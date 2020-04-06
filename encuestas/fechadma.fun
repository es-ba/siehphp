##FUN
fechadma
##ESQ
comun
##DETALLE
NUEVA
##PROVISORIO
CREATE OR REPLACE FUNCTION comun.fechadma (p_dia integer, p_mes integer, p_anio integer)
  RETURNS text AS
$BODY$
DECLARE
  valor_fecha timestamp;
  fecha text;
  mes text;
  dia text;
  anio text;
BEGIN
  IF p_dia is null THEN
     RETURN '';
  END IF;
  IF length(p_dia::text)=1 THEN
     dia='0'||p_dia::text;
  ELSE
     dia=p_dia::text;
  END IF;  
  IF p_mes is null THEN
     RETURN '';
  END IF;
  IF length(p_mes::text)=1 THEN
     mes='0'||p_mes::text;
  ELSE
     mes=p_mes::text;
  END IF;    
  IF p_anio is null THEN
     RETURN '';
  ELSE
     anio=p_anio::text;
  END IF;
  fecha=dia||'/'||mes||'/'||anio;
  IF dbo.es_fecha(fecha)=0 THEN  
	RETURN '';
  END IF;
  RETURN fecha;
END;
/*
     select esperado, comun.fechadma(dia,mes,anio) resultado
      from 
      (select '29/12/2012' as esperado, 29 as dia, 12 as mes, 2012 as anio
      union select '01/02/1925' as esperado, 1 as dia, 2 as mes, 1925 as anio
      union select '' as esperado, 49 as dia, 12 as mes, 2012 as anio
      union select '' as esperado, 31 as dia, 2 as mes, 2012 as anio
      union select '' as esperado, 31 as dia, 1 as mes, 12 as anio
      union select '' as esperado, 31 as dia, 2 as mes, 1972 as anio
      union select '31/01/1970' as esperado, 31 as dia, 1 as mes, 1970 as anio
      union select '' as esperado, null, 1 as mes, 1970 as anio
      union select '' as esperado, 2, null, 1970 as anio
      union select '' as esperado, 2, 3, null
      ) x
      where esperado is distinct from comun.fechadma(dia,mes,anio) 
 */
$BODY$
  LANGUAGE plpgsql IMMUTABLE;
ALTER FUNCTION comun.fechadma(integer, integer, integer)
  OWNER TO tedede_owner;