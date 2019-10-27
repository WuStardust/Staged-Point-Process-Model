function Wnew = update(spikeTrainY, lambdaYPredict, Xhat, Wold, alpha)
  G = (spikeTrainY - lambdaYPredict) * Xhat' - alpha * Wold;
  He = Xhat .* (lambdaYPredict .* (1 - lambdaYPredict)) * Xhat' + alpha * ones(length(Wold));

  Wnew = Wold + G / He;
end
