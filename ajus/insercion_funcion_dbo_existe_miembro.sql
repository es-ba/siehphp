CREATE OR REPLACE FUNCTION dbo.existe_miembro(p_enc integer, p_hogar integer, p_miembro integer)
  RETURNS integer AS
$BODY$
declare v_existe integer;
begin
    v_existe := count(distinct (res_mie)) from encu.respuestas where res_enc = p_enc and res_hog = p_hogar and res_mie = p_miembro;
    return v_existe;
end;
$BODY$
  LANGUAGE plpgsql STABLE
  COST 100;