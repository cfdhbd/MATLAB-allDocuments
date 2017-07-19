
%Soil Parameters
Hcs_kg = 600; %J/(Kg*K) heat capacity of soil, 3600 is to convert s^2 from J to min^2
Vols = 1; %m3, volume soil
rhos = 1520; %kg/m3 density soil
Hcs = Hcs_kg*rhos; %J/(m3*K) heat capacity soil in m3

%Initial Conditions & ODE parameters
ti = 0;
tguess = 10000;

Abundancy = 5.5e-5; %Kg enzyme / L cell culture
Lcc = 5; %Liter cell
Eo = Abundancy*Lcc; %Kg enzyme initial concentration
Sm3 = 106.988; %mol ClO4-/m3 soil, S stands for substrate
So = Sm3*Vols; %initial mol of ClO4- in reactor
P0 = 0; %initial product

To = 293; %K, room temperature
Po = 0; %atm, vacuum, initial pressure

Rgas = 8.314; %J/molK or m3*Pa/molK

%Enzyme Parameters
Kcat = 7500*60; %e-/min
Km = 2.15e-04; %M

%Bond Enthalpy
CLO = 205; %kJ/mol
OO = 498; %kJ/mol
dH = (CLO*4-OO*2)*1000; %J/mol total enthalpy change during reaction

%Reactor Parameters
Ak = 215; %W/(m*K) thermal conductivity of Alumnium
Va = 3.375; %m3 Volume above soil

%********************************Integration******************************

%Substrate
Sfunc = @(val) So-val(1); %Substrate decreases as product is made, ClO2 --> Cl- + O2 1:1


%@(val) val(1)=product; val(2)=temp; val(3)=pressure; val(4) =...
balance = @(t,val) [Kcat*Eo*Sfunc(val)/(Km+Sfunc(val));...
                    dH/Hcs*Sfunc(val)/Vols;...
                    val(1)*32/1000*Rgas*val(2)/Va/101325+Po];

options = odeset('Events',@events);
[tf,valf,te,ye,ie] = ode45(balance,[ti,tguess],[P0 To Po],options);

subplot(3,1,1), plot(tf, valf(:,1)), xlabel('time (min)'),ylabel('Product (mol)');
subplot(3,1,2), plot(tf, valf(:,2)), xlabel('time (min)'),ylabel('Temp (K)');
subplot(3,1,3), plot(tf, valf(:,3)), xlabel('time (min)'),ylabel('Pressure (atm)');

function [value,isterminal,direction] = events(t,val)  %#ok<INUSL>
So = 106.988; %terminate once val(1), produced O2, equals number mols ClO4- initial
value = (val(1)-So); %detect full conversion%
isterminal = 1; %terminate when value occurs
direction = []; %root can be approached from either direction
end
