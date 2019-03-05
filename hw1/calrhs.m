function y=calrhs(x0,x1,x2,h,i)
    if (i==1)
        y=(-x1/h+1)*pi/(-1)*(cos(pi*x1)-cos(pi*x0))+...
        pi^2/h*(x0/pi*cos(pi*x0)-x1/pi*cos(pi*x1)+1/pi^2*(sin(pi*x1)-sin(pi*x0)))+...
        (x1/h+1)*pi/(-1)*(cos(pi*x2)-cos(pi*x1))-...
        pi^2/h*(x1/pi*cos(pi*x1)-x2/pi*cos(pi*x2)+1/pi^2*(sin(pi*x2)-sin(pi*x1)));
    else
        y=(0.5*f((x0+x1)/2)+f(x1))/3*h+(0.5*f((x1+x2)/2)+f(x1))/3*h;
    end
end