/* ##FUN
edad_a_la_fecha
##ESQ
dbo
##PARA
provisoria
##DETALLE */
-- Function: dbo.edad_a_la_fecha(text, text)

-- DROP FUNCTION dbo.edad_a_la_fecha(text, text);

CREATE OR REPLACE FUNCTION dbo.edad_a_la_fecha(p_f_nac text, p_f_realiz text)
  RETURNS integer AS
$BODY$
DECLARE v_edad integer;
BEGIN
  if dbo.texto_a_fecha(p_f_nac) > dbo.texto_a_fecha(p_f_realiz) then 
    return null;
  end if;
  v_edad=extract(year from age(dbo.texto_a_fecha(p_f_realiz),dbo.texto_a_fecha(p_f_nac)));
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

-- ##CASOS
select dbo.edad_a_la_fecha(f_nac, f_real) is not distinct from resultado as ok, f_nac, f_real, resultado as esperado, dbo.edad_a_la_fecha(f_nac, f_real) as recibido
    from (
	  select '06/05/1969'::text as f_nac, '01/10/2014'::text as f_real, 45 as resultado
	  union select '20/09/2014', '01/10/2014', 0 
	  union select '99/99/9999', '01/10/2014', null
	  union select '15/99/9999', '01/10/2014', null
	  union select '99/99/2004', '01/10/2014', null --- ESTA FALLANDO
	  union select '99/11/9999', '01/10/2014', null --- ESTA FALLANDO
	  union select '//////2004', '01/10/2014', null
	  union select '01/09/2013', '01/10/2013', 0
         ) x 
    where dbo.edad_a_la_fecha(f_nac, f_real) is distinct from resultado or true
  
