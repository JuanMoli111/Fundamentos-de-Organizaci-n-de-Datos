program P2E14;
const
    valorAlto = 'ZZZ';
type
    str25 = string[25];

    //Define tipos subrango para representar dias y meses
    subr31 = 0..31;
    subr12 = 0..12;
    
    //Define tipos subrango para representar horas y minutos
    subr24 = 0..24;
    subr60 = 0..60;

    //Declara un tipo registro para representar fechas
    fecha = record
        dia : subr31;
        mes : subr12;
        anio: integer;
    end;

    //Declara un tipo registro para representar horas
    hora = record
        min : subr60;
        hor: subr24;
    end;

    //Registro para el archivo maestro que representa los proximos vuelos
    prox_vuelo = record
        dest: str25;
        fechaSalida: fecha;
        horaSalida: hora;
        asientosDisp: integer;
    end;

    //Registro para los archivos detalle que representan un vuelo
    vuelo = record
        dest: str25;
        fechaSalida: fecha;
        horaSalida: hora;
        asientosComp: integer;
    end;

    //Registro para la lista de vuelos solicitada
    info_vuelo = record
        dest: str25;
        fechaSalida: fecha;
        horaSalida: hora;
    end;


    //Declara los tipos para generar una lista enlazada por punteros
    lista = ^nodo;

    nodo = record
        dato : info_vuelo;
        sig : lista;
    end;


    //Declara tipos para los nombres logicos de los archivos
    arc_maestro = file of prox_vuelo;
    arc_detalle = file of vuelo;

//DECLARACION DE VARIABLES
var
    //Nombres logicos para los archivos
    maestro : arc_maestro;
    det1, det2 : arc_detalle;

    //Lista para los vuelos con cierta cant de asientos disponibles 
    listaVuelos : lista;


//DECLARACION DE PROCEDIMIENTOS


//Procedimiento para agregar un nodo a una lista
procedure agregarNodo(var l: lista; v: info_vuelo);
var
	aux: lista;
begin
	new(aux);
	aux^.dato := v;
	aux^.sig := l;
	l := aux;
end;

//Procedimiento para leer registros del archivo maestro sin riesgo de EOF, si llega a EOF retorna valor de corte
procedure leerMae(var arc: arc_maestro; var dato: prox_vuelo);
begin
    if(not(eof(arc))) then
        read(arc,dato)
    else 
        dato.dest := valorAlto;
end;

//Procedimiento para leer registros del archivo detalle sin riesgo de EOF, si llega a EOF retorna valor de corte
procedure leerDet(var arc: arc_detalle; var dato: vuelo);
begin
    if(not(eof(arc))) then
        read(arc,dato)
    else 
        dato.dest := valorAlto;
end;


//El procedure minimo calcula el registro minimo entre dos reg leidos de archivos, en este caso debe comparar seis campos y se pone un poco largo
procedure minimo(var reg1, reg2, min: vuelo);
begin

    //Si se cumpliera alguna condicion en la que el reg1 tiene menor destino que el reg2,
    // o tienen igual destino pero menor anio, o tienen igual destino y anio pero menor mes, o tiene ... (aplicar para cada campo)
    //entonces retornar el reg1, de lo contrario retornar el reg2
    if(reg1.dest <= reg2.dest) or ((reg1.dest = reg2.dest) and (reg1.fechaSalida.anio <= reg2.fechaSalida.anio))
        or ((reg1.dest = reg2.dest) and (reg1.fechaSalida.anio = reg2.fechaSalida.anio) and (reg1.fechaSalida.mes <= reg2.fechaSalida.mes))
        or ((reg1.dest = reg2.dest) and (reg1.fechaSalida.anio = reg2.fechaSalida.anio) and (reg1.fechaSalida.mes = reg2.fechaSalida.mes) and (reg1.fechaSalida.dia <= reg2.fechaSalida.dia))
        or ((reg1.dest = reg2.dest) and (reg1.fechaSalida.anio = reg2.fechaSalida.anio) and (reg1.fechaSalida.mes = reg2.fechaSalida.mes) and (reg1.fechaSalida.dia = reg2.fechaSalida.dia) and (reg1.horaSalida.hor <= reg2.horaSalida.hor))
        or ((reg1.dest = reg2.dest) and (reg1.fechaSalida.anio = reg2.fechaSalida.anio) and (reg1.fechaSalida.mes = reg2.fechaSalida.mes) and (reg1.fechaSalida.dia = reg2.fechaSalida.dia) and (reg1.horaSalida.hor = reg2.horaSalida.hor) and (reg1.horaSalida.min <= reg2.horaSalida.min))
        then begin
        min := reg1;
        leerDet(det1,reg1);
    end
    else begin
        min := reg2;
        leerDet(det2,reg2);
    end;
end;


procedure actualizarMaestroGenerarLista(var maestro: arc_maestro; var detalle1, detalle2: arc_detalle; var l: lista);
var
    //registro maestro
    regm : prox_vuelo;

    //Registros para cada arc detalle, registro minimo, registro vuelo actual
    reg1, reg2, min, vueloAct : vuelo;

    //Registro para la lista de vuelos
    regLista : info_vuelo;

    minAsientos: integer;
begin
    //Inicializa lista en nulo
    l := nil;

    writeln('Ingrese una cantidad de asientos disponibles, aquellos vuelos que resulten tener menor cantidad, seran agregados a una lista separada');
    readln(minAsientos);


    //Abrir archivos
    reset(maestro);
    reset(detalle1);
    reset(detalle2);

    //Leer primer registro de archivo maestro y archivos detalle
    leerMae(maestro,regm);

    leerDet(detalle1,reg1);
    leerDet(detalle2,reg2);

    //Calcular el registro minimo
    minimo(reg1,reg2,min);


    //Mientras haya datos en los archivos detalle
    while(min.dest <> valorAlto) do begin

        //Guardar el vuelo actual
        vueloAct := min;

        //Mientras el destino siga siendo el mismo
        while(min.dest = vueloAct.dest) do begin

            //Guardar el destino actual
            vueloAct.dest := min.dest;

            //Mientras el anio siga siendo el mismo
            while(min.dest = vueloAct.dest) and (min.fechaSalida.anio = vueloAct.fechaSalida.anio) do begin
                //Guardar el anio actual
                vueloAct.fechaSalida.anio := min.fechaSalida.anio;

                //Mientras el mes siga siendo el mismo
                while(min.dest = vueloAct.dest) and (min.fechaSalida.anio = vueloAct.fechaSalida.anio) and (min.fechaSalida.mes = vueloAct.fechaSalida.mes) do begin
                    //Guardar el mes actual
                    vueloAct.fechaSalida.mes := min.fechaSalida.mes;

                    //Mientras el dia siga siendo el mismo
                    while((min.dest = vueloAct.dest) and (min.fechaSalida.anio = vueloAct.fechaSalida.anio) and (min.fechaSalida.mes = vueloAct.fechaSalida.mes) and (min.fechaSalida.dia = vueloAct.fechaSalida.dia)) do begin
                        //Guardar el dia actual
                        vueloAct.fechaSalida.dia := min.fechaSalida.dia;

                        //Mientras la hora siga siendo la mismo
                        while((min.dest = vueloAct.dest) and (min.fechaSalida.anio = vueloAct.fechaSalida.anio) and (min.fechaSalida.mes = vueloAct.fechaSalida.mes) and (min.fechaSalida.dia = vueloAct.fechaSalida.dia) and (min.horaSalida.hor = vueloAct.horaSalida.hor)) do begin
                            //Guardar la hora actual
                            vueloAct.horaSalida.hor := min.horaSalida.hor;

                            //Mientras los minutos sigan siendo el mismo
                            while((min.dest = vueloAct.dest) and (min.fechaSalida.anio = vueloAct.fechaSalida.anio) and (min.fechaSalida.mes = vueloAct.fechaSalida.mes) and (min.fechaSalida.dia = vueloAct.fechaSalida.dia) and (min.horaSalida.hor = vueloAct.horaSalida.hor) and (min.horaSalida.min = vueloAct.horaSalida.min)) do begin
                                //Guardar el minuto actual
                                vueloAct.horaSalida.min := min.horaSalida.min;

                                //Avanzar en el maestro hasta hallar el registro correspondiente al vuelo minimo calculado
                                while((regm.dest <> vueloAct.dest) and (regm.fechaSalida.anio <> vueloAct.fechaSalida.anio) and (regm.fechaSalida.mes <> vueloAct.fechaSalida.mes) and (regm.fechaSalida.dia <> vueloAct.fechaSalida.dia) and (regm.horaSalida.hor <> vueloAct.horaSalida.hor) and (regm.horaSalida.min <> vueloAct.horaSalida.min)) do begin
                                    leerMae(maestro,regm);
                                end;

                                //Si el vuelo del detalle es el mismo que el maestro:
                                if((regm.dest = vueloAct.dest) and (regm.fechaSalida.anio = vueloAct.fechaSalida.anio) and (regm.fechaSalida.mes = vueloAct.fechaSalida.mes) and (regm.fechaSalida.dia = vueloAct.fechaSalida.dia) and (regm.horaSalida.hor = vueloAct.horaSalida.hor) and (regm.horaSalida.min = vueloAct.horaSalida.min)) then begin
                                    //actualizar los asientos disponibles
                                    with regm do asientosDisp -= vueloAct.asientosComp;

                                    // volver un registro atras en el archivo
                                    seek(maestro,filepos(maestro) - 1);

                                    //almacenar los datos actualizados
                                    write(maestro,regm);
                                end;

                                //Si los asientos disponibles del vuelo resultaron menores al nro ingresado por teclado: 
                                if(regm.asientosDisp < minAsientos) then begin
                                    with regLista do begin
                                        dest := regm.dest;
                                        fechaSalida := regm.fechaSalida;
                                        horaSalida := regm.horaSalida
                                    end;

                                    //agregar este vuelo a una lista
                                    agregarNodo(l,regLista);

                                end;

                                //Calcular el siguiente minimo
                                minimo(reg1,reg2,min);

                            end;
                        end;
                    end;
                end;
            end;
        end;


    end;

    //Cerrar los archivos
    close(maestro);
    close(detalle1);
    close(detalle2);

end;

begin
    //Assign de cada archivo
    assign(maestro,'mae');
    assign(det1,'det1');
    assign(det2,'det2');

    actualizarMaestroGenerarLista(maestro,det1,det2,listaVuelos);
end.