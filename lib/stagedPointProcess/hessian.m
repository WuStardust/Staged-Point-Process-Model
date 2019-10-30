function He = hessian(spikeTrainY, lambdaYTrainPredict, lambdaZTrain, Xhat, theta, Nx, H)
    [Nz, ~] = size(lambdaZTrain);

    lambdaYTrainPredictProduct = sparse((10 - 10 * lambdaYTrainPredict) .* (10 * lambdaYTrainPredict));

    Hetheta2 = - 10 * [
        lambdaZTrain * diag(lambdaYTrainPredictProduct) * lambdaZTrain', lambdaZTrain * lambdaYTrainPredictProduct'; 
        lambdaYTrainPredictProduct * lambdaZTrain', sum(lambdaYTrainPredictProduct)
    ];

    Hew2 = zeros(Nz * (Nx * H + 1));
    Hewtheta = zeros(Nz + 1, Nz * (Nx * H + 1));

    LambdaZProduct = sparse((10 * lambdaZTrain) .* (10 - 10 * lambdaZTrain));
    thetaLambdaZProduct = sparse((10 * theta') .* LambdaZProduct);
    thetaYZProduct = sparse(lambdaYTrainPredictProduct .* thetaLambdaZProduct);
    dSpikeLambdaY = sparse(10 * spikeTrainY - 10 * lambdaYTrainPredict);

    bias = sparse(thetaLambdaZProduct .* dSpikeLambdaY .* (10 - 20 * lambdaZTrain));
    wthetaBias = sparse(dSpikeLambdaY .* LambdaZProduct);
    biasM = eye(Nz);
    for m=1:Nz
        diagV = sparse(- thetaYZProduct(m, :) .* thetaLambdaZProduct + 1e3 * biasM(:, m) .* bias);
        for n=1:Nz
            Hew2((Nx * H + 1) * (m-1) + 1:(Nx * H + 1) * m, (Nx * H + 1) * (n-1) + 1:(Nx * H + 1) * n) = (Xhat .* diagV(n, :) * Xhat') / 1e5;
        end
        Hewtheta(1:Nz, (Nx*H+1)*(m-1)+1:(Nx*H+1)*m) = ((- thetaYZProduct(m, :) .* (10 * lambdaZTrain) + 1e3 * biasM(:, m) .* wthetaBias) * Xhat') / 1e3;
    end
    Hewtheta(Nz+1, :) = reshape((- thetaYZProduct * Xhat')' / 1e2, 1, Nz * (Nx * H + 1));

    He = [Hew2, Hewtheta'; Hewtheta, Hetheta2] / 1e3;
end