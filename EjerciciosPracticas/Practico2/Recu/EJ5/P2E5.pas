program ej5;
uses SysUtils;

{
                PRECONDICIONES

            *   1-  EXISTEN 100 ARCHIVOS DETALLE, POR CADA UNA DE LAS 50 DELEGACIONES UN ARCHIVO DE NACIMIENTOS Y UNO DE DECESOS

            *   2-  LOS ARCHIVOS ESTAN ORDENADOS POR PARTIDA DE NACIMIENTO LA CUAL ES UNICA POR PERSONA

            *   3-  DEBE GENERARSE UN ARCHIVO MAESTRO RECOPILANDO LA INFORMACION DE LOS DETALLES,

            *   4-  SIEMPRE HABRA UN REG NAC PARA UN REG DEC, PERO NO AL REVES, por precondicion 1 y 2

            *   5-  PODEMOS QUEDARNOS SIN DECESOS ANTES DE QUEDARNOS SIN NACIMIENTOS, por precondicion 4

           
}
const

    dimF = 50;
    valorAlto = -9999;
type

    str25 = string[25];


    fecha = record
        dia: -1..31;
        mes: -1..12;
        anio: -1..2022;
    end;
    hora = record
        horas: -1..24;
        minutos: -1..60;
    end;
    direccion = record
        calle, nro, piso, depto : integer;
        ciudad : str25;
    end;

    nacimiento = record
        nroPartida: integer;
        dniM, dniP : longint;
        nom, ape, matrN, nomM, apeM, nomP, apeP: str25;
        dir : direccion;
    end;

    deceso = record
        nroPartida: integer;
        dni: longint;
        nom, ape, lugar, matrD: str25;
        fecha: fecha;
        hora : hora;
    end;

    //persona es el registro maestro, en este registro compilaremos los datos
    persona = record
        nroPartida: integer;
        dni, dniM, dniP: longint;
        nom, ape, matrN, matrD, nomM, apeM, nomP, apeP, lugar: str25;
        dir : direccion;
        fecha: fecha;
        hora: hora;
    end;

    maestro = file of persona;

    detalle_nacimientos = file of nacimiento;
    detalle_decesos     = file of deceso;

    vec_det_nac = array[1..dimF] of detalle_nacimientos; 
    vec_det_dec = array[1..dimF] of detalle_decesos; 

    vec_reg_nac = array[1..dimF] of nacimiento;
    vec_reg_dec = array[1..dimF] of deceso;

    
//DECLARACION DE VARIABLES
var

    arc_txt : text;
    arc_mae : maestro;


    //Declarar los vectores de archivos, nacimientos y decesos respectivamente
    vec_arc_nac : vec_det_nac;
    vec_arc_dec : vec_det_dec;

    //Declarar vectores de registros, nacimientos y decesos respectivamente
    vec_nac : vec_reg_nac;
    vec_dec : vec_reg_dec;

    minNac : nacimiento;
    minDec : deceso;
    regM: persona;

    i : integer;


//DEVOLVER SIGUIENTE REGISTRO DE UN ARCHIVO DETALLE DE NACIMIENTOS , SI ES EOF DEVOLVER UN VALOR DE CORTE
procedure leerDetNac(var arc: detalle_nacimientos; var dato: nacimiento);
begin
    if(not(eof(arc))) then
        read(arc,dato)
    else
        dato.nroPartida := valorAlto;
end;    
//DEVOLVER SIGUIENTE REGISTRO DE UN ARCHIVO DETALLE DE DECESOS, SI ES EOF DEVOLVER UN VALOR DE CORTE
procedure leerDetDec(var arc: detalle_decesos; var dato: deceso);
begin
    if(not(eof(arc))) then
        read(arc,dato)
    else
        dato.nroPartida := valorAlto;
end;    
{--RECIBE UN VECTOR DE REGISTROS DE NACIMIENTOS Y RETORNA EL MINIMO POR NRO PARTIDA DE NACIMIENTO, EN EL PARAMETRO MIN.
 --ACTUALIZA Y RETORNA EL VECTOR DE REGISTROS LEYENDO EL SIGUIENTE DATO DEL DETALLE CORRESPONDIENTE    }
procedure minimoNac(var vec_reg: vec_reg_nac; var min: nacimiento);
var
    minPos, i : integer;
begin
    //Recorrer los reg detalle, consiguiendo la posicion del minimo
    for i := 1 to dimF do if(vec_reg[i].nroPartida < min.nroPartida) then minPos := i;
    //El registro minimo es el que esta en la posicion minPos 
    min := vec_reg[minPos];

    //Leer en el archivo detalle correspondiente, almacenar el siguiente registro en el vector de reg
    leerDetNac(vec_arc_nac[minPos],vec_reg[minPos]);
end;
{   --RECIBE UN VECTOR DE REGISTROS DE DECESOS Y RETORNA EL MINIMO POR NRO PARTIDA DE NACIMIENTO, EN EL PARAMETRO MIN.
    --ACTUALIZA Y RETORNA EL VECTOR DE REGISTROS LEYENDO EL SIGUIENTE DATO DEL DETALLE CORRESPONDIENTE    }
procedure minimoDec(var vec_reg: vec_reg_dec; var min: deceso);
var
    minPos, i : integer;
begin
    //Recorrer los reg detalle, consiguiendo la posicion del minimo
    for i := 1 to dimF do if(vec_reg[i].nroPartida < min.nroPartida) then minPos := i;
    //El registro minimo es el que esta en la posicion minPos 
    min := vec_reg[minPos];

    //Leer en el archivo detalle correspondiente, almacenar el siguiente registro en el vector de reg
    leerDetDec(vec_arc_dec[minPos],vec_reg[minPos]);
end;

begin

    //Assign y creacion del archivo maestro
    assign(arc_mae,'arc_maestro');
    rewrite(arc_mae);

    assign(arc_txt,'arc_text.txt');
    rewrite(arc_txt);

    for i := 1 to dimF do begin

        //Assign de los archivos detalle
        assign(vec_arc_nac[i],'det' + IntToStr(i) + ' nacimientos');
        assign(vec_arc_dec[i],'det' + IntToStr(i) + ' decesos');

        //Abrir los archivos
        rewrite(vec_arc_nac[i]);
        rewrite(vec_arc_dec[i]);

        //Almacenar el primer registro de cada archivo
        leerDetNac(vec_arc_nac[i],vec_nac[i]);
        leerDetDec(vec_arc_dec[i],vec_dec[i]);
    end;

    //Calcular el minimos para los nacimientos y los decesos
    minimoNac(vec_nac,minNac);
    minimoDec(vec_dec,minDec);

    //Mientras hayan datos en los detalles
    while(minNac.nroPartida <> valorAlto) do begin

        //Cargar los datos de nacimiento al registro maestro
        with regM do begin
            nroPartida := minNac.nroPartida; 
            nom := minNac.nom;      ape := minNac.ape;
            dniM := minNac.dniM;    dniP := minNac.dniP;    
            nomM := minNac.nomM;    nomP := minNac.nomP;    
            apeM := minNac.apeM;    apeP := minNac.apeP;            
            dir := minNac.dir;
            matrN := minNac.matrN;
        end;

        //Si los nro de partida son iguales es la misma persona, entonces el nac minimo actual fallecio
        if(minNac.nroPartida = minDec.nroPartida) then begin

            //Cargar los datos del deceso al registro maestro
            with regM do begin
                dni := minDec.dni;
                matrD := minDec.matrD;
                fecha := minDec.fecha;
                hora := minDec.hora;
                lugar := minDec.lugar;
            end;

            //AVANZAR EN LOS ARCHIVOS DE NAC Y DE DECESOS
            minimoNac(vec_nac,minNac);
            minimoDec(vec_dec,minDec);
        end
        //Si no el nacimiento actual no fallecio 
        else begin

            //LA PERSONA NO FALLECIO, DEJAR LOS CAMPOS NULOS O POR DEFECTO
            with regM do begin
                matrD := 'NONE';
                fecha.dia := -1;
                fecha.mes := -1;
                fecha.anio := -1;
                hora.horas := -1;
                hora.minutos := -1;
                lugar := 'NONE';
            end;
            //AVANZAR SOLO EN EL ARCHIVO DE NAC Y HASTA ENCONTRARSE EL NAC CORRESPONDIENTE AL DECESO MIN
            minimoNac(vec_nac,minNac);

        end;

        //Escribir el registro maestro al archivo maestro
        write(arc_mae,regM);

        //Exportar la informacion recopilada a un arc txt
        with regM do begin
            write(arc_txt,nroPartida,'      ',dni,'      ',dniM,'      ',dniP,'      ',fecha.dia,'      '
                    ,fecha.mes,'      ',fecha.anio,'      ',hora.horas,'     ',hora.minutos,'    '
                    ,dir.calle,'      ',dir.nro,'      ',dir.piso,'      ',dir.depto,'      '
                    ,lugar,'      ',matrD,'      ',matrN,'      ',nomM,'      '
                    ,nomP,'      ',nom,'      ',ape,'      ',apeM,'      ',apeP,'      ',dir.ciudad);
        end;

    end;


    //CERRADO DE ARCHIVOSSS
    close(arc_mae);
    close(arc_txt);
    for i := 1 to dimF do begin
        close(vec_arc_nac[i]);
        close(vec_arc_dec[i]);
    end;


end.