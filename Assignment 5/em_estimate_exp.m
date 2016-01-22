function lambda = em_estimate_exp(x)
% EM estimate for lambda in exponential dist when
% x is floor(y), where y is sampled from dist.
ERROR = 1e-7 ;
MAX_ITERATION = 10000;
lambda = 10;

for i = 1:MAX_ITERATION
    y = 1/lambda * (exp(-lambda*x).*(lambda*x + 1) - ...
        exp(-lambda*(x + 1)).*(lambda*(x + 1) + 1)) ./ ...
        (exp(-lambda.*x) .* (1 - exp(-lambda))); % see write up for derivation of this expression
    newlambda = length(x) / sum(y);
    
    if abs(newlambda - lambda) < ERROR
        break;
    end
    
    lambda = newlambda;
end
end