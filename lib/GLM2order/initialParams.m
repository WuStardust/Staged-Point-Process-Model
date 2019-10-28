function W = initialParams(H, Nx, xi)
  W = xi / sqrt((Nx*H-1)*Nx*H/2) * (2 * rand(1, (Nx*H+1)*Nx*H/2+1) - 1);
end