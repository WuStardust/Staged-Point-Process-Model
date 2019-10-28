function [L, overIterations] = evaluate(spikeTrainY, lambdaYTrainPredict, Lpre, overIterations, threshold, normW)
  L = logLikelyhood(spikeTrainY, lambdaYTrainPredict, normW); % get L

  err = abs(L - Lpre);
  if (err < threshold)
    overIterations = overIterations + 1;
  else
    overIterations = 0;
  end
end
