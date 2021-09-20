program ej6;
uses SysUtils;
{
    PRECONDICIONES


    *   1-  EXISTE UN ARCHIVO MAESTRO CON INFORMACION DE ARTICULOS

    *   2-  EXISTEN 15 ARCHIVOS DETALLE CON INFORMACION DE VENTA DE ARTICULOS

    *   3-  TODOS LOS ARCHIVOS ESTAN ORDENADOS POR CODIGO DE ARTICULO

    *   4-  LOS ARCHIVOS DETALLE PUEDEN TRAER 0 O N REGISTROS DE VENTAS PARA CADA ARTICULO

    *   5-  DEBE ACTUALIZARSE EL STOCK DEL MAESTRO SEGUN LAS VENTAS DE LOS DETALLES

    
    
    EL CICLO PRINCIPAL DEBE RECORRER LOS DETALLES, por prec 5


    EL MAESTRO SE PUEDE RECORRER SIN VERIFICAR END OF FILE PUES SI EXISTE 
    UN REGISTRO DETALLE SEGURO EXISTE UN REGISTOR MAESTRO QUE LE CORRESPONDE -> por prec 5
}
const

    dimF = 15;
    valorAlto = -999;
type

    str20 = string[20]; 

    articulo = record
        cod: integer;
        nom, desc, talle, color: str20;
        stockDisp, stockMin : integer;
        precio: real;
    end;

    venta = record
        cod, cant: integer;
    end;

    //Definir tipo para archivo detalle
    arc_maestro = file of articulo;

    arc_detalle = file of venta;

    //Definir tipos arreglo para el manejo de archivos detalle y sus registros
    vec_detalles = array [1..dimF] of arc_detalle;
    vec_reg_det = array[1..dimF] of venta;

//DECLARACION DE VARIABLES
var
    vec_det : vec_detalles;
    vec_reg : vec_reg_det;

    texto : text;

    maestro : arc_maestro;

    regm: articulo;

    min : venta;

    i, codAct, totVendido: integer;

//DEVOLVER SIGUIENTE REGISTRO DE UN ARCHIVO, SI ES EOF DEVOLVER UN VALOR DE CORTE
procedure leerDet(var arc: arc_detalle; var dato: venta);
begin
    if(not(eof(arc))) then
        read(arc,dato)
    else
        dato.cod := valorAlto;
end;    

{   --RECIBE UN VECTOR DE REGISTROS Y RETORNA EL MINIMO POR CODIGO DE ARTICULO, EN EL PARAMETRO MIN.
    --ACTUALIZA Y RETORNA EL VECTOR DE REGISTROS LEYENDO EL SIGUIENTE DATO DEL DETALLE CORRESPONDIENTE    }
procedure minimo(var vec_reg: vec_reg_det; var min: venta);
var
    minPos, i : integer;
begin

    //Recorrer los reg detalle, consiguiendo la posicion del minimo
    for i := 1 to dimF do if(vec_reg[i].cod < min.cod) then minPos := i;

    //El registro minimo es el que esta en la posicion minPos 
    min := vec_reg[minPos];

    //Leer en el archivo detalle correspondiente, almacenar el siguiente registro en el vector de reg
    leerDet(vec_det[minPos],vec_reg[minPos]);
end;

//PROGRAMA PRINCIPAL
begin

    //Assign y abrir el archivo maestro
    assign(maestro,'maestro');
    reset(maestro);

    assign(texto,'texto.txt');
    rewrite(texto);

    //Para cada archivo del vector de archivos detalle
    for i := 1 to dimF do begin
        //Assign y apertura de los arhcivos
        assign(vec_det[i],'detalle ' + IntToStr(i));
        reset(vec_det[i]);

        //Almacenar el primer registro de cada archivo en el vector de registros
        leerDet(vec_det[i],vec_reg[i]);
    end;

    minimo(vec_reg,min);


    while(min.cod <> valorAlto) do begin

        read(maestro,regm);

        //Inicializar variables de control y contador
        codAct := min.cod;
        totVendido := 0;

    
        //Mientras el articulo sea el mismo, totalizar la cantidad vendida, leer otro articulo
        while(codAct = min.cod) do begin
            totVendido += min.cant;
            minimo(vec_reg,min);
        end;

        //Recorrer el maestro hasta encontrar el articulo a actualizar
        while(codAct <> regm.cod) do read(maestro,regm);

        //Para el registro Maestro
        with regm do begin
            //Actualizar stock 
            stockDisp -= totVendido;

            //Si el stock es bajo, exportar la informacion del articulo a un .txt
            if(stockDisp < stockMin) then write(texto,precio,'       ',stockDisp,'        ',desc,'        ',nom);
        end;

        //Actualizacion del archivo maestro.
        seek(maestro,filepos(maestro) - 1);
        write(maestro,regm);      
                                                                                                                                                                       
    end;

    //CERRAR ARCHIVOS
    close(texto);
    close(maestro);
    for i := 1 to dimF do close(vec_det[i]);

end.