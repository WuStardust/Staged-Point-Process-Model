function L = logLikelyhood(trainSpikeY, lambdaYpredict)
    L = trainSpikeY * log(lambdaYpredict') + (1 - trainSpikeY) * log(1 - lambdaYpredict');
end
