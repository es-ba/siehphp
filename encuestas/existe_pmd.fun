##FUN
existe_pmd
##ESQ
dbo
##PARA
##DETALLE
Si existe el formulario PMD del hogar retorna 1 sino 0

NUEVA
##PROVISORIO
set search_path = encu, dbo, comun, public;

--drop function dbo.existe_pmd(integer,integer);
CREATE OR REPLACE FUNCTION dbo.existe_pmd(
    enc integer,
    hog integer)
    RETURNS bigint
    LANGUAGE 'sql'

    STABLE 
AS $BODY$
  select count(cla_enc)
  from encu.claves where cla_ope=dbo.ope_actual() 
    and cla_for='PMD'
    and cla_mat=''
    and cla_enc=$1
    and cla_hog=$2
    limit 1;
$BODY$;

ALTER FUNCTION dbo.existe_pmd(integer, integer)
    OWNER TO tedede_php;
  
