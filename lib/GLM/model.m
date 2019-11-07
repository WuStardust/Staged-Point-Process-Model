function [lambdaYpredict, spikeYpredict] = model(spikeTrainX, W)
%model - GLM model
%
% Syntax: [lambdaYpredict, spikeYpredict] = model(spikeX, w)
%
% Calculate GLM predict output

  [Nx, ~] = size(spikeTrainX);
  H = (length(W) - 1) / Nx;

  w = flipud(reshape(W(1:Nx*H), Nx, H));
  w0 = W(Nx*H+1);

  lambdaYpredict = [zeros(1, H-1), sigmaFunc(conv2(spikeTrainX, w, 'valid') + w0)];
  spikeYpredict = lambda2Spike(lambdaYpredict);
end
