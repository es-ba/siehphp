CREATE OR REPLACE FUNCTION dbo.nroconyuges(p_enc integer, p_hogar integer)
  RETURNS integer AS
$BODY$
declare v_nroconyuges integer;
begin
    v_nroconyuges := count(*) from encu.respuestas where res_enc = p_enc and res_hog = p_hogar and res_var = 'p4' and (res_valor ='2');
    return v_nroconyuges;
end;
$BODY$
  LANGUAGE plpgsql STABLE
  COST 100;