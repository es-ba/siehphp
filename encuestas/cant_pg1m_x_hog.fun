##FUN
cant_pg1m_x_hog
##ESQ
dbo
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO
set search_path = encu, dbo, comun, public;
CREATE OR REPLACE FUNCTION dbo.cant_pg1m_x_hog(p_enc integer, p_hog integer)
  RETURNS integer AS
$BODY$
DECLARE
 v_cantidad integer;
BEGIN 
  select count(*) into v_cantidad 
  from encu.plana_pg1_m where pla_enc=p_enc and pla_hog=p_hog;
  return v_cantidad;
END;
$BODY$
  LANGUAGE plpgsql STABLE;
ALTER FUNCTION dbo.cant_pg1m_x_hog(integer, integer)
  OWNER TO tedede_php;
##CASOS_SQL