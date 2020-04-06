##FUN
edadjefe
##ESQ
dbo
##PARA
revisar 
##DETALLE
-- Function: dbo.edadjefe(integer, integer)

-- DROP FUNCTION dbo.edadjefe(integer, integer);

CREATE OR REPLACE FUNCTION dbo.edadjefe(p_enc integer, p_nhogar integer)
  RETURNS integer AS
$BODY$
  select pla_edad 
      from encu.plana_s1_p 
      where pla_enc = p_enc and pla_hog = p_nhogar and pla_p4=1
      limit 1;
$BODY$
  LANGUAGE sql STABLE
  COST 100;
ALTER FUNCTION dbo.edadjefe(integer, integer)
  OWNER TO tedede_php;