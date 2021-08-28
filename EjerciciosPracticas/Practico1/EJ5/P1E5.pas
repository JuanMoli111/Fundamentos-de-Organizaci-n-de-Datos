program ej5;
type

    str25 = string[25];

    celular = record
        cod, stockMin, stockDisp: integer;
        nom, desc, marca: str25;
    end;

    arc_bin_celulares: file of celular;

    arc_txt_celulares: text;
var


    
begin

    //Display menu
    repeat
        writeln('Ingrese una opcion');
        writeln('1: Crear archivo de empleados');
        writeln('2: Listar informacion');
        writeln('3: Agregar uno o mas empleados');
        writeln('4: Modificar edad a uno o mas empleados');
        writeln('0: Salir');


        readln(opc);

        case opc of
            
            1:  CrearArcCelulares(arc_bin);
            
            2:  ListarInformacion(arc_bin);

            3:  AgregarEmpleados(arc_bin);

            4:  ModificarEdad(arc_bin);


        end;

    until(opc = 0);

end.