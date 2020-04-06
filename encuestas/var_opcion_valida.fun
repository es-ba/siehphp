##FUN
var_opcion_valida
##ESQ
dbo
##PARA
revisar 
##DETALLE
funcion que dado un nombre de conjunto de opciones revisa si el valor pasado pertenece al conjunto de opciones. En ese caso devuelve true, sino false
NUEVA
##PROVISORIO
CREATE OR REPLACE FUNCTION dbo.var_opcion_valida( p_conopc text, p_valor integer)
  RETURNS boolean AS
$BODY$
  select case when encontrado>0 then true else false end
  from (select count(*) encontrado
           from encu.opciones 
           where opc_ope=dbo.ope_actual() and opc_conopc=p_conopc and opc_opc=p_valor::text) x;
$BODY$
  LANGUAGE sql stable;
ALTER FUNCTION dbo.var_opcion_valida(text,integer)
  OWNER TO tedede_php;  