program P2E13;
const
    valorAlto = 19997;
type

    str20 = string[20];


    log_maestro = record
        nro_user, cant_mails: integer;
        nombre_user, nombre, apellido: str20;
    end;

    log_detalle = record
        nro_user, cuenta_destino: integer;
        mensaje : string[200];
    end;


    archivo_maestro = file of log_maestro;
    archivo_detalle = file of log_detalle;

procedure leer(var det: archivo_detalle; var dato: log_detalle);
begin
    if(not(EOF(det))) then
        read(det,dato)
    else
        dato.nro_user := valorAlto;

end;
procedure leerMae(var mae: archivo_maestro; var dato: log_maestro);
begin
    if(not(EOF(mae))) then
        read(mae,dato)
    else
        dato.nro_user := valorAlto;

end;


//Crear el archivo maestro en base a un txt, este procedure lo cree para generar los archivos a mano y hacer tests
procedure crearMaestro(var mae: archivo_maestro);
var
    txt: text;
    regm: log_maestro;
begin

    Assign(txt,'maestro.txt');
    Reset(txt);

    Rewrite(mae);


    while(not(EOF(txt))) do begin
        with regm do ReadLn(txt,nro_user,cant_mails,nombre_user,nombre,apellido);
        write(mae,regm);
    end;

    close(mae);
    close(txt);
end;

//Crear el archivo detalle en base a un txt, este procedure lo cree para generar los archivos a mano y hacer tests
procedure crearDetalle(var det: archivo_detalle);
var
    txt: text;
    regd: log_detalle;
begin

    Assign(txt,'detalle.txt');
    Reset(txt);

    Rewrite(det);


    while(not(EOF(txt))) do begin
        with regd do ReadLn(txt,nro_user,cuenta_destino,mensaje);
        write(det,regd);
    end;

    close(det);
    close(txt);
end;
procedure actualizar(var mae: archivo_maestro; var det: archivo_detalle);
var
    regm: log_maestro;
    regd : log_detalle;

    userAct : integer;
begin
    //Abrir archivos maestro y detalle
    Reset(mae);
    Reset(det);

    //Leer primer registro detalle
    leer(det,regd);

    //Si hay registros detalles, leer primer registro maestro
    if(regd.nro_user <> valorAlto) then read(mae,regm);


    //Mientras haya registros detalle
    while(regd.nro_user <> valorAlto) do begin
      
        //Salvar el numero de user actual
        userAct := regd.nro_user;

        //Leer regm hasta que encuentre el registro con el mismo nro de user que el reg detalle
        while(regm.nro_user <> userAct) do read(mae,regm);

        //Mientras el regd sea del mismo user, incrementar la cant de mails, leer siguiente registro
        while(regd.nro_user = userAct) do begin
            regm.cant_mails += 1;
            leer(det,regd);
        end;

        //Actualizar Archivo
        seek(mae,FilePos(mae) - 1);
        write(mae,regm);

        //Si aun hay reg detalles, leer un registro maestro (seguro existe)
        if(regd.nro_user <> valorAlto) then read(mae,regm);

    end;    

    ///Cerrar archivos
    close(mae);
    close(det);

end;

//Recibe un detalle y genera un informe en un archivo de texto que totaliza la cantitad de mails enviados por usuario,
//Segun el enunciado todos los users del sistema deben estar en el listado, por lo que debemos 
//recorrer el archivo maestro, listando los users que no aparezcan en el archivo detalle con su cantidad de mails en cero
procedure informe(var mae: archivo_maestro; var det: archivo_detalle);
var
    regd: log_detalle;
    regm: log_maestro;
    userAct, cantMails : integer;

    arc_txt: text;
begin
    //Assign y creacion del archivo de texto
    Assign(arc_txt,'informe.txt');
    Rewrite(arc_txt);
  
    //Abrir archivo detalle y maestro
    Reset(det);
    Reset(mae);

    //Leer primer registro detalle
    leerMae(mae,regm);

    //Si hay registros detalle, leer primer registro maestro
    if(regm.nro_user <> valorAlto) then leer(det,regd);

    //Mientras haya registros detalle
    while(regm.nro_user <> valorAlto) do begin
    
        //Salvar el reg maestro actual
        userAct := regd.nro_user;
        cantMails := 0;

        //Mientras no encuentre un detalle con mismo nro user, listar los users q no enviaron ningun mail
        while(regm.nro_user <> regd.nro_user) do begin
            WriteLn(arc_txt,regm.nro_user,'  ',0);
            leerMae(mae,regm);

        end;

        //Mientras sean regd del mismo user, contabilizar los mails
        while((regd.nro_user <> valorAlto) and (userAct = regd.nro_user)) do begin
          
            cantMails += 1;

            leer(det,regd);
            
        end;    

        //Listar al txt solo si no es valorAlto (sin este if, la ultima iteracion escribe en el txt, dato con el cod valorAlto)
        if(regm.nro_user <> valorAlto) then WriteLn(arc_txt,regm.nro_user,'  ',cantMails);

        //Avanzar en el maestro.
        leerMae(mae,regm);

    end;

    //Cerrar archivos
    close(det);
    close(arc_txt);
end;
var
    arc_mae: archivo_maestro;
    arc_det: archivo_detalle;


begin
  
    Assign(arc_mae,'mae-binario');
    Assign(arc_det,'det-binario');

    //Cargar archivos binarios desde un txt
    crearMaestro(arc_mae);
    crearDetalle(arc_det);


    informe(arc_mae,arc_det);


end.