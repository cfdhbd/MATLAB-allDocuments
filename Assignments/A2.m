function [x,p,s] = A2()
% 1. exponential cell growth
% 2. perfect mixing
% 3. small heat effect, isothermal
% 4. constant liquid density
% 5. broth is solid + liquid but can be approx as homogenous
% 6. rg = mu*X where mu = mu(max)*S/(Ks+S)
% 7. rate product formation is rp = Y(p/x)*rg where 
%         Y(p/x) = mass product formed/mass new cells formed
% 8. feed stream has no cells

%Example 2.17 from Chapter 2:Theoretical Models of Chemical Processes

%initial conditions
x0 = 0.05; %g/L
p0 = 0; %g/L
s0 = 10; %g/L

%parameters
v = 1; %L
mum = 0.2; % mu max, hr^-1
ks = 1; %g/L
yxs = 0.5; %g/g
ypx = 0.2; %g/g
time = linspace(1,1000,1);
val = zeros(length(time),3); % cell, product, substrate
%val(1,3) = [x0, p0, s0];

for i=1:length(time)
    mu = mum*val(i,3)/(ks+val(i,3));
    rg = mu*val(i,1);
    rp = ypx*rg;
    balance = @(i, val) [v*rg; v*rp; -1/yxs*v*rg];
    [ifinal valfinal] = ode45(balance,[0, i],[x0 p0 s0]);
    if (valfinal(i,3)-s0)/s0 >= 0.9
        valfinal = [valfinal(i,1), valfinal(i,2), valfinal(i,3)];
    end
    hold on
    plot(ifinal,valfinal(i,1),'-o',ifinal,valfinal(i,2),'-*',ifinal,valfinal(i,3),'-.');
end
hold off
xlabel('time (h)'); ylabel('mass g');

end

