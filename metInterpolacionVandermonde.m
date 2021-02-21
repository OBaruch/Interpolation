%M�TODO DE MATRIZ DE VANDERMONDE
% Construcci�n de una funci�n de orden "n" para interpolar un grupo de datos
% utilizando el m�todo de la matriz de Vandermonde.
clear all;
clc;

% Vector de la variable independiente de la funci�n original
%xo=linspace(-5,5,1000);
%funci�n original
%fxo = ((1-xo)/xo.^2)*(((1+xo)./(1+xo*2))-((log(abs(1+2*xo)))./(xo))) + 1/2;

% Vector de la variable independiente
    x = [0;10;20;30;40;50];
% Valor de la funci�n Y
    %fx = cos(x.^2)+x.^3-3*x.^2+exp(-2*x);
    fx= [0.013;0.025;0.032;0.044;0.052;0.07];
    
 % N�mero de muestras
N = length(x);

% Algoritmo para crear la matriz de coeficientes
V = [];
for k = 1:N
V = [V x.^(k-1)];
end
A = inv(V)*fx; % Coeficientes calculados por el m�todo de la matriz de % Vandermonde.
A = A.'; % Para invertir el orden de los coeficientes se necesita un % vector rengl�n.
A = fliplr(A); % Se invierte el orden de los coeficientes para utilizar la % funci�n polyval.

xp = (-1000:0.01:1000); % Vector a evaluar en puntos entre el l�mite inferior y superior.
Fxp = polyval(A,xp); % Evaluaci�n de la funci�n en todos los puntos propuestos.


% Gr�ficas de los puntos iniciales y el polinomio interpolador
%plot(xo,fxo,'b',x,fx,'*',xp,Fxp,'r'); 
plot(x,fx,'*',xp,Fxp,'r'); 
legend('Gr�fica original','Puntos iniciales','Polinomio interpolador')
%Ejes de la repesentaci�n gr�fica
axis([-20,100,-.2,.2]) 

%%%%%A da los coeficientes ordenados de mayor a menor con uno menor al
%%%%%numero de puntos.

% f=@(x)(Funcion Original);
% x=[-2; -1.5; -1; -0.5; 0; 0.5; 1; 1.5; 2]; PUNTOS de interopolacion
% f(x)
% P=@(x)(0.0246*x.^8-0.2092*x.^6+0.6292*x.^4-0.9446*x.^2+1); Coeficientes
% P(x)
% [f(x),P(x),abs(f(x)-P(x))]