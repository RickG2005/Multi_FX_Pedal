function y = applyLPF(x, fs, fc)
    T = 1/fs;
    d_fc = 2*pi*fc/fs;
    a_fc = 2*tan(d_fc/2)/T;
    alpha = T*a_fc/2;
    a1 = (alpha-1)/(1+alpha);
    b0 = alpha/(1+alpha);
    b1 = b0;

    N = length(x);
    y = zeros(size(x));
    for n = 1:N % Can be replaced by -> y = filter([b0 b1], [1 a1], x);
        if n == 1
            y(1) = b0*x(n) + b1*0 - a1*0;
        else 
            y(n) = b0*x(n) + b1*x(n-1) - a1*y(n-1);
        end 
    end
end