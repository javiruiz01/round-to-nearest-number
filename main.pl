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

redondearDecimal(NumeroInicial, TipoRedondeo, NumeroFinal) :-
    recorrerParteEntera(TipoRedondeo, NumeroInicial, [], NumeroFinal).

% Recorremos parte entera y se va guardando en una lista
% Luego pasamos a parsear la parte decimal
recorrerParteEntera(TipoRedondeo, [',' | T], ParteEntera, NumeroFinal):-
    recorrerParteDecimal(TipoRedondeo, T, ParteEntera, [], ',',NumeroFinal).
recorrerParteEntera(TipoRedondeo, [X | T], ParteEntera ,NumeroFinal):-
    X \= ',',
    my_append(ParteEntera, [X],  Z),
    recorrerParteEntera(TipoRedondeo, T, Z, NumeroFinal).

% Recorremos la parte decimal y se guarda en una lista,
% Para luego crear NumeroFinal
recorrerParteDecimal(TipoRedondeo, [], ParteEntera, ParteDecimal, Separador, NumeroFinal):-
    construirNumeroFinal(redondeo(TipoRedondeo, numeroOriginal(Separador, ParteEntera, ParteDecimal), numeroFinal(Separador, ParteEnteraF, ParteDecimalF))).
recorrerParteDecimal(TipoRedondeo, [X | T], ParteEntera, ParteDecimal, Separador, NumeroFinal):-
    my_append(ParteDecimal, [X],  Z),
    recorrerParteDecimal(TipoRedondeo, T, ParteEntera, Z, Separador, NumeroFinal).

construirNumeroFinal(redondeo(redondeoUnidad, numeroOriginal(Separador, ParteEnteraO, [X | _]), numeroFinal(Separador, ParteEnteraF, ParteDecimalF))):-
    reverse(ParteEnteraO, Z),
    comprobarParteEntera(Z, X, Salida),
    Salida = ParteEnteraF,
    [] = ParteDecimalF.

comprobarParteEntera(ParteEntera, Referencia, Salida) :-
    less_or_equal(Referencia, s(s(s(s(0))))),
    reverse(ParteEntera, Salida).
comprobarParteEntera([Elemento | T], Referencia, Salida) :-
    less_or_equal(s(s(s(s(0)))), Referencia),
    peano_add(Elemento, s(0), NewElemento),
    append([NewElemento], T, Z),
    reverse(Z, Salida).

construirNumeroFinal(redondeo(redondeoDecimas, numeroOriginal(Separador, ParteEnteraO, [ X, Y | _ ]), numeroFinal(Separador, ParteEnteraF, ParteDecimalF))):-
    redondearParteDecimal(ParteEnteraO, [X, Y], Decimal),
    my_append(ParteEnteraF, ParteEnteraO, Z),
    my_append(ParteDecimalF, [Decimal], Zs).

construirNumeroFinal(redondeo(redondeoCentesimas, numeroOriginal(Separador, ParteEnteraO, [W, X, Y | T]), numeroFinal(Separador, ParteEnteraF, ParteDecimalF))) :-
    redondearParteDecimal(ParteEnteraO, [X, Y], Decimal),
    my_append(ParteEnteraF, ParteEnteraO, Z),
    my_append(ParteDecimalF, [W, Decimal], Zs).

redondearParteDecimal(ParteEnteraO, [Elemento, Referencia | _], Salida) :-
    less_or_equal(Referencia, s(s(s(s(0))))),
    peano_add(Elemento, 0, Z).
redondearParteDecimal(ParteEnteraO, [Elemento, Referencia | _], Salida) :-
    less_or_equal(s(s(s(s(0)))), Referencia),
    peano_add(Elemento, s(0), Salida),
    reverse(Z, Zs),
    comprobarAcarreo(Zs).

comprobarAcarreo([X | T]) :-
    X = s(s(s(s(s(s(s(s(s(s(0)))))))))),
    acarreo(T, s(0)).
acarreo([X|T], s(0)) :-
    peano_add(X, s(0), Xs),
    my_append([Xs], T, Ts),
    comprobarAcarreo(Ts).

% Métodos auxiliares
less_or_equal(0,X) :-
    nat(X).
less_or_equal(s(X),s(Y)) :-
    less_or_equal(X,Y).

nat(0).
nat(s(X)) :-
    nat(X).

my_append([], Y, Y).
my_append([H|X], Y, [H|Z]) :-
    my_append(X, Y, Z).

peano_add(0, N, N).
peano_add( s(N), M, s(Sum) ) :-
	peano_add( N, M, Sum ).

% Ejemplo
% redondearDecimal([s(s(s(s(s(0))))),',',s(s(s(0)))], redondeoUnidad, redondeo(redondeoUnidad, numeroOriginal(',', [s(s(s(s(s(0)))))], [s(s(s(0)))]), numeroRedondeado(',', [s(s(s(s(s(0)))))], []))).
% redondearDecimal([s(0), ',', s(s(s(s(s(s(s(0))))))), s(s(s(s(s(s(s(s(0))))))))], redondeoDecimas, X).