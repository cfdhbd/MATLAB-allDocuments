function [x,y] = Cb(func,xlim,y0,steps)
%CB Summary of this function goes here
%   general Euler that takes ANY ODE
n = length(y0);
dx = (xlim(2)-xlim(1))/steps;
y = zeros(steps+1,n);
x = linspace(xlim(1),xlim(2),steps+1);
y(1,:)=y0;

for i = 1:steps
    y(i+1,:) = y(i,:) + reshape(func(x(i),y(i,:)),1,n);
end

end

