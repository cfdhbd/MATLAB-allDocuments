function [X1,W1,yk,Err,n,T1,yksig,e,emean] = Train1(subval)
%steps: 
% 1. input x, forward proagate, find acitivations of hidden&output
% 2. eval sigma for outputs
% 3. back prop sigmas to obtain hidden sigmas
% 4. evaluate derivatives

%Train1 evals subcooled T(0.01 --> 200 degC)
%initialize matrices
M = 2; %M is #inputs (P,T) not including bias
Out = 4; %outputs (v,U,H,S)
w = 30; %#column weights in each row
L = 2; %layers, j&k
W1 = ones(L,(w+1)*Out);
dw = zeros(L,Out*(w+1));
%Out*w+1 b/c k layer has extra column due to bias
subvaln = subval(1:480,:);
%note, ignore column 3 of subval. Values are Tsat which isn't used
% to compute outputs
permtot = 100;
for permutations = 1:permtot
ttot = round(size(subvaln,1)); %total # of training data

perm = randperm(ttot,ttot);
subvalperm = subvaln(perm,:);

T1 = subvalperm(1:ttot,4:7);
% Ta = min(T1(:));
% Tb = max(T1(:));
% Tra = 0.9;
% Trb = 0.1;



%normalize data
biasinputs = ones(1,ttot)*0.11;
inputs = transpose(subvalperm(1:ttot,1:2)); %initial inputs
%f = size(biasinputs+inputs); %zeros for first layer weights
Xi = inputs;%zeros(w-f(1,1),ttot)];...unnecessary 
a = min(Xi,[],2);
b = max(Xi,[],2);
ra = 0.9;
rb = 0.1;
X1n = (((ra-rb).*(Xi-a))./(b-a)) + rb; %normalized inputs
X1 = [biasinputs;X1n];
%i:input, j:hidden, k:output layers
%a:activation, z:transferfuncn, sig:sigmoid (represents error)
%n is amount change to weights / error trial
%train 1st half of data, supervise the 1/4 for error, unsupervise last 1/4
aj = zeros((M+1),w);
ak = zeros((w+1),Out);
sigj = zeros(w,Out);
Err = zeros(ttot,Out);
%Errsup = zeros(ttot,Out); %sup for supervised training error
yk = zeros(ttot,Out);
zj = zeros(ttot,(w+1));
e = zeros(ttot,Out);
yksig = zeros(ttot,Out);

numup = round(permtot/permutations); %this will decrease number of updates
%as weights progress. by the end, they shouldn't need much updating

r2 = round((w+1)/4);
r3 = round((w+1)*3/4);
rate = 0.00002;
n = ones(2,(w+1)*Out)*rate*numup;
%n(1,2) = n(1,2)*100;
%n(2,r2:r3-1) = n(2,r3-r2)*300;
%n(1,2) = n(1,2);%*5;
%n(1,3) = n(1,2);%*5;
%n(2,3:4:(w+1)) = n(2,3:4:(w+1));%*20;
%n(1:w:w*(M+1)) = n(1:w:w*(M+1))*
n(2,1:Out:(w+1)*Out) = n(2,1:Out:(w+1)*Out)*6000;
n(2,Out:Out:(w+1)*Out) = n(2,Out:Out:(w+1)*Out)*8000;

for repeat = 1:1    %repeat training data
    for tau=1:ttot/2 %tau is step number, train for half known data
        for update = 1:numup %repeat multiple times per data input
            
            %determine output
            for i=1:(M+1) %first input is bias, 2nd T, 3rd P
                %this loop sums input*weight at each node
                aj(i,:) = X1(i,tau)*W1(1,((w*i)-(w-1)):((w*i)));
            end
            ajs =[1,sum(aj)]; %returns row of sum of inputs*weights + 1 bias
            
            for z = 1:size(ajs,2) %will be z = 1:(w+1)
                zj(tau,z) = ...
                    1/(1+exp(-ajs(1,z)));
                   %(exp(ajs(1,z))-exp(-ajs(1,z)))/(exp(ajs(1,z))+exp(-ajs(1,z)))
            end
            
            for j=1:size(zj,2) %also (w+1)
                ak(j,:) = zj(tau,j)*W1(2,((Out*j)-(Out-1)):(Out*j));
            end
            
            aks = sum(ak); %no bias added, 
            
            for y = 1:Out
                yksig(tau,y) = 1/(1+exp(-aks(1,y)));
            end
            %offset(1,:) = [0.00002, 20,20,0.2];
            for yout = 1:Out
                yk(tau,yout) = ...
                    (yksig(tau,yout))*max(T1(:,yout));%-Trb)*(Tb-Ta)+Ta;%min(T1(:,yout));
%             yk(tau,yout) = (1/(1+exp(-yksig(1,yout))))*...
%                 (1-1/(1+exp(-yksig(1,yout))));
            end
            
            %each column is output, in order: v, U, H, S
            %yk(tau,:) = aks;
            
            %error, back-propagation
            Err(tau,:) = 1/9*(yk(tau,:)-T1(tau,:)).^3; %to keep negatives
            e(tau,:) = (T1(tau,:)-yk(tau,:))./T1(tau,:)*100;
            sigks = yk(tau,:)-T1(tau,:);
            
            zjd = zj(tau,:).*(ones(1,size(zj,2))-zj(tau,:));
            zjder = zjd(1,1:(w+1)); %get rid of bias
            for cj=1:w  %cj is number w in j layer
                sigj(cj,:) = ...
                    zjder(1,(cj+1)).*(sigks).*W1(2,((Out*cj-(Out-1)):Out*cj));
                    %.*ajs(1,(cj+1))
                    %zjder(1,cj).*(sigks).*W1(2,((Out*cj-(Out-1)):Out*cj));
            end
            sigjs = sum(sigj,2);
      %maybe try sigj instead of Err, try to make d1 = 1:w instead of d1 = 1:M+1  
            for d1=1:(M+1)
%                 if Err(tau,:) < [1e-8, 1e-2, 1e-2, 1e-4] & [0,0,0,0] < Err(tau,:)
%                     dw1(1,d1*w-(w-1):d1*w) = zeros(1,(w));
%                 else
                    dw1(1,d1*w-(w-1):d1*w) = ...
                        -n(1,d1*w-(w-1):d1*w).*X1(d1,tau)*sigjs;
                    %dw1(1,d1*w-(w-1):d1*w) = -n(1,d1)*X1(d1,tau)*sigj(:,d1);
                    %sigj(:,(d1));
%                 for d1e = 1:w %d1e is d1error, this overrides weight change 
%                     if abs(sigjs(d1e,1)) < 1e-20 %&& sigjs(d1e,1) > 0
%                         dw1(1,d1*w-(w-d1e)) = 0;
%                     end
%                   
%                 end
            end
            
            for d2=1:(w+1)  
%                 if Err(tau,:) < [1e-8, 1e-2, 1e-2, 1e-4] & [0,0,0,0] < Err(tau,:)
%                     dw2(1,d2*Out-(Out-1):d2*Out) = ...
%                         zeros(1,Out);
%                 else
                    dw2(1,d2*Out-(Out-1):d2*Out) =...
                        -n(2,d2*Out-(Out-1):d2*Out).*sigks*zj(tau,d2);
                for d2e = 1:Out
                    if abs(Err(1,d2e)) < 1e-20 %&& Err(1,d2e) > 0
                        dw2(1, d2*Out-(Out-d2e)) = 0;
                    end
                end
%                 end
            end
            dw1(1,(size(dw1,2)+1):size(dw2,2)) = 0;
            dw = [dw1;dw2];
            W1 = W1 + dw;
            
        end
    end
end   

end
% supervised

for tau = (ttot/2+1):ttot
            %determine output
            for i=1:(M+1) %first input is bias, 2nd T, 3rd P
                %this loop sums input*weight at each node
                aj(i,:) = X1(i,tau)*W1(1,((w*i)-(w-1)):((w*i)));
            end
            ajs =[1,sum(aj)]; %returns row of sum of inputs*weights + 1 bias
            
            for z = 1:size(ajs,2) %will be z = 1:(w+1)
                zj(tau,z) = ...
                    1/(1+exp(-ajs(1,z)));
                   %(exp(ajs(1,z))-exp(-ajs(1,z)))/(exp(ajs(1,z))+exp(-ajs(1,z)))
            end
            
            for j=1:size(zj,2) %also (w+1)
                ak(j,:) = zj(tau,j)*W1(2,((Out*j)-(Out-1)):(Out*j));
            end
            
            aks = sum(ak); %no bias added, 
            
            for y = 1:Out
                yksig(tau,y) = 1/(1+exp(-aks(1,y)));
            end
            
            for yout = 1:Out
                yk(tau,yout) = yksig(tau,yout)*max(T1(:,yout));
%             yk(tau,yout) = (1/(1+exp(-yksig(1,yout))))*...
%                 (1-1/(1+exp(-yksig(1,yout))));
            end  
            
            Err(tau,:) = 1/9*(yk(tau,:)-T1(tau,:)).^3; %to keep negatives
            e(tau,:) = (T1(tau,:)-yk(tau,:))./T1(tau,:)*100;
            
end
emean(1,:) = mean(abs(e(:,:)));
end


