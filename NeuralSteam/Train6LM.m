function [net6] = Train6LM(superval)
%using matlabs traingrad function

X = transpose(superval(2025:4028,1:2)); %X is 1xcount, inputs are T;P
T = transpose(superval(2025:4028,3:7)); % outputs are Tsat V U H S

%net.trainFcn = 'trainlm'; %uses Levenberg-Marquardt optimization
net6 = feedforwardnet(30,'trainlm');
net6 = train(net6,X,T); % X is input, T is target
%view(net3)
%Y = net3(X); % Y is new outputs
%perf = perform(net3,T,Y); 

end

