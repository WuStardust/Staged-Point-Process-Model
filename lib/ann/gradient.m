function G = gradient(spikeTrainY, lambdaYTrainPredict, lambdaZTrain, Xhat, theta, Nx, H)
    [Nz, ~] = size(lambdaZTrain);

    dSpikeLambdaY = spikeTrainY - lambdaYTrainPredict;
    dSpikeLambdaYZProduct = dSpikeLambdaY .* lambdaZTrain .* (1 - lambdaZTrain);
    thetaDProdcut = (theta' .* dSpikeLambdaYZProduct)';

    Gtheta = dSpikeLambdaY * lambdaZTrain';

    Gtheta0 = sum(dSpikeLambdaY);

    Gw = zeros(Nx, H, Nz);
    for h=1:H
        Gw(:, h, :) = Xhat(Nx*(h-1)+1:Nx*h, :) * thetaDProdcut;
    end

    Gw0 = theta .* sum(dSpikeLambdaYZProduct, 2)';

    G = [reshape([reshape(Gw, Nx*H, Nz); Gw0], 1, (Nx*H+1)*Nz), Gtheta, Gtheta0];
end