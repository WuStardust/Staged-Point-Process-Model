%% import libs
addpath .\lib\generateSpikes
addpath .\lib\utils

%% const variables
timeBin = 0.01;
duration = 200;
t = timeBin:timeBin:duration;

%% generate
input = cell(10, 3);
inputS = cell(10, 3);
outputY = cell(10, 3, 3);
outputYs = cell(10, 3, 3);
outputLambda = cell(10, 3, 3);
outputLambdaS = cell(10, 3, 3);
for i = 1:10
% input spike
[lambdaX1, spikeX1] = inputSpike(0.3, 0.01, 1.05, 0.3, t, timeBin);
[lambdaX2, spikeX2] = inputSpike(0.3, 0.01, -1.05, 0.3, t, timeBin);
% three different transfer models
[lambdaY1, spikeY1, lambdaYs1, spikeYs1] = transferLiner(lambdaX1, lambdaX2);
[lambdaY2, spikeY2, lambdaYs2, spikeYs2] = transferQuadratic(lambdaX1, lambdaX2);
[lambdaY3, spikeY3, lambdaYs3, spikeYs3] = transferSinusoidal(lambdaX1, lambdaX2);

%% cut into train/validate/test
input{i, 1} = [spikeX1(1:0.6*length(t)); spikeX2(1:0.6*length(t))];
input{i, 2} = [spikeX1(0.6*length(t)+1:0.7*length(t)); spikeX2(0.6*length(t)+1:0.7*length(t))];
input{i, 3} = [spikeX1(0.7*length(t)+1:length(t)); spikeX2(0.7*length(t)+1:length(t))];
inputS{i, 1} = spikeX1(1:0.6*length(t));
inputS{i, 2} = spikeX1(0.6*length(t)+1:0.7*length(t));
inputS{i, 3} = spikeX1(0.7*length(t)+1:length(t));

outputY{i, 1, 1} = spikeY1(1:0.6*length(t));
outputY{i, 1, 2} = spikeY1(0.6*length(t)+1:0.7*length(t));
outputY{i, 1, 3} = spikeY1(0.7*length(t)+1:length(t));

outputY{i, 2, 1} = spikeY2(1:0.6*length(t));
outputY{i, 2, 2} = spikeY2(0.6*length(t)+1:0.7*length(t));
outputY{i, 2, 3} = spikeY2(0.7*length(t)+1:length(t));

outputY{i, 3, 1} = spikeY3(1:0.6*length(t));
outputY{i, 3, 2} = spikeY3(0.6*length(t)+1:0.7*length(t));
outputY{i, 3, 3} = spikeY3(0.7*length(t)+1:length(t));

outputYs{i, 1, 1} = spikeYs1(1:0.6*length(t));
outputYs{i, 1, 2} = spikeYs1(0.6*length(t)+1:0.7*length(t));
outputYs{i, 1, 3} = spikeYs1(0.7*length(t)+1:length(t));

outputYs{i, 2, 1} = spikeYs2(1:0.6*length(t));
outputYs{i, 2, 2} = spikeYs2(0.6*length(t)+1:0.7*length(t));
outputYs{i, 2, 3} = spikeYs2(0.7*length(t)+1:length(t));

outputYs{i, 3, 1} = spikeYs3(1:0.6*length(t));
outputYs{i, 3, 2} = spikeYs3(0.6*length(t)+1:0.7*length(t));
outputYs{i, 3, 3} = spikeYs3(0.7*length(t)+1:length(t));

outputLambda{i, 1, 1} = lambdaY1(1:0.6*length(t));
outputLambda{i, 1, 2} = lambdaY1(0.6*length(t)+1:0.7*length(t));
outputLambda{i, 1, 3} = lambdaY1(0.7*length(t)+1:length(t));

outputLambda{i, 2, 1} = lambdaY2(1:0.6*length(t));
outputLambda{i, 2, 2} = lambdaY2(0.6*length(t)+1:0.7*length(t));
outputLambda{i, 2, 3} = lambdaY2(0.7*length(t)+1:length(t));

outputLambda{i, 3, 1} = lambdaY3(1:0.6*length(t));
outputLambda{i, 3, 2} = lambdaY3(0.6*length(t)+1:0.7*length(t));
outputLambda{i, 3, 3} = lambdaY3(0.7*length(t)+1:length(t));

outputLambdaS{i, 1, 1} = lambdaYs1(1:0.6*length(t));
outputLambdaS{i, 1, 2} = lambdaYs1(0.6*length(t)+1:0.7*length(t));
outputLambdaS{i, 1, 3} = lambdaYs1(0.7*length(t)+1:length(t));

outputLambdaS{i, 2, 1} = lambdaYs2(1:0.6*length(t));
outputLambdaS{i, 2, 2} = lambdaYs2(0.6*length(t)+1:0.7*length(t));
outputLambdaS{i, 2, 3} = lambdaYs2(0.7*length(t)+1:length(t));

outputLambdaS{i, 3, 1} = lambdaYs3(1:0.6*length(t));
outputLambdaS{i, 3, 2} = lambdaYs3(0.6*length(t)+1:0.7*length(t));
outputLambdaS{i, 3, 3} = lambdaYs3(0.7*length(t)+1:length(t));

end

%% show data
% figure(1)
% subplot(2, 2, 1)
% plot(t, spikeX1)
% title('Synthetic input spike train')
% subplot(2, 2, 3)
% plot(t, lambdaX1);
% xlabel('Time(sec)')
% ylabel('lambdaX1')
% ylim([0, 1])
% subplot(2, 2, 2)
% plot(t, spikeX2)
% title('Synthetic input spike train')
% subplot(2, 2, 4)
% plot(t, lambdaX2)
% xlabel('Time(sec)')
% ylabel('lambdaX2')
% ylim([0, 1])

% figure(2)
% subplot(6, 1, 1)
% plot(t, spikeYs1)
% title('Synthetic output spike train')
% subplot(6, 1, 2)
% plot(t, lambdaYs1);
% xlabel('Time(sec)')
% ylabel('lambdaY1')
% ylim([0, 1])
% figure(2)
% subplot(6, 1, 3)
% plot(t, spikeYs2)
% title('Synthetic output spike train')
% subplot(6, 1, 4)
% plot(t, lambdaYs2);
% xlabel('Time(sec)')
% ylabel('lambdaY2')
% ylim([0, 1])
% figure(2)
% subplot(6, 1, 5)
% plot(t, spikeYs3)
% title('Synthetic output spike train')
% subplot(6, 1, 6)
% plot(t, lambdaYs3);
% xlabel('Time(sec)')
% ylabel('lambdaY3')
% ylim([0, 1])

%% save data
save input.mat input
save('output.mat', 'outputY', 'outputLambda')

input = inputS;
outputY = outputYs;
outputLambda = outputLambdaS;

save inputS.mat input
save('outputS.mat', 'outputY', 'outputLambda')
