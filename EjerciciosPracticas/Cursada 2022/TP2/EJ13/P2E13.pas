program P2E13;
const
    valorAlto = 19997;
type

    str20 = string[20];


    log_maestro = record
        nro_user, cant_mails: integer;
        nombre_user, nombre, apellido: str20;
    end;

    log_detalle = record
        nro_user, cuenta_destino: integer;
        mensaje : string[500];
    end;


    archivo_maestro = file of log_maestro;
    archivo_detalle = file of log_detalle;




var

begin
  
end.