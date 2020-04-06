##FUN
cant_a1_x_hog
##ESQ
dbo
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO
set search_path = encu, dbo, comun, public;
CREATE OR REPLACE FUNCTION dbo.cant_a1_x_hog(p_enc integer, p_hog integer)
  RETURNS integer AS
$BODY$
DECLARE
 v_cantidad integer;
BEGIN 
  select count(*) into v_cantidad 
  from encu.plana_a1_ where pla_enc=p_enc and pla_hog=p_hog;
  return v_cantidad;
END;
$BODY$
  LANGUAGE plpgsql IMMUTABLE
  COST 100;
ALTER FUNCTION dbo.cant_a1_x_hog(integer, integer)
  OWNER TO tedede_php;
##CASOS_SQL