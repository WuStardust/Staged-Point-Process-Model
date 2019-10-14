function plotData(spikeTrainY, lambdaYTrain, spikeTrainYpredict, lambdaYTrainPredict, LHistory, W)
    figure(1)

    t = 0:0.01:(length(spikeTrainY) - 1) * 0.01;
    
    subplot(4, 1, 1)
    plot(t, spikeTrainY);
    title('output spike train')

    subplot(4, 1, 2)
    plot(t, lambdaYTrain);
    title('output lambda')

    subplot(4, 1, 4);
    plot(t, lambdaYTrainPredict);
    xlabel('Time(sec)')
    ylabel('lambdaY3')

    subplot(4, 1, 3)
    plot(t, spikeTrainYpredict);
    title('model output spike train')

    figure(2)
    subplot(2, 1, 1)
    plot(LHistory)
    subplot(2, 1, 2)
    plot(W)
end