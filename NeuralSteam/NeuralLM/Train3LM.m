function [net3] = Train3LM(satval)
%using matlabs traingrad function

X = transpose(satval(:,1:2)); %X is 1xcount, inputs are T;P
T = transpose(satval(:,3:7)); % outputs are Vl Vv Ul Uv Hl Hv Sl Sv

%net.trainFcn = 'trainlm'; %uses Levenberg-Marquardt optimization
net3 = feedforwardnet(20,'trainlm');
net3 = train(net3,X,T); % X is input, T is target
%view(net3)
%Y = net3(X); % Y is new outputs
%perf = perform(net3,T,Y); 

end

