program P2E2;
{

    PRECONDICIONES

        LOS ARC MAESTRO Y DETALLE YA EXISTEN Y DEBEN IMPORTARSE DESDE ARCHIVOS DE TEXTO (alumnos.txt y detalle .txt respectivamente)

}
const
    valorAlto = 9999;
type
    
    subr1 = 0..1;

    str20 = string[20];

    alumno_mae = record
        cod, cursadas, finales: integer;
        nombre, apellido : str20;
    end;

    alumno_det = record
        cod: integer;
        final: subr1;
    end;

    arc_mae = file of alumno_mae;
    arc_det = file of alumno_det;

procedure leer(var det: arc_det; var a: alumno_det);
begin
    if(not(EOF(det))) then
        read(det,a)
    else
        a.cod := valorAlto;  
end;

procedure CrearArchivoMaestro(var mae: arc_mae);
var
    reg_m : alumno_mae;
    arc_txt: text;
begin
    //Assign y apertura del maestro.txt
    assign(arc_txt,'alumnos.txt');
    reset(arc_txt);

    rewrite(mae);


    while(not(EOF(arc_txt))) do begin

        with reg_m do begin 
            readln(arc_txt,cod,cursadas,finales,nombre);
            readln(arc_txt,apellido);
        end;

        write(mae,reg_m);
    end;

    close(arc_txt);
    close(mae);

end;
procedure CrearArchivoDetalle(var det: arc_det);
var
    reg_d : alumno_det;
    arc_txt: text;

begin
    //Assign y apertura del detalle.txt
    assign(arc_txt,'detalle.txt');
    reset(arc_txt);

    rewrite(det);


    while(not(EOF(arc_txt))) do begin
      
        with reg_d do read(arc_txt,cod,final);
        
        write(det,reg_d);
    end;


    close(arc_txt);
    close(det);

end;
procedure ListarMaestro(var mae: arc_mae);
var
    reporte: text;
    reg_m: alumno_mae;
begin
    assign(reporte,'reporteAlumnos.txt');
    rewrite(reporte);

    reset(mae);


    while(not(EOF(mae))) do begin      
        read(mae,reg_m);

        with reg_m do writeln(reporte,cod,'   ',cursadas,'    ',finales,'     ',nombre,'  ',apellido);
    end;

    close(mae);
    close(reporte);
end;

procedure ListarDetalle(var det: arc_det);
var
    reporte: text;
    reg_d: alumno_det;
begin
    //Assign y creacion de archivo text de reporte
    assign(reporte,'reporteDetalle.txt');
    rewrite(reporte);

    reset(det);

    while(not(EOF(det))) do begin
        read(det,reg_d);

        with reg_d do WriteLn(reporte,cod,'    ',final);
    end;    
    
    close(det);
    close(reporte);

end;


procedure ActualizarMaestro(var mae: arc_mae; var det: arc_det);
var
    reg_m : alumno_mae;
    reg_d, aux : alumno_det;
begin
    //Abrir archivos
    reset(mae);
    reset(det);

    //Leer registros maestro y detalle
    read(mae,reg_m);
    leer(det,reg_d);

    while (reg_d.cod <> valorAlto) do begin
      
        aux := reg_d;

        //Mientras el detalle tenga el mismo codigo, contabilizar segun haya aprobado el final o la cursada
        while(aux.cod = reg_d.cod) do begin
            if(reg_d.final = 1) then reg_m.finales += 1 else reg_m.cursadas += 1;
            leer(det,reg_d);
        end;

        //Posicionarse en el registro a actualizar
        seek(mae,FilePos(mae) - 1);

        //Actualizar registro
        write(mae,reg_m);

        if(not(EOF(mae))) then read(mae,reg_m);
    end;


    //Cerrar archivos
    close(mae);
    close(det);

end;



procedure ListarAlumnosMaterias(var mae: arc_mae);
var
    reg_m : alumno_mae;
    listado : text;
begin

    assign(listado,'listado.txt');
    rewrite(listado);

    reset(mae);

    while(not(EOF(mae))) do begin
      
        //Leer un registro maestro
        read(mae,reg_m);

        //Exportar sus datos al txt si tiene al menos mas de 4 cursadas aprobadas sin final
        if(reg_m.cursadas > reg_m.finales + 4) then with reg_m do begin 
            writeln(listado,cod,'   ',cursadas,'    ',finales,'     ',nombre);
            writeln(listado,apellido);
        end;
    end;   


    close(mae);
    close(listado);
end;

var

    mae: arc_mae;
    det: arc_det;
begin
    assign(mae,'maestro');
    assign(det,'detalle');


    CrearArchivoMaestro(mae);
    CrearArchivoDetalle(det);


    ListarMaestro(mae);
    ListarDetalle(det);


    ActualizarMaestro(mae,det);

    ListarAlumnosMaterias(mae);

    writeln;
end.