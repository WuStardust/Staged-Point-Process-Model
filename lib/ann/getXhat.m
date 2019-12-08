function Xhat = getXhat(spikeTrainX, H)
    [Nx, K] = size(spikeTrainX);
    Xhat = zeros(Nx * H + 1, K - H + 1);
    for h=1:H
        for i=1:Nx
            Xhat(Nx * (h - 1) + i, :) = spikeTrainX(i, H-h+1:K-h+1);
        end
    end
    Xhat(Nx * H + 1, :) = ones(1, K - H + 1);
    Xhat = double(Xhat);
  end