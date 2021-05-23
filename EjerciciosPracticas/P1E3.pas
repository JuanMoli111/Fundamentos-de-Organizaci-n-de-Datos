program P1E3;
type

    empleado = record
        nro: integer;
        apellido: string[15];
        nombre: string[15];
        edad: integer;
        dni: longint;
    end;

    archivo = file of empleado;

procedure leerEmpleado(var e: empleado);
begin
    writeln('Ingrese el apellido');
    readln(e.apellido);
    if(e.apellido <> 'fin') then begin
        writeln('Ingrese numero de empleado ');
        readln(e.nro);
        writeln('Ingrese nombre del empleado');
        readln(e.nombre);
        writeln('Ingrese la edad del empleado');
        readln(e.edad);
        writeln('Ingrese el dni del empleado');
        readln(e.dni);
    end;
end;

procedure generar_archivo(var arc_logico : archivo);
var
    e: empleado;
    arc_fisico: string[16];
begin
    writeln('Ingrese un nombre para el archivo a crear');
    readln(arc_fisico);

    //Asignar arc logico al fisico
    assign(arc_logico,arc_fisico);
    //Crear archivo
    rewrite(arc_logico);

    //Leer un empleado
    leerEmpleado(e);

    reset(arc_logico);


    while(e.apellido <> 'fin') do begin

        write(arc_logico,e);
        leerEmpleado(e);
    end;

    close(arc_logico);

end;

//Resolver el inciso B
procedure incisoB(var arc_logico : archivo);
var
    buscar : string[15];
    e: empleado;
begin

    writeln('Ingrese un string, se informara los empleados con ese nombre o apelllido');
    readln(buscar);

    reset(arc_logico);

    writeln;
    writeln;

    while not eof(arc_logico) do begin

        read(arc_logico,e);

        if((e.nombre = buscar) or (e.apellido = buscar)) then begin
            writeln('Registro ', filepos(arc_logico));
            with e do begin
                writeln('Nro de empleado: ', nro);
                writeln('Apellido: ',apellido);
                writeln('Nombre: ', nombre);
                writeln('Edad: ', edad);
                writeln('DNI: ', dni);
            end;
        end;
    end;

    close(arc_logico);

    reset(arc_logico);

    writeln;
    writeln;
    writeln('LISTADO DE EMPLEADOS');

    while not eof(arc_logico) do begin

        read(arc_logico,e);

        with e do begin
            writeln(nombre,' ',apellido,' Nro: ', nro,' DNI: ',dni);
        end;

    end;

    close(arc_logico);

    reset(arc_logico);
    
    writeln;
    writeln;
    writeln('Empleados mayores a 70 a�os: ');

    while not eof(arc_logico) do begin

        read(arc_logico,e);

        if(e.edad > 70) then begin

            with e do begin
                writeln(nombre,' ',apellido,' Nro: ', nro,' DNI: ',dni);
            end;

        end;
    end;

    close(arc_logico);

end;

//Declarar archivo logico
var
    arc_logico : archivo;
    opc : integer;
//PROGRAMA PRINCIPAL
begin
    //MEN�
    repeat
        //Display de las opciones
        writeln('Opciones:');
        writeln('1: Crear archivo de empleados');
        writeln('2: Abrir el archivo de empleados, resolver B');

        writeln('0: QUIT');
        writeln('\nIngrese una opcion');
        readln(opc);
        case opc of
            1:  generar_archivo(arc_logico);

            2:  incisoB(arc_logico);
        end;
    until(opc = 0);
end.

//COMO HACER UN MENU
//Repeat
//  Print de las opciones
//  Case(opcion)
//    (haciendo lo que haya que hacer)
//Until opcion = codigo de salida



