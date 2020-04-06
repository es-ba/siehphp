##FUN
cant_registros_a1_m
##ESQ
dbo
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO
CREATE OR REPLACE FUNCTION dbo.cant_registros_a1_m(p_enc integer, p_hog integer)
  RETURNS integer AS
$BODY$
DECLARE
    v_cantidad integer;
BEGIN 
    SELECT count(distinct res_exm) INTO v_cantidad 
        FROM encu.respuestas 
        WHERE res_ope=dbo.ope_actual() and res_for='A1' and res_mat='M' and res_enc=p_enc and res_hog=p_hog and res_valor is not null;  
    return v_cantidad;
END;
$BODY$
  LANGUAGE plpgsql IMMUTABLE;
ALTER FUNCTION dbo.cant_registros_a1_m(integer, integer)
  OWNER TO tedede_php;
##CASOS_SQL

