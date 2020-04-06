CREATE OR REPLACE FUNCTION dbo.buscar_rea(p_enc integer)
  RETURNS integer AS
$BODY$
declare v_rea integer;
begin
	select res_valor::integer into v_rea from encu.respuestas where res_enc = p_enc and res_hog = 1 and res_var = 'rea' ;
	return v_rea;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

