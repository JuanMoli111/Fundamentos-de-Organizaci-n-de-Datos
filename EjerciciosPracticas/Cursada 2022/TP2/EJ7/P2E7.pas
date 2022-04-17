program P2E7;
const
    valorAlto = 9999;

type

    str25 = string[25];


    producto_maestro = record
        cod, stockDisp, stockMin: integer;
        nom: str25;
        precio: real;
    end;

    producto_detalle = record
        cod, cant_vendida : integer;
    end;

    archivo_maestro = file of producto_maestro;
    archivo_detalle = file of producto_detalle;
    archivo_texto   = Text;

procedure leer(var det: archivo_detalle; var dato: producto_detalle);
begin
    if(not(EOF(det))) then
        read(det,dato)
    else
        dato.cod := valorAlto;
end;

procedure CrearMaestro(var mae: archivo_maestro);
var
    arc_txt : archivo_texto;
    regm : producto_maestro;
begin
    //Assign y apertura del archivo de texto
    Assign(arc_txt,'productos.txt');
    Reset(arc_txt);

    //Assign y creacion del archivo maestro
    Assign(mae,'maestro');
    Rewrite(mae);


    while(not(EOF(arc_txt))) do begin

        //Leer los campos del registro maestro, del archivo de texto existente
        with regm do readln(arc_txt,cod,precio,stockDisp,stockMin,nom);

        //Escribir el registro al archivo maestro
        write(mae,regm);
    end;


    //Cerar archivos
    close(mae);
    close(arc_txt);
end;

procedure ListarContenidoMaestro(var mae: archivo_maestro);
var
    arc_txt : archivo_texto;

    regm: producto_maestro;
begin

    //Assign y creacion del archivo de texto
    Assign(arc_txt,'reporte.txt');
    Rewrite(arc_txt);

    //Abrir el archivo maestro
    reset(mae);

    while(not(EOF(mae))) do begin

        //Leer un reg del archivo maestro
        read(mae,regm);

        //Escribir sus campos en el archivo txt
        with regm do writeln(arc_txt,cod,' ',precio:2:2,' ',stockDisp,' ',stockMin,' ',nom);
    end;

    //Cerrar archivos
    close(mae);
    close(arc_txt);  
end;

procedure CrearDetalle(var det: archivo_detalle);
var
    regd : producto_detalle;
    arc_txt : archivo_texto;
begin
    //Assign y apertura del archivo de texto
    Assign(arc_txt,'ventas.txt');
    Reset(arc_txt);

    //Assign y creacion del archivo detalle
    Assign(det,'detalle-ventas-binario');
    Rewrite(det);

    //Leer registros del archivo de texto existente, escribirlos en el archivo detalle
    while(not(EOF(arc_txt))) do begin
        with regd do read(arc_txt,cod,cant_vendida);    
        write(det,regd);
    end;

    //Cerrar archivos
    Close(arc_txt);
    close(det);
end;

procedure ListarDetalle(var det: archivo_detalle);
var
    regd: producto_detalle;
begin
    //Abrir archivo detalle
    Reset(det);

    //Leer registros del archivo detalle e imprimirlos en pantalla
    while(not(EOF(det))) do begin
        read(det,regd);
        with regd do writeln('cod: ',cod,' cantidad vendida: ',cant_vendida);
    end;

    //Cerrar archivo detalle
    close(det);
end;
procedure ListarMaestro(var mae: archivo_maestro);
var
    regm: producto_maestro;
begin
    //Abrir archivo maestro
    Reset(mae);

    //Leer registros del archivo maestro e imprimirlos en pantalla
    while(not(EOF(mae))) do begin
        read(mae,regm);
        with regm do writeln('cod: ',cod,' stock disponible: ',stockDisp,' stock minimo: ',stockMin,' nombre: ',nom,' precio: ',precio:2:2);
    end;

    //Cerrar archivo maestro
    close(mae);
end;
procedure ActualizarMaestro(var mae: archivo_maestro; var det: archivo_detalle);
var
    regm: producto_maestro;
    regd: producto_detalle;

    codAct : integer;
begin
    //Abrir archivos
    Reset(mae);
    Reset(det);

    //Leer registro detalle, si no existe el campo cod = valorAlto
    leer(det,regd);

    //Si hay registros detalles, actualizan un registro maestro, leer el primer registro maestro (seguro existe)
    if(regd.cod <> valorAlto) then read(mae,regm);

    //Mientras haya registros detalle
    while(regd.cod <> valorAlto) do begin
      
        //Salvar el codigo del registro detalle actual
        codAct := regd.cod;


        //Leer registros maestros hasta encontrar el eregistro que debe ser actualizado
        while(regm.cod <> codAct) do read(mae,regm);


        //Mientras sean ventas del mismo producto
        while(codAct = regd.cod) do begin
            //Actualizar el stock 
            regm.stockDisp -= regd.cant_vendida;
            
            //Leer siguiente registor detalle
            leer(det,regd);
        end;

        //Ubicarse en la posicion del registro maestro a actualizar, escribir el registro actualizado
        seek(mae,FilePos(mae) - 1);
        write(mae,regm);

        //si aun hay registros detalle, leer siguiente reg maestro
        if(regd.cod <> valorAlto) then read(mae,regm);

    end;


    close(det);
    close(mae);

end;
procedure ListarStockMinimo(var mae: archivo_maestro);
var
    arc_txt : archivo_texto;
    regm: producto_maestro;
begin
    //Abrir archivo maestro
    Reset(mae);

    //Assign y creacion del archivo de texto
    Assign(arc_txt,'stock_minimo.txt');
    Rewrite(arc_txt);

    //Mientras haya regs maestro: Leer un reg maestro, si el stock esta debajo del minimo, escribir su informacion en el archivo de texto
    while(not(EOF(mae))) do begin
        read(mae,regm);
        with regm do if(stockDisp < stockMin) then writeln(arc_txt,cod,' ',precio:2:2,' ',stockDisp,' ',stockMin,' ',nom);
    end;

    //Cerrar archivos
    close(mae);
    close(arc_txt);
end;

var

    arc_mae: archivo_maestro;
    arc_det: archivo_detalle;

    opc: integer;
begin



    repeat
        writeln('Ingrese una opcion');
        writeln('-***-');
        writeln('1- Crear archivo maestro a partir del txt "productos.txt"');
        writeln('2- Listar el contenido del archivo maestro a un archivo de texto "reporte.txt"');
        writeln('3- Crear un archivo detalle a partir de un archivo de texto "ventas.txt"');
        writeln('4- Listar el contenido del archivo detalle en pantalla');
        writeln('5- Actualizar el archivo maestro con el contenido del archivo detalle');
        writeln('6- Listar los productos cuyo stock se encuentre por debajo del minimo, en un archivo de texto "stock_minimo.txt"');
        writeln;
        writeln('0- Salir');

        readln(opc);


        case(opc) of
            1: CrearMaestro(arc_mae);

            2: ListarContenidoMaestro(arc_mae);

            3: CrearDetalle(arc_det);

            4: ListarDetalle(arc_det);

            5: ActualizarMaestro(arc_mae,arc_det);

            6: ListarStockMinimo(arc_mae);

            7: ListarMaestro(arc_mae);

        end;
        
    
    until(opc = 0);

end.