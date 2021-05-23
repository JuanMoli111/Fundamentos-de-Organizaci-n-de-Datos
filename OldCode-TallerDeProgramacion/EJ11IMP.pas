program EJ11IMP;
const
	dimf = 8;
type

	subrDimf = 1..dimf;
	
	pelicula = record
		cod: integer;
		codGen: subrDimf;
		puntProm: real;
	end; 

	lista = ^nodo;
	
	nodo = record
		dato : pelicula;
		sig: lista;
	end;
	
	vectorLis = array[subrDimf] of lista;
	
procedure leerPelicula(var p: pelicula);
begin
	writeln('Ingrese el codigo de pelicula');	readln(p.cod);
	if(p.cod <> -1) then begin
		writeln('Ingrese el codigo de genero (1..8)');	readln(p.codGen);	
		writeln('Ingrese puntaje promedio otorgado por las criticas');	readln(p.puntProm);																{<>}
	end;

end;	
procedure inicializarVecL(var vecL: vectorLis);
var
	i: integer;
begin
	for i := 1 to dimf do
		vecL[i] := nil;
end;
procedure insertarNodo(var l: lista; p: pelicula);
var
	aux, act, ant: lista;
begin
	new(aux);
	aux^.dato := p;
	act := l;
	ant := l;
	
	while(act <> nil) and (act^.dato.cod < aux^.dato.cod) do begin
		ant := act;
		act := act^.sig;	
	end; 
	
	if(act = ant) then
		l := aux
	else
		ant^.sig := aux;
	
	aux^.sig := act;
end;

procedure agregarNodo(var l: lista; p: pelicula);
var
	aux: lista;
begin
	new(aux);
	aux^.dato := p;
	aux^.sig := l;
	l := aux;
end;

procedure cargarVecListas(var vecL: vectorLis);
var
	p: pelicula;
begin
	leerPelicula(p);
	
	while(p.cod <> -1) do begin
		insertarNodo(vecL[p.codGen],p);
		leerPelicula(p);
	end;
end;

procedure minimo(var vecL: vectorLis; var p: pelicula);
var
	pos, i: integer;
begin
	p.cod := 32767;
	pos := -1;
	
	for i:= 1 to dimf do begin
		if(vecL[i] <> nil) and (vecL[i]^.dato.cod >= p.cod) then begin
			p := vecL[i]^.dato;
			
			pos := i;
		end;
		
	end;
		
	if(pos <> -1) then
		vecL[pos] := vecL[pos]^.sig;
	
end;

procedure merge(vecL: vectorLis; var newL: lista);
var
	p: pelicula;
begin
	newL := nil;
	minimo(vecL,p);
	while(p.cod <> 32767) do begin
		agregarNodo(newL,p);
		minimo(vecL,p);
	end;

end;

procedure imprimirLista(l: lista);
begin
	while(l <> nil) do begin
		writeln('Cod: ',l^.dato.cod);
		l := l^.sig;
	end;
end;

procedure imprimirVecL(vecL: vectorLis);
var
	i: integer;
begin
	for i := 1 to dimf do begin
		imprimirLista(vecL[i]);
		writeln('****************************************');
	end;
end;
var
	vecL: vectorLis;
	newL: lista;
begin

	inicializarVecL(vecL);
	cargarVecListas(vecL);
	imprimirVecL(vecL);


	writeln('++++++++++++++++++++++++++++++++++++++++++++++');

	merge(vecL,newL);
	
	imprimirLista(newL);

	readln;
end.
