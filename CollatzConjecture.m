function one=CollatzConjecture(x)
count =0;
n=x;

while count <= 1000;
    if mod(n,2)==0;
        %n is even
        nnew = n/2;
        n=nnew;
        count = count+1;
    else
        %n is odd
        nnew=n*3+1;
        n=nnew;
        count = count+1;
    end
    
end
    if mod(n,2)==0;
        %final value is 2
        nnew=n/2;
        n=nnew;
        one=n;
    else
        %final value is 1
        one=n;
    end
%% note this function is slightly self determing, as i modify the last value
%% if it is equal to 2, i divide it by 2. A possible way to fix this would
%% be to change the count 1000 value to 1001 for even (or odd i forget) values

    
end
