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
    % leerTipo(TipoRedondeo, NumeroInicial, NumeroFinal).
    recorrerParteEntera(TipoRedondeo, NumeroInicial, [], NumeroFinal).

% Recorremos parte entera y se va guardando en una lista
% Luego pasamos a parsear la parte decimal
recorrerParteEntera(TipoRedondeo, [',' | T], ParteEntera, NumeroFinal):-
    recorrerParteDecimal(TipoRedondeo, T, ParteEntera, [], NumeroFinal).
recorrerParteEntera(TipoRedondeo, [X | T], ParteEntera ,NumeroFinal):-
    X \= ',',
    append(X, ParteEntera, Z),
    recorrerParteEntera(TipoRedondeo, T, Z, NumeroFinal).

% Recorremos la parte decimal y se guarda en una lista,
% Para luego crear NumeroFinal
recorrerParteDecimal(TipoRedondeo, [], ParteEntera, ParteDecimal, NumeroFinal):-
    construirNumeroFinal(TipoRedondeo, ParteEntera, ParteDecimal, NumeroFinal).
recorrerParteDecimal(TipoRedondeo, [X | T], ParteEntera, ParteDecimal, NumeroFinal):-
    append(X, ParteDecimal, Z),
    recorrerParteDecimal(TipoRedondeo, T, ParteEntera, Z, NumeroFinal).

construirNumeroFinal(redondeoUnidad, ParteEntera, ParteDecimal, NumeroFinal).
construirNumeroFinal(redondeoDecimas, ParteEntera, ParteDecimal, NumeroFinal).
construirNumeroFinal(redondeoCentesimas, ParteEntera, ParteDecimal, NumeroFinal).

% recorrerParteEntera(redondeoUnidad, [s(s(s(s(s(0))))),',',s(s(s(0)))], [], []).

% Suma Peano
peano_add(0, N, N).
peano_add( s(N), M, s(Sum) ) :-
	peano_add( N, M, Sum ).
