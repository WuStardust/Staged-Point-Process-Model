function [H, Wh, xi, threshold, iterationThres, maxIterations, alpha] = hyperParams()
  H = 50; % temporal history
  Wh = 20;
  xi = 0.5;
  threshold = 1e-2;
  iterationThres = 7;
  maxIterations = 200;
  alpha = 0; % to do
end
