% Autor
% Javier Ruiz Calle, Sergio Redondo, Jaime Merlín

% INFO:
% Representación de números en Peano
% redondearDecimal(NumeroInicial, TipoRedondeo, NumeroFinal).
% TipoRedondeo => redondeoUnidad     -> decimas < 5 => nop
%                                    -> decimas >= 5 => + 1 unidad
%              => redondeoDecimas    -> centesimas < 5 => nop
%                                    -> centesimas >= 5 => +1 decima
%              => redondeoCentesimas -> milesimas < 5 => nop
%                                    -> milesimas >= 5 => +1 centesima

% Numero final es de "tipo" redondeo:
%     redondeo(TipoRedondeo, NumeroOriginal, NumeroFinal).

% NumeroOriginal y NumeroFinal tienen la misma forma:
%     numeroOriginal(Separador, ListaCifraParteEntera, ListaCifraParteDecimal).
%     numeroFinal(Separador, ListaCifraParteEntera, ListaCifraParteDecimal).

:- module(_,_).

redondearDecimal(NumeroInicial, TipoRedondeo, NumeroFinal):-
    leerTipo(TipoRedondeo, NumeroInicial, NumeroFinal).

% Unificación del tipo de rendodeo
leerTipo(redondeoUnidad, NumeroInicial, NumeroFinal):-
    recorrerParteEntera(NumeroInicial, NumeroFinal).

leerTipo(redondeoDecimas, NumeroInicial, NumeroFinal):-.

leerTipo(redondeoCentesimas, NumeroInicial, NumeroFinal):-.

% Deberíamos ir guardando en una lista el valor de la parte entera
recorrerParteEntera([',' | T], NumeroFinal):-
    recorrerParteDecimal(T, NumeroFinal).
recorrerParteEntera([X | T], NumeroFinal):-
    X \= ',',
    recorrerParteEntera(T, NumeroFinal).

% Recorremos la parte decimal y se guarda en una lista,
% Para luego crear NumeroFinal
recorrerParteDecimal([X | T], NumeroFinal):-.

% Suma Peano
peano_add(0, N, N).
peano_add( s(N), M, s(Sum) ) :-
	peano_add( N, M, Sum ).
