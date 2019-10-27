clear

%% load data and import functions
addpath .\lib\generateSpikes
addpath .\lib\stagedPointProcess

load('input.mat')
load('output.mat')
spikeTrainX = input{1};
spikeTrainY = outputY{3,1};
lambdaYTrain = outputLambda{3,1};
[Nx, K] = size(spikeTrainX);

spikeTrainXvalidate = input{2};
spikeTrainYvalidate = outputY{3,2};
lambdaYValidate = outputLambda{3,2};

spikeTrainXtest = input{3};
spikeTrainYtest = outputY{3,3};
lambdaYTest = outputLambda{3,3};

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

%%
load GoodW.mat
% load Goodmu.mat
preTrainN = 12;
Whistory = zeros(preTrainN, Nx*H*Nz+Nz+Nz+1);
PreLhistory = zeros(1 ,preTrainN);
muHistory = zeros(1 ,preTrainN);
for pre=1:preTrainN
%% initialize the params
% [w, w0, theta, theta0, W] = initialParams(H, Nx, Nz, xi1, xi2);
W = GoodW(pre, :);
ww0 = reshape(W(1:(Nx*H+1) * Nz), Nx*H+1, Nz);
w = reshape(ww0(1:Nx*H, :), Nx, H, Nz);
w0 = ww0(Nx*H+1, :);
theta = W(Nx * H * Nz + Nz + 1:Nx * H * Nz + Nz + Nz);
theta0 = W(Nx * H * Nz + Nz + Nz + 1);
% mu = Goodmu(pre);
maxIterations = 1;

%% initialize histories
LHistory = zeros(1, maxIterations);
L = -Inf; % initialize Lpre as -Inf
overIterations = 0;

%% Train the model
[lambdaYTrainPredict, spikeTrainYpredict, lambdaZTrain] = predict(H, K, spikeTrainX, w, w0, theta, theta0);
for iteration=1:maxIterations
    normW = norm(W, 2);
    % validate
    [lambdaYTrainPredictValidate, spikeTrainYpredictValidate, ~] = predict(H, length(spikeTrainXvalidate), spikeTrainXvalidate, w, w0, theta, theta0);
    [L, overIterations, LHistory, isIncrease] = evaluate(spikeTrainYvalidate, lambdaYTrainPredictValidate, LHistory, iteration, L, overIterations, threshold, H, length(spikeTrainXvalidate), normW, alpha);
    if (overIterations > iterationThres)
        break;
    end
    plotData(spikeTrainYvalidate, lambdaYValidate, spikeTrainYpredictValidate, lambdaYTrainPredictValidate, LHistory, W)
    % update params
    if (isIncrease)
      mu = mu/10;
    else
      mu = 10*mu;
    end
    [w, w0, theta, theta0, W] = update(spikeTrainY(H:K), lambdaYTrainPredict(H:K), lambdaZTrain(:, H:K), Xhat, mu, theta, W, Nx, H, alpha);
    [lambdaYTrainPredict, spikeTrainYpredict, lambdaZTrain] = predict(H, K, spikeTrainX, w, w0, theta, theta0);
    fprintf('#')
    if (L < -2e4)
       break; 
    end
end
Whistory(pre, :) = W;
PreLhistory(pre) = L;
muHistory(pre) = mu;
fprintf('  pretrain %2d Completed.\n', pre);
%% Test
% [lambdaYTrainPredictTest, spikeTrainYpredicTest, ~] = predict(H, length(spikeTrainXtest), spikeTrainXtest, w, w0, theta, theta0);
% plotData(spikeTrainYtest, lambdaYTest, spikeTrainYpredicTest, lambdaYTrainPredictTest, [], [])

figure(fix((pre-1)/5) + 3)
subplot(5, 1, mod(pre-1, 5)+1)
t = 0:0.01:(length(lambdaYTrainPredictValidate) - 1) * 0.01;
plot(t, lambdaYTrainPredictValidate);
end
%% calculate DBR