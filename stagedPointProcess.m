clear

%% load data and import functions
addpath .\lib\generateSpikes
addpath .\lib\stagedPointProcess

load('input.mat')
load('output.mat')
spikeTrainX = input{1};
spikeTrainY = outputY{1,1};
lambdaYTrain = outputLambda{1,1};
[Nx, K] = size(spikeTrainX);

spikeTrainXvalidate = input{2};
spikeTrainYvalidate = outputY{1,2};
lambdaYValidate = outputLambda{1,2};

spikeTrainXtest = input{3};
spikeTrainYtest = outputY{1,3};
lambdaYTest = outputLambda{1,3};

%% get hyperparams
[H, Nz, xi1, xi2, mu, threshold, iterationThres] = hyperParams();

%% initialize the params
% [w, w0, theta, theta0, W] = initialParams(H, Nx, Nz, xi1, xi2);
load('linearW2.mat')
maxIterations = 100;

%% initialize histories
LHistory = -1000 * ones(1, maxIterations);
Lpre = Inf; % initialize Lpre as Inf
overIterations = 0;

%% Train the model
[lambdaYTrainPredict, spikeTrainYpredict, lambdaZTrain] = predict(H, K, spikeTrainX, w, w0, theta, theta0);
for iteration=1:maxIterations
    % validate
    [lambdaYTrainPredictValidate, spikeTrainYpredictValidate, ~] = predict(H, length(spikeTrainXvalidate), spikeTrainXvalidate, w, w0, theta, theta0);
    [Lpre, overIterations, LHistory] = evaluate(spikeTrainYvalidate, lambdaYTrainPredictValidate, LHistory, iteration, Lpre, overIterations, threshold, H, length(spikeTrainXvalidate));
    if (overIterations > iterationThres)
        break;
    end
    plotData(spikeTrainYvalidate, lambdaYValidate, spikeTrainYpredictValidate, lambdaYTrainPredictValidate, LHistory, W)
    % update params
    [w, w0, theta, theta0, W] = update(spikeTrainY, lambdaYTrainPredict, lambdaZTrain, spikeTrainX, mu, theta, W, K, H);
    [lambdaYTrainPredict, spikeTrainYpredict, lambdaZTrain] = predict(H, K, spikeTrainX, w, w0, theta, theta0);
end

%% Test
[lambdaYTrainPredictTest, spikeTrainYpredicTest, ~] = predict(H, length(spikeTrainXtest), spikeTrainXtest, w, w0, theta, theta0);
plotData(spikeTrainYtest, lambdaYTest, spikeTrainYpredicTest, lambdaYTrainPredictTest, [], [])

% save('linearW.mat', 'W', 'w', 'w0', 'theta', 'theta0')

%% calculate DBR