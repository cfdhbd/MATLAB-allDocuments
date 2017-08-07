%{
A = [1,0,-4,8,3;4,-2,3,3,1];
b = zeros(1,5);

for index = 1:size(A,2)
    if A(1,index) > A(2,index)
        b(index) = A(1,index);
    else
        b(index) = A(2,index);
    end
end
%question: what is b = to after execution
%answer is 1
%}

%{
function Q9()

x =1;
while x>1e-5
    x = x/2;
end
disp(x)
end
%}
