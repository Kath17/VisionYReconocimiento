/* reconocimiento basado en contar vertices
   El reconocedor delta-D */

database
	punto(integer,integer)
	incrementos(integer,integer)
	cambios(symbol)

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
	purgar(integer,integer)
	purgar_puntos
	posicion
	reconocer
	encontrar_triangulo(integer,integer)
	encontrar_cuadrado(integer,integer)
	encontrar_punto(integer,integer,integer,integer)
	es_cuadrado(integer,integer)
	es_triangulo(integer,integer)
	seguir_forma(integer,integer)
	seguir(integer,integer,integer,integer)
goal
	assert(incrementos(1,1)),
	assert(incrementos(-1,1)),
	assert(incrementos(1,-1)),
	assert(incrementos(1,0)),
	assert(incrementos(0,1)),
	assert(incrementos(-1,-1)),
	assert(incrementos(-1,0)),
	assert(incrementos(0,-1)),
	start.

clauses
	start:-
		borrar,
		posicion,
		reconocer.

	/* intentar encontrar objetos*/
	reconocer:-
		cursor(0,0),
		encontrar_triangulo(0,0),
		cursor(1,0),
		purgar_puntos, /*borrar BD puntos*/
		encontrar_cuadrado(0,0),
		purgar_puntos.

	encontrar_triangulo(R,C):-
		encontrar_punto(R,C,A,B),
		es_triangulo(A,B),
		write("triangulo en ",A," ",B," "),
		C1= C+1,
		encontrar_triangulo(A,C1).
	encontrar_triangulo(_,_).

	es_triangulo(R,C):-
		seguir_forma(R,C),
		purgar(0,N),!,
		N=2.
	es_triangulo(_,_):-
		purgar(0,_), fail.

	encontrar_cuadrado(R,C):-
		encontrar_punto(R,C,A,B),
		es_cuadrado(A,B),
		write("cuadrado en ",A," ",B," "),
		C1 = C+1,
		encontrar_cuadrado(A,C1).
	encontrar_cuadrado(_,_).

	es_cuadrado(R,C):-
		seguir_forma(R,C),
		purgar(0,N),!,
		N=3.
	es_cuadrado(_,_):-
		purgar(0,_),fail.

	encontrar_punto(A,B,R,C):-
		scr_char(A,B,Ch),
		Ch='*',
		R= A, C=B.
		encontrar_punto(A,B1,R,C).
	encontrar_punto(A,_,R,C):-
		A1 = A+1,
		A1 < 24,!,
		encontrar_punto(A1,0,R,C).
	encontrar_punto(_,_,_,_):-fail.

/* Seguir un contorno hasta estar de vuelta en
   el punto inicial contando el numero de cambios
   de direccion */

   	seguir_forma(R,C):-
   		assert(punto(R,C)),
   		R1 = R+1,
   		scr_char(R1,C,Ch),
   		Ch='*',
   		seguir(R1,C,1,0),!.
   	seguir_forma(R,C):-
   		R1= R+1, C1=C+1,
   		scr_char(R1,C1,Ch),
   		Ch='*',
   		seguir(R1,C1,1,1),!.

   	/* Seguir cada linea */
   	seguir(R,C,_,_):-
   		punto(Y,X),
   		R= Y,
   		C= X.   /* de vuelta al punto inicial*/
   	seguir(R,C,I,J):-    /* seguir yendo en la misma direccion */
   		R1= R+I,
   		C1= C+J,
   		scr_char(R1,C1,Ch),
   		Ch='*',
   		assert(punto(R,C)),
   		seguir(R1,C1,I,J).
   	seguir(R,C,_,_):-  /*insertar horizontal */
   		assert(cambios(once)),   /* cambiar direccion */
   		incrementos(I,J),
   		R1 = R+I,   C1= C+J,
   		not(punto(R1,C1)),
   		scr_char(R1,C1,Ch),
   		Ch= '*',
   		seguir(R1,C1,I,J).

   	purgar(O,N):-
   		retract(cambios(_)),
   		N1 = O+1,
		purgar(N1,N).
	purgar(O,O).

	purgar_puntos:-
		retract(punto(_,_)),
		fail.
	purgar_puntos.

	/* poner objetos en la pantalla */

	posicion:-
		write("coordenadas para el triangulo isosceles: "),
		readint(R), write(","), readint(C),
		write("coordenadas para el triangulo rectangulo: "),
		readint(R2), readint(C2),
		write("coordenadas para el cuadrado: "),
		readint(R1), readint(C1),
		borrar,
		hacer_triangulo(R,C,5),
		hacer_cuadrado(R1,C1,5).
		/* hacer_derecha_triangulo(R2,C2,10).*/

	hacer_triangulo(R,C,N):-
		hacer_izquierda(R,C,N),
		hacer_derecha(R,C,N),
		hacer_base(R,C,N).
	hacer_izquierda(R,C,N):-
		N<>0,
		cursor(R,C),
		write("*"),
		R1 = R+1,
		C1 = C-1,
		N1 = N-1,
		hacer_izquierda(R1,C1,N1).
	hacer_izquierda(_,_,_).
	hacer_derecha(R,C,N):-
		N<>0,
		cursor(R,C),
		write("*"),
		R1=R+1,
		C1=C+1,
		N1=N-1,
		hacer_derecha(R1,C1,N1).
	hacer_derecha(_,_,_).
	hacer_base(R,C,N):-
		R1= R+N,   C1=C-N,
		cursor(R1,C1),
		write("***********").

	hacer_triangulo_rectangulo(R,C,N):-
		hacer_rt_izquierda(R,C1,N),
		cursor(R,C),
		write("**********").

	hacer_rt_izquierda(R,C,N):-
		N<>0,
		cursor(R,C),
		write("*"),
		R1= R+1,
		N1= N-1,
		hacer_rt_izquierda(R1,C,N1).
	hacer_rt_izquierda(_,_,_).
	hacer_rt_derecha(R,C,N):-
		N<>0,
		cursor(R,C),
		write("*"),
		R1 = R+1,
		C1 = C-1,
		N1 = N-1,
		hacer_rt_derecha(R1,C1,N1).
	hacer_rt_derecha(_,_,_).

	hacer_cuadrado(R,C,N):-
		hacer_arriba_abajo(R,C,N),
		hacer_izquierdalado(R,C,N),
		hacer_derechalado(R,C,N).

	hacer_arriba_abajo(R,C,N):-
		cursor(R,C),
		write("**********"),
		R1 = R+N,
		cursor(R1,C),
		write("**********").

	hacer_izquierdalado(R,C,N):-
		N<>0,
		cursor(R,C),
		write("*"),
		N1= N-1,
		R1= R+1,
		hacer_izquierdalado(R1,C,N1).
	hacer_izquierdalado(_,_,_).

	hacer_derechalado(R,C,N):-
		N<>0,
		C1 =C+9,
		cursor(R,C1),
		write("*"),
		N1=N-1,
		R1=R+1,
		hacer_derechalado(R1,C,N1).
	hacer_derechalado(_,_,_).

	borrar:-
		makewindow(1,6,0,"",0,0,25,80).
