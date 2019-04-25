function f=basis2(x,xi,h)
    if x<=xi
        f=(x-xi+h).^2.*(-2*x+h+2*xi)./h;
    else
        f=(x-xi-h).^2.*(2*x+h-2*xi)./h;
    end
end