program ej11;

uses SysUtils;
{
                    PRECONDICIONES

                *   1-  EXISTE UN ARCHIVO MAESTRO Y DEBE SER ACTUALIZADO

                *   2-  EXISTEN DOS ARCHIVOS DETALLE

                *   3-  TODOS LOS ARCHIVOS ORDENADOS POR NOMBRE DE PROVINCIA

                *   4-  EN UN ARCH DETALLE PUEDEN HABER 0 O N REG POR CADA PROVINCIA
}
const
    valorAlto = 'ZZZZ';
    dimF = 2;
type

    str25 = string[25];

    provData = record
        nom : str25;
        alfabetizados, encuestados : integer;
    end;

    censoData = record
        nom: str25;
        cod, alfabetizados, encuestados: integer;
    end;


    arc_maestro = file of provData;

    arc_detalle = file of censoData;


    vec_arc_det = array[1..dimF] of arc_detalle;
    vec_reg_det = array[1..dimF] of censoData;

var

    maestro : arc_maestro;

    vec_det : vec_arc_det;

    vec_reg : vec_reg_det;

    regm : provData;

    min : censoData;

    provAct : str25;
    
    i, totAlf, totEnc: integer;

//Leer el siguiente registro del archivo, si es EOF devolver un valor de corte
procedure leer(var arc: arc_detalle; var dato: censoData);
begin
    if(not(eof(arc))) then
        read(arc,dato)
    else
        dato.nom := valorAlto;
end;


{   --RECIBE UN VECTOR DE REGISTROS Y RETORNA EL MINIMO POR NOMBR DE PROVINCIA, EN EL PARAMETRO MIN.
    --ACTUALIZA Y RETORNA EL VECTOR DE REGISTROS LEYENDO EL SIGUIENTE DATO DEL DETALLE CORRESPONDIENTE    }
procedure minimo(var vec_reg: vec_reg_det; var min: censoData);
var
    minPos, i : integer;
begin

    //Recorrer los reg detalle, consiguiendo la posicion del minimo
    for i := 1 to dimF do if((vec_reg[i].nom) < min.nom) then minPos := i;

    //El registro minimo es el que esta en la posicion minPos 
    min := vec_reg[minPos];

    //Leer en el archivo detalle correspondiente, almacenar el siguiente registro en el vector de reg
    leer(vec_det[minPos],vec_reg[minPos]);
end;


//PROGRAMA PRINCIPAL
begin

    //Assign y apertura del archivo maestro
    assign(maestro,'maestro');
    reset(maestro);


    for i := 1 to dimF do begin
        //Assign y apertura de todos los detalle
        assign(vec_det[i],'Det ' + IntToStr(i));
        reset(vec_det[i]);

        //Almacenar primer registro de cada detalle en el vector
        leer(vec_det[i],vec_reg[i]);
    end;

    //Calcular el registro minimo dentro de los archivos detalle
    minimo(vec_reg,min);

    //Leer primer registro maestro
    if(min.nom <> valorAlto) then read(maestro,regm);


    while(min.nom <> valorAlto) do begin

        //Inicializar var de control y totalizadores
        provAct := min.nom;
        totEnc := 0;
        totAlf := 0;

        //Mientras el registro sea de la misma provincia, totalizar los datos
        while(provAct = min.nom) do begin
            totEnc += min.encuestados;
            totAlf += min.alfabetizados;
            minimo(vec_reg,min);
        end;

        //Buscar el registro maestro correspondiente al registro detalle leido
        while(regm.nom <> provAct) do read(maestro,regm);

        //Actualizar los campos del registro
        regm.encuestados += totEnc;
        regm.alfabetizados += totAlf;

        //Posicionar puntero en el registro a actualizar
        seek(maestro,filepos(maestro) - 1);

        //Sobreescribir el registro con sus campos actualizados
        write(maestro,regm);
    
    
        if(not(eof(maestro))) then read(maestro,regm);

    end;


    //Cierre de archivos
    close(maestro);

    for i := 1 to dimF do close(vec_det[i]);

end.