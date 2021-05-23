program ejercicio11;

const 
	dimF = 8;
	
Type
	generos = 1..dimF;
	pelicula = record
		cod: integer;
		codG: generos;
		prom: real;
	end;
	
	lista = ^nodo;
	nodo = record
		dato: pelicula;
		sig: lista;
	end;
	
	vectorPelis = array [generos] of lista;

{--------------------------------- Vector de Listas ---------------------------------} 

Procedure leer (var p: pelicula); 
begin
	writeln('Ingrese codigo de pelicula');
	readln(p.cod);
	if (p.cod <> -1) then
	begin
		writeln('Ingrese codigo de genero');
		readln(p.cod);
		writeln('Ingrese puntaje promedio');
		readln(p.prom);
	end;
end;

Procedure agregarOrdenado (var pri: lista; p: pelicula);
var
	act, ant, nue: lista;
begin
	new(nue);
	nue^.dato:= p;
	act:= pri;
	ant:= pri;
	
	while (act <> nil) and (act^.dato.cod < p.cod) do
	begin
		ant:= act;
		act:= act^.sig;
	end;
	
	if (act = ant) then
		pri:= nue
	else 
		ant^.sig:= nue;
	
	nue^.sig:= act;
end;

procedure inicializarVector (var vP: vectorPelis);
var
	i: integer;
begin
	for i:= 1 to dimF do
		vP[i]:= nil;
end;

procedure cargarVectorPeliculas (var vP: vectorPelis);
var
	p: pelicula;
begin
	inicializarVector(vP);
	
	leer(p);
	while (p.cod <> -1) do
	begin
		agregarOrdenado(vP[p.codG],p);
		leer(p);
	end;
end;

{-------------------------------------- Merge ---------------------------------------} 	

Procedure minimoMerge (var vP: vectorPelis; var min: pelicula);
var
	pos: integer;
	i: generos;
	aux: lista;
begin
	pos:= -1;
	min.cod:= 9999;
	
	for i:=1 to dimF do
		if (vP[i] <> nil) and (min.cod >= vP[i]^.dato.cod) then
		begin
			min:= vP[i]^.dato;
			pos:= i;
		end;
		
	if (pos <> -1) then
	begin
		aux:= vP[pos];
		vP[pos]:= vP[pos]^.sig;
		dispose(aux);
	end;
end;
		

Procedure agregarFinal (var pri: lista; var ult: lista; p: pelicula);
var
	nue: lista;
begin
	new(nue);
	nue^.dato:= p;
	nue^.sig:= nil;
	
	if (pri = nil) then
		pri:= nue
	else
		ult^.sig:= nue;
	
	ult:= nue;
end;	
	
Procedure merge (vP: vectorPelis; var LNue: lista);
var
	min: pelicula;
	ult: lista;
begin
	LNue:= nil;
	
	minimoMerge(vP,min);
	while (min.cod <> 9999) do
	begin
		agregarFinal(LNue,ult,min);
		minimoMerge(vP,min);
	end;
end;
	
{------------------------------------- Informar -------------------------------------}

procedure imprimirLista (l: lista); 
begin
	while (l <> nil) do
	begin
		writeln('Codigo de la pelicula: ',l^.dato.cod);
		writeln('Codigo de genero: ',l^.dato.codG);
		writeln('Promedio de puntacion: ',l^.dato.prom);
	end;
	writeln();
end;

procedure imprimirVectorLista (vP: vectorPelis);
var
	i: integer;
begin
	for i:=1 to dimF do
	begin
		writeln('listado de peliculas del genero: ',i);
		writeln();
		imprimirLista(vP[i]);
	end;
end;


{-------------------------------- PROGRAMA PRINCIPAL --------------------------------} 


VAR 
	vP: vectorPelis;
	l: lista;
BEGIN

	cargarVectorPeliculas(vP);
	writeln();
	imprimirVectorLista(vP);
	writeln();
	merge(vP,l);
	writeln('Lista completa ordenada');
	imprimirLista(l);
	
END.

