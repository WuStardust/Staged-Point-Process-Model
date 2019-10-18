clear

%% load data and import functions
addpath .\lib\generateSpikes
addpath .\lib\stagedPointProcess

load('trainSet.mat')
load('testSet.mat')
spikeTrainX = trainSet{1,1}; % get train input
spikeTrainY = trainSet{1,4}; % get train output(GT) of linear
lambdaYTrain = trainSet{1,7};
[Nx, K] = size(spikeTrainX);

%% GLM models
% need todo

%% 2nd order GLM
% need todo

%% staged point process
[spikeTrainYpredict, lambdaYTrainPredict, LHistory, W] = stagedPointProcess(spikeTrainX, spikeTrainY, Nx, K);

%% Assessing Goodness-of-fit
% todo: calculate DBR with spikeYpredict
