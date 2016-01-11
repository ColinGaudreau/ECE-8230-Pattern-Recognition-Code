% Part 3, Problem 1

normal = @(x,y,mux,muy,sigx,sigy,rho) 1./(2*pi*sigx*sigy*sqrt(1-rho^2)).*...
    exp(-1/(2*(1-rho)^2).*((x-mux).^2./sigx^2 + ...
    (y-muy).^2./sigy^2 + 2*rho*(x-mux).*(y-muy)./(sigx*sigy)));

x = linspace(-5,5,200); y = x; [x,y] = meshgrid(x,y);

mixture = (normal(x,y,0,0,1,1/sqrt(2),0) + ...
    normal(x,y,1,1,1/sqrt(2),1,0) + ...
    normal(x,y,2,2,1,1/sqrt(2),0))/3;

figure, surf(mixture);

input('Continue...');

mixture = (normal(x,y,0,0,1/10,1/10,0) + ...
    normal(x,y,1,1,1/10,1/10,0) + ...
    normal(x,y,2,2,1/10,1/10,0))/3;

surf(mixture);

input('Continue...');

mixture = (normal(x,y,0,0,3,3,0) + ...
    normal(x,y,1,1,3,3,0) + ...
    normal(x,y,2,2,3,3,0))/3;

surf(mixture);
