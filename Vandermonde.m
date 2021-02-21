a=-2;
b=2;

k=9;
xn=linspace(a,b,9);
x=linspace(-5,5,1000);

y=(1./(1+x.^2));
yn=(1./(1+xn.^2));
%plot(x,y,'b',xn,yn,'ro')
A=ones(k,1);
for i=1:(k-1)
  A=[A,xn'.^i];
end
C=inv(A)*yn';
A=ones(1000,1);
for i=1:(k-1)
  A=[A,x'.^i];
end
PK=A*C;
plot(x,y,'b',xn,yn,'r*',x,PK,'r')
axis([-5,5,0,1.5])