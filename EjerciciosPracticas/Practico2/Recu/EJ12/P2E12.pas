program ej12;
{
                                                PRECONDICIONES


            *   1-  EXISTE UN ARCHIVO MAESTRO CON DATOS DE LOS ACCESOS AL SERVIDOR WEB

            *   2-  EL ARCHIVO ORDENADO POR AÑO, MES, DIA, E ID DEL USER 

            *   3-  DEBE REALIZARSE UN INFORME RESPETANDO CIERTO FORMATO

            *   4-  EL INFORME DEBE SER DE UN AÑO INGRESADO POR TECLADO, DEBE INFORMARSE EN CASO DE NO ESTAR REGISTRADO TAL AÑO
}
const
    valorAlto = -1;
type

    //Declarar un tipo registro que represente los accesos al servidor
    accesos = record
        anio : -1..2030;
        mes  : 1..12;
        dia  : 1..31;
        
        id     : integer;
        tiempo : real;
    end;


    //Declarar un tipo para el archivo de accesos
    archivo = file of accesos;

procedure leer(var arc: archivo; var dato: accesos);
begin

    if(not(eof(arc))) then
        read(arc,dato)
    else
        dato.anio := valorAlto;

end;
var
    //Declarar variable para el archivo
    arc : archivo;

    //Registro acceso
    acceso : accesos;


    //Declarar totalizadores para el tiempo accedido
    totAnio, totMes, totDia: real;

    //Declarar variables de control para el corte de control
    anioInforme, mesAct, diaAct: integer;


begin



    //Assign y abrir archivo
    assign(arc,'accesos');
    rewrite(arc);

    //Input del año a realizar el informe
    writeln('Ingrese un año a realizar el informe');
    readln(anioInforme);

    
    //Leer primer registro
    leer(arc,acceso);

    //Mientras no se acaben los registros y el año actual no sea el año solicitado por el usuario
    while((acceso.anio <> valorAlto) and (acceso.anio <> anioInforme)) do leer(arc,acceso);
    


    //Si el año existe comenzar el informe de los datos
    if(acceso.anio = anioInforme) then begin



        //Inicializar totalizador
        totAnio := 0;
        

        writeln('Anio: ', anioInforme);

        //Mientras el año sea el mismo, realizar el informe
        while(acceso.anio = anioInforme) do begin

            writeln('   Mes: ', acceso.mes);
            
            //inicializar totalizador y variable de control
            totMes := 0;
            mesAct := acceso.mes;


            while((acceso.anio = anioInforme) and (mesAct = acceso.mes)) do begin

                writeln('       Dia: ', acceso.dia);

                //inicializar totalizador y variable de control
                totDia := 0;
                diaAct := acceso.dia;



                while((acceso.anio = anioInforme) and (mesAct = acceso.mes) and (diaAct = acceso.dia)) do begin
                    
                    //totalizar tiempo de acceso
                    totAnio += acceso.tiempo;
                    totMes += acceso.mes;
                    totDia += acceso.dia;


                    //Informar con formato
                    writeln('           idUsuario ',acceso.id,'    Tiempo total de este acceso el dia ',diaAct, ' mes ',mesAct,':  ',acceso.tiempo:2:2);


                    //Leer siguiente registro de acceso
                    leer(arc,acceso);
                end;


                writeln('       Tiempo total acceso en el dia ',diaAct,' mes ',mesAct,'    :',totDia:2:2);

            end;
            
            writeln('   Tiempo total acceso en el mes ',mesAct,'    :',totMes:2:2);

        end;
            
        writeln('Tiempo total acceso en el anio: ',totAnio:2:2);

    end
    else writeln('Anio no encontrado');


    //Cerrar archivo
    close(arc);
end.

