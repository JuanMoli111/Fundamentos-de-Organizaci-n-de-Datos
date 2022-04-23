program RedictadoFOD;
type

    str15 = string[15];
    arc_int = file of integer;
var

    arc : arc_int;
    int : integer;
    nom : str15;
begin
    
    //Ingresar nombre del archivo
    writeln('Ingrese el nombre del archivo');
    readln(nom);

    //Declarar y crear el archivo de enteros
    assign(arc,nom);
    rewrite(arc);

    writeln('Ingrese un entero a agregar al archivo');

    readln(int);

    while(int <> 30000) do begin

        write(arc,int);

        readln(int);

    end;


    close(arc);


    reset(arc);

    while(not(EOF(arc))) do begin
        read(arc,int);
        writeln(int);

    end;

end.