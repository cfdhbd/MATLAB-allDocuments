
steps = 20;
boundary = [0,0.5];
cd = 0.5;
dx = (boundary(2)-boundary(1))/steps;
rhos = 2500;
rhof = 1000;
rads = 0.005;
g = 9.81;
u0 = 0;

%numerical
func = @(t,u) g-rhof*g/rhos - 3*rhof*u^2*cd/(8*rhos*rads);
[t,u] = Aa(func,u0,boundary,steps);

%analytical
A = sqrt(g-rhof*g/rhos);
B = sqrt(3*rhof*cd/(8*rhos*rads));
time = 0:0.005:0.5;
uana = A*tanh(A*B*time)/B;

%plot
plot(t,u,'-*',time,uana,'-o');
xlabel('time');
ylabel('velocity');
legend('Euler''s method', 'Analytical');
grid on;
