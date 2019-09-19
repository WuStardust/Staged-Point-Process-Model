clear

%% load data and import functions
addpath .\lib\generateSpikes
addpath .\lib\stagedPointProcess
addpath .\lib\optimize
load('trainSet.mat')
load('testSet.mat')

trainSet{1,1} = trainSet{1,1}(:, 1:400);
trainSet{1,2} = trainSet{1,2}(1:400);

trainSpikeX = trainSet{1,1}; % get train input
trainSpikeY = trainSet{1,2}; % get train output(GT) of linear

[Nx, H] = size(trainSet{1,1});
Nz = 15;
err = 1;
threshold = 1e-3;
v = 1e-5;
iterationThres = 7;

%% GLM models
% need todo

%% 2nd order GLM
% need todo

%% staged point process
% initialize the params
w = 20 * (rand(Nx, H, Nz) - 0.5);
w0 = 20 * (rand(1, Nz) - 0.5);
theta = 20 * (rand(1, Nz) - 0.5);
theta0 = 0; % rand();

[lambdaYpredict, spikeYpredict, lambdaZ] = model(trainSpikeX, w, w0, theta, theta0); % apply the model
L = logLikelyhood(trainSpikeY, lambdaYpredict); % get L

% use gradient ascent to maxmium the L
% history = L;
iterationOverThres = 0;
while(iterationOverThres < iterationThres)
    G = gradient(trainSpikeY, lambdaYpredict, lambdaZ, trainSpikeX, theta); % get Gradient
%     HL = hessian(trainSpikeY, lambdaYpredict, lambdaZ, trainSpikeX, theta);

    % update params
    w = w + v * G.w;
    w0 = w0 + v * G.w0;
    theta = theta + v * G.theta;
    theta0 = theta0 + v * G.theta0;

    % calculat with new params
    Lpre = L;
    [lambdaYpredict, spikeYpredict, lambdaZ] = model(trainSpikeX, w, w0, theta, theta0);
    L = logLikelyhood(trainSpikeY, lambdaYpredict);
    err = abs(L - Lpre);
    
%     history = [history, L];
%     figure(2)
%     plot(history)
    
    if (err < threshold)
        iterationOverThres = iterationOverThres + 1;
    end
end

plotData(trainSpikeY, lambdaYpredict, spikeYpredict)



%% Assessing Goodness-of-fit
% todo: calculate DBR with spikeYpredict
