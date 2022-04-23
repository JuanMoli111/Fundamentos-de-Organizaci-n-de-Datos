program P2E10;
const
    valorAlto = 19998;
type
    
    empleado = record
        depto, division, nro_empleado, horas_extra, categoria : integer;
    end;


    archivo_maestro = file of empleado;

    archivo_texto = text;

    //Vector con el valor de las horas extra
    vector_horas = array[1..15] of real;

procedure leer(var arc : archivo_maestro; var dato: empleado);
begin
    if(not(EOF(arc))) then
        read(arc,dato)
    else
        dato.depto := valorAlto;
end;

//Carga un arreglo con la informacion de un archivo de texto, con los valores por las horas extras de distintas categorias
procedure cargarArray(var vec : vector_horas);
var
    txt : archivo_texto;
    i : integer;
begin
    
    //Assign y apertura del txt de valores por hora extra
    Assign(txt,'valores.txt');
    Reset(txt);
  

    //Si el formato del txt es categoria / valor, podemos leer primero la categoria en i, luego usar ese codigo de categoria como indice para salvar el valor por hora extra correspondiente
    while(not(EOF(txt))) do ReadLn(txt,i,vec[i]);


    //Cerrar txt
    close(txt);
end;

//Lista el contenido del archivo segun lo pide el enunciado
procedure listarContenido(var mae: archivo_maestro; valores_horas : vector_horas);
var
    regm : empleado;

    //Declarar depto actual, divison actual, total de horas por division, total de horas por depto
    depAct, divAct, totalHorasDiv,  totalHorasDep  : integer;

    //Declarar monto total por division y depto
    totalMontoDiv, totalMontoDep, monto : real;
begin

    //Abrir archivo 
    reset(mae);

    //leer primer registro
    leer(mae,regm);

    //mientras haya registros
    while(regm.depto <> valorAlto)do begin

        //Salvar depto actual
        depAct := regm.depto;

        //Inicializar contadores por departamento
        totalHorasDep := 0;
        totalMontoDep := 0;

        //Informar
        writeln('Departamento ',depAct);

        //Mientras los registors sean del mismo departamento
        while(depAct = regm.depto) do begin
          
            //Salvar division actual
            divAct := regm.division;

            //Inicializar contadores por division
            totalHorasDiv := 0;
            totalMontoDiv := 0;

            //Informar
            WriteLn('Division ',divAct);

            //Mientras los registros sean del mismo departamento y de la misma division
            while((depAct = regm.depto) and (divAct = regm.division)) do begin

                //Calcular monto del empleado segun su categoria y las horas extra trabajadas
                monto := valores_horas[regm.categoria] * regm.horas_extra;

                //Informar datos del empleado
                WriteLn('Numero de Empleado     Total de Hs     Importe a cobrar');
                WriteLn(regm.nro_empleado,'                     ',regm.horas_extra,'               ',monto:1:1);

                //Contabilizar horas y montos por division
                totalHorasDiv += regm.horas_extra;
                totalMontoDiv += monto;

            end;

            //Informar
            WriteLn('Total de horas division: ',totalHorasDiv);
            WriteLn('Monto total por division: ',totalMontoDiv);

            //Contabilizar el total por division en el total por depto
            totalHorasDep += totalHorasDiv;
            totalMontoDep += totalMontoDiv;

        end;        

        //Informar
        WriteLn('Total horas departamento: ',totalHorasDep);
        WriteLn('Monto total departamento: ',totalMontoDep);
    end;    


    //Cerrar archivo
    close(mae);

end;

var

    arc_mae : archivo_maestro;

    arc_txt : archivo_texto;

    vec_horas : vector_horas;
begin
    cargarArray(vec_horas);
    listarContenido(arc_mae,vec_horas);
end.