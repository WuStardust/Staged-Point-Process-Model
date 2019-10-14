clear

%% load data and import functions
addpath .\lib\generateSpikes
addpath .\lib\stagedPointProcess

load('trainSet.mat')
load('testSet.mat')
spikeTrainX = trainSet{1,1}; % get train input
spikeTrainY = trainSet{1,4}; % get train output(GT) of linear
lambdaYTrain = trainSet{1,7};
spikeTrainX = spikeTrainX(1:500);
spikeTrainY = spikeTrainY(1:500);
lambdaYTrain = lambdaYTrain(1:500);
[Nx, K] = size(spikeTrainX);

%% GLM models
% need todo

%% 2nd order GLM
% need todo

%% staged point process
% train
tic
[spikeTrainYpredict, lambdaYTrainPredict, LHistory, W] = stagedPointProcess(spikeTrainX, spikeTrainY, Nx, K);
plotData(spikeTrainY, lambdaYTrain, spikeTrainYpredict, lambdaYTrainPredict, LHistory, W)
toc

%% Assessing Goodness-of-fit
% todo: calculate DBR with spikeYpredict
