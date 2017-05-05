function D()
%D Summary of this function goes here
%   Detailed explanation goes here
v1 = 1*10^7; %m3
v2 = 8x10^6;
v3 = 5*10^6;
vdot = 4*10^6;
cin = 0;
c1 = [0,15,11,7,6,8,12,16,20];
c2 = [0,3,5,7,7,6,4,2];
c3 = [100,48,26,16,10,4,3,2];
time = [0,2,4,6,8,12,16,20];

    function objective(@int, 



    function int(d1,d2)
conc = @(t,c) [-vdot/v1*c(1)+d1/v1*(c(2)-c(1)) + d2/v1*(c(3)-c(1));...
    d1/v2*(c(1)-c(2));...
    d2/v3*(c(1)-c(3))];
[t,c] = ode45(conc,[0,20],c(1,:));
    end




end

