function [W1,emean1,yk,T1,emin1,emax1] = Train1H(subval)
%steps: 
% 1. input x, forward proagate, find acitivations of hidden&output
% 2. eval sigma for outputs
% 3. back prop sigmas to obtain hidden sigmas
% 4. evaluate derivatives

%Train1 evals subcooled T(0.01 --> 200 degC)
%initialize matrices
M = 2; %M is #inputs (P,T) not including bias
Out = 4; %outputs (v,U,H,S)
w = 15; %#column weights in each row
H = 5; %hidden layers 
W1 = ones(H+1,(w+1)*(w+1),1);
dw = zeros(H+1,(w+1)*(w+1),1);
bias = ones(1,H);
%Out*w+1 b/c k layer has extra column due to bias
subvaln = subval(1:480,:);
%note, ignore column 3 of subval. Values are Tsat which isn't used
% to compute outputs
permtot = 110;
for permutations = 1:permtot
ttot = round(size(subvaln,1)); %total # of training data

perm = randperm(ttot,ttot);
subvalperm = subvaln(perm,:);

T1 = subvalperm(1:ttot,4:7);
Tmax = max(T1,[],1);
%Tmin = min(T1,[],1);
% Tra = 0.9;
% Trb = 0.1;



%normalize data
biasinputs = ones(1,ttot);
inputs = transpose(subvalperm(1:ttot,1:2)); %initial inputs
%f = size(biasinputs+inputs); %zeros for first layer weights
Xi = inputs;
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
%sigj = zeros(w,Out);
Err = zeros(ttot,Out);
%Errsup = zeros(ttot,Out); %sup for supervised training error
yk = zeros(ttot,Out);
zj = zeros(ttot,(w+1));
e = zeros(ttot,Out);
%yksig = zeros(ttot,Out);

%errors
a = zeros((w+1),(w),1);
z = zeros(1,(w+1),H);
sig = zeros((w+1),(w+1),H);
%sigs = zeros(1,w+1,H);
zd = zeros(1,(w+1),H+1);

numup = round(permtot/permutations); %this will decrease number of updates
%as weights progress. by the end, they shouldn't need much updating
rate = 0.03;
%n = ones(L,(w+1)*Out)*rate*numup;
n = rate;
%n(L,1:Out:(w+1)*Out) = n(2,1:Out:(w+1)*Out)*5000;
% n(L,Out:Out:(w+1)*Out) = n(2,Out:Out:(w+1)*Out)*1000;
%dw = zeros(H+1,(w+1)*(w+1),numup);
%dw(H+1,(w+1)*(w+1),1) = 0;
%mu = 0.001;
for repeat = 1:1    %repeat training data
    for tau=1:ttot/2 %tau is step number, train for half known data
        for update = 1:numup %repeat multiple times per data input
            %update starts at 2 to account for the first momentum term 
            %determine output
            for i=1:(M+1) %first input is bias, 2nd T, 3rd P
                %this loop sums input*weight at each node
                aj(i,:) = X1(i,tau)*W1(1,((w*i)-(w-1)):((w*i)));
            end
            ajs =[bias(1,1),sum(aj)]; %returns row of sum of inputs*weights + 1 bias
            zj(tau,:,1) = logsig(ajs(1,:));
            z(1,:,1) = zj(tau,:,1);
            
            for hf = 2:H %input and output layer are unique, hf for h forward
                for hi=1:(w+1)
                    a(hi,:,1) = z(1,hi,(hf-1))*W1(hf,((w*hi)-(w-1)):((w*hi)),1);
                end
                asum(1,:,1) = [bias(1,hf),sum(a)];
                z(1,:,hf) = logsig(asum(1,:,1));
            end
            

            %NOTE make zj the last h
            %NOTE k is the final layer, ie. output
            for k=1:(w+1) %also (w+1)
                ak(k,:,1) = z(1,k,H)*W1((H+1),((Out*k)-(Out-1)):(Out*k),1);
            end
            aks = sum(ak); %no bias added, 
            
            for y = 1:Out 
                yk(tau,y) = logsig(aks(1,y))*Tmax(1,y);
                %this gives value of yk b/w 0&1*max of each output
            end
    
            %each column is output, in order: v, U, H, S        
            
            %error, back-propagation
            Err(tau,:) = 1/9*(yk(tau,:)-T1(tau,:)).^3; %to keep negatives
            e(tau,:) = (yk(tau,:)-T1(tau,:))./T1(tau,:)*100;
            
            sigks(1,:,1) = yk(tau,:)-T1(tau,:);
            zd(1,:,H) = z(1,:,H).*(ones(1,size(z,2))-z(1,:,H));
            
            %for H
            for Hc = 1:(w+1)
                sig(Hc,:,H) = ...
                    [zd(1,Hc,H).*sigks.*W1(H+1,((Out*Hc-(Out-1)):Out*Hc),1),...
                     zeros(1,abs((w+1)-Out),1)];
            end
            %sigs(1,:,H) = sum(sig(:,:,H),2);
            
            %perfect
            
            for hb = (H-1):-1:1
                zd(1,:,hb) = z(1,:,hb).*(ones(1,size(z,2))-z(1,:,hb));
                for hbc = 1:(w+1)
                    sig(hbc,:,hb) = ...
                        zd(1,hbc,hb).*sig(hbc,:,hb+1).*W1(hb+1,((w+1)*hbc-w):hbc*(w+1),1);
                end
                %sigs(1,:,hb) = sum(sig(:,:,hb),2);
            end
            
            %deltaw
            
            for dfin = 1:(w+1)
                dw(H+1,(dfin*Out-(Out-1)):dfin*Out) =...
                    -n*sigks.*z(1,dfin,H);%+mu*dw(H+1,(dfin*Out-(Out-1)):dfin*Out,update-1);
                %2nd term is momentum...didn't end up working, gave 0's
            end
             
            for db = 1:H
                for dc = 1:(w+1)
                    dw(db,(dc*(w+1)-(w)):dc*(w+1)) = ...
                        -n*sig(1,dc,db).*z(1,dc,db);%+mu*(dw(db,(dc*(w+1)-w):dc*(w+1),update-1));
                end
            end
            W1 = W1 + dw; 
        end
    end
end   
end

% testing
for tau = (ttot/2+1):ttot
            %determine output
          %determine output
            for i=1:(M+1) %first input is bias, 2nd T, 3rd P
                %this loop sums input*weight at each node
                aj(i,:) = X1(i,tau)*W1(1,((w*i)-(w-1)):((w*i)));
            end
            ajs =[bias(1,1),sum(aj)]; %returns row of sum of inputs*weights + 1 bias
            zj(tau,:,1) = logsig(ajs(1,:));
            z(1,:,1) = zj(tau,:,1);
            
            for hf = 2:H %input and output layer are unique, hf for h forward
                for hi=1:(w+1)
                    a(hi,:,1) = z(1,hi,(hf-1))*W1(hf,((w*hi)-(w-1)):((w*hi)),1);
                end
                asum(1,:,1) = [bias(1,hf),sum(a)];
                z(1,:,hf) = logsig(asum(1,:,1));
            end
            

            %NOTE make zj the last h
            %NOTE k is the final layer, ie. output
            for k=1:(w+1) %also (w+1)
                ak(k,:,1) = z(1,k,H)*W1((H+1),((Out*k)-(Out-1)):(Out*k),1);
            end
            aks = sum(ak); %no bias added, 
            
            for y = 1:Out 
                yk(tau,y) = logsig(aks(1,y))*Tmax(1,y);
                %this gives value of yk b/w 0&1*max of each output
            end    
            
end
emin1(1,:) = min(abs(e(:,:)));
emean1(1,:) = mean(abs(e(:,:)));
emax1(1,:) = max(abs(e(:,:)));
end