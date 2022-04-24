program P2E14;
const
    valorAlto = 'ZZZZZZZZ';
type

    str20 = string[20];

    vuelos_maestro = record
        destino : str20;

        fecha: LongInt;
        hora, cant_asientos: integer
    end;

    vuelos_detalle = record
        destino : str20;
        fecha: LongInt;
        hora, cant_comprados: integer;
    end;


    archivo_maestro = file of vuelos_maestro;
    archivo_detalle = file of vuelos_detalle;

procedure leer(var det: archivo_detalle; var dato: vuelos_detalle);
begin
    if(not(EOF(det))) then
        read(det,dato)
    else
        dato.destino := valorAlto;
end;

procedure minimo(var reg1, reg2, min: vuelos_detalle; var det1, det2: archivo_detalle);
begin
    if((reg1.destino < reg2.destino) or ((reg1.destino = reg2.destino) and (reg1.fecha < reg2.fecha)) or ((reg1.destino = reg2.destino) and (reg1.fecha = reg2.fecha) and (reg1.hora < reg2.hora))) then begin
        min := reg1;
        leer(det1,reg1);
    end
    else begin
        min := reg2;
        leer(det2,reg2);
    end;
end;

procedure actualizarMaestro(var mae: archivo_maestro; var det1, det2: archivo_detalle);
var
    regm: vuelos_maestro;

    regd1, regd2, min: vuelos_detalle;

    //Destino actual, fecha y hora actual
    destinoAct: str20;    fechaAct  : longint;      horaAct   : integer;
begin
    //Abrir archivos
    Reset(mae);
    Reset(det1);    Reset(det2);

    //Leer primer registro detalle, de cada arch
    leer(det1,regd1);    leer(det2,regd2);

    //Calcular el minimo
    minimo(regd1,regd2,min,det1,det2);

    //Si hay registros detalle leer primer registro maestro
    if(min.destino <> valorAlto) then read(mae,regm);

    //Mientras haya registros
    while(min.destino <> valorAlto) do begin
      
        destinoAct := min.destino;


        //mientras el rergd tenga el mismo destino
        while(destinoAct = min.destino) do begin
            //Salvar fecha actual
            fechaAct := min.fecha;

            //Mientras el regd tenga el mismo destino y fecha
            while((destinoAct = min.destino) and (fechaAct = min.fecha)) do begin
              
                //Salvar horario del regd vuelo actual
                horaAct := min.hora;


                //Buscar el vuelo a actualizar en el maestro
                while((regm.destino <> destinoAct) and (regm.fecha <> fechaAct) and (regm.hora <> horaAct)) do read(mae,regm);

                //Mientras los reg detalle sean el mismo vuelo (dest fecha y hora)
                while((destinoAct = min.destino) and (fechaAct = min.fecha) and (horaAct = min.hora)) do begin


                    //Actualizar la cant de asientos disponibles del reg maestro de este vuelo
                    regm.cant_asientos -= min.cant_comprados;

                    //Calcular siguiente minimo
                    minimo(regd1,regd2,min,det1,det2);
                end;


                //Actualizar registro del archivo maestro
                seek(mae,FilePos(mae) - 1);
                Write(mae,regm);
            end;    
        end;    
    end;


    Close(mae); close(det1); Close(det2);
end;

//Generar una lista (en un txt)  de los vuelos con menos asientos disponibles q el parametros asientos
procedure generarLista(var mae: archivo_maestro; asientos: integer);
var
    regm: vuelos_maestro;

    arc_txt: text;
begin

    //Assign y creacion del archivo txt
    Assign(arc_txt,'Listado.txt');
    Rewrite(arc_txt);

    //Abrir archivo
    Reset(mae);

    //Leer primer registro
    if(not(EOF(mae))) then read(mae,regm);


    //Mientras tenga registros, si cumplen la condicion escribirlos al txt. leer otro registro maestro
    while(not(EOF(mae))) do begin
        with regm do if(cant_asientos < asientos) then writeln(arc_txt,destino,' ',fecha,' ',hora,' ',cant_asientos);
        read(mae,regm);
    end;
    
    //Cerrar archivos
    close(mae);
    close(arc_txt);
end;


var
    arc_mae : archivo_maestro;
    det1, det2: archivo_detalle;

    asientos : integer;
begin

    Assign(arc_mae,'maestro');
    Rewrite(arc_mae);

    Assign(det1,'det1');    Assign(det2,'det2');
    Rewrite(det1);  Rewrite(det2);

    writeln('Ingrese una cantidad de asientos, se generara un listado con los vuelos que tengan una menor cant de asientos disponibles');
    ReadLn(asientos);

    actualizarMaestro(arc_mae,det1,det2);

    generarLista(arc_mae,asientos);
  
end.