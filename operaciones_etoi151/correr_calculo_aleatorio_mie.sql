-- Function: encu.correr_calculo_aleatorio_mie()

-- DROP FUNCTION encu.correr_calculo_aleatorio_mie();
-- select setseed(0.32);

CREATE OR REPLACE FUNCTION encu.correr_calculo_aleatorio_mie()
  RETURNS void AS
$BODY$
DECLARE
 vmie   RECORD;
BEGIN
    FOR vmie IN 
        select pla_enc, pla_hog, pla_mie
            from encu.plana_i1_
            order by pla_enc, pla_hog, pla_mie
    LOOP
        update encu.plana_i1_  set pla_obs=pla_obs
            where pla_enc=vmie.pla_enc and pla_hog=vmie.pla_hog  and pla_mie=vmie.pla_mie; 
        raise notice 'Lista de miembros: %, %, % ', vmie.pla_enc, vmie.pla_hog, vmie.pla_mie;    
    END LOOP;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION encu.correr_calculo_aleatorio_mie()
  OWNER TO tedede_php;