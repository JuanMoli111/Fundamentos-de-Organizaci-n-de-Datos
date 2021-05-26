program P2E4;
//PRECONDICIONES:

//      -ARCHIVOS DETALLE EXISTEN Y SON CINCO
//      -ARCHIVO MAESTRO NO EXISTE
//      -TODOS LOS ARCHIVOS DETALLE ORDENADOS POR COD DE USER Y FECHA
//      -UN USER PUEDE INICIAR MAS DE UNA SESION POR DIA (MISMA FECHA) Y EN DIFERENTES MAQUINAS (DIFERENTES ARCHIVOS DETALLE)
//      -EL ARCHIVO MAESTRO DEBE CREARSE EN LA UBICACION FISICA /var/log
//          
const

    valorAlto = -9999;
    
    cantE = 5;

type

    //Declara tipos rango para los dias meses y años de la fecha
    subr30    = 1..30;
    subr12  = 1..12;
    subr2022   = 2020..2022;

    //registro fecha con subrangos para especificar una fecha entre el 2020 y el 2022
    fecha = record
        dia : subr30;
        mes : subr12;
        anio : subr2022;
    end;

    //Codigo del usuario que inicio sesion, fecha de  la sesion, y el tiempo de sesion en minutos
    sesion = record
        cod : integer;
        fech : fecha;
        tiempo: integer;
    end;

    //Declara el tipo archivo de sesiones, sera el arc detalle
    arc_detalle = file of sesion;

    //El archivo maestro será de registros sesion_total_semanal, que representan el conteo semanal de las sesiones de cada usaurio,
    //la fecha sera la semana en que se genera el archivo de logs, el tiempo total la suma de todas las sesiones del mismo user
    sesion_total_semanal = record
        cod : integer;
        fech : fecha;
        tiempo_total : integer;
    end;

    //Declara el tipo para el archivo maestro
    arc_mae = file of sesion_total_semanal;

    //Declara un arreglo para los archivos de sesiones de las 5 maquinas, 
    arreglo_sesiones = array[1..cantE] of arc_detalle;

    //Declara un tip arreglo de registros sesiones, util como auxiliar para mover informacion
    arreglo_reg_sesiones = array[1..cantE] of sesion;

//PROCEDURE LEER REGISTRO DE ARC DETALLE, SI NO HAY MAS DATOS RETORNA EL VALOR DE CORTE VALORALTO
procedure leer(var arc: arc_detalle; var dato: sesion);
begin
    if(not(eof(arc))) then
        read(arc,dato)
    else
        dato.cod := valorAlto;
end;
    
//Calcula el registro con menor codigo de un arreglo de cantE registros sesion, 
//lo retorna en min y retorna el índice del arreglo donde se encontró, se avanzará en el archivo de tal indice
//en el arreglo de archivos detalle, antes de volver a mandar el arreglo de registros y calcular el siguiente minimo
procedure minimo(var array_sesions: arreglo_reg_sesiones; var min: sesion; var minPos: integer);
var
	i: integer;
begin
    //Itera a traves del arreglo de registros
    for i := 1 to cantE do begin
        //Si el codigo de la sesion actual es menor al cod sesion minimo, actualizar la sesion minima
        if(array_sesions[i].cod < min.cod) then begin
            //Guarda el nuevo minimo en el parámetro a retornar min
            min := array_sesions[i];
            //Guarda la posicion donde se encontró el minimo en minPos para retornarla
            minPos := i;
        end;
    end;
end;

var
    //Nombre logico archivo maestro 
    archMae : arc_mae;

    //Arreglo de archivos detalle
    vectorArchDet : arreglo_sesiones;

    //Arreglo de registros sesion auxiliares
    vectorRegSesion : arreglo_reg_sesiones;

    //reg sesion minima
    sesion_min : sesion;

    dateChanged: boolean;

    //Reg sesion para elarchivo maestro
    sesion_semanal : sesion_total_semanal;

    //Cod actual para corte de control  
    //indice 
    //posMin para actualizar arreglos
    codAct, i, posMin: integer;
    
    //Fecha actual para cortes de control
    fechAct : fecha;
    
    //string Indices para nombrar los archivos dinamicamente (arreglo N archivos)
    strIndice : string;
begin

    //Assign y creacion del archivo maestro
    assign(archMae,'var/log/maestro');
    rewrite(archMae);


    for i := 1 to cantE do begin
        //Genera un string in strindice 
        Str(i,strIndice);
        //Assign y apertura de los 5 archivos detalle
        assign(vectorArchDet[i],'det'+strIndice);
        reset(vectorArchDet[i]);

        //lee y avanza en los 5 archivos detalle , almacena los cinco registros sesiones en el vector,
        leer(vectorArchDet[i],vectorRegSesion[i]);

    end;



    //Calcula el primer registro sesion mínino del arreglo de sesion generado, lo retorna en ventamin 
    minimo(vectorRegSesion,sesion_min,posMin);
    //Ya almacenado el registro minimo en sesion_min, lee el siguiente registro en ese archivo,
    // almacenandolo y asi actualizando el arreglo de registros del que se calculará luego el segundo registro mínimo
    leer(vectorArchDet[posMin],vectorRegSesion[posMin]);

    //Mientras haya datos en los archivos
    while(sesion_min.cod <> valorAlto) do begin
        //Actualiza el codigo actual y la fecha(cambio la sesion)
        codAct := sesion_min.cod;
        fechAct := sesion_min.fech;
        dateChanged := False;

        //Mientras la fecha del user que inició sea la misma
        while(not(dateChanged)) do begin
            //Actualiza la fecha actual (cambio la fecha)
            fechAct := sesion_min.fech;

            //Setea el registro sesion con los datos del user de la sesion actual y el tiempo total en cero
            with sesion_semanal do begin
                cod := sesion_min.cod;
                fech := sesion_min.fech;
                tiempo_total := 0;
            end;

            //Mientras la fecha de la sesion sea la misma
            while(sesion_min.cod = codAct) do begin

                //Suma el tiempo de la sesion al campo tiempo total del registro sesion_total_semanal
                with sesion_semanal do tiempo_total += sesion_min.tiempo;

                //Calcula el primer registro sesion mínino del arreglo de sesion generado, lo retorna en ventamin 
                minimo(vectorRegSesion,sesion_min,posMin);
                //Ya almacenado el registro minimo en sesion_min, lee el siguiente registro en ese archivo,
                // almacenandolo y asi actualizando el arreglo de registros del que se calculará luego el segundo registro mínimo
                leer(vectorArchDet[posMin],vectorRegSesion[posMin]);

            end;
            
            dateChanged := True;

            //Cambió el user, almacenar sesion_semanal en el archivo maestro
            write(archMae,sesion_semanal);

        end;


    end;

    //Cierra los archivos detalle
    for i := 1 to cantE do 
        close(vectorArchDet[i]);

    //Cierra el archivo maestro
    close(archMae);


end.

