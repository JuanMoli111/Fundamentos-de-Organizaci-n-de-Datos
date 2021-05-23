program TeoriaEj1;
const
	dimf = 20;
type
	rangovec = 1..dimf;
	
	lista = ^nodo;
	
	nodo = record
		dato: integer;
		sig: lista;
	end;

	vec20int = array[rangovec] of integer;
procedure leerNum(var num: integer);
begin
	writeln('Ingrese un numero');
	readln(num);
end;
procedure generarVecInt(var v: vec20int; var i: integer);
var
	num: integer;										{<>}
begin
	 leerNum(num);
	
	while(i < dimf) and (num <> 0) do begin
		i := i + 1;
		v[i] := num;
		leerNum(num);
	end;


end;
procedure imprimirVec(v: vec20int;diml: integer);
var
	i: integer;
begin
	for i  := 1 to diml do
		writeln(v[i]);
end;
procedure eliminarElemento(var v: vec20int; num: integer);
var
	i, j: integer;
	ok: boolean;
begin
	i := 1;
	ok:= false;

	while(i <= dimf) and (ok = false) do begin
	
		if(v[i] = num) then begin
			ok := true;
			for j := i to (dimf-1) do
				v[j] := v[j+1];
		end;	
		i := i + 1;
	end;

end;

procedure agregarNodo(var l: lista; num: integer);
var
	aux, act: lista;
begin
	new(aux);
	aux^.dato := num;
	aux^.sig := nil;
	if(l = nil) then
		l := aux
	else begin
		act := l;
		while(act^.sig <> nil) do
			act := act^.sig;
		act^.sig := aux;
	end;
end;
procedure generarLista(var l: lista);
var
	num: integer;
begin
	randomize;
	num := random(21);

	while(num <> 20) do begin
		agregarNodo(l,num);
		num := random(21);
	end;
end;
procedure imprimirLista(l: lista);
begin
	while(l <> nil) do begin
		writeln(l^.dato);
		l := l^.sig;
	end;

end;

procedure probarModules;
var
	l : lista;
	v : vec20int;
	num,diml: integer;
BEGIN
	l := nil;
	diml := 0;
	generarVecInt(v,diml);
	imprimirVec(v,diml);
	writeln('Ingrese un numero a eliminar del vector');
	readln(num);
	eliminarElemento(v,num);
	imprimirVec(v,diml);
	
	writeln('Hora de hacer la pinche lista')
	
	generarLista(l);
	imprimirLista(l);
end;
begin
	probarModules;
	readln;
END.

