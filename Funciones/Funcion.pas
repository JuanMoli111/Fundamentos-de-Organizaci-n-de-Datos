program Funcion;
var
begin
  
end.
{function ContieneString(StringBase, StringBuscar: String): boolean;
var
    i, j: integer;
    bool, encontro: boolean;
    auxStr : String;
begin

    //Si la cadena a buscar tiene mayor longitud que el string base, es imposible que le contenga, devuelve falso
    if(Length(StringBuscar) > Length(StringBase)) then bool := False      
    else begin
      

        writeln('Length del string base: ',Length(StringBase),StringBase,'  Length del string a buscar: ',Length(StringBuscar), 'el primer char es: ',StringBase[-1],'seguido de ',StringBase[3]);

        //Inicializar en vacio el str auxiliar
        auxStr := '';

        //Desde la posicion 0 hasta la long del str base menos la del string buscar, por ejemplo si tenemos HOLA y OL, seria 4 - 2 = 2, para cada letra el indice: H = 0, O = 1, L = 2, no es necesario hacer una verificacion en el indice A = 3 por que OL mide dos caracteres y no puede estar contenido en A
        for i := 0 to Length(StringBase) - Length(StringBuscar) do begin
          
            

            while(not(encontro)) do begin

                bool := false;

                for j := 0 to Length(StringBuscar) do begin

                    writeln('ITERACION ',j,' StringBase[i] = ',StringBase[i],'  StringBuscar[j] = ',StringBuscar[j]);
                    //Si alguno de los caracteres es distinto, el booleano va en falso
                    if(StringBase[i] = StringBuscar[j]) then bool := true;

                    
                end;

                encontro := bool
            end;



        end;
        writeln('Si ', StringBuscar, ' esta contenido en ',StringBase,' resulto en ',bool);

    end;

    ContieneString := bool;
end;
function ContieneString(StringBase, StringBuscar: String): boolean;
var
    i, j, longStrBuscar, longStrBase: integer;
    encontro: boolean;
    auxStr : String;
begin

    //Si la cadena a buscar tiene mayor longitud que el string base, es imposible que le contenga, devuelve falso
    if(Length(StringBuscar) > Length(StringBase)) then encontro := False      
    else begin
      
        encontro := false;

        //Ajustar las longitudes 
        longStrBuscar := Length(StringBuscar);
        longStrBase := Length(StringBase);

        //writeln('Length del string base: ',Length(StringBase),'  Length del string a buscar: ',Length(StringBuscar), 'el primer char es: ',StringBase[1],'seguido de ',StringBase[2]);

        //Mientras no encuentre un substring en el StringBase
        while(not(encontro)) do begin

            //Desde la posicion 0 hasta la long del str base menos la del string buscar, por ejemplo si tenemos HOLA y buscamos OL, seria 4 - 2 = 2, para cada letra el indice: H = 1, O = 2, L = 3, no es necesario hacer una verificacion en el indice A = 4 por que OL mide dos caracteres y no puede estar contenido en A
            for i := 2 to (longStrBase - longStrBuscar) do begin

                writeln('cuenta1: ',longStrBase - longStrBuscar);

                //Inicializar en vacio el str auxiliar
                auxStr := '';

                

                writeln('cuenta2: ',i + longStrBuscar);

                //Desde el indice i actual del string Base, hasta i + length de la cadena a buscar, siguiendo el ejemplo procesariamos primero HO, luego OL, luego LA
                for j := i to (i + longStrBuscar) do begin

                    auxStr := auxStr + StringBase[j];

                    writeln(auxStr);
                    //writeln('ITERACION ',j,' StringBase[i] = ',StringBase[i],'  StringBuscar[j] = ',StringBuscar[j]);
                end;
                
                //Si el substring generado es igual al buscado, terminar la iteracion principal, encontro es TRUE
                if(auxStr = StringBuscar) then begin
                    encontro := true;
                    break;
                end;

                
            end;
        end;
    end;


    writeln('Si ', StringBuscar, ' esta contenido en ',StringBase,' resulto en ',encontro);          

    ContieneString := encontro;
end;}