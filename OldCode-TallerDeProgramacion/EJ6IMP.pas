program untitled;
const
	dimf = 100;
type
	indice = 1..dimf;
	
	vector = array[indice] of integer;

procedure busquedaDicotomica(v: vector; ini,fin: indice; dato: integer; var pos: indice);
var
	med: integer;
begin
	med := (ini + fin) DIV 2;																				{<>}

	if(ini <= fin) and (dato <> v[med]) then
	
		if(dato < v[med])then
			fin := med+1;
		else
			ini := med-1;
		
		med := (ini + finf) div 2;

end;
	v: vector
	ini, fin, pos: indice;
	num: integer;
BEGIN
	pos := -1;
	ini := 1;
	fin := dimf
	
	busquedaDicotomica(v,ini,fin,num,pos)
	
END.

