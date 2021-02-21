%MÉTODO DE INTERPOLACIÓN DE LAGRANGE
% Función para crear un interpolador de Lagrange a partir de los siguientes datos:
% x .- vector discreto de la variable independiente
% fx .- valor de la función en los puntos x
clear all;
clc;
 %Vector de la variable independiente de la función original
    %xo=linspace(-5,5,1000);
%función original
    %fxo = (xo.^2).*exp(-xo);

% Vector de la variable independiente
    x = [0;10;20;30;40;50];
% Valor de la función Y
    %fx = cos(x.^2)+x.^3-3*x.^2+exp(-2*x);
    fx= [0.013;0.025;0.032;0.044;0.052;0.07];


% Número de muestras
N = length(x);

% Algoritmo para calcular los coeficientes.
for k=1:N
for m=1:N
if k==m
ind = 1; % Índice para omitir el dato cuando k=m.
else
FN(k,m-ind) = x(m); % Factores del numerador (raíces del polinomio).
FD(k,m-ind) = x(k)-x(m); % Factores del denominador.
end
end
ind = 0; % Se pone en cero para sólo omitir el caso k=m.
end
% Cálculo de los coeficientes del numerador de cada polinomio.
for k = 1:N
CN(k,:) = poly(FN(k,:));
end
Fac = prod(FD,2); % Multiplica los factores de cada denominador.
% Rutina para multiplicar cada polinomio por el factor correspondiente.
for k = 1:N
Multi(k,:) = CN(k,:)*fx(k)/Fac(k);
end
Coef = sum(Multi); % Calcula los coeficientes del polinomio interpolador.


xp = (-20:0.01:100); % Vector por evaluar en puntos entre el límite inferior y
% superior.
Fxp = polyval(Coef,xp); % Evaluación de la función en todos los puntos propuestos.
% Gráficas de los puntos iniciales y el polinomio interpolador

plot(x,fx,'*',xp,Fxp,'r'); 
legend('Puntos iniciales','Polinomio interpolador')
%Ejes de la repesentación gráfica
axis([-20,100,-.2,.2]) 


%%%%%Coef da los coeficientes ordenados de mayor a menor con uno menor al
%%%%%numero de puntos.

% f=@(x)(1./(1+x.^2));
% x=[-2; -1.5; -1; -0.5; 0; 0.5; 1; 1.5; 2];
% f(x)
% P=@(x)(0.0246*x.^8-0.2092*x.^6+0.6292*x.^4-0.9446*x.^2+1);
% P(x)
% [f(x),P(x),abs(f(x)-P(x))]