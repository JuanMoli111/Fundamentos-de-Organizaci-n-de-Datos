//Se dispone de un archivo con informacion de los alumnos de la facultad de informatica. Por cada
//alumno se dispone de su codigo de alumno, apellido, nombre, cantidad de mateirias (cursadas) aprobadas
//sin final y cantidad de materias con final aprobado. Ademas, se tiene un archivo detalle con el codigo 
//de alumno e informacion correspondiente a una materia (esta info indica si aprobo la cursada o aprobo el final)

//Todos los archivos estan ordenados por codigo de alumno y en el archivo detalle puede haber 0, 1 o mas registros
//para cada alumno del archivo maestro. Se pide realizar un programa con opciones para:

//  a)  Crear el archivo maestro a partir de un archivo de texto llamado alumnos.txt
//  b)  Crear el archivo detalle a partir de un archivo de texto llamado detalle.txt
//  c)  Listar el contenido del archivo detalle en un archivo de texto llamado reporteAlumnos.txt
//  d)  Listar el contenido del archivo detalle en un archivo de texto llamado reporteDetalle.txt
//  e)  Actualizar el archivo maestro de la siguiente manera
//      
//      i) Si aprobó el final se incrementa en uno la cantidad de materia con final aprobado
//      ii) Si aprobo la cursada se incrementa en uno la cantidad de materias aprobadas sin final

//  f)  Listar en un archivo de texto los alumnos que tengan más de cuatro materias con cursada
//      aprobada pero no aprobaron el final. Deben listarse todos los campos
//
//  NOTA: Para la actualizacion del inciso e) los archivos deben ser recorridos una sola vez

program P2E2;

const
    valorAlto = -9999;

type

    str15 = string[15];

    //Registro alumno, cursadas representa las materias con cursada aprobada sin final, el campo finales
    //representa las materias con finales aprobados, estos conjuntos son disjuntos

    alumno = record
        cod : integer;
        apellido: str15;
        nombre : str15;
        cursadas : integer;
        finales : integer;
    end;

    //info_materia es un registro que representa informacion sobre la materia que cursó un alumno
    //cod es el codigo de alumno, final es un booleano si es TRUE el alumno aprobó el final si es FALSE el alumno solo aprobó la cursada

    info_materia = record
        cod : integer;
        final : integer;
    end;


    //Archivo de alumnos, este sera nustro archivo maestro a modificar
    arc_alumnos = file of alumno;

    //Archivo de informacion de materias, será nuestro archivo detalle con info de las cursadas de los alumnos
    arc_info_materias = file of info_materia;

//Lee el siguiente dato de un archivo y lo retorna en dato, si llegó al EOF retorna el valor de corte
procedure leerAlumnos(var arc_al : arc_alumnos; var dato: alumno);
begin
    if(not(eof(arc_al))) then
        read(arc_al,dato)
    else
        dato.cod := valorAlto;
end;
procedure leerInfo(var arc_info : arc_info_materias; var dato: info_materia);
begin
    if(not(eof(arc_info))) then
        read(arc_info,dato)
    else
        dato.cod := valorAlto;
end;
//INCISO A: crear el archivo MAESTRO a partir de un archivo de texto llamado alumnos.txt
procedure generarArcBinarioMaestroDesdeTxt(var arc_logico: arc_alumnos; var arcTxt: text);
var
    arc_fisico : string[16];
    a: alumno;
begin
    writeln('Ingrese nombre del archivo');  //Leer el nombre que va a tener el archivo binario
    readln(arc_fisico);

    assign(arc_logico,arc_fisico);          //Linkear archivo logico con arc_fisico

    rewrite(arc_logico);                    //Crear el archivo binario y abrirlo

    assign(arcTxt,'alumnos.txt');           //Linkear el archivo txt logico con el nombre alumnos.txt
    reset(arcTxt);                          //Abrir el archivo txt

    //Mientras no alcance el EOF del archivo de texto
    while(not(eof(arcTxt))) do begin

        //Leer los campos del alumno, del archivo de texto
        with a do
            read(arcTxt,cod,apellido,nombre,cursadas,finales);

        //Escribir en el archivo binario el alumno del archivo de texto
        write(arc_logico,a);
    end;

    writeln('Done');
    //Cerrar los archivos
    close(arc_logico);
    close(arcTxt);

end;

//INCISO B: crear el archivo detalle a paratir de un archivo de texto llamado detalle.txt
procedure generarArcBinarioDetalleDesdeTxt(var arc_logico: arc_info_materias; var arcTxt: text);
var
    arc_fisico : string[16];
    info: info_materia;
begin
    writeln('Ingrese nombre del archivo');  //Leer el nombre que va a tener el archivo binario
    readln(arc_fisico);

    assign(arc_logico,arc_fisico);          //Linkear archivo logico con arc_fisico

    rewrite(arc_logico);                    //Crear el archivo binario y abrirlo

    assign(arcTxt,'detalle.txt');           //Linkear el archivo txt logico con el nombre detalle.txt
    reset(arcTxt);                          //Abrir el archivo txt

    //Mientras no alcance el EOF del archivo de texto
    while(not(eof(arcTxt))) do begin

        //Leer los campos de la info de la materia, del archivo de texto
        with info do readln(arcTxt,cod,final);

        //Escribir en el archivo binario la info de la materia del archivo de texto
        
        write(arc_logico,info);
    end;

    writeln('Done');
    //Cerrar los archivos
    close(arc_logico);
    close(arcTxt);

end;


//INCISO C: crear un archivo de txt llamado reporteAlumnos listando el contenido del archivo maestro
procedure generarTxtReporteMaestro(var arc_logico: arc_alumnos);
var
    a: alumno;
    arcTxt: text;
begin
    //Abrir el archivo logico, binario maestro con info de los alumnos
    reset(arc_logico);

    //Asignar al nuevo archivo de texto su nombre fisico "reporteAlumnos.txt"
    assign(arcTxt,'reporteAlumnos.txt');
    
    //Crea y abre el archivo de texto creado
    rewrite(arcTxt);

    //Formato de lista.
    writeln(arcTxt,'    cod     Apellido    Nombre      Cursadas     Finales');


    //Mientras no llegemos al final del archivo logico
    while(not (eof(arc_logico))) do begin
        
        //Leer el siguiente alumno del archivo logico
        read(arc_logico,a);

        //Escribir en el txt los datos de los campos del alumno leido
        with a do
            writeln(arcTxt,'   ',cod,'   ',apellido ,'   ',nombre,'   ',cursadas,'   ',finales);

    end;
    //Cerrar los archivos
    close(arc_logico);
    close(arcTxt);
end;

//INCISO D: crear un archivo de txt llamado reporteDetalle listando el contenido del archivo detalle
procedure generarTxtReporteDetalle(var arc_logico: arc_info_materias);
var
    info: info_materia;
    arcTxt: text;
begin
    //Abrir el archivo logico, binario detalle con info de las materias aprobadas por alumnos
    reset(arc_logico);

    //Asignar al nuevo archivo de texto su nombre fisico "reporteDetalle.txt"
    assign(arcTxt,'reporteDetalle.txt');
    
    //Crea y abre el archivo de texto creado
    rewrite(arcTxt);

    //Formato de lista
    writeln(arcTxt,'    cod     Final');

    //Mientras no llegemos al final del archivo logico
    while(not(eof(arc_logico))) do begin
        
        //Leer la siguiente info_materia del archivo logico
        read(arc_logico,info);

        //Escribir en el txt los datos de los campos de la info_materia leida
        with info do
            writeln(arcTxt,'   ',cod,'   ',final);

    end;
    //Cerrar los archivos
    close(arc_logico);
    close(arcTxt);
end;

//Inciso e)     Actualiza la informacion de alumnos del archivo maestro con los datos de las materias aprobadas del archivo detalle
procedure actualizarArchivoMaestro(var arc_mae: arc_alumnos; var arc_det: arc_info_materias);
var 
    //Declara registros auxiliares para mover informacion
    a : alumno;
    info : info_materia;
    //Contadores para almacenar las cursadas y finales, que luego sumaremos en el archivo maestro
    codact, contCursadas, contFinales: integer;

begin
    //Abrir los archivos maestro y detalle
    reset(arc_mae);
    reset(arc_det);

    //Lee el primer registro del archivo detalle
    leerInfo(arc_det,info);
    //Lee el primer registro del archivo maestro
    leerAlumnos(arc_mae,a);

    //Mientras el cod sea valorAlto significa q aun hay registros en el archivo detalle
    while(info.cod <> valorAlto) do begin

        //Actualizar codigo actual cada vez que entra un alumno nuevo
        codact := info.cod;

        //Inicializar contadores cada vez q entra un alumno nuevo
        contCursadas := 0;
        contFinales := 0;

        //Mientras el codigo de los registros detalle siga siendo el mismo, significa que hay mas materias por cargar al total
        while(info.cod = codact) do begin

            //Si final es TRUE Agrega un final aprobado al contador, si no es TRUE agrega una cursada aprobada al contador
            if(info.final = 1) then
                contFinales += 1
            else
                contCursadas += 1;

            //Lee el siguiente registro
            leerInfo(arc_det,info);
        end;

        //Salio del while por que cambió de alumno en el arc detalle, necesitamos asegurarnos que se lea del maestro el alumno a modificar
        //para esto itera hasta que se lea el alumno con el codigo actual (el alumno del q se acaba de contabilizar sus datos)
        while(codact <> a.cod)do
            read(arc_mae,a);

        //suma en el registro alumno, las cursadas y finales contabilizados 
        with a do begin
            cursadas += contCursadas;
            finales += contFinales;
        end;

        //El read dejó el archivo maestro en el siguiente alumno, vuelve una posición hacia atrás antes de cargar el alumno actualizado
        seek(arc_mae,filepos(arc_mae) - 1);

        //Almacena el alumno actualizado
        write(arc_mae,a);
    end;

    //Cerrar archivos
    close(arc_mae);
    close(arc_det);
end;

//Inciso f)     Listar en un txt los alumnos que tengan mas de cuatro materias con cursada pero no aprobaron el final. Listar todos los campos
procedure listarAlumnosEnTxt(var arc_logico: arc_alumnos);
var
    arcTxt: text;
    a   : alumno;
begin
    //Abrir el archivo logico, binario con info de las materias aprobadas por alumnos
    reset(arc_logico);

    //Asignar al nuevo archivo de texto su nombre fisico "reporteDetalle.txt"
    assign(arcTxt,'reporteAlumnosINCISOF.txt');
    
    //Crea y abre el archivo de texto creado
    rewrite(arcTxt);

    //Formato de lista.
    writeln(arcTxt,'    cod     Apellido    Nombre      Cursadas     Finales');


    //Mientras no llegemos al final del archivo logico
    while(not (eof(arc_logico))) do begin
        
        //Leer el siguiente alumno del archivo logico
        read(arc_logico,a);

        //Escribir en el txt los datos de los campos de la info_materia leida, solo si el alumno tiene mas de 4 cursadas aprobadas sin final aprobado
        if((a.cursadas - 4) > a.finales) then begin
            with a do
                writeln(arcTxt,'   ',cod,'   ',apellido ,'   ',nombre,'   ',cursadas,'   ',finales);
        end;
    end;


    //Cerrar los archivos
    close(arc_logico);
    close(arcTxt);

end;


var
    //Declarar nombres logicos de los archivos maestro y detalle
    arc_mae : arc_alumnos;
    arc_det : arc_info_materias;

    arc_mae_txt, arc_det_txt : text;
    //Declarar un registro de tipo alumno, auxiliar util para mover los datos
    reg_alu : alumno;
    opc : integer;
begin

    repeat
        //Display de las opciones
        writeln('Opciones:');
        writeln('1: Crear archivo maestro de alumnos en base al txt "alumnos"');
        writeln('2: Crear archivo detalle de info de las materias en base al txt "detalle"');
        writeln('3: Listar el archivo binario maestro a un txt');
        writeln('4: Listar el archivo binario detalle a un txt');
        writeln('5: Actualizar el archivo maestro con las materias de los alumnos, del archivo detalle');
        writeln('6: Listar en un txt los alumnos con mas de 4 materias con cursada aprobada sin final aprobado');


        writeln('0: QUIT');
        writeln('\nIngrese una opcion');
        readln(opc);

        case opc of
            1:  generarArcBinarioMaestroDesdeTxt(arc_mae,arc_mae_txt);

            2:  generarArcBinarioDetalleDesdeTxt(arc_det,arc_det_txt);

            3:  generarTxtReporteMaestro(arc_mae);

            4:  generarTxtReporteDetalle(arc_det);

            5:  actualizarArchivoMaestro(arc_mae,arc_det);

            6:  listarAlumnosEnTxt(arc_mae);

        end;
    until(opc = 0);

end.