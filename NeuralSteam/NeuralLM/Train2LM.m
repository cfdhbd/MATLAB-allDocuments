function [net2] = Train2LM(subval)
%using matlabs traingrad function

X = transpose(subval(481:860,1:2)); %X is 1xcount, inputs are T;P
T = transpose(subval(481:860,4:7)); % outputs are V U H S

%net.trainFcn = 'trainlm'; %uses Levenberg-Marquardt optimization
net2 = feedforwardnet(20,'trainlm');
net2 = train(net2,X,T); % X is input, T is target
%view(net2)
%Y = net2(X); % Y is new outputs
%perf = perform(net2,T,Y); 

end

