function [w, w0, theta, theta0, W] = update(spikeTrainY, lambdaYTrainPredict, lambdaZTrain, spikeTrainX, mu, theta, W, K, H)
  [Nx, ~] = size(spikeTrainX);
  [Nz, ~] = size(lambdaZTrain);

  G = gradient(spikeTrainY(H:K), lambdaYTrainPredict(H:K), lambdaZTrain(:, H:K), spikeTrainX(:, 1:K), theta, K, H); % get Gradient
  He = hessian(spikeTrainY(H:K), lambdaYTrainPredict(H:K), lambdaZTrain(:, H:K), spikeTrainX(:, 1:K), theta, K, H); % get Hessian

  % update params
  W = W + G / ( - He + mu * eye(size(He)));
  ww0 = reshape(W(1:(Nx*H+1) * Nz), Nx*H+1, Nz);
  w = reshape(ww0(1:Nx*H, :), Nx, H, Nz);
  w0 = ww0(Nx*H+1, :);
  theta = W(Nx * H * Nz + Nz + 1:Nx * H * Nz + Nz + Nz);
  theta0 = W(Nx * H * Nz + Nz + Nz + 1);
end