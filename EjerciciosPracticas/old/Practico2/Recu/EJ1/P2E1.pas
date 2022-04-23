program ej1;
const
    valorAlto = 9999;
type

    str25 = string[25];

    empleado = record
        cod : integer;
        monto: real;
        nom : str25;
    end;

    arc_empleados = file of empleado;


procedure leer(var arc_emp: arc_empleados; var e: empleado);
begin
    if(not(eof(arc_emp))) then
        read(arc_emp,e)
    else
        e.cod := valorAlto;
end;

procedure CompactarArchivo(var arc_mae, arc_det: arc_empleados);
var
    e_det, e_mae: empleado;
    tot : real;
    codActual: integer;
begin
    reset(arc_det);

    //Crear y abrir el archivo maestro que resumira la informacion de los empleados
    assign(arc_mae,'archivo-compactado');
    rewrite(arc_mae);

    //Leer el primer empleado del archivo detalle
    leer(arc_det,e_det);

    while(e_det.cod <> valorAlto)do begin

        //Guardar al registro maestro de empleado, los datos del empleado detalle que se almacenarán
        e_mae := e_det;

        //Set el total a cero, el codigo actual es del empleado actual
        tot := 0;
        codActual := e_det.cod;

        //Mientras siga siendo el mismo empleado, totalizar sus comisiones y leer otro arc detalle
        while(e_det.cod = codActual) do begin
            
            tot := tot + e_det.monto;

            leer(arc_det,e_det);
        end;

        //Guardar el total en el empleado reg maestro
        e_mae.monto := tot;

        //Escribe al maestro la informacion del detalle
        write(arc_mae,e_mae);
        
    end;

    close(arc_mae);
    close(arc_det);

end;
var

    arc_mae, arc_det : arc_empleados;
begin

    assign(arc_det,'detalle-comisiones');

    CompactarArchivo(arc_det,arc_mae);

end.