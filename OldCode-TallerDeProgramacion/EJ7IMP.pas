program ConvertDecimalToBinary;
procedure leerNum(var n: integer);
begin
	writeln('Ingrese un numero');
	readln(n);
end;

procedure ConvertDecimalToBinary(num: integer);
begin

	if(num <> 0) then begin
		if((num mod 2) = 1) then begin
			ConvertDecimalToBinary((num div 2));
			write('1');
		end
		else begin
			ConvertDecimalToBinary((num div 2));														{<>}
			write('0');
		end;
	end;
		
end;
procedure leerProcesarNumeros;
var
	num: integer;
begin
	
	leerNum(num);
	while(num <> 0) do begin
	
		ConvertDecimalToBinary(num);
		writeln;
		leerNum(num);
	end;

end;
begin
	leerProcesarNumeros;
end.
