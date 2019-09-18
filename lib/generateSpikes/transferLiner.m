% generate output with liner model
function [lambdaY, spikeTrain] = transferLiner(lambdaX1, lambdaX2)
    lambdaY = 0.83 * lambdaX1 + 0.83 * lambdaX2 - 0.25;
    lambdaY = (lambdaY > 0) .* lambdaY;
    spikeTrain = lambda2Spike(lambdaY);
end
