% static nonlinear transformation
function output = sigmaFunc(input)
    % define the static nonlinear transformation here
    output = 1 ./ (1 + exp(-input));
end
