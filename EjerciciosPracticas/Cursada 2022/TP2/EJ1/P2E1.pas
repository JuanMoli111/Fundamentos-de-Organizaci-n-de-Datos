program P2E1;
const
    valorAlto = 9999;
type

    str20 = string[20];

    comision = record
        cod: integer;
        nombre: str20;
        monto: real;
    end;


    archivo_comisiones = file of comision;

procedure LeerCom(var c: comision);
begin
    writeln('Ingrese el codigo: ');  readln(c.cod);

    if(c.cod <> 9999) then begin
        with c do begin
            writeln('Ingrese el nombre: ');  readln(nombre);
            writeln('Ingrese el monto: ');  readln(monto);
        end;
    end;    
end;

procedure leer(var arc_com: archivo_comisiones; var c: comision);
begin
    if(not(EOF(arc_com))) then
        read(arc_com,c)
    else
        c.cod := valorAlto;  
end;

procedure CompactarArchivo(var arc_comisiones, arc_compactado: archivo_comisiones);
var
    c, aux: comision;
begin

    //Assign y creacion del archivo compactado
    assign(arc_compactado,'comisiones_compactado');
    rewrite(arc_compactado);

    //Abrir archivo comisiones
    reset(arc_comisiones);


    //Leer primer registro
    leer(arc_comisiones,c);


    while(c.cod <> valorAlto) do begin

        aux.monto := 0;
        aux.nombre := c.nombre;
        aux.cod := c.cod;

        //Leer registros mientras sea el mismo codigo, acumular monto en registro auxiliar
        while(aux.cod = c.cod) do begin
            aux.monto += c.monto;
            leer(arc_comisiones,c);
        end;

        //Cargar registros compactados al nuevo archivo
        write(arc_compactado,aux);

    
    end;

    //Cerrar archivos
    close(arc_compactado);
    close(arc_comisiones);

end;

procedure RecorrerArchivo(var arc_comp: archivo_comisiones);
var
    c: comision;
begin

    reset(arc_comp);

    while(not(EOF(arc_comp))) do begin
        read(arc_comp,c);

        writeln('nombre: ',c.nombre,'   monto:  ',c.monto:2:2);
    end;    

    close(arc_comp);
end;
var
    arc_bin, arc_comp: archivo_comisiones;
    c: comision;
begin
  
    assign(arc_bin,'binario');
    rewrite(arc_bin);

    LeerCom(c);

    while(c.cod <> valorAlto) do begin
        write(arc_bin,c);
        LeerCom(c);
    end;


    CompactarArchivo(arc_bin, arc_comp);

    RecorrerArchivo(arc_bin);

    writeln;
    writeln;

    RecorrerArchivo(arc_comp);
end.