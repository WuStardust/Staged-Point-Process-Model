% clear
% 
% %% load data and import functions
% addpath .\lib\generateSpikes
% addpath .\lib\stagedPointProcess
% 
% load('input.mat')
% load('ouput.mat')
% spikeTrainX = input{1};
% spikeTrainY = ouputY{3,1};
% lambdaYTrain = outputLambda{3,1};
% [Nx, K] = size(spikeTrainX);
% 
% %% GLM models
% % need todo
% 
% %% 2nd order GLM
% % need todo
% 
% %% staged point process
% [spikeTrainYpredict, lambdaYTrainPredict, LHistory, W] = stagedPointProcess(spikeTrainX, spikeTrainY, Nx, K, spikeTrainXvalidate, spikeTrainYvalidate);
% plotData(spikeTrainY, lambdaYTrain, spikeTrainYpredict, lambdaYTrainPredict, LHistory, W)
% 
% %% Assessing Goodness-of-fit
% % todo: calculate DBR with spikeYpredict
