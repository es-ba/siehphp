-- FUNCTION:  encu.contar_md_res_trg

-- DROP FUNCTION IF EXISTS  encu.contar_md_res_trg();

CREATE OR REPLACE FUNCTION encu.contar_md_res_trg()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE
  v_sentencia text;
  v_sentencia2 text;
  v_total_md integer;
  v_rea_md integer;
  
  BEGIN
    v_total_md:=0;
    v_sentencia:=$$
      SELECT coalesce(pla_md_tot,0) from encu.plana_tem_ where pla_enc=$1
    $$;
     v_sentencia2:=$$
      UPDATE encu.respuestas SET res_valor=$1 where res_ope=dbo.ope_actual() and res_for='TEM' and res_var='md_tot' and res_enc=$2
    $$;
    CASE 
            WHEN  (TG_OP ='INSERT' OR TG_OP= 'UPDATE') THEN
                v_rea_md:=0;
                select count(pla_entrea_md) into v_rea_md from encu.plana_md_ where pla_entrea_md=1 and pla_enc=NEW.pla_enc;
               -- raise notice 'enc, v_rea_md: %,% ', new.pla_enc,v_rea_md;
                EXECUTE v_sentencia2 USING v_rea_md, NEW.pla_enc ;
                RETURN NEW;
            WHEN TG_OP ='DELETE' THEN
                v_rea_md:=0;
                select count(pla_entrea_md) into v_rea_md from encu.plana_md_ where pla_entrea_md=1 and pla_enc=OLD.pla_enc;
                EXECUTE v_sentencia  INTO v_total_md  USING OLD.pla_enc;
                --raise notice 'valor,%', v_total_md ;
                if (v_total_md> 0 ) then
                   --raise notice 'valorrea,%', v_rea_md ;
                   EXECUTE v_sentencia2  USING v_rea_md, OLD.pla_enc ;
                end if;
                --Raise notice 'valor2,%', v_total_md ;
                RETURN OLD;
            ELSE
                RETURN NULL;
                
    END CASE;
END
$BODY$;


ALTER FUNCTION encu.contar_md_res_trg()
    OWNER TO tedede_php;
---------------------------------------------------


-- DROP TRIGGER IF EXISTS contar_md_res_d_trg ON encu.plana_md_;

CREATE TRIGGER contar_md_res_d_trg
    AFTER DELETE
    ON encu.plana_md_
    FOR EACH ROW
    EXECUTE FUNCTION encu.contar_md_res_trg();  




-- DROP TRIGGER IF EXISTS contar_md_res_iu_trg ON encu.plana_md_;

CREATE TRIGGER contar_md_res_iu_trg
    AFTER INSERT OR UPDATE OF pla_entrea_md
    ON encu.plana_md_
    FOR EACH ROW
    EXECUTE FUNCTION encu.contar_md_res_trg(); 
    
 /*   
--prueba con un caso insertando, borrando, actualizando desde dispositivo en test
    set role tedede_php;
    set search_path=encu;    
    select pla_enc, pla_mie,pla_entrea_md
      from encu.plana_md_
      where pla_enc=404147
    --group by 1;

    update encu.respuestas set res_valor=2 where res_enc=404147 and res_var='entrea_md'
      and res_for='MD' and res_mie=3 and res_hog=1;
    
    select pla_enc, pla_md_tot
      from encu.plana_tem_
      where pla_enc=404147 ;
  */    
----actualizar lo que ya está cargado en la base 
 update encu.respuestas set res_valor= null
   where res_ope=dbo.ope_actual() and res_for='TEM' and res_mat='' and res_var='md_tot'; 
 update encu.respuestas r set res_valor=v_rea_md::text
  from 
  ( select pla_enc, count(pla_entrea_md) v_rea_md 
      from encu.plana_md_  where pla_entrea_md=1
      group by 1
      order by 1) md
  where r.res_ope=dbo.ope_actual() and r.res_for='TEM' and r.res_mat='' and r.res_var='md_tot' and r.res_enc=md.pla_enc ;
     