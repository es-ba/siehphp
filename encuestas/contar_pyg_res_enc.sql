-- FUNCTION: encu.contar_pyg_res_enc_trg()

-- DROP FUNCTION IF EXISTS encu.contar_pyg_res_enc_trg();

CREATE OR REPLACE FUNCTION encu.contar_pyg_res_enc_trg()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE
  v_sentencia text;
  v_sentencia2 text;
  v_total_pyg integer;
  v_rea_pyg integer;
  
BEGIN
    v_total_pyg:=0;
    v_sentencia:=$$
      SELECT coalesce(pla_pyg_tot,0) from encu.plana_tem_ where pla_enc=$1
    $$;
     v_sentencia2:=$$
      UPDATE encu.respuestas SET res_valor=$1 where res_ope=dbo.ope_actual() and res_for='TEM' and res_var='pyg_tot' and res_enc=$2
    $$;
    CASE 
            WHEN  (TG_OP ='INSERT' OR TG_OP= 'UPDATE') THEN
                v_rea_pyg:=0;
                select count(pla_entrea_pg1) into v_rea_pyg from encu.plana_pyg_ where pla_entrea_pg1=1 and pla_enc=NEW.pla_enc;
                --raise notice 'enc, v_rea_pyg: %,% ', new.pla_enc,v_rea_pyg;  
                EXECUTE v_sentencia  INTO v_total_pyg  USING NEW.pla_enc;
                --raise notice 'valor,%', v_total_pyg ;
                v_total_pyg:=v_rea_pyg;
                --raise notice 'valor,%', v_total_pyg ;
                EXECUTE v_sentencia2 USING v_total_pyg, NEW.pla_enc ;
                RETURN NEW;
            WHEN TG_OP ='DELETE' THEN
                v_rea_pyg:=0;
                select count(pla_entrea_pg1) into v_rea_pyg from encu.plana_pyg_ where pla_entrea_pg1=1 and pla_enc=NEW.pla_enc;
                EXECUTE v_sentencia  INTO v_total_pyg  USING OLD.pla_enc;
                --raise notice 'valor,%', v_total_pyg ;
                if (v_total_pyg> 0 ) then
                   v_total_pyg=v_rea_pyg;
                  -- raise notice 'valor2,%', v_total_pyg ;
                   EXECUTE v_sentencia2  USING v_total_pyg, OLD.pla_enc ;
                end if;
                --Raise notice 'valor2,%', v_total_pyg ;
                RETURN OLD;
            ELSE
                RETURN NULL;
                
    END CASE;
END
$BODY$;

ALTER FUNCTION encu.contar_pyg_res_enc_trg()
    OWNER TO tedede_php;

--INICIALIZAR variable PYG_TOT
select count(*) from encu.respuestas
--update encu.respuestas set res_valor=0 
  where res_ope=dbo.ope_actual() and res_for='TEM' and res_mat='' and res_var='pyg_tot' and res_valor is null;
--9551 
