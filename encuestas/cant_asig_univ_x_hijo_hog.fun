##FUN
cant_asig_univ_x_hijo_hog
##ESQ
dbo
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO
-- cuenta la cantidad de registros con i3_13=1 en la plana_i1_ de un hogar
set search_path = encu, dbo, comun, public;

--drop function dbo.cant_asig_univ_x_hijo_hog(integer,integer);
CREATE OR REPLACE FUNCTION dbo.cant_asig_univ_x_hijo_hog(p_enc integer, p_hog integer)
  RETURNS bigint AS
$BODY$
  select count(*)
    from encu.plana_i1_ where pla_enc=$1 and pla_hog=$2
      and pla_i3_13=1 ;
$BODY$
  LANGUAGE sql STABLE;
ALTER FUNCTION dbo.cant_asig_univ_x_hijo_hog(integer, integer)
  OWNER TO tedede_php;
##CASOS_SQL  
select pla_enc, pla_hog, count(*) --702303  1, 323507 2
  from encu.plana_i1_
  where pla_enc in (702303, 323507) and 
    pla_i3_13=1
  group by pla_enc, pla_hog;
select dbo.cant_asig_univ_x_hijo_hog(702303,1);--1
select dbo.cant_asig_univ_x_hijo_hog(323507,1);--2  
