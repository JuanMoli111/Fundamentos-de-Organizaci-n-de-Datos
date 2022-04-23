program P2E11;
const

    valorAlto =  'ZZZZZ';

type

    str25 = string[25];

    //Registro maestro de datos de alfabetizacion
    datos_maestro = record
        prov : str25;
        cant_alfabetizados, cant_encuestados : integer;
    end;

    datos_detalle = record
        prov : str25;
        cod_localidad, cant_alfabetizados, cant_encuestados : integer;
    end;


    archivo_maestro = file of datos_maestro;
    archivo_detalle = file of datos_detalle;

procedure leer(var det: archivo_detalle; var dato: datos_detalle);
begin
    if(not(EOF(det))) then
        read(det,dato)
    else
        dato.prov := valorAlto;
end;

//Procedure minimo implementado para dos archivos detalle, devuelve el registro minimo encontrado y lee el sig registro del archivo donde lo encontro
procedure minimo(var r1, r2, min: datos_detalle; var det1, det2 : archivo_detalle);
begin
    
    if(r1.cod <= r2.cod) then begin
        min := r1;
        leer(det2,r1);
    end
    else begin
        min := r2;
        leer(det2,r2);
    end;
end;


procedure actualizarMaestro(var mae: archivo_maestro; var det1, det2: archivo_detalle);
var
    regd1, regd2, min: datos_detalle;
    regm: datos_maestro;

    provAct: str25
begin
    //Abrir archivos maestro y detalles
    Reset(mae);
    Reset(det1);  Reset(det1);

    //Leer los dos primeros registros detalle
    leer(det1,regd1);    leer(det2,regd2);

    //Calcular el registro minimo entre estos dos
    minimo(regd1,regd2,min,det1,det2);

    //Si hay registros detalle seguro hay registros maestros por actualizar, entonces leer un registro maestro
    if(min.prov <> valorAlto) then read(mae,regm);


    //Mientras haya registros detalles
    while(min.prov <> valorAlto) do begin

        //Salvar la provincia actual    
        provAct := min.prov;

        //Leer registros maestros hasta encontrar el registro a actualizar
        while(regm.prov <> provAct) do read(mae,regm);


        //Mientras la provincia se la misma
        while(provAct = min.prov) do begin

            //Contabilizar los datos en el registro maestro
            regm.cant_alfabetizados += min.cant_alfabetizados;
            regm.cant_encuestados += min.cant_encuestados;

            //Calcular nuevo registro minimo
            minimo(regd1,regd2,min,det1,det2);
        end;

        //Actualizar maestro: ubicarse en la pos del registro a actualizar, sobreescribirlo con la informacion actualizada
        seek(mae,FilePos(mae) - 1);
        write(mae,regm);

        //Si aun hay registros detalle, seguro hay registros maestro por actualizar, leer siguiente registro maestro
        //(Podria chequear por EOF del maestro, pero en el caso que ya no haya registros detalle y el maestro aun no llego a EOF, estaria leyendo un registro maestro para nada)
        if(min.prov <> valorAlto) then read(mae,regm);

    end;

    //cerrar archivos
    close(mae);
    close(det1);
    close(det2);
end;


var

    arc_mae: archivo_maestro;

    arc_det1, arc_det2 : archivo_detalle;

begin
  
    Assign(arc_mae,'maestro');
    Assign(arc_det1,'det1');
    Assign(arc_det2,'det2');

    actualizarMaestro(arc_mae,arc_det1,arc_det2);
end.