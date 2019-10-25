function [H, Nz, xi1, xi2, mu, threshold, iterationThres, alpha] = hyperParams()
  H = 50; % temporal history
  Nz = 15;
  xi1 = 1;
  xi2 = 1;
  mu = 1e-2;
  threshold = 1e-2;
  % v = 1e-2;
  iterationThres = 7;
  alpha = 100; % to do
end