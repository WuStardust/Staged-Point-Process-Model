function [L, overIterations, LHistory, isIncrease] = evaluate(spikeTrainY, lambdaYTrainPredict, LHistory, iteration, Lpre, overIterations, threshold, H, K, normW)
  L = logLikelyhood(spikeTrainY(H:K), lambdaYTrainPredict(H:K), normW); % get L
  LHistory(iteration:length(LHistory)) = L; % record L

  isIncrease = L > Lpre;
  err = abs(L - Lpre);
  if (err < threshold)
      overIterations = overIterations + 1;
  else
      overIterations = 0;
  end
end