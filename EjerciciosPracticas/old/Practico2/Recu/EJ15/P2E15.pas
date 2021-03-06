program Ej15;

uses SysUtils;
{

                        PRECONDICIONES


        1   *- EXISTE UN ARCHIVO CON INFODE ALUMNOS INSCRIPTOS A CARRERAS DE LA FACULTAD DE CIENCIAS JURIDICAS, Y DEL TOTAL PAGADO DE SU CARRERA

        2   *- SE RECIBEN n ARCHIVOS CON INFORMACION DE PAGOS REALIZADOS A LA FACULTAD POR TALES ALUMNOS, MEDIANTE RAPIPAGO

        3   *- CADA ARCHIVO REUNE INFORMACION DE n SUCURSALES, CADA SUCURSAL PUEDE REGISTRAR 0 a n PAGOS

        4   *- CADA ALUMNO PUEDE PAGAR MAS DE UNA CUOTA EL MISMO DIA, OSEA UN MISMO ALUMNO PUEDE REALIZAR 0 A n PAGOS EL MISMO DIA

        5   *- UN PROCEDIMIENTO DEBE ACTUALIZAR LA INFORMACION DE LOS ALUMNOS Y SU TOTAL PAGO, CON LOS n ARCHIVOS RECIBIDOS EN EL DIA

        5   *- CADA ALUMNO PUEDE ESTAR INSCRIPTO EN UNA O VARIAS CARRERAS (PUEDE APARECER 0 O n VECES EN EL MAESTRO)

        6   *- TODOS LOS ARCHIVOS ORDENADOS POR DNI, LUEGO POR CODIGO_CARRERA

        7   *- EN LOS ARC DE PAGOS DE RAPIPAGO HAY INFO SOBRE ALUMNOS QUE SEGURO EXISTEN EN EL ARCHIVO DE INSCRIPTOS
    
}
const
    
    dimF = 5;

    valorAlto = -9999;
type


    inscripto = record
        dni, cod : integer;
        monto: real;
    end;


    //La representacion es la misma, razón de que pueden usarse el mismo tipo de reg
    //tanto para mae como para detalle y no definir un registro extra
    pago = record
        dni, cod: integer;
        monto: real;
    end;

    //Declarar tipos archivo maestro y detalle
    maestro = file of inscripto;
    detalle = file of pago;


    //Declarar tipos arreglo para el manejo de multiples archivos y registros detalle
    vec_det = array[1..dimF] of detalle;
    vec_reg = array[1..dimF] of pago;



//DEVOLVER SIGUIENTE REGISTRO DE UN ARCHIVO, SI ES EOF DEVOLVER UN VALOR DE CORTE
procedure leerDet(var det: detalle; var dato : pago);
begin
    if(not(eof(det))) then
        read(det,dato)
    else
        dato.dni := valorAlto;
end;


{   --RECIBE UN VECTOR DE REGISTROS Y RETORNA EL MINIMO POR DESTINO FECHA Y HORA, EN EL PARAMETRO MIN.
    --ACTUALIZA Y RETORNA EL VECTOR DE REGISTROS LEYENDO EL SIGUIENTE DATO DEL DETALLE CORRESPONDIENTE    }
procedure minimo (var regs: vec_reg; var detalle: vec_det; var min: pago);
var 
    i, posMin: integer;
begin
	posMin:= 0;
    
	min.dni := valoralto;
	min.cod := valorAlto;

	for i:=1 to dimF do begin
		if(regs[i].dni <= min.dni) then begin
			if (regs[i].cod <= min.cod) then begin
				min := regs[i];
				posMin := i;	
			end;
		end;
	end;

	if (posMin <> 0) then
		leerDet(detalle[posMin], regs[posMin]);
end;

procedure ActualizarMaestro(var mae: maestro; var dets: vec_det; var regs: vec_reg);
var
    regm: inscripto;
    min: pago;

    dniAct, codAct, i : integer;
begin
    //Abrir archivo maestro
    reset(mae);

    //Assign y apertura de archivos detalle, leer su primer registro. 
    for i := 1 to dimF do begin
        assign(dets[i], 'det ' + IntToStr(i));
        rewrite(dets[i]);

        leerDet(dets[i],regs[i]);
    end;

    //Leer registro maestro
    if(not(eof(mae))) then read(mae,regm);

    //Calcular el minimo de los regs detalle leidos
    minimo(regs,dets,min);


    //Mientras haya datos en los detalle
    while(min.dni <> valorAlto) do begin

        dniAct := min.dni;


        
        //Mientras siga siendo el mismo alumno
        while(dniAct = min.dni) do begin

            codAct := min.cod;

            //Mientras la carrera no sea la correcta avanzar en el archivo maestro
            while(dniAct <> regm.dni) do read(mae,regm);

            //Mientras el pago sea a la misma carrera
            while((dniAct = min.dni) and (codAct = min.cod)) do begin

                //Actualizar el reg maestro con los montos pagados a esta carrera, por este alumno
                regm.monto += min.monto;


                minimo(regs,dets,min);

            end;


            //Actualizar el archivo maestro
            seek(mae,filepos(mae) - 1);
            write(mae,regm);

            if(not(eof(mae))) then read(mae,regm);
        end;


    end;

    close(mae);

    for i := 1 to dimF do close(dets[i]);

end;


procedure GenerarTxt(var mae: maestro);
var
    texto : Text;

    regm: inscripto;
begin

    //Assign del arc de texto, crearlo y abrirlo
    assign(texto,'alumnosMorosos');
    rewrite(texto);

    //Abrir archivo maestro
    reset(mae);

    if(not(eof(mae))) then read(mae,regm);

    //Mientras haya regs en el maestro, importarlos al texto si los reg alumnos no han pagado nada aun
    while(not(eof(mae))) do with regm do if(monto = 0) then write(texto,dni,'     ',cod);

    //Cerrar archivo maestro
    close(mae);
end;
var

    dets : vec_det;
    regs : vec_reg;

    mae: maestro;
begin

    assign(mae,'maestro');
    rewrite(mae);



    ActualizarMaestro(mae,dets,regs);

    GenerarTxt(mae);

end.