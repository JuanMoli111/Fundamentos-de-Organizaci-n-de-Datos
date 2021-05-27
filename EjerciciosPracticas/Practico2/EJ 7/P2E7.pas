program P2E7;

    //PRECONDICIONES


    //  -ARCHIVOS MAESTRO Y DETALLE SON UNICOS Y "NO EXISTEN"
    //  -ARCHIVOS MAESTRO Y DETALLE SE GENERAN DESDE UN TXT
    //  -TODOS LOS ARCHIVOS ORDENADOS POR COD DE PRODUCTO
    //  -ARCHIVO DETALLE SOLO CONTIENE REGISTROS QUE ESTAN EN EL ARCHIVO MAESTRO*

const
    valorAlto = -9999;
    

type

    str20 = string[20];

    //REGISTROS MAESTRO
    producto = record
        cod, stockMin, stockDisp: integer;
        nom: str20;
        precio: real;
    end;    
    //ARCHIVOS MAESTRO
    arc_mae = file of producto;


    //REGISTROS DETALLE
    venta = record
        cod, cant : integer;
    end;

    //ARCHIVOS DETALLE
    arc_det = file of venta;

procedure leer(var arc_detalle: arc_det;var min: venta);
begin
    if(not(eof(arc_detalle))) then 
        read(arc_detalle,min)
    else
        min.cod := valorAlto;
end;

//Crear maestro a partir del txt de productos
procedure crearMaestro(var arc_productos: text; var arc_maestro: arc_mae);
var
    prod: producto;
begin
    //Abre el txt de productos, crea el archivo maestro
    reset(arc_productos);

    rewrite(arc_maestro);


    //Mientras el txt no llegue al EOF, lee en prod y lo guarda en el arch maestro
    while(not(eof(arc_productos))) do begin

        with prod do readln(arc_productos,cod,stockMin,stockDisp,precio,nom);

        write(arc_maestro,prod);
    end;

    //Cerramos los archivos utilizados
    close(arc_maestro);
    close(arc_productos)
end;

//Listar contenido del archivo maestro generado en un archivo reportes.txt
procedure ListarReporte(var arc_maestro: arc_mae; var arc_reportes: text);
var
    prod: producto;
begin
    //Crea TXT de reportes
    rewrite(arc_reportes);

    //Abre el arc maestro
    reset(arc_maestro);

    //Mientras haya datos en el maestro, leerlos en la variable prod y luego almacenar sus campos al txt de reportes
    while(not(eof(arc_maestro))) do begin

        read(arc_maestro,prod);

        with prod do write(arc_reportes,'   ',cod,'   ',stockMin,'   ',stockDisp,'   ',precio,'   ',nom);

    end;

    //Cerramos los archivos utilizados
    close(arc_maestro);
    close(arc_reportes);

end;

procedure CrearDetalle(var arc_ventas: text; var arc_detalle: arc_det);
var
    v: venta;
begin

    //Abre el txt de ventas, crea el archivo detalle
    reset(arc_ventas);

    rewrite(arc_detalle);


    //Mientras el txt no llegue al EOF, lee en prod y lo guarda en el arch maestro
    while(not(eof(arc_ventas))) do begin

        with v do readln(arc_ventas,cod,cant);

        write(arc_detalle,v);
    end;

    //Cerramos los archivos utilizados
    close(arc_detalle);
    close(arc_ventas);
end;

procedure InformarListarDetalle(var arc_detalle: arc_det);
var
    v: venta;
begin

    reset(arc_detalle);

    writeln('COD     CANT');

    while(not(eof(arc_detalle))) do begin

        read(arc_detalle,v);
        writeln(v.cod,'   ',v.cant);

    end;

    close(arc_detalle);

end;

procedure ListarStockTxt(var arc_maestro: arc_mae; var sin_stock_txt: text);
var
    prod: producto;
begin
    //Apertura del maestro, creacion y apertura del txt       
    rewrite(sin_stock_txt);

    reset(arc_maestro);


    //Almacena en el txt, los productos cuyo stock disponible sea menor al stock minimo
    while(not(eof(arc_maestro))) do begin

        read(arc_maestro,prod);

        with prod do begin
            if(stockDisp < stockMin) then write(sin_stock_txt,'    ',cod,'    ',stockMin,'    ',stockDisp,'    ',precio,'    ',nom);
        end;
    end;

    //Cierra los archivos
    close(arc_maestro);
    close(sin_stock_txt);
end;
//DECLARACION DE VARIABLES
var
    //Nombre logico del archivo maestro: arc_maestro
    arc_maestro : arc_mae;

    //Nombre logico del archivo detalle: arc_detalle
    arc_detalle : arc_det;

    //Nombres logicos para archivos de texto
    productos_txt, reportes_txt, ventas_txt, stock_minimo_txt : text;

    //Registro de tipo venta, de este se compone el detalle
    reg_venta : venta;

    //Registro de tipo producto, de este se compone el maestro
    prod: producto;

    codAct: integer;
begin
    //Assign del maestro y el detalle
    assign(arc_maestro,'maestro');
    assign(arc_detalle,'detalle');

    //Assign de los archivos txt necesarios
    assign(productos_txt,'productos.txt');
    assign(reportes_txt,'reporte.txt');
    assign(ventas_txt,'ventas.txt');
    assign(stock_minimo_txt,'stock_minimo.txt');



    //Resuelve inciso A  
    crearMaestro(productos_txt,arc_maestro);

    //Resuelve inciso B
    ListarReporte(arc_maestro,reportes_txt);

    //Resuelve inciso C
    CrearDetalle(ventas_txt,arc_detalle);

    //Resuelve inciso D
    InformarListarDetalle(arc_detalle);


    //ABRIR LOS ARCHIVOS MAESTRO Y DETALLE
    reset(arc_maestro);
    reset(arc_detalle);

    //Lee el primer registro del archivo detalle
    leer(arc_detalle,reg_venta);
    //Lee el primer registro del archivo maestro a actualizar
    read(arc_maestro,prod);

    //Si aun hay datos en el archivo detalle
    while(reg_venta.cod <> valorAlto)do begin

        //Actualiza el codigo actual
        codAct := reg_venta.cod;

        //mientras el codigo actual de la venta coincida con el del producto
        while(reg_venta.cod = prod.cod) do begin

            //Actualizar el stock segun la cantidad vendida
            prod.stockDisp -= reg_venta.cant;
            
            //Leer el siguiente registro de venta
            leer(arc_detalle,reg_venta);
        end;

        //Si codAct coincide con el cod del producto 
        if(codAct = prod.cod)then begin
            seek(arc_maestro,filepos(arc_maestro) - 1);

            write(arc_maestro,prod);
        end;
        
        //*PRECONDICION :  -ARCHIVO DETALLE SOLO CONTIENE REGISTROS QUE ESTAN EN EL ARCHIVO MAESTRO
        //Si no se cumple esta precondicion en la creacion de productos.txt y ventas.txt, que son los datos de entrada del ejercicio,
        //la siguiente linea podría dar error por leer el End Of File del archivo maestro,
        read(arc_maestro,prod);

    end;

    //CERRAR ARCHIVOS
    close(arc_maestro);
    close(arc_detalle);

    ListarStockTxt(arc_maestro,stock_minimo_txt);


end.
