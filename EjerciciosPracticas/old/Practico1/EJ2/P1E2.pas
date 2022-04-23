program tp1e2;
type

    arc_int = file of integer;
    str15 = string[15];

var

    arc : arc_int;

    nom : str15;

    int, sum, cant, cantM : integer;
begin
    //Inicializar las variables necesarias
    sum := 0;
    cant := 0;
    cantM := 0;

    //Solicita el nombre del archivo a abrir
    writeln('Ingrese el nombre del archivo');
    readln(nom);

    //Asignacion del arc logico con el fisico
    assign(arc,nom);

    //abrir el archivo de enteros
    reset(arc);

    //Recorrer el archivo entero 
    while(not(EOF(arc))) do begin

        //Leer un dato
        read(arc,int);

        //Sum y cant sirven para calcular el promedio de los datos
        sum += int;
        cant += 1;

        //Listar en pantalla los datos del archivo
        writeln('El dato: ' ,int);


        //Si el entero es menor a 1500 incrementar la cant de enteros menores a 1500
        if(int < 1500) then cantM += 1;
    end;

    close(arc);


    writeln('El promedio de los datos es: ', (sum/cant):2:2);

    writeln('La cantidad de datos menores a 1500 es: ', cantM);


end.