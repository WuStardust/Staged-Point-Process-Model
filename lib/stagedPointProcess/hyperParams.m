function [H, Nz, xi1, xi2, mu, threshold, iterationThres] = hyperParams()
  H = 3; % temporal history
  Nz = 2;
  xi1 = 1;
  xi2 = 5;
  mu = 0.01;
  threshold = 1e-1;
  % v = 1e-2;
  iterationThres = 7;
end