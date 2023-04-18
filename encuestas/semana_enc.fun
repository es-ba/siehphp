##FUN
semana_enc
##ESQ
dbo
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO
--retorna la semana de la encuesta

-- DROP FUNCTION IF EXISTS dbo.semana_enc(integer);

CREATE OR REPLACE FUNCTION dbo.semana_enc(
	p_enc integer)
    RETURNS integer
    LANGUAGE 'sql'
    IMMUTABLE
AS $BODY$
    select pla_semana from encu.plana_tem_ where pla_enc=$1;  
$BODY$;

ALTER FUNCTION dbo.semana_enc(integer)
    OWNER TO tedede_php;

 
--select pla_enc, pla_semana, dbo.semana_enc(pla_enc) f from plana_tem where pla_semana=2 limit 10;  
