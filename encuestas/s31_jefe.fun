##FUN
s31_jefe
##ESQ
dbo
##PARA
revisar 
##DETALLE
-- retorna s31_anio concatenado con s31_mes  del jefe, salvando -1, -5,-9 por 00 ó 0000 segun se presente en anio ó mes.

--DROP FUNCTION dbo.s31_jefe(integer, integer);
CREATE OR REPLACE FUNCTION dbo.s31_jefe(
    p_enc integer,
    p_nhogar integer)
  RETURNS integer AS
$BODY$
  select (case when pla_s31_anio <0 then '0000' else pla_s31_anio::text end || case when pla_s31_mes <0 then '00' else lpad(pla_s31_mes::text,2,'0') end ):: integer
      from encu.plana_i1_ i join encu.plana_s1_p p on i.pla_enc=p.pla_enc and i.pla_hog=p.pla_hog and i.pla_mie=p.pla_mie
      where p.pla_enc = p_enc and p.pla_hog = p_nhogar and p.pla_p4=1
      limit 1;
      
$BODY$
  LANGUAGE sql STABLE;
ALTER FUNCTION dbo.s31_jefe(integer, integer)
  OWNER TO tedede_php;
  
## pruebas
select pla_enc, pla_hog,pla_mie,  pla_s31_anio,pla_s31_mes, (case when pla_s31_anio <0 then '0000' else pla_s31_anio::text end ||case when pla_s31_mes <0 then '00' else lpad(pla_s31_mes::text,2,'0') end) ::integer
from encu.plana_i1_
where pla_mie=1;

select pla_enc, pla_hog, pla_s31_anio,pla_s31_mes, dbo.s31_jefe(pla_enc, pla_hog) 
from encu.plana_i1_
where pla_mie=1
limit 10;

  
  
  

