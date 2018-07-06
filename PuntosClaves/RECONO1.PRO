/* reconocimiento mediante puntos clave */
predicates
	start
	borrar
	hacer_triangulo(integer,integer,integer)
	hacer_izquierda(integer,integer,integer)
	hacer_derecha(integer,integer,integer)
	hacer_base(integer,integer,integer)
	hacer_cuadrado(integer,integer,integer)
	hacer_arriba_abajo(integer,integer,integer)
	hacer_derechalado(integer,integer,integer)
	hacer_izquierdalado(integer,integer,integer)
	hacer_rt_izquierda(integer,integer,integer)
	hacer_rt_derecha(integer,integer,integer)
	hacer_triangulo_rectangulo(integer,integer,integer)
	posicion
	reconocer
	encontrar_triangulo(integer,integer)
	encontrar_cuadrado(integer,integer)
	encontrar_punto(integer,integer,integer,integer)
	es_triangulo(integer,integer)

goal
	start.

clauses
	start:-
		borrar,
		posicion,
		reconocer.

/* intentar encontrar objetos */
reconocer:-
	cursor(0,0),
	encontrar_triangulo(0,0),
	cursor(1,0),
	encontrar_cuadrado(0,0).

encontrar_triangulo(R,C):-
	encontrar_punto(R,C,A,B),
	es_triangulo(A,B),
	write("Triangulo en ",A," ",B," "),
	R1 = A + 1, C1 = C + 1,
	encontrar_triangulo(R1,C1).
encontrar_triangulo(_,_).

/* buscar posiciones apropiadas */
es_triangulo(R,C):- /* triangulo rectangulo */
	R1 = R + 9,
	R1 < 24,
	scr_char(R1,C,Ch),
	Ch = '*',
	C1 = C + 9,
	C1 < 80,
	scr_char(R,C1,Ch1),
	Ch1 = '*',
	C2 = C + 1,
	R2 = R1 - 1,
	scr_char(R2,C2,Ch2),
	Ch2 = '*'.
es_triangulo(R,C):- /* isosceles */
	R1 = R + 5,
	C1 = C - 5,
	R1 < 24, C1 > 0,
	scr_char(R1,C1,Ch),
	Ch= '*',
	C2 = C + 5, C2 < 80,
	scr_char(R1,C2,Ch1),
	Ch1 = '*'.

encontrar_cuadrado(R,C):-
	encontrar_punto(R,C,A,B),
	A1 = A + 5,
	B1 = B + 9,
	A1 < 25,
	B1 < 81,
	scr_char(A1,B,Ch),
	Ch = '*',
	scr_char(A1,B1,Ch1),
	Ch1 = '*',
	scr_char(A,B1,Ch2),
	Ch2 = '*',
	A2 = A + 1,
	B2 = B + 1,
	write("Cuadrado en  ",A," ",B," "),
	encontrar_cuadrado(A2,B2).
encontrar_cuadrado(_,_).

encontrar_punto(A,B,R,C):-
	scr_char(A,B,Ch),
	Ch = '*',
	R = A, C = B.
encontrar_punto(A,B,R,C):-
	 B1 = B + 1,
	 B1 < 80,
	 !,
	 encontrar_punto(A,B1,R,C).
encontrar_punto(A,_,R,C):-
	A1 = A + 1,
	A1 < 24,
	!,
	encontrar_punto(A1,0,R,C).
encontrar_punto(_,_,_,_):-fail.

/*poner objetos en pantalla*/
posicion:-
	write("coordenadas para el triangulo isoceles: "),
	readint(R),write(","),readint(C),
	write("coordenadas para le triangulo rectangulo: "),
	readint(R2),write(","),readint(C2),
	write("coordenadas para cuadrado: "),
	readint(R1),write(","),readint(C1),
	borrar,
	hacer_triangulo(R,C,5),
	hacer_cuadrado(R1,C1,5).
	hacer_triangulo(R2,C2,10). /* error aqui*/

hacer_triangulo(R,C,N):-
	hacer_izquierda(R,C,N),
	hacer_derecha(R,C,N),
	hacer_base(R,C,N).
hacer_izquierda(R,C,N):-
	N<>0,
	cursor(R,C),
	write("*"),
	R1 = R + 1,
	C1 = C - 1,
	N1 = N -1,
	hacer_izquierda(R1,C1,N1).
hacer_izquierda(_,_,_).
hacer_derecha(R,C,N):-
	N<>0,
	cursor(R,C),
	write("*"),
	R1 = R + 1,
	C1 = C + 1,
	N1 = N -1,
	hacer_derecha(R1,C1,N1).
hacer_derecha(_,_,_).
hacer_base(R,C,N):-
	R1 = R + N,
	C1 = C - N,
	cursor(R1,C1),
	write("***********").

hacer_triangulo_rectangulo(R,C,N):-
	hacer_rt_izquierda(R,C,N),
	C1 = C + 9,
	hacer_rt_derecha(R,C1,N),
	cursor(R,C),
	write("***********").

hacer_rt_izquierda(R,C,N):-
	N<>0,
	cursor(R,C),
	write("*"),
	R1 = R + 1,
	N1 = N - 1,
	hacer_rt_izquierda(R1,C,N1).
hacer_rt_izquierda(_,_,_).
hacer_rt_derecha(R,C,N):-
	N<>0,
	cursor(R,C),
	write("*"),
	R1 = R + 1,
	C1 = C -1,
	N1 = N - 1,
	hacer_rt_derecha(R1,C,N1).
hacer_rt_derecha(_,_,_).

hacer_cuadrado(R,C,N):-
	hacer_arriba_abajo(R,C,N),
	hacer_izquierdalado(R,C,N),
	hacer_derechalado(R,C,N).

hacer_arriba_abajo(R,C,N):-
	cursor(R,C),
	write("*********"),
	R1 = R + N,
	cursor(R1,C),
	write("*********").

hacer_izquierdalado(R,C,N):-
	N<>0,
	cursor(R,C),
	write("*"),
	N1 = N - 1,
	R1 = R + 1,
	hacer_izquierdalado(R1,C,N1).
hacer_izquierdalado(_,_,_).

hacer_derechalado(R,C,N):-
	N<>0,
	C1 = C + 9,
	cursor(R,C1),
	write("*"),
	N1 = N - 1,
	R1 = R + 1,
	hacer_derechalado(R1,C,N1).
hacer_derechalado(_,_,_).

borrar:-
	makewindow(1,6,0,"",0,0,25,80).





