program ejTeoria2;
const
	dimf = 20;
type
	rangovec = 1..dimf;

	participante = record
		cod:	integer;
		edad:	integer;
	end;
	
	vector = array[rangovec] of participante;
	
procedure leerParticipante(var p: participante);
begin
	writeln('Ingrese cod de participante');		readln(p.cod);
	if(p.cod <> -1) then begin
		writeln('Ingrese edad del participante');	readln(p.edad);
	end;
end;

procedure cargarVector(var v: vector; var i: integer);
begin
	leerParticipante(p);
	while(i < dimf) and (p.cod <> -1) do begin
		i := i +1;
		v[i] := p;
	
		leerParticipante(p);
	end;
end;

procedure imprimirVector(v: vector; diml: integer);
var
	i: integer;
begin
	for i := 1 to diml do begin
		writeln('Cod: ',v[i].cod);
		writeln('Edad: ',v[i].edad);
	end;
end;

procedure ordenarVector(var v: vector; diml: integer);
var
	i,j: integer;
	actual : participante;
begin
	for i := 2 to diml do begin
		actual := v[i];
		j := i - 1;
		while(j > 0) and (v[j].edad > actual.edad) do begin
			v[j+1] := v[j];
			j := j - 1;
		end;
		v[j+1] := actual;
	end;
end;

procedure eliminarEdad(var v: vector; diml: integer);
var
	pos, i, cant: integer;
begin
	cant := 0;
	i	:= 1;
	
	while(i <= diml) and (v[i].edad < 20) do
		i := i + 1;
		
	pos := i;
	
	while(i <= diml) and (v[i].edad <= 22) do
		i := i + 1;
		
	cant := i - pos;
	
	for i := (pos + cant) to diml do
		v[i-cant] := v[i];
		
	diml := diml - cant;

end;
