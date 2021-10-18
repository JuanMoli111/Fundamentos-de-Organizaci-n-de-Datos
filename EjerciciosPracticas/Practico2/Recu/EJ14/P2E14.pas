program ej14;

uses SysUtils;
{
                    PRECONDICIONES

            *   1-  EXISTE UN ARCHIVO MAESTRO CON INFORMACION SOBRE VUELOS

            *   2-  SE RECIBEN DOS ARCHIVOS DETALLES 

            *   3-  DEBE ACTUALIZARSE EL ARCHIVO MAESTRO CON LA INFORMACION DE LOS DETALLE

            *   4-  LOS ARCHIVOS ORDENADOS POR DESTINO, FECHA, Y HORA DE SALIDA

            *   5-  LOS DETALLES PUEDEN TENER 0 O N REGISTROS POR CADA REGISTRO DEL MAESTRO



}
const
    dimF = 2;
    valorAlto = 'zzzz';
type

    str25 = string[25];


    // Registro maestro
    proxVuelo = record
        dest : str25;
        fecha : string[6];          //      yymmdd
        hora : string[4];           //      hhmm
        lugarDisp: integer;
    end;

    //Regisro detalle
    compraVuelo = record
        dest : str25;
        fecha : string[6];
        hora : string[4];
        cantComprado : integer;
    end;

    //Tipos para archivos maestro y detalle
    arc_maestro = file of proxVuelo;

    arc_detalle = file of compraVuelo;

    //Tipos arreglo para manejar los archivos detalle
    vec_detalle =     array[1..dimF] of arc_detalle;
    vec_reg_detalle = array[1..dimF] of compraVuelo;


    //Declara los tipos para generar una lista enlazada por punteros
    lista = ^nodo;

    nodo = record
        dato : proxVuelo;
        sig : lista;
    end;

var
    vec_det : vec_detalle;

    maestro : arc_maestro;




//DEVOLVER SIGUIENTE REGISTRO DE UN ARCHIVO, SI ES EOF DEVOLVER UN VALOR DE CORTE
procedure leerDet(var det: arc_detalle; var dato : compraVuelo);
begin
    if(not(eof(det))) then
        read(det,dato)
    else
        dato.dest := valorAlto;
end;

procedure leerMae(var mae: arc_maestro; var dato : proxVuelo);
begin
    if(not(eof(mae))) then
        read(mae,dato)
    else
        dato.dest := valorAlto;
end;


//Procedimiento para agregar un nodo a una lista
procedure agregarNodo(var l: lista; v: proxVuelo);
var
	aux: lista;
begin
	new(aux);
	aux^.dato := v;
	aux^.sig := l;
	l := aux;
end;


{   --RECIBE UN VECTOR DE REGISTROS Y RETORNA EL MINIMO POR DESTINO FECHA Y HORA, EN EL PARAMETRO MIN.
    --ACTUALIZA Y RETORNA EL VECTOR DE REGISTROS LEYENDO EL SIGUIENTE DATO DEL DETALLE CORRESPONDIENTE    }
procedure minimo(var vec_r: vec_reg_detalle; var min: compraVuelo);
var
    minPos, i : integer;
begin

    //Recorrer los reg detalle, consiguiendo la posicion del minimo
    for i := 1 to dimF do begin
        if((vec_r[i].dest < min.dest) or ((vec_r[i].dest = min.dest) and (vec_r[i].fecha < min.fecha)) or
          ((vec_r[i].dest = min.dest) and (vec_r[i].fecha = min.fecha) and (vec_r[i].hora < min.hora))) then minPos := i;
    end;


    writeln('Error de ejecucion en la siguiente linea');
    //El registro minimo es el que esta en la posicion minPos 
    min := vec_r[minPos];

    //Leer en el archivo detalle correspondiente, almacenar el siguiente registro en el vector de reg
    leerDet(vec_det[minPos],vec_r[minPos]);
end;


procedure ActualizarMaestro(var mae: arc_maestro; var vec_det: vec_detalle; var vec_reg: vec_reg_detalle);
var
    min : compraVuelo;
    vuelo : proxVuelo;

    destAct: str25;
    fechaAct: string[6];
    horaAct : string[4];

    totComprado, i: integer;
begin
    //Abrir archivo maestro
    reset(mae);

    //Abrir detalles y leer registros
    for i := 1 to dimF do begin

        assign(vec_det[i],'det ' + IntToStr(i));

        rewrite(vec_det[i]);
        leerDet(vec_det[i],vec_reg[i]);
    end;


    //Error de ejecucion idk why ¿?
    writeln('Error de ejecucion en la siguiente linea');

    //Calcular el reg minimo
    minimo(vec_reg,min);


    //leer el primer reg maestro
    leerMae(mae,vuelo);


    //Mientras haya registros en los archivos detalle
    while(min.dest <> valorAlto) do begin
        
        destAct := min.dest;


        while(min.dest = destAct) do begin

            fechaAct := min.fecha;


            //Mientras la fecha y el destino sean el mismo
            while((min.dest = destAct) and (min.fecha = fechaAct)) do begin

                horaAct := min.hora;

                //Inicializar totalizador para las compras de este vuelo
                totComprado := 0;

                //Mientras sean compras del mismo vuelo, contar la cant comprada
                while((min.fecha = fechaAct) and (min.hora = horaAct) and (min.dest = destAct)) do begin
                    
                    totComprado += min.cantComprado;

                    //Leer un nuevo minimo
                    minimo(vec_reg,min);

                end;
                
                //Leer reg maestros hasta encontrar el vuelo a actualizar
                while((vuelo.fecha <> fechaAct) and (vuelo.hora <> horaAct) and (vuelo.dest <> destAct)) do read(mae,vuelo);
    
                //Actualizar registro
                vuelo.lugarDisp -= totComprado;

                //Ubicarse en la pos del archivo maestro y actualizarlo
                seek(mae,filepos(mae) - 1);
                write(mae,vuelo);

                //Leer un registro maestro
                leerMae(mae,vuelo);

            end;
        end;
    end;

    //Cerrar archivos
    close(mae);
    for i := 1 to dimF do close(vec_det[i]);
end;


procedure GenerarLista(var mae: arc_maestro; var l : lista);
var
    vuelo : proxVuelo;
    inputNum : integer;
begin
    
    //Abrir arch maestro
    reset(mae);

    //Leer primer registro
    leerMae(mae,vuelo);


    write('Ingrese una cantidad de asientos: ');
    readln(inputNum);


    //Mientras haya registros en el archivo maestro
    while(vuelo.dest <> valorAlto) do begin

        if(vuelo.lugarDisp < inputNum) then agregarNodo(l,vuelo);

        leerMae(mae,vuelo);

    end;


    writeln('Lista generada');

    close(mae);
end;
//DECLARACION DE VARIABLES
var
    //Vector de reg detalle 
    vec_reg : vec_reg_detalle;

    l : lista;
begin

    //Assign de los archivos maestro y detalles
    assign(maestro,'maestro');
    rewrite(maestro);
    //Inicializar lista
    l := nil;

    writeln('test');
    
    ActualizarMaestro(maestro,vec_det,vec_reg);


    GenerarLista(maestro,l);
end.