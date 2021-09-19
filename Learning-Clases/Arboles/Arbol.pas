program arboles;
type

    nodo = record
        elem : integer;

        hi, hd : integer;
    end;

    archivo = file of nodo;

procedure insertar(var a : archivo; dato: integer);
var
    raiz, nodo_nuevo: nodo;

    pos_nodo_nuevo: integer;

    encontre_padre: boolean;
begin
    
    reset(a);

    //Carga el nodo nuevo con los datos
    with nodo_nuevo do begin
        elem := dato;
        hi := -1;
        hd := -1;
    end;

    //Significaria que es un arbol vacio entonces el elemento insertado sera raiz
    if(eof(a)) then write(a,nodo_nuevo)
    else begin
        
        //NOTAR QUE PRIMERO AGREGA EL NODO AL ARCHIVO. ACTO SEGUIDO HACE LOS ENLACES CON LOS NODOS PADRES
        
        read(a,raiz);

        //GUARDA LA POSICION DEL NODO PARA HACER EL ENLACE CON EL NODO PADRE
        pos_nodo_nuevo := filesize(a);

        //Posicionarse al final del archivo
        seek(a,pos_nodo_nuevo);

        //Escribir al final el nuevo nodo
        write(a,nodo_nuevo);



        encontre_padre := False;

        while not(encontre_padre) do begin

            
            //SI EL ELEMENTO ES MAYOR
            if(raiz.elem > nodo_nuevo.elem) then begin

                //Si esta raiz TIENE hijo izq
                if(raiz.hi <> -1) then begin

                    //SEEK a la posicion de este hijo, y guardarlo en raiz
                    seek(a,raiz.hi);
                    read(a, raiz);          
                end
                else begin
                //Cuando encuentra una raiz en -1, establecerle el indice del nuevo hijo izquierdo
                    raiz.hi := pos_nodo_nuevo;
                    encontre_padre := True;
                end;



            end
            //ELSE, SI EL ELEMENTO ES MENOR O IGUAL
            else begin
                //Si esta raiz TIENE hijo derecho
                if(raiz.hd <> -1) then begin

                    //Seek a la posicion de ese hijo , y guardarlo en raiz
                    seek(a,raiz.hd);
                    read(a, raiz);
                end
                else begin
                //Cuando encuentra una raiz en -1, establecerle el indice del nuevo hijo derecho
                    raiz.hi := pos_nodo_nuevo;
                    encontre_padre := True;
                end;
            end;

        end;

        //Raiz es el padre y ya lo lei, volver a posicionarse
        seek(a,Filepos(a)-1);

        //Guardar el padre con la nueva referencia
        write(a, raiz);


    end;

    close(a);

end;
procedure recorrer(var a : archivo);
var
    raiz: nodo;
begin


    reset(a);

    

    while(not(eof(a))) do begin

        read(a,raiz);

        
        if(raiz.hi <> -1) then begin




        end;






    end;


end;

var

    arc: archivo;
begin

    assign(arc,'lol');

    rewrite(arc);

    insertar(arc,5);
    insertar(arc,16);
    insertar(arc,3);
end.