Vdot = 1000;
Cin = 100;
k = 0.1;
C4 = 10;

xinit = [50;50;50;100];
funcs = @(x) [Vdot*Cin - Vdot*x(1) - k*x(1)^2*x(4);...
    Vdot*x(1) - Vdot*x(2) - k*x(2)^2*x(4);...
    Vdot*x(2) - Vdot*x(3) - k*x(3)^2*x(4);...
    Vdot*x(3) - Vdot*C4 - k*C4^2*x(4)];

x = fsolve(funcs,xinit);

variables = {'C1';'C2';'C3';'V'}; 
values = x;
table(values,'RowNames',variables)
