function [lambdaYpredict, spikeYpredict, lambdaZ] = model(Xhat, W, H, Nx, Nz)
precise = 1e-6; % deal with tructed error of matlab --- Qian

w = reshape(W(1:(Nx*H+1)*Nz), Nx*H+1, Nz)';
theta = W((Nx*H+1)*Nz+1:length(W));
lambdaZ = sigmaFunc(w * Xhat);
lambdaZ(lambdaZ<precise) = precise;
lambdaZ(1-lambdaZ<precise) = 1-precise;

lambdaYpredict = sigmaFunc(theta * [lambdaZ; ones(1, length(lambdaZ))]);
lambdaYpredict(lambdaYpredict<precise) = precise;
lambdaYpredict(1-lambdaYpredict<precise) = 1-precise;

spikeYpredict = lambda2Spike(lambdaYpredict);
end
