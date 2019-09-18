function lambdaY = secondLayer(lambdaZ, theta, theta0)
    lambdaY = sigmaFunc(theta * lambdaZ + theta0);
end
