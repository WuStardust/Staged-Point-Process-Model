function Xall = getXall(spikeTrainX, H)
  [Nx, K] = size(spikeTrainX);
  Xhat = zeros(Nx * H + 1, K - H + 1);
  for h=1:H
      for i=1:Nx
          Xhat(Nx * (h - 1) + i, :) = spikeTrainX(i, H-h+1:K-h+1);
      end
  end
  Xhat(Nx * H + 1, :) = ones(1, K - H + 1);

  XcovHat = zeros((Nx*H-1)*Nx*H/2, K - H + 1);
  unitTril = logical(tril(ones(Nx*H), -1));
  for k=H:K
    Xhis = reshape(spikeTrainX(:, k-H+1:k)*1, 1, Nx*H);
    Xcov = Xhis' * Xhis;
    XcovHat(:, k-H+1) = Xcov(unitTril);
  end

  Xall = [XcovHat; Xhat];
  Xall = sparse(Xall);
end