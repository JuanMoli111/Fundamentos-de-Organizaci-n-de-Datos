program ej18;
{
                        PRECONDICIONES


        1*  -   EXISTE UN ARCHIVO CON INFORMACION DE VENTAS, DE EVENTOS DE UN TEATRO

        2*  -   LA INFORMACION ORDENADA POR NOMBRE DE EVENTO Y LUEGO POR FECHA DE LA FUNCION    (CADA EVENTO PUEDE TENER 1 O MAS FUNCIONES)

        3*  -   SE DEBE REALIZAR UN INFORME CON EL FORMATO DESCRITO EN EL TRABAJO PRACTICO
}
const
    valorAlto = 'ZZXD';
type

    str25 = string[25];
    str6 = string[6];

    ventaEvento = record
        
        nom, sector : str25;
        fecha : str6;

        entradasVendidas: integer;
    end;


    maestro = file of ventaEvento;

procedure leer(var mae: maestro; var dato: ventaEvento);
begin
    if(not(eof(mae))) then read(mae,dato)
    else dato.nom := valorAlto;
end;

procedure realizarInforme(var mae: maestro);
var
    regm : ventaEvento;

    totFuncion, totEvento : integer;

    nomAct : str25;
    fechaAct : str6;
begin

    reset(mae);


    leer(mae,regm);

    while(regm.nom <> valorAlto) do begin

        totEvento := 0;

        nomAct := regm.nom;

        write(nomAct, 'Evento N');


        while(nomAct = regm.nom) do begin

            totFuncion := 0;
            fechaAct := regm.fecha;

            while((nomAct = regm.nom) and (fechaAct = regm.fecha)) do begin

                write('     ',fechaAct,' fecha N');


                writeln('               ',  regm.sector,'   N       cant vendida: ',   regm.entradasVendidas);

                totFuncion += regm.entradasVendidas;
                totEvento += regm.entradasVendidas;

                leer(mae,regm);
            end;


            writeln('     cant total entradas vendidas por funcion: ', totFuncion);

        end;


        writeln('cant total entradas vendidas por evento: ', totEvento);

    end;
    
    close(mae);
end;
var
    mae: maestro;

begin
    assign(mae,'maestro');
    rewrite(mae);
    realizarInforme(mae);
end.