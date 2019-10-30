function [W, G, He] = update(spikeTrainY, lambdaYTrainPredict, lambdaZTrain, Xhat, mu, W, Nx, H, alpha)
  [Nz, ~] = size(lambdaZTrain);
  theta = W((Nx*H+1)*Nz+1:(Nx*H+1)*Nz+Nz);

  G = gradient(spikeTrainY, lambdaYTrainPredict, lambdaZTrain, Xhat, theta, Nx, H); % get Gradient
  He = hessian(spikeTrainY, lambdaYTrainPredict, lambdaZTrain, Xhat, theta, Nx, H); % get Hessian

  % update params
  a = zeros(1, 13);
  a(11) = 0.0001;
  W = W + (G - alpha * W) / ( - He + (mu + alpha) * eye(size(He)));
end