function [w, w0, theta, theta0, W] = update(spikeTrainY, lambdaYTrainPredict, lambdaZTrain, Xhat, mu, theta, W, Nx, H, alpha)
  [Nz, ~] = size(lambdaZTrain);

  % W0 = W;
  % for m = 1:7
  %     a = eye(length(W));
  %    for n = m:7
  %    Ghistory = zeros(1, 10);
  %    W = W0;
  %    for i = 1:10
  G = gradient(spikeTrainY, lambdaYTrainPredict, lambdaZTrain, Xhat, theta, Nx, H); % get Gradient
  He = hessian(spikeTrainY, lambdaYTrainPredict, lambdaZTrain, Xhat, theta, Nx, H); % get Hessian

  % update params
  W = W + (G - alpha * W) / ( - He + (mu + alpha) * eye(size(He)));
  ww0 = reshape(W(1:(Nx*H+1) * Nz), Nx*H+1, Nz);
  w = reshape(ww0(1:Nx*H, :), Nx, H, Nz);
  w0 = ww0(Nx*H+1, :);
  theta = W(Nx * H * Nz + Nz + 1:Nx * H * Nz + Nz + Nz);
  theta0 = W(Nx * H * Nz + Nz + Nz + 1);
  % [lambdaYTrainPredict, ~, lambdaZTrain] = predict(H, length(spikeTrainX), spikeTrainX, w, w0, theta, theta0);
  % G = gradient(spikeTrainY, lambdaYTrainPredict(H:length(lambdaYTrainPredict)), lambdaZTrain(:, H:length(lambdaYTrainPredict)), Xhat, theta, Nx, H);% - alpha * W/normW; % get Gradient
  % He = hessian(spikeTrainY, lambdaYTrainPredict(H:length(lambdaYTrainPredict)), lambdaZTrain(:, H:length(lambdaYTrainPredict)), Xhat, theta, Nx, H); % get Hessian
  % %He = He + alpha/normW^3 * (W'*W) - alpha/normW * eye(size(He));
  % Ghistory(i) = G(m);
  % % update params
  % W = (1e9 * W + He(m, :) .* a(n, :)) / 1e9;% / ( - He + mu * eye(size(He)));
  %    end
  %    delta = (Ghistory(2:10) - Ghistory(1:9)) > 0;
  %    if (min(delta) == 0)
  %        disp([num2str(m), num2str(n), ' xxxxxx ', num2str(delta)])
  %    end
  %    end
  %    disp(num2str(m))
  % end
end