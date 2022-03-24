program ArbolBalanceado;

//Esta version funcionara con la variable arbolB declarada globalmente

Const
    //Cant de hijos que entran en el nodo, el orden del arbol.
    maxHijos = 4;

    //CANTIDAD DE ELEMENTOS
    maxLlaves = maxHijos - 1;

    //Max numero de hijos y llaves en su estructura auxiliar
    maxHijosAux = maxHijos + 1;
    maxLlavesAux = maxHijos;


    //Una constante NullPointer en el arreglo de hijos indica que ese hijo es nulo
    NullPointer = -1;

    //Definir una constante que representa un valor nulo en los elementos
    Nulo = -999;

    minLlaves = maxLlaves div 2;

Type


    tipo_de_dato = integer;



    //Un arbol B compuesto por un arreglo con las direcciones efectivas de los hijos
    //un arreglo para las claves osea los datos efectivos a almacenar
    //y un contador de nro registros que contabiliza la cantidad de datos en el nodo,
    // un contador de registros en -1 podria significar que tal registro nodo es nulo
    reg_arbol_b = record
        hijos: array[1..maxHijos] of integer;
        claves: array[1..maxLlaves] of tipo_de_dato;
        nro_registros: integer;
    end;


    //Delarar tipo archivo ARBOL BALANCEADO
    arbolB = file of reg_arbol_b;

//Declaracion de variables
var

    //Tres variables globales de registros nodo, que podrian ser necesarias para la implementacion de la eliminacion de llaves
    
    nuevaRaiz, nodoRaiz, done, balanceNode: reg_arbol_b;



    raiz: integer;

    //Declarar globalmente el arbol, asi lo hace el libro
    arbol: arbolB;

function abreab: boolean;
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

procedure cierraab;
begin
    close(arbol)
end;

function tomaraiz: integer;
var
    raiz: reg_arbol_b;
begin
    seek(arbol,0);

    if(not(eof)) then begin
        read(arbol,raiz);
        tomaraiz := raiz.nro_registros;
    end
    else
        writeln('Error no se pudo obtener la raiz');


end;
procedure iniciapag(var pag: reg_arbol_b);
var
    j : integer;
begin

    for j := 1 to maxLlaves do begin
        pag.claves[j] := Nulo;
        pag.hijos[j] := NullPointer;
    end;

    pag.hijos[maxLlaves + 1] := NullPointer;


end;


procedure colocarraiz(raiz: integer);
var
    nrrRaiz : reg_arbol_b;
begin
    seek(arbol,0);
    nrrRaiz.nro_registros := raiz;
    iniciapag(nrrRaiz);
    write(arbol,nrrRaiz);
end;

function tomapag: integer;
begin
    tomapag := filesize(arbol);
end;

function getPagina(NRR: integer) : reg_arbol_b;
begin

    seek(arbol,NRR);
    read(arbol,getPagina);

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

procedure leeab(nrr: integer; var pag: reg_arbol_b);
begin
    seek(arbol,nrr);
    read(arbol,pag);
end;


procedure escribeArbolb(nrr: integer; pag: reg_arbol_b);
begin
    seek(arbol,nrr);
    write(arbol,pag);
end;

{Inserta una llave y asigna valores iniciales al nodo raiz}
function crea_raiz(llave, izq, der: integer) : integer;
var
    pag: reg_arbol_b;
    nrr: integer;
begin

    nrr := tomapag;
    iniciapag(pag);

    pag.claves[1] := llave;
    pag.hijos[1] := izq;
    pag.hijos[2] := der;

    pag.nro_registros := 1;

    escribeArbolb(nrr,pag);
    colocarraiz(nrr);

    crea_raiz := nrr;
end;

function crea_arbol: integer;
var
    nrrRaiz, llave : integer;
begin

    rewrite(arbol);
    read(llave);

    nrrRaiz := tomapag;

    colocarraiz(nrrRaiz);

    crea_arbol := crea_raiz(llave,NullPointer,NullPointer);
end;


procedure divide(llave, hijo_d: integer; var pagAnt, pagNue: reg_arbol_b; var llave_promo, hijo_d_promo: integer);
var
    i: integer;

    llavesAux : array[1..maxLlavesAux] of tipo_de_dato;

    carAux : array[1..maxHijosAux] of integer;

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
    hijo_d_promo := tomapag;

    iniciapag(pagNue);

    for i := 1 to minLlaves do begin

        //Mueve la primera mitad de las llaves e hijos a la pagina anterior
        pagAnt.claves[1] := llavesAux[i];
        pagAnt.hijos[i] := carAux[i];

        //
        pagNue.claves[i] := llavesAux[i + 1 + minLlaves];
        pagNue.hijos[i] := carAux[i + 1 + minLlaves];

        //Marca la segunda mitad de la pagina como vacia
        pagAnt.claves[i + minLlaves] := Nulo;
        pagAnt.hijos[i + 1 + minLlaves] := NullPointer;


    end;

    pagAnt.hijos[minLlaves + 1] := carAux[minLlaves + 1];
    pagNue.hijos[i + 1 + minLlaves] := carAux[i + 2 + minLlaves];

    pagNue.nro_registros := maxLlaves - minLlaves;
    pagAnt.nro_registros := minLlaves;


    //Promueve la llave del medio
    llave_promo := llavesAux[minLlaves + 1]


end;

function busca_nodo(llave: integer; a_pagina: reg_arbol_b; var pos : integer): boolean;
var
    i: integer;
begin

    i := 1;

    writeln('test en busca nodo');


    while((i <= a_pagina.nro_registros) and (llave > a_pagina.claves[1])) do i := i + 1;

    pos := i;


    writeln('test, pos es igual a : ',pos);

    if((pos <= a_pagina.nro_registros) and (llave = a_pagina.claves[pos])) then
        busca_nodo := true
    else
        busca_nodo := false;

end;

//FUNCION RECURSIVA QUE BUSCA UNA LLAVE EN UN ARBOL B
//RETORNA TRUE O FALSE SEGUN HAYA ENCONTRADO EL ELEMENTO
//nrr_found RETORNARA EL NUMERO RELATIVO DE REGISTRO A ACCEDER (LA PAGINA DONDE ESTA EL DATO), pos_found RETORNARA EL INDICE DEL ARREGLO DE LLAVES DE ESE REGISTRO, A ACCEDER PARA RECUPERAR EL DATO BUSCADO

function buscar(NRR: integer; Llave: tipo_de_dato; var nrr_found, pos_found: integer): boolean;
var
    nodo: reg_arbol_b;
    i : integer;
begin



    //Abrimos el arbol
    {reset(arbol);}

    //Recuperar el nodo ubicado en el NRR
    seek(arbol,NRR);

    //CASO BASE
    if(NRR = NullPointer) or (eof(arbol)) then begin
        buscar := false;
    end
    else begin

        read(arbol,nodo);

        //Cerrar el arbol antes de cualquier posible retorno de la funcion para evitar errores, no necesitamos el archivo en si para leer ni insertar informacion.
        {close(arbol);}


        i := 1;

        //Avanzar i hasta encontrar la pos donde esta o deberia estar el elemento
        while(i <= nodo.nro_registros) and (nodo.claves[i] < Llave) do i += 1;

        //TEST
        writeln('test i variable: ',i);

        //Si esta llave es la buscada, devolver el Nro relativo del registro, y la posicion del dato dentro del nodo, retornar true
        if(nodo.claves[i] = Llave) then begin
            nrr_found := NRR;
            pos_found := i;
            buscar := true;
        end
        else begin 

            if(nodo.claves[i] < Llave) then i += 1;

            //Llamar recursivamente, enviandole el NRR que indique el puntero de los hijos. El while de arriba calculo un i que es el indice del nodo hijo en donde deberia encontrarse el velemento si existiese ordenado, notar que si el elemento no exi
            //ste esto envia un -1 que funciona como nulo del caso base
            buscar := buscar(nodo.hijos[i], Llave, nrr_found,pos_found);
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

function insertar(NRR: integer; llave: tipo_de_dato; var hijo_d_promo, llave_promo: integer): boolean;
var

    //Pagina actual y pagina nueva se crea si hay division
    pagAct, pagNue: reg_arbol_b;

    // -Indica si la llave ya esta en el arbol B
    // -Indica si la llave ya se promovio
    encontro, promocion: boolean;

    // -Pos en la que debe estar la llave
    // -NRR Promovido desde abajo
    // -Llave promovida desde abajo
    pos, nrr_p_a, llave_p_a : integer;
begin

    writeln('breakpoint entrando a insertar:    NRR: ',NRR,'    Llave:  ', llave,'  hijo_d_promo: ', hijo_d_promo,'     llave_promo: ', llave_promo);

    //Si NRR es nulo se paso del fondo del arbol, se inserta la llave original en un nodo hoja
    if(NRR = NullPointer) then begin
        llave_promo := llave;
        hijo_d_promo := NullPointer;
        insertar := true;

        writeln('se inserto en hojas');
    end
    else begin

        writeln('test: ');
        writeln('breakpoint test1:    NRR: ',NRR,'    Llave:  ', llave,'  hijo_d_promo: ', hijo_d_promo,'     llave_promo: ', llave_promo);

        leeab(nrr,pagAct);

        encontro := busca_nodo(llave,pagAct,pos);


        if(encontro) then begin

            write('Intento ingresar una llave ya existente');
            insertar := false;

        end
        else begin

            writeln('test2');


            promocion := insertar(pagAct.hijos[pos], llave, nrr_p_a, llave_p_a);


            writeln('test3');

            if(not(promocion)) then insertar := false
            else begin

                if(pagAct.nro_registros < maxLlaves) then begin
                    //No hay promocion, insertar en la pagina
                    //Listo para insertar la llave y el apuntador en esta pagina, no hay promocion
                    insertar_en_pagina(llave_p_a,nrr_p_a,pagAct);
                    escribeArbolb(nrr,pagAct);
                    insertar := false;
                end
                //Hay promocion, dividir
                else begin


                    divide(llave_p_a,nrr_p_a,pagAct,pagNue,llave_promo,hijo_d_promo);

                    escribeArbolb(nrr,pagAct);
                    escribeArbolb(hijo_d_promo,pagNue);

                    insertar := true;
                end;

            end;


        end;

    end;
end;

procedure delete(key : tipo_de_dato);
begin
    balanceNode.nro_registros := -1;
    raiz = findRebalance(nodoRaiz);
end;

//Dado un registro pagina o registro nodo retornar true si es hoja, false si es un nodo interno
function esHoja(pag: reg_arbol_b): boolean;
var
    i: integer;
begin

    esHoja := false;

    while((i <= maxHijos) and (esHoja = false)) do begin
        
        if(pag.hijos[i] <> NullPointer)then esHoja := true;

    end;
    
end;


//Recibe un nodo y retorna la mayor llave del nodo, si no tiene elemento retorna Nulo
function llaveMax(pag: reg_arbol_b) : tipo_de_dato;
var
    i: integer;
    max : tipo_de_dato;
begin
    
    max := Nulo;

    //Recorrer todas las llaves del nodo, no pasa nada si alguna es Nulo
    for i := 1 to maxLlaves do begin
        
        //Calcular la llave maxima
        if(pag.claves[i] > max) then max := pag.claves[i];

    end;

    llaveMax := max;
end;

//Recibe una pagina nodo y retorna el integer que, mediante el arreglo de hijos, acceda a la llave mas grande encontrada
function IndiceMaxHijo(pag : reg_arbol_b): integer;
var
    i, max : integer;
    
begin
    
    //Si retorna Nulo es que no habia elementos en el nodo
    max := Nulo;

    for i := 1 to maxLlaves do begin
        
        if pag.claves[i] > max then begin
            IndiceMaxHijo := i;
            max := pag.claves[i];
        end;

    end;

end;

//Retorna la pagina maxima entre las paginas hijas de un nodo recibido por parametro
function paginaMax(pag: reg_arbol_b): reg_arbol_b;
var
    res, i: integer
    pagReturn: reg_arbol_b;
begin
    res := IndiceMaxHijo(pag);

    if(res <> Nulo) then begin
        
        leeab(res,pagReturn);

        paginaMax := pagReturn;

    end
    else begin
        //Si no tiene hijos retornar una pagina nula
        pagReturn.nro_registros := -1;
        paginaMax := pagReturn;
    end;
end;

procedure findRebalance(thisNode, leftNode, rightNode, lanchor, ranchor : reg_arbol_b; llave : tipo_de_dato);
var

    removeNode, nextNode, nextLeft, nextRight, nextAncL, nextAncR: reg_arbol_b;

    i : integer;
begin
    
    if(thisNode.nro_registros <= minLlaves) then 
        balanceNode.nro_registros := -1         //???   BalanceNode == NO BALANCE
    else
        if (balanceNode.nro_registros == -1) then balanceNode := currentNode;

    
    //Incrementar i hasta encontrar la posicion del arreglo de hijos donde estaria un siguiente nodo
    while(i <= thisNode.nro_registros) and (thisNode.claves[i] < llave) do i += 1;
    
    writeln('testing i: ', i);
    

    //Node location best matching key value, nextNode sera el siguiente nodo a acceder, en este proceso recursivo buscando la llave a eliminar
    nextNode := getPagina(thisNode.hijos[i]);


    //si no es un nodo hoja
    if(not(esHoja(thisNode)) then begin
        

        //Si nextNode es menor que thisNode (entonces la llave mayor de nextNode sigue siendo menor que la llave menor de thisNode)
        if nextNode.claves[maxLlaves] <= thisNode.claves[1] then begin

            //next left sera el nodo hijo que contiene la llave mas grande, entre los nodos hijos de leftNode
            nextLeft := paginaMax(leftNode);

            nextAncL := lanchor;

        end
        else
        begin
            //next left sera el anteultimo hijo de leftNode
            nextLeft := getPagina(leftNode.hijos[maxHijos - 1]);      
        end;

    end;


end;

var
    //AB : arbolB;
    nodo: reg_arbol_b;



    inte: integer;

    promovido : boolean;

    NRR, nrr_promo, llave_promo, llave, nrr_found, pos_found: integer;
begin
    //crearArcArbolB(AB);

    if abreab then raiz := tomaraiz
    else raiz := crea_arbol;


    read(llave);

    while(llave <> 0) do begin

        writeln('Raiz antes de llamar a insertar: ',raiz);

        promovido := insertar(raiz,llave,nrr_promo,llave_promo);

        writeln('Raiz luego de llamar a insertar: ',raiz);

        if(promovido) then raiz := crea_raiz(llave_promo, raiz, nrr_promo);

        writeln('Raiz luego de llamar a crear raiz: ',raiz);

        read(llave);
    end;

    cierraab;

    reset(arbol);

    seek(arbol,raiz);
    if(not(eof(arbol))) then read(arbol,nodo);

    writeln(nodo.claves[1],' aaa ',nodo.claves[2],' aaa ',nodo.claves[3]);


    if(nodo.hijos[1] <> NullPointer) then seek(arbol,nodo.hijos[1]);

    if(not(eof(arbol))) then read(arbol,nodo);

    writeln(nodo.claves[1],' aaa ',nodo.claves[2]);


    //writeln(nodo.hijos[0],' hijos ',nodo.hijos[1]);

    if(buscar(0,5,nrr_found,pos_found)) then writeln('Se encontro la clave en el NRR: ',nrr_found,' en el elemento ',pos_found) else writeln('No hubo exito');
end.
