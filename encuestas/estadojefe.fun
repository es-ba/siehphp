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
CREATE OR REPLACE FUNCTION dbo.estadojefe(p_enc integer, p_hog integer)
  RETURNS integer 
  LANGUAGE sql STABLE
  AS
$BODY$
    select pla_p5
      from encu.plana_s1_p
      where pla_enc=p_enc 
        and pla_hog=p_hog
        and pla_p4=1
      limit 1;
$BODY$;
ALTER FUNCTION dbo.estadojefe(integer, integer)
  OWNER TO tedede_php;
##NOMBRE
Estado conyugal del jefe
##DESCRIPCION
En caso de que haya más de un jefe muestra el estado conyugal de cualquiera de ellos
Antes de usarla hay que garantizar que se han limpiado todos los doblejefes.

