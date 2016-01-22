N = [20,50,100,200]; % number of samples
L = 1000; % number of training samples
lambda = 1;
lambda_D = @(x) log(1 + length(x)/sum(x)); % Maximum likelihood estimate of lambda
estimate_D = zeros(L,1);
estimate_EM = estimate_D;
error = @(x) sum((x - lambda).^2)/length(x);

for n = N
    for i = 1:L
        x = floor(exprnd(lambda,1,n));
        estimate_D(i) = lambda_D(x);
        estimate_EM(i) = em_estimate_exp(x);
    end
    
    err_D = error(estimate_D);
    err_EM = error(estimate_EM);
    
    fprintf('N = %d\n', n);
    fprintf(['Error for maximum likelihood estimate: %.4f\n' ... 
        'Error for EM algorithm estimate: %.4f\n\n'], err_D, err_EM);
end