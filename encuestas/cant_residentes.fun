##FUN
cant_residentes
##ESQ
dbo
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO
-- cuenta la cantidad de registros con r0=1 en la plana_S1_p de un hogar
set search_path = encu, dbo, comun, public;

--drop function dbo.cant_residentes(integer,integer);
CREATE OR REPLACE FUNCTION dbo.cant_residentes(p_enc integer, p_hog integer)
  RETURNS bigint AS
$BODY$
  select count(*)
    from encu.plana_s1_p where pla_enc=$1 and pla_hog=$2
      and pla_r0=1 ;
$BODY$
  LANGUAGE sql STABLE;
ALTER FUNCTION dbo.cant_residentes(integer, integer)
  OWNER TO tedede_php;
##CASOS_SQL  
select pla_enc, pla_hog, count(*), dbo.cant_residentes(pla_enc,pla_hog) --200606,404703
  from encu.plana_s1_p
  where pla_enc in (200606,404703) and 
    pla_r0=1
  group by pla_enc, pla_hog;

select * from encu.plana_s1_p
  where pla_enc=404703
  
