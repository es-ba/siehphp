##FUN
norea_supervisable
##ESQ
dbo
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO
set search_path= encu, comun, dbo, public;
DROP FUNCTION if exists dbo.norea_supervisable(integer);
/*otra*/
CREATE OR REPLACE FUNCTION dbo.norea_supervisable(p_norea integer)
  RETURNS boolean AS
$BODY$
 select p_norea in (91,95,96) or (p_norea not in (10,18) and (p_norea <70));
$BODY$
  LANGUAGE sql IMMUTABLE;
/*otra*/
ALTER FUNCTION dbo.norea_supervisable(integer)
  OWNER TO tedede_php;
