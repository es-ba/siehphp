CREATE OR REPLACE FUNCTION dbo.cant_menores(p_enc integer, p_hog integer, p_edad integer)
  RETURNS integer AS
$BODY$
DECLARE v_cant_menores integer;
BEGIN
    select count(*) into v_cant_menores from encu.respuestas
    inner join encu.variables on var_var=res_var and var_ope=res_ope and res_for=var_for and res_mat=var_mat
    where res_ope=dbo.ope_actual()
    and res_enc=p_enc
    and res_hog=p_hog
    and res_exm=0
    and res_var='edad'
    and res_valor::integer<p_edad;
    
    return v_cant_menores;
END;
$BODY$
  LANGUAGE plpgsql STABLE;
ALTER FUNCTION dbo.cant_menores(integer, integer)
  OWNER TO tedede_php;