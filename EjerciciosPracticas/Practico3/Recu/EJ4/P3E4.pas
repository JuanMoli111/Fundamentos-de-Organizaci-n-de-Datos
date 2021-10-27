program ej4;
uses SysUtils;

const

    valorAlto = 'ZZZZZZZZZZZZ';
type


    tTitulo = string[50];

    tArchRevistas = file of tTitulo;


procedure leer(var arc: tArchRevistas; var dato: tTitulo);
begin
    if(not(eof(arc))) then read(arc,dato)
    else dato := valorAlto;
end;
//Crea un archivo de revistas con registro cabecera inicializado
procedure CrearArchivo(var arc: tArchRevistas);
var
    reg : tTitulo;
begin
    //Setear el reg cabecera, sus datos en null
    reg := '0';

    //Crear el archivo y escribir la novela que hace de reg cabecera
    reset(arc);

    write(arc,reg);

    close(arc);
end;

procedure AgregarRevista(var arc: tArchRevistas; titulo: string);
var
    regCab: tTitulo;
begin
    
    //Abrir arch
    reset(arc);

    //Leer reg cabecera
    read(arc,regCab);


    //Si el reg cabecera fue cero, no hay espacio en el archivo
    if(regCab = '0') then begin

        //Posicionarse al final del archivo y escribir el nuevo registro
        seek(arc,filesize(arc));
        write(arc,titulo);

    end
    //Si el reg cabecera tiene un signo menos en el primer caracter, este numero indica un espacio libre
    else if (pos(regCab,'-') = 1) then begin


        //Dirigirse al indice que indica el cod
        seek(arc,StrToInt(regCab) * -1);

        //Leer el reg que contiene la pos a guardar en la cabecera              Notar que accedimos el indice con la misma var en la que, guardaremos un nuevo indice encontrado en esa posicion, 
        read(arc,regCab);

        //Volver atras para pisar el registro anterior, ahora que ya hemos salvado el indice, guardaremos el reg nuevo
        seek(arc,filepos(arc) - 1);
        write(arc,titulo);


        //Dirigirse a reg cabecera y guardar el indice con el sig espacio libre, o en su defecto un cero.
        seek(arc,0);
        write(arc,regCab);
    end;


    //Cerrar arch
    close(arc);
    

end;
procedure ListarContenido(var arc: tArchRevistas);
var
    str : tTitulo;
begin
    
    reset(arc);

    //Omitir registro cabecera
    leer(arc,str);

    //Leer primer registro
    leer(arc,str);

    writeln('Revistas :');

    //Mientras haya registros
    while(str <> valorAlto) do begin

        //Si la pos de un char - es distinto de 1 (no esta al principio del string, o, si es 0, no esta)
        //Significa que el registro actual no fue borrado logicamente por tanto debe listarse
        if(( pos(str,'-') <> 1) and (str <> '0'))then writeln(str);

        //Leer siguiente registro
        leer(arc,str);
    end;

    //Cerrar arch
    close(arc);

end;
//Revisar para soluciones mas eficientes: 

//      al saltear el cabecera podria salvarlo y realizar luego menos operaciones


procedure EliminarRevista(var arc: tArchRevistas; titulo : string);
var
    reg, regCab: tTitulo;

    encontro : boolean;
begin

    //Var de control
    encontro := false;

    //Abrir archivo
    reset(arc);


    //Saltear reg cabecera
    leer(arc,reg);

    //Leer primer reg titulo
    leer(arc,reg);

    //Mientras no se terminen los regs
    while((reg <> valorAlto) and not(encontro)) do begin
            

        //Si este registro tiene el codigo solicitado
        if(reg = titulo) then begin
            
            //Volver el puntero al reg a eliminar
            seek(arc,filepos(arc) - 1);
                

            //Guardar esta pos para intercambiarla por la cabecera
            reg := IntToStr(filepos(arc) * -1);

            //Borrar logicamente poniendole su indice en negativo
            write(arc,reg);


            //Leer el reg cabecera
            seek(arc,0);
            read(arc,regCab);

        {Intercambiar los indices}

            //Escribir el reg borrado logic en la cabecera,
            seek(arc,0);
            write(arc,reg);

            //Escribir el reg cabecera en la ultima pos borrada
            seek(arc,StrToInt(reg) * -1);
            write(arc,regCab);

        {}

                
            encontro := true;
        end;


            //Leer siguiente reg revista
        leer(arc,reg);

    end;


    if(encontro) then writeln('Exito!');


    close(arc);
end;
var

    arch: tArchRevistas;
begin

    assign(arch,'revistas');

    rewrite(arch);

    CrearArchivo(arch);

    AgregarRevista(arch,'AAA');
    AgregarRevista(arch,'bbb');
    AgregarRevista(arch,'ccA');


    AgregarRevista(arch,'AddA');
    
    ListarContenido(arch);

    EliminarRevista(arch,'bbb');

    ListarContenido(arch);

end.