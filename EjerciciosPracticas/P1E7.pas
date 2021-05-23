program P1E7;
type
    //Declara un registro novela
    novela = record
        cod: integer;
        precio: real;
        nombre: string[30];
        genero: string[20];
    end;

    //Declara un archivo de registros novela
    archivo = file of novela;

procedure leerNovela(var n : novela);
begin
    with n do begin
        writeln('Ingrese el precio de la novela');
        readln(precio);
        writeln('Ingrese el codigo de novela ');
        readln(cod);
        writeln('Ingrese el nombre de la novela');
        readln(nombre);
        writeln('Ingrese el genero de la novela');
        readln(genero);
    end;
end;
procedure generarArcBinarioDesdeTxt(var arc_logico: archivo; var arcTxt: text);
var
    arc_fisico : string[16];
    n: novela;
begin
    writeln('Ingrese nombre del archivo');  //Leer el nombre que va a tener el archivo binario
    readln(arc_fisico);

    assign(arc_logico,arc_fisico);          //Linkear archivo logico con arc_fisico
    rewrite(arc_logico);                    //Crear el archivo binario y abrirlo

    assign(arcTxt,'novelas.txt');           //Linkear el archivo txt logico con el nombre novelas.txt
    reset(arcTxt);                        //Crear y abrir el archivo txt

    while(not(eof(arcTxt))) do begin
        with n do begin
          readln(arcTxt,cod,precio,genero);
          read(arcTxt,nombre);
        end;
        write(arc_logico,n);
    end;

    writeln('Done');
    close(arc_logico);
    close(arcTxt);
    readln;
    readln;
end;
//AGREGAR UNA NOVELA Y ACTUALIZAR UNA NOVELA.RESUELVE INCISO B
procedure AgregarNovela(var arc_logico: archivo);
var
    n: novela;
begin    
//AGREGAR NOVELA AL FINAL DEL ARCHIVO
    writeln('Ingrese una novela y se agregara al final del archivo');

    reset(arc_logico);

    while(not(eof(arc_logico))) do begin
        read(arc_logico,n);
    end;

    leerNovela(n);

    write(arc_logico, n);

    writeln('Done');
    readln;
    close(arc_logico);
end;
//MODIFICAR UNA NOVELA DEL ARCHIVO, BUSCAR POR NOMBRE
procedure ActualizarNovela(var arc_logico: archivo);
var
    n: novela;
    nom: string[30];
    ok : boolean;
begin 
    ok := false;
    reset(arc_logico);
    writeln('Ingrese un nombre de alguna novela, esta se buscara y, si existe, se le permitira modificar todos sus campos');
    readln(nom);

    while( (not(eof(arc_logico))) and (not(ok)) ) do begin

        read(arc_logico, n);

        if(n.nombre = nom) then begin
            writeln('Novela encontrada, a continuacion ingrese los nuevos datos');
            leerNovela(n);

            seek(arc_logico,filepos(arc_logico) - 1);
            write
            (arc_logico,n);
            ok := true;
        end;
    end;

    if(not(ok)) then
        writeln('No se encontro una novela con tal nombre')
    else
        writeln('La novela se modifico exitosamente!');

    close(arc_logico);

end;
var
    arc_logico: archivo;
    arcTxt: text;
begin

    generarArcBinarioDesdeTxt(arc_logico,arcTxt);
    AgregarNovela(arc_logico);
    ActualizarNovela(arc_logico);
    readln;
    readln;
end.
