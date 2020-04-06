CREATE OR REPLACE FUNCTION dbo.cadena_normalizar(p_cadena text)
  RETURNS text AS
$BODY$

/*
-- Pruebas:
select entrada, esperado, dbo.cadena_normalizar(entrada)
    , esperado is distinct from dbo.cadena_normalizar(entrada)
  from (
  select 'hola' as entrada, 'HOLA' as esperado
  union select 'Cañuelas', 'CAÑUELAS'
  union select 'ÁCÉNTÍTÓSÚCü','ACENTITOSUCU'
  union select 'CON.SIGNOS/DE-PUNTUACION    Y MUCHOS ESPACIOS','CON SIGNOS DE-PUNTUACION Y MUCHOS ESPACIOS'
  union select 'CONÁÀÃÄÂáàãäâ   A', 'CONAAAAAAAAAA A'
  union select 'vocalesÁÒöÈÉüÙAeùúÍî?j', 'VOCALESAOOEEUUAEUUII J'
  union select 'ÅåÕõ.e', 'AAOO E'
) casos
  where esperado is distinct from dbo.cadena_normalizar(entrada);
*/
  select upper(trim(regexp_replace(translate ($1, 'ÁÀÃÄÂÅÉÈËÊÍÌÏÎÓÒÖÔÕÚÙÜÛáàãäâåéèëêíìïîóòöôõúùüûçÇ¿¡!:;,?¿"./,()_^[]*$', 'AAAAAAEEEEIIIIOOOOOUUUUaaaaaaeeeeiiiiooooouuuu                      '), ' {2,}',' ','g')));
$BODY$
 LANGUAGE sql IMMUTABLE;
ALTER FUNCTION dbo.cadena_normalizar(text)
  OWNER TO tedede_owner;