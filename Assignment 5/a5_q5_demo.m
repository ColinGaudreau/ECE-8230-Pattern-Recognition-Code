theta = 5; theta_0 = -1;
xdata = cat(2,randn(1,1000),randn(1,100) + theta);
theta = overly_simple_gmm(xdata, theta_0, true);