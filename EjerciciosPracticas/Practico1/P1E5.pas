program P1E5;
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

        writeln('0: QUIT');
        writeln('\nIngrese una opcion');
        readln(opc);

        case opc of
            1:  generarArcDesdeTxt(arc_logico);

            2:  celularesBajoStock(arc_logico);

            3:  celusConString(arc_logico);

            4:  exportBinToTxt(arc_logico);

        end;
    until(opc = 0);
end.
