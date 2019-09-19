function G = gradient(trainSpikeY, lambdaYpredict, lambdaZ, trainSpikeX, theta)
    [Nx, H] = size(trainSpikeX);
    [Nz, ~] = size(lambdaZ);

    G.theta = (trainSpikeY - lambdaYpredict) * lambdaZ';

    G.theta0 = sum(trainSpikeY - lambdaYpredict);

    GlambdZ2w = theta' .* ((trainSpikeY - lambdaYpredict) .* lambdaZ .* (1 - lambdaZ));
    for j = 1:Nz
        for i = 1:Nx
            convRes = conv(GlambdZ2w(j, :), flip(trainSpikeX(i, :))); % todo, not clear here
            G.w(i, :, j) = convRes(1:H);
        end
    end

    G.w0 = theta .* sum((trainSpikeY - lambdaYpredict) .* lambdaZ .* (1 - lambdaZ), 2)';
end