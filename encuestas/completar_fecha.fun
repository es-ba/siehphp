/* ##FUN
completar_fecha
##ESQ
comun
##PARA
provisoria
##DETALLE */

-- DROP FUNCTION comun.completar_fecha(text);

CREATE OR REPLACE FUNCTION comun.completar_fecha(p_fecha text)
  RETURNS text AS
$BODY$
DECLARE
  v_fecha_construida text;
  v_array_fecha text[];
begin
     if(comun.es_fecha(p_fecha)) then
        return p_fecha;
     else
       v_array_fecha:=regexp_split_to_array(p_fecha, '/');
       v_fecha_construida:='15/'||v_array_fecha[array_length(v_array_fecha, 1)-1]||'/'||v_array_fecha[array_length(v_array_fecha, 1)];
       return v_fecha_construida;
     end if;	
end;
$BODY$
  LANGUAGE plpgsql IMMUTABLE
  COST 100;
ALTER FUNCTION comun.completar_fecha(text)
  OWNER TO tedede_php;

-- ##CASOS
select comun.completar_fecha(entrada)=resultado as ok, entrada, resultado as esperado, comun.completar_fecha(entrada) as recibido
    from (
	  select '06/05/1969'::text as entrada, '06/05/1969'::text as resultado
	  union select '99/99/9999', '01/10/2014'
	  union select '99/99/9999', '01/10/2014'
	  union select '01/10/2013', '01/10/2013'
         ) x 
    where comun.completar_fecha(entrada) is distinct from resultado 
