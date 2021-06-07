//Una empresa de software posee un archivo con accesos a un servidor web
//la informacion se almacena: año, mes, dia, idUsuario, tiempo de acceso.
//
//El archivo ordenado por año luego mes luego dia luego idUsuario
//
//Se debe realizar un procedimiento que genere un informe, del año que ingrese el usuario

//este informe debe respetar el siguiente formato:
//FORMATO DE INFORME

//Año: --
//
//  Mes:  1
//
//      Dia:  1
//  
//              idUsuario 1 Tiempo total de acceso en el dia 1 mes 1: ----
//
//              idUsuario N tiempo total de acceso en el dia 1 mes 1: ----
//
//          Tiempo total de acceso dia 1 mes 1: -----
//
//
//      Dia:   N
//
//              idUsuario 1 Tiempo total de acceso en el dia N mes 1: ----
//
//              idUsuario N tiempo total de acceso en el dia N mes 1: ----
//
//          Tiempo total de acceso dia N mes 1: -----
//
//      Tiempo total de acceso mes 1: ------
//
//
//   Mes: N 
//
//      Dia: 1
//
//              idUsuario 1 Tiempo total de acceso en el dia 1 mes N: ----
//
//              idUsuario N tiempo total de acceso en el dia 1 mes N: ----
//
//          Tiempo total de acceso dia 1 mes N: -----
//
//      Dia: N
//              idUsuario 1 Tiempo total de acceso en el dia N mes N: ----
//
//              idUsuario N tiempo total de acceso en el dia N mes N: ----
//
//          Tiempo total de acceso dia N mes N: -----
//
//      Tiempo total de acceso mes N: ------
//
//
//  Tiempo total de acceso año --: --------
//
//


program P2E12;

const   
    valorAlto = -9999;

type

    //define subrangos para representar dias y meses, 0 es un dato nulo
    subr31 = 0..31;
    subr12 = 0..12;

    //Registro acceso que representa un acceso al servidor web
    acceso = record
        anio, id, tiempo: integer;
        mes: subr31;
        dia: subr12;
    end;

    //Declara el tipo para el nombre logico del archivo de registros acceso
    arch = file of acceso;


//Leer el archivo, si se quedo sin datos retornar el valor de corte
procedure leer(var arc: arch;var dato: acceso);
begin
    if(not(eof(arc))) then
        read(arc,dato)
    else begin
        dato.anio := valorAlto;
        dato.mes := 0;
        dato.dia := 0;
        dato.id := valorAlto;
    end;
end;

//Recibe el archivo de accesos y el año del que se hará el informe
procedure InformarTiemposAccesoAnual(var archAcc: arch; anioInforme: integer);
var
    //Registro acceso y acceso actual
    regAcc, accAct : acceso;
    tot, totMes, totDia, totId: integer;
begin

    //Abrir el archivo
    reset(archAcc);

    //Leer el primer registro de acceso
    leer(archAcc,regAcc);


    //Leer registros hasta hallar el año del que se debe realizar el informe, o hasta encontrar el valor de corte (no hay mas datos)
    while((regAcc.anio <> anioInforme) AND (regAcc.anio <> valorAlto)) do leer(archAcc,regAcc);

    //Si el anio está registrado, entonces (regAcc = anioInforme) será true luego del bucle anterior
    // de lo contrario debe abortar el programa informando el problema
    if(regAcc.anio = anioInforme) then begin

        //vuelve un registro atras en el archivo maestro, para procesar desde el primer reg del anio solicitado
        seek(archAcc,filepos(archAcc) - 1);

        //Informar con formato
        writeln('Anio :  ',regAcc.anio);

        //Inicializa un contador total en cero, para el tiempo de acceso total en todo el anio
        tot := 0; 

        //Mientras el anio sea el correcto, y haya registros en el archivo
        while((regAcc.anio = anioInforme) AND (regAcc.anio <> valorAlto)) do begin
            
            //Guarda el registro actual, el acceso actual,
            accAct := regAcc;

            //Informar con formato
            writeln('Mes :  ',regAcc.mes);

            //Inicializa o reinicia un contador total para el tiempo de los accesos del mes
            totMes := 0; 


            //Mientras el mes siga siendo el mismo, y haya registros en el archivo
            while((regAcc.mes = accAct.mes) AND (regAcc.mes <> 0)) do begin

                //Informar con formato
                writeln('Dia :  ',regAcc.dia);

                //Inicializa o reinicia un contador total para el tiempo de los accesos del dia
                totDia := 0;


                //Mientras el dia siga siendo el mismo, y haya registros en el archivo
                while((regAcc.dia = accAct.dia) and (regAcc.dia <> 0)) do begin

                    //Informar con formato
                    writeln('idUsuario :  ',regAcc.id);

                    //Inicializa o reinicia un contador total para el tiempo de los accesos del user
                    totId := 0;


                    //Mientras el id de usuario siga siendo el mismo, y haya registros en el archivo

                    while((regAcc.id = accAct.id) and (regAcc.id <> valorAlto)) do begin
                        //Sumar al contador total tiempo por usuario
                        totId += regAcc.tiempo;

                        //Leer el siguiente registro de acceso
                        leer(archAcc,regAcc);
                    end;


                    //Informar total con formato
                    write('   Tiempo total de acceso en el dia ',accAct.dia,' mes ', accAct.mes,':  ',totId);

                    //Sumar al contador total tiempo diario
                    totDia += totId;

                end;  

                //Informar con formato
                writeln('Tiempo total acceso dia ',accAct.dia, ' mes ', accAct.mes, ':  ',totDia);

                //Sumar al contador total tiempo mensual
                totMes += totDia;

            end;

            //Informar con formato
            writeln('Tiempo total de acceso mes ', accAct.mes, ':  ',totMes);

            //Sumar al contador total de tiempo anual
            tot += totMes;

        end;

        writeln('Tiempo total de acceso anio: ', tot);

    end
    else writeln('EL ANIO INGRESADO NO ESTA REGISTRADO');
        
    //Cierre del archivo2
    close(archAcc);

end;

//DECLARACION DE VARIABLES
var
    //Nombre logico del archivo maestro, archivo de accesos al servidor
    maestro: arch;
    
    //Anio a ingresar por el user
    anio : integer;

//PROGRAMA PRINCIPAL

begin

    //Assign del arhivo logico con el archivo fisico
    assign(maestro,'archAccesos');

    //Leer el anio
    writeln('Ingrese un anio, se realizara un informe de los tiempos de acceso al servidor web por fecha y usuario');

    readln(anio);

    InformarTiemposAccesoAnual(maestro,anio);

end.