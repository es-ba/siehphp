/* ##FUN
max_mie_ingresado
##ESQ
dbo
##PARA
provisoria
##DETALLE 
maximo numero de miembro existente en la tabla plana_s1_p
*/
-- Function: dbo.max_mie_ingresado(integer, integer)

-- DROP FUNCTION dbo.max_mie_ingresado(integer, integer);

CREATE OR REPLACE FUNCTION dbo.max_mie_ingresado(p_enc integer, p_hog integer)
  RETURNS integer AS
$BODY$
DECLARE
 v_mie_max integer;
BEGIN 
  select max(pla_mie) into v_mie_max
  from encu.plana_s1_p where pla_enc=p_enc and pla_hog=p_hog;
  return v_mie_max;
END;
$BODY$
  LANGUAGE plpgsql STABLE;
ALTER FUNCTION dbo.max_mie_ingresado(integer, integer)
  OWNER TO tedede_php;
  
