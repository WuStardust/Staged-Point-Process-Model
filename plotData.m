function plotData(spikeTrainY, lambdaYTrain, spikeTrainYpredict, lambdaYTrainPredict, LHistory, W)
    figure(1)

    t = 0:0.01:(length(spikeTrainY) - 1) * 0.01;
    
    subplot(4, 1, 1)
    plot(t, spikeTrainY);
    title('spikeY Ground Truth')

    subplot(4, 1, 2)
    plot(t, lambdaYTrain);
    title('lambdaY Ground Truth')

    subplot(4, 1, 4);
    plot(t, lambdaYTrainPredict);
    xlabel('Time(sec)')
    ylabel('lambdaY Predict')

    subplot(4, 1, 3)
    plot(t, spikeTrainYpredict);
    title('spikeY predict')

    figure(2)
    subplot(2, 1, 1)
    plot(LHistory)
    subplot(2, 1, 2)
    plot(W)

    drawnow
end