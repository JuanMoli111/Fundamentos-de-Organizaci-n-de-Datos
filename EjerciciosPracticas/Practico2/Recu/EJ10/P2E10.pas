program ej10;

{
                PRECONDICIONES

            *   1-  SE TIENE UN ARCHIVO DE EMPLEADOS 

            *   2-  EL ARCHIVO ORDENADO POR DEPARTAMENTO, POR DIVISION Y NUMERO DE EMPLEADO

            *   3-  DEBE GENERARSE UN REPORTE DEL TOTAL DE HORAS EXTRA Y MONTO A PAGAR PARA CADA EMPLEADO, SEGUN SU CARGO O CATEGORIA

            *   4-  LOS DATOS SOBRE EL VALOR DE CADA HORA POR CATEGORIA SE ENCUENTRAN EN UN ARCHIVO DE TEXTO Y DEBEN IMPORTARSE A UN ARREGLO

        SUPOSICIONES

        *   SEGUN ENUNCIADO EL ARCHIVO CONTIENE LAS HORAS EXTRAS REALIZADAS POR EMPLEADOS EN UN MES
            SUPONDRE QUE CADA EMPLEADO APARECE UNA UNICA VEZ CON EL TOTAL DE SUS HORAS (CADA COD DE EMPLEADO APARECE UNA UNICA VEZ)


    PD: no tiene mucho sentido definirlo como maestro en la declaracion de variables por que no hay operaciones de maestro-detalle pero bue quedo asi
}

const

    dimF =  15;
    valorAlto = 999;

type


    empleado = record
        depto, divi, cod, categoria, horas: integer;
    end;

    //Declarar tipo archivo
    archivo = file of empleado;

    //Declarar un tipo arreglo de reales
    vec_reales = array[1..dimF] of real;

//Leer el siguiente registro del archivo, si es EOF devolver un valor de corte
procedure leer(var arc: archivo; var dato: empleado);
begin
    if(not(eof(arc))) then
        read(arc,dato)
    else
        dato.depto := valorAlto;
end;

procedure importarHorasExtra(var vec: vec_reales);
var
    texto: text;
    i, aux: integer;

    valor: real;
begin
    //Assign y abrir el archivo de texto
    assign(texto,'categorias.txt');
    reset(texto);

    for i := 1 to dimF do begin
        //Importar a la variable valor, el valor de cada categoria
        readln(texto,aux,valor);

        //Guardar el valor de hora de cada categoria en el vector
        vec[i] := valor;
    end;


    //Cerrar el archivo
    close(texto);
end;
var
    vec_cat : vec_reales;
    maestro : archivo;

    e: empleado;

    cobro, montoDepto, montoDiv : real;

    //Declarar var de control y totalizadores
    deptoAct, divAct, totDepto, totDiv: integer;

begin

    //Importar el valor por hora de las categorias, a un vector de reales
    importarHorasExtra(vec_cat);

    //Assign y apertura del archivo 
    assign(maestro,'maestro');
    reset(maestro);

    //Leer el primer reg del archivo
    leer(maestro,e);

    //Mientras haya registros en el archivo de empleados
    while(e.depto <> valorAlto) do begin

        //Inicializar var de control y totalizadores
        deptoAct   := e.depto;
        totDepto   := 0;
        montoDepto := 0;


        writeln('Departamento ',deptoAct);


        //Mientras el departamento sea el mismo
        while(e.depto = deptoAct) do begin

            //Inicializar var de control y totalizadores por division
            divAct   := e.divi;
            totDiv   := 0;
            montoDiv := 0;

            writeln('Division ',divAct);

            writeln('Numero de empleado     Total de hs     Monto a cobrar');

            //Mientras la division sea la misma
            while((e.divi = divAct) and (e.depto = deptoAct)) do begin

                //Calcular el monto a cobrar para el empleado actual, segun su categoria y cantidad de horas extra
                cobro := (e.horas * vec_cat[e.categoria]);

                //Informar los datos con el formato requerido
                writeln(e.cod,'                 ',e.horas,'     ',cobro:2:2);

                //Totalizar las horas por division y departamento
                totDiv    += e.horas;
                totDepto  += e.horas;

                //Totalizar el monto por division y departamento
                montoDiv   += cobro;
                montoDepto += cobro;

                //Leer siguiente registro empleado
                leer(maestro,e);
            end;


            writeln('Total de horas por division: ', totDiv);
            writeln('Monto total por division: ', montoDiv:2:2);

        end;

        writeln('Total de horas por departamento: ', totDepto);
        writeln('Monto total por departamento: ', montoDepto:2:2);


    end;

    close(maestro);

end.

