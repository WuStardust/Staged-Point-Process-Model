function [preTrainN, H, Nz, xi1, xi2, mu, threshold, iterationThres, maxIterations, alpha] = hyperParams()
  preTrainN = 50;
  H = 50; % temporal history
  Nz = 15;
  xi1 = 0.05;
  xi2 = 0.1;
  mu = 1;
  threshold = 1e-3;
  iterationThres = 7;
  maxIterations = 500;
  alpha = 0;
end