program ejercicio_11;
const 
  cantsuc = 4;
type
  data = record
    dia: 1..31;
    mes: 1..12;
    anio: integer;
  end;
  
  venta = record
    fecha: data;
    codpro: integer;
    codsuc: 0..cantsuc;
    cantvent: integer;
  end;
    
  ventamerge = record
    codpro: integer;
    ventas: integer;
  end;  
    
  lista = ^nodo;
	
	nodo = record
	datos: venta;
	sig: lista;
  end;
 
  listamerge = ^nodomerge;
	
	nodomerge = record
	datos: ventamerge;
	sig: listamerge;
  end;
 
  sucursal =array [1..cantsuc] of lista;

procedure insertar_ordenado (var L:lista ; v:venta);
var
  ant,act,nue: lista;
begin
  new(nue);
  nue^.datos := v;
  act := L;
  while (act <> nil) and (v.codpro > act^.datos.codpro) do begin
    ant := act;
    act := act^.sig;
  end;
  if (act = L) then begin
    L := nue
  end
  else 
    ant^.sig := nue;
  nue^.sig := act;
end;

procedure agregar_atras (var Lnueva,ult:listamerge; vm:ventamerge);
var
  nue:listamerge;
begin
	new(nue);
	nue^.datos := vm;
	nue^.sig := nil;
	if (Lnueva = nil) then
	  Lnueva := nue
	else
	  ult^.sig := nue;
	ult := nue;
end;


procedure ini_vector (var s:sucursal);
var
  i:integer;
begin
  for i:= 1 to cantsuc do
    s[i]:= nil;
end;    

procedure leer_venta (var v:venta);
begin
  writeln ('Ingrese el codigo de la sucursal, ingrese 0 para terminar de almacenar ventas');
  readln (v.codsuc);
  if (v.codsuc <> 0) then begin
    writeln('Ingrese la fecha de la venta');
	write('dia: ');
	read (v.fecha.dia);
	write ('mes: ');
	read(v.fecha.mes);
	write ('anio: ');
	read (v.fecha.anio);
	writeln ('Ingrese el codigo del producto');
	readln (v.codpro);
	writeln ('Ingrese la cantidad vendida');
	readln (v.cantvent);
  end
end;

procedure cargar_vector (var s:sucursal);
var
  v:venta;
begin
  leer_venta (v);
  while (v.codsuc <> 0) do begin
    insertar_ordenado (s[v.codsuc], v);
    writeln ('Se ha guardado la venta');
    writeln('');
    leer_venta (v);
  end;
end;

Procedure minimo (var s:sucursal; var codproducto:integer; var cantventa:integer);
Var
 indicesuc,i:integer;
Begin
  indicesuc:= -1; 
  codproducto := 9999;
  for i:= 1 to cantsuc do begin
     if (s[i] <> nil) then 
       if (s[i]^.datos.codpro <= codproducto) then begin
         codproducto := s[i]^.datos.codpro;
         indicesuc := i;  
       end;  
  end; 
  if (indicesuc <> -1) then begin
    cantventa := s[indicesuc]^.datos.cantvent;
    s[indicesuc] :=  s[indicesuc]^.sig;
  end;
end;

procedure merge_acomulador (s:sucursal; var Lnueva,ult:listamerge);
var
  cantventa:integer; codproducto:integer; ventastotales:integer; vm:ventamerge; actual:integer;
begin
  Lnueva:= nil; 
  ult := nil;
  minimo (s, codproducto, cantventa);
  while (codproducto <> 9999) do begin
     actual := codproducto;
     ventastotales := 0;
     while ((codproducto <> 9999) and (codproducto = actual) ) do begin
        ventastotales := ventastotales + cantventa;
        minimo (s,codproducto,cantventa);
     end;
     vm.codpro := actual;
     vm.ventas := ventastotales;
     agregar_atras (Lnueva,ult,vm);
    end;
end;  

procedure imprimir_nuevalista (Lnueva:listamerge);
begin
  if (Lnueva <> nil) then begin
    writeln ('el codigo del producto es: ',Lnueva^.datos.codpro); 
    writeln ('la cantidad total de ventas del producot fue: ',Lnueva^.datos.ventas);
    writeln ('');
    Lnueva := Lnueva^.sig;
    imprimir_nuevalista (Lnueva);
  end
end;

var
  s:sucursal; Lnueva,ult:listamerge;
begin
  ini_vector (s);
  cargar_vector (s);
  writeln ('acontinuacion se generara una nueva estructura de datos');
  merge_acomulador(s,Lnueva,ult);
  writeln ('se ha generado con exito');
  writeln ('');
  writeln ('ahora se imprimiran la cantidad de ventas de los productos de la nueva lista');
  writeln ('');
  imprimir_nuevalista(Lnueva);
end.
