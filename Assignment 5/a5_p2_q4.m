clear all; close all;
phi = @(x,z,rho) 1./(2 * pi * sqrt(1 - rho.^2)) .* ...
    exp(-(x.^2 - 2*rho*x.*z + z.^2)./(2*(1 - rho.^2)));
mixture = @(x,z,pi,rho1,rho2) pi * phi(x,z,rho1) + (1-pi)*phi(x,z,rho2);

[x,z] = meshgrid(linspace(-5,5,100),...
    linspace(-5,5,100));

dist = mixture(x,z,1/2,1/2,-1/2);

figure, contour3(dist,20);
box on;