function plotDBR(y)
cdfplot(y)
hold on
plot(0:.1:1, cdf('Uniform', 0:.1:1, 0, 1))
hold off
end