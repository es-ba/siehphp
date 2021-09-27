/* ##FUN
texto_a_fecha_date
##ESQ
dbo
##PARA
provisoria
##DETALLE */
--Funcion sinonima de dbo.texto_a_fecha(text)
--se tuvo que definir por la diferencia en output de la version javascript y ser utilizada en consistencias de momento Relevamiento para eah2021
-- Function: dbo.texto_a_fecha_date(text)

-- DROP FUNCTION dbo.texto_a_fecha_date(text);

CREATE OR REPLACE FUNCTION dbo.texto_a_fecha_date(p_valor text)
    RETURNS date
    LANGUAGE 'sql'
    IMMUTABLE 
AS $BODY$
select dbo.texto_a_fecha(p_valor)
$BODY$;

ALTER FUNCTION dbo.texto_a_fecha_date(text)
    OWNER TO tedede_php;

-- ##CASOS
select dbo.texto_a_fecha_date(f_txt) is not distinct from resultado as ok, f_txt, resultado as esperado, dbo.texto_a_fecha_date(f_txt) as recibido
    from (
      select '06/05/1969'::text as f_txt, '06/05/1969'::date as resultado
      union select '20/09/2014', '20/09/2014'::date
      union select '99/99/9999', null
      union select '15/99/9999', null
      union select '99/99/2004', null
      union select '99/11/9999', null
      union select '//////2004', null
      union select '01/09/2013', '01/09/2013'::date
         ) x 
    where dbo.texto_a_fecha_date(f_txt) is distinct from resultado or true
  
