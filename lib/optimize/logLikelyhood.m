function L = logLikelyhood(trainSpikeY, lambdaYpredict)
    L = sum(trainSpikeY .* log(lambdaYpredict) + (1 - trainSpikeY) .* log(1 - lambdaYpredict));
end
