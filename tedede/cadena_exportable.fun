##FUN
cadena_exportable
##ESQ
comun
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO
CREATE or REPLACE FUNCTION comun.cadena_exportable(p_cadena TEXT, p_separador TEXT) returns TEXT
  LANGUAGE SQL
as 
$$
  SELECT regexp_replace(p_cadena, '[\r\n\t'||coalesce(p_separador,'')||']+', ',', 'g');
$$;

ALTER FUNCTION comun.cadena_exportable(TEXT, TEXT) OWNER TO tedede_owner;
-- ##CASOS_SQL
SELECT * FROM (
  SELECT esperado, 
         CASE WHEN esperado is distinct from comun.cadena_exportable(cadena, separador) THEN 'DISTINTO' ELSE NULL END as resultado,
         comun.cadena_exportable(cadena, separador), 
         cadena, separador
    FROM (
      SELECT 'sin cambios' as esperado, 'sin cambios' as cadena, ';' as separador
      UNION SELECT 'uno,dos, tres', 'uno;dos; tres', ';'
      UNION SELECT 'esto,tiene un corte', $$esto
tiene un corte$$,';'
    ) x)x
  WHERE resultado is not null;
