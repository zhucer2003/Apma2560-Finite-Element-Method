%% Preprocessing
clear
clc

%% start solving PDEs!!
ll=0;rr=1;numtrial=4;
error=zeros(numtrial,1);
nodeerror=zeros(numtrial,1);

for i=1:numtrial
    M=10*2^i-1;
    u=zeros(M+2,1);
    u(1)=0;u(M+2)=0;
    h=(rr-ll)/(M+1);
    A=full(gallery('tridiag',M,-1,2,-1))/h;
    b=zeros(M,1);
    x=linspace(ll,rr,M+2);
    for j=1:M
        b(j)=calrhs(x(j),x(j+1),x(j+2),h,1); %Calculate by hand
        %b(j)=calrhs(x(j),x(j+1),x(j+2),h,2); %Use Simpson's rule
    end
    u(2:M+1)=A\b;
    numeval=200000;
    testx=linspace(0,1,numeval);
    l2=0;
    for p=1:numeval
        j=floor(testx(p)/h)+1;
        if (j==M+2) 
            j=j-1;
        end
        uu=(u(j+1)-u(j))/(x(j+1)-x(j))*(testx(p)-x(j))+u(j);
        l2=l2+(uexact(testx(p))-uu)^2;
    end
    l2=sqrt(l2/numeval);
    error(i)=l2;
    exactu=uexact(x)';
    nodeerror(i)=sqrt(sum((u-exactu).^2)/(M+2));
end

%% Plot graph and summarize errors
plot(x,u)
for i=2:numtrial
    rate(i-1)=log(error(i-1)/error(i))/log(2); %rate for l2
end