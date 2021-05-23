{11. Un cine posee la lista de películas que proyectará durante el mes de octubre. De cada película se conoce: código de película, código de género (1: acción, 2: aventura, 3: drama, 4: suspenso, 5: comedia, 6: bélica, 7: documental y 8: terror) y puntaje promedio otorgado por las críticas.
Implementar un programa que contenga:
a. Un módulo que lea los datos de películas y los almacene ordenados por código de película y agrupados por código de género, en una estructura de datos adecuada. La lectura finaliza cuando se lee el código de película -1.
b. Un módulo que reciba la estructura generada en el punto a y retorne una estructura de datos donde estén todas las películas almacenadas ordenadas por código de película.}


program ejercicio2;
const
	dimF=8;
type
	
	pelicula=record
		cod:integer;
		codGen:integer;
		puntajeprom:real;
	end;
	
	lista=^nodo;
	nodo=record
		datos:pelicula;
		sig:lista;
	end;
		
	vectorListas=array [1..dimF] of lista;


procedure InicializarVL(var V:vectorListas);
var
	i:integer;
begin
	for i:=1 to DimF do
		V[i]:=nil;
end;

Procedure InsertarEnLista ( var pri: lista; elem: pelicula);
var
  ant, nue, act: lista;
begin
  new (nue);
  nue^.datos := elem;
  act := pri;
  while (act<>NIL) and (act^.datos.cod < elem.cod) do begin
    ant := act;
    act := act^.sig ;
  end;
  if (act = pri)  then
    pri := nue
  else
    ant^.sig := nue;
  nue^.sig := act ;
end;


procedure LeerPelicula(var P:pelicula);
begin
	write('Ingrese codigo de pelicula: ');
	readln(P.cod);
	if(P.cod<>-1)then begin
		write('Ingrese codigo de genero: ');
		readln(P.codGen);
		write('Ingrese puntaje promedio recibido por la critica: ');
		readln(P.puntajeProm);
	end;
end;

procedure crearVectorListas(var V:vectorListas);

var
	P:pelicula;
begin
	InicializarVL(V);
	LeerPelicula(P);
	while(P.cod <> -1)do begin
		InsertarEnLista(V[P.codGen],P);
		LeerPelicula(P);
	end;
end;





Procedure ImprimirLista(L:Lista);
begin
  While(L<>nil)do Begin
    Writeln('Codigo de Pelicula: ', L^.datos.cod, ' puntaje promedio: ', L^.datos.puntajeProm:1:2, '. ');
    L:=L^.sig;
  end;
end;

procedure ImprimirVL(V:vectorListas);
var
	i:integer;
begin
	for i:=1 to dimF do begin
		writeln('Lista del codigo de genero: ', i,': ');
		imprimirLista(V[i]);
		writeln('-------------------------------------------------------------');
	end;
end;



   Procedure AgregarAtras (var pri:lista; var ult: lista; elem: pelicula);
  var
    nue : lista;
  begin
    new (nue);
    nue^.datos:= elem;
    nue^.sig := NIL;
    if (pri <> nil) then
      ult^.sig := nue
    else
      pri := nue;
    ult := nue;
  end;

Procedure ActualizarLista(var L:lista);
var
	act:lista;
begin
	act:=L;
	L:=L^.sig;
	dispose(act);
end;


 Procedure Minimo(var v:vectorListas; DimL:integer; var min:pelicula; var ok:boolean);
  var
	pos:integer; i:integer; minimo:pelicula;
 begin 
      minimo.cod:=999;
      for i:= 1 to DimL do begin
          if(v[i]<>nil)then
              if(V[i]^.datos.cod<minimo.cod)then begin
                  minimo:=V[i]^.datos;
          	      pos:=i;
              end;
      end;
      min:=minimo;
      if(minimo.cod<>999)then
           ActualizarLista(v[pos])
      else
           ok:=false;
  end;


 Procedure Merge(var v:vectorListas; dimL:integer; var L:lista);
  var
	min:pelicula; ult:lista; ok:boolean;
  Begin
       L:=nil;
       ok:=true;
       Minimo(v, dimL, min,ok);
       while( ok )  do begin
            AgregarAtras(L,ult,min);
            Minimo(v, dimL, min, ok)
       end;
  end;


Procedure ImprimirLista(L:Lista);
Begin
  While(L<>nil)do Begin
    Writeln('Codigo de pelicula: ',L^.datos.cod,' - Puntaje: ', L^.datos.puntajeProm);;
    L:=L^.sig;
  end;
End;


var
	VL:vectorListas; L:lista;
begin
	crearVectorListas(VL);
	ImprimirVL(VL);
	Merge(VL, dimF, L);
	writeln('Lista Final de Peliculas: ');
	ImprimirLista(L);
	readln();
end.
