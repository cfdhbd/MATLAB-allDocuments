%model assumptions:
% notation: N1, S2, E3, W4 for node directions N is north for example
rpm = 466.67; %rotation per second
i=0;
cp = 1.996; %kJ/(kg*K)
vol = zeros(100,100,100); %# of control volumes
timerange = [0,100]; %seconds
Pi = 0; %Pa
Po = 101325*2; %Pa, assuming it is 2 atm at outlet....(guessed)
P = linspace(Pi,Po,vol); %pressure increments from vacuum to outlet
Ti = 200; %degC
To = 95; %degC
T = linspace(Ti,To,vol); %temp increments from top to bottom


%nozzle dimensions
dprime = 0.119; 
nprime = 24;
hprime = 0.0076;
rhow = 1000; %water, kg/m3
% initial droplet parameters


for d = [0.001, 0.0025, 0.005, 0.01] %initial diameter
    for i=1:vol
        %initialize
        dop(1) = d;
        dmass(1) = 1/6*pi()*dop(1)^3*rhow;
        dmass(i) = dmassnew(i);
        dop(i) = nthroot(dmass(i)/rhow*6/pi(),3);  %operating diameter
        A = pi()*dop()^2; %surface area for transfer
        dP = P(i-1)-P(i);
        
        %call function
        call balances
        
        dmassnew(i) = 1/6*pi()*dop(i)^3*rhow - dmd;
    end
end


function [] = balances(u(:),T(:),A(:),cp,dop(i),dP)
k = 0.6; % W/(m*K)
Uw = mean(u(:)); %velocity within the cell
Tw = mean(T(:)); % temp within
    for n = 1:4  %1through4 for 4 faces of control volume
        %mass
        G(n) = u(n)*A(n)*rhow;
        
        
        %momentum X dir
        Re(n) = rhow*u(n)*dop/mu;
        fo(n) = exp(Re(n))/(exp(Re(n))-1);
        M(n) = G(n)*(fo(n)*ux(n)+(1-fo(n))*Uw;
        
        %energy
        pe(n) = L*u(n)/(k*rhow*cp); %peclet #, Re*Pr
        fe(n) = exp(pe(n))/(exp(pe(n))-1);
        E(n) = G(n)*cp*(f(n)*T(n)+(1-f(n))*Tw);
        
    end
ded = [E(1);E(2);E(3);E(4)]; %delta energy flux for each face
dmd = G(2)+G(4)-G(1)-G(3); %delta mass efflux rate AKA conversion of liq to gas phase
dmod =      %delta momentum efflux rate %the O is for mOmentum

end


