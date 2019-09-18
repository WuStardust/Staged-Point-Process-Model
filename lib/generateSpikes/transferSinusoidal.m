% generate output with sinusoidal model
function [lambdaY, spikeTrain] = transferSinusoidal(lambdaX1, lambdaX2)
    lambdaY = 0.25 * sin(15.71 * lambdaX1 + 15.71 * lambdaX2 + 3.14) + 0.25;
    lambdaY = (lambdaY > 0) .* lambdaY;
    spikeTrain = lambda2Spike(lambdaY);
end
