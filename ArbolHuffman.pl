mi_arbol1(rama(rama(hoja(a,5),hoja(b,4)),hoja(e,3))).
mi_arbol(rama(hoja(s,4),rama(hoja(o,3),rama(hoja(e,2),hoja(i,2))))).

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


%Traducción de string de códigos a string de carácteres
%
%
%
%
%
%
%

%Construcción del árbol de Huffman

% Funciones necesareas para ordenar una lista de nodos
insertar_nodo(Nodo,[],[Nodo]).
insertar_nodo(Nodo1,[Nodo2|Resto],[Nodo1, Nodo2|Resto]):-
    peso(Nodo1,Peso1),
    peso(Nodo2,Peso2),
    Peso1=<Peso2.
insertar_nodo(Nodo1,[Nodo2|Resto],[Nodo2|ListaNueva]):-
    peso(Nodo1,Peso1),
    peso(Nodo2,Peso2),
    Peso1>=Peso2,
    insertar_nodo(Nodo1,Resto,ListaNueva).

ordenar_hojas([],[]).
ordenar_hojas([Nodo|ListaHojas], ListaHojasOrdenada):-
    ordenar_hojas(ListaHojas,ListaParcialmenteOrdenada),
    insertar_nodo(Nodo,ListaParcialmenteOrdenada,ListaHojasOrdenada).

% Construir la lista de hojas ordenada
string_a_lista_hojas(String, ListaHojasOrdenada) :-
    string_chars(String, ListaChars),
    crear_lista_hojas(ListaChars, [], ListaHojas),
    ordenar_hojas(ListaHojas, ListaHojasOrdenada).

% Transforma la lista de caracteres en una lista de hojas con
% sus respectivas frecuencias, pero desordenadas
crear_lista_hojas([],ListaHojas,ListaHojas).
crear_lista_hojas([Char|ListaChars],ListaTemp,ListaHojas):-
    frecuencia_caracter(Char,ListaTemp,NuevaLista),
    crear_lista_hojas(ListaChars,NuevaLista,ListaHojas).

frecuencia_caracter(Char,[],[hoja(Char,1)]).
frecuencia_caracter(Char,[hoja(Char,Frec)|ListaChars],[hoja(Char,NuevaFrec)|ListaChars]):-
    NuevaFrec is Frec+1.
frecuencia_caracter(Char,[Char2|ListaChars],[Char2|NuevaLista]):-
    frecuencia_caracter(Char,ListaChars,NuevaLista).

construir_arbol([Nodo],Arbol).
construir_arbol([Nodo1,Nodo2|ListaNodos],Arbol):-
    crear_rama(Nodo1,Nodo2,R),
    insertar_nodo(R,ListaNodos,NuevaLista),
    construir_arbol(NuevaLista,Arbol).

crear_rama(Nodo1,Nodo2,rama(Nodo1,Nodo2)).
