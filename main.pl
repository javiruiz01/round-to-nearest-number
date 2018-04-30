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
    comprobarParteEntera(Z, X, Zs),
    reverse(Zs, [Y | U]),
    comprobarAcarreoUnidad(U, Y, Salida),
    Salida = ParteEnteraF,
    [] = ParteDecimalF.

comprobarAcarreoUnidad([X | T], Ref, Salida) :-
    Ref = s(s(s(s(s(s(s(s(s(s(0)))))))))),
    peano_add(X, s(0), Xs),
    my_append([0], [Xs], Refs),
    my_append(Refs, T, [Y | U]),
    comprobarAcarreoUnidad(U, Y, Salida).
comprobarAcarreoUnidad([X | T], Ref, Salida) :-
    Ref \= s(s(s(s(s(s(s(s(s(s(0)))))))))),
    my_append([Ref], [X], Refs),
    my_append(Refs, T, Ts),
    reverse(Ts, Salida).

comprobarParteEntera(ParteEntera, Referencia, Salida) :-
    less_or_equal(Referencia, s(s(s(s(0))))),
    reverse(ParteEntera, Salida).
comprobarParteEntera([Elemento | T], Referencia, Salida) :-
    less_or_equal(s(s(s(s(0)))), Referencia),
    peano_add(Elemento, s(0), NewElemento),
    my_append([NewElemento], T, Z),
    reverse(Z, Salida).

construirNumeroFinal(redondeo(redondeoDecimas, numeroOriginal(Separador, ParteEnteraO, [ X, Y | _ ]), numeroFinal(Separador, ParteEnteraF, ParteDecimalF))):-
    redondearParteDecimal(ParteEnteraO, [X, Y], NuevaParteDecimal),
    reverse(ParteEnteraO, Z),
    comprobarAcarreoEntero(Z, NuevaParteDecimal, SalidaEntera, SalidaDecimal),
    SalidaEntera = ParteEnteraF,
    [SalidaDecimal] = ParteDecimalF.

construirNumeroFinal(redondeo(redondeoCentesimas, numeroOriginal(Separador, ParteEnteraO, [W, X, Y | T]), numeroFinal(Separador, ParteEnteraF, ParteDecimalF))) :-
    redondearParteDecimal(ParteEnteraO, [X, Y], Salida),
    my_append([W], [Salida], Z),
    ParteEnteraO = ParteEnteraF,
    Z = ParteDecimalF.

redondearParteDecimal(ParteEnteraO, [Elemento, Referencia | _], Salida) :-
    less_or_equal(Referencia, s(s(s(s(0))))),
    peano_add(Elemento, 0, Salida).
redondearParteDecimal(ParteEnteraO, [Elemento, Referencia | _], Salida) :-
    less_or_equal(s(s(s(s(0)))), Referencia),
    peano_add(Elemento, s(0), Salida).

comprobarAcarreoEntero([X | T], Ref, SalidaEntera, SalidaDecimal) :-
    Ref = s(s(s(s(s(s(s(s(s(s(0)))))))))),
    peano_add(X, s(0), Xs),
    SalidaDecimal = 0,
    comprobarAcarreo([Xs | T], SalidaEntera).
comprobarAcarreoEntero(ParteEntera, Ref, Salida) :-
    Ref \= s(s(s(s(s(s(s(s(s(s(0)))))))))),
    reverse(ParteEntera, Salida).

comprobarAcarreo([X], Salida) :-
    [X] = Salida.
comprobarAcarreo([X | T], Salida) :-
    X \= s(s(s(s(s(s(s(s(s(s(0)))))))))),
    my_append([X], T, Z),
    reverse(Z, Salida).
comprobarAcarreo([X | T], _) :-
    X = s(s(s(s(s(s(s(s(s(s(0)))))))))),
    acarreo(T).

acarreo([X|T]) :-
    peano_add(X, s(0), Xs),
    my_append([Xs], T, Ts),
    comprobarAcarreo(Ts, _).

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
% redondearDecimal([s(s(s(s(s(0))))),',',s(s(s(0)))], redondeoUnidad, X). --> Mirar a ver como hacer para que nos devuevla la respuesta
% redondearDecimal([s(0), s(0), ',', s(s(s(s(s(s(s(s(s(0))))))))) , s(s(s(s(s(0)))))], redondeoDecimas, redondeo(redondeoDecimas, numeroOriginal(',', [s(0), s(0)], [s(s(s(s(s(s(s(s(s(0))))))))), s(s(s(s(s(0)))))]), numeroRedondeado(',', [s(0), s(s(0))], []))).
% redondearDecimal([s(0), ',', s(s(s(0))), s(s(s(s(s(0))))), s(0)], redondeoCentesimas, redondeo(redondeoCentesimas, numeroOriginal(',', [s(0)], [s(s(s(0))), s(s(s(s(s(0))))), s(0)]), numeroRedondeado(',', [s(0)], [s(s(s(0))), s(s(s(s(s(0)))))]))).
% redondearDecimal([s(0), s(s(s(s(s(s(s(s(s(0))))))))), ',', s(s(s(s(s(0)))))], redondeoUnidad, redondeo(redondeoUnidad, numeroOriginal(',', [s(0), s(s(s(s(s(s(s(s(s(0)))))))))], [s(s(s(s(s(0)))))]), numeroRedondeado(',', [s(s(0)), 0], []))).