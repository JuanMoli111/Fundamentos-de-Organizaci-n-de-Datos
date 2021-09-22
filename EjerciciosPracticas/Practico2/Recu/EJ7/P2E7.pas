program ej7;
{
        PRECONDICIONES

        *   1- DEBEN RESOLVERSE LOS INCISOS EN FORMA DE OPCIONES DE UN MENU, RESOLVERÉ CADA INCISO EN UN PROCEDIMIENTO

        *   2- EXISTE UN ARCHIVO MAESTRO Y EXISTE UN ARCHIVO DETALLE, ESTOS SE GENERARAN EN BASE A ARCHIVOS DE TEXTO

        *   3- TODOS LOS ARCHIVOS ORDENADOS POR CODIGO DE PRODUCTO

        *   4- DEBE ACTUALIZARSE EL ARCHIVO MAESTRO DE PRODUCTOS CON EL ARCHIVO DETALLE DE VENTAS

        *   5- CADA REGISTRO MAESTRO PUEDE SER ACTUALIZADO POR 0 O N REGISTROS DEL DETALLE DE VENTAS

        *   6- EXISTE UN REGISTRO MAESTRO PARA CADA REGISTRO DETALLE EXISTENTE

        *   7- PODEMOS RECORRER EL MAESTRO SIN CONSULTAR EL EOF POR PRECONDICION 6 (Seguro existen registros M mientras existan registros D)
}

const
    valorAlto = -999;
type
    str20 = string[20];

    producto = record
        cod, stockDisp, stockMin : integer;
        nom: str20;
        precio: real;
    end;

    venta = record
        cod, cant: integer;
    end;


    arc_detalle = file of venta;

    arc_maestro = file of producto;

//DEVOLVER SIGUIENTE REGISTRO DE UN ARCHIVO, SI ES EOF DEVOLVER UN VALOR DE CORTE
procedure leerDet(var arc: arc_detalle; var dato: venta);
begin
    if(not(eof(arc))) then
        read(arc,dato)
    else
        dato.cod := valorAlto;
end; 

procedure CrearMaestroConTxt(var mae: arc_maestro);
var
    texto: text;
    prod: producto;
begin
    //Assign y apertura de archivo txt de productos
    assign(texto,'productos.txt');
    reset(texto);

    //Assign y creacion del archivo maestro
    assign(mae,'maestro');
    rewrite(mae);

    while(not(eof(texto))) do begin

        //Leer registro del txt, escribirlo en el maestro
        with prod do read(texto,cod,precio,stockDisp,stockMin,nom);
        write(mae,prod);
    end;

    close(mae);
    close(texto);
end;

procedure GenerarReporteMaestro(var mae : arc_maestro);
var
    reporte : text;
    p : producto;
begin

    //Assign y creacion del txt de reporte
    assign(reporte,'reporte.txt');
    rewrite(reporte);

    //Abrir archivo maestro
    reset(mae);


    //Mientras haya registros en el archivo maestro
    while(not(eof(mae))) do begin

        //Leer registro producto del maestro
        read(mae,p);

        //Exportar al archivo de texto reporte, los datos del registro
        with p do write(reporte,cod,'       ',stockDisp,'       ',stockMin,'        ',precio,'      ',nom);
    end;

end;

procedure CrearDetalleConTxt(var det: arc_detalle);
var
    texto: text;
    v: venta;
begin
    //Assign y crear el archivo detalle
    assign(det,'detalle_ventas');
    rewrite(det);

    //Assign y abrir el archivo de texto
    assign(texto,'ventas.txt');
    reset(texto);

    //Mientras haya datos en el archivo de texto
    while(not(eof(texto))) do begin

        //Leer los campos del registro
        with v do read(texto,cod,cant);

        //Almacenar el registro en el detalle
        write(det,v);
    end;

    //Cerrar archivos
    close(det);
    close(texto);
end;

procedure listarDetalle(var det: arc_detalle);
var
    v: venta;
begin
    //Abrir archivo
    reset(det);

    //Mientras haya registros en el archivo detalle
    while(not(eof(det))) do begin

        //Leer un registro
        read(det,v);

        //Informar sus datos
        with v do write('Codigo: ', cod, '  Cantidad vendida: ',cant);
    end;

    //Cerrar archivo
    close(det);
end;

procedure ActualizarMaestro(var maestro: arc_maestro; var detalle: arc_detalle);
var
    p: producto;
    v: venta;
    codAct, totVendido : integer;
begin

    //Abrir archivos
    reset(maestro);
    reset(detalle);

    //leer primer registro del detalle y del maestro

    leerDet(detalle,v);

    //Mientras haya registros en el archivo detalle
    while(v.cod <> valorAlto) do begin

        //Leer un registro maestro
        read(maestro,p);

        //Inicializar codigo actual y total vendido
        codAct := v.cod;
        totVendido := 0;

        //Mientras el producto vendido sea el mismo, totalizar sus ventas y leer otro producto
        while(codAct = v.cod) do begin
            totVendido += v.cant;
            leerDet(detalle,v);
        end;

        //Leer reg del maestro hasta encontrar el cod del producto a modificar
        while(codAct <> p.cod) do read(maestro,p);

        //Actualizar el stock del producto
        p.stockDisp -= totVendido;

        //Puntero del archivo maestro en la posicion del registro a actualizar
        seek(maestro,filepos(maestro) - 1);

        //Almacenar el registro actualizado
        write(maestro,p);

    end;

    //Cerrar archivos
    close(maestro);
    close(detalle);

end;

procedure ListarStockMinimo(var maestro: arc_maestro);
var
    p: producto;
    texto: text;
begin
    //Assign y creacion del archivo de texto
    assign(texto,'Reporte_Stock.txt');
    rewrite(texto);

    //Abrir el archivo maestro
    reset(maestro);

    //Mientras haya registros en el archivo maestro
    while(not(eof(maestro))) do begin

        //Leer un registro producto del archivo maestro
        read(maestro,p);

        //Si el prod tiene stock escaso, exportar sus datos en el archivo de texto
        with p do if(stockDisp < stockMin) then write(texto,cod,'       ',precio,'      ',stockDisp,'       ',stockMin,'        ',nom);
    end;

    //Cerrar archivos 
    close(texto);
    close(maestro);

end;

//DECLARARCION DE VARIABLES
var
    maestro: arc_maestro;

    detalle: arc_detalle;

    opc: integer;
begin
    //Display menu
    repeat
        writeln('Ingrese una opcion');
        writeln('1: Crear archivo binario MAESTRO de productos a partir del arc de texto "productos.txt');
        writeln('2: Listar el contenido del maestro en un archivo de texto llamado "reporte.txt');
        writeln('3: Crear un archivo detalle de ventas a partir de un txt llamado "ventas.txt"');
        writeln('4: Listar el contenido del archivo detalle generado');
        writeln('5: Actualizar el archivo maestro con el detalle');
        writeln('6: Listar en un archivo txt "stock_minimo.txt" los productos cuyo stock es escaso ');
        writeln('0: Salir');

        readln(opc);

        case opc of
            
            1:  CrearMaestroConTxt(maestro);
            
            2:  GenerarReporteMaestro(maestro);

            3:  CrearDetalleConTxt(detalle);

            4:  ListarDetalle(detalle);

            5:  ActualizarMaestro(maestro,detalle);

            6:  ListarStockMinimo(maestro);

        end;

    until(opc = 0);

end.