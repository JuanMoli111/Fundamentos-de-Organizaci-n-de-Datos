program P2E3;

//PRECONDICIONES:

    //  -MAESTRO EXISTE Y ES UNICO
    //  -DETALLES EXISTEN Y SON TREINTA
    //  -TODOS LOS ARCHIVOS ORDENADOS POR CODIGO DE PRODUCTO
    //  -LOS ARCHIVOS DETALLES PUEDEN TENER 0 O MAS REGISTROS POR CADA PRODUCTO

const
    valorAlto = -9999;
    cantE = 30;
type
    str25 = string[25];

    //Reg producto que representa un producto en una sucursal, su stock, su precio, etcétera
    producto = record
        cod: integer;
        nom : str25;
        desc: str25;
        stock: integer;
        minStock: integer;
        precio: real;
    end;

    //Archivo maestro de productos de la cadena de alimentos
    arc_mae = file of producto;

    //info_venta representa la venta de un producto en una sucursal, almacena el codigo del prod vendido y cant vendida,
    info_venta = record
        cod: integer;
        cant: integer;
    end;

    //Un archivo detalle de info_venta representa todos los productos vendidos en una sucursal, y sus cantidades
    arc_det = file of info_venta;

    //Declara un arreglo que representa las ventas de productos de cada sucursal, hay 30 sucursales 
    //cada una tiene su archivo con las ventas de cada producto, pueden haber 0 o mas registros de un determinado prod (cod)
    arreglo_venta_sucursales = array[1..cantE] of arc_det; 

    //Arreglo de registros info venta auxiliar para mover la info
    arreglo_registros_venta = array[1..cantE] of info_venta;
    
procedure leer(var archivo: arc_det; var dato: info_venta);
begin
    if (not(eof(archivo)))then 
        read(archivo, dato)
    else 
        dato.cod := valorAlto;
end;

//Calcula el registro con menor codigo de un arreglo de cantE registros info venta, 
//lo retorna en min y retorna el índice del arreglo donde se encontró, se avanzará en el archivo de tal indice
//en el arreglo de archivos detalle, antes de volver a mandar el arreglo de registros y calcular el siguiente minimo
procedure minimo(var array_ventas: arreglo_registros_venta; var min: info_venta; var minPos: integer);
var
	i: integer;
begin
    //Itera a traves del arreglo de registros
    for i := 1 to cantE do begin
        //Si el codigo de la venta actual es menor al cod prod minimo, actualizar la venta minima
        if(array_ventas[i].cod < min.cod) then begin
            //Guarda el nuevo minimo en el parámetro a retornar min
            min := array_ventas[i];
            //Guarda la posicion donde se encontró el minimo en minPos para retornarla
            minPos := i;
        end;
    end;
end;

var
    //Declara nombre logico para el archivo maestro
    arc_productos : arc_mae;

    //Declara arreglo de ventas de productos de las 30 sucursales, es un arreglo con 30 archivos detalle, archivos de info_ventas
    arreglo_ventas : arreglo_venta_sucursales;

    //Declara arreglo de 30 registros info_ventas
    reg_ventas : arreglo_registros_venta;

    //Auxiliares para lectura de registros
    venta_min : info_venta;    
    prod : producto;

    codAct, i, posMin, ventasTot: integer;

    strIndice : string;


begin

    //Assign del maestro, abre del maestro,
    assign(arc_productos,'maestro');
    reset(arc_productos);

    //Assign y abre los 30 archivos detalle
    for i := 1 to cantE do begin
        Str(i,strIndice);
        assign(arreglo_ventas[i],'det' + strIndice);
        Reset(arreglo_ventas[i]);
    
        //Guarda el primer regsitro del archivo en la iésima posicion del vector de registros de info_ventas
        leer(arreglo_ventas[i],reg_ventas[i])

    end;


    //Calcula el primer registro info_ventas mínino del arreglo de info ventas generado, lo retorna en ventamin 
    minimo(reg_ventas,venta_min,posMin);
    //Ya almacenado el registro minimo en venta_min, lee el siguiente registro en ese archivo,
    // almacenandolo y asi actualizando el arreglo de registros del que se calculará luego el segundo registro mínimo
    leer(arreglo_ventas[posMin],reg_ventas[posMin]);


    //{EL CODIGO ES ERRONEO LEE EL PRIMER PRODUCTO Y ACTUALIZA SU STOCK SIN VERIFICAR QUE SEA DEL MISMO TIPO}

    //Lee el primer producto del archivo maestro
    read(arc_productos,prod);

    //Mientras el codigo de la venta minima sea distinta al valor de corte (los archivos detalle aun tienen info)
    while(venta_min.cod <> valorAlto) do begin

        //Codact es el cod de la venta actual
        codAct := venta_min.cod;


        //Mientras el cod de la venta actual sea igual al cod del producto actual leido del maestro..
        while(venta_min.cod = prod.cod)do begin

            //Decrementa del stock del producto, la cantidad vendida del registro venta
            prod.stock -= venta_min.cant;


    
            //Calcula el siguiente registro info_ventas mínino del arreglo de info ventas generado, lo retorna en venta_min 
            minimo(reg_ventas,venta_min,posMin);

            //Ya almacenado el registro minimo en venta_min, lee el siguiente registro de ese archivo,
            // almacenandolo y asi actualizando el arreglo de registros del que se calculará luego el siguiente registro mínimo
            leer(arreglo_ventas[posMin],reg_ventas[posMin])

        end;

        //Si el codigo actual es igual al del prod actual cuando salio del while, significa que se actualizó la información de tal prod
        if(codAct = prod.cod)then begin
            //Vuelve un registro hacia atrás en el archivo maestro de productos, posándose así sobre el registro a actualizar
            seek(arc_productos,filepos(arc_productos) - 1);

            //Sobreescribe esa posición con el producto con su stock actualizado
            write(arc_productos,prod);
        end;
 
        //Lee el siguiente producto del archivo maestro
        read(arc_productos,prod);


    end;

    //Cerrar archivos detalle
    for i := 1 to cantE do
        close(arreglo_ventas[i]);

    //Cerrar archivo maestro
    close(arc_productos);


end.