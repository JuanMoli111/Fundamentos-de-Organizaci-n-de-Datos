//En la facultad de Ciencias juridicas existe un sistema a traves del cual los alumnos
//del posgrado tienen la posibilidad de pagar las carreras en rapipago. Cuando el alumno se
//inscribe a una carrera, se le imprime una chequera con seis codigos de barra para qe pague
//las seis cuotas correspondientes, existe un archivo que guarda la siguiente informacion de
// los alumnos inscriptos : dni_alumno, codigo_carrera y monto_tal_pagado
//Todos los dias rapipago manda N archivos con informacioon de los pagos realizados
//por los alumnos en las N sucursales. Cada sucursal puede registrar cero, uno o mas pagos y un aluno puede pagar mas de una cuota el mismo dia
//Los archivos que mada RapiPago tiene la siguiente informacio: dni_alumno, codigo_carrera, monto_cuota
//a) se debe realizar un procedimiento que dado el archivo con inforacion de los alumnos
//inscriptos y los N archivos que envia rapipago, actualice la informacion de lo que ha pagado cada alumno
//hasta el momento en cada carrear inscripto
//b) Realice otro procedimiento que reciba el archivo con informacion de los alumnos
//inscriptos y genere un archivo de texto con los alumnos que aun no ha pagado nada en las
//carreras que estan inscriptos. El archivo de texto debe contener la siguiente
//informacion:  dni_alumno, codigo_carrera, y la leyenda 'alumno moroso'. La organizacion de la inforamcion
//del archivo de texto debe ser tal de poder utilizarla en una futura imporacion de datos realizando la cantidad
//minima de lecturas
//
//PRECONDICIONES:
//
//-CADA ALUMNO PUEDE ESTAR INCSRIPTO EN UNA O VARIAS CARRERAS
//
//-TODOS LOS ARCHIVOS ESTAN ORDENADOS, PRIMERO POR dni_alumno Y LUEGO POR codigocarrear
//
//-EN LOS ARCHIVOS QUE ENVIA RAPIPAGO HAY INFORMACION DE PAGOS DE ALUMNOS QUE  SIO SI EXISTEN EN EL ARCHIO DE INSCRIPTOS


program P2E15;
const
    valorAlto = -9999;
    N = 20;
type

    info_carrera_alumno = record
        dni, cod_carrera: integer;
        monto : real;
    end;

    info_carrera_rapi = record
        dni, cod_carrera: integer;
        monto_cuota : real;
    end;

    arc_alumnos = file of info_carrera_alumno;

    arc_rapi = file of info_carrera_rapi;


    vec_arc_rapi = array[1..N] of arc_rapi;

    vec_reg_rapi = array[1..N] of info_carrera_rapi;

var

    maestro : arc_alumnos;

    vec_detalles: vec_arc_rapi;

    vec_reg_det: vec_reg_rapi;


procedure leerMae(var arc: arc_alumnos; var dato: info_carrera_alumno);
begin
    if(not(eof(arc))) then
        read(arc,dato)
    else begin
        dato.cod_carrera := valorAlto;
        dato.dni := valorAlto;
    end;
end;

procedure leerDet(var arc: arc_rapi; var dato: info_carrera_rapi);
begin
    if(not(eof(arc))) then
        read(arc,dato)
    else begin
        dato.cod_carrera := valorAlto;
        dato.dni := valorAlto;
    end;
end;


procedure minimo(var vec_reg : vec_reg_rapi; var min: info_carrera_rapi);
var
    minPos, i : integer;
begin



    for i := 1 to cantE do begin
        if(vec_reg[i].dni < min.dni) or ((vec_reg[i].dni = min.dni) and (vec_reg[i].cod_carrera < min.cod_carrera))then minPos := i;
    end;

end;