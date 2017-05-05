n = 10;
k = 1.5;
q = 6e5;
Too = 25;
h = 50;
L = 0.1;
x0 = 0;
dx = (L-x0)/(n-1);
x = (0:dx:L)';
T = zeros(n,1);

%setting up matrix
e = ones(n-1,1);
e(end) = 2;
f = -2*ones(n,1);
f(end) = f(end) - h/k*2*dx;
g = ones(n-1,1); 
g(1) = 2;
A = diag(e,-1) + diag(f) + diag(g,1);

b = -q.*x*dx^2/k.*ones(n,1);
b(end) = b(end) - Too*h/k*2*dx;

T = A\b;

plot(x,T(:,1),'o-');
xlabel('Position, x(m)'); ylabel('Temperature, T(C)');





% for i = 1:n
%     A(i,i) = -2;
%     if i>1
%         A(i,i-1) =1;
%     end
%     if i<n
%         A(i,i+1) = 1;
%     end
%     A(1,2) = 2;
%     A(end,end-1) = 2;
%     A(end,end) = -2+h/k*2*dx);
% end
