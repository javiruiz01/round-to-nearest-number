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
%     numeroRedondeado(Separador, ListaCifraParteEntera, ListaCifraParteDecimal).

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
recorrerParteDecimal(TipoRedondeo, [], ParteEntera, ParteDecimal, Separador, redondeo(TipoRedondeo, numeroOriginal(Separador, ParteEntera, ParteDecimal), numeroRedondeado(Separador, ParteEnteraF, ParteDecimalF))):-
    construirNumeroFinal(redondeo(TipoRedondeo, numeroOriginal(Separador, ParteEntera, ParteDecimal), numeroRedondeado(Separador, ParteEnteraF, ParteDecimalF))).
recorrerParteDecimal(TipoRedondeo, [X | T], ParteEntera, ParteDecimal, Separador, NumeroFinal):-
    my_append(ParteDecimal, [X],  Z),
    recorrerParteDecimal(TipoRedondeo, T, ParteEntera, Z, Separador, NumeroFinal).

construirNumeroFinal(redondeo(redondeoUnidad, numeroOriginal(Separador, ParteEnteraO, [X | _]), numeroRedondeado(Separador, ParteEnteraF, ParteDecimalF))):-
    reverse(ParteEnteraO, Z),
    comprobarParteEntera(Z, X, Zs),
    reverse(Zs, [Y | U]),
    comprobarAcarreoUnidad(U, Y, U, [], Salida),
    Salida = ParteEnteraF,
    [] = ParteDecimalF.
construirNumeroFinal(redondeo(redondeoDecimas, numeroOriginal(Separador, ParteEnteraO, [ X, Y | _ ]), numeroRedondeado(Separador, ParteEnteraF, ParteDecimalF))):-
    redondearParteDecimal([X, Y], NuevaParteDecimal),
    reverse(ParteEnteraO, Z),
    comprobarAcarreoEntero(Z, NuevaParteDecimal, SalidaEntera, SalidaDecimal),
    SalidaEntera = ParteEnteraF,
    SalidaDecimal = ParteDecimalF.
construirNumeroFinal(redondeo(redondeoCentesimas, numeroOriginal(_, ParteEnteraO, [W, X, Y | _]), numeroRedondeado(_, ParteEnteraF, ParteDecimalF))) :-
    redondearParteDecimal([X, Y], Salida),
    my_append([W], [Salida], Z),
    reverse(Z, Zs),
    comprobarAcarreo(Zs, Decimal),
    reverse(ParteEnteraO, PEnteraRev),
    comprobarAcarreoEntero(PEnteraRev, Decimal, SalidaEntera, SalidaDecimal),
    SalidaEntera = ParteEnteraF,
    SalidaDecimal = ParteDecimalF.

comprobarParteEntera(ParteEntera, Referencia, Salida) :-
    less_or_equal(Referencia, s(s(s(s(0))))),
    reverse(ParteEntera, Salida).
comprobarParteEntera([Elemento | T], Referencia, Salida) :-
    less_or_equal(s(s(s(s(0)))), Referencia),
    peano_add(Elemento, s(0), NewElemento),
    my_append([NewElemento], T, Z),
    reverse(Z, Salida).

% Creo que no hace falta que se le pase la parte entera, nos encargamos en otro sitio
redondearParteDecimal([Elemento, Referencia | _], Salida) :-
    less_or_equal(Referencia, s(s(s(s(0))))),
    peano_add(Elemento, 0, Salida).
redondearParteDecimal([Elemento, Referencia | _], Salida) :-
    less_or_equal(s(s(s(s(0)))), Referencia),
    peano_add(Elemento, s(0), Salida).

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

comprobarAcarreoEntero([X | T], Ref, SalidaEntera, SalidaDecimal) :-
    Ref = s(s(s(s(s(s(s(s(s(s(0)))))))))),
    peano_add(X, s(0), Xs),
    SalidaDecimal = [],
    comprobarAcarreoUnidad(T, Xs, T, [], SalidaEntera).
comprobarAcarreoEntero(ParteEntera, [Ref | T], SalidaEntera, SalidaDecimal) :-
    Ref \= s(s(s(s(s(s(s(s(s(s(0)))))))))),
    my_append([Ref], T, Refs),
    SalidaDecimal = Refs,
    reverse(ParteEntera, SalidaEntera).
comprobarAcarreoEntero(ParteEntera, Ref, SalidaEntera, SalidaDecimal) :-
    Ref \= s(s(s(s(s(s(s(s(s(s(0)))))))))),
    SalidaDecimal = [],
    reverse(ParteEntera, SalidaEntera).

comprobarAcarreoUnidad([], s(s(s(s(s(s(s(s(s(s(0)))))))))), [], New, Salida) :-
    my_append(New, [0], NewS),
    my_append(NewS, [s(0)], Newss),
    reverse(Newss, Salida).
comprobarAcarreoUnidad([], Ref, [], New, Salida) :-
    Ref \= s(s(s(s(s(s(s(s(s(s(0)))))))))),
    my_append([Ref], New, Salida).
comprobarAcarreoUnidad([X | T], Ref, [Y | U], New, Salida) :-
    Ref = s(s(s(s(s(s(s(s(s(s(0)))))))))),
    peano_add(X, s(0), Xs),
    append(New, [0], NewS),
    comprobarAcarreoUnidad(T, Xs, U, NewS, Salida).
comprobarAcarreoUnidad([X | T], Ref, [Y | U], New, Salida) :-
    Ref \= s(s(s(s(s(s(s(s(s(s(0)))))))))),
    append(New, [Ref], NewS),
    append(NewS, [X], Ts),
    reverse(Ts, Salida).

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
% Funciona: redondearDecimal([s(s(s(s(s(0))))),',',s(s(s(0)))], redondeoUnidad, redondeo(redondeoUnidad, numeroOriginal(',', [s(s(s(s(s(0)))))], [s(s(s(0)))]), numeroRedondeado(',', [s(s(s(s(s(0)))))], []))).
% Funciona: redondearDecimal([s(0), s(0), ',', s(s(s(s(s(s(s(s(s(0))))))))) , s(s(s(s(s(0)))))], redondeoDecimas, redondeo(redondeoDecimas, numeroOriginal(',', [s(0), s(0)], [s(s(s(s(s(s(s(s(s(0))))))))), s(s(s(s(s(0)))))]), numeroRedondeado(',', [s(0), s(s(0))], []))).
% Funciona: redondearDecimal([s(0), s(s(s(s(s(s(s(s(s(0))))))))), ',', s(s(s(s(s(0)))))], redondeoUnidad, redondeo(redondeoUnidad, numeroOriginal(',', [s(0), s(s(s(s(s(s(s(s(s(0)))))))))], [s(s(s(s(s(0)))))]), numeroRedondeado(',', [s(s(0)), 0], []))).
% Funciona: redondearDecimal([s(0), s(s(s(s(s(s(s(s(s(0))))))))), ',', s(s(s(s(s(s(s(s(s(0))))))))), s(s(s(s(s(0)))))], redondeoDecimas, redondeo(redondeoDecimas, numeroOriginal(',', [s(0), s(s(s(s(s(s(s(s(s(0)))))))))], [s(s(s(s(s(s(s(s(s(0))))))))), s(s(s(s(s(0)))))]), numeroRedondeado(',', [s(s(0)), 0], []))).
% Funciona: redondearDecimal([s(0), ',', s(s(s(0))), s(s(s(s(s(0))))), s(0)], redondeoCentesimas, redondeo(redondeoCentesimas, numeroOriginal(',', [s(0)], [s(s(s(0))), s(s(s(s(s(0))))), s(0)]), numeroRedondeado(',', [s(0)], [s(s(s(0))), s(s(s(s(s(0)))))]))).
% Funciona: redondearDecimal([s(0), s(s(s(s(s(s(s(s(s(0))))))))), ',', s(s(s(s(s(s(s(s(s(0))))))))), s(s(s(s(s(0)))))], redondeoDecimas, redondeo(redondeoDecimas, numeroOriginal(',', [s(0), s(s(s(s(s(s(s(s(s(0)))))))))], [s(s(s(s(s(s(s(s(s(0))))))))), s(s(s(s(s(0)))))]), numeroRedondeado(',', [s(s(0)), 0], []))).
% redondearDecimal([s(s(s(s(s(s(s(s(s(0))))))))), s(s(s(s(s(s(s(s(s(0))))))))), s(s(s(s(s(s(s(s(s(0))))))))), ',', s(s(s(s(s(s(s(s(s(0)))))))))], redondeoUnidad, redondeo(redondeoUnidad, numeroOriginal(',', [s(s(s(s(s(s(s(s(s(0))))))))),s(s(s(s(s(s(s(s(s(0))))))))),s(s(s(s(s(s(s(s(s(0)))))))))], [s(s(s(s(s(s(s(s(s(0)))))))))]), numeroRedondeado(',', [s(0), 0, 0, 0], []))).