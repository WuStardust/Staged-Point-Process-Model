clear

%% load data and import functions
addpath .\lib\generateSpikes
addpath .\lib\stagedPointProcess
addpath .\lib\optimize
load('trainSet.mat')
load('testSet.mat')

trainSpikeX = trainSet{1,1}; % get train input
trainSpikeY = trainSet{1,4}; % get train output(GT) of Sinusoidal

[Nx, H] = size(trainSet{1,1});
Nz = 15;
err = 1;
tol = 0.001;
v = 0.01;

%% GLM models
% need todo

%% 2nd order GLM
% need todo

%% staged point process
% initialize the params
w = rand(Nx, H, Nz);
w0 = rand(1, Nz) * 4 - 2;
theta = rand(1, Nz) * 4 - 2;
theta0 = rand() * 4 - 2;

% use gradient ascent to maxmium the L

[lambdaYpredict, spikeYpredict, lambdaZ] = model(trainSpikeX, w, w0, theta, theta0);

% plotData(trainSpikeY, lambdaYpredict, spikeYpredict)

L = logLikelyhood(trainSpikeY, lambdaYpredict);

iteration = 0;
while(err > tol)
    G = gradient(trainSpikeY, lambdaYpredict, lambdaZ, trainSpikeX, theta);  % todo: complete the function
    
    % update params
    w = w - v * G.w;
    w0 = w0 - v * G.w0;
    theta = theta - v * G.theta;
    theta0 = theta0 - v * G.theta0;
    
    % calculat with new params
    Lpre = L;
    [lambdaYpredict, spikeYpredict, lambdaZ] = model(trainSpikeX, w, w0, theta, theta0);
    L = logLikelyhood(trainSpikeY, lambdaYpredict);
    err = abs(L - Lpre);
    
    iteration = iteration + 1;
end

%% Assessing Goodness-of-fit
% todo: calculate DBR with spikeYpredict
