program P2E11;
    //PRECONDICIONES:   ARCHIVO MAESTRO EXISTE, SE DEBE ACTUALIZAR CON DOS ARCHIVOS DETALLE QUE SE RCIBEN
    //                  LOS ARCHIVOS ORDENADOS POR NOMBRE DE PROVINCIA
    //                  ARCHIVOS DETALLE PUEDEN TENER 0 O MAS REGISTROS POR CADA PROVINCIA

const
    valorAlto = 'ZZZ';

type

    str15 = string[15];

    //Declarar registros para cada tipo de archivo, los reg representan informacion de la alfabetizacion en las distintas provincias
    info_alfab_mae = record
        prov : str15;
        cant_alfab : integer;
        encuestados : integer;
    end;    
    info_alfab_det = record
        prov : str15;
        codLoc : integer;
        cant_alfab : integer;
        encuestados : integer;
    end;    

    //Declara tipos para los nombres logicos de los archivos maestro y detalle
    arc_mae = file of info_alfab_mae;
    arc_det = file of info_alfab_det;

//DECLARACION DE VARIABLES
var

    //Nombres logicos para los archivos
    arc_maestro : arc_mae;
    arc_detalle1, arc_detalle2 : arc_det;

//DECLARACION DE PROCEDIMIENTOS

//Leer registros de los archivos detalle, si se quedan sin datos devolver el valor de corte
procedure leerDet(var archivo_det : arc_det; var dato : info_alfab_det);
begin
    if(not(eof(archivo_det))) then
        read(archivo_det,dato)
    else
        dato.prov := valorAlto;
end;

//Leer registros del archivo maestro, si se queda sin datos devolver el valor de corte
procedure leerMae(var archivo_mae : arc_mae; var dato : info_alfab_mae);
begin
    if(not(eof(archivo_mae))) then
        read(archivo_mae,dato)
    else
        dato.prov := valorAlto;
end;


//Retorna el registro con menor nombre entre dos registros 
procedure minimo(var reg1, reg2, min: info_alfab_det);
begin
    //Si el nombre del reg1 es menor, lo retorna como minimo, sino retorna el reg2;
    if(reg1.prov <= reg2.prov)then begin
        min := reg1;
        leerDet(arc_detalle1,reg1);
    end
    else begin
        min := reg2;
        leerDet(arc_detalle2,reg2);
    end;
end;
procedure ActualizarMaestro(var arc_mae : arc_mae; var arc_det1, arc_det2 : arc_det);
var
    //Registros detalle y min para calcular y almacenar el minimo
    reg1, reg2, min: info_alfab_det;
    regm : info_alfab_mae;
    provAct : str15;
begin
    //Abrir archivos
    rewrite(arc_mae);
    rewrite(arc_det1);
    rewrite(arc_det2);


    //Leer el primer registro de cada archivo detalle
    leerDet(arc_det1,reg1);
    leerDet(arc_det2,reg2);

    leerMae(arc_mae,regm);


    //Calcular el registro con menor nombre y retornarlo en min 
    minimo(reg1,reg2,min);


    //Mientras haya datos en los archivos
    while(min.prov <> valorAlto) do begin

        provAct := min.prov;


        while(min.prov = provAct) do begin


            //Cuando salga de este bucle, el archivo maestro está detenido en el reg posterior al que debe cambiar 
            while(min.prov <> regm.prov) do begin

                leerMae(arc_maestro,regm);
            end;

            //Actualiza los datos de las provincias, sumando la cant de personas encuestadas y alfabetizadas a cada contador
            with regm do begin
                cant_alfab += min.cant_alfab;
                encuestados += min.encuestados;
            end;

            //Vuelve a la posicion donde está el dato a actualizar
            seek(arc_maestro,filepos(arc_maestro) - 1);

            //Actualiza el dato del archivo
            write(arc_maestro,regm);


            //Calcular el registro con menor nombre y retornarlo en min 
            minimo(reg1,reg2,min);            

        end;
    end;

    //Cierra los tres archivos
    close(arc_mae);
    close(arc_det1);
    close(arc_det2);

end;

//PROGRAMA PRINCIPAL

begin

    assign(arc_maestro,'mae');

    assign(arc_detalle1,'det1');
    assign(arc_detalle2,'det2');


    ActualizarMaestro(arc_maestro,arc_detalle1,arc_detalle2);

    read;
end.
