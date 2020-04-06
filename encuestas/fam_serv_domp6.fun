##FUN
fam_serv_domp6
##ESQ
dbo
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO
set search_path = encu, dbo, comun, public;

CREATE OR REPLACE FUNCTION dbo.fam_serv_domp6(p_enc integer, p_hog integer, p_mie integer)
  RETURNS boolean AS
$BODY$
SELECT case when m.pla_p4=13 then true when m.pla_p4=14 then
          (
           SELECT true
             FROM encu.plana_s1_p p -- pariente
             WHERE p.pla_enc=m.pla_enc
               AND p.pla_hog=m.pla_hog
               AND p.pla_p4 = 13 
               AND ( p.pla_mie = m.pla_p6_a OR p.pla_mie = m.pla_p6_b
                    OR m.pla_mie = p.pla_p6_a OR m.pla_mie = p.pla_p6_b)
           LIMIT 1
          ) is true
       else false end
  FROM encu.plana_s1_p m
  WHERE m.pla_enc=p_enc
    AND m.pla_hog=p_hog
    AND m.pla_mie=p_mie;
$BODY$
  LANGUAGE sql VOLATILE;

ALTER FUNCTION dbo.fam_serv_domp6(integer, integer, integer)
  OWNER TO tedede_php;
  
##CASOS_SQL 
## en eah2015_test 
select dbo.fam_serv_domp6(102002,1,2); --true
select dbo.fam_serv_domp6(100301,1,1); --false 

 