program Arbol(INPUT, OUTPUT);
{
    MANEJADOR DE PRUEBA
}

{$B-}
Const 
    //Cant de hijos que entran en el nodo, el orden del arbol.
    maxHijos = 4;

    //CANTIDAD DE ELEMENTOS
    maxLlaves = maxHijos - 1;


    //Definir una constante que representa un valor nulo en los elementos
    Nulo = -9999;

    minLlaves = maxLlaves div 2;
Type
    

    tipo_de_dato = integer;



    //Un arbol B compuesto por un arreglo con las direcciones efectivas de los hijos
    //un arreglo para las claves osea los datos efectivos a almacenar
    //y un contador de nro registros que contabiliza la cantidad de datos en el nodo
    reg_arbol_b = record
        hijos: array[1..maxHijos] of integer;
        claves: array[1..maxLlaves] of tipo_de_dato;
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

        for i := 1 to Length(nodo.hijos) do nodo.hijos[i] := Nulo;
        for i := 1 to Length(nodo.claves) do nodo.claves[i] := Nulo;



        nro_registros := 0;
    end;


    write(arbol,nodo);

    close(arbol);

end;

function abreab(var arbol: arbolB): boolean;
var
    respuesta : char;
begin
    
    assign(arbol,'arbolb.dat');


    writeln('Existe arbolb.dat? responda S o N:');
    readln(respuesta);
    writeln;

    if((respuesta = 'S') or (respuesta = 's')) then begin
        
        reset(arbol);
        abreab := true;
    end
    else abreab := false;
end;

procedure cierraab(var arbol: arbolB);
begin
    close(arbol)
end;

function tomaraiz(var arbol: arbolB): integer;
var
    raiz: reg_arbol_b;
begin
    seek(arbol,0);

    if(not(eof)) then begin
        read(arbol,raiz);
        tomaraiz := raiz.nro_registros;
    end;

end;
procedure iniciapag(var pag: reg_arbol_b);
var
    j : integer;
begin
    
    for j := 1 to maxLlaves do begin
        pag.claves[j] := Nulo;
        pag.hijos[j] := Nulo;
    end;

    pag.hijos[maxLlaves + 1] := Nulo;


end;


procedure colocarraiz(var arbol: arbolB; raiz: integer);
var
    nrrRaiz : reg_arbol_b;
begin
    seek(arbol,0);
    nrrRaiz.nro_registros := raiz;
    iniciapag(nrrRaiz);
    write(arbol,nrrRaiz);
end;

function tomapag(var arbol: arbolB): integer;
begin
    tomapag := filesize(arbol);
end;



procedure insertar_en_pagina(llave, hijo_d : integer; var a_pagina: reg_arbol_b);
var
    i: integer;
begin
    

    i := a_pagina.nro_registros + 1;

    while((llave < a_pagina.claves[i-1]) and (i > 1)) do begin
        
        //Desplazar los elementos y los hijos que correspondan
        a_pagina.claves[i]   := a_pagina.claves[i-1];
        a_pagina.hijos[i + 1] := a_pagina.hijos[i];

        i := i - 1;
    end;

    a_pagina.nro_registros := a_pagina.nro_registros + 1;
    a_pagina.claves[i] := llave;
    a_pagina.hijos[i + 1] := hijo_d;

end;



procedure escribeArbolb(var arbol: arbolB; nrr: integer; pag: reg_arbol_b);
begin
    reset(arbol);
    seek(arbol,nrr);
    write(arbol,pag);
    close(arbol);
end;

{Inserta una llave y asigna valores iniciales al nodo raiz}
function crea_raiz(var arbol: arbolB; llave, izq, der: integer) : integer;
var
    pag: reg_arbol_b;
    nrr: integer;
begin
    
    nrr := tomapag(arbol);
    iniciapag(pag);

    pag.claves[1] := llave;
    pag.hijos[1] := izq;
    pag.hijos[2] := der;

    pag.nro_registros := 1;

    escribeArbolb(arbol,nrr,pag);
    colocarraiz(arbol,nrr);

    crea_raiz := nrr;
end;

function crea_arbol(var arbol: arbolB): integer;
var
    nrrRaiz, llave : integer;
begin
    
    rewrite(arbol);
    read(llave);

    nrrRaiz := tomapag(arbol);

    colocarraiz(arbol,nrrRaiz);

    crea_arbol := crea_raiz(arbol,llave,Nulo,Nulo);
end;




procedure divide(var arbol: arbolB; llave, hijo_d: integer; var pagAnt, pagNue: reg_arbol_b; var llave_promo, hijo_d_promo: integer);
var
    i: integer;

    llavesAux : array[1..maxLlaves] of tipo_de_dato;

    carAux : array[1..maxHijos] of integer;

begin
    
    //Mover llaves e hijos de la pagina, salvarlos
    for i := 1 to maxLlaves do begin
        llavesAux[i] := pagAnt.claves[i];
        carAux[i] := pagAnt.hijos[i];
    end;


    carAux[maxLlaves + 1] := pagAnt.hijos[maxLlaves + 1];

    i := maxLlaves + 1;

    while((llave < llavesAux[i - 1]) and (i > 1)) do begin

        //Inserta la llave nueva
        llavesAux[i] := llavesAux[i - 1];

        carAux[i + 1] := carAux[i];
        i := i - 1;
    
    end;

    llavesAux[1] := llave;
    carAux[i + 1] := hijo_d;


    //Crea la pagina nueva para la division
    hijo_d_promo := tomapag(arbol);

    iniciapag(pagNue);

    for i := 1 to minLlaves do begin
        
        //Mueve la primera mitad de las llaves e hijos a la pagina anterior
        pagAnt.claves[i] := llavesAux[i];
        pagAnt.hijos[i] := carAux[i];
        
        //
        pagNue.claves[i] := llavesAux[i + 1 + minLlaves];
        pagNue.hijos[i] := carAux[i + 1 + minLlaves];

        //Marca la segunda mitad de la pagina como vacia
        pagAnt.claves[i + minLlaves] := Nulo;
        pagAnt.hijos[i + 1 + minLlaves] := Nulo;


    end;

    pagAnt.hijos[minLlaves + 1] := carAux[minLlaves + 1];
    pagNue.hijos[i + 1 + minLlaves] := carAux[i + 2 + minLlaves];

    pagNue.nro_registros := maxLlaves - minLlaves;
    pagAnt.nro_registros := minLlaves;


    //Promueve la llave del medio
    llave_promo := llavesAux[minLlaves + 1]


end;

function busca_nodo(var arbol: arbolB; llave: integer; a_pagina: reg_arbol_b; var pos : integer): boolean;
var
    i: integer;
begin
    
    i := 1;

    while((i <= a_pagina.nro_registros) and (llave > a_pagina.claves[1])) do i := i + 1;

    pos := i;

    if((pos <= a_pagina.nro_registros) and (llave = a_pagina.claves[pos])) then 
        busca_nodo := true
    else
        busca_nodo := false;

end;

//FUNCION RECURSIVA QUE BUSCA UNA LLAVE EN UN ARBOL B
//RETORNA TRUE O FALSE SEGUN HAYA ENCONTRADO EL ELEMENTO
//nrr_found RETORNARA EL NUMERO RELATIVO DE REGISTRO A ACCEDER (LA PAGINA DONDE ESTA EL DATO), pos_found RETORNARA EL INDICE DEL ARREGLO DE LLAVES DE ESE REGISTRO, A ACCEDER PARA RECUPERAR EL DATO BUSCADO

function buscar(var arbol: arbolB; NRR: integer; Llave: tipo_de_dato; var nrr_found, pos_found: integer): boolean;
var
    nodo: reg_arbol_b;
    i : integer;
begin
    


    //Abrimos el arbol
    reset(arbol);

    //Recuperar el nodo ubicado en el NRR 
    seek(arbol,NRR);

    //CASO BASE
    if(NRR = Nulo) or (eof(arbol)) then begin
        buscar := False;
    end
    else begin

        read(arbol,nodo);

        //Cerrar el arbol antes de cualquier posible retorno de la funcion para evitar errores, no necesitamos el archivo en si para leer ni insertar informacion.
        close(arbol);


        i := 1;

        //Avanzar i hasta encontrar la pos donde esta o deberia estar el elemento
        while(nodo.claves[i] < Llave) do i += 1;

            //TEST
            writeln('test i variable: ',i);

            //Si esta llave es la buscada, devolver el Nro relativo del registro, y la posicion del dato dentro del nodo, retornar true
            if(nodo.claves[i] = Llave) then begin
                nrr_found := NRR;
                pos_found := i;
                buscar := true;
            end
            else begin

                //Llamar recursivamente, enviandole el NRR que indique el puntero de los hijos. El while de arriba calculo un i que es el indice del nodo hijo en donde deberia encontrarse el velemento si existiese ordenado, notar que si el elemento no existe esto envia un -1 que funciona como nulo del caso base
                buscar := buscar(arbol,nodo.hijos[i],Llave, nrr_found,pos_found);
        end;

    end;

end;

{
    Funcion que inserta una llave en un arbol B

        Se llama a si misma hasta alcanzar la base del arbol.
        Entonces inserta la llave en el nodo.

        Si el nodo esta lleno, llama a divide() para dividir el nodo
            Promueve la llave de en medio y el NRR del nodo nuevo

}

function insertar(var arbol: arbolB; NRR: integer; llave: tipo_de_dato; var hijo_d_promo, llave_promo: integer): boolean;
var
    pagAct, pagNue: reg_arbol_b;

    encontro, promocion: boolean;

    pos, nrr_p_a, llave_p_a : integer;
begin
    
    //Si NRR es nulo se paso del fondo del arbol, se inserta la llave original en un nodo hoja
    if(NRR = Nulo) then begin
        llave_promo := llave;
        hijo_d_promo := Nulo;
        insertar := true;
    end
    else begin
        
        
        seek(arbol,NRR);

        encontro := busca_nodo(arbol,llave,pagAct,pos);


        if(encontro) then begin
            
            write('Intento ingresar una llave ya existente');
            insertar := false;

        end
        else begin
            
            promocion := insertar(arbol,pagAct.hijos[pos], llave, nrr_p_a, llave_p_a);

            if(not(promocion)) then insertar := false
            else begin
                
                if(pagAct.nro_registros < maxLlaves) then begin
                    //No hay promocion, insertar en la pagina
                    //Listo para insertar la llave y el apuntador en esta pagina, no hay promocion
                    insertar_en_pagina(llave_p_a,nrr_p_a,pagAct);
                    escribeArbolb(arbol,nrr,pagAct);
                    insertar := false;
                end
                //Hay promocion, dividir
                else begin


                    divide(arbol,llave_p_a,nrr_p_a,pagAct,pagNue,llave_promo,hijo_d_promo);

                    escribeArbolb(arbol,nrr,pagAct);
                    escribeArbolb(arbol,hijo_d_promo,pagNue);

                    insertar := true;
                end;

            end;


        end;

    end;
end;



var
    AB : arbolB;
    nodo: reg_arbol_b;



    inte: integer;

    promovido : boolean;

    raiz, NRR, nrr_promo, llave_promo, llave : integer;
begin


    if abreab(AB) then raiz := tomaraiz(AB)
    else raiz := crea_arbol(AB);



    read(llave);

    while(llave <> 0) do begin
        

        promovido := insertar(AB,raiz,llave,nrr_promo,llave_promo);

        if(promovido) then raiz := crea_raiz(AB,llave_promo, raiz, nrr_promo);

        read(llave);
    end;


    //if(buscar(AB,0,5,nrr_found,pos_found)) then writeln('Se encontro la clave en el NRR: ',nrr_found,' en el elemento ',pos_found) else writeln('No hubo exito');
end.