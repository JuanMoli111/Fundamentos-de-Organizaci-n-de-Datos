program ej6;
type

    str25 = string[25];

    celular = record
        cod, stockMin, stockDisp: integer;
        precio: real;
        nom, desc, marca: str25;
    end;

    arc_bin_celulares = file of celular;

    arc_txt_celulares = text;
procedure LeerCelular(var c: celular);
begin
    with c do begin
        writeln('Ingrese el nombre del celular, para salir ingrese fin');   readln(nom);
        if(nom <> 'fin') then begin
            writeln('Ingrese el codigo');           readln(cod);
            writeln('Ingrese el stock minimo');     readln(stockMin);
            writeln('Ingrese el stock disponible'); readln(stockDisp);
            writeln('Ingrese el precio');           readln(precio);
            writeln('Ingrese la descripcion');      readln(desc);
            writeln('Ingrese la marca ');           readln(marca);
        end;
    end;
end;
procedure CrearBinarioConTxt(var arc_bin: arc_bin_celulares);
var
    arc_txt: arc_txt_celulares;
    c: celular;
    nombre: str25;
begin

    writeln('Ingrese el nombre para el archivo binario: ');
    readln(nombre);

    //Conexion archivo logico-fisico con nombre ingresado
    assign(arc_bin,nombre);

    //Conexion archivo logico-fisico de texto
    assign(arc_txt,'celulares.txt');

    //Abrir archivo binario, crear archivo de texto
    rewrite(arc_bin);
    reset(arc_txt);

    //Mientras no se termine el archivo binario
    while(not(eof(arc_bin))) do begin
        //Leer los datos de un celular, del archivo de texto, almacenar en el celular c
        with c do readln(arc_txt,cod,stockMin,stockDisp,precio,nom,desc,marca);
        //Guardar el celular c en el archivo binario
        write(arc_bin,c);
    end;

    close(arc_bin);
    close(arc_txt);

end;
procedure ListarCelularesEscasos(var arc_bin: arc_bin_celulares);
var
    c: celular;

begin

    reset(arc_bin);

    writeln('Celulares cuyo stock disponible es menor al stock minimo:');

    while(not(eof(arc_bin))) do begin
        //Leer un celular del archivo
        read(arc_bin,c);

        //Si su stock disponible es menor a su stock minimo, listar sus datos
        with c do if(stockDisp < stockMin) then writeln('cod: ',cod,'   stockmin: ',stockMin,'  stockDisp: ',stockDisp,'    precio: ',precio,'    nombre: ',nom,'     desc: ',desc,'  marca: ', marca);

    end;

    close(arc_bin);
end;
procedure ListarCelularesConCiertaDescripcion(var arc_bin: arc_bin_celulares);
var
    c: celular;
    cadena : str25;
begin
    writeln('Ingrese una cadena de texto, se listaran los celulares que contengan tal cadena en su descripcion');

    readln(cadena);

    reset(arc_bin);

    while(not(eof(arc_bin))) do begin
        //Leer un celular del archivo
        read(arc_bin,c);

        //Si la cadena existe dentro del string, listar sus datos
        with c do if(pos(cadena,desc) <> 0) then writeln('cod: ',cod,'   stockmin: ',stockMin,'  stockDisp: ',stockDisp,'    precio: ',precio,'    nombre: ',nom,'     desc: ',desc,'  marca: ', marca);

    end;

    close(arc_bin);
end;
procedure CrearTxtConBinario(var arc_bin: arc_bin_celulares; var arc_txt: arc_txt_celulares);
var
    c: celular;
begin
    //Abrir el archivo binario
    reset(arc_bin);

    //Conectar arc fisico-logico;   crear y abrir el archivo de texto
    assign(arc_txt,'celular.txt');
    rewrite(arc_txt);

    while(not(eof(arc_bin))) do begin
        //Leer un celular del archivo binario
        read(arc_bin,c);

        //Cargar datos al archivo de texto en un formato ordenado de dos lineas por cada celular
        with c do begin
            writeln(arc_txt,'     ',cod,'     ',precio,'      ',marca,'       ',nom);
            writeln(arc_txt,'     ',stockMin,'      ',stockDisp,'       ',desc);
        end;

    end;

    close(arc_bin);
    close(arc_txt);
end;
procedure AgregarCelulares(var arc_bin: arc_bin_celulares);
var
    c: celular;
begin

    reset(arc_bin);

    //Seek a la ultima posicion del archivo
    seek(arc_bin,FileSize(arc_bin));

    LeerCelular(c);

    //Mientras el nombre del cel  no sea fin, escribir sus datos en el archivo y leer un nuevo cel
    while(c.nom <> 'fin') do begin
        write(arc_bin,c);
        LeerCelular(c);
    end;

    close(arc_bin);
end;
procedure ModificarStock(var arc_bin: arc_bin_celulares);
var
    c: celular;
    nombre : str25;
    encontro: boolean;
begin
    //Abrir el archivo binario
    reset(arc_bin);

    writeln('Ingrese el nombre de un celular a modificar su stock');
    readln(nombre);

    encontro := false;

    while((not(eof(arc_bin))) and (not(encontro))) do begin
        //Leer un celular
        read(arc_bin,c);

        //Si es el celular con el nombre que pidio el usuario 
        if(c.nom = nombre)then begin
            encontro := true;

            //Leer el nuevo stock
            writeln('Ingrese el stock actualizado');
            readln(c.stockDisp);

            //Volver a la posicion del celular a modificar;
            seek(arc_bin,FilePos(arc_bin) - 1);
            //Escribir al archivo con el nuevo celular actualizado
            write(arc_bin,c);

        end;
    
    end;

    if not(encontro) then write('No se encontro ese celular');

    close(arc_bin);
end;
procedure CrearTxtConCelularesSinStock(var arc_bin: arc_bin_celulares);
var
    arc_txt : arc_txt_celulares;
    c: celular;
begin
    //Abrir el archivo binario
    reset(arc_bin);
    //Asociar los arc logico-fisico de texto
    assign(arc_txt,'SinStock.txt');

    //Crear el archivo de texto
    rewrite(arc_txt);

    while(not(eof(arc_bin))) do begin
        //Leer un celular
        read(arc_bin,c);
        //Si el stock es cero escribir sus datos en el archivo de texto
        with c do if(stockDisp = 0) then write(arc_txt,'     ',cod,'     ',precio,'     ',stockMin,'      ',stockDisp,'       ',desc,'      ',marca,'       ',nom);
    end;

    close(arc_bin);
    close(arc_txt);
end;
var

    opc: integer;

    arc_bin : arc_bin_celulares;
    arc_txt1, arc_txt2, arc_txt3 : arc_txt_celulares;
    
begin



    //Display menu
    repeat
        writeln('Ingrese una opcion');
        writeln('1: Crear archivo binario de celulares a partir del arc de texto');
        writeln('2: Listar celulares con stock menor al minimo');
        writeln('3: Listar celular cuya descripcion contenga una cadena ingresada por el usuario');
        writeln('4: Exportar el archivo binario generado a un nuevo archivo de texto');
        writeln('5: Añadir celulares al archivo');
        writeln('6: Modificar el stock de un celular ');
        writeln('7: Crear un txt con los celulares sin stock disponible');
        writeln('0: Salir');


        readln(opc);

        case opc of
            
            1:  CrearBinarioConTxt(arc_bin);
            
            2:  ListarCelularesEscasos(arc_bin);

            3:  ListarCelularesConCiertaDescripcion(arc_bin);

            4:  CrearTxtConBinario(arc_bin,arc_txt2);

            5:  AgregarCelulares(arc_bin);

            6:  ModificarStock(arc_bin);

            7:  CrearTxtConCelularesSinStock(arc_bin);
        end;

    until(opc = 0);

end.