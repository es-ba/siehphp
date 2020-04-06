##FUN
hogp4eq13
##ESQ
dbo
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO
--dada la clave de un hogar, devuelve 1 si existe al menos un miembro con p4=13, sino retorna 0 

set search_path = encu, dbo, comun, public;

CREATE OR REPLACE FUNCTION dbo.hogp4eq13(
    p_enc integer,
    p_hog integer)
  RETURNS integer AS
$BODY$
SELECT case when cant_sd>0  then 1 else  0 end 
FROM (SELECT count(*) as cant_sd 
  FROM encu.plana_s1_p m
  WHERE m.pla_enc=p_enc
    AND m.pla_hog=p_hog and m.pla_p4=13
) as t;  
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION dbo.hogp4eq13(integer, integer)
  OWNER TO tedede_php;

  
##CASOS_SQL 
## en etoi162_test 
select pla_enc, pla_hog, dbo.hogp4eq13(pla_enc, pla_hog)
  from encu.plana_s1_
  limit 10;
 select * from encu.plana_s1_p
 where pla_enc=130001


 