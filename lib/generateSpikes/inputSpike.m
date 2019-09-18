% generate input spike by given params
function [lambdaX, spikeTrain] = inputSpike(alphaX, betaX, gammaX, deltaX, t, timeBin)
    lambdaX = alphaX * sin(betaX * t / timeBin + gammaX) + deltaX;
    % if lamdX < 0, then lamdX = 0
    lambdaX = (lambdaX > 0) .* lambdaX;
    spikeTrain = lambda2Spike(lambdaX);
end
