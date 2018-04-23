% Autor
% Javier Ruiz Calle

:- module(_,_).
redondearDecimal(NumeroInicial, TipoRedondeo, NumeroFinal):-
    leerTipo(TipoRedondeo, NumeroInicial, NumeroFinal).

leerTipo(redondeoUnidad, NumeroInicial, NumeroFinal):-
    recorrerParteEntera(NumeroInicial, NumeroFinal).

leerTipo(redondeoDecimas, NumeroInicial, NumeroFinal):-.

leerTipo(redondeoCentesimas, NumeroInicial, NumeroFinal):-.

recorrerParteEntera([',' | T], NumeroFinal):-
    recorrerParteDecimal().
recorrerParteEntera([X | T], NumeroFinal):-
    X \= ',',
    recorrerParteEntera(T, NumeroFinal).

% Métodos Peano
peano_add(0, N, N).
peano_add( s(N), M, s(Sum) ) :-
	peano_add( N, M, Sum ).
