function [H, Nz, xi1, xi2, mu, threshold, iterationThres] = hyperParams()
  H = 50; % temporal history
  Nz = 15;
  xi1 = 1;
  xi2 = 10;
  mu = 0.01;
  threshold = 1e-1;
  % v = 1e-2;
  iterationThres = 7;
end