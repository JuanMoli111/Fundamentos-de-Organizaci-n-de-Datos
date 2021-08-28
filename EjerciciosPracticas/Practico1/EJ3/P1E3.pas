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
1
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

var
    opc: integer;
    arc: arc_emp;

    
begin


    //Display menu
    repeat
        writeln('Ingrese una opcion');
        writeln('1: Crear archivo de empleados');
        writeln('2: Listar informacion');
        writeln('0: Salir');


        readln(opc);

        case opc of
            
            1:  CrearArcEmpleados(arc);
            
            2:  ListarInformacion(arc);
        end;

    until(opc = 0);





end.