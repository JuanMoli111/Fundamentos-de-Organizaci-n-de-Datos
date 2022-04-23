program P2E12;
const

    valorAlto = 19991;
type


    acceso = record
        anio, mes, dia, id: integer;
        tiempo: real;
    end;


    maestro = file of acceso;
procedure leer(var mae : maestro; var dato: acceso);
begin
    if(not(EOF(mae))) then
        read(mae,dato)
    else
        dato.anio := valorAlto;
end;

procedure informe(var mae: maestro; anio : integer);
var
    regm: acceso;

    encontroAnio : Boolean;

    anioAct, mesAct, diaAct, idAct: integer;

    totalId, totalDia, totalMes, totalAnio: real;
begin

    //Abrir maestro
    Reset(mae);

    //Leer primer registro
    leer(mae,regm);

    encontroAnio := false;


    //Mientras no encuentre el anio solicitado y haya registros, chequear si el anio es el solicitado, si se encontro setear TRUE, sino SEGUIR LEYENDO REGISTROS
    while((encontroAnio = false) and (regm.anio <> valorAlto)) do if(anio = regm.anio) then encontroAnio := true else read(mae,regm);

    //Solo entrar a listar los datos si encontro el anio
    if(encontroAnio) then begin
        //Mientras haya registros
        while(regm.anio <> valorAlto) do begin
        
            //Salvar el anio actual
            anioAct := regm.anio;

            //INFORMAR  
            writeln('Año: ',anioAct);

            //Inicializar contador total tiempo de acceso en el año
            totalAnio := 0;

            //Mientras el registro sea del mismo año
            while (anioAct = regm.anio) do begin
            
                //Salvar mes actual
                mesAct := regm.mes;

                //Inicalizar contador tiempo de acceso por mes
                totalMes := 0;

                //INFROMAR
                writeln('Mes: ',mesAct);

                //Mientras el registro sea del mismo mes
                while((anioAct = regm.anio) and (mesAct = regm.mes)) do begin
                
                    //Salvar el dia actual
                    diaAct := regm.dia;

                    //Inicializar contador de tiempo de acceso por dia
                    totalDia := 0;

                    //INFORMAR
                    writeln('dia: ',diaAct);

                    //Mientras el registro sea del mismo dia
                    while((anioAct = regm.anio) and (mesAct = regm.mes) and (diaAct = regm.dia)) do begin

                        //Salvar id del user actual
                        idAct := regm.id;

                        //Inicializar contador de tiempo de acceso por ID de user
                        totalId := 0;

                        //INFORMAR
                        writeln('idUsuario: ',idAct,'   Tiempo total de acceso en el dia ',diaAct,' mes ',mesAct);
                        
                        //Mientras sea el mismo user, totalizar el tiempo de acceso, leer siguiente registro maestro
                        while((anioAct = regm.anio) and (mesAct = regm.mes) and (diaAct = regm.dia) and (idAct = regm.id)) do begin
                            totalId += regm.tiempo;
                            leer(mae,regm);
                        end;

                        //INFORMAR TIEMPO POR USER
                        writeln(totalId);

                        //Contabilizar en total por dia, cada total por user
                        totalDia += totalId;
                    end;

                    //INFORMAR
                    writeln('Tiempo total acceso dia ',diaAct,' mes ',mesAct,': ',totalDia);

                    //Contabilizar en el tiempo por mes, cada tiempo contabilizado por dia
                    totalMes += totalDia;

                end;

                //INFORMAR
                writeln('Tiempo total de acceso mes ',mesAct,': ',totalMes);

                //Contablizar en el total por anio, cada total contablizado por mes
                totalAnio += totalMes;

            end;    

            WriteLn('Total tiempo de acceso año: ',totalAnio);

        end;
    end
    //Si no encontro el año, informar el error
    else writeln('Año no encontrado');


    close(mae);
end;
var

    year: Integer;

    mae: maestro;
begin
  
    Assign(mae,'maestro');


    writeln('Ingrese un año, se realizara un informe sobre los datos de accesos al servidor, si es que el año existe');
    readln(year);


    informe(mae,year);

end.