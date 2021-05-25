program Merge3DetConRep;
//MERGE DE TRES ARCHIVOS DETALLE CON REPETICION

const 
    valoralto = '9999';
type
    str4 = string[4];
    str10 = string[10];
    vendedor = record
        cod: str4;               
        producto: str10;         
        montoVenta: real;        
    end;
    
    ventas = record
        cod: str4;                
        total: real;              
    end;
    
    detalle = file of vendedor; 
    maestro = file of ventas;   

//AGREGAR PROCEDURE MINIMO

var 
    min, regd1, regd2, regd3: vendedor;
    det1, det2, det3: detalle;
    mae1: maestro;
    regm: ventas;
    aux: str4;


begin
    assign (det1, 'det1'); assign (det2, 'det2'); assign (det3, 'det3'); 
    assign (mae1, 'maestro');
    
    reset (det1);    reset (det2);     reset (det3);
    rewrite (mae1);
    
    leer (det1, regd1);     leer (det2, regd2);     leer (det3, regd3);
    
    minimo(regd1, regd2, regd3,min);
    
    while (min.cod <> valoralto) do begin
        regm.cod := min.cod;
        regm.total := 0;

        while (regm.cod = min.cod ) do begin
            regm.total := regm.total+ min.montoVenta;
            minimo (regd1, regd2, regd3, min);
        end;

        write(mae1, regm);
    end;
end;