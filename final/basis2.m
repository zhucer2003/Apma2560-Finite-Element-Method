function f=basis2(x,xi,h)
    if x<=xi
        f=(x-xi+h).^2.*(-2*x+h+2*xi)./h.^3;
    else
        f=(x-xi-h).^2.*(2*x+h-2*xi)./h.^3;
    end
end