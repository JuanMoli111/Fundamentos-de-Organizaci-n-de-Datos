program P2E4;
const 
    valorAlto = 9999;
    fechaAlta = 11119999;
    cant_detalles = 5;  
type


    log_detalle = record
        cod : integer;
        fecha: longint;
        tiempo: real;
    end;

    log_maestro = record
        cod : integer;
        fecha: longint;
        tiempo_total: real;
    end;
    
    archivo_detalle = file of log_detalle;
    archivo_maestro = file of log_maestro;


    vector_archivos_detalle = array[1..cant_detalles] of archivo_detalle;
    vector_registros_detalle = array[1..cant_detalles] of log_detalle;


procedure leer(var det: archivo_detalle; var l: log_detalle);
begin
    if(not(EOF(det))) then
        read(det,l)
    else begin
        l.cod := valorAlto;     l.fecha := fechaAlta;
    end;    
end;
procedure minimo(var vec_det: vector_archivos_detalle; var vec_reg: vector_registros_detalle; var min: log_detalle);
var
    i, minPos : integer;
begin
    //Inicializar min en valor alto, pos en -1
    min.cod   := valorAlto; 
    min.fecha := fechaAlta;


    //Recorrer el vector de registros detalle, salvar el minimo y su posicion
    for i := 1 to cant_detalles do begin

        
        if(vec_reg[i].cod < min.cod) or ((vec_reg[i].cod = min.cod) and (vec_reg[i].fecha < min.fecha)) then begin
            min := vec_reg[i];
            minPos := i;
        end;


    end;

    //Si pos fue alterado, min retorna el registro minimo, leer un registro en el vector correspondiente
    if(min.cod <> valorAlto) then leer(vec_det[minPos],vec_reg[minPos]);

end;
procedure recorrerMaes(var mae:archivo_maestro);
var
    regm: log_maestro;
begin

    Reset(mae);


    writeln;
    writeln('Datos en Maestro');

    while (not(EOF(mae))) do begin
      

        read(mae,regm);


        with regm do writeln('cod: ',cod,'  fecha: ',fecha,'  tiempo total: ',tiempo_total:2:2);

    end;

    close(mae);


end;
procedure generarMaestro(var mae: archivo_maestro; var vec_det: vector_archivos_detalle; var vec_reg: vector_registros_detalle);
var
    i, j, codAct : integer;
    strAssign: string;

    fechaAct : longint;

    //tiempo_total: real;

    regm: log_maestro;  
    min, regdTest : log_detalle;
begin

    //Assign y creacion del archivo maestro
    Assign(mae,'maestro');
    Rewrite(mae);

    writeln('DATOS AL DETALLE');
    
    //Assign y apertura de los archivos detalle
    for i := 1 to cant_detalles do begin
        Str(i,strAssign);
        Assign(vec_det[i],'det' + strAssign);

        Rewrite(vec_det[i]);        
        //Llenar de datos los detalles

        

        for j := 0 to 6 do begin

            //Los registros deben generar codigo y fecha ordenados, para simular los datos segun la precondicion
            with regdTest do begin
                cod := j;
                fecha := 10 * (j+1);
                tiempo := 2.5 * (j+1);
            
                writeln('Reg Test[',i,',',j,'] --- cod: ',cod,' fecha: ',fecha,' tiempo: ',tiempo:2:2);
            end;

            write(vec_det[i],regdTest);

            with regdTest do begin
                cod := j;
                fecha := 10 * (j+1);
                tiempo := 4.5 * (j+1);
            
                writeln('Reg Test[',i,',',j,'] --- cod: ',cod,' fecha: ',fecha,' tiempo: ',tiempo:2:2);
            end;

            write(vec_det[i],regdTest);
        
        end;

        seek(vec_det[i],0);

    end;




    for i := 1 to cant_detalles do begin
        //Cargar el vector de reg
        leer(vec_det[i],vec_reg[i]);
    end;

    //Leer el registro minimo del vector de archivos detalle
    minimo(vec_det,vec_reg,min);


    while(min.cod <> valorAlto) do begin
      
        //Salva el codigo de user de la sesion actual
        codAct := min.cod;


        //Mientras, sea el mismo user...
        while(codAct = min.cod) do begin 

            
            //Salvar la fecha de esta sesion
            fechaAct := min.fecha;

            regm.tiempo_total := 0;

            //Mientras sea el mismo user y la misma fecha...
            while((codAct = min.cod) and (fechaAct = min.fecha)) do begin
            
                //Totalizar el tiempo de sesion
                regm.tiempo_total += min.tiempo;
                
                minimo(vec_det,vec_reg,min);
            end;

            //Guardar la fecha y codigo de la sesion al registro maestro
            regm.fecha := fechaAct;

        end;

        regm.cod := codAct;

        //Escribir el reg al archivo maestro
        write(mae,regm);

    end;

    for i := 1 to cant_detalles do close(vec_det[i]);
    close(mae);
end;

var
    arc_mae : archivo_maestro;
    vec_dets : vector_archivos_detalle;
    vec_regs : vector_registros_detalle;

begin

    generarMaestro(arc_mae,vec_dets,vec_regs);
    recorrerMaes(arc_mae);
end.