CREATE OR REPLACE FUNCTION dbo.nrojefes(p_enc integer, p_hogar integer)
  RETURNS integer AS
$BODY$
declare v_cantjefes integer;
begin
    v_cantjefes := count(*) from encu.respuestas where res_enc = p_enc and res_hog = p_hogar and res_var = 'p4' and (res_valor ='1') ;
    return v_cantjefes;
end;
$BODY$
  LANGUAGE plpgsql STABLE
  COST 100;
