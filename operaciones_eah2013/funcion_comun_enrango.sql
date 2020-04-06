-- Function: comun.enrango(integer, integer, integer)

-- DROP FUNCTION comun.enrango(integer, integer, integer);

CREATE OR REPLACE FUNCTION comun.enrango("P_valor" integer, "P_minimo" integer, "P_maximo" integer)
  RETURNS integer AS
'SELECT CASE WHEN ($1>=$2 and $1<=$3) THEN 1 ELSE 0 END'
  LANGUAGE sql IMMUTABLE
  COST 100;
ALTER FUNCTION comun.enrango(integer, integer, integer)
  OWNER TO tedede_php;

