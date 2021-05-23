program EJ3IMPERATIVO;
const
	dimf6 = 6;
	dimf30 = 30;
type
	subr6 = 1..dimf6;
	
	producto = record
		cod: integer;
		rubro: subr6;
		precio: real;
	end;
	
	prodRubro3 = record
		cod: integer;
		precio: real;
	end;
	
	lista = ^nodo;
	
	nodo = record
		dato: producto;
		sig: lista;
	end;
	
	vec6lis = array[1..dimf6] of lista;								{ <>}
	vec30prod3 = array[1..dimf30] of prodRubro3;
	
procedure inicializarVecListas(var v: vec6lis);		{INICIALIZA EN NIL CADA CELDA DE UN VECTOR DE LISTAS DE DIMENSION FISICA 'DIMF'}
var
	i: integer;
begin
	for i := 1 to dimf6 do 
		v[i] := nil;
end;
procedure agregarElemento(var v: vec30prod3; var diml: integer; p: prodRubro3);
begin
	if((diml + 1) <= dimf30) then begin
		diml := diml + 1;
		v[diml] := p;
	end;
end;
procedure leerProducto(var p: producto);
begin
	writeln('Ingrese el precio del producto');		readln(p.precio);
	if(p.precio  <> -1) then begin
		writeln('Ingrese el codigo del producto');		readln(p.cod);	
		writeln('Ingrese el cod del rubro (1..6)');		readln(p.rubro);
	end;
end;

procedure insertarNodo(var l: lista;p: producto);
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

procedure cargarVecListas(var vLis: vec6lis);
var
	p: producto;
begin
	leerProducto(p);
	while(p.precio <> -1) do begin
		insertarNodo(vLis[p.rubro],p);
		leerProducto(p);
	end;
end;

procedure informarProdGenerarVec(vLis: vec6lis;var vProd: vec30prod3; var diml: integer);		{RECIBE UN VECTOR DE LISTAS E INFORMA LOS CODIGOS DE LOS PRODUCTOS}
var																									{RECIBE UN VECTOR DE REGS. PRODUCTO Y AGREGA LOS 30 PRIMEROS CUYO RUBRO SEA COD. 3}
	i: integer;
	p: prodRubro3;
begin
	
	for i := 1 to dimf6 do begin
		writeln('Productos del rubro ',i);
		
		while(vLis[i] <> nil) do begin
			writeln('Cod: ',vLis[i]^.dato.cod);
			
			if(i = 3) then begin
				p.cod := vLis[i]^.dato.cod;
				p.precio := vLis[i]^.dato.precio;
				
				agregarElemento(vProd,diml,p);
			end;
			
			vLis[i] := vLis[i]^.sig;
		end;
	end;
end;
procedure ordenarInformarVector(var vProd: vec30prod3; diml: integer);		{RECIBE UN VECTOR DE REGS. Y LO ORDENA X PRECIO, USANDO EL METODO DE INSERCION (INCISO C)}
var																			
	actual: prodRubro3;
	j, i : integer;
begin
	for i := 2 to diml do begin
		actual := vProd[i];
		j := i-1;
		while(j > 0) and (vProd[j].precio > actual.precio) do begin
			vProd[j+1] := vProd[j];
			j := j - 1;
		end;
		vProd[j+1] := actual;
	end;

	for i := 1 to diml do 													{INFORMA LOS PRECIOS DEL VECTOR (INCISO D)}
		writeln('Precio: ',vProd[i].precio);

end;
var
	vLis : vec6lis;
	vProd: vec30prod3;
	diml:	integer;
begin
	diml := 0;
	inicializarVecListas(vLis);
	cargarVecListas(vLis);
	informarProdGenerarVec(vLis,vProd,diml);
	ordenarInformarVector(vProd,diml);

	readln;
end.

