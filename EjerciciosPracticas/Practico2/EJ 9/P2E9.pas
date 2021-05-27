program P2E9;
    //PRECONDICIONES

    //  -ARCHIVO MAESTRO EXISTE Y DEBEMOS INFORMAR SUS DATOS
    //  -ARCHIVO MAESTOR ORDENADO POR COD DE PROV Y COD DE LOCALIDAD

const

    valorAlto = -9999;

type
    str20 = string[20];

    //reg_mesa representa una mesa electoral
    //Codigo de provincia, codigo de localidad, nro de mesa y votos de la mesa
    reg_mesa = record
        codProv, codLoc, nro, votos: integer;
    end;


    //Declara tipo para el archivo maestro, es un archivo de registros mesa electoral
    arc_mae = file of reg_mesa;


//Leer archivo maestro de mesas electorales sin errores de EOF
procedure leer(var arc_maestro: arc_mae;var dato: reg_mesa);
begin
    if(not(eof(arc_maestro)))then
        read(arc_maestro,dato)
    else begin
        dato.codProv := valorAlto;
        dato.codLoc := valorAlto;
    end;
end;

//DECLARACION DE VARIABLES
var
    //Declara el nombre logico del archivo maestro
    arc_maestro: arc_mae;

    //Registro mesa para recibir la informacion
    mesa : reg_mesa;

    //Cod actual de localidad y provincia, auxiliares para manejar los cortes de control
    codProvAct, codLocAct: integer;
    
    //Contadores para los votos totales, por provincia y por localidad
    totProv, totLoc: integer;
    totVotos : longint;

begin

    //Assign y apertura del archivo maestro
    assign(arc_maestro,'maestro');
    reset(arc_maestro);

    //Inicializar en cero el contador de votos totales
    totVotos := 0;

    //Leer el primer registro mesa electoral
    leer(arc_maestro,mesa);

    //Mientras haya datos en el archivo maestro
    while(mesa.codProv <> valorAlto) do begin

        //Actualizar los cod actuales de provincia y localidad ya que entro un nuevo registro mesa electoral
        with mesa do begin
            codProvAct := codProv;
            codLocAct := codLoc;
        end;

        //Informar en forma de lista
        writeln('Codigo de provincia    ',codProvAct);

        //Reiniciar el contador de votos de la provincia
        totProv := 0;


        //Mientras la provincia sea la misma...
        while(mesa.codProv = codProvAct) do begin

            //Informar en forma de lista
            writeln('Codigo de localidad           Total de votos');

            //Actualizar el cod de localidad actual ya que entro un reg mesa de otra localidad
            codLocAct := mesa.codLoc;

            //Reiniciar el contador de votos de la localidad
            totLoc := 0;

            //Mientras la localidad sea la misma...
            while(mesa.codLoc = codLocAct) do begin

                //Acumular los votos en los contadores provincial, local y total
                totProv += mesa.votos;
                totLoc += mesa.votos;
                totVotos += mesa.votos;

                //Leer el siguiente registro
                leer(arc_maestro,mesa);
            end;

            //Informar en forma de lista
            writeln('   ',codLocAct,'                       ',totLoc);
        end;

        //Informar en forma de lista
        writeln(' Total de votos provincia: ', totProv);
    end;

    //Informar en forma de lista
    writeln('Total general votos: ',totVotos);

    //Cerrar archivo maestro
    close(arc_maestro);
end.