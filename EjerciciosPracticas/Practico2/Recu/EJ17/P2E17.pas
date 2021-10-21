program ej17;
uses SysUtils;
{

                                PRECONDICIONES


            1*  -   EXISTE UN ARCHIVO DE VEHICULOS A LA VENTA

            2*  -   EXISTEN DOS ARCHIVOS DETALLE CON INFORMACION DE VENTAS DE LOS VEHICULOS

            3*  -   TODOS LOS ARCHIVOS ORDENADOS POR CODIGO DE VEHICULO

            4*  -   SE DEBE ACTUALIZAR EL STOCK EN EL ARCHIVO MAESTRO CON LA INFORMACION DE LAS VENTAS DEL DETALLE
}
const
    dimF = 2;
    valorAlto = 29999;
type


    str15 = string[15];
    str35 = string[35];
    str6 = string[6];


    vehiculo = record
        nombre, modelo: str15;
        desc: str35;
        cod, stock : integer;
    end;

    venta = record
        cod : integer;
        precio: real;
        fecha : str6;
    end;


    //Declarar tipos archivo maestro y detalle
    maestro = file of vehiculo;
    detalle = file of venta;


    //Declarar tipos arreglo para el manejo de multiples archivos y registros detalle
    vec_det = array[1..dimF] of detalle;
    vec_reg = array[1..dimF] of venta;



//DEVOLVER SIGUIENTE REGISTRO DE UN ARCHIVO, SI ES EOF DEVOLVER UN VALOR DE CORTE
procedure leerDet(var det: detalle; var dato : venta);
begin
    if(not(eof(det))) then
        read(det,dato)
    else
        dato.cod := valorAlto;
end;
{   --RECIBE UN VECTOR DE REGISTROS Y RETORNA EL MINIMO POR FECHA Y COD, EN EL PARAMETRO MIN.
    --ACTUALIZA Y RETORNA EL VECTOR DE REGISTROS LEYENDO EL SIGUIENTE DATO DEL DETALLE CORRESPONDIENTE    }
procedure minimo(var regs: vec_reg; var dets: vec_det; var min: venta);
var
    minPos, i : integer;
begin

    minPos := 0;

    min.cod := valorAlto;

    //Recorrer los reg detalle, consiguiendo la posicion del minimo
    for i := 1 to dimF do begin
        if(regs[i].cod <= min.cod) then begin
            min := regs[i];
            minPos := i;
        end;
    end;

    //El registro minimo es el que esta en la posicion minPos 
    min := regs[minPos];

    //Leer en el archivo detalle correspondiente, almacenar el siguiente registro en el vector de reg
	if (minPos <> 0) then
		leerDet(dets[minPos], regs[minPos]);
end;

procedure ActualizarMaestro(var mae: maestro; var dets: vec_det; var regs: vec_reg);
var
    regm, vehiMasVendido: vehiculo;

    min: venta;

    totVentas, maxVentas, codAct, i: integer;

begin

    reset(mae);

    for i := 1 to dimF do begin
        assign(dets[i],'det ' + IntToStr(i));
        reset(dets[i]);
        leerDet(dets[i],regs[i]);
    end;


    minimo(regs,dets,min);


    if(not(eof(mae)))then read(mae,regm);


    maxVentas := -1;

    while(min.cod <> valorAlto) do begin
        
        codAct := min.cod;

        totVentas := 0;

        //Recorrer maestro hasta encontrar el registro correspondiente al detalle
        while(codAct <> regm.cod) do read(mae,regm);


        //Mientras las ventas sean del mismo modelo de auto, actualizar su stock
        while(codAct = min.cod) do begin
            totVentas += 1;

            minimo(regs,dets,min);
        end;

        //Si fue el vehi mas vendido almacenarlo y actualizar el maximo
        if(totVentas > maxVentas) then begin
            maxVentas := totVentas;
            vehiMasVendido := regm;
        end;


        //Actualizar el stock en el registro maestro
        regm.stock -= totVentas;

        //Actualizar el archivo maestro
        seek(mae,filepos(mae) - 1);
        write(mae,regm);


        //Leer siguiente reg del maestro
        if(not(eof(mae))) then read(mae,regm);

    end;


    //Cerrar archivos
    close(mae);
    for i := 1 to dimF do close(dets[i]);


    with vehiMasVendido do writeln('El vehiculo mas vendido es un ',nombre,' modelo ',modelo);
end;

var
    mae: maestro;

    dets : vec_det;
    regs : vec_reg;


begin
    assign(mae,'maestro');


    ActualizarMaestro(mae,dets,regs);
end.