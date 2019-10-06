function generateData(trainSize, testSize)
    %% import libs
    addpath .\lib\generateSpikes

    %% const variables
    timeBin = 0.01;
    duration = 15;
    t = 0:timeBin:duration;
    trainSet = cell(trainSize, 7);
    testSet = cell(testSize, 4);

    %% loop for generate
    for i=1:(trainSize+testSize)
        % input spike
        [lambdaX1, spikeX1] = inputSpike(0.3, 0.01, 1.05, 0.3, t, timeBin);
        [lambdaX2, spikeX2] = inputSpike(0.3, 0.01, -1.05, 0.3, t, timeBin);
        % three different transfer models
        [lambdaY1, spikeY1] = transferLiner(lambdaX1, lambdaX2);
        [lambdaY2, spikeY2] = transferQuadratic(lambdaX1, lambdaX2);
        [lambdaY3, spikeY3] = transferSinusoidal(lambdaX1, lambdaX2);

       %% generate train set and test set
        % generate spike trains follow the same method as above for several times
        % to construct the train and test set 
        if (i <= trainSize)
            trainSet{i, 1} = [spikeX1; spikeX2];
            trainSet{i, 2} = spikeY1;
            trainSet{i, 3} = spikeY2;
            trainSet{i, 4} = spikeY3;
            trainSet{i, 5} = lambdaY1;
            trainSet{i, 6} = lambdaY2;
            trainSet{i, 7} = lambdaY3;
        else
            testSet{i - trainSize, 1} = [spikeX1; spikeX2];
            testSet{i - trainSize, 2} = spikeY1;
            testSet{i - trainSize, 3} = spikeY2;
            testSet{i - trainSize, 4} = spikeY3;
        end

    end

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
    save trainSet.mat trainSet
    save testSet.mat  testSet
end
