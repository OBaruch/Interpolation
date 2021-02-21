%M�TODO DE NEWTON EN DIFERENCIAS
% Funci�n para crear un interpolador utilizando el m�todo de diferencias divididas de
% Newton, a partir de los siguientes datos:
% x .- vector discreto de la variable independiente
% fx .- valor de la funci�n en los puntos x
clear all;
clc;
% Vector de la variable independiente de la funci�n original
    %xo=linspace(-3/2,7/2,1000);
%funci�n original
  %  fxo = cos(xo.^2)+xo.^3-3*xo.^2+exp(-2*xo);

    % Vector de la variable independiente
    x = [0;10;20;30;40;50];
% Valor de la funci�n Y
    %fx = cos(x.^2)+x.^3-3*x.^2+exp(-2*x);
    fx= [0.013;0.025;0.032;0.044;0.052;0.07];
    
% N�mero de muestras.
N = length(x);
% Orden de la m�xima diferencia dividida de Newton.
P = N-1;
% Aparta espacio para el almacenamiento de x, fx y todas las diferencias divididas de
% Newton.
Tb = zeros(N,P);
Tb = [x fx Tb];
% Rutina para crear la tabla columna por columna.
for k=1:P
for m=1:N-k
Num = Tb(m+1,k+1) - Tb(m,k+1); % Diferencia en el numerador.
Den = Tb(m+k,1) - Tb(m,1); % Diferencia del denominador.
Tb(m,k+2) = Num/Den; % Coeficiente resultante de la divisi�n.
end
end
% Los coeficientes quedan en el primer rengl�n de la columna 2 a la P+2, por tanto:
Newton = Tb(1,2:P+2);
% Rutina que crea la matriz que contiene los coeficientes resultantes de multiplicar
% cada t�rmino de la tabla de diferencias divididas de Newton por el polinomio de
% grado k que lo acompa�a.
for k=1:N
orden = x(1:k-1); % Orden del polinomio que acompa�a al coeficiente
% de Newton.
Pol = Newton(k)*poly(orden); % Obtiene los coeficientes de un polinomio de
% orden k-1.
Coef(k,N-k+1:N) = Pol; % Acomoda los coeficientes en la matriz Coef.
end





% Suma todos los t�rminos del mismo orden para crear el polinomio interpolador.
Pol = sum(Coef);

xp = (-10:0.01:60); % Vector a evaluar en puntos entre el l�mite inferior y
% superior.
Fxp = polyval(Pol,xp); % Evaluaci�n de la funci�n en todos los puntos
% propuestos.

% Gr�ficas de los puntos iniciales y el polinomio interpolador
%plot(xo,fxo,'b',x,fx,'*',xp,Fxp,'r'); 
plot(x,fx,'*',xp,Fxp,'r'); 
legend('Gr�fica original','Puntos iniciales','Polinomio interpolador')
%Ejes de la repesentaci�n gr�fica
axis([-20,100,-.2,.2]) 

%%%%%Pol da los coeficientes ordenados de mayor a menor con uno menor al
%%%%%numero de puntos.



% f=@(x)(1./(1+x.^2));
% x=[-2; -1.5; -1; -0.5; 0; 0.5; 1; 1.5; 2];
% f(x)
% P=@(x)(0.0246*x.^8-0.2092*x.^6+0.6292*x.^4-0.9446*x.^2+1);
% P(x)
% [f(x),P(x),abs(f(x)-P(x))]