program EJ16;
uses SysUtils;
{
                    PRECONDICIONES


        1*  EXISTE UN ARC MAESTRO DE SEMANARIOS

        2*  SE RECIBEN 100 DETALLES SOBRE SUS VENTAS

        3*  DEBE ACTUALIZARSE EL ARCHIVO MAESTRO CON LOS DATOS DEL ARCHIVO DETALLE

        4*  LOS ARCHIVOS ESTAN ORDENADOS POR FECHA Y CODIGO DE SEMANARIO

        5*  NO SE REALIZAN VENTAS DE SEMANARIOS SI NO HAY EJEMPLARES SUFICIENTES --> (LOS SEMANARIOS VENDIDOS DEL DETALLE SEGURO EXISTEN EN LOS REG MAESTRO Y LOS MODIFICAN)
}
const
    dimF = 100;
    valorAlto = '-9XD9';
type

    str6 = string[6];
    str33 = string[33];

    emision = record
        fecha: str6;
        cod, totEjemplares, totVendido: integer;
        nom, desc: str33;
        precio : real;
    end;

    venta = record
        fecha : str6;
        cod, cantVendidos: integer;
    end;


    //Declarar tipos archivo maestro y detalle
    maestro = file of emision;
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
        dato.fecha := valorAlto;
end;
{   --RECIBE UN VECTOR DE REGISTROS Y RETORNA EL MINIMO POR FECHA Y COD, EN EL PARAMETRO MIN.
    --ACTUALIZA Y RETORNA EL VECTOR DE REGISTROS LEYENDO EL SIGUIENTE DATO DEL DETALLE CORRESPONDIENTE    }
procedure minimo(var regs: vec_reg; var dets: vec_det; var min: venta);
var
    minPos, i : integer;
begin

    minPos := 0;

    min.fecha := valorAlto;
    min.cod := 9999;

    //Recorrer los reg detalle, consiguiendo la posicion del minimo
    for i := 1 to dimF do begin
        if(regs[i].fecha <= min.fecha) then begin
            if(regs[i].cod <= min.cod) then begin
                min := regs[i];
                minPos := i;
            end; 
        end;
    end;


    //Leer en el archivo detalle correspondiente, almacenar el siguiente registro en el vector de reg
	if (minPos <> 0) then
		leerDet(dets[minPos], regs[minPos]);
end;

procedure ActualizarMaestro(var mae: maestro; var dets: vec_det; var regs: vec_reg);
var
    regm, semMasVendido, semMenosVendido: emision;

    min: venta;

    maxVentas, minVentas, totVentas, codAct, i: integer;

    fechaAct: str6;      
begin
    
    maxVentas := -1;
    minVentas := 29999;

    reset(mae);

    //assign apertura y lectura de arc detalle
    for i := 1 to dimF do begin
        assign(dets[i],'det ' + IntToStr(i));
        reset(dets[i]);
        leerDet(dets[i],regs[i]);
    end;


    minimo(regs,dets,min);

    //Leer el primer registro maestro
    if(not(eof(mae))) then read(mae,regm);


    while(min.fecha <> valorAlto) do begin

        fechaAct := min.fecha;



        while(fechaAct = min.fecha) do begin
            
            codAct := min.cod;

            //Resetear contador de ventas 
            totVentas := 0;

            //Mientras el semanario del regmaestro no corresponda con el detalle, avanzar en el arc maestro 
            while(regm.cod <> min.cod) do read(mae,regm);


            while((fechaAct = min.fecha) and (codAct = min.cod)) do begin
                
                //Contabilizar las ventas de este semanario
                totVentas += min.cantVendidos;

                //Actualizar las ventas y ejemplares en los registros maestro
                regm.totVendido += min.cantVendidos;
                regm.totEjemplares-= min.cantVendidos;

                //Leer el siguiente registro minimo de los detalles
                minimo(regs,dets,min);
            end;

            //Actualizar los maximos y minimos si corresponde
            if(totVentas > maxVentas) then begin
                maxVentas := totVentas;
                semMasVendido := regm;
            end; 

            if(totVentas < minVentas) then begin
                minVentas := totVentas;
                semMenosVendido := regm;
            end;


            //Actualizar maestro
            seek(mae,filepos(mae) - 1);
            write(mae,regm);

            //Leer siguiente registro maestro
            if(not(eof(mae))) then read(mae,regm);
        end;

    end;

    //Informar
    writeln('El semanario mas vendido: ', semMasVendido.nom,'   Fecha: ',semMasVendido.fecha);
    writeln('El semanario menos vendido: ', semMenosVendido.nom,'   Fecha: ',semMenosVendido.fecha);

    //Cerrar archivos
    close(mae);
    for i := 1 to dimF do close(dets[i]);

end;

var
    //Declarar var vector de registros detalle

    regs : vec_reg;

    mae: maestro;

    dets : vec_det;
begin

    assign(mae,'maestro');

    ActualizarMaestro(mae,dets,regs);
    

end.