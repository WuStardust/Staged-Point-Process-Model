function [w, w0, theta, theta0, W] = update(spikeTrainY, lambdaYTrainPredict, lambdaZTrain, spikeTrainX, mu, theta, W, K, H)
  [Nx, ~] = size(spikeTrainX);
  [Nz, ~] = size(lambdaZTrain);

  for m = 1:length(W)
     Ghistory = zeros(1, 10);
     for i = 1:10
  ww0 = reshape(W(1:(Nx*H+1) * Nz), Nx*H+1, Nz);
  w = reshape(ww0(1:Nx*H, :), Nx, H, Nz);
  w0 = ww0(Nx*H+1, :);
  theta = W(Nx * H * Nz + Nz + 1:Nx * H * Nz + Nz + Nz);
  theta0 = W(Nx * H * Nz + Nz + Nz + 1);
  [lambdaYTrainPredict, ~, lambdaZTrain] = predict(H, K, spikeTrainX, w, w0, theta, theta0);
  G = gradient(spikeTrainY(H:K), lambdaYTrainPredict(H:K), lambdaZTrain(:, H:K), spikeTrainX(:, 1:K), theta, K, H); % get Gradient
  He = hessian(spikeTrainY(H:K), lambdaYTrainPredict(H:K), lambdaZTrain(:, H:K), spikeTrainX(:, 1:K), theta, K, H); % get Hessian
  Ghistory(i) = G(m);
  % update params
  W = W + 0.001 * He(m, :);% / ( - He + mu * eye(size(He)));
     end
     delta = Ghistory(2:10) - Ghistory(1:9);
     disp([num2str(m), 'xxxxxx', num2str(delta)])
  end
end