function [b] = rb(l,f,x1,h)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
if l==1
b = integral(f,x1,x1+2*h);
elseif l==2
b=(f(x1+h/2)+f(x1+h)*2+f(x1+3*h/2))/3*h;
end

end

% b=(0.5*f((x1+x1+h/2)/2)+f(x1+h/2))/3*h+(0.5*f((x1+x2)/2)+f(x1))/3*h;