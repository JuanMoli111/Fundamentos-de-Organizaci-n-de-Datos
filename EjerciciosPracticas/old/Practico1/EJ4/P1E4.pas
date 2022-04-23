program ej3;
type

    str22 = string[22];

    emp = record
        nro: integer;
        lastname: str22;
        nombre : str22;
        edad: integer;
        dni : integer;
    end;


    arc_emp = file of emp;

procedure leerEmpleado(var e: emp);
begin
    with e do begin
        writeln('Ingrese el apellido del empleado');     readln(lastname);

        if(lastname <> 'fin') then begin

            writeln('Ingrese el nombre del empleado');    readln(nombre);
            writeln('Ingrese el numero de empleado');    readln(nro);
            writeln('Ingrese el dni del empleado');    readln(dni);
            writeln('Ingrese la edad del empleado');    readln(edad);

        end;

    end;
end;

procedure CrearArcEmpleados(var arc: arc_emp);
var
    e: emp;
    arc_name: str22;
begin
    //Solicitar nombre del archivo al user
    writeln('Ingrese el nombre de un archivo de empleados a crear');
    readln(arc_name);

    //Declaramos la conexion arc logico-fisico
    assign(arc,arc_name);

    //Crear el archivo
    rewrite(arc);    


    leerEmpleado(e);

    while(e.lastname <> 'fin') do begin

        write(arc,e);
        leerEmpleado(e);
    end;

    close(arc);
end;

procedure ListarInformacion(var arc: arc_emp);
var
    e: emp;
    str: str22;
begin

    writeln('Ingrese un nombre o apellido, se listaran los empleados que tengan este nombre o apellido');

    readln(str);

    reset(arc);

    while(not(EOF(arc))) do begin

        read(arc,e);

        if((e.nombre = str) or (e.lastname = str)) then begin
            with e do begin
                writeln('Nro de emp: ', nro);
                writeln('Nombre: ', nombre);
                writeln('Apellido: ',lastname);
                writeln('dni:   ', dni);
                writeln('edad:   ', edad);
            end;
        end;

    end;

    close(arc);

    reset(arc);

    while(not(eof(arc))) do begin

        read(arc,e);

        with e do writeln('Nombre: ',nombre,'   Apellido: ',lastname,'  dni: ',dni,'    nro de emp: ', nro,'    edad: ',edad);

    end;

    close(arc);

    reset(arc);

    writeln;
    writeln('A continuacion un listado de los empleados mayores a 70 años');

    while(not(eof(arc))) do begin
        read(arc,e);

        if(e.edad > 70) then begin
            with e do writeln('Nombre: ',nombre,'   Apellido: ',lastname,'  dni: ',dni,'    nro de emp: ', nro,'    edad: ',edad);
        end;
    end;

    close(arc);
end;

procedure AgregarEmpleados(var arc: arc_emp);
var
    e: emp;

begin
    //Abrir achivo
    reset(arc);

    //Posicionarse en la ultima posicion del archivo
    seek(arc,FilePos(arc));


    //Leer un empleado nuevo
    leerEmpleado(e);

    //Hasta que se ingrese el apellido fin, escribir el empleado al archivo y leer un nuevo empleado
    while(e.lastname <> 'fin') do begin
        write(arc,e);
        leerEmpleado(e);
    end;

    //Cerrar archivo
    close(arc);
end;

procedure ModificarEdad(var arc: arc_emp);
var
    num: integer;
    e: emp;
    encontro: boolean;
begin

    writeln('Ingrese un numero de empleado a cambiar su edad, ingrese -1 para salir');
    readln(num);


    while(num <> -1) do begin

        //Abrir el archivo, encontro es false
        reset(arc);
        encontro := false;

        //Recorrer el archivo hasta que se termine o hasta que encontro sea TRUE
        while(not(eof(arc)) and (encontro = false)) do begin

            //Leer un empleado del archivo
            read(arc,e);

            //Si el empleado leido es el que debe ser modificado...
            if(num = e.nro) then begin
                encontro := true;

                //Dirigirse a la pos del archivo donde esta almacenado el empleado a modificar
                seek(arc,filepos(arc) - 1);
                
                //Leer nueva edad
                writeln('Ingrese la edad modificada del empleado nro: ',e.nro);
                readln(e.edad);

                //Sobreescribir el dato con el empleado actualizado
                write(arc,e);
            end;


        end;
        close(arc);

        //Ingresar un nuevo numero de empleado
        writeln('Ingrese un numero de empleado a cambiar su edad, ingrese -1 para salir');
        readln(num);
    end;

end;
procedure ConvertirBinarioTexto(var arc_bin: arc_emp; var arc_txt: text);
var
    e: emp;
begin

    //Abrir el archivo binario de empleados
    reset(arc_bin);
    //Crear el archivo de texto
    rewrite(arc_txt);

    while(not(eof(arc_bin))) do begin

        read(arc_bin,e);

        with e do writeln(arc_txt,'     ',nro,'     ',lastname,'        ',nombre,'      ',edad,'       ',dni);


    end;

    close(arc_bin);
    close(arc_txt);
end;
procedure exportarSinDNI(var arc_bin: arc_emp;var arc_txt: text);
var
    e: emp;
begin

    reset(arc_bin);

    rewrite(arc_txt);

    while(not(eof(arc_bin))) do begin
        //Leer un empleado del archivo binario
        read(arc_bin,e);

        //Si el dni es 00 escribir los datos del empleado en el arc txt
        with e do if(dni = 00) then writeln(arc_txt,'     ',nro,'     ',lastname,'        ',nombre,'      ',edad,'       ',dni);

    end;

    close(arc_bin);
    close(arc_txt);

end;

var
    opc: integer;
    arc_bin: arc_emp;

    arc_txt, arc_txt_sin_dni: text;
begin

    assign(arc_txt,'todos_empleados.txt');
    assign(arc_txt_sin_dni,'faltaDNIEmpleado.txt');

    //Display menu
    repeat
        writeln('Ingrese una opcion');
        writeln('1: Crear archivo de empleados');
        writeln('2: Listar informacion');
        writeln('3: Agregar uno o mas empleados');
        writeln('4: Modificar edad a uno o mas empleados');
        writeln('5: Exportar contenido a un archivo de texto');
        writeln('6: Exportar a un archivo de texto los empleados que no hayan cargado su DNI');
        writeln('0: Salir');


        readln(opc);

        case opc of
            
            1:  CrearArcEmpleados(arc_bin);
            
            2:  ListarInformacion(arc_bin);

            3:  AgregarEmpleados(arc_bin);

            4:  ModificarEdad(arc_bin);

            5:  ConvertirBinarioTexto(arc_bin,arc_txt);

            6:  exportarSinDNI(arc_bin,arc_txt_sin_dni);

        end;

    until(opc = 0);

end.