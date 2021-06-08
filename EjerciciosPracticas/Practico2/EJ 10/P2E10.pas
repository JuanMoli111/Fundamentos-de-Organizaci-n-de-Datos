program P2E10;

    //PRECONDICIONES:

    //  -ARCH MAESTRO EXISTE Y TIENE DATA
    //  -DEBEMOS INFORMAR LA DATA (HORAS EXTRAS DE LOS EMPLEADOS)
    //  -EL ARCHIVO MAESTRO ORDENADO POR DEPTO, LUEGO POR DIVISION, LUEGO POR NRO DE EMPLEADO

    //  -CARGAR UN ARREGLO DESDE UN ARCHIVO ARREGLO.TXT EXISTENTE.
    //      DEBE HACERSE AL INICIO DEL PROGRAMA. EL ARREGLO, TENDRÁ QUINCE ELEMENTOS
    //      DE TIPO REGISTRO, CON DOS CAMPOS: NRO DE CATEGORIA Y VALOR DE LA HORA.
    

const
    valorAlto = -9999;
    cantE = 15;
type
//DECLARACION DE TIPOS

    range15 = 1..cantE;

    str15 = string[15];

    //INFO EMPLEADO TIENE EL DEPARTAMENTO, DIVISION Y NRO DE EMPLEADO
    //CAT ES LA CATEGORIA DEL EMPLEADO DEL 1 AL 15 CADA UNA TIENE UN VALOR X HORA TRABAJADA
    info_empleado = record
        depto, division, nro: integer;
        cat: range15;
        horas_extra: real;
    end;

    //Declara el tipo para el archivo maestro de registros info_empleados
    arc_info_empleado = file of info_empleado;

    //arreglo donde almacenaremos los valores de las horas segun categoria
    arreglo_horas = array[1..cantE] of integer;

//PROCEDURE leer archivo maestro de registros_info empleado sin errores de EOF
procedure leer(var arc_maestro: arc_info_empleado; var dato: info_empleado);
begin
    if(not(eof(arc_maestro))) then
        read(arc_maestro,dato)
    else begin
        dato.depto := valorAlto;
        dato.division := valorAlto;
        dato.nro := valorAlto;
    end;
end;

//Procedimiento cargar arreglo desde el archivo TXT 
procedure CargarArreglo(var arcArregloTxt: text; var arr_horas: arreglo_horas);
var
    i: integer;
begin
    //Assign y apertura del archivo TXT
    assign(arcArregloTxt,'arreglo.txt');
    reset(arcArregloTxt);

    //Tenemos la garantia de q hay 15 lineas en el archivo .txt por PRECONDICION
    for i := 1 to cantE do readln(arcArregloTxt,arr_horas[i], arr_horas[i]);

    //Cerrar archivo de texto
    close(arcArregloTxt);
end;


//DECLARACION DE VARIABLES
var
    //Nombre logico del arch maestro de informacion de las horas extra de los empleados
    arc_maestro : arc_info_empleado;

    //Nombre logico del archivo txt del que cargaremos un arreglo con valores de las horas trabajadas para cada categoria 
    arregloTxt : text;

    //Arreglo de enteros donde cargaremos el valor de las horas trabajadas segun cada categoria
    arregloHoras: arreglo_horas;

    //registro de tipo infoempleado
    info_emp : info_empleado;

    //Contadores totales de horas y monto por division, y de horas y monto por departamento.
    //MontoEmp guardara el monto que se le debe al empleado
    totHorasDiv, totMontoDiv, totHorasDto, totMontoDto, montoEmp: real;

    //Depto, division y nro de empleado, ACTUAL, variable auxiliares para los cortes de control
    deptoAct, divAct, nroAct: integer;

begin
    //Cargamos los valores de las horas trabajadas segun la categoria de empleado, en un arreglo de 15 enteros
    CargarArreglo(arregloTxt,arregloHoras);

    //Assign y apertura del archivo maestro
    assign(arc_maestro,'maestro');
    reset(arc_maestro);

    //Lee el primer registro del arch maestro
    leer(arc_maestro,info_emp);

    //Mientras haya informacion en el archivo maestro
    while(info_emp.depto <> valorAlto) do begin

        with info_emp do begin
            deptoAct := depto;
            divAct := division;
            nroAct := nro;
        end;

        //IMPRIMIR CON FORMA DE LISTA
        writeln('Departamento           ',deptoAct);

        //Reiniciar los contadores totales por departamento
        totHorasDto := 0;       totMontoDto := 0;

        while(info_emp.depto = deptoAct) do begin

            //Informar en forma de lista
            writeln('Divison            ',divAct);

            //Reiniciar los contadores totales por division
            totHorasDiv := 0;   totMontoDiv := 0;

            while((info_emp.depto = deptoAct) and (info_emp.division = divAct)) and do begin

                //Informar en forma de lista    
                writeln('Numero de Empleado     Total de Hs.    Importa a cobrar');


                while((info_emp.depto = deptoAct) and (info_emp.division = divAct) and (info_emp.nro = nroAct)) do begin


                    //El importe a cobrar es la cat del empleado por el valor q haya en el arreglo, en la pos categ del empleado
                    with info_emp do begin
                        //Calcular el monto a pagar y guardarlo en la variable montoEmp
                        montoEmp := horas_extra * arregloHoras[cat];

                        //Informar en forma de lista
                        writeln(nro,'           ',horas_extra:2:2,'         ',montoEmp:2:2);
                        
                        //Sumar a los contadores
                        totHorasDiv += horas_extra;
                        totMontoDiv += montoEmp;
                        totHorasDto += horas_extra;
                        totMontoDto += montoEmp;

                    end;

                    //Leer el siguiente regsitr info_emp
                    leer(arc_maestro,info_emp);
                end;


            end;

            //Informar
            writeln('Total de horas division: ',totHorasDiv:2:2);
            writeln('Monto total por divison: ',totMontoDiv:2:2);

        end;
        
        //Informar
        writeln('Total de horas departamento: ',totHorasDto:2:2);
        writeln('Monto total por departamento: ',totMontoDto:2:2);
    end;

    //Cerrar archivo maestro
    close(arc_maestro);

end.