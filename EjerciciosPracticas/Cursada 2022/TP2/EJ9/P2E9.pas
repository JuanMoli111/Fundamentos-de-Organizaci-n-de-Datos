program P2E9;
const
    valorAlto = 9999;
type


    mesa = record
        cod_localidad, cod_provincia, nro_mesa, cant_votos: integer;
    end;


    archivo_maestro = file of mesa;

procedure leer(var mae: archivo_maestro; var dato: mesa);
begin
    if(not(EOF(mae))) then
        read(mae,dato)
    else
        dato.cod_provincia := valorAlto;
end;

procedure listarDatos(var mae: archivo_maestro);
var
    provAct, locAct : integer; 

    //declarar contadores para el total de votos, el total por provincia y el total por localidad
    total, totalProv, totalLoc : integer;

    regm  : mesa;
begin
  
    //Abrir archivo maestro
    Reset(mae);

    //Leer primer registro
    leer(mae,regm);

    total := 0;

    //Mientras haya registros
    while(regm.cod_localidad <> valorAlto) do begin
      
        provAct := regm.cod_provincia;
        totalProv := 0;


        WriteLn('Codigo de provincia: ',provAct);

        while(provAct = regm.cod_provincia) do begin
            WriteLn('Codigo de localidad: ',regm.cod_localidad,'       votos: ',regm.cant_votos);    

            totalProv += regm.cant_votos;
        end;  

        Writeln('Total de votos en la provincia ',provAct,': ',totalProv);
        total += totalProv;
    end;

    WriteLn('Total de votos: ',total);

    close(mae);

end;

var
    arc_mae : archivo_maestro;
begin

    Assign(arc_mae,'maestro');
  
    listarDatos(arc_mae);

end.