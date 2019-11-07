function [Wnew, isSingluar] = update(spikeTrainY, lambdaYPredict, Xhat, Wold, alpha)
  G = (spikeTrainY - lambdaYPredict) * Xhat' - alpha * abs(Wold) ./ Wold;
  He = Xhat .* (lambdaYPredict .* (1 - lambdaYPredict)) * Xhat';

  if (rcond(full(He)) < 1e-10)
    Wnew = 0;
    isSingluar = 1;
    return
  end
  isSingluar = 0;
  Wnew = Wold + G / He;
end
