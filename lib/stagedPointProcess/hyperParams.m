function [H, Nz, xi1, xi2, mu, threshold, iterationThres] = hyperParams()
  H = 50; % temporal history
  Nz = 15;
  xi1 = 0.5;
  xi2 = 1;
  mu = 1e-3;
  threshold = 5e-2;
  % v = 1e-2;
  iterationThres = 7;
end