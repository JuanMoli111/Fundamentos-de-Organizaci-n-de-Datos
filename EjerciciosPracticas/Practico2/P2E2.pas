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
        final : boolean;
    end;


    //Archivo de alumnos, este sera nustro archivo maestro a modificar
    arc_alumnos = file of alumno;

    //Archivo de informacion de materias, será nuestro archivo detalle con info de las cursadas de los alumnos
    arc_info_materias = file of info_materia;

//Lee el siguiente dato de un archivo y lo retorna en dato, si llegó al EOF retorna el valor de corte
procedure leer(var arc_al : arc_alumnos; var dato: alumno);
begin
    if(not(eof(arc_al))) then
        read(arc_al,dato)
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
        with info do
            read(arcTxt,cod,final);

        //Escribir en el archivo binario la info de la materia del archivo de texto
        write(arc_logico,info);
    end;

    writeln('Done');
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
        writeln('3: Listar celulares con string ingresado por usuario');
        writeln('4: Crear un nuevo txt con distinto formato, desde el archivo binario,');
        {writeln('5: A�adir uno o mas celulares al final de archivo');
        writeln('6: Modificar el stock de un celular');
        writeln('7: Exportar desde el binario, a un archivo de texto, los celulares sin stock');}


        writeln('0: QUIT');
        writeln('\nIngrese una opcion');
        readln(opc);

        case opc of
            1:  generarArcBinarioMaestroDesdeTxt(arc_mae,arc_mae_txt);

            2:  generarArcBinarioDetalleDesdeTxt(arc_det,arc_detalle_txt);

            {3:  celusConString(arc_logico);

            4:  exportBinToTxt(arc_logico)}
        end;
    until(opc = 0);

end.