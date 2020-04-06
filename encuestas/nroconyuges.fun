##FUN
nroconyuges
##ESQ
dbo
##PARA
produccion
##PUBLICA
Sí
##PAR
p_enc INTEGER
p_hog INTEGER
p_mie INTEGER
##TIPO_DEVUELTO
boolean
##CUERPO
-- DROP FUNCTION dbo.nroconyuges(integer,integer);

CREATE OR REPLACE FUNCTION dbo.nroconyuges(p_enc integer, p_hog integer)
  RETURNS bigint
  LANGUAGE sql STABLE
  AS
$BODY$
    select count(*) 
      from encu.plana_s1_p 
      where pla_enc=p_enc
        and pla_hog=p_hog
        and pla_p4=2;
$BODY$;
ALTER FUNCTION dbo.nroconyuges(integer, integer)
  OWNER TO tedede_php;
##NOMBRE
Número de Conyuges
##DESCRIPCION
Cuenta la cantidad de miembros del s1_p que dicen ser el conyuje del jefe
