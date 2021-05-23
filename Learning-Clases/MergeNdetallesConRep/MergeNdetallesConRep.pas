program union_de_archivos_III;
const 
    valorAlto = '9999';
    cantE = 100;
type 
    vendedor = record
        cod: string[4];               
        producto: string[10];         
        montoVenta: real;        
    end;

    ventas = record
        cod: string[4];                
        total: real;              
    end;

    maestro = file of ventas;
   
    arc_detalle= array[1..cantE] of file of vendedor;
    reg_detalle= array[1..cantE] of vendedor;

procedure leer(var archivo:detalle; var dato:vendedor);
begin
    if (not eof( archivo ))then 
        read (archivo, dato)
    else 
        dato.cod := valorAlto;
end;

//PRECODNICION A CONSIDERAR, TODOS LOS ARCHIVOS ORDENADOS POR COD DE VENDEDOR DE FORMA ASCENDENTE
//Minimo retorna, en el parámetro min, el vendedor con menor codigo del arreglo de archivos arc_deta, de longitud cantE 
procedure minimo(var arc_deta : arc_detalle; var reg_det: reg_detalle; var min: vendedor);
var
	i: integer;
begin
    i := 1;

    //Leer el primer registro del primer archivo detalle y guardarlo en la primer posicion del arreglo de registros
    leer(arc_deta[i],reg_detalle[i]);

    //Guardar este vendedor en min
    min = reg_detalle[i];     
	
    //Iterar la cantidad de archivos detalle que tengamos, hasta que i sea = cantE +1 o hasta que min tome el valorAlto (todos los arch se quedaron sin datos)
    while((i <= cantE) and (min <> valorAlto)) do begin

        //Si el codigo del vendedor actual es menor al cod del vendedor minimo, actualizar el vendedor minimo
        if(reg_detalle[i].cod < min.cod) then begin
            min := reg_detalle[i]

        //Incrementa i
        i += 1;

        //Leer el siguiente vendedor del iésimo archivo del arreglo de archivos, guardarlo en la iésima posición del arreglo de vendedores 
        leer(arc_deta[i],reg_detalle[i])
	end;

end;
var 
    //MIN ES UN REGISTRO VENDEDOR Y SIRVE DE VARIABLE AUXILIAR PARA CALCULAR EL VENDEDOR DE MENOR COD
    min: vendedor;

    //ARC_DETA ES UN ARREGLO DE CANTE ARCHIVOS DE VENDEDORES, CANTE ES 100 EN ESTE EJEMPLO
    arc_deta: arc_detalle;

    //REG_DET ES UN ARREGLO DE REGISTROS VENDEDOR, SIRVE PARA 
    reg_det: reg_detalle;

    //ARCHIVO MAESTRO, ES UN ARCHIVO DE VENTAS
    mae1: maestro;

    //REGM ES UN REGISTRO VENTAS
    regm: ventas;
    i, n: integer;

begin

    //Deta es un arreglo con los archivos detalle
    //reg_det es un arreglo con registros de tipo vendedor, ¿es un auxiliar para leer los vendedores del archivo detalle?

    //Iterar el arreglo de archivos, haciendo su assign y abriendolos 
    for i := 1 to cantE do begin

        assign(arc_deta[i], 'det' + str(i)); 
        
        reset(arc_deta[i]);
 
    end;

    //Assign del archivo maestro
    assign(mae1, 'maestro');
    //Crea y abre el archivo maestro
    rewrite(mae1);

    //Calcula el minimo
    minimo(arc_deta, reg_det, min);

    while (min.cod <> valorAlto) do begin
        //INICIALIZA UN REGISTRO VENTA CON EL COD DEL VENDEDOR MIN RECIBIDO DEL PROC MINIMO, INICIALIZA EL CAMPO TOTAL EN 0
        regm.cod := min.cod;
        regm.total := 0;

        //ITERA HASTA QUE EL CODIGO SEA DISTINTO, ACUMULANDO LAS VENTAS DE ESE VENDEDOR
        while (regm.cod = min.cod ) do begin
            regm.total := regm.total + min.montoVenta;

            //VUELVE A CALCULAR EL MINIMO
            minimo(arc_deta, reg_det, min);
        end;

        //SI TERMINA DE ITERAR YA CONTO TODAS LAS VENTAS DE UN VENDEDOR, GUARDAR LA VENTA TOTAL EN EL ARCHIVO MAESTRO
        write(mae1, regm);
    end;
    
    //CERRAR LOS ARCHIVOS ITERANDO EL ARREGLO DE ARCHIVOS
    for n := 1 to cantE do begin
        close(arc_deta[n]);

    //CIERRA EL ARCHIVO MAESTRO
    close(maestro)
 end.
