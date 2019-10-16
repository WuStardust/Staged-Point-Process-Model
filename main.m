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
Result = cell(1, 30);
for i=1:1
    % train
    tic
    [spikeTrainYpredict, lambdaYTrainPredict, LHistory, W] = stagedPointProcess(spikeTrainX, spikeTrainY, Nx, K);
    plotData(spikeTrainY, lambdaYTrain, spikeTrainYpredict, lambdaYTrainPredict, LHistory, W)
    Result{i} = {spikeTrainYpredict, lambdaYTrainPredict, LHistory, W};
    toc
%     figure(1)
%     subplot(5, 6, i)
%     plot(Result{i}{1})
%     figure(2)
%     subplot(5, 6, i)
%     plot(Result{i}{2})
%     figure(3)
%     subplot(5, 6, i)
%     plot(Result{i}{3})
%     figure(4)
%     subplot(5, 6, i)
%     plot(Result{i}{4})
%     drawnow
end

%% Assessing Goodness-of-fit
% todo: calculate DBR with spikeYpredict
