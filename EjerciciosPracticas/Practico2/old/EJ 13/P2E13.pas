program P2E13;
const
    valorAlto = -999;
    cantE = 30;
type

    str15 = string[15];


    user_total= record
        cod, cantMail: integer;
        user, nombre, apellido: str15;
    end;

    user_daily = record
        cod, cuenta: integer;
        mensaje : string;
    end;


    arc_mae = file of user_total;
    arc_det = file of user_daily;


    vec_arc_det = array[1..cantE] of arc_det;

procedure leerMae(var arc : arc_mae; var dato : user_total);
begin
    if(not(eof(arc)))then
        read(arc,dato)
    else 
        dato.cod := valorAlto;
end;

procedure leerDet(var arc : arc_det; var dato : user_daily);
begin
    if(not(eof(arc)))then
        read(arc,dato)
    else 
        dato.cod := valorAlto;
end;

procedure ActualizarMaestro(var maestro: arc_mae; var detalle: arc_det);
var
    regm : user_total;
    regd, regAct: user_daily;
begin
    //Abrir los archivos
    reset(maestro);
    reset(detalle);

    //Leer el primer reg de cada arch
    leerMae(maestro,regm);
    leerDet(detalle,regd);


    //Mientras haya datos en el detalle
    while(regd.cod <> valorAlto)do begin 

        regAct := regd;


        //Iterar hasta que el cod del maestro sea igual al cod del dato a actualizar
        while(regd.cod <> regm.cod) do begin
            leerMae(maestro,regm);
        end;

        //Si (regd.cod = regm.cod) es true luego de la iteracion, aun hay datos y estamos apuntando al reg posterior al que debemos cambiar
        if(regd.cod = regm.cod) then begin

            //Vuelve un paso atras el puntero
            seek(maestro,filepos(maestro) - 1);
            
            //mientras el user sea el mismo, sumar mails en el registro maestro
            while(regd.cod = regAct.cod) do begin

                with regm do cantMail += 1;

                //Leer el siguiente registro detalle
                leerDet(detalle,regd);
            end;

            //Almacena el registro con la cantidad de mails actualizada
            write(maestro,regm);


        end;
        
    end;

    close(maestro);
    close(detalle);
end;

procedure generarTxt(var detalle: arc_det; var arc_txt: text);
var 
    strArch : str15;
    regd: user_daily;
    cantMail, codAct : integer;
    
begin
    //Nombrar el txt
    writeln('Ingrese un nombre para el txt a generar');
    readln(strArch);
    assign(arc_txt,strArch);

    //Abrir el detalle, crear y abrir el txt
    reset(detalle);
    rewrite(arc_txt);

    //Leer el primer registro del archivo detalle
    leerDet(detalle,regd);

    //Mientras haya datos en el archivo detalle
    while(regd.cod <> valorAlto) do begin

        //Actualizar codigo actual
        codAct := regd.cod;

        //Inicializar o reiniciar el contador de mails por usuario
        cantMail := 0;

        //Mientras el registro corresponda al mismo usuario...
        while(regd.cod = codAct) do begin
            //Incremente la cant de mails a almacenar en el txt
            cantMail += 1;

            //Leer siguiente registro
            leerDet(detalle,regd);
        end;

        //Almacenar la informacion con el formato pedido
        write(arc_txt,regd.cod,'........',cantMail);

    end;

    //Cerrar los archivos
    close(detalle);
    close(arc_Txt);

end;
//DECLARACION DE VARIABLES
var
    maestro : arc_mae;

    vec_detalles : vec_arc_det;

    arc_text : text;

    i, dia: integer;

    strIndice: string;

    //PROGRAMA PRINCIPAL
begin

    //Assign del maestro    
    assign(maestro,'mae');

    //Assign de los archivos detalle
    for i := 1 to cantE do begin
        Str(i,strIndice);

        assign(vec_detalles[i],'det'+strindice);
    end;

    //Assign del archivo text
    assign(arc_text,'arcTxt');


    writeln('Ingrese un dia del 1 al 30, se actualizara la informacion del archivo maestro con los datos del dia, y se generara un txt con la cantidad de mail enviados por cada user');
    writeln('Ingrese cero para salir');
    writeln;
    readln(dia);

    while(dia <> 0) do begin

        ActualizarMaestro(maestro,vec_detalles[dia]);

        generarTxt(vec_detalles[dia],arc_text);

        writeln('Ingrese un dia del 1 al 30, se actualizara la informacion del archivo maestro con los datos del dia, y se generara un txt con la cantidad de mail enviados por cada user');
        writeln('Ingrese cero para salir');
        writeln;
        readln(dia);
    end;


end.