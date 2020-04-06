##FUN
suma_auh_i3_13a_hog
##ESQ
dbo
##PARA
revisar 
##DETALLE
suma el valor de la variable i3_13a cuando sea >0 y pla_i3_13=1

##PROVISORIO

set search_path = encu, dbo, comun, public;

CREATE OR REPLACE FUNCTION dbo.suma_auh_i3_13a_hog(p_enc integer, p_hog integer)
  RETURNS bigint AS
$BODY$
  select sum(case when pla_i3_13=1 then case when pla_i3_13a>=0 then pla_i3_13a when pla_i3_13a<0 then 1 else 0 end else 0 end)
    from encu.plana_i1_ where pla_enc=$1 and pla_hog=$2
      ;
$BODY$
  LANGUAGE sql STABLE
  ;
ALTER FUNCTION dbo.suma_auh_i3_13a_hog(integer, integer)
  OWNER TO tedede_php;
