##FUN
e_niveljefe
##ESQ
dbo
##PARA
revisar 
##DETALLE
-- Function: dbo.e_niveljefe(integer, integer)

-- DROP FUNCTION dbo.e_niveljefe(integer, integer);

CREATE OR REPLACE FUNCTION dbo.e_niveljefe(p_enc integer, p_nhogar integer)
  RETURNS integer AS
$BODY$
  select pla_e_nivel
      from encu.plana_i1_ i join encu.plana_s1_p p on i.pla_enc=p.pla_enc and i.pla_hog=p.pla_hog and i.pla_mie=p.pla_mie
      where p.pla_enc = p_enc and p.pla_hog = p_nhogar and p.pla_p4=1
      limit 1;
$BODY$
  LANGUAGE sql STABLE;
ALTER FUNCTION dbo.e_niveljefe(integer, integer)
  OWNER TO tedede_php;

select dbo.e_niveljefe(pla_enc, pla_hog),*
from encu.plana_s1_
where pla_entrea in(1,3)
limit 10; 