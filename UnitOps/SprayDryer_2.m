%model assumptions:
%assume each droplet is not affected by the next
% notation: N1, S2, E3, W4 for node directions N is north for example
rpm = 466.67; %rotation per second 
i=1;
cp = 1.996; %kJ/(kg*K)
cv = 0.718;
control = 100; %# of control volumes
timerange = linspace(0,control,dt); %seconds
%dt = 1/control;
Po = 0; %Pa vacuum at bottom
Pi = 101325*2; %Pa, assuming it is 2 atm at outlet....(guessed)
P = linspace(Pi,Po,control); %pressure increments from vacuum to outlet
dP = (Pi-Po)/control;
Tiair = 200; %degC air
Toair = 95; %degC air
Tair = linspace(Tiair,Toair,control); %temp increments from top to bottom
dTair=(Tiair-Toair)/control; %assume air temp diff is linear downwards
mu = 0.00089; %dynamic viscosity, water, Pa*s
Lvap = 2257; %kJ/kg
kw = 0.6; % W/(m*K)
kair = 0.343; %W/(m*K)
Dsh = 0.0000282; %m2/s diff coeff of water to air for sherwood
kmasstrans = 1; %guessed for sherwood number
xoo = 0.1; %humidity air guess (mass frac vap free stream) @ infinity
%dmass(1) = 0; may not be necessary
%dmd = 0;
rhow = 1000; %water, kg/m3
dtank = 1; %1 m diameter tank

%nozzle dimensions
dprime = 0.119; 
circ = pi()*dprime; %nozzle circumference
nprime = 24;
hprime = 0.0076;
rotspeed = rpm/60*circ; %speed of rotation
% initial droplet parameters
v = 0.005; %assume gas velcity, due to pressure difference

%preallocations for speed
dmass = zeros(1,control);
dop = zeros(1,control);
A = zeros(1,control);
u = zeros(1,control);
Re = zeros(1,control);
Cdo = zeros(1,control);
Cd = zeros(1,control);
xdrop = zeros(1,control);
hv = zeros(1,control);
Tdrop = zeros(1,control);
unew = zeros(1,control);
dmod = zeros(1,control);
dmd = zeros(1,control);
ded = zeros(1,control);
%theta = zeros(1,control);
hd = zeros(1,control);

for n = 1:5 %initial diameter
    d(1) =0.001; d(2)=0.004; d(3) = 0.008; 
    d(4) = 0.01; d(5) = 0.012;
    
    for i=2:control
        %initialize parameters
        dop(1) = d(n);
        dmass(1) = 1/6*pi()*dop(1)^3*rhow;
        Fc = dmass(1)*rotspeed^2/(dprime/2); %initial centrifugal force
        u(1) = sqrt(Fc*2/dmass(1)); %initial speed
        xdrop(1)=0; %0m is at nozzle in center
        Tair(1) = Tiair;
        Tdrop(1) = 25; %degC
        dmd(1) = 0; %no change
        
        %droplet
        dmass(i) = dmass(i-1)-dmd(i-1);
        dop(i) = nthroot(dmass(i)/rhow*6/pi(),3);  %operating diameter
        A(i) = pi()*dop(i)^2; %surface area for transfer
        
        Re(i) = rhow*abs(v-u(i-1))*dop(i)/mu;
        Cdo(i) = (Re(i)/24)*(1+0.15*Re(i)^0.687);
        Cd(i) = Cdo(i)/(1+cv*dTair/Lvap);
        ft = Cd(i)*Re(i)/24;
        tau = rhow*dop(i)^2/18/mu/ft;
        u(i) = v-(v-u(1))*exp(-dt/tau)+9.81*tau*(1-exp(-dt/tau)); %u is droplet velocity
        
        Pr = mu*cp/kw; %i think it is kw...as it is pr of droplet
        
        xdrop(i) = xdrop(1) + (u(i)+u(1))*dt/2;
        Nu = 2+0.6*Re(i)^(0.5)*Pr^(0.33);
        q = Nu*pi()*kair*dop(i)*(Tair(i-1)-Tdrop(i-1));
        Sh = kmasstrans/Dsh*dop(i);
        Pv = 0.61121*exp((18.678-Tdrop(i-1)/234.5)*(Tdrop(i-1)...
            /(257.14+Tdrop(i-1)))); %partial vapour pressure using Bucks Eqn
        xv = Pv*16/(29-(29-16)*Pv); %29 and 16 are molar masses
        
        QL = Lvap*Sh*rhow*dop(i)*(xv-xoo)/Nu/kair;
        theta = rhow*dop(i)^2*Cd(i)/6/Nu/kair;
        
        constant = dt/theta;
        Tair(i) = Tair(1)-i*dTair; %linear gradient starting at 200 to 95
        Tdrop(i) = Tair(i)-(Tair(i)-Tdrop(1))*exp(-constant)-...
            QL*(1-exp(-constant));
        
        
        %Tdiff = Tdrop(i)-Tair(i);
        
        %PSI-Cell
        Xi = 1; %frac droplet enter j...assuming
        Yi = dmass(i)/dmass(1); %frac drop mass w/ di
        mp = dmass(i)*Xi*Yi;
        ni = 6*mp/(pi()*rhow*dop(1)^3);
        dmd(i) = pi()*rhow*ni*(dop(i)^3-dop(i-1)^3)/6; %i is out, i-1 is in
        dmod(i) = pi()*rhow*ni*(u(i)*dop(i)^3-u(i-1)*dop(i-1)^3)/6;
        hv(1) = q/dmass(1);
        hv(i) = q/dmass(i);
        hd(1) = hv(1)-Lvap;
        hd(i) = hv(i)-Lvap;
        ded(i) = pi()*rhow*ni*(hd(i)*dop(i)^3-hd(i-1)*dop(i-1)^3)/6;
        
        dmass(i) = dmass(i) - dmd(i); %1/6*pi()*dop(i)^3*rhow
        u(i) = u(i)-dmod(i);
        Tdrop(i) = Tdrop(i) - ded(i);
        
        udroplet(i,n) = u(i);
        ddroplet(i,n) = dop(i);
        Tdroplet(i,n) = Tdrop(i);
        dropletmass(i,n) = dmass(i);
        dropletdistance(i,n) = xdrop(i);
        dropletdistance(1,n) = xdrop(1);
        ratio(1,n) = xdrop(1);
        ratio(i,n) = xdrop(i)/dtank;
    end
    
end

plot(ratio(:,2),dropletdistance(:,2),'-*');
%plot(dropletdistance(:,2),udroplet(:,2));


%         for n = 1:4  %1through4 for 4 faces of control volume
%             Uw = u(i); %velocity within the cell
%             Tw = Tair(i); % temp within
%         
%             %mass
%             G(n) = u(i)*A(i)*rhow;
%         
%         
%             %momentum X dir
%             Re(n) = rhow*u(n)*dop/mu;
%             fo(n) = exp(Re(n))/(exp(Re(n))-1);
%             Mo(n) = G(n)*(fo(n)*u(n)+(1-fo(n))*Uw);
%             
%         
%             %energy
%             pe(n) = dop(i)*u(n)/(kw*rhow*cp); %peclet #, Re*Pr
%             fe(n) = exp(pe(n))/(exp(pe(n))-1);
%             E(n) = G(n)*cp*(fe(n)*Tair(n)+(1-fe(n))*Tw);
%         
%         end
%         ded = [E(1);E(2);E(3);E(4)]; %delta energy flux for each face
%         dmd = G(2)+G(4)-G(1)-G(3); %delta mass efflux rate AKA conversion of liq to gas phase
%         dmod = -Mo(1)+Mo(2)-Mo(3)+Mo(4)+dP*A(i);     %delta momentum efflux rate %the O is for mOmentum



