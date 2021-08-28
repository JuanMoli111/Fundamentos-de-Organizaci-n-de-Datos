//  ACTIVIDAD UNO       Molinari Juan Roman         Legajo 17213/1

program actividad1;
const
    valorAlto = '9999';
type
    str25 = string[25];


    venta = record
        nombre : str25;
        fecha : integer;
        sec : str25;
        ventas: integer;
    end;

    arc_venta = file of venta;

var
    v : venta;

    arc : arc_venta;

    total, cantFuncion, cantEvento: integer;
    evento: str25;
    funcion : integer;

procedure leer(var arc: arc_venta; var v: venta);
begin
    if(not(eof(arc))) then
        v.nombre := valorAlto
    else
        read(arc,v);

end;
begin

    assign(arc,'nombre_fisico');

    reset(arc);

    leer(arc,v);

    writeln('Nombre evento: ', v.nombre);

    while(v.nombre <> valorAlto) do begin

        evento := v.nombre;

        cantEvento := 0;
        
        writeln('Fecha funcion ', v.fecha);

        while(evento = v.nombre)do begin

            funcion := v.fecha;

            cantFuncion := 0;


            while(funcion = v.fecha) and (evento = v.nombre) do begin

                writeln('Sector: ', v.sec, '     Cantidad vendida: ', v.ventas);

                cantFuncion += v.ventas;

                leer(arc,v);
            end;

            writeln('----------------------------------------------------------------');

            writeln('Cantidad total vendida por funcion ', v.fecha, '   ',  cantFuncion);

            cantEvento += cantFuncion;

        end;

        writeln('Cantidad total vendida por evento: ', cantEvento);

    end;

    close(arc);

end.