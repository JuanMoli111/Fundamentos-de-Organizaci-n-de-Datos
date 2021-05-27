program P2E8;
//  PRECONDICIONES

    //  -EL MAESTRO EXISTE Y TIENE INFO DE VENTAS A CLIENTES
    //  -HAY QUE INFORMAR LA DATA DE LAS VENTAS 
    //  -MAESTRO ORDENADO POR COD DE CLIENTE, LUEGO AÑO DE LA VENTA, LUEGO MES DE LA VENTA
    //  -

const

    valorAlto = -9999;
//DECLARACION DE TIPOS
type
    str15 = string[15];

    fecha = record
        dia : 1..31;
        mes : 1..12;
        anio: 2000..2021;
    end;

    //Registro venta
    venta = record
        cod : integer;
        date: fecha;
        monto: real;
        nom, ape: str15;
    end;

    //Declara tipo arch maestro es file de registros venta
    arc_mae = file of venta;



//Leer archivo de ventas sin errores de EOF
procedure leer(var arc_maestro: arc_mae;var dato: venta);
begin
    if(not(eof(arc_maestro))) then
        read(arc_maestro,dato)
    else begin
        dato.cod := valorAlto;
        dato.date.mes := valorAlto;
        dato.date.anio := valorAlto;
    end;
end;

//DECLARACION DE VARIABLES
var
    //Nombre logico para el archivo maestro de ventas
    arc_maestro : arc_mae;

    //Registro venta
    v : venta;

    //Cod actual, año actual, mes actual, variables para el corte de control 
    codAct, anioAct, mesAct : integer;

    //Nombre y apellido para informar datos personales del cliente
    nomCliente, apeCliente: str15;

    //Contadores para: ventas totales de la emrpesa, ventas mensuales y anuales de los clientes
    total, totMensual, totAnual: real;

//PROGRAMA PRINCIPAL
begin

    assign(arc_maestro,'maestro');
    reset(arc_maestro);

    leer(arc_maestro,v);

    total := 0;

    while(v.cod <> valorAlto) do begin

        //Nuevo registro venta, (cambió el usuario), actualizar las variablaes auxiliares act
        with v do begin
            codAct := cod;
            anioAct := date.anio;
            mesAct := date.mes;
            nomCliente := nom;
            apeCliente := ape;
        end;

        writeln('EL CLIENTE: ', nomCliente,' ', apeCliente);

        while(v.cod = codAct) do begin

            //Cambió de anio, actualice anio actual
            anioAct := v.date.anio;
            totAnual := 0;

            writeln('EN EL ANIO: ', anioAct);

            while(v.date.anio = anioAct) do begin

                //Cambió de mes, actualice mes actual
                mesAct := v.date.mes;
                totMensual := 0;

                while(v.date.mes = mesAct) do begin

                    //Ir acumulando los montos de cada compra en los contadores totales mensual y anual
                    totMensual += v.monto;
                    totAnual += v.monto;
                    total += v.monto;


                    leer(arc_maestro,v);
                end;

                writeln('Total mes ',mesAct,' ',totMensual:2:2);


            end;

            writeln('Total anio ',anioAct,' ',totAnual:2:2);

        end;    
        
    end;

    

    writeln('El total recaudado por la empresa: ', total:2:2);

    close(arc_maestro);
end.