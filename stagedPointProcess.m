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
[H, Nz, xi1, xi2, mu, threshold, iterationThres, alpha] = hyperParams();

%% get Xhat
Xhat = zeros(Nx * H + 1, K - H + 1); % todo
for h=1:H
    for i=1:Nx
        Xhat(Nx * (h - 1) + i, :) = spikeTrainX(i, H-h+1:K-h+1);
    end
end
Xhat(Nx * H + 1, :) = ones(1, K - H + 1);
Xhat = sparse(Xhat);

%% initialize the params
[w, w0, theta, theta0, W] = initialParams(H, Nx, Nz, xi1, xi2);
% load('linearW2.mat')
maxIterations = 100;

%% initialize histories
LHistory = ones(1, maxIterations);
Lpre = Inf; % initialize Lpre as Inf
overIterations = 0;

%% Train the model
[lambdaYTrainPredict, spikeTrainYpredict, lambdaZTrain] = predict(H, K, spikeTrainX, w, w0, theta, theta0);
for iteration=1:maxIterations
    normW = norm(W, 2);
    % validate
    [lambdaYTrainPredictValidate, spikeTrainYpredictValidate, ~] = predict(H, length(spikeTrainXvalidate), spikeTrainXvalidate, w, w0, theta, theta0);
    [Lpre, overIterations, LHistory] = evaluate(spikeTrainYvalidate, lambdaYTrainPredictValidate, LHistory, iteration, Lpre, overIterations, threshold, H, length(spikeTrainXvalidate), normW, alpha);
    if (overIterations > iterationThres)
        break;
    end
    plotData(spikeTrainYvalidate, lambdaYValidate, spikeTrainYpredictValidate, lambdaYTrainPredictValidate, LHistory, W)
    % update params
    [w, w0, theta, theta0, W] = update(spikeTrainY(H:K), lambdaYTrainPredict(H:K), lambdaZTrain(:, H:K), Xhat, mu, theta, W, Nx, H, normW, alpha);
    [lambdaYTrainPredict, spikeTrainYpredict, lambdaZTrain] = predict(H, K, spikeTrainX, w, w0, theta, theta0);
end

%% Test
[lambdaYTrainPredictTest, spikeTrainYpredicTest, ~] = predict(H, length(spikeTrainXtest), spikeTrainXtest, w, w0, theta, theta0);
plotData(spikeTrainYtest, lambdaYTest, spikeTrainYpredicTest, lambdaYTrainPredictTest, [], [])

% save('linearW.mat', 'W', 'w', 'w0', 'theta', 'theta0')

%% calculate DBR