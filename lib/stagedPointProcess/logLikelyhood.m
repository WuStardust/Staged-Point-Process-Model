function L = logLikelyhood(spikeTrainY, lambdaYTrainPredict, normW, alpha)
    lambdaYTrainPredict = lambdaYTrainPredict - ...,
        ((1 - lambdaYTrainPredict) < 1e-8) * 1e-8 + ...,
        (lambdaYTrainPredict < 1e-8) * 1e-8;
    L = spikeTrainY * log(lambdaYTrainPredict') + (1 - spikeTrainY) * log(1 - lambdaYTrainPredict') - alpha * 0.5 * normW^2;

    % if (isnan(L))
    %    error('Error: L is NaN!');
    % end
end
