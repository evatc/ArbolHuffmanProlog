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
    texto_a_bits_lista(ListaChars,Bits),
    append(Codigo,Bits,Union).


%Traducción de string de códigos a string de carácteres
bits_a_texto(BitsString, Texto) :-
 string_chars(BitsString, ListaBitsChars),
 maplist(atom_number, ListaBitsChars, Bits),
 bits_a_texto_lista(Bits, ListaChars),
 string_chars(Texto, ListaChars).

bits_a_texto_lista([], []).  % Caso base: si no hay bits, no hay caracteres.
bits_a_texto_lista(Bits, [Char|Chars]) :-
    mi_arbol(Arbol),               
    recorrer_arbol(Bits, Arbol, Char, RestBits), 
    bits_a_texto_lista(RestBits, Chars).  

% Recorre el árbol de Huffman usando los bits para encontrar un carácter.
recorrer_arbol(Bits, hoja(C, _), C, Bits). 
recorrer_arbol([0|Bits], rama(I, _), Char, RestBits) :-
    recorrer_arbol(Bits, I, Char, RestBits).
recorrer_arbol([1|Bits], rama(_, D), Char, RestBits) :-
    recorrer_arbol(Bits, D, Char, RestBits). 


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
    Char2 \= hoja(Char,_),
    frecuencia_caracter(Char,ListaChars,NuevaLista).

construir_arbol([Nodo],Nodo).
construir_arbol([Nodo1,Nodo2|ListaNodos],Arbol):-
    crear_rama(Nodo1,Nodo2,R),
    insertar_nodo(R,ListaNodos,NuevaLista),
    construir_arbol(NuevaLista,Arbol).

crear_rama(Nodo1,Nodo2,rama(Nodo1,Nodo2)).

% Declaramos tabla_codigo como dinámico para poder agregar y eliminar hechos.
:- dynamic tabla_codigo/2.

% Generar la tabla de códigos a partir del árbol de Huffman.
generar_tabla_codigos :-
    retractall(tabla_codigo(_, _)),  
    mi_arbol(Arbol),                 
    recorrer_arbol_generar_tabla(Arbol, []). 

% Recorre el árbol y genera el código para cada hoja.
recorrer_arbol_generar_tabla(hoja(C, _), Codigo) :-
    asserta(tabla_codigo(C, Codigo)), 
    fail.                            
recorrer_arbol_generar_tabla(rama(Izq, Der), Codigo) :-
    append(Codigo, [0], CodigoIzq),   
    recorrer_arbol_generar_tabla(Izq, CodigoIzq),
    append(Codigo, [1], CodigoDer),   
    recorrer_arbol_generar_tabla(Der, CodigoDer).
recorrer_arbol_generar_tabla(_, _).   

% Convierte un texto en una lista de bits usando la tabla de códigos.
texto_a_bits2(Texto, StringBits) :-
    atom_chars(Texto, ListaChars),    
    maplist(codigo_de_caracter, ListaChars, ListaBits), 
    flatten(ListaBits, BitsFlatten), 
    atomic_list_concat(BitsFlatten, '', AtomicBits), 
    atom_string(AtomicBits, StringBits). 

% Obtiene el código de un carácter usando la tabla.
codigo_de_caracter(Char, Codigo) :-
    tabla_codigo(Char, Codigo).

% Convierte una lista de bits en un texto usando la tabla de códigos.
bits_a_texto2(BitsString, Texto) :-
    string_chars(BitsString, ListaBitsChars), 
    maplist(atom_number, ListaBitsChars, Bits), 
    bits_a_lista_chars(Bits, ListaChars),       
    string_chars(Texto, ListaChars).           

% Traduce bits en caracteres según la tabla.
bits_a_lista_chars([], []).  % Caso base: sin bits, sin caracteres.
bits_a_lista_chars(Bits, [Char|Chars]) :-
    extraer_codigo(Bits, Char, RestBits),  
    bits_a_lista_chars(RestBits, Chars).  

% Extrae el primer carácter correspondiente de los bits.
extraer_codigo(Bits, Char, RestBits) :-
    tabla_codigo(Char, Codigo),  
    append(Codigo, RestBits, Bits).   
