function [W, bad] = update(spikeTrainY, lambdaYTrainPredict, lambdaZTrain, Xhat, mu, W, Nx, H, alpha)
  [Nz, ~] = size(lambdaZTrain);
  theta = W((Nx*H+1)*Nz+1:(Nx*H+1)*Nz+Nz);

  G = gradient(spikeTrainY, lambdaYTrainPredict, lambdaZTrain, Xhat, theta, Nx, H); % get Gradient
  He = hessian(spikeTrainY, lambdaYTrainPredict, lambdaZTrain, Xhat, theta, Nx, H); % get Hessian

  % update params
  He2 = - He + (mu + alpha) * eye(size(He));
  bad = 0;
  if ((rcond(He2) < 1e-15) + (isnan(He2)))
      bad = 1;
      return;
  end
  W = W + (G - alpha * W) / He2;
end