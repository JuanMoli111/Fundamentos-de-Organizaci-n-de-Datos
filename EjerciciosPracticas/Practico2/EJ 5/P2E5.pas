program P2E5;
const
    valorAlto = -9999;
    cantE = 50;
type

    str20 = string[20];

    direccion = record
        calle, ciudad : str20;
        nro, piso, depto : integer;
    end;

    // -1 y 2022 son valores de los rangos que se usan como nulo o valor invalido

    fecha = record
        dia : -1..31;
        mes : -1..12;
        anio: 2000..2022;
    end;



    hora = record
        horas : -1..23;
        minutos: -1..60;
    end;


    //Registro nacimiento
    nacimiento = record
        nroPartida, matricula,  dniMama,    dniPapa :   integer;
        nombre,     apellido,   nombreMama, apellidoMama,   nombrePapa,   apellidoPapa: str20;
        dir : direccion;
    end;

    //Registro fallecimiento
    fallecimiento = record
        nroPartida, dni, matricula,  dniMama,    dniPapa :   integer;
        nombre,     apellido, lugar: str20;
        dir : direccion;
        fecha : fecha;
        hora : hora;
    end;

    //Declara registro con los datos requeridos para el archivo maestro
    regMaestro = record
        nroPartida, matricula, matriculaDeceso, dniMama,    dniPapa :   integer;
        nombre,     apellido,   nombreMama, apellidoMama,   nombrePapa,   apellidoPapa, lugarDeceso: str20;
        dir : direccion;
        fecha: fecha;
        hora: hora;
    end;

    //Declara el tipo para archivo maestro
    arcMaestro = file of regMaestro;

    //Declara los tipos para los archivos de nacimientos y decesos
    arcNacimiento = file of nacimiento;
    arcFallecimiento = file of fallecimiento;

    //Declara arreglos de registros de cada tipo
    arr50Nacimientos = array[1..cantE] of nacimiento;
    arr50Fallecimientos = array[1..cantE] of fallecimiento;

    //Declara tipos arreglo con 50 archivos de cada tipo
    arr50ArcNacimientos = array[1..cantE] of arcNacimiento;
    arr50ArcFallecimientos = array[1..cantE] of arcFallecimiento;

//Procedure de lectura de archivos nacimiento, con valoralto de corte 
procedure leerDetNac(var arc_detalle : arcNacimiento; var dato: nacimiento);
begin
    if(not(eof(arc_detalle))) then
        read(arc_detalle,dato)
    else
        dato.nroPartida := valorAlto;
end;

//Procedure de lectura de archivos fallecimiento, con valoralto de corte 
procedure leerDetFall(var arc_detalle: arcFallecimiento;var dato: fallecimiento);
begin
    if(not(eof(arc_detalle))) then
        read(arc_detalle,dato)
    else
        dato.nroPartida := valorAlto;
end;

//Calcula el registro con menor codigo de un arreglo de cantE archivos de registros nacimiento, 
//lo retorna en min y retorna el índice del arreglo donde se encontró, se avanzará en el archivo de tal indice
//en el arreglo de archivos detalle, antes de volver a mandar el arreglo de registros y calcular el siguiente minimo
procedure minimoNacimientos(var arrNacimientos: arr50Nacimientos; var min : nacimiento; var minPos: integer);
var
	i: integer;
begin
    //Itera a traves del arreglo de registros
    for i := 1 to cantE do begin
        //Si el codigo del nacimiento actual es menor al cod sesion minimo, actualizar el nacimiento minimo
        if(arrNacimientos[i].nroPartida < min.nroPartida) then begin
            //Guarda la posicion donde está el min en el arreglo de nacimientos
            minPos := i;
        end;
    end;

    //Usa minPos para conseguir el elemento minimo, lo retorna en min
    min := arrNacimientos[minPos];

end;
//Calcula el registro con menor codigo de un arreglo de cantE archivos de registros fallecimiento, 
//lo retorna en min y retorna el índice del arreglo donde se encontró, se avanzará en el archivo de tal indice
//en el arreglo de archivos detalle, antes de volver a mandar el arreglo de registros y calcular el siguiente minimo
procedure minimoFallecimientos(var arrFallecimientos: arr50Fallecimientos; var min: fallecimiento; var minPos: integer);
var
	i: integer;
begin

    //Itera a traves del arreglo de registros
    for i := 1 to cantE do begin
        //Si el codigo de la sesion actual es menor al cod sesion minimo, actualizar la sesion minima
        if(arrFallecimientos[i].nroPartida < min.nroPartida) then begin
            //Guarda la posicion donde se encontró el minimo en minPos para retornarla
            minPos := i;
        end;
    end;

    //Usa minPos para conseguir el elemento minimo, lo retorna en min
    min := arrFallecimientos[minPos];

end;

//DECLARACION DE VARIABLES
var
    //Nombre logico para el archivo maestro
    arcMae : arcMaestro;

    //Arreglos con los 50 archivos detalle de cada tipo
    arrArcNac : arr50ArcNacimientos;
    arrArcFal : arr50ArcFallecimientos;

    //Arreglos con registros de cada tipo, auxiliares
    arrRegNac : arr50Nacimientos;
    arrRegFal : arr50Fallecimientos;

    //Registros aux
    nac_min : nacimiento;
    fal_min : fallecimiento;

    reg_mae : regMaestro;

    //Nro partida actual, indice
    nroPartAct, i, nacMinPos, falMinPos: integer;

    //Declara string util para los nombres fisicos de los archivos detalle
    strIndice : string;
begin

    //Apertura de archivos detalle, generamos arreglos de registros auxiliares
    for i := 1 to cantE do begin

        //Castea el entero i en un string lo guarda en strindice 
        Str(i,strIndice);

        //Assign de los archivos detalle
        assign(arrArcNac[i],'detNac' + strIndice);
        assign(arrArcFal[i],'detFal' + strIndice);

        //Apertura de los archivos detalle
        reset(arrArcNac[i]);
        reset(arrArcFal[i]);


        //Lee el iésimo registro de los 50 archivos nacimientos, 
        //lo guarda en la iésima posicion del arreglo de registros nacimiento
        leerDetNac(arrArcNac[i],arrRegNac[i]);
        //Lee el iésimo registro de los 50 archivos fallecimientos, 
        //lo guarda en la iésima posicion del arreglo de registros fallecimiento
        leerDetFall(arrArcFal[i],arrRegFal[i]);
    end;

    //Assign y creacion del archivo maestro
    assign(arcMae,'maestro');
    rewrite(arcMae);

    //Calcula los registros minimos, los retorna en naci_min y fall_min
    minimoNacimientos(arrRegNac,nac_min,nacMinPos);
    minimoFallecimientos(arrRegFal,fal_min,falMinPos);

    while(nac_min.nroPartida <> valorAlto)do begin

        //Hay un nuevo nacimiento generar un reg para el arc maestro con los datos por defecto de la persona (haya fallecido o no)
        with reg_mae do begin
            nroPartida := nac_min.nroPartida;
            nombre := nac_min.nombre;
            apellido := nac_min.apellido;
            matricula := nac_min.matricula;
            nombreMama := nac_min.nombreMama;
            apellidoMama := nac_min.apellidoMama;
            dniMama := nac_min.dniMama;
            nombrePapa := nac_min.nombrePapa;
            apellidoPapa := nac_min.apellidoPapa;
            dniPapa := nac_min.dniPapa;
        end;

        //SI EL NRO DE PARTIDA DEL NAC ES IGUAL AL DEL FALLECIMIENTO SIGNIFICA QUE ESTA PERSONA FALLECIO
        // Y LOS DATOS DEBEN ALMACENARSE, SINO DEJAR DATOS NO VALIDOS
        if(nac_min.nroPartida = fal_min.nroPartida) then begin

            //LA PERSONA FALLECIO, ALMACENAR LOS DATOS CORRESPONDIENTES DE SU DETALLE DE DEFUNCION
            with reg_mae do begin

                dir := fal_min.dir;
                matriculaDeceso := fal_min.matricula;
                fecha := fal_min.fecha;
                hora := fal_min.hora;
                lugarDeceso := fal_min.lugar;
            end;

            //Lee el iésimo registro de los 50 archivos fallecimientos, 
            //lo guarda en la iésima posicion del arreglo de registros fallecimiento, actualizándolo
            leerDetFall(arrArcFal[falMinPos],arrRegFal[falMinPos]);
            //Lee el iésimo registro de los 50 archivos nacimientos, 
            //lo guarda en la iésima posicion del arreglo de registros nacimiento, actualizándolo
            leerDetNac(arrArcNac[nacMinPos],arrRegNac[nacMinPos]);

            //Calcula los registros minimos, los retorna en naci_min y fall_min
            minimoNacimientos(arrRegNac,nac_min,nacMinPos);
            minimoFallecimientos(arrRegFal,fal_min,falMinPos);

        end
        else begin
            //LA PERSONA NO FALLECIO, DEJAR LOS CAMPOS NULOS O POR DEFECTO
            with reg_mae do begin
                dir := nac_min.dir;
                matriculaDeceso := -1;
                fecha.dia := -1;
                fecha.mes := -1;
                fecha.anio := 2022;
                hora.horas := -1;
                hora.minutos := -1;
                lugarDeceso := 'NONE';
            end;

            //Calcula el registro minimo, lo retorna en naci_min
            minimoNacimientos(arrRegNac,nac_min,nacMinPos);

            //Lee el iésimo registro de los 50 archivos nacimientos, 
            //lo guarda en la iésima posicion del arreglo de registros nacimiento, actualizándolo
            leerDetNac(arrArcNac[nacMinPos],arrRegNac[nacMinPos]);


        end;
        
        //Almacena el reg con datos de la persona, en el archivo maestro
        write(arcMae,reg_mae);



    end;

    //CIERRE DE ARCHIVOS

    for i := 1 to cantE do begin
        close(arrArcNac[i]);
        close(arrArcFal[i]);
    end;

    close(arcMae);

end.