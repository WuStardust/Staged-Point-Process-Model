function [lambdaYpredict, spikeYpredict] = model(spikeTrainX, W)
%model - GLM model
%
% Syntax: [lambdaYpredict, spikeYpredict] = model(spikeX, w)
%
% Calculate GLM predict output

  [Nx, K] = size(spikeTrainX);
  H = (length(W) - 1) / Nx;

  Xhis = zeros(Nx, H+1, K);
  for k=H:K
    Xhis(:, :, k) = [spikeTrainX(:, k-H+1:k), ones(Nx, 1)];
  end

  w = [fliplr(reshape(W(1:Nx*H), Nx, H)), W(Nx*H+1)/Nx * ones(Nx, 1)];

  lambdaYpredict = sigmaFunc(squeeze(sum(sum(Xhis .* w)))');
  spikeYpredict = lambda2Spike(lambdaYpredict);
end
