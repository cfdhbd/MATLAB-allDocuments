function Bb()
Vin = 0.002;
L = 1.5;
W = 0.8;
htotal = 0.5;
h0=0;
D = 0.038;
g = 9.81;

overflow = fzero(@func,[1,1000]);
fprintf('time to overflow is: t=%4.2f s\n',overflow);

plot(t,h,'-*');
xlabel('Time (s)'); ylabel('height (m)');

function over = func(x)
    func1 = @(t,h) Vin/L/W - pi*D^2/4/L/W*sqrt(g*h/2.5);
    [t,h] = ode45(func1,[0,x],h0);
    over = h(end)-htotal;
end

end

