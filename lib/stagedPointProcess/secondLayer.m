function lambdaY = secondLayer(lambdaZ, theta, theta0)
    lambdaY = sigmaFunc(((10 * theta) * (10 * lambdaZ) + 100 * theta0) / 100);
end
