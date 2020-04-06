##FUN
existe_pyg1
##ESQ
dbo
##PARA
##DETALLE
Si existe el formulario PG1 del hogar retorna 1 sino 0

NUEVA
##PROVISORIO
set search_path = encu, dbo, comun, public;

--drop function dbo.existe_pyg(integer,integer);
CREATE OR REPLACE FUNCTION dbo.existe_pyg1(
    enc integer,
    hog integer)
  RETURNS bigint AS
$BODY$
  select count(cla_enc)
    from encu.claves 
    where cla_ope=dbo.ope_actual()
        and cla_for='PG1'
        and cla_mat=''
        and cla_enc=$1
        and cla_hog=$2
    limit 1;
$BODY$
  LANGUAGE sql;
ALTER FUNCTION dbo.existe_pyg1(integer, integer)
  OWNER TO tedede_php;
  
/*
select s.pla_enc, s.pla_hog,  pla_pygf1a, pla_pygf1b, dbo.existe_pyg1(s.pla_enc, s.pla_hog)
from encu.plana_a1_ s
where not ( pla_pygf1a=1 or pla_pygf1b=1 ) --exists (select * from encu.plana_pg1_ d where d.pla_enc=s.pla_enc and d.pla_hog=s.pla_hog ) ;
*/