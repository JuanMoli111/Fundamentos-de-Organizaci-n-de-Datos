program P2E15;
const
    valorAlto = 19998;
    cant_detalles = 5;
type



    inscriptos_maestro = record
        dni : longint;
        cod : integer;
        monto_pagado: real;
    end;

    pagos_detalle = record
        dni: longint;
        cod: integer;
        monto_cuota: real;
    end;

    archivo_maestro = file of inscriptos_maestro;
    archivo_detalle = file of pagos_detalle;

    //Declarar tipos vec de archivos y de registros detalle
    vector_archivos_detalle = array[1..cant_detalles] of archivo_detalle;
    vector_registros_detalle = array[1..cant_detalles] of pagos_detalle;


procedure leer(var det: archivo_detalle; var dato: pagos_detalle);
begin
    if(not(EOF(det))) then
        read(det,dato)
    else
        dato.dni := valorAlto; 
end;

procedure minimo(var vec_det: vector_archivos_detalle; var vec_reg: vector_registros_detalle; var min: pagos_detalle);
var
    pos, i: integer;
begin
    min.dni := valorAlto;

    for i := 1 to cant_detalles do begin
        
        //Si el reg del vector es menor al minimo, actualizar el minimo, salvar la pos
        if((vec_reg[i].dni < min.dni) or ((vec_reg[i].dni = min.dni) and (vec_reg[i].cod < min.cod))) then begin
            min := vec_reg[i];
            pos := i;
        end;

    end;

    if(min.dni <> valorAlto) then leer(vec_det[pos],vec_reg[pos]);   
end;

procedure actualizarMaestro(var mae: archivo_maestro; var vec_det: vector_archivos_detalle);
var
    regm: inscriptos_maestro;

    vec_reg: vector_registros_detalle;

    min : pagos_detalle;

    dniAct: longint;
    codAct, i: integer;
begin

    Reset(mae);

    //Abrir detalles, Leer primer reg de los archivos detalle, salvarlo al vector de registros
    for i:= 1 to cant_detalles do begin
        Reset(vec_det[i]);
        leer(vec_det[i],vec_reg[i]);
    end;

    //Calcular el registro minimo
    minimo(vec_det,vec_reg,min);

    //Si hay registros detalle, leer primer registro maestro
    if(min.dni <> valorAlto) then read(mae,regm);


    //Mientras haya registros
    while(min.dni <> valorAlto) do begin
      
        dniAct := min.dni;


        //Mientras el registro sea del mismo alumno        
        while(dniAct = min.dni) do begin

            codAct := min.cod;

            //Buscar regm a actualizar
            while((regm.dni <> dniAct) and (regm.cod <> codAct)) do read(mae,regm);
            
            //Mientras el reg pago sea del mismo alumno y el mismo cod de carrera
            while((dniAct = min.dni) and (codAct = min.cod)) do begin
                
                //Sumar lo pagado al total del regm
                regm.monto_pagado += min.monto_cuota;

                //calcular otro minimo
                minimo(vec_det,vec_reg,min);

            end;

            //Actualizar maestro
            seek(mae,filepos(mae) - 1);
            write(mae,regm);

            //Si quedan registros detalle, leer un regm
            if(min.dni <> valorAlto) then read(mae,regm);
        end;

    end;

    //cerrar archivos
    close(mae);
    for i := 1 to cant_detalles do Close(vec_det[i]);

end;
procedure listarAlumnos(var mae: archivo_maestro);
var
    arc_txt : text;

    regm: inscriptos_maestro;
begin
    //assign y creacion de archivo de texto
    Assign(arc_txt,'listado.txt');
    Rewrite(arc_txt);

    //abrir arch maestro
    Reset(mae);

    //Mientras no este en el fin de archivo, leer un registro maestro y escribirlo en el txt si el alumno no ha pagado
    while(not(EOF(mae))) do begin
        read(mae,regm);
        with regm do if(monto_pagado = 0) then WriteLn(arc_txt,dni,' ',cod,' alumno-moroso');
    end;

    //cerrar archivos
    close(mae);
    close(arc_txt);
end;

var
    arc_mae: archivo_maestro;

    vector_detalles: vector_archivos_detalle;

    i : integer;

    strAssign : string;
begin
  
    //Assign y creacion del archivo maestro
    Assign(arc_mae,'maestro');
    Rewrite(arc_mae);
    Close(arc_mae);


    //Assign y creacion de archivos detalle
    for i := 1 to cant_detalles do begin
        Str(i,strAssign);
        Assign(vector_detalles[i],'det' + strAssign);
        Rewrite(vector_detalles[i]);
        Close(vector_detalles[i]);
    end;

    actualizarMaestro(arc_mae,vector_detalles);
    listarAlumnos(arc_mae);
end.