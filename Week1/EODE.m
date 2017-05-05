% dy/dx = -5yx

func = @(x,y) -5*x*y;
[x1,y1] = ode45(func,[0 3], 3);
[x2,y2] = ode15s(func,[0 3],3);
subplot(1,2,1);
plot(x1,y1,'*');
subplot(1,2,2);
plot(x2,y2,'o');
