program P1E7;
type

    novela = record
        cod: integer;
        nombre, genero : string[20];
        precio: real;
    end;


    archivo_bin_novelas = file of novela;
    archivo_txt_novelas = text;
procedure LeerNovela(var n: novela);
begin
    writeln('Ingrese un codigo de novela');    readln(n.cod);
    if(n.cod <> 0) then begin

        with n do begin
            writeln('Ingrese el nombre');    readln(nombre);
            writeln('Ingrese el genero');    readln(genero);
            writeln('Ingrese el precio');    readln(precio);  
        end;
    end;
end;

procedure AgregarNovela(var arc_bin: archivo_bin_novelas);
var
    n: novela;
begin
    Reset(arc_bin);


    LeerNovela(n);

    Seek(arc_bin,FileSize(arc_bin));
    write(arc_bin,n);

    close(arc_bin);
end;
procedure ModificarNovela(var arc_bin: archivo_bin_novelas);
var
    n: novela;
    codigo: integer;
begin

    Reset(arc_bin);

    writeln('Ingrese un codigo de novela a modificar sus datos');
    ReadLn(codigo);

    while(not(eof(arc_bin))) do begin
        Read(arc_bin,n);    
        if(n.cod = codigo) then break;
    end;

    if(n.cod = codigo) then begin
        seek(arc_bin,FilePos(arc_bin) - 1);

        LeerNovela(n);

        write(arc_bin,n);
    end
    else writeln('El codigo ingresado no corresponde a ninguna novela');
    

    close(arc_bin);
end;
var
    arc_bin_novelas: archivo_bin_novelas;
    arc_txt : archivo_txt_novelas;

    n : novela;

    opc: integer;
begin
  
    Assign(arc_txt,'novelas.txt');
    Assign(arc_bin_novelas,'novelasBin');

    Reset(arc_txt);
    Rewrite(arc_bin_novelas);

    while(not(eof(arc_txt))) do begin
      
        with n do begin
          
            readln(arc_txt,cod,precio,genero);
            readln(arc_txt,nombre);

            write(arc_bin_novelas,n);
        end;    


    end;   

    Close(arc_bin_novelas);
    close(arc_txt);

    writeln(' 1- Agregar una novela al archivo');
    writeln(' 2- Modificar una novela del archivo');

    writeln('Ingrese una opcion: ');
    readln(opc);

    repeat
      
        case (opc) of
            1: AgregarNovela(arc_bin_novelas);

            2: ModificarNovela(arc_bin_novelas);
        end;
        
        writeln('Ingrese una nueva opcion: ');
        readln(opc);
    until(opc = 0);

end.