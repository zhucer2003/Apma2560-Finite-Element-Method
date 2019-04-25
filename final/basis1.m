function f=basis1(x,xi,h)
    if x<=xi
        f=(x-xi+h).^2.*(x-xi);
    else
        f=(x-xi-h).^2.*(x-xi);
    end
end