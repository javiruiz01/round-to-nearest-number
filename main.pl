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

numeroFinal(Separador, ParteEnteraF, ParteDecimalF).

redondearDecimal(NumeroInicial, TipoRedondeo, NumeroFinal):-
    recorrerParteEntera(TipoRedondeo, NumeroInicial, [], NumeroFinal).

% Recorremos parte entera y se va guardando en una lista
% Luego pasamos a parsear la parte decimal
recorrerParteEntera(TipoRedondeo, [',' | T], ParteEntera, NumeroFinal):-
    recorrerParteDecimal(TipoRedondeo, T, ParteEntera, [], ',',NumeroFinal).
recorrerParteEntera(TipoRedondeo, [X | T], ParteEntera ,NumeroFinal):-
    X \= ',',
    append(ParteEntera, [X],  Z),
    recorrerParteEntera(TipoRedondeo, T, Z, NumeroFinal).

% Recorremos la parte decimal y se guarda en una lista,
% Para luego crear NumeroFinal
recorrerParteDecimal(TipoRedondeo, [], ParteEntera, ParteDecimal, Separador, NumeroFinal):-
    construirNumeroFinal(redondeo(TipoRedondeo, numeroOriginal(Separador, ParteEntera, ParteDecimal), numeroFinal(Separador, [], []))).
recorrerParteDecimal(TipoRedondeo, [X | T], ParteEntera, ParteDecimal, Separador, NumeroFinal):-
    append(ParteDecimal, [X],  Z),
    recorrerParteDecimal(TipoRedondeo, T, ParteEntera, Z, Separador, NumeroFinal).

construirNumeroFinal(redondeo(redondeoUnidad, numeroOriginal(Separador, ParteEnteraO, ParteDecimalO), numeroFinal(Separador, ParteEnteraF, ParteDecimalF))).

construirNumeroFinal(redondeo(redondeoDecimas, numeroOriginal(Separador, ParteEnteraO, [ X, Y | _ ]), numeroFinal(Separador, ParteEnteraF, ParteDecimalF))):-
    % Uso de less or equals para saber si tenemos que redondear o no
    redondear(X, Y, Salida),
    reverse(Salida, Z), % Porque el append añade por delante
    comprobarAcarreoParteDecimal(Z, SalidaDecimal),
    reverse(ParteEnteraO, W),
    comprobarAcarreoParteEntera(W, Z, SalidaEntera),
    reverse(Z, Zs),
    reverse(SalidaEntera, Ws),
    numeroFinal(Separador, Ws, Zs).

redondear(Elemento, Referencia, Salida) :-
    less_or_equal(Referencia, s(s(s(s(0))))),
    peano_add(Elemento, 0, Z),
    append([Z], [], Salida).
redondear(Elemento, Referencia, Salida) :-
    peano_add(Elemento, s(0), Z),
    append([Z], [], Salida).

comprobarAcarreoParteDecimal([X | T], Salida):-
    X = s(s(s(s(s(s(s(s(s(s(0)))))))))),
    suma(T, Salida),
    comprobarAcarreoParteDecimal(T, Salida).
comprobarAcarreoParteDecimal([X | T], Salida):-
    peano_add(X, 0, Z),
    comprobarAcarreoParteDecimal(T, Z).

comprobarAcarreoParteEntera([X | T], [Y | _], SalidaEntera) :-
    X = s(s(s(s(s(s(s(s(s(s(0)))))))))),
    suma(T, SalidaEntera),
    comprobarAcarreoParteEntera(SalidaEntera, Y, SalidaEntera).

suma([X | T], Salida):-
    peano_add(X, s(0), Z),
    append([Z], T, Salida).

construirNumeroFinal(redondeo(redondeoCentesimas, numeroOriginal(Separador, ParteEnteraO, ParteDecimalO), numeroFinal(Separador, ParteEnteraF, ParteDecimalF))).

% recorrerParteEntera(redondeoUnidad, [s(0),',',s(s(s(0)))], [], []).

% Métodos auxiliares
less_or_equal(0,X) :-
    nat(X).
less_or_equal(s(X),s(Y)) :-
    less_or_equal(X,Y).

nat(0).
nat(s(X)) :-
    nat(X).

append([], Y, Y).
append([H|X], Y, [H|Z]) :-
    append(X, Y, Z).

peano_add(0, N, N).
peano_add( s(N), M, s(Sum) ) :-
	peano_add( N, M, Sum ).
