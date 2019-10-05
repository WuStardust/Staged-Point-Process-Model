function HL = hessian(trainSpikeY, lambdaYpredict, lambdaZ, trainSpikeX, theta)
    [Nx, H] = size(trainSpikeX);
    [Nz, ~] = size(lambdaZ);
    
    %% dL*dL/dtheta*dtheta
    HL.theta2 = [
        lambdaZ * diag((1 - lambdaYpredict) .* lambdaYpredict) * lambdaZ', lambdaZ * ((1 - lambdaYpredict) .* lambdaYpredict)'; 
        (1 - lambdaYpredict) .* lambdaYpredict * lambdaZ', (1 - lambdaYpredict) * lambdaYpredict'
    ];

    %% dL*dL/dw*dw
    X_hat = zeros(Nx, H, H);
    X_hat_all = repmat(trainSpikeX, [1 1 H]);
    for i = 1:Nx
       X_hat(i, :, :) = tril(squeeze(X_hat_all(i, :, :))); % todo: not clear the define of X_hat
    end
    X_hat(Nx + 1, :, :) = ones(1, H, H);

    HL.w2 = zeros(Nx + 1, H, Nz, Nx + 1, H, Nz);
    for i = 1:Nz
        for j = 1:Nz
            diagV_part = theta(i) * theta(j) * ...,
                        (1 - lambdaYpredict) .* lambdaYpredict .* ...,
                        lambdaZ(i, :) .* (1 - lambdaZ(i, :) .* ...,
                        lambdaZ(j, :) .* (1 - lambdaZ(j, :)));
            bias = theta(i) * (trainSpikeY - lambdaYpredict);
            if(i == j)
                diagM = diag(diagV_part + bias);
            else
                diagM = diag(diagV_part);
            end
            HL.w2(:, :, i, :, :, j) = reshape(reshape(X_hat, (Nx + 1) * H, H) * diagM * reshape(X_hat, (Nx + 1) * H, H)', Nx + 1, H, Nx + 1, H);
        end
    end

    %% 
    
    %%
end