function [Y] = Test(T,P)

X = [T;P];
%net = TrainLM(net1,net2,net3,net4,net5,net6);
[net1,net2,net3,net4,net5,net6] = TrainLM();
tic %test speed once network is trained
if T < 175 && P < 500
    Y = net1(X);
elseif T < 374 && P < 500
    Y = net2(X);
elseif T < 205 && P < 15.5
    Y = net4(X);
elseif T < 405 && P < 220.7
    Y = net5(X);
elseif T < 805 && P < 220.7
    Y = net6(X);
else
    Y = net3(X); %assume saturated
end
toc
end

