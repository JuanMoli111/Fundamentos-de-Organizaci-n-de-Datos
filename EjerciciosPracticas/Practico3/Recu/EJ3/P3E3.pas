program ej3;
const
    valorAlto = 29999;
type

    str20 = string[20];

    novela = record
        cod: integer;
        duracion, precio: real;
        nombre, genero, director: str20;        
    end;

    archivo = file of novela;

procedure datosNovela(var n: novela);
begin
    
    writeln('Ingrese el nombre de la novela');
    readln(n.nombre);

    writeln('Ingrese el genero de la novela');
    readln(n.genero);

    writeln('Ingrese el director de la novela');
    readln(n.director);

    writeln('Ingrese la duracion de la novela');
    readln(n.duracion);

    writeln('Ingrese el precio de la novela');
    readln(n.precio);
end;

//Leer un registro novela
procedure leerNovela(var n: novela);
begin
    writeln('Ingrese un codigo de novela, debe ser mayor a CERO o el programa no FUNCIONARA');
    readln(n.cod);

    if(n.cod > 0) then datosNovela(n)
    else writeln('ADVERTENCIA PUEDEN SUCEDER ERRORES POR HABER INGRESADO CODIGO INVALIDO')
end;


procedure leer(var arc: archivo; var dato: novela);
begin
    if(not(eof(arc))) then read(arc,dato)
    else dato.cod := valorAlto;
end;

//Crea un archivo de novelas con registro cabecera inicializado
procedure CrearArchivo(var arc: archivo);
var
    reg : novela;
begin
    //Setear el reg cabecera, sus datos en null
    with reg do begin
        cod := 0;
    end;

    //Crear el archivo y escribir la novela que hace de reg cabecera
    reset(arc);

    write(arc,reg);

    close(arc);
end;

procedure ImprimirArchivo(var arc: archivo);
var
    reg : novela;
begin
    reset(arc);
    while not eof(arc) do begin
        read(arc,reg);
        //if(reg.cod > 0) then begin
            writeln('Codigo: ',reg.cod);
            writeln('Nombre: ',reg.nombre);
            writeln('Genero: ',reg.genero);
            writeln('Director: ',reg.director);
            writeln('Duracion: ',reg.duracion:2:2);
            writeln('Precio: ',reg.precio:2:2);
        //end;
    end;
    close(arc);
end;

//Cargar un archivo con datos de novelas leido desde teclado.
//Se cargan n registros desde teclado por el usuario,
// el archivo no tendra espacio para nuevos registros 
//el registro cabecera estará en 0,
procedure CargarArchivo(var arc: archivo);
var
    reg: novela;
begin

    //Abrir archivo
    reset(arc);

    //Leer el primer registro para saltear el cabecera
    read(arc,reg);

    //Leer un registro novela
    leerNovela(reg);
    

    //Si es un registro valido, escribirlo en el archivo, leer nuevo registro
    while(reg.cod <> -1) do begin

        write(arc,reg);
        leerNovela(reg);
    end;
    

    close(arc);
end;
procedure AgregarNovela(var arc: archivo);
var
    reg, regCab: novela;
begin
    
    reset(arc);

    //Leer reg cabecera
    seek(arc,0);
    read(arc,regCab);
    
    
    write('el cod es : ',regCab.cod);

    leerNovela(reg);


    //Si el reg cabecera fue cero, no hay espacio en el archivo
    if(regCab.cod = 0) then begin

        //Posicionarse al final del archivo y escribir el nuevo registro
        seek(arc,filesize(arc));
        write(arc,reg);
    end
    //Si el reg cabecera menor a cero..
    else if (regCab.cod < 0) then begin

        //Dirigirse al indice que indica el cod
        seek(arc,regCab.cod * -1);

        //Leer el reg que contiene la pos a guardar en la cabecera
        read(arc,regCab);

        //Volver atras para pisar el registro anterior, ahora que ya hemos salvado el indice, guardaremos el reg nuevo
        seek(arc,filepos(arc) - 1);
        write(arc,reg);


        //Dirigirse a reg cabecera y guardar el reg que contiene el siguiente indice, o en su defecto un cero.
        seek(arc,0);
        write(arc,regCab);
    end;




    close(arc);


end;

procedure ModificarNovela(var arc: archivo);
var
    reg: novela;
    encontro: boolean;
    cod: integer;
begin
    
    //Var de control
    encontro := false;

    reset(arc);


    writeln('Ingrese un cod, se modificara la novela con tal codigo');
    readln(cod);

    if(cod > 0) then begin
    
        //Saltear reg cabecera
        leer(arc,reg);


        //Leer primer reg novela
        leer(arc,reg);


        //Mientras haya registros novela y no haya encontrado el reg a modificar
        while((reg.cod <> valorAlto) and not(encontro)) do begin
             

            //Si el cod de novela coincide con el solicitado
            if(cod = reg.cod) then begin
                 
                //Modificar datos de la novela
                datosNovela(reg);

                //Actualizar el registro
                seek(arc,filepos(arc) - 1);
                write(arc,reg);

                encontro := true;
            end;


            //Leer siguiente registro
            leer(arc,reg);

        end;

    end
    else writeln('Codigo invalido');

    if(encontro) then writeln('Exito!');


    close(arc);
end;

procedure EliminarNovela(var arc: archivo);
var
    reg, regCab: novela;
    cod: integer;
    encontro : boolean;
begin

    //Var de control
    encontro := false;

    //Abrir archivo
    reset(arc);


    writeln('Ingrese un cod, se eliminara la novela con tal codigo');
    readln(cod);

    if(cod > 0) then begin



        //Saltear reg cabecera
        leer(arc,reg);

        //Leer primer reg novela
        leer(arc,reg);

        //Mientras no se terminen los regs
        while((reg.cod <> valorAlto) and not(encontro)) do begin
            

            //Si este registro tiene el codigo solicitado
            if(reg.cod = cod) then begin
                
                //Volver el puntero al reg a eliminar
                seek(arc,filepos(arc) - 1);
                
                reg.cod := filepos(arc) * -1;

                //Borrar logicamente poniendole su indice en negativo
                write(arc,reg);


                //Leer el reg cabecera
                seek(arc,0);
                read(arc,regCab);

            {Intercambiar los indices}

                //Escribir el reg borrado logic en la cabecera,
                seek(arc,0);
                write(arc,reg);

                //Escribir el reg cabecera en la ultima pos borrada
                seek(arc,reg.cod * -1);
                write(arc,regCab);

            {}

                
                encontro := true;
            end;


            //Leer siguiente reg novela
            leer(arc,reg);

        end;


        if(encontro) then writeln('Exito!');
    end
    else writeln('Ingrese un codigo valido, debe ser mayor a cero');

    close(arc);
end;
procedure ExportarTxt(var arc: archivo);
var
    texto: text;
    reg: novela;
begin
    //Abrir arc binario
    reset(arc);

    //Assign y crear arc de texto
    assign(texto,'texto.txt');
    rewrite(texto);

    //Saltear registro cabecera
    leer(arc,reg);

    //Si el cabecera es una novela eliminada, exportarla al txt
    if(reg.cod < 0) then with reg do write(texto,cod,'       ',duracion,'      ',precio,'   ',nombre,'        ',genero,'        ',director);

    //Leer primer registro
    leer(arc,reg);

    //Mientras haya registros novela
    while(reg.cod <> valorAlto) do begin
        
        //Si cod distinto de cero exportar a texto, ya sea negativo (novela eliminada logicamente) o positivo, novela existente
        if(reg.cod <> 0) then
            with reg do write(texto,cod,'       ',duracion,'      ',precio,'   ',nombre,'        ',genero,'        ',director);
        
        //Leer siguiente registro
        leer(arc,reg);
    end;

    //Cerrar archivos
    close(texto);
    close(arc);

end;

var
    arc: archivo;
    opc : integer;
begin

    assign(arc,'archivo');

    rewrite(arc);

    CrearArchivo(arc);

    CargarArchivo(arc);

    ImprimirArchivo(arc);


    repeat
        
        writeln('1- Dar de alta una novela');
        writeln('2- Modificar una novela');
        writeln('3- Eliminar una novela');
        writeln('4- Listar en txt');

        writeln();  writeln('0- EXIT');
        writeln();

        writeln('Ingrese una opcion');
        readln(opc);

        case opc of

            1:  begin
                    AgregarNovela(arc);
                    ImprimirArchivo(arc);
                end;

            2:  begin
                    ModificarNovela(arc);
                    ImprimirArchivo(arc);   
                end;

            3:  begin
                    EliminarNovela(arc);
                    ImprimirArchivo(arc);
                end;

            4: ExportarTxt(arc);
            
            
        end;

    until (opc = 0);
end.