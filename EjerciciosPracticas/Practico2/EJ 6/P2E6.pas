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
    
    //Declara tipos para el archivo maestro y los archivos detalle
    arc_maestro = file of articulo;
    arc_detalle = file of venta;

    //Declara un tipo arreglo para representar la info de las 15 sucursales, una por cada archivo detalle
    arr_arc_detalle = array[1..cantE] of arc_detalle;

    arr_reg_venta = array[1..cantE] of venta;

procedure leer(var arc_det: arc_detalle; var dato: venta);
begin
    if(not(eof(arc_det)))then
        read(arc_det,dato)
    else
        dato.cod := valorAlto;
end;

procedure minimo(var arc_reg)