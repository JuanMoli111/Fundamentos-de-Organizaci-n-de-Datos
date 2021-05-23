Program Merge_Ejercicio12;

Const DIMF=4; Corte=0;

Type

    sub=1..DIMF;
    
    Venta=Record
          CodProd:integer;
          CodS:Integer;
          CantVentas:integer;
          end;
    
    EstructuraNueva=Record
                    CodProduct:integer;
                    CantTotal:integer
                    end;
                    
    Enueva=^Enodo;
    Enodo=record
          dato:EstructuraNueva;
          sig:Enueva;
          end;                 
    
    Lista=^nodo;
    nodo=record
         dato:Venta;
         sig:Lista;
         end;        
         
    Sucursales= array [sub] of Lista;

// Leo las ventas hasta que el codigo de sucursal sea 0

Procedure LeerVentas(Var V:Venta);
Begin
 Writeln('Ingrese el codigo de sucursal (1 al 4)');
 Read(V.CodS);
 If (V.CodS<>Corte) then begin
  Writeln('Ingrese codigo de producto');
  Readln(V.CodProd);
  Writeln('Ingrese cantidad vendida');
  Readln(V.CantVentas);
 end;
end;

//Las ventas van a estar ordenadas por Codigo de producto

Procedure InsertarOrdenado(Var L:Lista;V:Venta);
var aux,act,ant:Lista;
Begin
 new(aux);
 act:=nil;
 ant:=nil;
 While(act<>nil) and (act^.dato.CodProd<V.CodProd) do begin
   ant:=act;
   act:=act^.sig;
 end;
 If (act=nil) then L:=aux
 else ant^.sig:=aux;
 aux^.sig:=act;
end;

Procedure InicializarVector(Var S:Sucursales);
Var i:integer;
Begin
 For i:=1 to DIMF do S[i]:=NIL;
end;

//Las ventas van a estar agrupadas por sucursal

Procedure CargarVector(Var S:Sucursales);
Var V:Venta;
Begin
  Writeln('Informacion sobre la ventas');
  LeerVentas(V);
  While (V.CodS<>Corte) do begin
   InsertarOrdenado(S[V.CodS],V);
   Writeln();
   LeerVentas(V);
   end;
end;

Procedure AgregarAtras(var nue,ult:ENueva; E:EstructuraNueva);
var aux:ENueva;
begin
	New(aux);
	nue^.dato:=E;
	nue^.sig:=nil;
	if (nue=nil) then nue:=aux
	else ult^.sig:=nue;
	ult:=nue;
end;

Procedure PorCodigoProd(Var S:Sucursales;Var Min:Venta);
Var i,IndiceMin:integer;
Begin
 Min.CodProd:=999;
 For i:=1 to DIMF do begin
  If(S[i]<>nil) AND (S[i]^.dato.CodProd<Min.CodProd) then begin
     Min:=S[i]^.dato;
     IndiceMin:=i;
     end;
 end;
 //Si encontró un mínimo entonces al siguiente nodo de esa lista
 //Si no hay mas minimo que buscar, no hace nada
 If (Min.CodProd<>999) then S[IndiceMin]:=S[IndiceMin]^.sig;
end;

Procedure Merge(S:Sucursales; Var Nue:ENueva);
Var Min:Venta;TotalVentas:Integer;Actual:integer; E:EstructuraNueva;ult:ENueva;
Begin
 Nue:=NIL;ult:=NIL;
 PorCodigoProd(S,Min);
 While(Min.CodProd<>999) do begin
    Actual:=Min.CodProd; TotalVentas:=0;
   While ((Min.CodProd<>999) AND (Min.CodProd=Actual)) do begin
      TotalVentas:=TotalVentas+Min.CantVentas;
      PorCodigoProd(S,Min);
   end;
    E.CodProduct:=Actual;
    E.CantTotal:=TotalVentas;
    AgregarAtras(Nue,ult,E);
 end;
end;

Procedure ImprimirLista(nue:ENueva);
Begin 
  Writeln();
  Writeln('La nueva estructura quedo asi: ');
  Writeln();
  While(nue<>nil) do begin
  writeln('Codigo de producto: ', nue^.dato.CodProduct);
  writeln('Total total vendida por este producto ', nue^.dato.CantTotal);
  Writeln();
  nue:=nue^.sig;
  end;
end;

//Programa principal

Var S:Sucursales;Nue:ENueva;

Begin

InicializarVector(S);

CargarVector(S);

Merge(S,Nue);

ImprimirLista(Nue);

end.
