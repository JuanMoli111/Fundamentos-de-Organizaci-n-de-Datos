program ej8;
{
                PRECONDICIONES


            *   1-  EXISTE UN ARCHIVO MAESTRO CON INFORMACION DE VENTAS DE UNA EMPRESA

            *   2-  EL ARCHIVO ORDENADO POR CODIGO DE CLIENTE, AÑO Y MES
            
            *   3-  SE DEBE GENERAR UN REPORTE TOTALIZANDO EL TOTAL MENSUAL DE COMPRAS POR CLIENTE, EL TOTAL ANUAL Y EL TOTAL DE VENTAS DE LA EMPRESA
            
            *   4-  EL CICLO DE PROCESAMIENTO DE LOS DATOS CONFORMADO POR CUATRO ESTRUCTURAS WHILE ANIDADAS, UNA PARA EL EOF Y TRES PARA CADA CRITERIO DE ORDENAMIENTO APLICANDO CORTE DE CONTROL -> por precondicion 2
}
const
    valorAlto = 0;
type

    str25 = string[25];

    cliente = record
        cod: integer;
        nom, ape: str25;
    end;

    fecha = record
        anio : 0..2021;
        mes  : 0..12;
        dia  : 0..31;
    end;

    //Registro venta
    venta = record
        cliente : cliente;
        fecha   : fecha;
        monto   : real;
    end;

    //Declaracion del tipo de archivo de ventas
    archivo_ventas = file of venta;


//DEVOLVER SIGUIENTE REGISTRO DEL ARCHIVO, SI ES EOF DEVOLVER UN VALOR DE CORTE
procedure leer(var arc: archivo_ventas;var dato: venta);
begin
    if(not(eof(arc))) then
        read(arc,dato)
    else
        dato.cliente.cod := valorAlto;

end;

var

    maestro : archivo_ventas;

    v: venta;

    //Declaracion de variables de control para el corte de control
    codAct, anioAct, mesAct : integer;

    //Variables para la totalizacion de ventas por mes, por año y totales de la empresa
    totMes, totAnio, total: real;


begin

    //Assign y abrir el archivo de ventas
    assign(maestro,'maestro');
    reset(maestro);


    //Leer el primer registro de ventas
    leer(maestro,v);

    //Inicializar el totalizador de ventas de la empresa
    total := 0;

    while(v.cliente.cod <> valorAlto) do begin


        writeln('DATOS PERSONALES: ');
        writeln('Nombre: ', v.cliente.nom,'     Apellido: ',v.cliente.ape,'    Codigo de cliente: ',v.cliente.cod);


        //Inicializar el codigo de cliente actual
        codAct := v.cliente.cod;

        //Mientras el cliente sea el mismo, totalizar ventas x año y mes...
        while(codAct = v.cliente.cod) do begin


            //Inicializar el anio actual y el totalizador por año, notar que cuando cambie de año se 'resetean' estas variables
            anioAct := v.fecha.anio;

            totAnio := 0;

            //Mientras el año sea el mismo, 
            while((anioAct = v.fecha.anio) and (codAct = v.cliente.cod)) do begin


                //Inicializar el mes actual y el totalizador por mes,
                mesAct := v.fecha.mes;
                totMes := 0;


                //Mientras el mes sea el mismo
                while((mesAct = v.fecha.mes) and (anioAct = v.fecha.anio) and (codAct = v.cliente.cod))do begin
                    

                    with v do begin
                        total += monto;
                        totAnio += monto;
                        totMes += monto;
                    end;


                    leer(maestro,v);

                end;

                //Informar total mensual
                writeln('Total vendido en el mes ',mesAct,': ',totMes:2:2);


            end;

            //Informar total anual
            writeln('Total vendido en el anio ',anioAct,': ',totAnio:2:2);
        end;

    end;

    //Informar total de ventas
    writeln('Total de ventas de la empresa: ',total:2:2);

    //Cerrar archivo
    close(maestro);

end.




