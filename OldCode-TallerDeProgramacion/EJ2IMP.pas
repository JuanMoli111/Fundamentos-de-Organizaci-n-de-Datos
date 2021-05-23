program EJ2IMPERATIVO;
const
	dimf = 8;
type
	subr8 = 1..dimf;
	
	pelicula = record
		cod: integer;
		codgen: subr8;
		puntProm: real;
	end;
	
	peliVecCod = record
		cod: integer;
		puntProm: real;
	end;
	
	lista = ^nodo;	
	nodo = record			
		dato: pelicula;
		sig: lista;
	end;
	
	vec8lis = array[1..dimf] of lista;		{DECLARA UN VECTOR DE LISTAS DIMENSION DIMF, PARA PUNTO A Y B}
	vec8pel = array[1..dimf] of peliVecCod; {DECLARA UN VECTOR DE REGISTROS TIPO PELIVECCOD, PARA PUNTO C Y D}
	
procedure inicializarVecListas(var v: vec8lis);		{INICIALIZA EN NIL CADA CELDA DE UN VECTOR DE LISTAS DE DIMENSION FISICA 'DIMF'}
var
	i: integer;
begin
	for i := 1 to dimf do 
		v[i] := nil;
end;

procedure leerPelicula(var p: pelicula);
begin
	writeln('Ingrese el codigo de pelicula');							readln(p.cod);
	if(p.cod <> -1) then begin
		writeln('Ingrese codigo del genero (1..8)');					readln(p.codgen);
		writeln('Ingrese puntaje promedio otorgado por las criticas');	readln(p.puntProm);
	end;
end;

procedure agregarNodo(var l : lista; p: pelicula);
var
	aux: lista;
begin
	new(aux);
	aux^.dato := p;
	aux^.sig := l;
	l := aux;
end;

procedure cargarVecListas(var v: vec8lis);
var
	p : pelicula;
begin
	leerPelicula(p);

	while(p.cod <> -1) do begin
		agregarNodo(v[p.codgen],p);
		leerPelicula(p);
	end;
end;

procedure generarVectorCod(vLis: vec8lis;var vPel: vec8pel);
var
	maxPuntGen: real;
	i: integer;
begin
	
	for i := 1 to dimf do begin
		maxPuntGen := -1;

		while(vLis[i] <> nil) do begin
		
			{SI EL PUNTAJE PROM ES MAYOR, ACTUALIZA MAXPUNT Y GUARDA EL COD DE ESA PELICULA EN EL VECTOR}
			if(vLis[i]^.dato.puntProm > maxPuntGen) then begin
				maxPuntGen := vLis[i]^.dato.puntProm;
				vPel[i].cod := vLis[i]^.dato.cod;
				vPel[i].puntProm := vLis[i]^.dato.puntProm;
			end;
			
			vLis[i] := vLis[i]^.sig;
		end;
	end;
end;

procedure ordenarVector(var v: vec8pel);
var
	actual: peliVecCod;
	j, i : integer;
begin
	for i := 2 to dimf do begin
		actual := v[i];
		j := i-1;
		while(j > 0) and (v[j].puntProm > actual.puntProm) do begin
			v[j+1] := v[j];
			j := j - 1;
		end;
		v[j+1] := actual;
	end;
end;

procedure recorrerVectorInformar(v: vec8pel);
var
	maxPunt, minPunt: real;
	i, codMaxPunt, codMinPunt: integer;
begin
	maxPunt := -1;	minPunt := 32767;

	for i := 1 to dimf do begin
	
		if(v[i].puntProm > maxPunt) then begin
			maxPunt := v[i].puntProm;
			codMaxPunt := v[i].cod;
		end;
		
		if(v[i].puntProm < minPunt) then begin
			minPunt := v[i].puntProm;
			codMinPunt := v[i].cod;
		end;

	end;
	
	writeln('El cod de la pelicula con mayor puntaje es ',codMaxPunt);
	writeln('El cod de la pelicula con menor puntaje es ',codMinPunt);
	
end;

procedure imprimirLista(l : lista);		{DEBUGGING}
begin

	while(l <> nil) do begin
		writeln(l^.dato.cod);
		writeln((l^.dato.puntProm):1:2);	
		l := l^.sig;
	end;

end;

procedure imprimirVecListas(vLis: vec8lis);			{DEBUGGING}
var
	i: integer;
begin

	for i := 1 to dimf do
		imprimirLista(vLis[i]);

end;

procedure imprimirVector(v: vec8pel);			{DEBUGGING}
var
	i: integer;
begin

	for i := 1 to dimf do begin
		writeln(v[i].cod);
		writeln((v[i].puntProm):1:2);
	end;
end;

var
	vLis: vec8lis;
	vPel: vec8pel;
begin
	inicializarVecListas(vLis);
	cargarVecListas(vLis);
	
	writeln('Imprimir vector de listas: ');
	imprimirVecListas(vLis);	{DEBUGGING}
	
	generarVectorCod(vLis,vPel);
	
	writeln('Imprimir vector de peliculas: ');
	imprimirVector(vPel);	{DEBUGGING}
	
	ordenarVector(vPel);
	
	writeln('Imprimir vector de peliculas: ');	
	imprimirVector(vPel);	{DEBUGGING}
	
	recorrerVectorInformar(vPel);

	readln;
end.
