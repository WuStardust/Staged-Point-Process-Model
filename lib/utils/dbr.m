function DBR = dbr(p, spikes)
    % time scale transform
    q = -log(1-p);
    mask = spikes==1;
    subs = cumsum(spikes)+1;
    subs(mask) = subs(mask) - 1;
    xi = accumarray(subs', q', [], @(x) ...,
            sum(x(1:length(x)-1)) - log(...,
                1 - rand() * (...,
                    1 - exp(-x(length(x)))...,
                )...,
            )...,
        );
    y = 1 - exp(-xi);
    
    % distance
    cdfplot(y)
    hold on
    plot(0:.1:1, cdf('Uniform', 0:.1:1, 0, 1))
    hold off
    
    B = sort(y);
    D = max(abs(B' - (1/length(y):1/length(y):1)));
    DBR = D / 1.36 * sqrt(length(y));
end