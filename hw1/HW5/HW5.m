clear 
M=[19 39 79 159];
h=1./(1+M);
[m mm]=size(M);
f=@(x) pi*pi*sin(pi.*x);
error1=zeros(mm,1);
error2=zeros(mm,1);

for i=1:mm
    A=zeros(M(i));
    b=zeros(M(i),1);
    for j=2:M(i)-1
       f1=@(x) f(x).*phi(j,x,h(i));
       A(j,j)=2/h(i);
       A(j,j-1)=-1/h(i);
       A(j,j+1)=-1/h(i);
     b(j)=rb(1,f1,h(i)*(j-1),h(i));
 %        b(j)=rb(2,f1,h(i)*(j-1),h(i));
    end
    f2=@(x) f(x).*phi(1,x,h(i));
    j=1;
     b(j)=rb(1,f2,h(i)*(j-1),h(i)); %1:integral
%   b(j)=rb(2,f2,h(i)*(j-1),h(i)); %2:Simpson's rule
    j=M(i);
    fm=@(x) f(x).*phi(j,x,h(i));
    b(j)=rb(1,fm,h(i)*(j-1),h(i)); %1:integral
 %   b(j)=rb(2,fm,h(i)*(j-1),h(i));
    A(1,1)=2/h(i);
    A(M(i),M(i))=2/h(i);
    A(M(i),M(i)-1)=-1/h(i);
    A(1,2)=-1/h(i);
    
    uu=A\b;
    
    u=@(x) 0*x;
    for j=1:M(i)
        u=@(x) u(x)+uu(j).*phi(j,x,h(i));
    end
    ee=@(x) (u(x)-sin(pi.*x)).^2;
    
    for j=1:M(i)+1
    error2(i)=error2(i)+ee(h(i)*j); 
    error1(i)=integral(ee,(j-1)*h(i),(j)*h(i))+error1(i);
    end
    error2(i)=sqrt((error2(i))/M(i));
    error1(i)=sqrt(error1(i));    
end

p=zeros(101,1);
q=p;
x=p;
for i=1:101
    x(i)=(i-1)*0.01;
    p(i)=u(x(i));
    q(i)=sin(pi.*x(i));
end
plot(x,p);
hold on
plot(x,q);
hold off

for i=2:mm
    rate(i-1)=log(error1(i-1)/error1(i))/log(2); %rate
end

for i=2:mm
    rate2(i-1)=log(error2(i-1)/error2(i))/log(2); %rate
end
