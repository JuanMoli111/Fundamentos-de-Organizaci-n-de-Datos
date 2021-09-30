program ej13;
{
                PRECONDICIONES

        *   1- EXISTE UN ARCHIVO MAESTRO DE LOGS EN EL SERVIDOR

        *   2- EL ARCHIVO MAESTRO ESTA UBICADO EN LA RUTA /var/log/logmail.dat

        *   3- SE RECIBE UN ARCHIVO DETALLE CON LOS MAILS ENVIADOS EN EL DIA

        *   4- DEBE ACTUALIZARSE LOS USUARIOS DEL ARCH MAESTRO CON LA INFORMACION DEL ARCH DETALLE

        *   5- LOS ARCHIVOS ESTAN ORDENADOS POR NUMERO DE USUARIO

        *   6- UN USUARIO PUEDE ENVIAR 0 O N MAILS POR DIA
}
const
    valorAlto = 9999;
type
    str25 = string[25];


    //Registro que representa los movimientos de un user
    log = record
        nro, cantMail : integer;
        username, nombre, apellido: str25;
    end;

    //Este registro representa un mail enviado
    mail = record
        nro_user, nro_destino: str25;
        cuerpoMensaje: string[400];
    end;

    //Tipo archivo maestro
    arc_log = file of log;

    //Tipo archivo detalle
    arc_mail = file of mail;


procedure leerDet(var det : arc_mail; var dato : mail);
begin
    if(not(eof(det))) then
        read(det,dato)
    else
        dato.nro_user := valorAlto;
end;

procedure leerMae(var mae : arc_log; var dato : log);
begin
    if(not(eof(mae))) then
        read(mae,dato)
    else
        dato.nro_user := valorAlto;
end;

//PROCEDIMIENTO DE ACTUALIZACION DE ARCHIVO MAESTRO
{
    recibe un archivo maestro a actualizar y un detalle con informacion de los 
    mails enviados en el dia, actualiza los mails totales enviados por cada
    usuario
}
procedure ActualizarMaestro(var mae: arc_log; var det: arc_mail);
var
    correo : mail;
    regm : log;

    nroAct, totMail: integer;
begin

    //Abrir archivos
    reset(mae);
    reset(det);

    //Leer primer registro detalle
    leerDet(det,correo);

    //Si hay registros detalle leer un registro maestro
    if(correo.nro_user <> valorAlto) then read(mae,regm);

    //Mientras haya registros detalle...
    while(correo.nro_user <> valorAlto) do begin

        //Inicializar contador de mail y variable de control 
        totMail := 0;
        nroAct := correo.nro_user;

        //Mientras el registro sea del mismo usuario, contabilizar los mails que envio
        while(nroAct = correo.nro_user) do begin
            totMail += 1;
            leerDet(det,correo);
        end;

        //Leer el maestro hasta encontrar el registro correspondiente a este usuario
        while(nroAct <> regm.nro_user) do read(mae,regm);


        //Actualizar la cantidad de mails enviados por el usuario
        regm.cantMail += totMail;

        //Posicionarse en el registro a actualizar 
        seek(mae,FilePos(mae) - 1);

        //Sobreescribir el archivo con el registro actualizado
        write(mae,regm);


        //Leer siguiente registro maestro
        if(not(eof(mae))) then read(mae,regm);

    end;

    //Cerrar archivos
    close(mae);
    close(det);
end;


//PROCEDIMIENTO GENERAR INFORME EN TXT
{
    recibe un archivo detalle y genera un archivo de texto con un reporte
    de todos los usuarios con su cantidad de mails enviados en un dia

    en el listado deben aparecer TODOS los usuarios que existen en el sistema
    razon de que deba recorrerse el maestro para listar todos los usuarios
    pero solo debe informar los mails enviados en el dia (info del detalle)
}
procedure GenerarInforme(var mae: arc_log; var det: arc_mail);
var
    texto : text;

    nroAct, totMail : integer;

    regm: log;
    regd: mail;
begin
    
    //Assign y crear archivo de texto
    assign(texto,'informe.txt');
    rewrite(texto);


    //Abrir archivos binarios
    reset(mae);
    reset(det);


    //Leer primer registro de los archivos
    leerMae(mae,regm);
    leerDet(det,regd);


    //DEBO RECORRER TODO EL ARCHIVO MAESTRO, RECORRIENDO EN "SEGUNDO PLANO" (CICLO INTERNO) EL REGISTRO DETALLE.
    //PARA AQUELLOS REGISTROS MAESTRO SIN CORRESPONDIENTE EN EL DETALLE, SIGNIFICA QUE NO ENVIARON MAILS EN
    //ESE DIA, DEBEMOS INFORMAR SU NRO DE USUARIO Y CERO MENSAJES ENVIADOS, PARA LOS REGISTROS MAESTRO
    //QUE POSEAN REGISTROS DETALLE CORRESPONDIENTES, DEBE CONTABILIZARSE SUS MAILS Y LISTARLOS

    //Mientras existan registros maestro
    while(regm.nro_user <> valorAlto) do begin

        //El nro actual el registro detalle
        nroAct := regd.nro_user;
        totMail := 0;

        //Hasta que no encuentre el reg maestro correspondiente al detalle leido, listar users con cero mails
        while(nroAct <> regm.nro_user) do begin
            writeln(texto,regm.nro_user,'        ',totMail);
            leerMae(mae,regm);
        end;


        //Al salir, o bien encontro el reg maestro correspondiente, o se acabaron los registros detalle
        //entonces totalizar los mails de este registro user a no ser que sea un registro con valor de corte
        

        //Si el nro es valorAlto, habra informado los ultimos reg maestro que quedban en el while anterior
        //y ya no hay registros por informar entonces no procesaremos reg detalle
        if(regd.nro_user <> valorAlto) then begin


            //Mientras el reg detalle corresponda al mismo user, totalizar sus mails
            while(nroAct = regd.nro_user) do begin
                totMail += 1;
                leerDet(det,regd);
            end;
            
            //Listar el total para este usuario
            writeln(texto,nroAct,'        ',totMail);


            //Leer siguiente registro maestro pues ya procesamos este usuario recorriendo el archivo detalle, 
            //pero en el maestro seguimos apuntando al mismo user y no debe volver a procesarse en el while de la linea 167
            leerMae(mae,regm);
        end;

    end;


    //CERRAR ARCHIVOS
    close(mae);
    close(det);
    close(texto);
end;

var
    maestro: arc_log;
    detalle: arc_mail;


begin

    //Assign de los archivos maestro de logs y detalle de mails enviados en el dia
    assign(maestro,'maestro');
    assign(detalle,'detalleDia');


    //Llamar a los procedimientos correspondientes

    ActualizarMaestro(maestro,detalle);

    GenerarInforme(maestro,detalle);
end.