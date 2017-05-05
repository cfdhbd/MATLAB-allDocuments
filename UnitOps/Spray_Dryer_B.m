
ti = 0;
g = 9.81; %m/s^2
Hl = 2257*1000;   %latent heat vaporization @ wet bulb temp of air
     %(kJ/kgw)
Rd = 60e-6; %initial droplet radius (m)
Rp = 10e-6;%radius @ critical moisture content (m)
Rs = 1.19; %radius spray dryer
% D = 0.0000282; %effective mass diffusivity (m2/s)
% D50 = 0.917;
% D = D50*exp(-2060*(1/Ta-1/323));
D = 5e-11;
Ka = 0.343; 
Ta = 200+273.15; %air temp of spray dryer (K)
Ts = Ta*0.15; %surface temp droplet  (K), assume 5% less than air
%mc   %moisture removal rate for cnst rate (s^-1)
W0 = 10; %initial moisture content (kg w / kg sol)
Wc = 0.818; %critical moisture content (kg w / kg sol)
a = 12.5473; b = -0.0951; c = 0.1283; Aw = 0.7;
%We = (a + b*(Ta-273.15))*(Aw/(1-Aw))^c; %equilibrium moisture content (kg w /kg sol)
We = 0.04;
Wf = 0.042; %final moisture content
tf = (Hl*(W0-Wc)/(4*pi*60*Rd*Ka*(Ta-Ts)))*1000*4/3*(Rd)^3*pi*0.05...
     + (Rp^2/(pi^2)/D)*log(6/(pi^2)*(Wc-We)/(Wf-We));
 
usd = Rs/tf; %spray dryer droplet speed = rad spray dryer / tfdrying

%falling droplet starting at 0 speed
ufd = g*tf;

upercent = (usd)/ufd*100; %spray droplet is 9% of normal

Vd = Rd^3*pi*4/3;
Vair = Rd^2*pi*Rs; %distance is dist droplet falls ~Rs...time that the air is acting on droplet
Vair = sqrt(1000*Vd*(ufd^2-usd^2)/1.225/Vair);


