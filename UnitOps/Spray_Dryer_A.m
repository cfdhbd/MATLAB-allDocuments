%Group 1, Spray_Dryer_A Lab, Dalhousie 2017.
%Based on Particle-Source-In-Cell model developed by Crowe, 1977.


ti = 0;
tguess = 0.25; %seconds, to is end

%tank parameters
Po = 0; %Pa vacuum at bottom
Pi = 101325; %Pa, assuming it is 2 atm at outlet....(guessed)
%P = linspace(Pi,Po,control); %pressure increments from vacuum to outlet
%dP = (Pi-Po)/control;
dtank = 1; %1 m diameter tank
v = 1; %gas flow

Tiair = 200+273.15; %K air
Toair = 95+273.15; %K air

%nozzle parameters
dprime = 0.119; 
circ = pi()*dprime; %nozzle circumference
nprime = 24;
hprime = 0.0076;
rps = 466.67; %rotation per second %speed of rotation

%water parameters
mu = 0.00089; %dynamic viscosity, water, Pa*s
Lvap = 2257; %kJ/kg
kw = 0.6; % W/(m*K)
cp = 1.996; %kJ/(kg*K)
cv = 0.718;
rhow = 1000; %water, kg/m3
cd = 1.996; %kJ/KgK 


%air parameters
kair = 0.343; %W/(m*K)
Dsh = 0.0000282; %m2/s diff coeff of water to air for sherwood
kmasstrans = 1; %guessed for sherwood number
xoo = 0.002; %humidity air guess (mass frac vap free stream) @ infinity
xv = 0.99;

%v = 0.005; %assume gas velcity, due to pressure difference
%initial parameters


for n = 1:3 %initial diameter
    d(1) =0.001; d(2)=0.0015; d(3) = 0.002; 
   
    d0 = d(n);
    dmass0 = 1/6*pi()*d0^3*rhow;
    
    %Fc0 = dmass0*rotspeed^2/(dprime/2); %initial centrifugal force
    Anozzle = 24*hprime^(2)*pi()/4;
    u0 = 10/3600/1000/Anozzle;% m/s
    xdrop0 = 0; %0m is at nozzle in center
    Tair0 = Tiair;
    Tdrop0 = 25+273.15; %K
    dmd0 = 0; %no change
    
    %motion parameters
    Re = @(p) rhow*(v-p(1))*p(3)/mu;
    Cdo = @(p) (Re(p)/24)*(1+0.15*Re(p)^0.687);
    Cd = @(p) Cdo(p)/(1+cv*(Tair0-p(4))/Lvap);
    f = @(p) Cd(p)*Re(p)/24;
    
    %mass & diameter parameters
    Sc = @(p) mu/(rhow*p(3));
    Sh = @(p) 2+0.6*Re(p)^(0.5)*Sc(p)^0.33;
   
    %heat parameters
    Pv = @(p) 0.61121*exp((18.678-p(4)/234.5)*(p(4)...
            /(257.14+p(4)))); %partial vapour pressure using Bucks Eqn
    xv = @(p) Pv(p)*18/(29-(p(2)-29)*Pv(p)); %29 and 16 are molar masses
    %tried to use this but think something is wrong with my partial
    %pressure....works now
    Pr = mu*cp/kw; %i think it is kw...as it is pr of droplet
    Nu = @(p) 2+0.6*Re(p)^(0.5)*Pr^(0.33);
    q = @(p) Nu(p)*pi()*kair*p(3)*(Tair0-p(4));
    QL = @(p) Lvap*Sh(p)*rhow*Dsh*(xv(p)-xoo)/(Nu(p)*kair);
    theta = @(p) rhow*p(3)^2*cd/(6*Nu(p)*kair);
    
    
    %p stands for parameter
    % p(1) = u m/s, p(2) = mass kg, p(3) = diameter m, p(4) = Temp K
    balance = @(t,p) [18*mu*f(p)/(rhow*p(3)^2)*(v-p(1))+9.81;...
            -Sh(p)*rhow*Dsh*pi()*p(3)*(xv(p)-xoo);...
            -2*Sh(p)*rhow*Dsh*(xv(p)-xoo)/(rhow*p(3));...
            (Tair0-p(4))/theta(p)-QL(p)/theta(p)];
    options = odeset('Events',@events);
    %[tf,pf] = ode15s(balance,[ti,tguess],[u0 dmass0 d0 Tdrop0]); 
    [tf,pf,te,ye,ie] = ode15s(balance,[ti,tguess],[u0 dmass0 d0 Tdrop0],options);
    %above calls 'options' which terminates integration once Tdroplet = 95
    %which is the outlet temp we measured
    
   
    subplot(5,1,1), plot(tf, pf(:,1)), hold on; xlabel('time (s)'),ylabel('speed (m/s)');
    subplot(5,1,2), plot(tf, pf(:,2)), hold on; xlabel('time (s)'),ylabel('mass (kg)');
    subplot(5,1,3), plot(tf, pf(:,3)), hold on; xlabel('time (s)'),ylabel('diameter (m)');
    subplot(5,1,4), plot(tf, pf(:,4)), hold on; xlabel('time (s)'),ylabel('Temp droplet (K)');
    drawnow
%       id = 'MATLAB:plot:IgnoreImaginaryXYPart';
%       warning('off',id)
end



function [value, isterminal, direction] = events(t,p) %#ok<INUSL>
value = p(2) ; %detect 0 
isterminal = 1; %terminate when value occurs
direction = []; %root can be approached from either direction
end

