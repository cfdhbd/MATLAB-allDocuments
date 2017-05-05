function [net5] = Train5LM(superval)
%using matlabs traingrad function

X = transpose(superval(786:2024,1:2)); %X is 1xcount, inputs are T;P
T = transpose(superval(786:2024,3:7)); % outputs are Tsat V U H S

%net.trainFcn = 'trainlm'; %uses Levenberg-Marquardt optimization
net5 = feedforwardnet(30,'trainlm');
net5 = train(net5,X,T); % X is input, T is target
%view(net3)
%Y = net3(X); % Y is new outputs
%perf = perform(net3,T,Y); 

end

