function [H, Wh, xi, threshold, iterationThres, maxIterations, alpha] = hyperParams()
  H = 50; % temporal history
  Wh = 5;
  xi = 0.1;
  threshold = 1e-2;
  iterationThres = 7;
  maxIterations = 20;
  alpha = 0.003; % to do
end