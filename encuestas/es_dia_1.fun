##FUN
es_dia_1
##ESQ
comun
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO
set search_path = encu, dbo, comun, public;

CREATE OR REPLACE FUNCTION comun.es_dia_1(p_fecha date)
  RETURNS boolean AS
$BODY$  
  SELECT coalesce(extract(DAY from $1::timestamp),1) is not distinct from 1; --l--la tabla por ahora no tiene la restriccion q no sea null este campo
$BODY$
  LANGUAGE sql IMMUTABLE;
ALTER FUNCTION comun.es_dia_1(date)
  OWNER TO tedede_php;

##CASOS_SQL

      select '2014-07-01', es_dia_1('2014-07-01'), true
union select '2014-06-30', es_dia_1('2014-06-30'), false
union select null, es_dia_1(null), false