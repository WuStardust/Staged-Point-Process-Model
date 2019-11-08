function [preTrainN, H, Nz, xi1, xi2, mu, threshold, iterationThres, maxIterations, alpha] = hyperParams()
  preTrainN = 50;
  H = 50; % temporal history
  Nz = 15;
  xi1 = 10;
  xi2 = 10;
  mu = 0.01;
  threshold = 1e-3;
  iterationThres = 7;
  maxIterations = 300;
  alpha = 0;
end