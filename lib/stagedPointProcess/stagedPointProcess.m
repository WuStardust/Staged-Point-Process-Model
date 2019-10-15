function [spikeTrainYpredict, lambdaYTrainPredict, LHistory, W] = stagedPointProcess(spikeTrainX, spikeTrainY, Nx, K)
%% get hyperparams
[H, Nz, xi1, xi2, mu, threshold, iterationThres] = hyperParams();

%% initialize the params
[w, w0, theta, theta0, W] = initialParams(H, Nx, Nz, xi1, xi2);
maxIterations = 30;

%% initialize histories
LHistory = zeros(1, maxIterations);
Lpre = Inf; % initialize Lpre as Inf
overIterations = 0;

%% Train the model
for iteration=1:maxIterations
    if (overIterations > iterationThres)
        break;
    end
    [lambdaYTrainPredict, spikeTrainYpredict, lambdaZTrain] = predict(H, K, spikeTrainX, w, w0, theta, theta0);

    [Lpre, overIterations, LHistory] = evaluate(spikeTrainY, lambdaYTrainPredict, LHistory, iteration, Lpre, overIterations, threshold, H, K);

    plotData(spikeTrainY, spikeTrainY, spikeTrainYpredict, lambdaYTrainPredict, LHistory, W)

    [w, w0, theta, theta0, W] = update(spikeTrainY, lambdaYTrainPredict, lambdaZTrain, spikeTrainX, mu, theta, W, K, H);
end

end