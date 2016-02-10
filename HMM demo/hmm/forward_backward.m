function [alpha, beta] = forward_backward(pi, A, B, O)
% Function finds the forward and backward variables in
% one pass.

T = length(O);
N = size(A,1);

alpha = zeros(T,N);
beta = zeros(T,N);

alpha(1,:) = pi(1,:) .* (B(:,O(1))'); % assume that O(t) is the number of the state (i.e. 1 <= num <= M)
beta(T,:) = ones(1,N);

for t = 2:T
    tau = (T + 1) - t; % keep track of t for backward pass
    alpha(t,:) = alpha(t-1,:) * A .* (B(:,O(t))');
    beta(tau,:) = A * (B(:,O(tau+1)) .* beta(tau+1,:)');
end

end