function [Lpre, overIterations, LHistory] = evaluate(spikeTrainY, lambdaYTrainPredict, LHistory, iteration, Lpre, overIterations, threshold, H, K)
  L = logLikelyhood(spikeTrainY(H:K), lambdaYTrainPredict(H:K)); % get L
  LHistory(iteration) = L; % record L

  err = abs(L - Lpre);
  if (err < threshold)
      overIterations = overIterations + 1;
  else
      overIterations = 0;
  end
  Lpre = L;
end