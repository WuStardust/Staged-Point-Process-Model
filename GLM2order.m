clear

%% load data and import functions
path(pathdef)
addpath .\lib\GLM2order
addpath .\lib\utils

load('inputS.mat')
load('outputS.mat')

M = containers.Map({'linear', 'quadratic', 'sin'}, [1, 2, 3]);
transType = M('sin');

spikeTrainX = input{1};
spikeTrainY = outputY{transType,1};
lambdaYTrain = outputLambda{transType,1};

spikeTrainXvalidate = input{2};
spikeTrainYvalidate = outputY{transType,2};
lambdaYValidate = outputLambda{transType,2};

spikeTrainXtest = input{3};
spikeTrainYtest = outputY{transType,3};
lambdaYTest = outputLambda{transType,3};

%% get hyperparams
[H, Wh, xi, threshold, iterationThres, maxIterations, alpha] = hyperParams();

%% get Xhat, XcovHat
Xall = getXall(spikeTrainX, H);
XallValidate = getXall(spikeTrainXvalidate, H);
XallTest = getXall(spikeTrainXtest, H);

%% initialize the params
[Nx, K] = size(spikeTrainX);
W = initialParams(H, Nx, xi);

%% history variables
Whistory = zeros(Wh, length(W));
LHistory = zeros(1, maxIterations);
L = -Inf; % initialize Lpre as -Inf
overIterations = 0;

%% Train the model
for iteration=1:maxIterations
  % update params
  [lambdaYTrainPredict, spikeTrainYpredict] = model(Xall, W, H);
  W = update(spikeTrainY(H:K), lambdaYTrainPredict(H:K), Xall, W, alpha);
  Whistory = [Whistory(2:Wh, :); W];

  normW = alpha * norm(W, 1);
  % validate
  [lambdaYTrainPredictValidate, spikeTrainYpredictValidate] = model(XallValidate, W, H);
  [L, overIterations] = evaluate(spikeTrainYvalidate, lambdaYTrainPredictValidate, L, overIterations, threshold, normW);
  LHistory(iteration:length(LHistory)) = L; % record L
  if (overIterations > iterationThres)
    break;
  end
  plotData(spikeTrainYvalidate, lambdaYValidate, spikeTrainYpredictValidate, lambdaYTrainPredictValidate, LHistory, W)
end

%% test
[lambdaYTrainPredictTest, spikeTrainYpredicTest] = model(XallTest, W, H);
plotData(spikeTrainYtest, lambdaYTest, spikeTrainYpredicTest, lambdaYTrainPredictTest, LHistory, W)