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
threshold = 1e-3;
v = 1e-5;

%% GLM models
% need todo

%% 2nd order GLM
% need todo

%% staged point process
% initialize the params
w = rand(Nx, H, Nz) - 0.5;
w0 = rand(1, Nz) - 0.5;
theta = rand(1, Nz) - 0.5;
theta0 = 0; % rand();

% use gradient ascent to maxmium the L

[lambdaYpredict, spikeYpredict, lambdaZ] = model(trainSpikeX, w, w0, theta, theta0);

% plotData(trainSpikeY, lambdaYpredict, spikeYpredict)

L = logLikelyhood(trainSpikeY, lambdaYpredict);

history = L;
iteration = 0;
while(err > threshold)
    G = gradient(trainSpikeY, lambdaYpredict, lambdaZ, trainSpikeX, theta);  % todo: complete the function
    
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
    
    history = [history, L];
    figure(2)
    plot(history)
    
    iteration = iteration + 1;
end

plotData(trainSpikeY, lambdaYpredict, spikeYpredict)



%% Assessing Goodness-of-fit
% todo: calculate DBR with spikeYpredict
