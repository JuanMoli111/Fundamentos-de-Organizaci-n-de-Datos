program ej4;
uses SysUtils;
    {               
                PRECONDICIONES


                *   1- EXISTEN CINCO ARCHIVOS DETALLE Y DEBE GENERARSE UN ARCHIVO MAESTRO A PARTIR DE ESTOS

                *   2- LOS ARCHIVOS DETALLE ORDENADOS POR CODIGO DE USUARIO Y FECHA

                *   3- UN USUARIO PUEDE INICIAR MAS DE UNA SESION EN EL DIA EN LA MISMA O DISTINTAS MAQUINAS

                    (OSEA PUEDE APARECER 0 O N VECES EN 0 A 5 DE LOS ARCHIVOS DETALLES,  )  -->     Aplicando el proceso minimo, esto nos da igual pues manejamos los detalles como si fueran un unico archivo aprovechando que seguro estan ordenados

                *   4- EL MAESTRO DEBE TOTALIZAR EL TIEMPO DE LAS SESIONES POR USUARIO

    }

const

    dimF = 5;
    valorAlto = -9999;

type


    sesion = record
        cod: integer;
        fecha : string[6];  //AAMMDD    AÑO MES DIA
        tiempo : real;
    end;

    arc_sesiones = file of sesion;

    vec_detalles = array [1..dimF] of arc_sesiones;

    vec_reg_det = array[1..dimF] of sesion;

var
    vec_det : vec_detalles;
    vec_reg : vec_reg_det;

    maestro : arc_sesiones;

    i: integer;
    str : string;

//DEVOLVER SIGUIENTE REGISTRO DE UN ARCHIVO, SI ES EOF DEVOLVER UN VALOR DE CORTE
procedure leerDet(var arc: arc_sesiones; var dato: sesion);
begin
    if(not(eof(arc))) then
        read(arc,dato)
    else
        dato.cod := valorAlto;
end;    

{   --RECIBE UN VECTOR DE REGISTROS Y RETORNA EL MINIMO POR CODIGO DE USUARIO Y FECHA, EN EL PARAMETRO MIN.
    --ACTUALIZA Y RETORNA EL VECTOR DE REGISTROS LEYENDO EL SIGUIENTE DATO DEL DETALLE CORRESPONDIENTE    }
procedure minimo(var vec_reg: vec_reg_det; var min: sesion);
var
    minPos, i : integer;
begin

    //Recorrer los reg detalle, consiguiendo la posicion del minimo
    for i := 1 to dimF do begin
        if((vec_reg[i].cod < min.cod) or ((vec_reg[i].cod < min.cod) and (vec_reg[i].fecha < min.fecha))) then minPos := i;
    end;
    //El registro minimo es el que esta en la posicion minPos 
    min := vec_reg[minPos];

    //Leer en el archivo detalle correspondiente, almacenar el siguiente registro en el vector de reg
    leerDet(vec_det[minPos],vec_reg[minPos]);
end;
{   GENERAR ARC MAESTRO TOTALIZANDO LOS TIEMPOS DE LAS SESIONES DE LOS ARCHIVOS DETALLE}
procedure generarMaestro(var vec_reg: vec_reg_det; var arc_mae: arc_sesiones);
var
    min, regm: sesion;
    codAct: integer;
    fechaAct: string[6];
    totTiempo : real;
begin


    //Assign y creacion del maestro
    assign(arc_mae, 'maestro');
    rewrite(arc_mae);


    //Calcular el reg minimo 
    minimo(vec_reg,min);

    //Mientras haya sesiones en los arc detalle
    while(min.cod <> valorAlto) do begin

        codAct := min.cod;

        //El reg maestro copia los datos del min    (LOS REGISTROS SON DEL MISMO TIPO SINO NO ES POSIBLE LA ASIGNACION)
        regm := min;

        //Mientras sea el mismo usuario...
        while(codAct = min.cod)do begin

            fechaAct := min.fecha;
            totTiempo := 0;

            //Mientras sea la misma fecha, Totalizar el tiempo de sesion que tuvo el usuario en esta fecha
            while(fechaAct = min.fecha) do begin

                totTiempo += min.tiempo;

                minimo(vec_reg,min);
            end;
                
            //Guardar en el registro el tiempo total de la sesiones del usuario
            regm.tiempo := totTiempo;

            //Escribir el registro al archivo maestro
            write(arc_mae,regm);

        end;

    end;

    close(arc_mae);
end;
//PROGRAMA PRINCIPAL
begin

    //Assign y apertura de los 5 archivos detalle
    for i := 1 to dimF do begin

        assign(vec_det[i],'det' + IntToStr(i));
        rewrite(vec_det[i]);
    
        //Guarda el primer registro de cada detalle en la iésima posicion del vector de registros de ventas
        leerDet(vec_det[i],vec_reg[i]);

    end;


    generarMaestro(vec_reg,maestro);


    //Cerrar archivos detalle
    for i := 1 to dimF do close(vec_det[i]);

end.
    