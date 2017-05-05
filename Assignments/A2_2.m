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
t = 0;
%parameters
v = 1; %L
mum = 0.2; % mu max, hr^-1
ks = 1; %g/L
yxs = 0.5; %g/g
ypx = 0.2; %g/g
tguess = 100; %guess for final time

%mu = mum*val(3)/(ks+val(3)); %rg = mu*val(1); %rp = ypx*rg;
balance = @(t, val) [v*mum*val(3)/(ks+val(3))*val(1);...
    v*ypx*mum*val(3)/(ks+val(3))*val(1);...
    -1/yxs*v*mum*val(3)/(ks+val(3))*val(1)];

options = odeset('Events',@events,'OutputFcn',@odeplot);
[tf,valf,te,ye,ie] = ode45(balance,[1,tguess],[x0 p0 s0],options); 
xlabel('time (hr)'); ylabel('concentration (g/g');
legend('[Cell]','[Product]','[Substrate]','Location','Northeast');
 
function [value, isterminal, direction] = events(t,val) %#ok<INUSL>
s0=10;
value = (val(3)-s0)/s0 + 0.9; %detect 90%
isterminal = 1; %terminate when value occurs
direction = []; %root can be approached from either direction
end