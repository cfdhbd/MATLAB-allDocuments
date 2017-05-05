Vin = 0.002;
L = 1.5;
W = 0.8;
h0 = 0.5;
D = 0.038;
g = 9.81;



uout = @(h) sqrt(g*h/2.5);
func = @(t,h) Vin/L/W - pi*D^2/4/L/W*uout(h);
[t,h] = ode45(func,[0,900],h0);

plot(t,h,'*');
xlabel('time (s)'); ylabel('height (m)');

grid on;