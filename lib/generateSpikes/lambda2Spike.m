% generate spike as a Bernoulli random variable
function spike = lambda2Spike(lambda)
    lengthT = length(lambda);
    randSeq = rand(1, lengthT);
    spike = randSeq < lambda;
end
