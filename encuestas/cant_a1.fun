##FUN
cant_a1
##ESQ
dbo
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO
set search_path = encu, dbo, comun, public;
CREATE OR REPLACE FUNCTION dbo.cant_a1(p_enc integer)
  RETURNS bigint AS
$BODY$
  select count(cla_hog)
    from encu.claves 
    where cla_ope=dbo.ope_actual() and cla_for='A1' and cla_mat='' and cla_enc=p_enc ;
$BODY$
  LANGUAGE sql STABLE;
ALTER FUNCTION dbo.cant_a1(integer)
  OWNER TO tedede_php;
##CASOS_SQL