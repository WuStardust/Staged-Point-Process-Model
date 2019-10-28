function Wnew = update(spikeTrainY, lambdaYPredict, Xhat, Wold, alpha)
  G = (spikeTrainY - lambdaYPredict) * Xhat' - alpha * abs(Wold) ./ Wold;
  He = Xhat .* (lambdaYPredict .* (1 - lambdaYPredict)) * Xhat';

  Wnew = Wold + G / He;
end
