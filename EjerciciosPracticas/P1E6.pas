program P1E6;
type

    celular = record
        cod : integer;
        nom : string[10];
        desc: string[30];
        marca: string[10];
        precio: real;
        minStock: integer;
        dispStock: integer;
    end;

    archivo = file of celular;
procedure leerCelular(var c: celular);
begin
    with c do begin
        writeln('Ingrese stock disponible, ingrese -1 para finalizar');
        readln(dispStock);
        if(c.dispStock <> -1) then begin
            writeln('Ingrese el codigo del celular');
            readln(cod);
            writeln('Ingrese nombre del celular');
            readln(nom);
            writeln('Ingrese la descripcion del celular');
            readln(desc);
            writeln('Ingrese la marca');
            readln(marca);
            writeln('Ingrese el precio');
            readln(precio);
            writeln('Ingrese el stock minimo');
            readln(minStock);
        end;
    end;
end;

procedure generarArcDesdeTxt(var arc_logico: archivo);
var
   arcTxt : text;
   c: celular;
   arc_fisico : string[16];
begin
    //Lee el nombre, arc fisico
    writeln('Ingrese el nombre del archivo fisico');
    readln(arc_fisico);

    //Conecta el arc logico con el fisico
    assign(arc_logico,arc_fisico);

    //Conecta el txt arcTxt con un archivo de la carpeta que se llame "celulares"
    assign(arcTxt,'celulares.txt');
    //Abre el txt
    reset(arcTxt);

    //Crea el archivo logico del archivo binario de registros y lo abre
    rewrite(arc_logico);
    reset(arc_logico);

    while(not eof(arcTxt)) do begin
        with c do readln(arcTxt,cod,precio,minStock,dispStock,nom,desc,marca);
        write(arc_logico,c);
    end;

    writeln('Done');
    close(arc_logico);
    close(arcTxt);

end;

procedure celularesBajoStock(var arc_logico: archivo);
var
    c: celular;
begin
    reset(arc_logico);

    while(not(eof(arc_logico))) do begin

        read(arc_logico,c);

        if(c.dispStock < c.minStock) then begin

            with c do begin
                writeln('Codigo: ', cod,'     precio: ', precio,'         nombre: ', nom,'      desc: ', desc,'      marca: ', marca,'      stock minimo: ', minStock,'          stock disponible: ', dispStock);
            end;
        end;
    end;

    close(arc_logico);
end;

procedure celusConString(var arc_logico: archivo);
var
   str: string;
   c: celular;
begin
    writeln('Ingrese una cadena de caracteres, se informaran los celulares cuya descripcion la contengan');
    readln(str);

    //Abrir archivo logico
    reset(arc_logico);


    while(not(eof(arc_logico))) do begin

        read(arc_logico,c);

        if(pos(str,c.desc) <> 0) then
            with c do begin
                writeln('Codigo: ', cod,'     precio: ', precio,'        nombre: ', nom,'      desc: ', desc,'      marca: ', marca,'      stock minimo: ', minStock,'          stock disponible: ', dispStock);
            end;
    end;

    //Cerrar archivo
    close(arc_logico);
end;

procedure exportBinToTxt(var arc_logico: archivo);
var
    c: celular;
    arcTxt: text;
begin
    //Abre el archivo logico binario
    reset(arc_logico);

    //Linkea el archivo logico de texto, con el nombre designado
    assign(arcTxt,'celular.txt');

    //Crea el txt y lo abre
    rewrite(arcTxt);

    while(not(eof(arc_logico))) do begin

        read(arc_logico,c);

        with c do begin
            writeln(arcTxt,'Cod:   ',cod,'    precio:    ',precio:2:2,'    marca:    ',marca,'    nombre:    ',nom);
            writeln(arcTxt,'Stock disponible:   ',dispStock,'    stock minimo:    ',minStock,'    descripcion:    ',desc);
            writeln(arcTxt);
        end;
    end;

    close(arc_logico);
    close(arcTxt);
end;
procedure agregarCelulares(var arc_logico: archivo);
var
    c: celular;
begin

    reset(arc_logico);

    while(not(eof(arc_logico))) do
        read(arc_logico,c);

    leerCelular(c);

    while(c.dispStock <> -1) do begin

        write(arc_logico,c);
        leerCelular(c);

    end;

    close(arc_logico);
end;

procedure modificarStock(var arc_logico: archivo);
var
    c: celular;
    ok: boolean;
    nom: string[10];
begin
    ok := false;

    writeln('Ingrese un nombre de celular, a cambiar su stock, ingrese "NONE" para finalizar');
    readln(nom);


    while(nom <> 'NONE') do begin

        reset(arc_logico);

        while((not(eof(arc_logico))) and (not(ok))) do begin
            read(arc_logico,c);

            if(c.nom = nom) then begin
                writeln('Ingrese el nuevo stock');
                readln(c.dispStock);

                seek(arc_logico, filepos(arc_logico) - 1);
                write(arc_logico,c);
                ok := true;
            end;
        end;


        if(not(ok)) then
            writeln('No se encontro ningun celular con ese nombre')
        else
            ok := false;

        writeln('Ingrese un nombre de celular, a cambiar su stock, ingrese "NONE" para finalizar');
        readln(nom);
    end;

    close(arc_logico);
end;
procedure generarTxtSinStock(var arc_logico: archivo);
var
    c: celular;
    arcTxt: text;
begin
    reset(arc_logico);

    writeln('El nombre del archivo sera "SinStock"');

    assign(arcTxt,'SinStock.txt');
    rewrite(arcTxt);


    while(not(eof(arc_logico))) do begin
        read(arc_logico,c);

        if(c.dispStock = 0) then begin
            with c do begin
                writeln(arcTxt,'Cod:   ',cod,'    precio:    ',precio:2:2,'    marca:    ',marca,'    nombre:    ',nom);
                writeln(arcTxt,'Stock disponible:   ',dispStock,'    stock minimo:    ',minStock,'    descripcion:    ',desc);
                writeln(arcTxt);
            end;
        end;

    end;
    close(arc_logico);
    close(arcTxt);

end;
var
   arc_logico: archivo;
   opc : integer;
begin

    repeat
        //Display de las opciones
        writeln('Opciones:');
        writeln('1: Crear archivo de celulares en base al txt "celulares"');
        writeln('2: Listar celulares con stock menor al sock minimo');
        writeln('3: Listar celulares con string ingresado por usuario');
        writeln('4: Crear un nuevo txt con distinto formato, desde el archivo binario,');
        writeln('5: A�adir uno o mas celulares al final de archivo');
        writeln('6: Modificar el stock de un celular');
        writeln('7: Exportar desde el binario, a un archivo de texto, los celulares sin stock');


        writeln('0: QUIT');
        writeln('\nIngrese una opcion');
        readln(opc);

        case opc of
            1:  generarArcDesdeTxt(arc_logico);

            2:  celularesBajoStock(arc_logico);

            3:  celusConString(arc_logico);

            4:  exportBinToTxt(arc_logico);

            5:  agregarCelulares(arc_logico);

            6:  modificarStock(arc_logico);

            7:  generarTxtSinStock(arc_logico);
        end;
    until(opc = 0);
end.
