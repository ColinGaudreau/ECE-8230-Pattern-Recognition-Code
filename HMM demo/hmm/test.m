clear all; close all;

L = 120;
O_list = cell(1,L);
lengths = ceil(30 * rand(1,L) + 1);
states = zeros(1,L);

for i = 1:L
    tt = rand();
    if tt <= 0.33
        mult = -2;
        states(i) = 1;
    elseif tt >= 0.66
        mult = 2;
        states(i) = 2;
    else
        mult = 2;
        states(i) = 3;
    end
    tmp = mult*randn(1,lengths(i));
    O = zeros(1,lengths(i));
    O(tmp < -5) = 1;
    O(tmp >= - 5 & tmp < -2) = 2;
    O(tmp >= -2 & tmp < 1) = 3;
    O(tmp >= 1 & tmp < 5) = 4;
    O(tmp >= 5) = 5;
    O_list{i} = O;
end

A = ones(3,3); A = A/sum(A(:));
B = ones(3,5); B = B/5;
pi = ones(1,3); pi = pi/sum(pi);

[npi,nA,nB,conv] = baum_welch(pi, A, B, O_list);