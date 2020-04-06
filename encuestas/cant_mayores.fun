##FUN
cant_menores
##ESQ
dbo
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO
--cuenta la cantidad de personas con edad > p_edad de un hogar

-- DROP FUNCTION dbo.cant_mayores(integer, integer, integer);

CREATE OR REPLACE FUNCTION dbo.cant_mayores(
    p_enc integer,
    p_hog integer,
    p_edad integer)
  RETURNS bigint AS
$BODY$
    select count(*) 
        from encu.respuestas
            inner join encu.variables on var_var=res_var and var_ope=res_ope and res_for=var_for and res_mat=var_mat
        where res_ope=dbo.ope_actual()
        and res_enc=p_enc
        and res_hog=p_hog
        and res_exm=0
        and res_var='edad'
        and res_valor::integer>p_edad;

$BODY$
  LANGUAGE sql STABLE;
ALTER FUNCTION dbo.cant_mayores(integer, integer, integer)
  OWNER TO tedede_php;
 
--select dbo.cant_mayores(pla_enc, pla_hog, 45);  
