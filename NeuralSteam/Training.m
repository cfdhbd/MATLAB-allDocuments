% %script imports saturated steam table values from Steam_Tables.xlsx sheet
% P in bar 
% T in C
% v in m3/kg 
% u in KJ/kg
% h in KJ/kg
% s in KJ/(kg K)
 
% uevap = xlsread('Steam_Tables.xlsx','Saturated','H5:H405'); %evap is diff
% hevap = xlsread('Steam_Tables.xlsx','Saturated','K5:K405'); %b/w liq & vap
% sevap = xlsread('Steam_Tables.xlsx','Saturated','N5:N405');

%import steam table values
filename = 'Steam_Tables.xlsx';

satval = xlsread(filename,'Saturated','C5:L405');
superval = xlsread(filename,'Superheated','C5:BP405');
subval = xlsread(filename, 'Subcooled','E5:K864');
superT = xlsread(filename,'Superheated','A4:A19');
%define steam table values

%========================
%*****************************TRAIN DATA**********************************
%data will be trained in 6 sections, titled ANN#  
%ANN stands for Artificial Neural Network

%section 1: subcool,     p=0.01-220 bar
%section 2: subcool,     p=220-500 bar
%section 3: saturated,   p=0.01-220.63
%section 4: superheated, p=0.01-1 bar
%section 5: superheated, p=1-94 bar
%section 6:= superheated, p=94-220.63 bar

%Each section will call a script, which will train passed parameters, which
%will then return weighted values. 

%..........Train Subcooled..............
%Section 1, T=0.01-150 C
[net1,X,T] =Train1Grad(subval);
%The below was to test the output 'net1' for variables
% tic
% Y = net1(X);
% toc
% compare = [Y(1,:);T(1,:);Y(2,:);T(2,:);Y(3,:);T(3,:);Y(4,:);T(4,:)];
% 
% TP = [150;215]; % 0.001077034	622.3275178	645.4837481	1.819382382
% ytp = net1(TP);



% %Section 2, T=150-373 C
[net2] =Train2LM(subval);
% 
% 
%................. Train Saturated...............%
% %Section 3, p=0.01-220.63
[net3] =Train2LM(satval);
% 
%.................Train Superheated.............%
% %Section 4, p=0.01-1 bar
% [net4] =Train4(superval);
% 
% 
% 
% %Section 5, p=1-94 bar
% [net5] =Train5(superval);
% 
% 
% %Section 6, p=94-220.63 bar
% [net6] =Train6(superval);
% 
% 
% 
