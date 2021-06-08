program P3E3;
const
    valorAlto = -9999;

type

    str25 = string[25];


    novela = record
        cod, duracion: integer;
        gen, nom, director: str25;
        precio : real;
    end;

    