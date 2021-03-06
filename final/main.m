%% Preprocessing
clear
clc

%% start solving PDEs!!
ll=0;rr=1;numtrial=5;gamma=2;
error=zeros(numtrial,1);
bderror1=zeros(numtrial,1);
bderror2=zeros(numtrial,1);

for i=1:numtrial
    M=10*2^(i-1)-1;
    u=zeros(2*M+2,1);
    h=(rr-ll)/(M+1);
    A11=8*h;
    A12=0;
    A22=24/h;
    B11=2*h;
    B12=-6;
    B21=6;
    B22=-12/h;
    C11=4*h;
    D11=4*h+gamma*h^2;
    A=zeros(2*M+2);
    A(1,1)=C11;A(1,2)=B11;A(1,3)=B12;
    A(2,1)=B11;A(2,2)=A11;A(2,3)=A12;A(2,4)=B11;A(2,5)=B12;
    A(3,1)=B12;A(3,2)=A12;A(3,3)=A22;A(3,4)=B21;A(3,5)=B22;
    A(2*M,2*M-2)=B11;A(2*M,2*M-1)=B21;A(2*M,2*M)=A11;A(2*M,2*M+1)=A12;A(2*M,2*M+2)=B11;
    A(2*M+1,2*M-2)=B12;A(2*M+1,2*M-1)=B22;A(2*M+1,2*M)=A12;A(2*M+1,2*M+1)=A22;A(2*M+1,2*M+2)=B21;
    A(2*M+2,2*M)=B11;A(2*M+2,2*M+1)=B21;A(2*M+2,2*M+2)=D11;
    for j=4:2*M-1
        if mod(j,2)==0
            A(j,j-2)=B11;A(j,j-1)=B21;A(j,j)=A11;A(j,j+1)=A12;A(j,j+2)=B11;A(j,j+3)=B12;
        else
            A(j,j-3)=B12;A(j,j-2)=B22;A(j,j-1)=A12;A(j,j)=A22;A(j,j+1)=B21;A(j,j+2)=B22;
        end
    end
    b=zeros(2*M+2,1);
    x=linspace(ll,rr,M+2);
    b1=@(x) basis1(x,0,h).*exp(-x);
    b(1)=integral(b1,0,h);
    b2=@(x) basis1(x,(M+1)*h,h).*exp(-x);
    b(2*M+2)=integral(b2,M*h,(M+1)*h);
    for j=2:2*M+1
        if mod(j,2)==0
            b3=@(x) basis1(x,j/2*h,h).*exp(-x);
            b(j)=integral(b3,j/2*h-h,j/2*h)+integral(b3,j/2*h,j/2*h+h);
        else
            b4=@(x) basis2(x,(j-1)/2*h,h).*exp(-x);
            b(j)=integral(b4,(j-1)/2*h-h,(j-1)/2*h)+integral(b4,(j-1)/2*h,(j-1)/2*h+h);
        end
    end
    u=A\b;
    
    numeval=200000;
    testx=linspace(0,1,numeval);
    l2=0;
    for p=1:numeval
        j=floor(testx(p)/h)+1;
        if (j==M+2) 
            j=j-1; 
        end
        if (j==1)
            uu=u(1)*basis1(testx(p),0,h)+u(2)*basis1(testx(p),h,h)+u(3)*basis2(testx(p),h,h);
        elseif (j==M+1)
            uu=u(2*M)*basis1(testx(p),M*h,h)+u(2*M+1)*basis2(testx(p),M*h,h)+u(2*M+2)*basis1(testx(p),(M+1)*h,h);
        else
            uu=u(2*j-2)*basis1(testx(p),(j-1)*h,h)+u(2*j-1)*basis2(testx(p),(j-1)*h,h)+u(2*j)*basis1(testx(p),j*h,h)+u(2*j+1)*basis2(testx(p),j*h,h);
        end
        uu=uu/h^2;
        l2=l2+(uexact(testx(p))-uu)^2;
    end
    uuu=zeros(M+2,1);
    for p=1:M+2
        j=p;
        if (j==M+2) 
            j=j-1; 
        end
        if (j==1)
            uuu(p)=u(1)*basis1(x(p),0,h)+u(2)*basis1(x(p),h,h)+u(3)*basis2(x(p),h,h);
        elseif (j==M+1)
            uuu(p)=u(2*M)*basis1(x(p),M*h,h)+u(2*M+1)*basis2(x(p),M*h,h)+u(2*M+2)*basis1(x(p),(M+1)*h,h);
        else
            uuu(p)=u(2*j-2)*basis1(x(p),(j-1)*h,h)+u(2*j-1)*basis2(x(p),(j-1)*h,h)+u(2*j)*basis1(x(p),j*h,h)+u(2*j+1)*basis2(x(p),j*h,h);
        end
        uuu(p)=uuu(p)/h^2;
    end
    l2=sqrt(l2/numeval);
    bderror1(i)=abs(-4/h*u(1)-2/h*u(2)+6/h^2*u(3));
    bderror2(i)=abs(u(2*M)*2/h+u(2*M+1)*6/h^2+u(2*M+2)*4/h+2*u(2*M+2));
    error(i)=l2;
    exactu=uexact(x)';
end

%% Plot graph and summarize errors
plot(x,exactu,x,uuu)
legend('Exact Solution','Numerical Solution')
savefig('result/solution.fig')
for i=2:numtrial
    rate(i-1)=log(error(i-1)/error(i))/log(2); %rate for l2 error
    rate2(i-1)=log(bderror1(i-1)/bderror1(i))/log(2); %rate for left boundary error
    rate3(i-1)=log(bderror2(i-1)/bderror2(i))/log(2); %rate for right boundary error
end
save('data/error_rate.fig','error','bderror1','bderror2','rate','rate2','rate3')