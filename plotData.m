function plotData(spikeTrainY, lambdaYTrain, spikeTrainYpredict, lambdaYTrainPredict)
    figure(1)

    % plot the result
    t = 0:0.01:(length(spikeTrainY) - 1) * 0.01;
    
    subplot(4, 1, 1)
    plot(t, spikeTrainY);
    title('output spike train')

    subplot(4, 1, 2)
    plot(t, lambdaYTrain);
    title('output lambda')

    p = subplot(4, 1, 4);
%     hold(p,'on')
    plot(p, t, lambdaYTrainPredict);
    xlabel('Time(sec)')
    ylabel('lambdaY3')
%     hold(p, 'off')

    subplot(4, 1, 3)
    plot(t, spikeTrainYpredict);
    title('model output spike train')
 
end