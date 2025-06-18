##FUN
meshort53bis
##ESQ
dbo
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO
-- Calculo de horas mensuales trabajadas 
set search_path = encu, dbo, comun, public;
-- Function: dbo.meshort53bis(p_enc ,p_hog, p_mie)

-- DROP FUNCTION dbo.meshort53bis(p_enc integer,p_hog integer, p_mie integer);
CREATE OR REPLACE FUNCTION dbo.meshort53bis(p_enc integer,p_hog integer, p_mie integer)
  RETURNS decimal AS
               --WHEN pla_cond_activ<>1 or pla_t45=3 or pla_i1=2 and pla_i4<>1 THEN 0
  'SELECT CASE WHEN (pla_i1=1 or pla_i4=1 or informado(pla_i10)) and 
                    (pla_t53_bis1<0 or pla_t53_bis2<0 or (pla_t53_bis1=1 or pla_t53_bis1=2) and pla_t53_bis1_sem<0 or pla_t53_bis1=3 and pla_t53_bis1_mes<0) THEN -9
               WHEN (not informado(pla_t28) and not informado(pla_t30)) or pla_t45=3 or pla_i1=2 and pla_i4<>1 THEN 0
               WHEN (pla_t53_bis1=1 or pla_t53_bis1=2 or pla_t53_bis1<0) and pla_t53_bis1_sem>0 and pla_t53_bis2>0 THEN  pla_t53_bis1_sem*pla_t53_bis2*4.3
               WHEN (pla_t53_bis1=3 or pla_t53_bis1<0) and pla_t53_bis1_mes>0 and pla_t53_bis2>0 THEN pla_t53_bis1_mes*pla_t53_bis2 
               ELSE null END
      FROM encu.plana_i1_
      WHERE pla_enc=p_enc and pla_hog= p_hog and pla_mie= p_mie'
  LANGUAGE sql STABLE;

ALTER FUNCTION dbo.meshort53bis(p_enc integer,p_hog integer, p_mie integer)
  OWNER TO tedede_php;

set search_path= encu, dbo, comun;

CREATE OR REPLACE FUNCTION dbo.meshort53bis_v2(
   p_enc integer,
   p_hog integer,
   p_mie integer
    )
    RETURNS numeric
    LANGUAGE 'sql'

    STABLE 
AS $BODY$
-- desde eah2025 se reemplaza t30 por t30_1    
SELECT CASE WHEN (pla_i1=1 or pla_i4=1 or informado(pla_i10)) and 
                    (pla_t53_bis1<0 or pla_t53_bis2<0 or (pla_t53_bis1=1 or pla_t53_bis1=2) and pla_t53_bis1_sem<0 or pla_t53_bis1=3 and pla_t53_bis1_mes<0) THEN -9
               WHEN (not informado(pla_t28) and not informado(pla_t30_1)) or pla_t45=3 or pla_i1=2 and pla_i4<>1 THEN 0
               WHEN (pla_t53_bis1=1 or pla_t53_bis1=2 or pla_t53_bis1<0) and pla_t53_bis1_sem>0 and pla_t53_bis2>0 THEN  pla_t53_bis1_sem*pla_t53_bis2*4.3
               WHEN (pla_t53_bis1=3 or pla_t53_bis1<0) and pla_t53_bis1_mes>0 and pla_t53_bis2>0 THEN pla_t53_bis1_mes*pla_t53_bis2 
               ELSE null END
      FROM encu.plana_i1_
      WHERE pla_enc=p_enc and pla_hog= p_hog and pla_mie= p_mie
$BODY$;

ALTER FUNCTION dbo.meshort53bis_v2(integer, integer, integer)
    OWNER TO tedede_php;
  

