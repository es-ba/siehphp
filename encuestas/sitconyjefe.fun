##FUN
sitconyjefe
##ESQ
dbo
##PARA
produccion
##PUBLICA
Sí
##PAR
p_enc INTEGER
p_hog INTEGER
##TIPO_DEVUELTO
integer
##CUERPO
CREATE OR REPLACE FUNCTION dbo.sitconyjefe(p_enc integer, p_hog integer)
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
ALTER FUNCTION dbo.sitconyjefe(integer, integer)
  OWNER TO tedede_php;
##NOMBRE
situacion conyugal del jefe
##DESCRIPCION
En caso de que haya más de un jefe muestra el estado conyugal de cualquiera de ellos
Antes de usarla hay que garantizar que se han limpiado todos los doblejefes.

