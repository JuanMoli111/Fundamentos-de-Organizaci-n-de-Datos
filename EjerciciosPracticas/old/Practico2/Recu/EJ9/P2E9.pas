program ej9;
{
                PRECONDICIONES

            *   1- EXISTE UN ARCHIVO MAESTRO DE DATOS DE VOTOS

            *   2- EL ARCHIVO ORDENADO POR CODIGO DE PROVINCIA Y CODIGO DE LOCALIDAD

            *   3- DEBEN INFORMARSE LA CANTIDAD DE VOTOS DE CADA LOCALIDAD Y EL TOTAL POR CADA PROVINCIA


    SUPOSICIONES:

            *   SUPONDRE QUE PUEDE HABER MAS DE UNA MESA POR LOCALIDAD, Y QUE DEBE TOTALIZARSE LA CANTIDAD DE VOTOS DE LAS MESAS POR LOCALIDAD AUNQUE EL ENUNCIADO ASI NO LO ESPECIFIQUE

}
const
    valorAlto = 9999;
type

    //Codigo de provincia, codigo de localidad, cantidad de votos en la mesa, numero de mesa
    mesa = record
        codProv, codLoc, cant, num: integer;
    end;

    //Declarar tipo para archivos de registros mesa
    archivo = file of mesa;

//LEER EL SIGUIENTE REGISTRO DE UN ARCHIVO, SI ES EOF DEVOLVER UN VALOR DE CORTE
procedure Leer(var arc: archivo; var dato: mesa);
begin
    if(not(eof(arc))) then
        read(arc,dato)
    else
        dato.codProv := valorAlto;
end;

//DECLARACION DE VARIABLES
var

    //Archivo binario de registros mesa
    maestro : archivo;

    //Registro mesa
    m : mesa;

    //Declarar variables totalizadoras, y variables de control para el corte de control
    provAct, locAct, totProv, totLoc, total: integer;

begin
    //Assign y abrir el archivo
    assign(maestro,'maestro');
    rewrite(maestro);

    //Leer el primer registro del archivo
    leer(maestro,m);

    //Inicializar el totalizador general
    total := 0;

    while(m.codProv <> valorAlto) do begin

        //Inicializar totalizador por provincia y prov actual
        totProv := 0;
        provAct := m.codProv;

        writeln('Codigo de provincia ',provAct);


        //Mientras la provincia siga siendo la misma
        while(m.codProv = provAct) do begin


            //Inicializar totalizador por localidad y localidad actual
            totLoc := 0;
            locAct := m.codLoc;


            writeln('Codigo de localidad ',locAct);

            //Mientras la localidad sea la misma
            while((locAct = m.codLoc) and (m.codProv = provAct))do begin
            
                //Totalizar los votos en los contadores
                totProv += m.cant;
                totLoc += m.cant;
                total += m.cant;

                //Leer el siguiente registro
                leer(maestro,m);
            end;

            //Informar el total por localidad
            write('     Total: ',totLoc);

        end;

        //Informar el total por provincia
        writeln('Total de votos provincia: ',totProv);

    end;

    //Informar el total general
    writeln('Total general de votos: ', total);


    //CIERRE DEL ARCHIVO
    close(maestro);

end.