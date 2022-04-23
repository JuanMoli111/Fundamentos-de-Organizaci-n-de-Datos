program P2E8;
const
    valorAlto = 19997;
type

    registro_cliente = record
        cod: integer;

        nom, apellido : string[25];
    end;


    registro_venta = record
        cliente : registro_cliente;
        anio, mes, dia: integer;
        monto : real;
    end;

    archivo_maestro = file of registro_venta;

procedure leerVenta(var v: registro_venta);
begin
  
    writeln('Ingrese el codigo de cliente, ingrese -1 para cancelar: ');
    readln(v.cliente.cod);


    if(v.cliente.cod <> -1) then begin
        writeln('Ingrese el nombre del cliente: ');
        readln(v.cliente.nom);

        writeln('Ingrese el apellido del cliente: ');
        readln(v.cliente.apellido);

        writeln('Ingrese el dia de la venta: ');
        readln(v.dia);

        writeln('Ingrese el mes de la venta: ');
        readln(v.mes);

        writeln('Ingrese el anio de la venta: ');
        readln(v.anio);

        writeln('Ingrese el monto de la venta: ');
        readln(v.monto);
    end;
    
end;


procedure generarMae(var mae: archivo_maestro);
var
    regm : registro_venta;
begin
    Rewrite(mae);

    leerVenta(regm);

    while(regm.cliente.cod <> -1) do begin
        write(mae, regm);
        leerVenta(regm);
    end;

    Close(mae);
end;

procedure leer(var mae: archivo_maestro; var dato: registro_venta);
begin
    if(not(EOF(mae))) then
        read(mae,dato)
    else
        dato.cliente.cod := valorAlto;
end;

procedure informar(var mae: archivo_maestro);
var
    codAct, anioAct, mesAct: integer;
    
    //Contadores de montos por mes, por cliente, y total de todas las ventas
    montoMes, montoAnio, montoTotal: real;

    regm: registro_venta;
begin
    //Abrir archivo maestro
    Reset(mae);

    //Leer registro
    leer(mae,regm);

    MontoTotal := 0;

    while(regm.cliente.cod <> valorAlto) do begin
      
        codAct := regm.cliente.cod;

        WriteLn('Datos personasles: ');
        Writeln('Nombre: ',regm.cliente.nom);
        Writeln('Apellido: ',regm.cliente.apellido);


        while(regm.cliente.cod = codAct) do begin
          
            anioAct := regm.anio;
            montoAnio := 0;



            while((regm.cliente.cod = codAct) and (regm.anio = anioAct)) do begin
                mesAct := regm.mes;
                montoMes := 0;

                
                //Mientras sea el mismo mes..
                while((regm.cliente.cod = codAct) and (regm.anio = anioAct) and (regm.mes = mesAct)) do begin

                    //Totaizar el monto por mes
                    montoMes += regm.monto;

                    //LEE SIGUIENTE REGISTRO
                    leer(mae,regm);
                end;


                writeln('Monto en el mes ',mesAct,': ',montoMes:2:2);

                montoAnio += montoMes;


            end;

            writeln('Monto en el año ',anioAct,': ',montoAnio:2:2);
            montoTotal += montoAnio;

        end;    
    end;

    if(montoTotal > 0) then begin
        writeln;
        writeln('Monto total de todas las ventas: ',montoTotal:2:2);
    end;


    close(mae);
end;
var

    arc_mae : archivo_maestro;
begin
  
    Assign(arc_mae,'maestro');
    generarMae(arc_mae);

    informar(arc_mae);


end.