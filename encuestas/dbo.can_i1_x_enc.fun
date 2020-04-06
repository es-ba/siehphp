##FUN
cant_i1_x_enc
##ESQ
dbo
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO
set search_path = encu, dbo, comun, public;

CREATE OR REPLACE FUNCTION dbo.cant_i1_x_enc(p_enc integer)
  RETURNS bigint AS
$BODY$
  select count(cla_mie)
  from encu.claves where cla_ope=dbo.ope_actual() 
	and cla_for='I1' 
	and cla_mat=''
	and cla_enc=$1;
$BODY$
  LANGUAGE sql STABLE;
ALTER FUNCTION dbo.cant_i1_x_enc(integer)
  OWNER TO tedede_php;
##CASOS_SQL 
select pla_enc, count(*) --702003  7, 516010 1
  from encu.plana_i1_
  where pla_enc in (702003, 516010)
  group by pla_enc;
select dbo.cant_i1_x_enc(702003); --7
select dbo.cant_i1_x_enc(516010); --1 