function [w, w0, theta, theta0, W] = initialParams(H, Nx, Nz, xi1, xi2)
  w = xi2 / sqrt(H * Nx) * (2 * rand(Nx, H, Nz) - 1);
  w0 = xi2 / sqrt(H * Nx) * (2 * rand(1, Nz) - 1);
  theta = xi1 / sqrt(Nz) * (2 * rand(1, Nz) - 1);
  theta0 = xi1 / sqrt(Nz) * (2 * rand() - 1);
  W = [reshape([reshape(w, Nx*H, Nz); w0], 1, (Nx*H+1)*Nz), theta, theta0];
end