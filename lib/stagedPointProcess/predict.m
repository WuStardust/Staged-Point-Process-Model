function [lambdaYTrainPredict, spikeTrainYpredict, lambdaZTrain] = predict(H, K, spikeTrainX, w, w0, theta, theta0)
  lambdaYTrainPredict = zeros(1, K);
  spikeTrainYpredict = zeros(1, K);
  lambdaZTrain = zeros(length(w0), K);

  for k=H:K % K is the number of time bins over the whole observation interval
    [lambdaYpredict, spikeYpredict, lambdaZ] = model(spikeTrainX(:, k-H+1:k), w, w0, theta, theta0); % apply the model
    % record the history
    lambdaYTrainPredict(k) = lambdaYpredict;
    spikeTrainYpredict(k) = spikeYpredict;
    lambdaZTrain(:, k) = lambdaZ;
  end
end