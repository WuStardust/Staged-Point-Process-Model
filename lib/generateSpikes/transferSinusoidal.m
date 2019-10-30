% generate output with sinusoidal model
function [lambdaY, spikeTrain, lambdaYs, spikeTrainS] = transferSinusoidal(lambdaX1, lambdaX2)
    lambdaY = 0.25 * sin(15.71 * lambdaX1 + 15.71 * lambdaX2 + 3.14) + 0.25;
    lambdaY = (lambdaY > 0) .* lambdaY;
    spikeTrain = lambda2Spike(lambdaY);

    lambdaYs = 0.25 * sin(15.71 * lambdaX1 - 1.57) + 0.25;
    lambdaYs = (lambdaYs > 0) .* lambdaYs;
    spikeTrainS = lambda2Spike(lambdaYs);
end
