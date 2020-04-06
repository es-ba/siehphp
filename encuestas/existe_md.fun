##FUN
existe_md
##ESQ
dbo
##PARA
##DETALLE
Si existe el formulario MD de la persona retorna 1 sino 0

NUEVA
##PROVISORIO
set search_path = encu, dbo, comun, public;

--drop function dbo.existe_md(integer,integer);
CREATE OR REPLACE FUNCTION dbo.existe_md(
    enc integer,
    hog integer,
    mie integer)
  RETURNS bigint AS
$BODY$
  select count(cla_enc)
    from encu.claves 
    where cla_ope=dbo.ope_actual()
        and cla_for='MD'
        and cla_mat=''
        and cla_enc=$1
        and cla_hog=$2
        and cla_mie=$3
    limit 1;
$BODY$
  LANGUAGE sql;
ALTER FUNCTION dbo.existe_md(integer, integer, integer)
  OWNER TO tedede_php;
  
/*
select s.pla_enc, s.pla_hog, s.pla_mie,pla_pd, dbo.existe_md(s.pla_enc, s.pla_hog,s.pla_mie)
from encu.plana_i1_ s
where  pla_pd is distinct from 1  --exists (select * from encu.plana_md_ d where d.pla_enc=s.pla_enc and d.pla_hog=s.pla_hog and d.pla_mie=s.pla_mie) ;
*/