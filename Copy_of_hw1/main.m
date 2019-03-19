clear; clc; close all;
n=4;
error=zeros(n,1);
error2=zeros(n,1);

for i=1:n
    num=10*2^i-1;
    usol=zeros(num+2,1);
    usol(1)=0;
    usol(num+2)=0;
    hh=1/(num+1);
    left=zeros(num,num);
    for kk=1:num
        for kk2=1:num
            if kk==kk2
                left(kk,kk2)=2;
            elseif kk==kk2+1
                left(kk,kk2)=-1;
            elseif kk==kk2-1
                left(kk,kk2)=-1;
            end
        end
    end
    left=left/hh;
    right=zeros(num,1);
    x=linspace(0,1,num+2);
    for k=1:num
        right(k)=(-x(k+1)/hh+1)*pi/(-1)*(cos(pi*x(k+1))-cos(pi*x(k)))+...
        pi^2/hh*(x(k)/pi*cos(pi*x(k))-x(k+1)/pi*cos(pi*x(k+1))+1/pi^2*(sin(pi*x(k+1))-sin(pi*x(k))))+...
        (x(k+1)/hh+1)*pi/(-1)*(cos(pi*x(k+2))-cos(pi*x(k+1)))-...
        pi^2/hh*(x(k+1)/pi*cos(pi*x(k+1))-x(k+2)/pi*cos(pi*x(k+2))+1/pi^2*(sin(pi*x(k+2))-sin(pi*x(k+1))));
%         right(k)=(0.5*4*pi^2*sin((x(k)+x(k+1))/2*pi)+pi^2*sin(x(k+1)*pi))/6*hh+...
%             (0.5*4*pi^2*sin((x(k+1)+x(k+2))/2*pi)+pi^2*sin(x(k+1)*pi))/6*hh;
    end
    usol(2:num+1)=left\right;
    num2=1000;
    xdata=linspace(0,1,num2);
    l2error=0;
    for p=1:num2
        ele=floor(xdata(p)/hh)+1;
        if (ele==num+2) 
            ele=ele-1;
        end
        unumerical=(usol(ele+1)-usol(ele))/(x(ele+1)-x(ele))*(xdata(p)-x(ele))+...
            usol(ele);
        l2error=l2error+(sin((xdata(p)*pi))-unumerical)^2;
    end
    l2error=sqrt(l2error/num2);
    error(i)=l2error;
    exactu=sin(pi*x)';
    error2(i)=sqrt(sum((usol-exactu).^2)/(num+2));
end