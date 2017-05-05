vin = 1000;
vr = 1;
vout = 1000;
v1 = 1000;
v2 = 500;
v3 = 1200;
cin = 100;
k = 0.1;
vrt = [1;100;250;500;1000;2500;5000;10000];
%conc = zeros(length(vr),3);

for i = 1:length(vr)
    vr = vrt(i);
    conc = @(t,c) [(vin*cin+vr*c(3)-(vin+vr)*c(1))/v1-k*c(1)^2;...
    ((vin+vr)*c(1)-(vin+vr)*c(2))/v2-k*c(2)^2;...
    (vr*c(2)-vr*c(3))/v3-k*c(3)^2];
    [t1,c1] = ode45(conc,[0,2],[0,0,0]);
    hold on;
    plot(t1,c1(:,2),'-o');
    %lengendInfo{i} = ['vr = ', num2str(vr)];
end

hold off
%legend(legendInfo);        %FOR some reason legend info doesn't work
xlabel('time h');ylabel('c2');