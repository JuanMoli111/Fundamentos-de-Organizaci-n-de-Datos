program P1E4;
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
            writeln(nombre,' ',apellido,' Nro: ', nro,' DNI: ',dni, ' EDAD: ',edad);
        end;

    end;

    close(arc_logico);

    reset(arc_logico);
    
    writeln;
    writeln;
    writeln('Empleados mayores a 70 años: ');

    while not eof(arc_logico) do begin

        read(arc_logico,e);

        if(e.edad > 70) then begin

            with e do begin
                writeln(nombre,' ',apellido,' Nro: ', nro,' DNI: ',dni,' EDAD: ',edad);
            end;

        end;
    end;

    close(arc_logico);

end;

procedure agregarEmpleados(var arc_logico: archivo);
var
    e: empleado;
begin

    reset(arc_logico);

    while not eof(arc_logico) do begin
        read(arc_logico,e);
        writeln('filepos: ', filepos(arc_logico));
    end;

    leerEmpleado(e);

    while(e.apellido <> 'fin') do begin

         write(arc_logico,e);

         leerEmpleado(e);
    end;

    close(arc_logico);

end;

procedure modificarEdades(var arc_logico: archivo);
var
    e: empleado;
    nroEmp: integer;
    ok : boolean;
begin

    ok := false;
    writeln('Ingrese un numero de empleado, a cambiar su edad, ingrese -1 para volver al menu');
    readln(nroEmp);

    while(nroEmp <> -1) do begin
        reset(arc_logico);

        while((not eof(arc_logico)) and (not(ok))) do begin

            read(arc_logico,e);

            if(e.nro = nroEmp) then begin
                writeln('Ingrese la nueva edad');
                readln(e.edad);

                seek(arc_logico,filepos(arc_logico) - 1);
                write(arc_logico,e);
                ok := true;
            end;
        end;

        if(not(ok)) then
            writeln('No se encontro ningun empleado con ese numero')
        else
            ok := false;

        writeln('Ingrese un numero de empleado, a cambiar su edad, ingrese -1 para volver al menu');
        readln(nroEmp);
    end;

    close(arc_logico);
end;

procedure generarTxt(var arc_logico: archivo);
var
   e: empleado;
   arcTxt: text;
   nomTxt: string;
begin
     reset(arc_logico);

     writeln('Ingrese nombre para el archivo de texto a crear');
     readln(nomTxt);


     assign(arcTxt,nomTxt);
     rewrite(arcTxt);

     writeln(arcTxt,'   Nro    Apellido    Nombre     Edad      DNI');

     while(not eof(arc_logico)) do begin
         read(arc_logico,e);
         writeln(arcTxt,'   ',e.nro,'   ',e.apellido ,'   ',e.nombre,'   ',e.edad,'   ',e.dni);

         readln();
     end;

     close(arc_logico);
     close(arcTxt);
end;

procedure generarTxtSinDNI(var arc_logico: archivo);
var
   e: empleado;
   arcTxt: text;
begin
     reset(arc_logico);

     writeln('El nombre del archivo seá "faltaDNIEmpleado"');


     assign(arcTxt,'faltaDNIEmpleado.txt');
     rewrite(arcTxt);

     writeln(arcTxt,'   Nro    Apellido    Nombre     Edad      DNI');

     while(not eof(arc_logico)) do begin
         read(arc_logico,e);
         if(e.dni = 00) then
             writeln(arcTxt,'   ',e.nro,'   ',e.apellido ,'   ',e.nombre,'   ',e.edad,'   ',e.dni);

         readln();
     end;

     close(arc_logico);
     close(arcTxt);
end;

//Declarar archivo logico
var
    arc_logico : archivo;
    opc : integer;
//PROGRAMA PRINCIPAL
begin
    //MENÚ
    repeat
        //Display de las opciones
        writeln('Opciones:');
        writeln('1: Crear archivo de empleados');
        writeln('2: Abrir el archivo de empleados, resolver 4B');
        writeln('3: Añadir un empleado al archivo de empleados');
        writeln('4: Modificar la edad de uno o mas empleados');
        writeln('5: Exportar a archivo de texto');
        writeln('6: Exportar empleados sin DNI cargado a un archivo de texto');

        writeln('0: QUIT');
        writeln('\nIngrese una opcion');
        readln(opc);

        case opc of
            1:  generar_archivo(arc_logico);

            2:  incisoB(arc_logico);

            3:  agregarEmpleados(arc_logico);

            4:  modificarEdades(arc_logico);

            5:  generarTxt(arc_logico);

            6:  generarTxtSinDNI(arc_logico);
        end;
    until(opc = 0);
end.

