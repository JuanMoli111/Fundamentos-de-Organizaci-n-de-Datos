program P2E3;
const
    valorAlto = 9999;
    cant_detalles = 3;
type

    str20 = string[20];

    producto_maestro = record
        codigo, stockDis, stockMin: integer;

        precio: real;

        nombre, descripcion: str20;
    end;

    producto_detalle = record
        cod, cant: integer;
    end;
    

    archivo_maestro = file of producto_maestro;
    archivo_detalle = file of producto_detalle;

    archivo_text = text;


    array_archivo_detalle = array[1..cant_detalles] of archivo_detalle;
    array_registros_detalle = array[1..cant_detalles] of producto_detalle;
procedure llenarArchivosTesting(var mae: archivo_maestro; var vec_det: array_archivo_detalle);
var
    regm: producto_maestro;
    regd: producto_detalle;
    i : integer;
begin
  
    Reset(mae);

    for i := 1 to cant_detalles do begin
        Reset(vec_det[i]);
        
        with regd do begin
            cod := i;
            cant := 10;
        end;

        write(vec_det[i],regd);


    end;

    with regm do begin
        codigo := 1;
        stockDis := 20; stockMin := 15;
        precio := 2.5;
        nombre := 'aaa';    descripcion := 'aaa';
    end;

    write(mae,regm);

    with regm do begin
        codigo := 2;
        stockDis := 40; stockMin := 35;
        precio := 10;
        nombre := 'bbb';    descripcion := 'bbb';
    end;

    write(mae,regm);

    with regm do begin
        codigo := 3;
        stockDis := 33; stockMin := 30;
        precio := 10;
        nombre := 'ccb';    descripcion := 'bcc';
    end;

    write(mae,regm);
    
   

    for i := 1 to cant_detalles do begin
        close(vec_det[i]);
    end;

    close(mae);
   
end;

procedure recorrerMaestro(var mae: archivo_maestro);
var
    regm: producto_maestro;
begin
    Reset(mae);

    while(not(EOF(mae))) do begin
        read(mae,regm);

        with regm do WriteLn('cod: ', codigo,' stockDis: ',stockDis);


    end;

    close(mae);
end;

procedure leer(var det: archivo_detalle; var p : producto_detalle);
begin
    if(not(EOF(det))) then
        read(det,p)
    else
        p.cod := valorAlto;
end;

procedure minimo(var vec_det: array_archivo_detalle; var vec_reg: array_registros_detalle; var min: producto_detalle);
var
    i, minPos : integer;
begin
    //Inicializar min en valor alto, pos en -1
    min.cod := valorAlto; 
    minPos := -1;


    //Recorrer el vector de registros detalle, salvar el minimo y su posicion
    for i := 1 to cant_detalles do begin

        if(vec_reg[i].cod < min.cod) then begin
            min := vec_reg[i];
            minPos := i;
        end;

    end;

    //Si pos fue alterado, min retorna el registro minimo, leer un registro en el vector correspondiente
    if(minPos <> -1) then begin
        min := vec_reg[minPos];
        leer(vec_det[minPos],vec_reg[minPos]);
    end;
end;

//Recibe el archivo maestro, el vector de archivos detalle y el vector de registros detalle,
//actualiza el stock del maestro con los datos del archivo detalle
procedure ActualizarMaestro(var mae : archivo_maestro; var vec_det : array_archivo_detalle; var vec_reg: array_registros_detalle);
var
    regm : producto_maestro;
    regd, min : producto_detalle;


    i, tot, codAct: integer;
    
    strIndice : string;
begin

    //Abrir maestro
    reset(mae);

    read(mae,regm);

    //abrir los 30 archivos detalle
    for i := 1 to cant_detalles do begin
        Reset(vec_det[i]);
    
        //Guarda el primer registro del archivo en la iésima posicion del vector de registros de info_ventas
        leer(vec_det[i],vec_reg[i])
    end;

    
    minimo(vec_det,vec_reg,min);

    while(min.cod <> valorAlto) do begin
      
        codAct := min.cod;

        tot := 0;

        while(codAct = min.cod) do begin
            tot += min.cant;
            minimo(vec_det,vec_reg,min);
        end;

        
        while(regm.codigo <> codAct) do
            read(mae,regm);
        
        seek(mae,FilePos(mae) - 1);

        regm.stockDis -= tot;
        writeln('whi');
        write(mae,regm);

        if(not(EOF(mae))) then read(mae,regm);

    end;

    
    for i := 1 to cant_detalles do close(vec_det[i]);
    close(mae);

end;

procedure informarTxt(var mae: archivo_maestro);
var
    regm: producto_maestro;
    arc_txt : archivo_text;
begin
    Reset(mae);

    assign(arc_txt,'arc_texto.txt');
    rewrite(arc_txt);

    if(not(EOF(mae))) then read(mae,regm);

    while(not(EOF(mae))) do begin
     
        //Si el stock disponible menor al minimo, exportar informacion a un txt
        with regm do if(stockDis < stockMin) then write(arc_txt,stockDis,'     ',precio:2:2,'     ',descripcion,'       ',nombre);

        if(not(EOF(mae))) then read(mae,regm);
    end;


    close(arc_txt);
    close(mae);

end;
var

    arc_mae: archivo_maestro;

    vector_det : array_archivo_detalle;
    vector_reg : array_registros_detalle;

    strIndice : str20;
    i : integer;

begin

    //Assign del maestro, abre del maestro,
    assign(arc_mae,'maestro');
    Rewrite(arc_mae);

    for i := 1 to cant_detalles do begin

        Str(i,strIndice);
        assign(vector_det[i],'det' + strIndice);
    
        Rewrite(vector_det[i]);
    end;


    llenarArchivosTesting(arc_mae,vector_det);

    recorrerMaestro(arc_mae);

    ActualizarMaestro(arc_mae,vector_det,vector_reg);


    writeln();
    writeln('MAESTRO ACTUALIZADO: ');
    writeln();

    recorrerMaestro(arc_mae);

    informarTxt(arc_mae);
end.