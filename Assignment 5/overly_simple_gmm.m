function theta = overly_simple_gmm(xdata, theta_0, varargin)
% Solution for Assignment 5 problem 5.

if nargin > 1
    plot_progress = varargin{1};
else
    plot_progress = false;
end

MAX_ITERATION = 10000;
EPSILON = 1e-5;

gauss = @(x,mu,sigma) 1/sqrt(2*pi*sigma^2) * exp(-(x - mu).^2 ./ (2*sigma^2));

mixture = @(x,theta) gauss(x,0,1)/2 + gauss(x - theta,0,1)/2;

if plot_progress
    figure;
    xx = linspace(min(xdata),max(xdata), 200);
end

for i = 1:MAX_ITERATION
    if plot_progress
        subplot(2,1,1);
        plot(xx, mixture(xx, theta_0), '-b'); hold on;
        plot(xdata, 0, 'or'); hold off;
        subplot(2,1,2), hold on;
        plot(i,theta_0,'ob','linewidth',2);
        xlabel('Iteration'); ylabel('Value of Estimate');
        drawnow;
    end
    
    W_i = gauss(xdata - theta_0, 0, 1)/2 ./ mixture(xdata, theta_0);
    theta_new = sum(W_i.*xdata)/sum(W_i);
    
    if abs(theta_new - theta_0) < EPSILON
        break;
    end
    
    theta_0 = theta_new;
end

theta = theta_new;

end