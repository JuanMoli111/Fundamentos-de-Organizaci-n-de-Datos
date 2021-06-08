program P3E2;
//PRECONDICIONES

            //  EL ARCHIVO DE DATOS EMPLEADOS DEBE GENERARSE
            //  DEBEN ELIMINARSE LOGICAMENTE AQUELLOS CON DNI INFERIOR A 8.000.000

const
    valorAlto = -9999;

type

    str20 = string[20];


    empleado = record
        cod, tel: integer;
        dni, fecha : longint;
        nom, ap, dir : str20;
    end;

    archivo = file of empleado;


procedure leer(var arc: archivo; var dato: empleado);
begin
    if(not(eof(arc))) then
        read(arc,dato)
    else 
        dato.cod := valorAlto;
end;

var
    e: empleado;
    arc_empleados: archivo;
begin

    //Assign y apertura del archivo empleados
    assign(arc_empleados,'empleados');
    rewrite(arc_empleados);

    //Lee el primer registro empleado
    leer(arc_empleados,e);


    //Mientras el archivo tenga datos
    while(e.cod <> valorAlto) do begin
        
        //Si el dni es menor a 8 millones, borrar logicamente el empleado
        if(e.dni < 8000000) then begin
            //Genera la marca de borrado logico en el campo nombre
            e.nom := '***' + e.nom;
            //Vuelve un registro atrás y sobreescribe el registro correspondiente
            seek(arc_empleados, filepos(arc_empleados) - 1);
            write(arc_empleados,e);
        end;

        //Lee el siguiente registro empleado
        leer(arc_empleados,e);

    end;

    //Cierra el archivo de empleados
    close(arc_empleados);

end.
