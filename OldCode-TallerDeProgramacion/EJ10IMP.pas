program EJ10IMP;
type
	str25 = string[25];
	
	alumno = record
		legajo: integer;
		lastName: str25;
		name: str25;
		dni: longint;
		incomeYear: integer;
	end;
	
	arbol = ^nodo;																						{<>}
	
	nodo = record
		dato: alumno;
		HI:	arbol;
		HD: arbol;
	end;
procedure leerAlumno(var a: alumno);
begin
	writeln('Ingrese legajo del alumno');	readln(a.legajo);
	if(a.legajo <> 0) then begin
		writeln('Ingrese apellido');	readln(a.lastName);
		writeln('Ingrese nombre');	readln(a.name);
		writeln('Ingrese dni');	readln(a.dni);
		writeln('año de ingreso del alumno');	readln(a.incomeYear);
	end;
end;
procedure crearHoja(var a: arbol; alumno: alumno);													{<>}
begin
	if(a = nil)then begin
		new(a);
		a^.dato := alumno;
		a^.HI := nil;
		a^.HD := nil;
	end
	else
		if(alumno.legajo < a^.dato.legajo) then
			crearHoja(a^.HI,alumno)
		else
			crearHoja(a^.HD,alumno);
end;
procedure cargarArbol(var a: arbol);			{CARGA UN ARBOL DE BUSQUEDA BINEARIO CON REGISTROS TIPO ALUMNO, ORDENADO POR ALUMNO.LEGAJO}
var
	al: alumno;
begin

	leerAlumno(al);
	while(al.legajo <> 0) do begin
	
		if(al.incomeYear > 2000) then			{SOLO ALMACENA LOS ALUMNOS CON AÑO DE INGRESO MAYOR A 2000}
			crearHoja(a,al);
			
		leerAlumno(al);
	end;

end;

procedure informarAlumnosB(a: arbol);
begin

	if(a <> nil) then begin
	
		if(a^.dato.legajo > 12803) then begin
			writeln('Nombre: ', a^.dato.name);
			writeln('Apellido: ', a^.dato.lastName);
			informarAlumnosB(a^.HI);
			informarAlumnosB(a^.HD);
		end
		else
			informarAlumnosB(a^.HD)

	end;
end;

procedure informarAlumnosC(a: arbol);
begin

	if(a <> nil) then begin
	
	
		if(a^.dato.legajo > 2803) and (a^.dato.legajo < 6982) then begin
			writeln('Nombre: ', a^.dato.name);
			writeln('Apellido: ', a^.dato.lastName);
			informarAlumnosC(a^.HI);
			informarAlumnosC(a^.HD);
		end
		else 
			if(a^.dato.legajo < 2803) then
				informarAlumnosC(a^.HD);
				
			if(a^.dato.legajo > 6982) then
				informarAlumnosC(a^.HI);
		
	end;



end;

var
	a: arbol;
begin

	cargarArbol(a);
	informarAlumnosB(a);
	writeln('************************************************');
	informarAlumnosC(a);
	
	readln;
	
end.
