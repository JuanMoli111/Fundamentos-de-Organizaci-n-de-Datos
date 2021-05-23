program CorteControl;
const 
    valoralto='zzzz';
type 
    str10 = string[10];
    //Declara registro provincia    
    prov = record
        provincia, partido, ciudad: str10;            
        cant_varones, cant_mujeres, cant_desocupados : integer; 
    end;
    
    //Archivo de provincias
    instituto = file of prov;

var 
    //DECLARA REG PROVINCIA
    regm: prov;
    //DECLARA ARCHIVO INSTITUTO ES UN ARCHIVO DE REGISTROS PROVINCIA
    inst: instituto;

    //CONTADORES DE TRABAJADORES VARONES Y MUJERES, Y CUANDOS TRABAJADORES ESTAN DESOCUPADOS
    t_varones, t_mujeres, t_desocupa, t_prov_var, t_prov_muj, t_prov_des: integer;

    //PROVINCIA ANTERIOR Y PARTIDO ANTERIOR, UTIL PARA EL CORTE DE CONTROL
    ant_prov, ant_partido : str10;

//LEER DATO DEL ARCHIVO
procedure leer(var archivo:instituto; var dato:prov);
begin
    //SI NO SE HA LLEGADO AL FINAL DEL ARCHIVO, LEER UNA PROVINCIA Y GUARDARLA EN DATO
    if(not eof(archivo)) then
        read(archivo,dato)
    else
        //SI SE HA LLEGADO AL FINAL DEL ARCHIVO, SETEAMOS EL CAMPO PRIVINCIA DE LA VARIABLE DATO EN UN STRING MUY ALTO, (¿CORTES DE CONTROL?)
        dato.provincia := valoralto;
end;
//PROGRAMA PRINCIPAL
begin
    //ASÍGNESE UN NOMBRE FÍSICO 'censo' AL NOMBRE LOGICO INST QUE ES UN ARCHIVO DE PROVINCIAS, 'censo' EXISTE 
    //Y ES UN ARCHIVO DE PROVINCIAS ORDENADO POR PROVINCIA PARTIDO Y CIUDAD
    assign(inst, 'censo'); 

    //ABRE EL ARCHIVO
    reset(inst); 

    //LEE EL PRIMER REGISTRO PROV, ¿REGM SE UTILIZARA COMO REGISTRO PARA GENERAR EL ARCHIVO MAESTRO?
    leer(inst, regm);
    
    //INFORME LA PROVINCIA Y EL PARTIDO QUE SE VA A PROCESAR, DISPONGA UNA TABLA PARA PRESENTAR ORDENADAMENTE LOS VALORES
    writeln ('Provincia: ',regm.provincia);
    writeln ('Partido: ', regm.partido);
    writeln('Ciudad','Mas','Fem','Desocupa');


    //INICIALIZA TODOS LOS CONTADORES EN CERO
    t_varones := 0;     t_mujeres := 0;   t_desocupa := 0;t_prov_var := 0;    t_prov_muj := 0;  t_prov_des := 0;
    
    //LOOP PRINCIPAL, MIENTRAS EL CAMPO PROVINCIA SEA DISTINTO A LA CONSTANTE 'valoralto'( QUE SE SETEA SI SE ALCANZA EL EOF AL LEER UN REG)..
    while (regm.provincia <> valoralto) do begin
        
        //PROV ANTERIOR Y PARTIDO ANTERIOR
        ant_prov := regm.provincia; 
        ant_partido := regm.partido;

        //MIENTRAS LA PROV ANTERIOR Y EL PARTIDO ANTERIOR SEAN DISTINTOS A LA PROV Y PARTIDO DEL REG ACTUAL
        while(ant_prov = regm.provincia) and (ant_partido = regm.partido) do begin
            //INFORMAR LOS DATOS
            write(regm.ciudad, regm.cant_varones, regm.cant_mujeres,regm.cant_desocupados);

            //SUMAR LOS TRABAJADORES CONTABILIZADOS EN ESTE REGISTRO, AL CONTADOR DE TRABAJADORES DE CADA TIPO
            t_varones := t_varones + regm.cant_varones;      
            t_mujeres := t_mujeres + regm.cant_mujeres;
            t_desocupa := t_desocupa + regm.cant_desocupados;

            //LEER OTRO REGISTRO PROVINCIA
            leer(inst, regm);
        end;


        //SI SALE DEL LOOP ES POR QUE CAMBIO EL PARTIDO O EL PARTIDO Y LA PROVINCIA, ENTONCES:
        //INFORMA EL TOTAL DEL PARTIDO
        writeln ('Total Partido: ', t_varones, t_mujeres, t_desocupa);

        //ACUMULA LOS TRABAJADORES DEL ULTIMO REGISTRO DE ESA PROV/PARTIDO, EN SU RESPECTIVO CONTADOR
        t_prov_var := t_prov_var + t_varones; 
        t_prov_muj := t_prov_muj +  t_mujeres;  
        t_prov_des := t_prov_des + t_desocupa;

        //RESETA LAS VARIABLES A CERO
        t_varones := 0; t_mujeres := 0; t_desocupa := 0;

        //ACTUALIZAMOS LA VARIABLE PARTIDO ANTERIOR CON EL NUEVO PARTIDO
        ant_partido := regm.partido;

        //SI LA PROV ANTERIOR ES DISTINTA DE LA PROVINCIA ACTUAL
        if (ant_prov <> regm.provincia) then begin

            //INFOMAR EL TOTAL DE LA PROVINCIA
            writeln ('TotalProv.',t_prov_var, t_prov_muj, t_prov_des);

            //RESETEAR LOS CONTADORES
            t_prov_var := 0;
            t_prov_muj := 0; 
            t_prov_des := 0;

            //INFORMAR LA NUEVA PROVINCIA
            writeln('Prov.:',regm.provincia);
        end;

        //INFORMAR EL NUEVO PARTIDO
        writeln('Partido:', regm.partido);
    end;
end.