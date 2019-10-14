function [w, w0, theta, theta0, W] = update(spikeTrainY, lambdaYTrainPredict, lambdaZTrain, spikeTrainX, mu, theta, W, K, H)
  [Nx, ~] = size(spikeTrainX);
  [Nz, ~] = size(lambdaZTrain);

  G = gradient(spikeTrainY(H:K), lambdaYTrainPredict(H:K), lambdaZTrain(:, H:K), spikeTrainX(:, 1:K), theta, K, H); % get Gradient
  He = hessian(spikeTrainY(H:K), lambdaYTrainPredict(H:K), lambdaZTrain(:, H:K), spikeTrainX(:, 1:K), theta, K, H); % get Hessian

  % figure(3); subplot(2, 1, 1); plot(G)
  % figure(3); subplot(2, 1, 2); colormap([1 1 0; 1 0 0; 1 0 1; 0 0 1; 0 1 0]); mesh(1:length(He), 1:length(He), He)

  % update params
  W = W + G / (He + mu * eye(size(He)));
  w = reshape(W(1:Nx * H * Nz), Nx, H, Nz);
  w0 = W(Nx * H * Nz + 1: Nx * H * Nz + Nz);
  theta = W(Nx * H * Nz + Nz + 1:Nx * H * Nz + Nz + Nz);
  theta0 = W(Nx * H * Nz + Nz + Nz + 1);
end