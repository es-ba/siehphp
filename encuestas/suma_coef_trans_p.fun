##FUN
suma_coef_trans_p
##ESQ
dbo
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO

-- DROP FUNCTION dbo.suma_coef_trans_p(integer, integer);

CREATE OR REPLACE FUNCTION dbo.suma_coef_trans_p(
    p_enc integer,
    p_hog integer)
  RETURNS decimal AS
$BODY$
select sum(pla_coef_trans_p) from encu.plana_i1_ where pla_enc=p_enc and pla_hog= p_hog ;
$BODY$
  LANGUAGE sql STABLE;
ALTER FUNCTION dbo.suma_coef_trans_p(integer, integer)
  OWNER TO tedede_php;
 
#PRUEBA

select dbo.suma_coef_trans_p(100302,1); --1.829
