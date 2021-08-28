program parcial;

const

    valorAlto = -9;
    cantE = 10;
type

    str20 = string[20];

    info_muni = record
        codloc, codCep, cantActivos, cantNuevos, cantRec, cantFal: integer;
    end;

    info_tot = record
        codLoc, codCep, cantActivos, cantNuevos, cantRec, cantFal: integer;
        nomLoc, nomCep : str20;
    end;

    //ARCHIVO MAESTRO
    arc_muni_maestro = file of info_tot;

    //DETALLES
    arc_muni = file of info_muni;

    vec_detalles = array[1..cantE] of arc_muni;

    vec_reg_det = array[1..cantE] of info_muni;


//DECLARACION DE VARIABLES
var

    maestro: arc_muni_maestro;

    vec_det : vec_detalles;

    vec_reg : vec_reg_det;

    i : integer;
    
    strIndice : string;

procedure leerDet(var arc: arc_muni; var dato: info_muni);
begin
    if(not(eof(arc))) then
        read(arc,dato)
    else begin
        dato.codLoc := valorAlto;
        dato.codCep := valorAlto;
    end;
end;

procedure leerMae(var arc: arc_muni_maestro; var dato: info_tot);
begin
    if(not(eof(arc))) then
        read(arc,dato)
    else begin
        dato.codLoc := valorAlto;
        dato.codCep := valorAlto;
    end;
end;


procedure minimo(var vec_reg: vec_reg_det; var min: info_muni);
var
    minPos, i : integer;
begin

    for i := 1 to cantE do if(vec_reg[i].codLoc < min.codLoc) or ((vec_reg[i].codLoc = min.codLoc) and (vec_reg[i].codCep < min.codCep)) then minPos := i;

    min := vec_reg[minPos];

    leerDet(vec_det[minPos],min);
end;

procedure ActualizarMaestro(var mae: arc_muni_maestro; var vec_det: vec_detalles);
var
    vec_reg : vec_reg_det;
    min, regAct : info_muni;
    regm : info_tot;
    cantLoc : integer;
begin

    cantLoc := 0;

    reset(mae);

    for i := 1 to cantE do begin
        reset(vec_det[i]);
        leerDet(vec_det[i],vec_reg[i]); 
    end;

    leerMae(mae,regm);

    minimo(vec_reg,min);


    while(min.codLoc <> valorAlto) do begin

        regAct := min;


        while(min.codLoc = regAct.codLoc) do begin

            regAct.codLoc := min.codLoc;

            while((min.codLoc = regAct.codLoc) and (min.codCep = regAct.codCep)) do begin

                regAct.codCep := min.codCep;

                with regm do begin
                    cantFal += min.cantFal;
                    cantRec += min.cantRec;
                    cantActivos := min.cantActivos;
                    cantNuevos := min.cantNuevos;
                end;

                seek(mae,filepos(mae) - 1);

                write(mae,regm);

                minimo(vec_reg,min);


                leerMae(mae,regm);
            end;

        end;
    
        if(regAct.cantActivos > 50) then cantLoc += 1;


    end;

    close(mae);

    for i := 1 to cantE do close(vec_det[i]);

    writeln('La cant de localidades con mas de 50 casos activos fue: ', cantLoc);

end;
begin

    assign(maestro,'m');

    for i := 1 to cantE do begin
        Str(i,strIndice);

        assign(vec_det[i],'det'+strIndice);
    end;

    ActualizarMaestro(maestro, vec_det);

end.