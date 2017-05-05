function NewtonRaphson = A1_2(x1,x2)
%A1 to perform newton-raphson method
%   using dF/dx* x = -F(x) when F(x+dx) = 0
i=0; 
xinit = [x1,x2];
xold = xinit;
funcval =zeros(1000,2); %these variables are for plotting
iter = zeros(1000,1);   % and to watch convergence

func = @(x) [x(1)^3 + 2*x(1)*x(2)/(1+exp(x(2)))-43;...
    x(1)^(1/3) + x(1)*x(2)^(1/2)-3/x(2)-12];

jac = @(x) [3*x(1)^2+2*x(2)/(1+exp(x(2))),2*x(1)/(1+exp(x(2)))-...
    2*x(1)*x(2)*exp(x(2))/(1+exp(x(2)))^2;...
    x(2)^(1/2)+x(1)^(-2/3)/3, x(1)/(2*x(2)^(1/2))+3/x(2)^2];
  
for i=1:1000
    dx = jac(xold)\(-1*func(xold));
    xnew = xold + dx;
    funcval(i,:) = func(xnew);
    iter(i) = i; %for plotting
    i = i+1;
    if max(abs(dx)) < 1e-8
        xnew;
        break
    end
    xold = xnew;
end

NewtonRaphson = xnew(:,1); 
plot(iter,funcval(:,1),iter,funcval(:,2));

end

