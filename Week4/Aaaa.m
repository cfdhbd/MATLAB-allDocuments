function Aaaa()
    Too = 25;
    h = 50;
    k = 1.5;
    rho = 2500;
    cp = 850;

    Tx0 = 0;
    Tguess = 100;

    L = 0.1;

    A = 6e5;
    h = 50;
    %y(1) =T, y(2) = f
    out = fzero(@objFunc,Tguess);
    plot(x,yNew(:,1));


    function result = objFunc(Tguess)
        func =@(x,y) [y(2);-A*x/k]; %y(1) =T, y(2) = f
        [x,yNew] = ode45(func,[0,L],[Tguess, 0]); %yNew(1) = T, yNew(2) = f
        result = yNew(end,2) - (-h/k*yNew(end,1) - Too);
    end


end

