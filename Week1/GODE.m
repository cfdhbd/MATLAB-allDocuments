
k1 = 1;
k2 = 0.2;
k3 = 0.05;
k4 = 0.1;
Ao = 1;

func = @(~,y) [-k1*y(1) - k2*y(2) + k3*y(3);...
    2*k1*y(1) - k4*y(2);...
    k2*y(1) - k3*y(3) + k4*y(2)];

options = odeset('RelTol',1e-5);
[x1,y1] = ode45(func, [0 20], [1,0,0], options);

plot(x1, y1(:,1), '-*', x1,y1(:,2),'-+', x1,y1(:,3),'-o');
xlabel('Time (min)');
ylabel('Concentration (mol/L)');


% note, this graph does not take into account D
