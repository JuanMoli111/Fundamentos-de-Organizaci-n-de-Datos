program ej7;
type

    str25 = string[25];

    novela = record
        cod: integer;
        nom, genero: str25;
        precio: real;
    end;


    arc_bin_novelas = file of novela;

    arc_txt_novelas = text;


procedure LeerNovela(var n: novela);
begin
    with n do begin
        writeln('Ingrese el cod de novela, ingrese -1 para terminar');  readln(cod);
        if(cod <> -1) then begin
            writeln('Ingrese el nombre');    readln(nom);
            writeln('Ingrese el genero');    readln(genero);
            writeln('Ingrese el precio');    readln(precio);
        end;

    end;
end;

procedure CrearBinarioConTxt(var arc_bin: arc_bin_novelas);
var
    n: novela;
    arc_txt: arc_txt_novelas;
begin
    //Conexion del archivo logico-fisico de texto, de novelas
    assign(arc_txt,'novelas.txt');

    //Abrir el txt de novelas, crear el archivo binario de novelas
    reset(arc_txt);
    rewrite(arc_bin);

    //Mientras no se termine el txt
    while(not(eof(arc_txt))) do begin
        //Leer una novela del archivo de texto
        with n do begin
            readln(arc_txt,cod,precio,genero);
            readln(arc_txt,nom);
        end;
        //Escribir la novela en el archivo binario
        write(arc_bin,n);
    end;

    close(arc_bin);
    close(arc_txt);
end;

procedure AgregarNovelaModificarNovela(var arc_bin: arc_bin_novelas);
var
    n: novela;
    cod: integer;
    encontro: boolean;
begin
    encontro := false;

    //Abrir archivo binario de novelas
    reset(arc_bin);

    writeln('Ingrese un codigo de novela a modificar sus datos');
    readln(cod);

    //Mientras no se termine el archivo y no haya encontrado la novela solicitada...
    while(not(eof(arc_bin)) and not(encontro)) do begin

        //Leer una novela
        read(arc_bin,n);

        //Si es la solicitada por el usuario, permitir actualizar sus datos
        if(n.cod = cod) then begin

            encontro := true;

            LeerNovela(n);

            //Moverse a la posicion de la novela solicitada
            seek(arc_bin,FilePos(arc_bin) - 1);

            //Sobreescribirla con los datos actualizados
            write(arc_bin,n);
        end;

    end;

    //Si no existe la novela solicitada, informarlo
    if(not(encontro)) then writeln('No se encontro la novela solicitada');

    writeln('A continuacion podra agregar una novela al final del archivo: ');
    LeerNovela(n);

    //Si el usuario carga una nueva novela, moverse al final del archivo y escribirla
    if(n.cod <> -1) then begin
        seek(arc_bin,filesize(arc_bin));
        write(arc_bin,n);
    end;

    //Cerrar archivvo binario
    close(arc_bin);

end;
var

    opc: integer;

    arc_bin : arc_bin_novelas;
begin

    assign(arc_bin,'novela-binario');

    //Display menu
    repeat
        writeln('Ingrese una opcion');
        writeln('1: Crear archivo binario de novelas a partir del arc de texto');
        writeln('2: Modificar una novela y agregar una novela');
        writeln('0: Salir');


        readln(opc);

        case opc of
            
            1:  CrearBinarioConTxt(arc_bin);
            
            2:  AgregarNovelaModificarNovela(arc_bin);

        end;

    until(opc = 0);

end.