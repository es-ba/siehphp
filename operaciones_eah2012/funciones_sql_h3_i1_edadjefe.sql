-- DROP FUNCTION dbo.existeindividual(integer, integer, integer);

CREATE OR REPLACE FUNCTION dbo.existeindividual(enc integer, hog integer, mie integer)
  RETURNS integer AS
  $BODY$
  DECLARE existe integer;
  BEGIN
	existe := count(distinct (res_mie)) from encu.respuestas where res_ope=dbo.ope_actual() and res_enc = enc and res_hog = hog and res_mie = mie and res_for = 'I1';
	return existe;
 END;
$BODY$
  LANGUAGE plpgsql STABLE
  COST 100;
ALTER FUNCTION dbo.existeindividual(integer, integer, integer)
  OWNER TO tedede_php;



-- DROP FUNCTION dbo.edadjefe(integer, integer);

CREATE OR REPLACE FUNCTION dbo.edadjefe(p_enc integer, p_nhogar integer)
RETURNS integer AS
$BODY$
DECLARE v_edad_jefe integer;
BEGIN
	v_edad_jefe := 0;
	select res_valor into v_edad_jefe from encu.respuestas where res_ope=dbo.ope_actual() and res_for='S1' and res_mat='P' and res_enc = p_enc and res_hog = p_nhogar and res_var = 'edad' and res_mie in (select res_mie from encu.respuestas where res_ope=dbo.ope_actual() and res_for='S1' and res_mat='P' and res_enc=p_enc and res_hog=p_nhogar and res_var ='p4' and (res_valor ='1') limit 1);
	return v_edad_jefe;	
END;
$BODY$
  LANGUAGE plpgsql STABLE
  COST 100;



CREATE OR REPLACE FUNCTION dbo.sumah3(p_enc integer)
  RETURNS integer AS
$BODY$
DECLARE sum_hab integer;
BEGIN
	sum_hab := 0;
	select sum(res_valor::integer) into sum_hab from encu.respuestas 
	where res_ope=dbo.ope_actual() and res_for='A1' and res_mat='' and res_enc = p_enc and res_var = 'h3' and not comun.nsnc(res_valor);
	return sum_hab;
END;
$BODY$
  LANGUAGE plpgsql STABLE
  COST 100;
ALTER FUNCTION dbo.sumah3(integer)
  OWNER TO tedede_php;