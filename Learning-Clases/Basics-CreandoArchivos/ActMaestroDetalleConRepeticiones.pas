program archivosMejorado;
//ACTUALIZA STOCK DE UN MAESTRO DE DE PRODUCTOS, CON UN DETALLE DE VENTAS DE PRODUCTOS,
// UN PRODUCTO PUEDE REGISTRAR MUCHAS VENTAS (HAY COD DE PRODS REPETIDOS)
// LOS PRODUCTOS PROBABLAMENTE ESTEN ORDENADOS POR COD
const valoralto='9999';

type 
    str4 = string[4];
    //REGISTRO PRODUCTO
    prod = record
        cod: str4;                   
        descripcion: string[30];     
        pu: real;                    
        cant: integer;               
    end;
    //REGISTRO VENTA DE PROD
    v_prod = record
        cod: str4;               
        cv: integer;   
    end;
    //DECLARE ARCHIVO DETALLE Y MAESTRO
    detalle = file of v_prod;     
    maestro = file of prod;

procedure leer (var archivo:detalle; var dato:v_prod);
begin
    if(not eof(archivo)) then 
        read (archivo,dato)
    else 
        dato.cod := valoralto;
    end;   
var
    //DECLARE REGISTROS AUXILIARES PROD Y VENTA PROD, 
    //DECLARE DOS VARIABLES ARCHIVO, MAESTRO Y DETALLE
    regm: prod;
    regd: v_prod;
    mae1: maestro;
    det1: detalle;
    total: integer;
begin
    //SE ASIGNAN LAS VARIABLES A LOS ARCHIVOS FISICOS YA EXISTENTES
    assign(mae1, 'maestro');  
    assign(det1, 'detalle');
    //ABRE LOS ARCHIVOS MAESTRO Y DETALLE
    reset(mae1);  
    reset(det1);

    //Leer el primer registro del arch detalle
    leer(det1,regd);

    //Mientras el cod sea distinto al ¿valor de corte?
    while (regd.cod <> valoralto) do begin
        //Leer el siguiente registro del archivo maestro
        read(mae1, regm);

        //Mientras el cod del reg del archivo M sea distinto del cod del reg del archivo D, leer el siguiente reg del arch M
        while(regm.cod <> regd.cod) do
            read(mae1,regm);

            //Mientras los cod sean iguales, ir actualizando el stock del reg producto segun cuantos se vendieron, leer el sig reg del arch Detalle
            while(regm.cod = regd.cod) do begin
                regm.cant := regm.cant - regd.cv;        
                leer(det1,regd);          
            end;

        //Ubicarse en la posicion anterior del archivo maestro (donde está el registro ÚNICO del prod a actualizar)
        seek(mae1, filepos(mae1)-1);
        //Reescribir el producto con su nuevo stock (registro auxiliar)
        write(mae1,regm);
    end;

    
end.
