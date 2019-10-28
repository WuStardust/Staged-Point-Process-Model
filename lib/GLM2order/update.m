function Wnew = update(spikeTrainY, lambdaYPredict, Xall, Wold, alpha)
  G = (spikeTrainY - lambdaYPredict) * Xall' - alpha * abs(Wold) ./ Wold;
  He = Xall .* (lambdaYPredict .* (1 - lambdaYPredict)) * Xall';

  Wnew = Wold + G / He;
end
