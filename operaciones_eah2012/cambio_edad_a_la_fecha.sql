-- DROP FUNCTION dbo.edad_a_la_fecha(text, text);

CREATE OR REPLACE FUNCTION dbo.edad_a_la_fecha(p_f_nac text, p_f_realiz text)
  RETURNS integer AS
$BODY$
DECLARE v_edad integer;
BEGIN
  if dbo.texto_a_fecha(p_f_nac) > dbo.texto_a_fecha(p_f_realiz) then 
    return null;
  end if;
  v_edad=extract(year from age(dbo.texto_a_fecha(p_f_realiz)+interval '1 hour',dbo.texto_a_fecha(p_f_nac)));
  if v_edad>130 or v_edad<0 then
    return null;
  end if;
  return v_edad;
EXCEPTION
  WHEN invalid_datetime_format THEN
    return null;
  WHEN datetime_field_overflow THEN
    return null;
END;
$BODY$
  LANGUAGE plpgsql IMMUTABLE
  COST 100;
ALTER FUNCTION dbo.edad_a_la_fecha(text, text)
  OWNER TO tedede_php;
