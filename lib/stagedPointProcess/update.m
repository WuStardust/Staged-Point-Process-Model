function [w, w0, theta, theta0, W] = update(spikeTrainY, lambdaYTrainPredict, lambdaZTrain, Xhat, mu, theta, W, Nx, H, normW, alpha)
  [Nz, ~] = size(lambdaZTrain);

  G = gradient(spikeTrainY, lambdaYTrainPredict, lambdaZTrain, Xhat, theta, Nx, H); % get Gradient
  He = hessian(spikeTrainY, lambdaYTrainPredict, lambdaZTrain, Xhat, theta, Nx, H); % get Hessian

  % update params
  W = W + (G - alpha * W/normW) / ( - He + (mu + alpha/normW) * eye(size(He)));
  ww0 = reshape(W(1:(Nx*H+1) * Nz), Nx*H+1, Nz);
  w = reshape(ww0(1:Nx*H, :), Nx, H, Nz);
  w0 = ww0(Nx*H+1, :);
  theta = W(Nx * H * Nz + Nz + 1:Nx * H * Nz + Nz + Nz);
  theta0 = W(Nx * H * Nz + Nz + Nz + 1);
end