function [net1,X,T] = Train1LM(subval)
%using matlabs traingrad function

X = transpose(subval(1:480,1:2)); %X is 1xcount
T = transpose(subval(1:480,4:7));

%net.trainFcn = 'trainlm'; %uses Levenberg-Marquardt optimization
net1 = feedforwardnet(20,'trainlm');
net1 = train(net1,X,T); % X is input, T is target
%view(net1)
%Y = net1(X); % Y is new outputs
%perf = perform(net1,T,Y); 



end

