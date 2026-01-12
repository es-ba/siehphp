-- FUNCTION: encu.contar_md_encuesta_trg()

-- DROP FUNCTION IF EXISTS encu.contar_md_encuesta_trg();

CREATE OR REPLACE FUNCTION encu.contar_md_encuesta_trg()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE
  v_sentencia text;
  v_sentencia2 text;
  v_total_md integer;
  
BEGIN
    v_total_md:=0;
    v_sentencia:=$$
      SELECT coalesce(pla_md_tot,0) from encu.plana_tem_ where pla_enc=$1
    $$;
     v_sentencia2:=$$
      UPDATE encu.respuestas SET res_valor=$1 where res_ope=dbo.ope_actual() and res_for='TEM' and res_var='md_tot' and res_enc=$2
    $$;
    CASE TG_OP
            WHEN 'INSERT' THEN
                --raise notice 'enc,%', new.pla_enc;
                EXECUTE v_sentencia  INTO v_total_md  USING NEW.pla_enc;
                --raise notice 'valor,%', v_total_md ;
                v_total_md:=v_total_md+1;
                EXECUTE v_sentencia2 USING v_total_md, NEW.pla_enc ;
                RETURN NEW;
            WHEN 'DELETE' THEN 
                EXECUTE v_sentencia  INTO v_total_md  USING OLD.pla_enc;
                --raise notice 'valor,%', v_total_md ;
                if (v_total_md> 0 ) then
                   v_total_md=v_total_md-1;
                   EXECUTE v_sentencia2  USING v_total_md, OLD.pla_enc ;
                end if;
                --Raise notice 'valor2,%', v_total_md ;
                RETURN OLD;
            ELSE
                RETURN NULL;
                
    END CASE;
END
$BODY$;

ALTER FUNCTION encu.contar_md_encuesta_trg()
    OWNER TO tedede_php;


CREATE TRIGGER contar_md_d_trg
    AFTER DELETE
    ON encu.plana_md_
    FOR EACH ROW
    EXECUTE FUNCTION encu.contar_md_encuesta_trg();

-- Trigger: contar_md_i_trg

-- DROP TRIGGER IF EXISTS contar_md_i_trg ON encu.plana_md_;

CREATE TRIGGER contar_md_i_trg
    AFTER INSERT
    ON encu.plana_md_
    FOR EACH ROW
    EXECUTE FUNCTION encu.contar_md_encuesta_trg();