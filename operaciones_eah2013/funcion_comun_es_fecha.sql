CREATE OR REPLACE FUNCTION comun.es_fecha(valor text)
  RETURNS boolean AS
$BODY$
DECLARE
  valor_fecha timestamp;
BEGIN
  if valor is null THEN
     RETURN false;
  end if;
  valor_fecha :=comun.valor_fecha(valor);
  RETURN true;
EXCEPTION
  WHEN invalid_datetime_format THEN
    RETURN false;  
  WHEN datetime_field_overflow THEN
    RETURN false;  
  WHEN raise_exception THEN
    RETURN false;  
  WHEN others THEN     return false;
END;
$BODY$
  LANGUAGE plpgsql IMMUTABLE
  COST 100;
ALTER FUNCTION comun.es_fecha(text)
  OWNER TO tedede_owner;


CREATE OR REPLACE FUNCTION comun.valor_fecha(p_valor text)
  RETURNS timestamp AS
$BODY$
DECLARE
  valor_fecha timestamp;
BEGIN
  if p_valor ~ '^[\s]*[0-9][0-9][0-9][0-9][-/][0-1]?[0-9][-/][0-3]?[0-9]([\s][0-9][0-9][:][0-9][0-9]([:][0-9][0-9])?)?[\s]*$' THEN
     valor_fecha :=TO_TIMESTAMP(p_valor,'YYYY-MM-DD HH24:MI:SS'); 
  elseif p_valor  ~ '^[\s]*[0-3]?[0-9][-/][0-1]?[0-9][-/][0-9][0-9][0-9][0-9]([\s][0-9][0-9][:][0-9][0-9]([:][0-9][0-9])?)?[\s]*$' THEN
     valor_fecha :=TO_TIMESTAMP(p_valor,'DD-MM-YYYY HH24 MI SS');     
  else
    raise exception 'no se pudo';
  end if;
  RETURN valor_fecha;
EXCEPTION
  WHEN invalid_datetime_format THEN
    RETURN null; 
  -- when others THEN     return null; 
END;
$BODY$
  LANGUAGE plpgsql IMMUTABLE
  COST 100;
ALTER FUNCTION comun.valor_fecha(text)
  OWNER TO tedede_owner;

select comun.es_fecha(entrada), entrada, case when comun.es_fecha(entrada) then comun.valor_fecha(entrada) else null end, esperado_f
  from (
     select       true  as esperado_es, '2013-02-03' as esperado_f, '2013-02-03'::text as entrada
     union select true  as esperado_es, '2013-02-03' as esperado_f, '2013/2/3  '::text as entrada
     union select true  as esperado_es, '2013-02-03' as esperado_f, '  2013/2/3'::text as entrada
     union select true  as esperado_es, '2013-02-03' as esperado_f, '3/2/2013'  ::text as entrada
     union select false as esperado_es, null         as esperado_f, 'x 3/2/2013'::text as entrada
     union select false as esperado_es, null         as esperado_f, '3/2/2013 x'::text as entrada
     union select true  as esperado_es, '2003-02-13' as esperado_f, '13-02-2003'::text as entrada
     union select false as esperado_es, null         as esperado_f, '13-02-2003 12'::text as entrada
     union select true  as esperado_es, '2003-02-13 12:34' as esperado_f, '13-02-2003 12:34'::text as entrada
     union select true  as esperado_es, '2003-12-02 12:34:42' as esperado_f, '2003-12-02 12:34:42'::text as entrada
     union select false as esperado_es, null         as esperado_f, '2003-12-02 12 34 42'::text as entrada
     union select false as esperado_es, null         as esperado_f, '19'::text as entrada
     union select false as esperado_es, null         as esperado_f, '1.1'::text as entrada
     union select false as esperado_es, null         as esperado_f, 'hoy'::text as entrada
     union select false as esperado_es, null         as esperado_f, '20130202'::text as entrada
     union select false as esperado_es, null         as esperado_f, '2013020'::text as entrada
     union select false as esperado_es, null         as esperado_f, '2/2/2'::text as entrada
     union select false as esperado_es, null         as esperado_f, '12/12/12'::text as entrada
  ) x
  where esperado_es is distinct from comun.es_fecha(entrada) or abs(extract(epoch from esperado_f::timestamp) - extract(epoch from case when comun.es_fecha(entrada) then comun.valor_fecha(entrada) else null end))>2 ;

