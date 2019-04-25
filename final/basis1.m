function f=basis1(x,xi,h)
    if x<=xi
        f=(x-xi+h).^2.*(x-xi)./h.^2;
    else
        f=(x-xi-h).^2.*(x-xi)./h.^2;
    end
end