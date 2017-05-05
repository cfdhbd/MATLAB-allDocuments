% %script imports saturated steam table values from Steam_Tables.xlsx sheet
% P in bar 
% T in C
% v in m3/kg 
% u in KJ/kg
% h in KJ/kg
% s in KJ/(kg K)

%import steam table values
filename = 'Steam_Tables.xlsx';

satval = xlsread(filename,'Saturated','C5:I4032');
superval = xlsread(filename,'Superheated','C5:I4032');
subval = xlsread(filename, 'Subcooled','E5:K864');
%define steam table values


%*****************************TRAIN DATA**********************************
%data will be trained in 6 sections, titled Train#LM  
%LM stands for Levenberg-Marquardt
%ANN stands for Artificial Neural Network

%section 1: subcool,     T=0.01-150 C
%section 2: subcool,     T=200-373 C
%section 3: saturated,   P=0.01-220.63 Bar
%section 4: superheated, T=50-200 C
%section 5: superheated, T=250-400 C
%section 6: superheated, T=450-800 C

%Each section will call a script, which will train passed parameters, which
%will then return weighted values. 

%..........Train Subcooled..............
%Section 1, T=0.01-150 C
[net1,X,T] = Train1LM(subval);
%The below was to test the output 'net1' for variables
% tic
% Y = net1(X);
% toc
% compare = [Y(1,:);T(1,:);Y(2,:);T(2,:);Y(3,:);T(3,:);Y(4,:);T(4,:)];
% 
% TP = [150;215]; % 0.001077034	622.3275178	645.4837481	1.819382382
% ytp = net1(TP);

% %Section 2, T=150-373 C
[net2] = Train2LM(subval);

%................. Train Saturated...............%
% %Section 3, p=0.01-220.63
[net3] = Train3LM(satval);

%.................Train Superheated.............%
% %Section 4, p=0.01-1 bar
[net4] = Train4LM(superval);

% %Section 5, p=1-94 bar
[net5] = Train5LM(superval);

% %Section 6, p=94-220.63 bar
[net6] = Train6LM(superval);

