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


%Traducción de carácter a código
char_codigohuff(Codigo, Caracter) :-
    mi_arbol(Arbol),
    char_codigohuff_arbol(Codigo, Arbol, Caracter).

char_codigohuff_arbol([], hoja(C,_), C).
char_codigohuff_arbol([0|Codigo], rama(I,_), Caracter) :-
    char_codigohuff_arbol(Codigo,I,Caracter).

char_codigohuff_arbol([1|Codigo], rama(_,D), Caracter) :-
    char_codigohuff_arbol(Codigo,D,Caracter).

%Traducción de código a carácter
codigohuff_char(Codigo, Caracter) :-
    mi_arbol(Arbol),
    codigohuff_char_arbol(Codigo, Arbol, Caracter).

codigohuff_char_arbol([], hoja(C,_), C).
codigohuff_char_arbol([0|Codigo],rama(I,_),Caracter) :-
    codigohuff_char_arbol(Codigo,I,Caracter).

codigohuff_char_arbol([1|Codigo],rama(_,D),Caracter) :-
    codigohuff_char_arbol(Codigo,D,Caracter).


%Traducción de string de carácteres a string de códigos
texto_a_bits(Texto, StringBits) :-
    atom_chars(Texto, ListaChars),
    texto_a_bits_lista(ListaChars, Bits),
    maplist(number_chars, Bits, ListaBitsChars),
    flatten(ListaBitsChars, ListaBitsFlatten),
    atomic_list_concat(ListaBitsFlatten, '', AtomicBits),
    atom_string(AtomicBits,StringBits).

texto_a_bits_lista([],[]).
texto_a_bits_lista([A|ListaChars],Union) :-
    char_codigohuff(Codigo,A),
    append(Codigo,Bits,Union),
    texto_a_bits_lista(ListaChars,Bits).
