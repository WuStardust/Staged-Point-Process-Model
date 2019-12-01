function W = initialParams(H, Nx, Nz, xi1, xi2)
  w = xi2 / sqrt(H * Nx) * (2 * rand(Nx*H+1, Nz) - 1);
  theta = xi1 / sqrt(Nz) * (2 * rand(1, Nz+1) - 1);
  W = [reshape(w, 1, (Nx*H+1)*Nz), theta];
end