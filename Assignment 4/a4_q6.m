D = 5;
% del = [1,2,5,10]; rho = [-.8,-.1,.1,.8];
del = linspace(0.1,10,1000); rho = linspace(-.99,.99,1000);

R_nb_rho = zeros(1, length(rho));
R_nb_del = zeros(1, length(del));
ind = 1;
for r = rho
    cov_mat = r * ones(D);
    mean_mat = del(3) * ones(D,1);
    mu = mean_mat' * mean_mat;
    var = mean_mat' * (cov_mat - mean_mat * mean_mat') * mean_mat;
    R_nb_rho(ind) = 1/4 * corr_erfc(mu/var) + 1/4 * corr_erfc(mu/var);
    ind = ind + 1;
end
ind = 1;
for d = del
    cov_mat = -0.01 * ones(D); % do for 0.2 valued rho
    mean_mat = d * ones(D,1);
    mu = mean_mat' * mean_mat;
    var = mean_mat' * (cov_mat - mean_mat * mean_mat') * mean_mat;
    R_nb_del(ind) = 1/4 * corr_erfc(mu/var) + 1/4 * corr_erfc(mu/var);
    ind = ind + 1;
end

figure,
subplot(2,1,1);
plot(rho,R_nb_rho, '-b', 'linewidth', 2);
xlabel(['\rho, \delta = ' num2str(del(3))]); ylabel('Risk');
axis([min(rho) max(rho) 0 1]);
subplot(2,1,2);
plot(del,R_nb_del, '-r', 'linewidth', 2);
xlabel('\delta, \rho = -0.01'); ylabel('Risk');
axis([min(del), max(del), 0, 1]);