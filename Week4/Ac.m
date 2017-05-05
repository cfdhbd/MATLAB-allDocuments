function Ac()
%AC Summary of this function goes here
%   Detailed explanation goes here

k = 1.5;
h = 50;
Too = 25;
L=0.1;
q = 6e5;
n = 20;
x = linspace(0,L,n);

bcFunc = @(yL,yR) [yL(2); yR(2)+h/k*(yR(1)-Too)];

odeFunc = @(x,y) [y(2); -q*x/k];

solinit = bvpinit(x,[Too,0]);
sol = bvp4c(odeFunc,bcFunc, solinit);

plot(sol.x,sol.y(1,:),'o-');
xlabel('Position (m)'); ylabel('Temperature, T (C)');

end

