function plotResults(results)
for transType = 1:3
    spikeTrainY = results{transType, 1};
    lambdaYTrain = results{transType, 2};
    lambdaYTrainPredict = results{transType, 3};
    spikeTrainYpredict = results{transType, 4};
    y = results{transType, 6};

    t = 0:0.01:(length(spikeTrainY) - 1) * 0.01;    
    figure(transType)

    subplot(5, 1, 1)
    plot(t, spikeTrainY);
    title('spikeY Ground Truth')

    subplot(5, 1, 2)
    plot(t, lambdaYTrain);
    title('lambdaY Ground Truth')

    subplot(5, 1, 4);
    plot(t, lambdaYTrainPredict);
    xlabel('Time(sec)')
    ylabel('lambdaY Predict')

    subplot(5, 1, 3)
    plot(t, spikeTrainYpredict);
    title('spikeY predict')
    
    subplot(5, 1, 5)
    plotDBR(y)
end
end