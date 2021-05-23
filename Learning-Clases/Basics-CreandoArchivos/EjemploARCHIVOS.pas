Program EjemploARCHIVOS;
type
    //Declara el tipo archivo, que es un archivo de enteros
    archivo = file of integer;
var
   //Declara la variable arc_logico, nombre l�gico del archivo
   arc_logico: archivo;
   nro: integer;

//Procedimiento que recorre el archivo imprimiendo sus elementos
Procedure Recorrido(var arc_logico: archivo );
  var  nro: integer;  
  
  begin
    reset( arc_logico ); 
   	   while not eof( arc_logico) do begin
        read(arc_logico, nro );
        writeln(nro);
        writeln('La pos: ',FilePos(arc_logico))
     end;
     close( arc_logico );
  end;
//Procedimiento que crea y rellena un archivo de integers,tipo arc_logico
Procedure Generar_archivo(var arc_logico: archivo);
var
   arc_fisico: string[12];
begin
    //Ingresa un nombre para el archivo,
    write( 'Ingrese el nombre del archivo:' );
    read( arc_fisico ); 

    //Establecer la correspondencia entre nombres l�gico y f�sico del archivo
    assign( arc_logico,arc_fisico );
    //Crear el archivo arc_logico
    rewrite(arc_logico);
    read(nro);
    //Hasta que se ingrese el 0, leer numeros y almacenarlo en el archivo
    while nro <> 0 do begin
        write( arc_logico, nro ); 
        read( nro );
        writeln('El espacio ocupado es:' , FileSize(arc_logico))
    end;

end;

begin
     Generar_archivo(arc_logico);
     Recorrido(arc_logico);
     read( nro );
end.

