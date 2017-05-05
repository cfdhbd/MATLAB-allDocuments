k1 = 0.02;
k2 = 0.05;
vin = 10;
v1dot = 12;
v2dot = 10;
v1 = 20;
v2 = 100;
v21dot = 2;
cin = 10;
c0 = 0;

conc = @(t,c) [vin/v1*cin + v21dot/v1*c(2) - v1dot/v1*c(1) - k1*c(1);...
    v1dot/v2*c(1) - (v21dot+v2dot)/v2*c(2) - k2*c(2)];

[t,c] = Cb(conc,[0,60],[c0,c0],100);

plot(t,c(:,1),'-*',t,c(:,2),'-o');
xlabel('time (min)'); ylabel('concentration (mol/L)');
grid on