clear;
clc;
options = simset('solver','ode45','RelTol',1e-5);
sim('E3',[0,2],options);
x1=tout; y1=simout;
plot(x1,y1,'-o');
xlabel('x');ylabel('y');