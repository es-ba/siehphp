CREATE OR REPLACE FUNCTION dbo.existe_hogar(p_enc integer, p_hogar integer)
  RETURNS integer AS
$BODY$
declare v_existe integer;
begin
    v_existe := count(distinct (res_hog)) from encu.respuestas where res_enc = p_enc and res_hog = p_hogar;
    return v_existe;
end;
$BODY$
  LANGUAGE plpgsql STABLE
  COST 100;