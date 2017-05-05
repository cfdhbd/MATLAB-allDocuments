function H()

mump = 0.24;
mumb = 0.25;
kb = 4e8;
ks = 5e-4;
yxpb=7.14e-4;
yxbs = 3.03e9;
D = 0.0625;
Sin = 0.5;
xp0 = 1.4e4;
xb0 = 1.6e9;
s0 = 0;
%write [] profiles on 3 plots for 15-day period
%use ode15s

[t,C] = ode15s(@odeFunc,[0,15*24],[xp0,xb0,s0]);

t = t/24;
figure(1); plot(t,C(:,1));
xlabel('Time, t (d)'); ylabel('Protozoa Concentration, X_{p} (cells/mL)');
figure(2); plot(t,C(:,2));
xlabel('Time, t (d)'); ylabel('Bacteria Concentration, X_{b} (cells/mL)');
figure(3); plot(t,C(:,3));
xlabel('Time, t (d)'); ylabel('Substrate Concentration, S (mg/mL)');


    function res = odeFunc(~,y)
        res = zeros(3,1);
        res(1) = -D*y(1) + mump*y(2)*y(1)/(y(2)+y(1));
        res(2) = -D*y(2) + mumb*y(3)*y(2)/(ks+y(3)) - 1*mump*y(2)*y(1)/(yxpb*(y(2)+y(2)));
        res(3) = D*(Sin - y(3)) - 1*mumb*y(3)*y(2)/(yxbs*(ks+y(3)));
    end


end

