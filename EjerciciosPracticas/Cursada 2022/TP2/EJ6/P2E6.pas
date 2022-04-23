program P2E6;
const
    cant_detalles = 15;
    valorAlto = 19998;
type

    str20 = string[20];

    articulo_maestro = record
        cod, talle, stockMin, stockDisp : integer;
        nombre, descripcion, color: str20;
        precio : real;
    end;


    articulo_detalle = record
        cod, cant_vendida: integer;
    end;


    archivo_maestro = file of articulo_maestro;
    archivo_detalle = file of articulo_detalle;


    vec_archivos_detalle = array[1..cant_detalles] of archivo_detalle;
    vec_registros_detalle = array[1..cant_detalles] of articulo_detalle;

    vec_registros_maestros = array[1..cant_detalles] of articulo_maestro;
procedure leer(var det: archivo_detalle; var dato: articulo_detalle);
begin
    if(not(EOF(det))) then
        read(det,dato)
    else
        dato.cod := valorAlto;
end;

procedure minimo(var vec_det : vec_archivos_detalle; var vec_reg: vec_registros_detalle; var min: articulo_detalle);
var
    i, pos: integer;
begin
  
    min.cod := valorAlto;

    for i := 1 to cant_detalles do begin
        
        //Si encuentra un nuevo minimo actualizar reg min para seguir comparando, actualizar pos
        if(vec_reg[i].cod < min.cod) then begin
            min := vec_reg[i];
            pos := i;
        end;
    end;

    //Si el minimo no es valorAlto, se encontro un minimo, por lo que debemos leer el siguiente registro en el archivo detalle de la pos correspondiente
    if(min.cod <> valorAlto) then leer(vec_det[pos],vec_reg[pos]);

end;

procedure ActualizarMaestro(var mae: archivo_maestro; var vec_det: vec_archivos_detalle);
var

    vec_reg: vec_registros_detalle;

    regm: articulo_maestro;

    min: articulo_detalle;

    i, codAct : integer;

    arc_txt : text;
begin
  
    //Assign y crear archivo de texto
    Assign(arc_txt,'informe.txt');
    Rewrite(arc_txt);

    //Abrir archivo maestro
    reset(mae);

    //Abrir archivos detalle, leer el primer registro de cada detalle, salvarlo en el vector de registros
    for i := 1 to cant_detalles do begin
        Reset(vec_det[i]);

        leer(vec_det[i],vec_reg[i]);
    end;


    //Leer un registro del maestro, si es que tiene
    if(not(EOF(mae))) then read(mae,regm); 

    //Calcular el registro detalle minimo 
    minimo(vec_det,vec_reg,min);


    //Mientras haya registros detalle
    while(min.cod <> valorAlto) do begin

        codAct := min.cod;


        //Si el registro maestro no es el correspondiente, leer el archivo hasta encontrarlo
        while(regm.cod <> codAct) do read(mae,regm);

        //Mientras el codigo del registro detalle sea el mismo, actualizar el stock del registro maestro
        while(min.cod = codAct) do begin
            regm.stockDisp -= min.cant_vendida;

            //calcular el siguiente minimo
            minimo(vec_det,vec_reg,min);
        end;

        //Con el registro maestro, si el stock disponible es menor al minimo, importar su informacion a un archivo de texto
        with regm do if(stockDisp < stockMin) then write(arc_txt,nombre,'    ',descripcion,'    ',stockDisp,'    ',precio:2:2);


        //Ubicarse en la correcta posicion del registro a actualizar, sobreescribirlo con la informacion actualizada
        seek(mae,filepos(mae) - 1);
        write(mae,regm);

        //Leer siguiente registro maestro
        if(not(EOF(mae))) then read(mae,regm);


    end;

    
    Close(mae);
    close(arc_txt);

    for i := 1 to cant_detalles do Close(vec_Det[i]);

end;

var
    arc_mae: archivo_maestro;
    vec_detalles: vec_archivos_detalle;

    strAssign : String[3];
    i: integer;
begin

    Assign(arc_mae,'maestro');
    Rewrite(arc_mae);


    for i := 1 to cant_detalles do begin
        Str(i,strAssign);
        Assign(vec_detalles[i],'det' + strAssign);
        Rewrite(vec_detalles[i]);
        //Close(vec_det[i]);
    end;


    ActualizarMaestro(arc_mae,vec_detalles);
  

end.