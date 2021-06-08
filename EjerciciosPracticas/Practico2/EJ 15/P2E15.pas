program P2E15;
const
    valorAlto = -9999;

type

    info_alumno = record
        dni, cod: integer;
        monto : real;
    end;

    arc_alumnos = file of info_alumno;