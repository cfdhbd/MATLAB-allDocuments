Vdot = 2.5;
V = 70;
rho = 1000;
cp = 4.184;
Tinf = 30; %degC
UA = 10;
T0 = 30; %init temp
C1 = Vdot/V;
C2 = UA/rho/V/cp*3600;

func = @(t,T) C1*((10*sin(t)+60)-T)-C2*(T - Tinf);
options = odeset('RelTol', 1e-5);
[t,T] = ode15s(func,[0, 50], T0, options);

plot(t,T,'o-');
xlabel('Time (h)');
ylabel('Temperature (C)');
ylim([28,38]);
grid on;

