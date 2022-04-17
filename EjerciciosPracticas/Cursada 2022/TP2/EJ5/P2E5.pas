program P2E5;
const
    cant_detalles = 50;
    valorAlto = 9999;
type

    str25 = string[25];


    //Tipo registro de datos de nacimientos
    nacimiento_det = record
        nro_partida, matricula_medico: integer;
        nombreCompleto, nombreMadre, nombrePadre : str25;
        dniMadre, dniPadre : longint;
        dir : string[50];
    end;


    //Tipo registro de datos de defunciones
    defuncion_det = record
        nro_partida, matricula_med_firmante : integer;

        nombreCompleto, lugar: str25;
        dni, fechaHora : longint;
    end;


    //Tipo registro maestro que acumula la informacion de las personas
    reg_maestro = record
        nro_partida, matricula_medico, matricula_med_firmante : integer;
        nombreCompleto, nombreMadre, nombrePadre, lugar: str25;
        dniMadre, dniPadre, fechaHora: longint;
        dir: string[50];
    end;

    //Tipos archivo
    archivo_nacimientos_detalle = file of nacimiento_det;
    archivo_defunciones_detalle = file of defuncion_det;

    archivo_maestro = file of reg_maestro;

    //vector de archivos
    vec_arch_nac = array[1..cant_detalles] of archivo_nacimientos_detalle;
    vec_arch_def = array[1..cant_detalles] of archivo_defunciones_detalle;

    //vector de registros
    vec_reg_nac = array[1..cant_detalles] of nacimiento_det;
    vec_reg_def = array[1..cant_detalles] of defuncion_det;

procedure leerNacimiento(var det : archivo_nacimientos_detalle; var dato: nacimiento_det);
begin
    if(not(EOF(det))) then
        read(det,dato)
    else
        dato.nro_partida := valorAlto;
end;

procedure leerDefuncion(var det: archivo_defunciones_detalle; var dato: defuncion_det);
begin
    if(not(EOF(det))) then
        read(det,dato)
    else
        dato.nro_partida := valorAlto;
end;

procedure nacimientoMinimo(var vec_det : vec_arch_nac; var vec_reg: vec_reg_nac; var min: nacimiento_det);
var
    pos, i: integer;
begin
    //Setea el num de partida en valorAlto para conseguir el minimo
    min.nro_partida := valorAlto;

    //Recorriendo el vector de registros
    for i := 1 to cant_detalles do begin

        //Si un registro tiene menor num de partida, actualizar pos y actulizar el nuevo minimo
        if(vec_reg[i].nro_partida < min.nro_partida) then begin
            pos := i;
            min := vec_reg[i];
        end;
    end;

    //Si el nro de min NO es valor alto, significa q se encontro un nuevo minimo, se debe leer el archivo correspondiente para avanzar y obtener el siguiente registro, salvarlo en el vector de registros
    if(min.nro_partida <> valorAlto) then leerNacimiento(vec_det[pos],vec_reg[pos]);

end;

procedure defuncionMinimo(var vec_det : vec_arch_def; var vec_reg: vec_reg_def; var min: defuncion_det);
var
    pos, i: integer;
begin
    //Setea el num de partida en valorAlto para conseguir el minimo
    min.nro_partida := valorAlto;

    //Recorriendo el vector de registros
    for i := 1 to cant_detalles do begin

        //Si un registro tiene menor num de partida, actualizar pos y actulizar el nuevo minimo
        if(vec_reg[i].nro_partida < min.nro_partida) then begin
            pos := i;
            min := vec_reg[i];
        end;
    end;

    //Si el nro de min NO es valor alto, significa q se encontro un nuevo minimo, se debe leer el archivo correspondiente para avanzar y obtener el siguiente registro, salvarlo en el vector de registros
    if(min.nro_partida <> valorAlto) then leerDefuncion(vec_det[pos],vec_reg[pos]);

end;

procedure GenerarMaestroListarTxt(var mae: archivo_maestro; var vec_det_nac : vec_arch_nac; var vec_det_def : vec_arch_def);
var

    vec_nac : vec_reg_nac;
    vec_def : vec_reg_def;

    min_nac: nacimiento_det;
    min_def: defuncion_det;

    nroAct, i: integer;

    regm: reg_maestro;

    arc_txt : text;

begin
  
    //Assign y creacion del archivo maestro
    Assign(mae,'maestro');
    Rewrite(mae);

    //Assign y creacion del archivo txt
    Assign(arc_txt,'datos_personas.txt');
    Rewrite(arc_txt);

    //Abrir los 50 archivos detalle y leer su primer registro
    for i := 1 to cant_detalles do begin
        reset(vec_det_nac[i]);
        reset(vec_det_def[i]);

        leerNacimiento(vec_det_nac[i],vec_nac[i]);
        leerDefuncion(vec_det_def[i],vec_def[i]);
    end;


    //Conseguir el regs minimo tanto de nacimientos como defunciones
    nacimientoMinimo(vec_det_nac,vec_nac,min_nac);
    defuncionMinimo(vec_det_def,vec_def,min_def);


    //mientras haya registros nacimiento:
    while(min_nac.nro_partida <> valorAlto) do begin

        //Cargar al registro maestro, el nro partida, nombre completo suyo y de sus padres, direccion detallada, dni de los padres y matricula del medico
        with regm do begin
            nro_partida := min_nac.nro_partida;
            nombreCompleto := min_nac.nombreCompleto;   nombreMadre := min_nac.nombreMadre;     nombrePadre := min_nac.nombrePadre;
            dir := min_nac.dir;
            dniMadre := min_nac.dniMadre;   dniPadre := min_nac.dniPadre;
            matricula_medico := min_nac.matricula_medico;

            //Escribir los datos al archivo de texto
            writeln(arc_txt,nro_partida,' ',nombreCompleto,' ',nombreMadre,' ',nombrePadre,' ',dir,' ',dniMadre,' ',dniPadre,' ',matricula_medico,' ');
        end;


        //Si los nros de partida coinciden es la misma persona y fallecio.
        if(min_nac.nro_partida = min_def.nro_partida) then begin

            //Cargar los datos de defuncion al registro maestro
            with regm do begin
                matricula_med_firmante := min_def.matricula_med_firmante;
                fechaHora := min_def.fechaHora;
                lugar := min_def.lugar;

                //Escribir los datos de defuncion al archivo txt
                write(arc_txt,matricula_med_firmante,' ',fechaHora,' ',lugar,' ');
            end;
           
            //conseguir la siguiente defuncion minima
            defuncionMinimo(vec_det_def,vec_def,min_def);
        end
        else begin

            //Setear datos de defuncion del registro maestro en nulo 
            with regm do begin
                matricula_med_firmante := -1;
                fechaHora := -1;
                lugar := 'None';
            end;

        end;

        //Seguro necesito un nuevo registro nacimiento --> buscar el minimo
        nacimientoMinimo(vec_det_nac,vec_nac,min_nac);

        //Cargar los datos al archivo maestro
        write(mae,regm);

    end;


    //Cerrar archivos maestro, archivo de texto, y archivos detalle
    close(mae);     close(arc_txt);

    for i := 1 to cant_detalles do begin
        close(vec_det_nac[i]);
        close(vec_det_def[i]);
    end;


end;

var
    arc_mae: archivo_maestro;

    vec_detalles_nacimientos : vec_arch_nac;
    vec_detalles_defunciones : vec_arch_def;

    reg_nac : nacimiento_det;
    reg_def : defuncion_det;


    i : integer;

    strAssign: string[5];

begin

    for  i := 1 to cant_detalles do begin
        Str(i,strAssign);

        Assign(vec_detalles_nacimientos[i],'det_nac' + strAssign);
        Assign(vec_detalles_defunciones[i],'det_def' + strAssign);

        Rewrite(vec_detalles_nacimientos[i]);
        Rewrite(vec_detalles_defunciones[i]);


        Close(vec_detalles_nacimientos[i]); Close(vec_detalles_defunciones[i]);
    end;


    GenerarMaestroListarTxt(arc_mae,vec_detalles_nacimientos,vec_detalles_defunciones);

    recorrerMaestro(arc_mae);

end.