clear

%% load data and import functions
path(pathdef)
addpath .\lib\GLM
addpath .\lib\utils

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
[H, Wh, xi, threshold, iterationThres, maxIterations, alpha] = hyperParams();

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
W = initialParams(H, Nx, xi);

%% history variables
Whistory = zeros(Wh, length(W));
LHistory = zeros(1, maxIterations);
L = -Inf; % initialize Lpre as -Inf
overIterations = 0;

%% Train the model
for iteration=1:maxIterations
  % update params
  [lambdaYTrainPredict, spikeTrainYpredict] = model(spikeTrainX, W);
  W = update(spikeTrainY(H:K), lambdaYTrainPredict(H:K), Xhat, W, alpha);
  Whistory = [Whistory(2:Wh, :); W];

  normW = alpha * 0.5 * norm(W, 2)^2;
  % validate
  [lambdaYTrainPredictValidate, spikeTrainYpredictValidate] = model(spikeTrainXvalidate, W);
  [L, overIterations] = evaluate(spikeTrainYvalidate, lambdaYTrainPredictValidate, L, overIterations, threshold, normW);
  LHistory(iteration:length(LHistory)) = L; % record L
  if (overIterations > iterationThres)
    break;
  end
  plotData(spikeTrainYvalidate, lambdaYValidate, spikeTrainYpredictValidate, lambdaYTrainPredictValidate, LHistory, W)
end

%% test
[lambdaYTrainPredictTest, spikeTrainYpredicTest] = model(spikeTrainXtest, W);
plotData(spikeTrainYtest, lambdaYTest, spikeTrainYpredicTest, lambdaYTrainPredictTest, [], [])