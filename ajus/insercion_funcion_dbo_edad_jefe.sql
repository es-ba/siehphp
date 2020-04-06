CREATE OR REPLACE FUNCTION dbo.edadjefe(p_enc integer, p_nhogar integer)
  RETURNS integer AS
$BODY$
declare v_edad_jefe integer;

begin
	v_edad_jefe := 0;

	select res_valor into v_edad_jefe from encu.respuestas where res_enc = p_enc and res_hog = p_nhogar and res_mie = 1 and res_var = 'p3_b' ;
	return v_edad_jefe;
	
end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
