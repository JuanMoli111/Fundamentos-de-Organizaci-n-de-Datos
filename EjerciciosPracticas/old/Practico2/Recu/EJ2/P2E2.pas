program ej2;

///     PRECONDICIONES


    //  EXISTE UN ARCHIVO MAESTRO DE ALUMNOS

    //  EXISTE UN ARCHIVO DETALLE DE MATERIAS DE ALUMNOS

    //  PUEDE EXISTIR NINGUN, UNO, O MAS REGISTROS MATERIA POR CADA REGISTRO ALUMNO DEL ARCHIVO MAESTRO

const
    valorAlto = 9999;
type

    str22 = string[22];

    alumno = record
        cod, materiaCursadas, materiaFinales : integer;
        nombre, apellido: str22;
    end;

    materia_alumno = record
        codAlumno: integer;
        final : integer;
    end;    


    arc_bin_alumnos = file of alumno;
    arc_bin_materias = file of materia_alumno;

    arc_txt_alumnos = text;
    arc_txt_materias = text;

{procedure leerMaestro(var arc_bin: arc_bin_alumnos; var a : alumno);
begin
    if(not(eof(arc_bin))) then
        read(arc_bin,a)
    else
        a.cod := valorAlto;
end;}
procedure leerDetalle(var arc_bin: arc_bin_materias; var m : materia_alumno);
begin
    if(not(eof(arc_bin))) then
        read(arc_bin,m)
    else
        m.codAlumno := valorAlto;
end;
procedure CrearMaestroConTxt(var arc_bin: arc_bin_alumnos);
var
    arc_txt: arc_txt_alumnos;
    a: alumno;
begin
    //Crear archivo binario maestro
    rewrite(arc_bin);

    //Abrir el archivo txt para crear el maestro
    assign(arc_txt,'alumnos.txt');
    reset(arc_txt);

    //Mientras no se termine el txt
    while(not(eof(arc_txt))) do begin

        //Leer los campos del alumno de los datos del txt
        with a do read(arc_txt,cod,materiaCursadas,materiaFinales,nombre,apellido);
        
        //Cargar el alumno al archivo maestro
        write(arc_bin,a);

    end;

    //Cerrar los archivos
    close(arc_txt);
    close(arc_bin);

end;
procedure CrearDetalleConTxt(var arc_bin: arc_bin_materias);
var
    m : materia_alumno;
    arc_txt: arc_txt_materias;
begin
    //Crear archivo binario maestro
    rewrite(arc_bin);

    //Abrir el archivo txt para crear el maestro
    assign(arc_txt,'detalle.txt');
    reset(arc_txt);

    //Mientras no se termine el txt
    while(not(eof(arc_txt))) do begin

        //Leer los campos del alumno de los datos del txt
        with m do read(arc_txt,codAlumno,final);
        
        //Cargar el alumno al archivo maestro
        write(arc_bin,m);

    end;

    //Cerrar los archivos
    close(arc_txt);
    close(arc_bin);

end;
procedure CrearReporteMaestro(var arc_bin: arc_bin_alumnos);
var
    arc_txt: arc_txt_alumnos;
    a: alumno;
begin

    //Assign y crear archivo de texto para el reporte
    assign(arc_txt,'reporteAlumnos.txt');
    rewrite(arc_txt);

    //Abrir archivo maestro
    reset(arc_bin);

    while(not(eof(arc_bin))) do begin

        read(arc_bin,a);

        with a do write(arc_txt,cod,materiaCursadas,materiaFinales,nombre,apellido);
    end;

    close(arc_bin);
    close(arc_txt);

end;
procedure CrearReporteDetalle(var arc_bin: arc_bin_materias);
var
    arc_txt: arc_txt_alumnos;
    m: materia_alumno;
begin

    //Assign y crear archivo de texto para el reporte
    assign(arc_txt,'reporteDetalle.txt');
    rewrite(arc_txt);

    //Abrir archivo maestro
    reset(arc_bin);

    while(not(eof(arc_bin))) do begin

        read(arc_bin,m);

        with m do write(arc_txt,codAlumno,final);
    end;

    close(arc_bin);
    close(arc_txt);

end;
procedure ActualizarMaestro(var arc_bin_mae: arc_bin_alumnos; var arc_bin_det: arc_bin_materias);
var
    m: materia_alumno;
    a: alumno;

    codAct, cursadas, finales: integer;
begin

    reset(arc_bin_mae);
    reset(arc_bin_det);

    if(not(eof(arc_bin_mae))) then read(arc_bin_mae,a);


    leerDetalle(arc_bin_det,m);

    //Mientras no se termine el archivo detalle
    while(m.codAlumno <> valorAlto) do begin

        cursadas := 0;
        finales := 0;

        codAct := m.codAlumno;

        //Mientras el registro detalle corresponda al mismo alumno, totalizar sus datos
        while(codAct = m.codAlumno) do begin
            if(m.final <> 0) then
                finales += 1
            else
                cursadas += 1;

            leerDetalle(arc_bin_det,m);
        end;

        //Mientras el codigo del alumno a actualizar no se encuentre, avanzar en el maestro
        while(a.cod <> codAct) do begin
            read(arc_bin_mae,a);
        end;

        //Actualizar los datos del alumno 
        with a do begin
            materiaCursadas += cursadas;
            materiaFinales += finales;
        end;

        //Sobreescribir el alumno con los datos actualizados
        seek(arc_bin_mae,filepos(arc_bin_mae) - 1);
        write(arc_bin_mae,a);

        //Avanzar en el archivo maestro
        if(not(eof(arc_bin_mae))) then
            read(arc_bin_mae,a);
        
    end;

    close(arc_bin_mae);
    close(arc_bin_det);
end;
procedure ListarAlumnos(var arc_bin: arc_bin_alumnos);
var
    a: alumno;
    arc_txt: arc_txt_alumnos;
begin

    assign(arc_txt,'AlumnosMaterias.txt');
    rewrite(arc_txt);
    
    reset(arc_bin);

    while(not(eof(arc_bin))) do begin
        //Leer un alumno del archivo maestro
        read(arc_bin,a);

        //Si el alumno tiene mas de 4 cursadas sin aprobar final, escribir sus datos en el txt
        with a do if(materiaFinales - materiaCursadas > 4) then write(arc_txt,cod,'     ',materiaCursadas,'     ',materiaFinales,'      ',nombre,'      ',apellido); 
    end;

    close(arc_bin);
    close(arc_txt);
end;
var
    //Declara las variables archivos maestro y detalle
    arc_bin_maestro : arc_bin_alumnos;
    arc_bin_detalle : arc_bin_materias;

    opc : integer;

    nombre_arc : str22;
begin
    //Leer nombres para los arc maestro y detalle
    writeln('Ingrese nombre para el archivo maestro ');
    readln(nombre_arc);
    assign(arc_bin_maestro,nombre_arc);
    writeln('Ingrese nombre para el archivo detalle');
    readln(nombre_arc);
    assign(arc_bin_detalle,nombre_arc);

    //Display menu
    repeat
        writeln('Ingrese una opcion');
        writeln('1: Crear archivo maestro de alumnos');
        writeln('2: Crear el archivo detalle, de materias de alumnos');
        writeln('3: Listar el contenido del maestro en un reporte txt');
        writeln('4: Listar el contenido del detalle en un reporte txt');

        writeln('5: Actualizar el archivo maestro con los datos del detalle');
        writeln('6: Listar los datos de los alumnos que tengan mas de cuatro materias con cursada aprobada pero sin final');
        writeln('0: Salir');


        readln(opc);

        case opc of
            
            1:  CrearMaestroConTxt(arc_bin_maestro);
            
            2:  CrearDetalleConTxt(arc_bin_detalle);

            3:  CrearReporteMaestro(arc_bin_maestro);

            4:  CrearReporteDetalle(arc_bin_detalle);

            5:  ActualizarMaestro(arc_bin_maestro,arc_bin_detalle);

            6:  ListarAlumnos(arc_bin_maestro);

        end;

    until(opc = 0);

end.