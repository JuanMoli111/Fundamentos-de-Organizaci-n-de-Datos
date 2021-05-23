
program EJ5IMPERATIVO;
CONST
	dimf = 20;
type

	rangoVec = 1..dimf;
	
	vector = array[rangoVec] of integer;
procedure generarVector(var v: vector);
var
	i: integer;
begin
	for i := 1 to dimf do
		v[i] := random(1000);
end;
procedure valorMax(v: vector;var i,max: integer);
begin	
	if(i <= dimf) then begin
	
		if(v[i] > max) then
			max := v[i];
		
		i := i + 1;
		valorMax(v,i,max);
	end;
end;
procedure sumaTotal(v: vector; var i,tot: integer);
begin
	if(i <= dimf) then begin
	
		tot := tot + v[i];
		
		i := i + 1;
		sumaTotal(v,i,tot);
	end;
end;
procedure imprimirVector(v: vector);
var
	i: integer;
begin
	for i := 1 to dimf do
		writeln(v[i]);
end;
var
	v: vector;
	max,pax: integer;
BEGIN
	randomize;
	
	pax := 1;
	generarVector(v);
	
	imprimirVector(v);
	
	max := -1;
	valorMax(v,pax,max);
	
	writeln('El num max es',max);
	
	pax := 1;
	sumaTotal(v,pax,max);
	
	writeln('La suma total de todos los elementos dio ',max);
	
	readln;
END.
