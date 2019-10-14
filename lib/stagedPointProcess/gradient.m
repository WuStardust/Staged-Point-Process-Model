function G = gradient(spikeTrainY, lambdaYTrainPredict, lambdaZTrain, spikeTrainX, theta, K, H)
    [Nx, ~] = size(spikeTrainX);
    [Nz, ~] = size(lambdaZTrain);

    Gtheta = (spikeTrainY - lambdaYTrainPredict) * lambdaZTrain';

    Gtheta0 = sum(spikeTrainY - lambdaYTrainPredict);

    Gw = zeros(Nx, H, Nz);
    for h=1:H
        Gw(:, h, :) = spikeTrainX(:, H-h+1:K-h+1) * (theta' .* ((spikeTrainY - lambdaYTrainPredict) .* lambdaZTrain .* (1 - lambdaZTrain)))';
    end

    Gw0 = theta .* sum((spikeTrainY - lambdaYTrainPredict) .* lambdaZTrain .* (1 - lambdaZTrain), 2)';

    G = [reshape(Gw, 1, Nx * H * Nz), Gw0, Gtheta, Gtheta0];
end