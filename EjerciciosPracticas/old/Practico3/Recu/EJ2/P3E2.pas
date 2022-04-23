program ej2;
//Definir un programa que genere un archivo con registros de longitud fija conteniendo informacion
//de empleados de una empresa de correo privado. se deberá almacenar: código de empleado, apellido y nombre,
//dirección, teléfono, DNI, y fecha de nacimiento. Implementar un algoritmo que, a partir del archivo de datos generado
//elimine de forma lógica todos los empleados con DNI inferior a 8000000
//para ello se podra utilizar algún carácter especial delante de algún campo String a su elección. Ejemplo : *PEDRO.
type
    
    t_fecha = record
        dia: integer;
        mes: integer;
        anio: integer;
    end;

    t_empleado = record
        codigo: integer;
        apellido: string[20];
        nombre: string[20];
        direccion: string[20];
        telefono: string[20];
        dni: integer;
        fecha_nac: t_fecha;
    end;

    
    t_archivo = file of t_empleado;


procedure leer_empleado(var empleado: t_empleado);
begin
    writeln('Ingrese el codigo de empleado');
    readln(empleado.codigo);

    if(empleado.codigo <> -1) then begin
        writeln('Ingrese el apellido del empleado');
        readln(empleado.apellido);

        writeln('Ingrese el nombre del empleado');
        readln(empleado.nombre);

        writeln('Ingrese la direccion del empleado');
        readln(empleado.direccion);

        writeln('Ingrese el telefono del empleado');
        readln(empleado.telefono);

        writeln('Ingrese el dni del empleado');
        readln(empleado.dni);

        writeln('Ingrese el dia de nacimiento del empleado');
        readln(empleado.fecha_nac.dia);

        writeln('Ingrese el mes de nacimiento del empleado');
        readln(empleado.fecha_nac.mes);

        writeln('Ingrese el anio de nacimiento del empleado');
        readln(empleado.fecha_nac.anio);
    end;
end;

procedure generar_archivo(var archivo: t_archivo);
var
    empleado: t_empleado;
begin

    rewrite(archivo);

    leer_empleado(empleado);

    while(empleado.codigo <> -1) do begin
        write(archivo, empleado);
        leer_empleado(empleado);
    end;

    close(archivo);
end;

//Procedimiento que imprime un archivo, listando sus empleados con un formato 
procedure imprimir_archivo(var archivo: t_archivo);
var
    empleado: t_empleado;
begin

    reset(archivo);

    while(not eof(archivo)) do begin

        read(archivo, empleado);

        if(empleado.nombre <> '***') then begin
            writeln('Codigo: ', empleado.codigo);
            writeln('Apellido: ', empleado.apellido);
            writeln('Nombre: ', empleado.nombre);
            writeln('Direccion: ', empleado.direccion);
            writeln('Telefono: ', empleado.telefono);
            writeln('DNI: ', empleado.dni);
            writeln('Fecha de nacimiento: ', empleado.fecha_nac.dia, '/', empleado.fecha_nac.mes, '/', empleado.fecha_nac.anio);
        end;

    end;

    close(archivo);
end;

procedure eliminar_empleados(var archivo: t_archivo);
var
    empleado: t_empleado;
begin

    reset(archivo);
    
    while(not(eof(archivo))) do begin

        read(archivo, empleado);

        if(empleado.dni < 80) then begin

            seek(archivo, filepos(archivo) - 1);
            empleado.nombre := '***';
            write(archivo, empleado);
        end;
        

    end;

    close(archivo);
end;
var
    arch: t_archivo;
begin
    
    assign(arch, 'empleados');
    generar_archivo(arch);
    imprimir_archivo(arch);
    eliminar_empleados(arch);

    writeln();
    writeln();

    imprimir_archivo(arch);

end.