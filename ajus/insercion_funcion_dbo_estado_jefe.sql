CREATE OR REPLACE FUNCTION dbo.estadojefe(p_enc integer, p_hogar integer)
  RETURNS integer AS
$BODY$
declare v_estadojefe text;
begin
    select res_valor into v_estadojefe from encu.respuestas where res_enc = p_enc and res_hog = p_hogar and res_var = 'p5' and res_mie in (select res_mie from encu.respuestas where res_enc = p_enc and res_hog = p_hogar and res_var = 'p4' and (res_valor ='1') limit 1);
    return v_estadojefe;
end;
$BODY$
  LANGUAGE plpgsql STABLE
  COST 100;