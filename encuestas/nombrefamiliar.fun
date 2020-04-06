##FUN
nombrefamiliar
##ESQ
dbo
##PARA
revisar 
##DETALLE
-- Function: dbo.nombrefamiliar(integer, integer,integer)

-- DROP FUNCTION dbo.nombrefamiliar(integer, integer,integer);

CREATE OR REPLACE FUNCTION dbo.nombrefamiliar(p_enc integer, p_nhogar integer,p_mie integer)
  RETURNS text AS
$BODY$
  select pla_nombre
      from encu.plana_s1_p 
      where pla_enc = p_enc and pla_hog = p_nhogar and pla_mie=p_mie;
$BODY$
  LANGUAGE sql STABLE
  ;
ALTER FUNCTION dbo.nombrefamiliar(integer, integer,integer)
  OWNER TO tedede_php;

##Prueba  
select dbo.nombrefamiliar(pla_enc, pla_hog,pla_mie), dbo.nombrefamiliar(100000, 1,1),* 
from encu.plana_s1_p
limit 10