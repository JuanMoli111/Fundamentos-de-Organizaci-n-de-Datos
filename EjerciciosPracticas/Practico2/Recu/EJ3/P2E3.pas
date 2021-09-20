program ej3;
{                       PRECONDICIONES
                
                *  1 - EXISTE UN MAESTRO Y 30 DETALLES TODOS ORDENADOS POR COD DE PROD

                *  2 - HAY QUE RECORRER LOS 30 ARCHIVOS DETALLE

                *  3 - HAY QUE ACTUALIZAR EL MAESTRO SEGUN LA INFORMACION DE LOS DETALLES

                *  4 - SEGURO EXISTE REGISTRO EN EL MAESTRO PARA TODO REGISTRO DEL DETALLE ---> no sera necesario verificar el end of file del archivo maestro, pues mientras haya registros detalle, seguro existen registros en el maestro

                *  5 - PODRIA NO SER NECESARIO RECORRER TODO EL ARCHIVO MAESTRO (por precondicion 3)


}
const
    dimF = 30;
    valorAlto = -9999;
type


    str25 = string[25];

    //Declarar tipos registros para representar los productos y sus ventas
    producto = record
        cod, stockDisp, stockMin : integer;
        nom, desc : str25;
        precio : real;
    end;

    venta = record
        cod, cant : integer;
    end;

    //Declarar tipo arc maestro 
    maestro_productos = file of producto;

    detalle_ventas = file of venta;

    //Declarar tipos arreglo para el manejo de dimF archivos detalle
    vec_detalles = array[1..dimF] of detalle_ventas;
    vec_reg = array[1..dimF] of venta;

var
    vec_det : vec_detalles;

    maestro : maestro_productos;

    vec_ventas : vec_reg;

    arc_txt : text;

    min: venta;

    prod : producto;

    codAct, i, totVendido : integer;

    str : string;
    
//DEVOLVER SIGUIENTE REGISTRO DE UN ARCHIVO, SI ES EOF DEVOLVER UN VALOR DE CORTE
procedure leerDet(var arc: detalle_ventas; var dato: venta);
begin
    if(not(eof(arc))) then
        read(arc,dato)
    else
        dato.cod := valorAlto;
end;    
    
{   --RECIBE UN VECTOR DE REGISTROS Y RETORNA EL MINIMO POR CODIGO DE PRODUCTO, EN EL PARAMETRO MIN.
    --ACTUALIZA Y RETORNA EL VECTOR DE REGISTROS LEYENDO EL SIGUIENTE DATO DEL DETALLE CORRESPONDIENTE    }
procedure minimo(var vec_reg: vec_reg; var min: venta);
var
    minPos, i : integer;
begin

    //Recorrer los reg detalle, consiguiendo la posicion del minimo
    for i := 1 to dimF do begin
        if((vec_reg[i].cod) < min.cod) then minPos := i;
    end;
    //El registro minimo es el que esta en la posicion minPos 
    min := vec_reg[minPos];

    //Leer en el archivo detalle correspondiente, almacenar el siguiente registro en el vector de reg
    leerDet(vec_det[minPos],vec_reg[minPos]);
end;
//DECLARACION DE VARIABLES

//PROGRAMA PRINCIPAL
begin

    //Assign y crear el arc txt
    assign(arc_txt,'texto');
    rewrite(arc_txt);

    //Assign y creacion el maestro
    assign(maestro,'maestro');
    reset(maestro);

    //Assign y creacion de los 30 archivos detalle
    for i := 1 to dimF do begin

        Str(i,str);

        assign(vec_det[i],'det' + str);
        reset(vec_det[i]);
    
        //Guarda el primer registro de cada detalle en la iésima posicion del vector de registros de ventas
        leerDet(vec_det[i],vec_ventas[i]);

    end;

    //Calcular el reg minimo 
    minimo(vec_ventas,min);

    //Leer el primer registro producto
    if(min.cod <> valorAlto) then read(maestro,prod);


    //MIENTRAS LOS DETALLE TENGAN VENTAS
    while(min.cod <> valorAlto) do begin

        //Inicializar codigo actual y total vendido
        Codact := min.cod;
        totVendido := 0;

        //Mientras el cod del reg min sea el mismo, totalizar sus ventas
        while(codAct = min.cod) do begin
            totVendido += min.cant;
            minimo(vec_ventas,min);
        end;

        //Buscar el producto con ese codigo dentro del maestro (SEGURO EXISTE)
        while(codAct <> prod.cod) do read(maestro,prod);

        with prod do begin
            //Actualizar el stock del registro producto
            stockDisp -= totVendido;

            //Si el stock disponible es menor al minimo, exportar a un arc de texto la informacion de este producto
            if(stockDisp < stockMin) then write(arc_txt,nom,'     ',desc,'     ',stockDisp,'      ',precio);
        end;

        //Actualizar el maestro 
        seek(maestro,filepos(maestro) - 1);
        write(maestro,prod);

        //Avanzar en el archivo maestro
        if(not(eof(maestro))) then read(maestro,prod);
    end;




    //CERRAR LOS ARCHIVOS
    close(maestro);
    close(arc_txt);
    for i := 1 to dimF do close(vec_det[i]);


end.