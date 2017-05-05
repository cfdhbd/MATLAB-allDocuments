function V =C2(T,P)
%V Summary of this function goes here
%   Detailed explanation goes here
TC = 405.65;
PC=11280000;
omega=0.2526;
Rgas=8314;
Tr = T/TC;
a=0.42747*(Rgas)^2*TC^2/PC;
b=0.08664*Rgas*TC/PC;
m=0.48508+1.55171*omega-0.1561*omega^2;
alpha = (1+m*(1-(Tr)^0.5))^2;

func = @(x) P - Rgas*T/(x-b)+alpha*a/x/(x+b);
V = fzero(func,1);

end

