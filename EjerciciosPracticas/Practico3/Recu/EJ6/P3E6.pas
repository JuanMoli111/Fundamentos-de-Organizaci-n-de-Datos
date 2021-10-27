program ej6;

type

    str20 = string[20];

    //Reg q representa una prenda q esta a la venta
    prenda = record
        cod, stock : integer;
        desc, colores, tipo: str20;
        precio : real;
    end;


    cod_prenda = integer;


    archivo = file of prenda;

    obsoletas = file of cod_prenda;

//Arc es el archivo maestro, obs es un archivo de prendas obsoletas, que deben eliminarse logicamente del catalogo
procedure ActualizarCatalogo(var mae : archivo; var obs: obsoletas);
var
    reg : prenda;
    cod_del: integer;
    encontro : boolean;
begin
    

    reset(mae);

    
    //Leer primer reg prenda
    if(not(eof(mae))) then read(mae,reg);


    while(not(eof(mae))) do begin
        

        reset(obs);

        encontro := false;

        if(not(eof(obs))) then read(obs,cod_del);

        while(not(eof(obs))) and (not(encontro)) do begin
            

            if(reg.cod = cod_del) then begin
                
                {Borrar Logicamente}
                with reg do cod := cod * -1;

                seek(mae,filepos(mae) - 1);
                    
                write(mae,reg);
                {Borrar Logicamente}
                encontro := true;
            end;
        
            if(not(eof(obs))) then read(obs,cod_del);
        end;

        
        close(obs);

        //Leer siguiente reg prenda
        if(not(eof(mae))) then read(mae,reg);

    end;

    close(mae);

end;

procedure CompactarArchivo(var arc: archivo);
var
    reg : prenda;
    aux: archivo;
begin
    
    //Abrir arc 
    reset(arc);

    //Assign y crear arch auxiliar
    assign(aux,'maestro-compactado');
    rewrite(aux);

    //Leer primer registro
    if(not(eof(arc))) then begin
        
        read(arc,reg);

        //Pasar los registros validos a la estructura auxiliar (borrado fisico)
        while(not(eof(arc))) do begin
            if(reg.cod > 0) then write(aux,reg);       
            
            if(not(eof(arc))) then read(arc,reg);
        end;

        //Actualizar el arch
        arc := aux;
    end;

    close(aux);
    close(arc);
end;

var
    mae: archivo;

    obs: obsoletas;
begin

    assign(mae,'maestro');
    assign(obs,'prendas-obsoletas');

    

    //(Los archivos existen)
    //rewrite(mae);   rewrite(obs);


    ActualizarCatalogo(mae,obs);

    CompactarArchivo(mae);
    
end.