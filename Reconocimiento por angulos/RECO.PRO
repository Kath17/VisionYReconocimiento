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
	posicion
	reconocer
	encontrar_triangulo(integer,integer)
	encontrar_cuadrado(integer,integer)
	encontrar_punto(integer,integer,integer,integer)

goal
	start.

clauses
	start:-
		borrar,
		posicion,
		reconocer.

	reconocer:-
		encontrar_triangulo(R, C),
		cursor(0,0),
		write("triangulo en ",R," ",C),nl,
		encontrar_cuadrado(R1, C1),
		write("cuadrado en ",R1," ",C1),nl.


	encontrar_triangulo(R,C):-
		write("h"),
		encontrar_punto(0,0,A,B),
		write("h"),
		A1=A+1,
		B1=B-1,
		scr_char(A1,B1,Ch),
		Ch='*',
		B2=B+1,
		scr_char(A1,B2,Ch2),
		Ch2='*',
		R=A, C=B.

	encontrar_cuadrado(R,C):-
		encontrar_punto(0,0,A,B),
		A1=A+1,
		scr_char(A1,B,Ch),
		Ch='*',
		R=A, C=B.

	encontrar_punto(A,B,R,C):-
		scr_char(A,B,Ch),
		Ch='*',
		R=A, C=B.
	encontrar_punto(A,B,R,C):-
		B1=B+1,
		B1<80,
		encontrar_punto(A,B1,R,C).
	encontrar_punto(A,_,R,C):-
		A1=A+1,
		A1<20,
		encontrar_punto(A1,0,R,C).
	encontrar_punto(_,_,_,_):-fail.

	posicion:-
		write("coordenadas iniciales para el triangulo: "),
		readint(R),write(","),readint(C),
		write("coordenadas iniciales para	el cuadrado: "),
		readint(R1),write(","),readint(C1),
		borrar,
		hacer_triangulo(R,C,5),
		hacer_cuadrado(R1,C1,5).

	hacer_triangulo(R,C,N):-
		hacer_izquierda(R,C,N),
		hacer_derecha(R,C,N),
		hacer_base(R,C,N).

	hacer_izquierda(R,C,N):-
		N<>0,
		cursor(R,C),
		write("*"),
		R1=R+1,
		C1=C-1,
		N1=N-1,
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
		R1=R+N,
		C1=C-N,
		cursor(R1,C1),
		write("***********").
	hacer_cuadrado(R,C,N):-
		hacer_arriba_abajo(R,C,N),
		hacer_izquierdalado(R,C,N),
		hacer_derechalado(R,C,N).

	hacer_arriba_abajo(R,C,N):-
		cursor(R,C),
		write("**********"),
		R1=R+N,
		cursor(R1,C),
		write("**********").
	hacer_izquierdalado(R,C,N):-
		N<>0,
		cursor(R,C),
		write("*"),
		N1=N-1,
		R1=R+1,
		hacer_izquierdalado(R1,C,N1).
	hacer_izquierdalado(_,_,_).

	hacer_derechalado(R,C,N):-
		N<>0,
		C1=C+9,
		cursor(R,C1),
		write("*"),
		N1=N-1,
		R1=R+1,
		hacer_derechalado(R1,C,N1).
	hacer_derechalado(_,_,_).

	borrar:-
		makewindow(1,6,0,"",0,0,25,80).
