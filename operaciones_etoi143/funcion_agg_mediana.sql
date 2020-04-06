-- Function: comun.final_mediana(anyarray)

-- DROP FUNCTION comun.final_mediana(anyarray);

CREATE OR REPLACE FUNCTION comun.final_mediana(anyarray)
  RETURNS double precision AS
$BODY$ 
  WITH q AS
  (
     SELECT val
     FROM unnest($1) val
     WHERE VAL IS NOT NULL
     ORDER BY 1
  ),
  cnt AS
  (
    SELECT COUNT(*) AS c FROM q
  )
  SELECT AVG(val)::float8
  FROM 
  (
    SELECT val FROM q
    LIMIT  2 - MOD((SELECT c FROM cnt), 2)
    OFFSET GREATEST(CEIL((SELECT c FROM cnt) / 2.0) - 1,0)  
  ) q2;
$BODY$
  LANGUAGE sql IMMUTABLE;
ALTER FUNCTION comun.final_mediana(anyarray)
  OWNER TO tedede_owner;
  
-- Function: mediana(anyelement)

-- DROP AGGREGATE mediana(anyelement);

CREATE AGGREGATE mediana(anyelement) (
  SFUNC=array_append,
  STYPE=anyarray,
  FINALFUNC=comun.final_mediana,
  INITCOND='{}'
);
