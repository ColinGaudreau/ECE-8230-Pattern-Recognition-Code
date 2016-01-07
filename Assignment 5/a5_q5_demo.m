num = 100;
theta = 5; theta_0 = -1;
xdata = cat(2,randn(1,num),randn(1,num) + theta);
theta_em = overly_simple_gmm(xdata, theta_0, true);