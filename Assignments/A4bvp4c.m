function A4bvp4c()
%PDE of falling film evaporator
%==========================Initialize==========
%initialize evaporator
L = 1.64; %m
cpw = 4187; % J/(kg K), cp water 
cpwv = 1996; %J/(kg K), cp water vapour
muw = 0.5e-3; % Pa s
rhow = 1000; %kg/m3
gz = 9.81; %m/s^2 falling
condcop = 400; %W/(m K) thermal conductivity copper
Areacyl = 0.165; %m^2
nl = 10;
dl = linspace(0,L,nl); %length sections

timespan = linspace(0,5,3); %time independent but pde requires time
%initialize velocity var
uvap = -0.25;
%initialize temp var
Tinit = 20+273; %K
Twall = 50+273;
Tg = condcop*Twall/Areacyl; %W/m^3
Tvap = 50+273;

%film thickness
% for count = 1:10
% sig(count) = 0.0015-count*0.00011; %1 cm
sig = 0.0015; 
%sig(2) = 0.001;
nx = 100;
meshU = linspace(0,sig,nx);
meshT = linspace(0,sig,nx);
%======================SOLVE===================
%==Note: only have T solvable currently, for each sig. Changed the code 
%around for each graph.


%velocity pde, where y is u, velocity (m/s)
odeFuncU = @(x,y) [y(2); gz*rhow/muw];
bcFuncU = @(yL,yR) [yL(1);yR(1)-uvap];
solinitU = bvpinit(meshU,[0,uvap]);
solu = bvp4c(odeFuncU,bcFuncU,solinitU);

%temp pde
 m = 1;
  solT = pdepe(m,@pdeFuncT,@icFuncT,@bcFuncT,meshT,timespan);

%plot
hold on
plot(solu.x,solu.y(1,:),'-');
xlabel('Position, x (m)'); ylabel('velocity, u (m/s)');

yyaxis right
plot(meshT,solT(1,:),'-')
xlabel('Position, x (m)'); ylabel('Temperature, T (K)');

%end

    function [c,f,s] = pdeFuncT(meshT,t,T,dTdX)
        c = 0;
        f = condcop*dTdX;
        s = Tg;
    end

    function T0 = icFuncT(r)
        T0 = Tinit; %+ count*2.5;
    end
    function [pL,qL,pR,qR] = bcFuncT(rL,TL,rR,TR,t)
        pL = TL-Tinit; qL = 0;
        pR = TR-Tvap; qR = 0;
    end

end

% pdeFuncT = @(meshT,t,T,DTDx) [0,meshT*condcop*dTdx,Tg]; 
% icFuncT = @(x) Tinit;
% bcFuncT = @(xL, TL, xR, TR, t) [Ts,0,Tvap,0];
