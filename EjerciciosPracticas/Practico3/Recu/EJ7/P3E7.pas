program ej7;


type


    str25 = string[25];

    ave = record
        nom, fam, desc, zona : str25;
        cod: integer;
    end;

    archivo = file of ave;



procedure eliminarAves(var arc:archivo);
var
    reg: ave;
    cod: integer;
    encontro : boolean;
begin
    

    writeln('Ingrese un cod identificador de ave a eliminar');
    readln(cod);

    while(cod <> 500) do begin
        
        //Abrir el archivo de aves
        reset(arc);

        encontro := false;

        //Leer primer registro ave
        if(not(eof(arc))) then read(arc,reg);

        
        //Mientras existan registro ave y no se haya encontrado el solicitado
        while((not(eof(arc))) and not(encontro)) do begin
        
            //Si el cod de ave es el solicitado
            if(reg.cod = cod) then begin
                
                //Borrar logicamente el registro
                reg.cod := cod * -1;

                //Guardar el registro borrado
                seek(arc,filepos(arc) - 1);
                write(arc,reg);

                encontro := true;
            end;



            //Leer siguiente ave
            if(not(eof(arc))) then read(arc,reg);
           
        end;


        //Informar si el procedimiento fue exitoso
        if encontro then writeln('Exito') else writeln('No se encontro ave con tal codigo');


        //Cerrar archivo
        close(arc);


        writeln('Ingrese un nuevo identificador de ave a eliminar, ingrese 500 para salir');
        readln(cod);


    end;

end;

procedure CompactarArchivo(var arc: archivo);
var
    reg: ave;


    pos : integer;
begin
    
    //Abrir archivo de aves
    reset(arc);



    //Leer primer registro ave
    if(not(eof(arc))) then read(arc,reg);

    while(not(eof(arc))) do begin
        
        //Si el registro fue borrado logicamente, guardar aqui el ultimo registro, truncar
        if(reg.cod < 0) then begin
        
            //Guardar pos del reg a sobreescribir
            pos := filepos(arc) - 1;

            //Guardar el ultimo reg
            seek(arc,filesize(arc)-1);
            read(arc,reg);

            //Sobreescribir 
            seek(arc,pos);
            write(arc,reg);

            //Truncar archivo eliminando la repeticion
            seek(arc,filesize(arc) - 1);
            truncate(arc);

            //Re-abrir el archivo, el puntero vuelve a pos 0, seek a la var pos + 1, el puntero en la pos del arch con el siguiente registro a procesar, si es EOF termina el bucle.
            reset(arc);
            seek(arc,pos + 1);
        end;

        //Leer primer registro ave
        if(not(eof(arc))) then read(arc,reg);

    end;


    close(arc);

end;
var
    arch : archivo;

begin
    
    assign(arch,'aves');
    rewrite(arch);

    eliminarAves(arch);
    CompactarArchivo(arch);

end.