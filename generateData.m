%% import libs
addpath .\lib\generateSpikes

%% const variables
timeBin = 0.01;
duration = 200;
t = timeBin:timeBin:duration;

%% generate
% input spike
[lambdaX1, spikeX1] = inputSpike(0.3, 0.01, 1.05, 0.3, t, timeBin);
[lambdaX2, spikeX2] = inputSpike(0.3, 0.01, -1.05, 0.3, t, timeBin);
% three different transfer models
[lambdaY1, spikeY1] = transferLiner(lambdaX1, lambdaX2);
[lambdaY2, spikeY2] = transferQuadratic(lambdaX1, lambdaX2);
[lambdaY3, spikeY3] = transferSinusoidal(lambdaX1, lambdaX2);

%% cut into train/validate/test
input{1} = [spikeX1(1:0.6*length(t)); spikeX2(1:0.6*length(t))];
input{2} = [spikeX1(0.6*length(t)+1:0.7*length(t)); spikeX2(0.6*length(t)+1:0.7*length(t))];
input{3} = [spikeX1(0.7*length(t)+1:length(t)); spikeX2(0.7*length(t)+1:length(t))];

outputY{1, 1} = spikeY1(1:0.6*length(t));
outputY{1, 2} = spikeY1(0.6*length(t)+1:0.7*length(t));
outputY{1, 3} = spikeY1(0.7*length(t)+1:length(t));

outputY{2, 1} = spikeY2(1:0.6*length(t));
outputY{2, 2} = spikeY2(0.6*length(t)+1:0.7*length(t));
outputY{2, 3} = spikeY2(0.7*length(t)+1:length(t));

outputY{3, 1} = spikeY3(1:0.6*length(t));
outputY{3, 2} = spikeY3(0.6*length(t)+1:0.7*length(t));
outputY{3, 3} = spikeY3(0.7*length(t)+1:length(t));

outputLambda{1, 1} = lambdaY1(1:0.6*length(t));
outputLambda{1, 2} = lambdaY1(0.6*length(t)+1:0.7*length(t));
outputLambda{1, 3} = lambdaY1(0.7*length(t)+1:length(t));

outputLambda{2, 1} = lambdaY2(1:0.6*length(t));
outputLambda{2, 2} = lambdaY2(0.6*length(t)+1:0.7*length(t));
outputLambda{2, 3} = lambdaY2(0.7*length(t)+1:length(t));

outputLambda{3, 1} = lambdaY3(1:0.6*length(t));
outputLambda{3, 2} = lambdaY3(0.6*length(t)+1:0.7*length(t));
outputLambda{3, 3} = lambdaY3(0.7*length(t)+1:length(t));

%% show data
figure(1)
subplot(2, 2, 1)
plot(t, spikeX1)
title('Synthetic input spike train')
subplot(2, 2, 3)
plot(t, lambdaX1);
xlabel('Time(sec)')
ylabel('lambdaX1')
ylim([0, 1])
subplot(2, 2, 2)
plot(t, spikeX2)
title('Synthetic input spike train')
subplot(2, 2, 4)
plot(t, lambdaX2)
xlabel('Time(sec)')
ylabel('lambdaX2')
ylim([0, 1])

figure(2)
subplot(6, 1, 1)
plot(t, spikeY1)
title('Synthetic output spike train')
subplot(6, 1, 2)
plot(t, lambdaY1);
xlabel('Time(sec)')
ylabel('lambdaY1')
ylim([0, 1])
figure(2)
subplot(6, 1, 3)
plot(t, spikeY2)
title('Synthetic output spike train')
subplot(6, 1, 4)
plot(t, lambdaY2);
xlabel('Time(sec)')
ylabel('lambdaY2')
ylim([0, 1])
figure(2)
subplot(6, 1, 5)
plot(t, spikeY3)
title('Synthetic output spike train')
subplot(6, 1, 6)
plot(t, lambdaY3);
xlabel('Time(sec)')
ylabel('lambdaY3')
ylim([0, 1])

%% save data
save input.mat input
save('output.mat', 'outputY', 'outputLambda')
