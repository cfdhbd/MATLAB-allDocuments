function [x,y] = Aa(func,xlim,y0,steps)
%AA Summary of this function goes here
%   euler is 4 steps
% x(i+1) = xi + dx
% y(i+1) = yi + f(xi,yi)*dx
% yi = y(i+1)
% xi = x(i+1)
%xlim is [beg,end], func is function handle, step is #, y0 is initial

y = zeros(steps+1,1);
y(1) = y0;
x = linspace(xlim(1),xlim(2),steps+1);
dx = (xlim(2)-xlim(1))/steps;
for i = 1:steps
    y(i+1) = y(i)+func(x(i),y(i))*dx;
end

end

