//Una empresa posee un archivo con informacion de los ingresos percibidos por diferentes empleado en concepto
//e comision, de cada uno de ellos se conoce: codigo de empleado, nombre y monto de la comision. La
//informacion del archivo se encuentra ordenada por codigo de empleado y cada empleado puede aparecer mas de una 
//vez en el archivo de comisiones

//Realice un procedimiento que reciba el archivo descripto y lo compacte. En consecuencia, deberá generar un
//nuevo archivo en el cual, cada empleado aparezca una única vez con el valor total de sus comisiones

//NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser recorrido una única vez

program P2E1;
const
    valorAlto = -9919;
type

    str15 = string[15];

    //Cada uno de los ingresos por comisión de los empleados (los empleados pueden tener mas de una comision)
    comision = record
        cod : integer;
        nombre : str15;
        monto: real;
    end;

    //La comisión total de cada empleado (los empleados aparecen una unica vez)
    comision_total = record
        nombre : str15;
        total : real;
    end;


    //Archivos de cada tipo, en este ejemplo el archivo de comision son el DETALLE y el archivo de comisiones totales es el maestro
    arc_comisiones =         file of comision;
    arc_comisiones_totales = file of comision_total;


procedure leer(var arc_com : arc_comisiones; var dato: comision);
begin
    if(not(eof(arc_com)))then
        read(arc_com,dato)
    else
        dato.cod := valorAlto;
end;

var
    //Declara los nombres logicos para los archivos
    arc_det : arc_comisiones;
    arc_mae : arc_comisiones_totales;
    //Declaramos dos registros uno para las comisiones y otro para las comisiones totales
    reg_com : comision;
    reg_com_tot: comision_total;
    //Un codigo actual como auxiliar para los cortes de control
    cod_act : integer;
begin
    //Assign de cada archivo, empleados existe, maestro no existe
    assign(arc_mae,'maestro.txt');
    assign(arc_det,'empleados.txt');

    //Crea el arc maestro donde cargará las comisiones totales y lo abre
    rewrite(arc_mae);
    //Abre el archivo detalle de comisiones
    reset(arc_det);

    //Leer el primer registro de comisiones
    leer(arc_det,reg_com);

    //Mientras el cod actual sea distinto de valorAlto (osea los archivos aun tienen datos)
    while(reg_com.cod <> valorAlto)do begin

        //Guarda el codigo actual
        cod_act := reg_com.cod;

        //Inicializamos el registro contador de comisiones totales, asigamos el nombre del empleado y el total en 0
        with reg_com_tot do begin
            nombre := reg_com.nombre;
            total := 0;
        end;
        //Mientras el empleado sea el mismo, ir acumulando las comisiones en el total
        while(reg_com.cod = cod_act) do begin
            //Suma al contador el monto de la comision
            reg_com_tot.total += reg_com.monto;

            //Lee otro registro del archivo detalle de comisiones
            leer(arc_det,reg_com);
        end;

        //Almacenar en el maestro el total de comisiones del empleado
        write(arc_mae,reg_com_tot);

    end;

    //Cerrar archivos maestro y detalle
    close(arc_mae);
    close(arc_det);

end.