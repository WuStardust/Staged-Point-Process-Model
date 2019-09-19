function G = gradient(trainSpikeY, lambdaYpredict, lambdaZ, trainSpikeX, theta)
    [Nx, H] = size(trainSpikeX);
    [Nz, ~] = size(lambdaZ);

    G.theta = (trainSpikeY - lambdaYpredict) * lambdaZ';

    G.theta0 = sum(trainSpikeY - lambdaYpredict);

    GalmbdZ2w = theta' .* ((trainSpikeY - lambdaYpredict) .* lambdaZ .* (1 - lambdaZ));
    for j = 1:Nz
        for i = 1:Nx
            convRes = conv(GalmbdZ2w(j, :), flip(trainSpikeX(i, :)));
            G.w(i, :, j) = convRes(1:H);
        end
    end

    G.w0 = theta .* sum((trainSpikeY - lambdaYpredict) .* lambdaZ .* (1 - lambdaZ), 2)';
end