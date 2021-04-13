Program Aprendiendo_de_Archivos;
type
    //Declara el tipo archivo, que es un archivo de enteros
    archivo = file of integer;

//Procedure que recorre un archivo de enteros, listando los daots,
//informando la cant de nros menores a 1500 y el promedio de los nros
Procedure Recorrer_archivo(var arc_logico: archivo);
var
//Declarar las variables
     cantMinor, cant, sum, nro: integer;
     prom : real;
begin
     //Inicializar contadores y sumadores en 0
     cantMinor := 0;
     cant := 0; sum := 0;

     //Abrir el archivo
     reset(arc_logico);

     //Mientras el puntero del archivo no marque el EOF
     while not eof(arc_logico) do begin
         //Leer del archivo, guardando el dato en nro
         read(arc_logico,nro);
         writeln('En la pos ',filepos(arc_logico),' del archivo, se encuentra el num: ',nro);

         //Actualizar contadores y sumadores
         cant := cant + 1;
         sum += nro;
         if(nro < 1500) then
             cantMinor += 1;
     end;

     //Calcular promedio
     prom := sum / cant;
     //Informar
     writeln('La cantidad de datos menores a 1500 fue: ', cantMinor);
     writeln('El promedio de los datos enteros fue: ', prom:4:4);
end;
var
//Declarar arc logico y fisico
   nro : integer;
   arc_logico: archivo;
   arc_fisico: string[16];
begin
     writeln('Ingrese el nombre del archivo, se recorrera informando la cantidad de enteros menores a 1500, el promedio de sus enteros y el listado de sus datos');

     read(arc_fisico);
     assign(arc_logico,arc_fisico);
     Recorrer_archivo(arc_logico);
     read(nro);
end.

