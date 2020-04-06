##FUN
cant_i1_x_hog
##ESQ
dbo
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO
set search_path = encu, dbo, comun, public;

--drop function dbo.cant_i1_x_hog(integer,integer);
CREATE OR REPLACE FUNCTION dbo.cant_i1_x_hog(p_enc integer, p_hog integer)
  RETURNS bigint AS
$BODY$
  select count(*)
    from encu.plana_i1_ where pla_enc=$1 and pla_hog=$2;
$BODY$
  LANGUAGE sql STABLE;
ALTER FUNCTION dbo.cant_i1_x_hog(integer, integer)
  OWNER TO tedede_php;
##CASOS_SQL  
select pla_enc, pla_hog, count(*) --702003  7, 516010 1
  from encu.plana_i1_
  where pla_enc in (702003, 516010)
  group by pla_enc, pla_hog;
select dbo.cant_i1_x_hog(702003,1);--7
select dbo.cant_i1_x_hog(516010,1);--1  
