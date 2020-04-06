##FUN
norea_recuperable
##ESQ
dbo
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO
set search_path= encu, comun, dbo, public;
DROP FUNCTION if exists dbo.norea_recuperable(integer);
/*otra*/
CREATE OR REPLACE FUNCTION dbo.norea_recuperable(p_norea integer)
  RETURNS boolean AS
$BODY$
 select p_norea = 10 or (p_norea >=70 and p_norea not in (91,95,96));
 -- select p_norea = 10 or (p_norea >=70 and p_norea not in (91,95,96,990,991)); OJO para SAME2014
$BODY$
  LANGUAGE sql IMMUTABLE;
/*otra*/
ALTER FUNCTION dbo.norea_recuperable(integer)
  OWNER TO tedede_php;
