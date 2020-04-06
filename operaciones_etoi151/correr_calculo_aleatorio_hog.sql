-- Function: encu.correr_calculo_aleatorio_hog()

-- DROP FUNCTION encu.correr_calculo_aleatorio_hog();
-- select setseed(0.8);
CREATE OR REPLACE FUNCTION encu.correr_calculo_aleatorio_hog()
  RETURNS void AS
$BODY$
DECLARE
 venc   RECORD;
BEGIN
    FOR venc IN 
        select pla_enc, pla_hog
            from encu.plana_s1_
            order by pla_enc, pla_hog
    LOOP
        update encu.plana_s1_   set pla_s1a1_obs=pla_s1a1_obs
            where pla_enc=venc.pla_enc and pla_hog=venc.pla_hog ; 
        raise notice 'Lista de hogares: %, % ', venc.pla_enc, venc.pla_hog;    
    END LOOP;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION encu.correr_calculo_aleatorio_hog()
  OWNER TO tedede_php;
