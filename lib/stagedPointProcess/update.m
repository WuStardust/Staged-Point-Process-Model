function [w, w0, theta, theta0, W] = update(spikeTrainY, lambdaYTrainPredict, lambdaZTrain, spikeTrainX, mu, theta, W, K, H)
  [Nx, ~] = size(spikeTrainX);
  [Nz, ~] = size(lambdaZTrain);

  G = gradient(spikeTrainY(H:K), lambdaYTrainPredict(H:K), lambdaZTrain(:, H:K), spikeTrainX(:, 1:K), theta, K, H); % get Gradient
  He = hessian(spikeTrainY(H:K), lambdaYTrainPredict(H:K), lambdaZTrain(:, H:K), spikeTrainX(:, 1:K), theta, K, H); % get Hessian

%   figure(3); subplot(3, 1, 1); plot(G)
%   figure(3); subplot(3, 1, 2); colormap([1 1 0; 1 0 0; 1 0 1; 0 0 1; 0 1 0]); mesh(1:length(He), 1:length(He), He)
%   figure(3); subplot(3, 1, 3); plot(G / (He + mu * eye(size(He))))

  % update params
  W = W + G / (He + mu * eye(size(He)));
  ww0 = reshape(W(1:(Nx*H+1) * Nz), Nx*H+1, Nz);
  w = reshape(ww0(1:Nx*H, :), Nx, H, Nz);
  w0 = ww0(Nx*H+1, :);
  theta = W(Nx * H * Nz + Nz + 1:Nx * H * Nz + Nz + Nz);
  theta0 = W(Nx * H * Nz + Nz + Nz + 1);
end