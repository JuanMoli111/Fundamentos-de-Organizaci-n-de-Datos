program P2E6;


        //PRECONDICIONES


        //      EL MAESTRO EXISTE
        //      LOS DETALLES EXISTEN Y SON 15
        //      TODO ARCHIVO ORDENADO POR CODIGO DE ARTICULO
        //      EN CADA ARCHIVO DETALLE PUEDE HABER 0 ó N REGISTROS DE UN DETERMINADO ARTÍCULO 

        //DEBEMOS:

        //      ACTUALIZAR EL STOCK DE LOS ARTICULOS DEL ARCH MAESTRO CON LOS 15 ARCH DETALLES DE VENTAS
        //      GENERAR UN ARCHIVO .TXT CON LA INFORMACION SOLICITADA EN  EL ENUNCIADO

const
    valorAlto = -9999;
    cantE = 15;
type

    str30 = string[30];

    //Declara el tipo de registro artículo, del que haremos al arc maestro
    articulo = record
        //campos cod del artículo, stock disponible y stock minimo
        cod, stockDisp, stockMin: integer;

        precio : real;
        
        nom, desc, talle, color : str30;
    end;

    //Declara el tipo de registro para el arc detalle
    venta = record
        cod, cant: integer;
    end;

    //Declara tipos para el archivo maestro y los archivos detalle
    arc_mae = file of articulo;

    arc_det = file of venta;

    //Declara un tipo arreglo para representar la info de las 15 sucursales, una por cada archivo detalle
    arr_arc_det = array[1..cantE] of arc_det;

    arr_reg = array[1..cantE] of venta;

procedure leer(var arc_det: arc_det; var dato: venta);
begin
    if(not(eof(arc_det)))then
        read(arc_det,dato)
    else
        dato.cod := valorAlto;
end;

procedure minimo(var arr_reg_venta: arr_reg ;var min: venta; var minPos: integer);
var
    i: integer;
begin
    //Actualiza el minPos
    for i := 1 to cantE do begin
        if(arr_reg_venta[i].cod < min.cod)then minPos := i;
    end;
    //Actualiza el min
    min := arr_reg_venta[minPos]
end;

var
    //Nombres logicos arch maestro y de texto
    arc_maestro : arc_mae;
    arc_Txt : text;
    //Arreglo de archivos detalle
    arr_arc_detalle : arr_arc_det;
    //Arreglo de registros venta
    arr_reg_venta : arr_reg ;

    venta_min : venta;

    artic : articulo;

    codAct, minPos, i : integer;

    strIndice: string;
begin

    //Assign y apertura del txt}
    assign(arc_Txt,'articulos.txt');
    rewrite(arc_Txt);

    //Assign y apertura del maestro
    assign(arc_maestro,'maestro');
    reset(arc_maestro);

    //Assign y apertura de los detalles, lectura de los registros venta
    for i := 1 to cantE do begin
        Str(i,strIndice);

        assign(arr_arc_detalle[i],'det'+strindice);
        reset(arr_arc_detalle[i]);

        leer(arr_arc_detalle[i],arr_reg_venta[i]);
    end;

    //Calcular el minimo y su posicion
    minimo(arr_reg_venta,venta_min,minPos);

    //Lee el primer articulo del archivo maestro
    read(arc_maestro,artic);

    while(venta_min.cod <> valorAlto)do begin

        codAct := venta_min.cod;


        //Mientras el cod de las ventas correponda al articulo, actualizar su stock y leer sig venta minima
        while(venta_min.cod = artic.cod)do begin

            //Actualiza el stock en el reg leido artículo
            with artic do stockDisp -= venta_min.cant;

            leer(arr_arc_detalle[minPos],arr_reg_venta[minPos]);

            minimo(arr_reg_venta,venta_min,minPos);

        end;

        //Si salió y el codact es igual al del articulo significa que tenemos info para almacenar 
        if(codAct = artic.cod) then begin
            seek(arc_maestro,filepos(arc_maestro) - 1);

            write(arc_maestro,artic);
        end;

        with artic do if(stockDisp < stockMin) then write(arc_Txt,'   ',nom,'   ',desc,'   ',stockDisp,'   ',precio);

        //Leer siguiente articulo
        read(arc_maestro,artic);


    end;

    for i := 1 to cantE do close(arr_arc_detalle[i]);

    close(arc_maestro);
    close(arc_Txt);

end.