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


//DEVOLVER SIGUIENTE REGISTRO DE UN ARCHIVO, SI ES EOF DEVOLVER UN VALOR DE CORTE
procedure leerDet(var det: arc_detalle; var dato : compraVuelo);
begin
    if(not(eof(det))) then
        read(det,dato)
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


procedure minimo (var regs: vec_reg_detalle; var dets: vec_detalle; var min: compraVuelo);
var i, posMin: integer;
begin

    //Inicializar pos y registro MIN en valorALTO
	posMin:= 0;
	min.dest := valoralto;
	min.fecha := valorAlto;
	min.hora := valorAlto;

	for i:=1 to dimF do begin
		if(regs[i].dest <= min.dest) then begin
			if (regs[i].fecha <= min.fecha) then begin
				if (regs[i].hora <= min.hora) then begin
					min := regs[i];
					posMin := i;
				end;
			end;
		end;
	end;

    //Si hubo un nuevo dato minimo, leer un dato siguiente en el indice calculado
	if (posMin <> 0) then
		leerDet(dets[posMin], regs[posMin]);

end;
procedure ActualizarMaestro(var mae: arc_maestro; var dets: vec_detalle; var regs: vec_reg_detalle);
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
        assign(dets[i],'det ' + IntToStr(i));

        rewrite(dets[i]);

        leerDet(dets[i],regs[i]);
    end;


    //Calcular el reg minimo
    minimo(regs,dets,min);


    //leer el primer reg maestro
    if(not(eof(mae))) then read(mae,vuelo);


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
                    minimo(regs,dets,min);

                end;
                
                //Leer reg maestros hasta encontrar el vuelo a actualizar
                while((vuelo.fecha <> fechaAct) and (vuelo.hora <> horaAct) and (vuelo.dest <> destAct)) do read(mae,vuelo);
    
                //Actualizar registro
                vuelo.lugarDisp -= totComprado;

                //Ubicarse en la pos del archivo maestro y actualizarlo
                seek(mae,filepos(mae) - 1);
                write(mae,vuelo);

                //Leer un registro maestro
                if(not(eof(mae))) then read(mae,vuelo);

            end;
        end;
    end;

    //Cerrar archivos
    close(mae);
    for i := 1 to dimF do close(dets[i]);
end;


procedure GenerarLista(var mae: arc_maestro; var l : lista);
var
    vuelo : proxVuelo;
    inputNum : integer;
begin
    
    //Abrir arch maestro
    reset(mae);


    write('Ingrese una cantidad de asientos: ');
    readln(inputNum);

    //Mientras haya registros en el archivo maestro
    while(not(eof(mae))) do begin
        read(mae,vuelo);
        if(vuelo.lugarDisp < inputNum) then agregarNodo(l,vuelo);

    end;


    writeln('Lista generada');

    close(mae);
end;
//DECLARACION DE VARIABLES

var
    vec_det : vec_detalle;

    maestro : arc_maestro;

    //Vector de reg detalle 
    vec_reg : vec_reg_detalle;

    regm : proxVuelo;

    l : lista;

    i: integer;
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