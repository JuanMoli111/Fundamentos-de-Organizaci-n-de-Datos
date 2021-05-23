program EJ8IMP;
type
	arbol = ^nodo;
	
	nodo = record
		dato: integer;
		HI : arbol;
		HD : arbol;
	end;
	
procedure leerNum(var n: integer);
begin
	writeln('Ingrese un numero');
	readln(n);
end;
procedure crearHoja(var a: arbol; num: integer);													{<>}
begin
	if(a = nil)then begin
		new(a);
		a^.dato := num;
		a^.HI := nil;
		a^.HD := nil;
	end
	else
		if(num < a^.dato) then
			crearHoja(a^.HI,num)
		else
			crearHoja(a^.HD,num);
end;
procedure cargarArbol(var a: arbol);
var
	num: integer;
begin

	leerNum(num);
	while(num <> 0) do begin
		crearHoja(a,num);
		leerNum(num);
	end;

end;
function minimo(a: arbol): integer;
begin
	if(a = nil) then
		minimo := 32767
	else
		if(a^.HI = nil) then
			minimo := a^.dato
		else
			minimo := minimo(a^.HI);
end;
function maximo(a: arbol): integer;
begin
	if(a = nil) then
		maximo := -32767
	else
		if(a^.HD = nil) then
			maximo := a^.dato
		else
			maximo := maximo(a^.HD);
end;
procedure imprimirOrdenado(a: arbol);
begin

	if(a <> nil) then begin
		imprimirOrdenado(a^.HI);
		writeln(a^.dato);
		imprimirOrdenado(a^.HD);
	end;

end;

procedure imprimirParesDecreciendo(a: arbol);
begin

	if(a <> nil) then begin
	
		imprimirParesDecreciendo(a^.HD);
		
		if(a^.dato mod 2 = 0) then
			writeln(a^.dato);
			
		imprimirParesDecreciendo(a^.HI);
		
	end;

end;

procedure cantElementos(a: arbol;var cant : integer);
begin
	if(a <> nil) then begin
		cant := cant + 1;
		cantElementos(a^.HI,cant);
		cantElementos(a^.HD,cant);
	end;
end;
var
	a: arbol;
	cant: integer;
begin
	cargarArbol(a);
	cant := 0;
	
	cantElementos(a,cant);
	
	writeln('El minimo valor fue ',minimo(a));
	writeln('El maximo valor fue ',maximo(a));
	writeln('la cant de elementos es ',cant);
	
	writeln('*****************************************************************');
	imprimirOrdenado(a);
		
	writeln('*****************************************************************');
	imprimirParesDecreciendo(a);
	
	readln;
end.
