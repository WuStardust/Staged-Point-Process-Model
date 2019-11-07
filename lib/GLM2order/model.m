function [lambdaYpredict, spikeYpredict] = model(Xall, W, H)
%model - GLM 2nd order model
%
% Syntax: [lambdaYpredict, spikeYpredict] = model(spikeX, w)
%
% Calculate GLM predict output

  lambdaYpredict = [zeros(1, H-1), sigmaFunc(W * Xall)];
  spikeYpredict = lambda2Spike(lambdaYpredict);
end
