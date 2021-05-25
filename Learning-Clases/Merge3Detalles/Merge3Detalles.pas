program Merge3Detalles;
const 
    valoralto = 'zzzz';
type 
    str30 = string[30];
    str10 = string[10];

    //DECLARA UN TIPO: REGISTRO PARA REPRESENTAR ALUMNOS
    alumno = record
        nombre: str30;                
        dni: str10;                   
        direccion: str30;             
        carrera: str10;               
    end;

    //DECLARA UN TIPO: ARCHIVO DE ALUMNOS
    detalle = file of alumno;  

var 
    //DECLARA 4 REG TIPO ALUMNO, TRES PARA LOS 3 ARCHIVOS A PROCESAR, Y UNA VARIABLE AUXILIAR MIN
    min, regd1, regd2, regd3:   alumno;

    //DECLARA CUATRO ARCHIVOS DE ALUMNOS
    det1, det2, det3, maestro : detalle;


//LEE UN REGISTRO DE UN ARCHIVO, SI SE HAN LEIDO TODOS, RETORNA EL VALORALTO QUE HACE DE VARIABLE DE CORTE

procedure leer (var archivo:detalle; var dato:alumno);
    begin
        //SI NO HA LLEGADO AL FINAL DEL ARCHIVO, LEE UN REGISTRO Y LO GUARDA EN LA VAR DATO
        if(not eof( archivo )) then 
            read(archivo, dato)
        //SI LLEGO AL FINAL DEL ARCHIVO, GUARDA EN EL NOMBRE DEL ALUMNO EL VALORALTO (CONSTANTE DE CORTE )
        else 
            dato.nombre := valoralto;
    end;

//RECIBE UN REGISTRO DE C/U DE LOS 3 ARCHIVOS DETALLE Y RETORNA AQUEL CON MENOR NOMBRE (alfabeticamente) EN LA VAR AUX MIN
procedure minimo(var r1, r2, r3: alumno; var min: alumno);
    begin
        if (r1.nombre<r2.nombre) and (r1.nombre<r3.nombre) then begin
            min := r1;
            leer(det1,r1)
        end
        else if (r2.nombre<r3.nombre) then begin
            min := r2;
            leer(det2,r2)
        end
        else begin
            min := r3;
            leer(det3,r3)
        end;
    end;

begin
    //ASSIGN DE CADA ARCHIVO, TRES DETALLES Y UN MAESTRO QUE ALMACENARA LA INFORMACION DE TODOS LOS DETALLLES
    assign (det1, 'det1'); assign (det2, 'det2'); assign (det3, 'det3');
    assign (maestro, 'maestro');

    //CREA ARCHIVO MAESTRO Y LO ABRE
    rewrite (maestro);

    //ABRE LOS TRES ARCHIVOS DETALLE
    reset (det1);    reset (det2);    reset (det3);

    //LLAMA A LEER, PARA LEER EL PRIMER REGISTRO DE CADA ARCHIVO
    leer(det1, regd1); leer(det2, regd2); leer(det3, regd3);

    //CONSIGUE EL MINIMO
    minimo(regd1, regd2, regd3, min);

    //MIENTRAS NO SE ENCUENTRE EL VALORALTO (NO HAY MAS REGISTROS)
    while (min.nombre <> valoralto) do begin
        //ALMACENA EL ALUMNO EN EL ARCHIVO MAESTRO
        write(maestro,min);


        //CONSIGUE EL MINIMO
        minimo(regd1,regd2,regd3,min);
    end;

    //CIERRA EL ARCHIVO
    close(maestro);
end.


