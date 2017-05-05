function [net4] = Train4LM(superval)
%using matlabs traingrad function

X = transpose(superval(1:785,1:2)); %X is 1xcount, inputs are T;P
T = transpose(superval(1:785,3:7)); % outputs are Tsat V U H S

%net.trainFcn = 'trainlm'; %uses Levenberg-Marquardt optimization
net4 = feedforwardnet(30,'trainlm');
net4 = train(net4,X,T); % X is input, T is target
%view(net3)
%Y = net3(X); % Y is new outputs
%perf = perform(net3,T,Y); 

end

