% generate output with liner model
function [lambdaY, spikeTrain, lambdaYs, spikeTrainS] = transferLiner(lambdaX1, lambdaX2)
    lambdaY = 0.83 * lambdaX1 + 0.83 * lambdaX2 - 0.25;
    lambdaY = (lambdaY > 0) .* lambdaY;
    spikeTrain = lambda2Spike(lambdaY);

    lambdaYs = 0.83 * lambdaX1;
    lambdaYs = (lambdaYs > 0) .* lambdaYs;
    spikeTrainS = lambda2Spike(lambdaYs);
end
