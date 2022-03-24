{
    Dudas: no entiendo si carga.txt es el archivo txt desde el que se genera el archivo binario de celulares, o si es el archivo txt que se genera en el inciso 5d

}
program P1E6;
type
    

    celular = record
        codigo, stock_minimo, stock_disponible: integer;
        precio: real;
        nombre, descripcion, marca: string[25];
    end;

    archivo_celulares_bin = file of celular;

    archivo_celulares_txt = text;
procedure LeerCelular(var c: celular);
begin
    writeln('Ingrese el codigo del celular');    readln(c.codigo);

    if(c.codigo <> 0) then begin
        with c do begin
            writeln('Ingrese el nombre');           readln(nombre);
            writeln('Ingrese la descripcion');      readln(descripcion);
            writeln('Ingrese la marca');            readln(marca);
            writeln('Ingrese el stock disponible'); readln(stock_disponible);
            writeln('Ingrese el stock minimo');     readln(stock_minimo);
            writeln('Ingrese el precio');           readln(precio);
        end;
    end;
end;
procedure Crear_Archivo_Binario(var arc_bin : archivo_celulares_bin);
var
    c : celular;

    arc_txt: archivo_celulares_txt;

    nombre_arc : string[20];
begin
    
    writeln('Ingrese un nombre para el archivo binario de celulares');
    readln(nombre_arc);

    assign(arc_bin,nombre_arc);
    assign(arc_txt,'carga.txt');

    rewrite(arc_bin);
    reset(arc_txt);


    while(not(EOF(arc_txt))) do begin

        //Leer datos del archivo txt
        with c do begin

            //Leer los campos integer
            readln(arc_txt,codigo,precio,marca);
            readln(arc_txt,nombre);
            readln(arc_txt,stock_disponible,stock_minimo,descripcion);
            
        end;
        
        //Escribir al archivo binario
        write(arc_bin,c);
        
    end;


    close(arc_bin);
    close(arc_txt);

end;
procedure ListarCelularesBajoStock(var arc_bin: archivo_celulares_bin);
var
    c: celular;
begin
    
    //Abrir archivo binario de celulares
    reset(arc_bin);


    while(not(EOF(arc_bin))) do begin
        
        //Leer un reg celular
        read(arc_bin,c);

        //Informar datos de los celulares con stock bajo
        with c do if(stock_disponible < stock_minimo) then writeln(' -- Nombre: ',nombre,' Descripcion:  ',descripcion,' Marca:  ',marca,' Precio:  ',precio:2:2,' Stock Minimo:  ',stock_minimo,' Stock Disponible:  ',stock_disponible);
 
    end;


    close(arc_bin);
end;
procedure ListarCelularesPorString(var arc_bin: archivo_celulares_bin);
var
    c: celular;
    str : string[25];

    pos: integer;
begin
    
    pos := 0;

    writeln('Ingrese una cadena de caracteres, se listaran los celulares que contengan tal cadena en su descripcion');
    readln(str);

    //Abrir archivo binario de celulares
    reset(arc_bin);

    

    while(not(EOF(arc_bin))) do begin
        
        //Leer un reg celular
        read(arc_bin,c);


        //Informar datos de los celulares con descripciones que contengan el substr STR, falta implementar el metodo POS que no existe en la version de Pascal OBJECT PASCAL
        with c do begin
            if true then writeln(' -- Nombre: ',nombre,' Descripcion:',descripcion,' Marca:  ',marca,' Precio:  ',precio:2:2,' Stock Minimo:  ',stock_minimo,' Stock Disponible:  ',stock_disponible);
        end; 

        {with c do if Pos(descripcion,str) <> 0 then writeln(' -- Nombre: ',nombre,' Descripcion:  ',descripcion,' Marca:  ',marca,' Precio:  ',precio:2:2,' Stock Minimo:  ',stock_minimo,' Stock Disponible:  ',stock_disponible);}

    end;


    close(arc_bin);
end;
procedure ExportarCelularesTxt(var arc_bin:archivo_celulares_bin);
var

    arc_txt : archivo_celulares_txt;

    c: celular;
begin

    Assign(arc_txt,'celular.txt');

    //Abrir y crear archivos
    Reset(arc_bin);
    Rewrite(arc_txt);

    while(not(EOF(arc_bin))) do begin
        //Leer un registro del arc binario
        read(arc_bin,c);

        //Escribir datos del registro celular al archivo txt
        with c do writeln(arc_txt, stock_minimo,' ',stock_disponible,' ',precio:2:2,' ', codigo,' ', nombre,' ', marca,' ', descripcion);

    end;    

    close(arc_bin);
    close(arc_txt);
end;
procedure AgregarCelulares(var arc_bin: archivo_celulares_bin);
var
    c: celular;

begin
  
    //Abrir archivo
    Reset(arc_bin);

    writeln(FileSize(arc_bin));

    //Pararse al final del archivo
    Seek(arc_bin,FileSize(arc_bin));

    LeerCelular(c);

    //Mientras el celular sea valido, escribirlo al archivo, leer uno nuevo
    while(c.codigo <> 0) do begin
        write(arc_bin,c);   
        LeerCelular(c);
    end;

    close(arc_bin);
end;
procedure ModificarStock(var arc_bin: archivo_celulares_bin);
var
    c: celular;
    stock: integer;
    nom: string[25];
begin
  
    Reset(arc_bin);

    writeln('Ingrese un nombre de celular a modificar su stock, ingrese Z para salir');
    readln(nom);


    while(nom <> 'Z') do begin
      
        seek(arc_bin,0);

        read(arc_bin,c);

        while not(eof(arc_bin)) do begin
            if(c.nombre = nom) then break;
            read(arc_bin,c);
        end;

        if(c.nombre = nom) then begin
            seek(arc_bin,FilePos(arc_bin) - 1);

            WriteLn('Ingrese el stock actualizado: '); readln(stock);

            c.stock_disponible := stock;

            write(arc_bin,c);
        end
        else writeln('El nombre ingresado no corresponde a ningun celular');

        writeln('Ingrese otro nombre de celular a modificar su stock, ingrese Z para salir');
        readln(nom);
    end;

    Close(arc_bin)
end;
procedure ExportarCelularesSinStock(var arc_bin: archivo_celulares_bin);
var
    c: celular;
    arc_txt : archivo_celulares_txt;
begin
  
    //Assign del archivo de texto
    Assign(arc_txt,'SinStock.txt');

    //Abrir archivo binario, crear txt de celulares sin stock
    Reset(arc_bin);
    Rewrite(arc_txt);


    while(not(eof(arc_bin))) do begin
      
        read(arc_bin,c);

        //Exportar celulares sin stock
        if(c.stock_disponible = 0) then with c do WriteLn(arc_txt,precio:2:2,'      ',stock_minimo,'      ',stock_disponible,'      ',codigo,'      ',marca,'      ',nombre,'      ',descripcion);
    end;

    Close(arc_bin);
    Close(arc_txt);
end;
var
    arc_celulares: archivo_celulares_bin;
    opc: integer;
begin
  

    writeln(' -- 1: Crear archivo binario desde txt de celulares -- ');
    writeln(' -- 2: Listar en pantalla los datos de celulares con stock menor al stock minimo -- ');
    writeln(' -- 3: Listar en pantalla los celulares cuya descripcion contenga cierta cadena de caracteres ingresada por teclado -- ');
    writeln(' -- 4: Exportar el archivo binario a un txt llamado celular.txt -- ');
    writeln(' -- 5: Agregar uno o mas celulares al final del archivo -- ');
    writeln(' -- 6: Modificar stock de un celular -- ');
    writeln(' -- 7: Exportar el archivo binario a un txt "SinStock.txt" con aquellos celulares con stock igual a cero -- ');


    writeln('Ingrese una opcion: ');
    readln(opc);

  

    

    

    

    
    repeat
      

        case (opc) of
            1: Crear_Archivo_Binario(arc_celulares);

            2: ListarCelularesBajoStock(arc_celulares);

            3: ListarCelularesPorString(arc_celulares);

            4: ExportarCelularesTxt(arc_celulares);

            5: AgregarCelulares(arc_celulares);

            6: ModificarStock(arc_celulares);
            
            7: ExportarCelularesSinStock(arc_celulares);
        end;


        writeln('Ingrese una nueva opcion: ');
        readln(opc);
    until(opc = 0);



end.
