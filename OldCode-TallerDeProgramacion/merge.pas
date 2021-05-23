program merge;

const
	cantE = 5;
	
type

	lista = ^nodo;
	nodo = record
		dato: string;
		sig: lista;
	end;
	
	estantes = array[1..cantE] of lista;
	
procedure minimo(var todos: estantes; var min: string);
var
	pos, i: integer;
begin
	min := 'zzzzzz';
	pos := -1;
	

	//ANALOGOS: 		^.SIG 	= 	READ(ARC,REG)
	//					TODOS[I].DATO = 
	//


	for i:= 1 to cantE do

		//Si el elemento no es nil Y ES MENOR O IGUAL A VALORALTO
		if(todo[i] <> nil) and (todos[i]^.dato <= min) then begin
			//ACTUALIZA MIN
			min := todos[i]^.dato;
			//POS EN UNO ¿POR?
			pos := 1;
		end;
		

		//SI POS ES DISTINTO DE UNO (OSEA SE ACTUALIZÓ AUNQUE SEA ALGUNA VEZ EL MIN, OSEA HAY DATOS EN LAS ESTRUCTURAS)	SE AVANZA AL SIGUIENTE REG
		if(pos <> -1) then
			todos[pos] := todos[pos]^.sig
		else
			//DE LO CONTRARIO SER RETORNA EL MIN EN VALORALTO
			min := 'zzzzz';
			
	end;
end;
