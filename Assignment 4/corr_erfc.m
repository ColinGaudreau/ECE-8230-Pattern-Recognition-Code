function y = corr_erfc(x)
% correction for erfc given negative x
y = x;
y(x>=0) = 1 - erf(x(x>=0));
y(x<0) = 1 + erf(-x(x<0));
end