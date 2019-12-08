function G = gradient(spikeTrainY, lambdaYTrainPredict, lambdaZTrain, Xhat, theta)
    [Nz, ~] = size(lambdaZTrain);
    [XhatN, trainL] = size(Xhat);

    dSpikeLambdaY = spikeTrainY - lambdaYTrainPredict;
    dSpikeLambdaYZProduct = dSpikeLambdaY .* lambdaZTrain .* (1 - lambdaZTrain);
    thetaDProdcut = (theta' .* dSpikeLambdaYZProduct)';

    Gtheta = dSpikeLambdaY * [lambdaZTrain', ones(trainL, 1)];

    Gw = zeros(1, XhatN*Nz);
    for h=1:Nz
        Gw((h-1)*XhatN+1:h*XhatN) = (Xhat * thetaDProdcut(:, h))';
    end

    G = [Gw, Gtheta];
end
