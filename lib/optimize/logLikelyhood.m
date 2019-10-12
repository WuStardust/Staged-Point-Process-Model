function L = logLikelyhood(spikeTrainY, lambdaYTrainPredict)
    lambdaYTrainPredict = lambdaYTrainPredict - ...,
        ((1 - lambdaYTrainPredict) < 1e-8) * 1e-8 + ...,
        (lambdaYTrainPredict < 1e-8) * 1e-8;
    L = spikeTrainY * log(lambdaYTrainPredict') + (1 - spikeTrainY) * log(1 - lambdaYTrainPredict');
end
