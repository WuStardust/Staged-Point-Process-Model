function G = gradient(trainSpikeY, lambdaYpredict, lambdaZ, trainSpikeX, theta)
    [Nx, H] = size(trainSpikeX);
    [Nz, ~] = size(lambdaZ);

    % not very clear about how to calculate the gradient
    % G.w = permute(repmat((trainSpikeY - lambdaYpredict) * lambdaZ', [Nx,1,H]), [1, 3, 2]); 
    % G.w0 = repmat(sum(trainSpikeY - lambdaYpredict), [Nz, 1]);
    % G.theta = theta .* ((trainSpikeY - lambdaYpredict) .* lambdaZ .* (1 - lambdaZ)) * 
    % G.theta0 = 
end