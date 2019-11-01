function [lambdaYpredict, spikeYpredict, lambdaZ] = model(Xhat, W, H, Nx, Nz)
    w = reshape(W(1:(Nx*H+1)*Nz), Nx*H+1, Nz)';
    theta = W((Nx*H+1)*Nz+1:length(W));
    lambdaZ = [zeros(Nz, H-1), sigmaFunc(w * Xhat)];
    lambdaYpredict = sigmaFunc(theta * [lambdaZ; ones(1, length(lambdaZ))]);
    lambdaYpredict(1:H-1) = 0;
    spikeYpredict = lambda2Spike(lambdaYpredict);
end
