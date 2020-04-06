##FUN
mie_bu
##ESQ
dbo
##PARA
produccion
##PUBLICA
Sí
##NOMBRE
número de miembro para la base a usuario
##DETALLE
para renumerar las variables que corresponden a números de miembro
##CUERPO_CON_PARAMETROS
CREATE OR REPLACE FUNCTION dbo.mie_bu(p_enc integer, p_hog integer, p_mie integer)
  RETURNS integer 
  LANGUAGE SQL STABLE
  AS
$BODY$
  SELECT CASE WHEN p_mie=95 THEN 95 WHEN p_mie is null THEN null WHEN p_mie=99 THEN 99 WHEN p_mie=-1 THEN -1 WHEN p_mie=-9 THEN -9
    ELSE (SELECT pla_mie_bu 
            FROM encu.plana_i1_
            WHERE pla_enc=p_enc and pla_hog=p_hog and pla_mie=p_mie) END;
$BODY$;
ALTER FUNCTION dbo.mie_bu(integer, integer, integer)
  OWNER TO tedede_php;

##CASOS_SQL
select i.pla_enc, i.pla_hog, i.pla_mie, pla_p5b, dbo.mie_bu(i.pla_enc, i.pla_hog, pla_p5b)
  from encu.plana_i1_ i inner join encu.plana_s1_p p on i.pla_enc=p.pla_enc and i.pla_hog=p.pla_hog and i.pla_mie=p.pla_mie
  where pla_p5b is distinct from dbo.mie_bu(i.pla_enc, i.pla_hog, pla_p5b)
  limit 100;
  
