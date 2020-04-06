##FUN
es_par
##ESQ
comun
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO
-- si el parametro es un entero par devuelve true sino falso
set search_path = encu, dbo, comun, public;
-- Function: comun.es_par(integer)

-- DROP FUNCTION comun.es_par(integer);
CREATE OR REPLACE FUNCTION comun.es_par(p_valor integer)
  RETURNS boolean AS
  'select case when mod(p_valor,2)=0 then TRUE else FALSE end'
  LANGUAGE sql IMMUTABLE;

ALTER FUNCTION comun.es_par(integer)
  OWNER TO tedede_php;

-- DROP FUNCTION comun.es_par(bigint);
CREATE OR REPLACE FUNCTION comun.es_par(p_valor bigint)
  RETURNS boolean AS
'select case when mod(p_valor,2)=0 then TRUE else FALSE end'
  LANGUAGE sql IMMUTABLE
  COST 100;
ALTER FUNCTION comun.es_par(bigint)
  OWNER TO tedede_php;

  
  
##CASOS_SQL    
  SELECT 5 valor,comun.es_par(5) prueba, false esperado
    union select 402 valor,comun.es_par(402) prueba, true esperado
    union select 0 valor, comun.es_par(0) prueba, true esperado
    union select null valor,comun.es_par(null) prueba, false esperado  