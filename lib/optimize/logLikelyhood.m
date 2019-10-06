function L = logLikelyhood(spikeTrainY, lambdaYTrainPredict)
    L = spikeTrainY * log(lambdaYTrainPredict') + (1 - spikeTrainY) * log(1 - lambdaYTrainPredict');
end
