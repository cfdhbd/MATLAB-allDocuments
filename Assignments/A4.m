%PDE of falling film evaporator 
Ts = 328; %K
L = 1.64; %m
cpw = 4187; % J/(kg K), cp water 
cpwv = 1996; %J/(kg K), cp water vapour
muw = 0.5e-3; % Pa s
rhow = 1000; %kg/m3
gz = 9.81; %m/s^2 falling
condcop = 400; %W/(m K) thermal conductivity copper
Areacyl = 0.165; %m^2
iter = 10;


Tg = condcop*Ts/Areacyl; %W/m^3



sol = pdepe(1, 
