
steps = 20;
boundary = [0,0.5];
dx = (boundary(2)-boundary(1))/steps;
rhos = 2500;
rhof = 1000;
rads = 0.005;
g = 9.81;
u0 = 0;
mu = 0.001;

%numerical
Re = @(u) rhof*u*2*rads/mu;
cd = @(u) 24/(Re(u)+1e-12) *(1+0.18006*Re(u)^0.6459)+0.4251/(1+6880.95/(Re(u)+1e-12));
func = @(t,u) g-rhof*g/rhos - 3*rhof*u^2*cd(u)/(8*rhos*rads);
[t,u] = Aa(func,u0,boundary,steps);

%plot
plot(t,u,'-*');
xlabel('time');
ylabel('velocity');
legend('Euler''s method');
grid on;
