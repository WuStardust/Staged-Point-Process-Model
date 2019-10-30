% generate output with quadratic model
function [lambdaY, spikeTrain, lambdaYs, spikeTrainS] = transferQuadratic(lambdaX1, lambdaX2)
    lambdaY = (-5.56 * (lambdaX1 .^2)) + (-5.56 * (lambdaX2 .^ 2)) + (-11.11 * (lambdaX1 .* lambdaX2)) + (6.67 * lambdaX1) + (6.67 * lambdaX2) - 1.50;
    lambdaY = (lambdaY > 0) .* lambdaY;
    spikeTrain = lambda2Spike(lambdaY);

    lambdaYs = (-5.56 * (lambdaX1 .^2)) + (3.33 * lambdaX1);
    lambdaYs = (lambdaYs > 0) .* lambdaYs;
    spikeTrainS = lambda2Spike(lambdaYs);
end
