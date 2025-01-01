mi_arbol(rama(rama(hoja(a,5),hoja(b,4)),hoja(e,3))).

% Implementación del arbol
rama(NodoIzq, NodoDch).
hoja(Car, Peso).
 
% Saber si es un arbol o no
es_arbol_Huffman(rama(NodoIzq, NodoDch)) :-
    es_arbol_Huffman(NodoIzq),
    es_arbol_Huffman(NodoDch).
es_arbol_Huffman(hoja(X, Y)).

% Lista de caracteres
lista_caracteres(hoja(C,_),[C]).
lista_caracteres(rama(I,D),L) :- 
    lista_caracteres(I,LI),
    lista_caracteres(D,LD),
    append(LI,LD,L).

% Peso total
peso(hoja(_,P),P).
peso(rama(I,D),PT) :-
    peso(I,PI),
    peso(D,PD),
    PT is PI + PD.