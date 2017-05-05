function [X] = backsub(A,B)
n = size(B,1);
X = zeros(n,1);
sum = 0;
X(end) = B(end)/A(end);
for i = n-1:-1:1
sum = B(i);
for j = i+1:n
sum = sum - A(i,j)*X(j);
end
X(i) = sum/A(i,i);
end
end
