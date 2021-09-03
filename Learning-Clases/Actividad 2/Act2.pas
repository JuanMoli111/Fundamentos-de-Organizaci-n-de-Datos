//  MOLINARI JUAN ROMAN         LEGAJO:  17213/1
program actividad2;
const
    valorAlto = 9999;
    dimF = 2;
type
    subr12 = 1..12;
    subr31 = 1..31;
    subr99 = 0..99;

    fecha = record
        dia : subr12;
        mes : subr31;
        anio: subr99;
    end;

    producto = record
        cod, stockMin, stockDisp: integer;
        precio: real;
    end;

    pedido = record
        cod, cant: integer;
        fecha: fecha;
    end;

    //Declarar tipos para los archivos maestro y detalle
    arc_mae : file of producto;

    arc_det : file of pedido;

    //Declarar tipos para los arreglos de arch detalles y arreglos de registros 
    vec_det : array[1..dimF] of arc_det;
    vec_reg : array[1..dimF] of pedido;

var
    //Declarar archivo maestro
    mae : arc_mae;
    
    //Declarar un vector de archivos detalle y un vector de registros tipo pedido
    vec_reg : vec_reg;
    vec_det : vec_det

    //Un minimo de tipo pedido para manejar los archivos detalle ya que estan ordenados
    min: pedido;

    //Registro maestro
    rm: producto;

    //Str util para assigns de archivos
    str: string[2];

    //aux variable de control; sucursal para saber qué sucursal informar
    aux, sucursal : integer;


procedure leerDetalle(var det: arc_det; var p : pedido);
begin
    if(not(eof(det)))then
        read(det,p)
    else
        p.cod := valorAlto;
end;

procedure minimo(var min: pedido; var minPos: integer);
var
    reg: pedido;
begin

    //Para cada registro del arreglo de registros.
    for i := 1 to dimF do begin
        
        //Si el codigo del reg pedido en una pos i es menor al del minimo, actualizar el minimo
        //   guardar la sucursal de la que vino este pedido (minPos)
        if(vec_reg[i].cod < min) then begin
            min := vec_reg[i];
            minPos := i;
        end;

    end;

    //Leer el siguiente registro del archivo donde encontro el minimo, guardarlo en su respectiva pos del arreglo de registros
    leer(vec_det[minPos],vec_reg[minPos]);

end;

begin

    //Crear y abrir el archivo maestro
    assign(mae,'maestro');
    reset(mae);
    
    //Leer el primer reg del maestro,
    if(not(eof(mae))) then read(mae,rm);


    for i := 1 to dimF do begin
        //Assign y abrir archivos detalle
        String(i,str);
        assign(vec_det[i],'det' + i);
        reset(vec_det[i]);

        //Leer primer registro de cada arc detalle, almacenarlo en el vector de registros
        leer(vec_det[i],vec_reg[i]);
    end;


    //Calcular registro minimo 
    minimo(vec_reg,min,sucursal);

    //MIENTRAS HAYA PRODUCTOS EN LOS ARCHIVOS DETALLE!!
    while(min.cod <> valorAlto) do begin
        
        //Aux sirve para controlar el registro actual (codigo de producto actual)
        aux := min.cod;

        //Encontrar el registro del maestro que corresponde al producto actual
        while(aux <> rm.cod) do read(mae,rm);

        
        //Mientras el tipo de producto sea el mismo, actualizar si alcanzo el stock, de lo contrario informar
        while(rm.cod = min.cod) do begin
            if(rm.stockDisp - min.cant >= 0) then 
                rm.stockDisp := rm.stockDisp - min.cant;
            else begin
                //INFORMAR la sucursal y los datos del producto, y cuanto hizo falta para satisfacer el pedido
                writeln('Sin stock para el pedido de la sucursal ', sucursal);
                writeln('Hacen falta ', (min.cant - rm.stockDisp)  ,' unidades del producto de codigo ',rm.cod,' para satisfacer este pedido')
                rm.stockDisp := 0;
            end;

            //Calcular nuevo reg minimo
            minimo(vec_reg,min,sucursal);
        end;

        //Informar los productos cuyo stock hayan quedado debajo del stock minimo aceptable
        if(rm.stockDisp < rm.stockMin) then writeln('El stock del producto de codigo ',rm.cod,' esta por debajo del minimo');
        
        //Volver a la posicion del maestro donde se registra este tipo de producto
        seek(mae,filepos(mae) - 1);

        //Sobreescribirlo con los datos del stock actualizados
        write(mae,rm);

        //Leer siguiente reg maestro
        if(not(eof(mae))) then read(mae);
    end;


    //CERRAR ARCHIVOS
    for i := 1 to dimF do close(vec_det[i]);

    close(mae);
end.