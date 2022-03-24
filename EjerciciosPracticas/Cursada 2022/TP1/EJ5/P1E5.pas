{
    Dudas: no entiendo si carga.txt es el archivo txt desde el que se genera el archivo binario de celulares, o si es el archivo txt que se genera en el inciso 5d

}
program P1E5;
type
    

    celular = record
        codigo, stock_minimo, stock_disponible: integer;
        precio: real;
        nombre, descripcion, marca: string[25];
    end;

    archivo_celulares_bin = file of celular;

    archivo_celulares_txt = text;

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
var
    arc_celulares: archivo_celulares_bin;
begin
  

    Crear_Archivo_Binario(arc_celulares);

    ListarCelularesBajoStock(arc_celulares);

    ListarCelularesPorString(arc_celulares);

    ExportarCelularesTxt(arc_celulares);

end.
