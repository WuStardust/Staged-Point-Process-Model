function W = initialParams(H, Nx, xi)
  W = xi / sqrt(Nx) * (2 * rand(1, Nx*H+1) - 1);
end