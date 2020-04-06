##FUN
dic_parte
##ESQ
dbo
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO
CREATE OR REPLACE FUNCTION dbo.dic_parte(p_dic text, p_origen text, p_destino integer)
  RETURNS boolean AS
$BODY$
  select p_origen ~* 
    ('(\m' || coalesce((select string_agg(dictra_ori, '\M|\m') 
      from encu.dictra
      where dictra_dic=p_dic and dictra_des=p_destino),'')|| '\M)' )
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION dbo.dic_parte(text, text, integer)
  OWNER TO tedede_owner;