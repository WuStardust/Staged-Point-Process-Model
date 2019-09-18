function [lambdaYpredict, spikeYpredict, lambdaZ] = model(spikeX, w, w0, theta, theta0)
    lambdaZ = firstLayer(spikeX, w, w0);
    lambdaYpredict = secondLayer(lambdaZ, theta, theta0);
    spikeYpredict = lambda2Spike(lambdaYpredict);
end
