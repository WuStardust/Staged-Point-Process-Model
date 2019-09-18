function lambdaZ = firstLayer(spikeX, w, w0)
    [Nx, H, Nz] = size(w);
    convRes = zeros(Nx, H, Nz);
    
    for i=1:Nx
        for j=1:Nz
            res = conv(spikeX(i,:), w(i,:,j));
            convRes(i,:,j) = res(1:H);
        end
    end
    
    lambdaZ = sigmaFunc(squeeze(sum(convRes)) + w0)';
    
%     convRes = zeros(Nx, 2*H-1, Nz);
%     linerRes = zeros(2*H-1, Nz);
%     for i=1:Nx
%         for j=1:Nz
%             convRes(1,:,j) = conv(spikeX(i,:), w(i,:,j));
%         end
%     end
%     convRes = sum(convRes);
%     linerRes(:,:) = convRes(1,:,:);
%     lambdaZ = sigmaFunc(linerRes' + w0);
end
