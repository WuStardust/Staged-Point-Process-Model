function lambdaZ = firstLayer(spikeX, w, w0)
%     [Nx, H, Nz] = size(w);
%     convRes = zeros(Nx, H, Nz);

%     for i=1:Nx
%         for j=1:Nz
%             res = conv(spikeX(i,:), w(i,:,j));
%             convRes(i,:,j) = res(1:H);
%         end
%     end

%     lambdaZ = sigmaFunc(squeeze(sum(convRes)) + w0)';
    lambdaZ = sigmaFunc(squeeze(sum(sum(spikeX .* fliplr(w)))) + w0');
end
