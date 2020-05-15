##FUN
parte_fecha_dma
##ESQ
dbo
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO
CREATE OR REPLACE FUNCTION dbo.parte_fecha_dma(
	parte text,
	fecha date)
    RETURNS integer
    LANGUAGE 'sql'
    VOLATILE 
AS $BODY$
  select date_part(CASE parte WHEN 'dia' THEN 'day' WHEN 'mes' THEN 'month' WHEN 'anio' THEN 'year' ELSE 'year' END, fecha) ::integer
$BODY$;

ALTER FUNCTION dbo.parte_fecha_dma(text, date)
    OWNER TO tedede_php;
