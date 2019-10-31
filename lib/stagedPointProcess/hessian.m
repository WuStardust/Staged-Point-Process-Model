function He = hessian(spikeTrainY, lambdaYTrainPredict, lambdaZTrain, Xhat, theta, Nx, H)
    [Nz, ~] = size(lambdaZTrain);

    lambdaYTrainPredictProduct = sparse((1 - lambdaYTrainPredict) .* lambdaYTrainPredict);

    Hetheta2 = - [
        lambdaZTrain * diag(lambdaYTrainPredictProduct) * lambdaZTrain', lambdaZTrain * lambdaYTrainPredictProduct'; 
        lambdaYTrainPredictProduct * lambdaZTrain', sum(lambdaYTrainPredictProduct)
    ];

    Hew2 = zeros(Nz * (Nx * H + 1));
    Hewtheta = zeros(Nz + 1, Nz * (Nx * H + 1));

    LambdaZProduct = sparse(lambdaZTrain .* (1 - lambdaZTrain));
    thetaLambdaZProduct = sparse(theta' .* LambdaZProduct);
    thetaYZProduct = sparse(lambdaYTrainPredictProduct .* thetaLambdaZProduct);
    dSpikeLambdaY = sparse(spikeTrainY - lambdaYTrainPredict);

    bias = sparse(thetaLambdaZProduct .* dSpikeLambdaY .* (1 - 2 * lambdaZTrain));
    wthetaBias = sparse(dSpikeLambdaY .* LambdaZProduct);
    biasM = eye(Nz);
    for m=1:Nz
        diagV = sparse(- thetaYZProduct(m, :) .* thetaLambdaZProduct + biasM(:, m) .* bias);
        for n=1:Nz
            Hew2((Nx * H + 1) * (m-1) + 1:(Nx * H + 1) * m, (Nx * H + 1) * (n-1) + 1:(Nx * H + 1) * n) = (Xhat .* diagV(n, :) * Xhat');
        end
        Hewtheta(1:Nz, (Nx*H+1)*(m-1)+1:(Nx*H+1)*m) = ((- thetaYZProduct(m, :) .* lambdaZTrain + biasM(:, m) .* wthetaBias) * Xhat');
    end
    Hewtheta(Nz+1, :) = reshape((- thetaYZProduct * Xhat')', 1, Nz * (Nx * H + 1));

    He = [Hew2, Hewtheta'; Hewtheta, Hetheta2];
end