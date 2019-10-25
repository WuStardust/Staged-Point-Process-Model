function [Lpre, overIterations, LHistory] = evaluate(spikeTrainY, lambdaYTrainPredict, LHistory, iteration, Lpre, overIterations, threshold, H, K, normW, alpha)
  L = logLikelyhood(spikeTrainY(H:K), lambdaYTrainPredict(H:K), normW, alpha); % get L
  LHistory(iteration:length(LHistory)) = L; % record L

  err = abs(L - Lpre);
  if (err < threshold)
      overIterations = overIterations + 1;
  else
      overIterations = 0;
  end
  Lpre = L;
end