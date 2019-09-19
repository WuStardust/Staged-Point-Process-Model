function plotData(trainSpikeY, lambdaYpredict, spikeYpredict)
    figure(1)

    % plot the result
    t = 0:0.01:15;
    
    subplot(3, 1, 1)
    plot(t, trainSpikeY);
    title('train output spike train')
    subplot(3, 1, 2)
    plot(t, lambdaYpredict);
    xlabel('Time(sec)')
    ylabel('lambdaY3')
    ylim([0, 1])
    subplot(3, 1, 3)
    plot(t, spikeYpredict);
    title('model output spike train')
 
end