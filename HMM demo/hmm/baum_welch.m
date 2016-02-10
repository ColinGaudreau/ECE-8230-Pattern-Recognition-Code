function [pi, A, B, did_converge] = baum_welch(pi, A, B, O_list)
% Function uses the Baum-Welch (EM algorithm for hmm)
% to train hmm with several observations.
%
% N - number of states
% M - number of observable states
%
% pi - 1xN matrix of initial state probabilities
% A - NxN transition probabilities
% B - NxM emmision probabilities
% O - cell array, each element is a sequence of observed variables.
MAX_ITERATIONS = 100;
MIN_TOLERANCE = 1e-16;
did_converge = false;

alpha_list = [];
beta_list = [];

for i = 1:MAX_ITERATIONS
    if isempty(alpha_list) || isempty(beta_list)
        [alpha_list, beta_list] = alphabeta_list(pi, A, B, O_list);
    end
    new_pi = reestimate_pi(alpha_list, beta_list, A, B, O_list);
    new_A = reestimate_A(alpha_list, beta_list, A, B, O_list);
    new_B = reestimate_B(alpha_list, beta_list, A, B, O_list);
    
    [newalpha_list, newbeta_list] = alphabeta_list(new_pi, new_A, new_B, O_list);
    
    if i > 100 && abs(log_likelihood(newalpha_list) - log_likelihood(alpha_list)) < MIN_TOLERANCE
        did_converge = true;
        break;
    end
    
    pi = new_pi;
    A = new_A;
    B = new_B;
    alpha_list = newalpha_list;
    beta_list = newbeta_list;
end

    function new_pi = reestimate_pi(alpha_list, beta_list, A, B, O_list) 
        N = size(A,1);
        
        new_pi = zeros(1,N);
        for i = 1:length(O_list)
            O = O_list{i};
            alpha = alpha_list{i};
            beta = beta_list{i};
            
            W = 1 / sum(alpha(size(alpha,1),:));
            new_pi_i = alpha(1,:).*beta(1,:);
            new_pi = new_pi + W * new_pi_i/sum(new_pi_i);
        end
    end

    function new_A = reestimate_A(alpha_list, beta_list, A, B,O_list)
        N = size(A,1);
        
        new_A = zeros(N,N);
        for i = 1:length(O_list)
            O = O_list{i};
            alpha = alpha_list{i};
            beta = beta_list{i};
            T = length(O);
            new_A_i = zeros(N,N);
            
            for t = 1:T-1
                new_A_i = new_A_i + repmat(alpha(t,:)',1,N) .* A .* ...
                    repmat(B(:,O(t+1))',N,1) .* ...
                    repmat(beta(t+1,:),N,1);
            end
            
            W = 1 / sum(alpha(size(alpha,1),:));
            new_A = new_A + W * new_A_i / sum(new_A_i(:));
        end
    end

    function new_B = reestimate_B(alpha_list, beta_list, A, B, O_list)
        N = size(A,1);
        M = size(B,2);
        
        new_B = zeros(N,M);
        for i = 1:length(O_list)
            O = O_list{i};
            alpha = alpha_list{i};
            beta = beta_list{i};
            new_B_i = zeros(N,M);
            
            for j = 1:M
                ind = O == j; % find states such that O_t = v_j
                new_B_i(:,j) = sum(alpha(ind,:).*beta(ind,:),1)';
            end
            
            W = 1 / sum(alpha(size(alpha,1),:));
            new_B = new_B + W * new_B_i ./ ...
                repmat(sum(new_B_i,2),1,M);
        end
    end

    function ll = log_likelihood(alpha_list)
        % recall that P(O|lambda) = sum_i^N alpha_T (i)
        % so if we have a set of observations {O^1, ..., O^K}
        % and we are maximizing the parameters, then 
        % we can compare the behaviour of P({O^1,...,o^K},lamba)
        % = product(P(O^k | lambda) which is proportional to 
        % sum log(P(O^k|lambda)) = sum log (sum alpha_t^k(i))
        sum_alpha = @(alpha) log(sum(alpha(size(alpha,1),:)));
        ll = sum(cellfun(sum_alpha, alpha_list));
    end

    function [alpha_list, beta_list] = alphabeta_list(pi, A, B, O_list)
        alpha_list = cell(1,length(O_list));
        beta_list = cell(1,length(O_list));
        for i = 1:length(O_list);
            [alpha_list{i}, beta_list{i}] = forward_backward(pi, A, B, O_list{i});
        end
    end
end