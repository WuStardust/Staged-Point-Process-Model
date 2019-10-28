function [lambdaYpredict, spikeYpredict] = model(Xall, W, H)
%model - GLM model
%
% Syntax: [lambdaYpredict, spikeYpredict] = model(spikeX, w)
%
% Calculate GLM predict output

  lambdaYpredict = sigmaFunc([zeros(1, H-1), W * Xall]);
  spikeYpredict = lambda2Spike(lambdaYpredict);
end
