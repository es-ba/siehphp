CREATE OR REPLACE FUNCTION dbo.sexojefe(p_enc integer, p_hogar integer)
  RETURNS integer AS
$BODY$
declare v_sexojefe text;
begin
    select res_valor into v_sexojefe from encu.respuestas where res_enc = p_enc and res_hog = p_hogar and res_var = 'p2' and res_mie in (select res_mie from encu.respuestas where res_enc = p_enc and res_hog = p_hogar and res_var = 'p4' and (res_valor ='1' ) limit 1);
    return v_sexojefe;
end;
$BODY$
  LANGUAGE plpgsql STABLE
  COST 100;
