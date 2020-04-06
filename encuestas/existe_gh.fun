##FUN
existe_GH
##ESQ
dbo
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO
set search_path = encu, dbo, comun, public;

--drop function dbo.existe_GH(integer,integer);
CREATE OR REPLACE FUNCTION dbo.existe_GH(
    enc integer,
    hog integer)
  RETURNS bigint AS
$BODY$
  select count(cla_enc)
  from encu.claves where cla_ope=dbo.ope_actual() 
	and cla_for='GH'
	and cla_mat=''
	and cla_enc=$1
	and cla_hog=$2
	limit 1;
$BODY$
  LANGUAGE sql;
ALTER FUNCTION dbo.existe_GH(integer, integer)
  OWNER TO tedede_php;