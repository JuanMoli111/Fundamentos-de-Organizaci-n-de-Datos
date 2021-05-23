program EJ9IMP;
type

	str25 = string[25];

	arbol = ^nodo;
	
	nodo = record
		dato: str25;
		HI: arbol;
		HD: arbol;
	end;
	
procedure leerNombre(var nombre: str25);
begin
	writeln('Ingrese un nombre');
	readln(nombre);
end;
procedure crearHoja(var a: arbol; nombre: str25);													{<>}
begin
	if(a = nil)then begin
		new(a);
		a^.dato := nombre;
		a^.HI := nil;
		a^.HD := nil;
	end
	else
		if(nombre < a^.dato) then
			crearHoja(a^.HI,nombre)
		else
			crearHoja(a^.HD,nombre);
end;
procedure cargarArbol(var a: arbol);
var
	nombre: str25;
begin

	leerNombre(nombre);
	while(nombre <> 'ZZZ') do begin
		crearHoja(a,nombre);
		leerNombre(nombre);
	end;

end;

function buscarNombre(a: arbol; nombre: str25): arbol;
begin
	if(a = nil) then
		buscarNombre := nil
	else 
		if(nombre = a^.dato) then
			buscarNombre :=	a
		else
			if(nombre < a^.dato) then
				buscarNombre := buscarNombre(a^.HI,nombre)
			else
				buscarNombre := buscarNombre(a^.HD,nombre);
end;
var
	a: arbol;
	nombre: str25;
begin

	cargarArbol(a);

	writeln('Ingrese un nombre a buscar en el arbol');
	readln(nombre);
	
	if(buscarNombre(a,nombre) = nil) then
		writeln('El nombre no esta en el arbol')
	else
		writeln('El nombre esta en el arbol');
		
	readln;
end.
