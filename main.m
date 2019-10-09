clear

%% load data and import functions
addpath .\lib\generateSpikes
addpath .\lib\stagedPointProcess
addpath .\lib\optimize
load('trainSet.mat')
load('testSet.mat')

spikeTrainX = trainSet{1,1}; % get train input
spikeTrainY = trainSet{1,4}; % get train output(GT) of linear
lambdaYTrain = trainSet{1,7};

[Nx, K] = size(trainSet{1,1});
% set hyperparams
H = 50; % temporal history
Nz = 15;
xi1 = 1;
xi2 = 5;
mu = 0.01;
threshold = 1e-3;
% v = 1e-2;
iterationThres = 7;

%% GLM models
% need todo

%% 2nd order GLM
% need todo

%% staged point process
% initialize the params
w = xi2 / sqrt(H * Nx) * (2 * rand(Nx, H, Nz) - 1);
w0 = xi2 / sqrt(H * Nx) * (2 * rand(1, Nz) - 1);
theta = xi1 / sqrt(Nz) * (2 * rand(1, Nz) - 1);
theta0 = xi1 / sqrt(Nz) * (2 * rand() - 1);

% initialize histories
lambdaYTrainPredict = zeros(1, K);
spikeTrainYpredict = zeros(1, K);
lambdaZTrain = zeros(Nz, K);
LHistory = zeros(1, K);

Lpre = Inf; % initialize Lpre as Inf
overIterations = 0;
% use gradient ascent to maxmium the L
for K=H:length(spikeTrainY) % K is the number of time bins over the whole observation interval
    [lambdaYpredict, spikeYpredict, lambdaZ] = model(spikeTrainX(:, K-H+1:K), w, w0, theta, theta0); % apply the model
    % record the history
    lambdaYTrainPredict(K) = lambdaYpredict;
    spikeTrainYpredict(K) = spikeYpredict;
    lambdaZTrain(:, K) = lambdaZ;


    L = logLikelyhood(spikeTrainY(H:K), lambdaYTrainPredict(H:K)); % get L
    if (isnan(L))
       msg = 'NaN!'
       break
    end
    LHistory(K) = L; % record L

%     history = [history, L];
%     figure(3)
%     plot(history)

    err = abs(L - Lpre);
    if (err < threshold)
        overIterations = overIterations + 1;
    else
        overIterations = 0;
    end
    Lpre = L;

    G = gradient(spikeTrainY(H:K), lambdaYTrainPredict(H:K), lambdaZTrain(:, H:K), spikeTrainX(:, 1:K), theta, K, H); % get Gradient
    He = hessian(spikeTrainY(H:K), lambdaYTrainPredict(H:K), lambdaZTrain(:, H:K), spikeTrainX(:, 1:K), theta, K, H); % get Hessian

    % update params
    W = [reshape(w, 1, Nx * H * Nz), w0, theta, theta0];
    W = W + G / (He + mu * eye(size(He)));
    w = reshape(W(1:Nx * H * Nz), Nx, H, Nz);
    w0 = W(Nx * H * Nz + 1: Nx * H * Nz + Nz);
    theta = W(Nx * H * Nz + Nz + 1:Nx * H * Nz + Nz + Nz);
    theta0 = W(Nx * H * Nz + Nz + Nz + 1);
%     end
    figure(2)
    plot(LHistory)
%     if (isnan(L))
%        msg = 'NaN!'
%        break
%     end
    
    plotData(spikeTrainY, lambdaYTrain, spikeTrainYpredict, lambdaYTrainPredict)
end

% plotData(spikeTrainY, lambdaYTrain, spikeTrainYpredict, lambdaYTrainPredict)

output = {lambdaYTrainPredict, spikeTrainYpredict};
save output.mat output

%% Assessing Goodness-of-fit
% todo: calculate DBR with spikeYpredict
