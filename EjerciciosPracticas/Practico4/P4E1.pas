Const 
    //La notacion no ayuda, esta constante es la cant de elementos que entran en el nodo, el orden efectivo del arbol por definicion es 4 
    orden = 4;

    //CANTIDAD DE ELEMENTOS
    cantE = 3;

    Nulo = -9999;
Type
    

    tipo_de_dato = integer;



    //Un arbol B compuesto por un arreglo con las direcciones efectivas de los hijos
    //un arreglo para las claves osea los datos efectivos a almacenar
    //y un contador de nro registros que contabiliza la cantidad de datos en el nodo
    reg_arbol_b = record
        hijos: array[0..cantE] of integer;
        claves: array[1..cantE] of tipo_de_dato;
        nro_registros: integer;
    end;


    //Delarar tipo archivo ARBOL B
    arbolB = file of reg_arbol_b;

//Un procedure que cree nodos deberia asignar valores nulos para designar un espacio vacio?
procedure crearArcArbolB(var arbol: arbolB);
var
    nodo: reg_arbol_b;
    i : integer;
begin
    assign(arbol,'arcArbolB');
    rewrite(arbol);


    with nodo do begin
        

        writeln('funcion length de hijos: ',Length(nodo.hijos));
        writeln('funcion length de claves: ',Length(nodo.claves));

        for i := 0 to Length(nodo.hijos) do nodo.hijos[i] := -10;
        for i := 0 to Length(nodo.claves) do nodo.claves[i + 1] := -9999;



        nro_registros := 0;
    end;


    write(arbol,nodo);

    close(arbol);

end;


//Para

//AGREGA EL DATO, LO AGREGA ORDENADO EN EL NODO QUE CORRESPONDA SE PODRIA DECIR QUE LO INSERTA, AUN NO ESTA DISEÑADO EL ALGORITMO PARA OVERFLOWS
procedure agregarDato(var arbol: arbolB; dato: tipo_de_dato);
var
    nodo: reg_arbol_b;
    i, j: integer;

    aux1, aux2: tipo_de_dato;
begin
    

    reset(arbol);


    if(not(eof(arbol))) then read(arbol,nodo);

    //ANTES DEBERIA VERIFICAR SI EL NODO TIENE ESPACIO,

    //EL NODO PUEDE TENER orden - 1 ELEMENTOS, SI LA CANT DE ELEMENTOS NO ES MENOR QUE EL ORDEN, EL ELEMENTO DEBE ALMACENARSE EN ALGUN OTRO LADO (O HAY OVERFLOW? COMO É)
    if(nodo.nro_registros < cantE) then begin

        //FIX: SOLO HAY QUE GUARDAR EL ELEMENTO EN LA CLAVE DIGAMOS, DE INDICE nro_registros + 1, Y SETEAR EN -1 EL HIJO DE INDICE nro_registros

        //ESTE IF VERIFICA SI EL NODO NO TIENE ELEMENTOS, EN ESE CASO GUARDA EL DATO EN EL PRIMER ESPACIO DEL NODO 
        if(nodo.nro_registros = 0) then begin
            
            nodo.hijos[0] := -1;
            nodo.hijos[1] := -1;


            nodo.claves[1] := dato;
        end
        else begin


            i := 1;


            //DEBERIAMOS INSERTAR EL ELEMENTO CUANDO SE HALLE UNA CLAVE MAYOR AL DATO ACTUAL, LAS CLAVES POSTERIORES SE DESPLAZAN UN ELEM HACIA ADELANTE Y SE INSERTA EL DATO EN EL ESPACIO LIBRE
            while((nodo.claves[i] < dato) and (nodo.claves[i] <> Nulo)) do i += 1;


            //Salvar elemento actual
            aux1 := nodo.claves[i];


            //Insertar dato en la pos
            nodo.claves[i] := dato;


            //PARA CADA ELEMENTO DEL NODO QUE SEA MAYOR QUE EL DATO A INSERTAR, DESPLAZARLOS HACIA ADELANTE
            for j := i to nodo.nro_registros do begin

                //Salvar el siguiente elemento
                aux2 := nodo.claves[j + 1];

                //Pisar el siguiente elemento con el salvado anteriormente
                nodo.claves[j + 1] := aux1;

                //Actualiza el aux
                aux1 := aux2;
            end;

        end;


        nodo.nro_registros += 1;



        seek(arbol,filepos(arbol) - 1);
        write(arbol,nodo);


    end;


    close(arbol);
end;

var
    AB : arbolB;
    nodo: reg_arbol_b;

    inte: integer;
begin
    crearArcArbolB(AB);


    read(inte);


    agregarDato(AB,inte);

    read(inte);


    agregarDato(AB,inte);
    read(inte);


    agregarDato(AB,inte);


    reset(AB);

    read(AB,nodo);

    writeln(nodo.claves[1]);
    writeln(nodo.claves[2]);
    writeln(nodo.claves[3]);
    //writeln('nodo inv',nodo.claves[42]);

end.