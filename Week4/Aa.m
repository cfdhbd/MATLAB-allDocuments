Too = 25;
h = 50;
k = 1.5;
rho = 2500;
cp = 850;

Tx0 = 0;
Tguess = 30;

x0 = 0;
L = 0.1;

A = 6e5;

%y(1) =T, y(2) = f

options = odeset('Events',@events,'OutputFcn',@odeplot);
func =@(x,y) [y(2);-A*x/k];
[x,T] = ode45(func,[0,L],[Tguess, Tx0]);
   


function [value, isterminal, direction] = events(t,y) %#ok<INUSL>
    h = 50;
    Too = 25;
    value = T(end,2) - (-h/k*(T(end,1)-Too)); %detect 90%
    isterminal = 1; %terminate when value occurs
    direction = []; %root can be approached from either direction
end