function He = hessian(spikeTrainY, lambdaYTrainPredict, lambdaZTrain, Xhat, theta)
    [Nz, ~] = size(lambdaZTrain);
    [XhatN, trainL] = size(Xhat);

    lambdaYTrainPredictProduct = (1 - lambdaYTrainPredict) .* lambdaYTrainPredict;

    Hetheta2 = - [lambdaZTrain; ones(1, length(lambdaZTrain))] * spdiags(lambdaYTrainPredictProduct', 0, trainL, trainL) * [lambdaZTrain; ones(1, length(lambdaZTrain))]';

    Hew2 = zeros(Nz * XhatN);
    Hewtheta = zeros(Nz + 1, Nz * XhatN);

    LambdaZProduct = lambdaZTrain .* (1 - lambdaZTrain);
    thetaLambdaZProduct = theta' .* LambdaZProduct;
    thetaYZProduct = lambdaYTrainPredictProduct .* thetaLambdaZProduct;
    dSpikeLambdaY = spikeTrainY - lambdaYTrainPredict;

    bias = thetaLambdaZProduct .* dSpikeLambdaY .* (1 - 2 * lambdaZTrain);
    wthetaBias = dSpikeLambdaY .* LambdaZProduct;
    biasM = eye(Nz);
    for m=1:Nz
        diagV = (- thetaYZProduct(m, :) .* thetaLambdaZProduct + biasM(:, m) .* bias)';
        for n=1:Nz
            Hew2((m-1)*XhatN+1:m*XhatN, (n-1)*XhatN+1:n*XhatN) = Xhat * spdiags(diagV(:, n), 0, trainL, trainL) * Xhat';
        end
        Hewtheta(1:Nz, XhatN*(m-1)+1:XhatN*m) = (- thetaYZProduct(m, :) .* lambdaZTrain + biasM(:, m) .* wthetaBias) * Xhat';
    end
    Hewtheta(Nz+1, :) = reshape((- thetaYZProduct * Xhat')', 1, Nz * XhatN);

    He = [Hew2, Hewtheta'; Hewtheta, Hetheta2];
end
