function He = hessian(spikeTrainY, lambdaYTrainPredict, lambdaZTrain, spikeTrainX, theta, K, H)
    [Nx, ~] = size(spikeTrainX);
    [Nz, ~] = size(lambdaZTrain);

    Hetheta2 = -[
        ((1 - lambdaYTrainPredict) .* lambdaYTrainPredict) .* lambdaZTrain * lambdaZTrain', lambdaZTrain * ((1 - lambdaYTrainPredict) .* lambdaYTrainPredict)'; 
        (1 - lambdaYTrainPredict) .* lambdaYTrainPredict * lambdaZTrain', (1 - lambdaYTrainPredict) * lambdaYTrainPredict'
    ];

    Xhat = zeros(Nx * H + 1, K - H + 1); % todo
    for h=1:H
        for i=1:Nx
            Xhat(Nx * (h - 1) + i, :) = spikeTrainX(i, H-h+1:K-h+1);
        end
    end
    Xhat(Nx * H + 1, :) = ones(1, K - H + 1);
    Xhat = sparse(Xhat);

    Hew2 = zeros(Nz * (Nx * H + 1));
    Hewtheta = zeros(Nz + 1, Nz * (Nx * H + 1));
    for m=1:Nz
        for n=1:Nz
            diagVpart = - sparse(theta(m) * theta(n) * ...,
                (1 - lambdaYTrainPredict) .* lambdaYTrainPredict .* ...,
                lambdaZTrain(m, :) .* (1 - lambdaZTrain(m, :)) .* ...,
                lambdaZTrain(n, :) .* (1 - lambdaZTrain(n, :)));
            bias = sparse(theta(m) * (spikeTrainY - lambdaYTrainPredict) .* ...,
                (1 - 2 * lambdaZTrain(m, :)) .* lambdaZTrain(m, :));

            wthetaV = - sparse(theta(m) * ...,
                (1 - lambdaYTrainPredict) .* lambdaYTrainPredict .* ...,
                lambdaZTrain(m, :) .* (1 - lambdaZTrain(m, :)) .* ...,
                lambdaZTrain(n, :));
            wthetaBias = sparse((spikeTrainY - lambdaYTrainPredict) .* ...,
                (1 - lambdaZTrain(m, :)) .* lambdaZTrain(m, :));

            if(m == n)
                diagM = diag(diagVpart + bias);
                wthetaPart = wthetaV + wthetaBias;
            else
                diagM = diag(diagVpart);
                wthetaPart = wthetaV;
            end
            Hew2((Nx * H + 1) * (m-1) + 1:(Nx * H + 1) * m, (Nx * H + 1) * (n-1) + 1:(Nx * H + 1) * n) = ...,
                Xhat * diagM * Xhat';

            Hewtheta(m, (Nx * H + 1) * (n-1) + 1:(Nx * H + 1) * n) = wthetaPart * Xhat';
        end
    end

    for m=1:Nz
        Hewtheta(Nz + 1, (Nx * H + 1) * (m-1) + 1:(Nx * H + 1) * m) = - theta(m) * ...,
            ((1 - lambdaYTrainPredict) .* lambdaYTrainPredict .* ...,
            lambdaZTrain(m, :) .* (1 - lambdaZTrain(m, :))) * ...,
            Xhat';
    end

    He = [Hew2, Hewtheta'; Hewtheta, Hetheta2];
end