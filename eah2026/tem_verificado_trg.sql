CREATE OR REPLACE FUNCTION tem_verificado_trg()
  RETURNS trigger AS
$BODY$
DECLARE
  v_rol integer;
  v_rea integer;
  v_norea integer;
  v_hog_tot integer;
  v_prox_rol integer;
  v_lote integer;
  v_per integer;
  v_dominio integer;
  v_verificado integer;
  v_estado_procesamiento varchar(255);
  v_estado_procesamiento_int integer;
  v_devolucion_campo varchar(255);
  v_devolucion_tematico varchar(255);
  v_fin_campo varchar(255);
  v_estado varchar(255);
  v_estado_int integer;
  v_sup_dirigida integer;
  v_per_a_cargar integer;
  v_bolsa integer;
  v_recep integer;
BEGIN
  -- Este trigger aplica solo a la TEM y a la modificación de los valores (no de los colores) 
  if new.res_for='TEM' and 
        (new.res_valor is distinct from old.res_valor 
        or new.res_valesp is distinct from old.res_valesp 
        or new.res_valor_con_error is distinct from old.res_valor_con_error 
        ) 
  then
    -- #590 No permitir cambiar rea, norea, etc. si Verificado = 1
    if new.res_var in ('rea','hog_pre','hog_tot','pob_pre','pob_tot','norea') then
      SELECT res_valor INTO STRICT v_verificado     FROM respuestas WHERE res_var='verificado'     AND res_ope=new.res_ope AND res_for=new.res_for AND res_mat=new.res_mat AND res_enc=new.res_enc;
      if v_verificado is not null then
        raise exception 'no se puede modificar porque esta verificado.';
      end if;
    end if;
    -- #591 Poner sup_dirigida en prox_rol
    if new.res_var = 'sup_dirigida' then
          UPDATE respuestas SET res_valor=new.res_valor WHERE res_var='prox_rol' AND res_ope=new.res_ope AND res_for=new.res_for AND res_mat=new.res_mat AND res_enc=new.res_enc;
    end if;
    -- #604 Al poner un resultado_supervision, hay que pasar el estado_carga a 2
    if new.res_var = 'resultado_supervision' then
        UPDATE respuestas SET res_valor=2 WHERE res_var='estado_carga' AND res_ope=new.res_ope AND res_for=new.res_for AND res_mat=new.res_mat AND res_enc=new.res_enc;
    end if;
    -- Aplica cuando se verifica o desverifica
    if new.res_var='verificado' then
      SELECT res_valor INTO STRICT v_rol     FROM respuestas WHERE res_var='rol'           AND res_ope=new.res_ope AND res_for=new.res_for AND res_mat=new.res_mat AND res_enc=new.res_enc;
      SELECT res_valor INTO STRICT v_rea     FROM respuestas WHERE res_var='rea'           AND res_ope=new.res_ope AND res_for=new.res_for AND res_mat=new.res_mat AND res_enc=new.res_enc;
      SELECT res_valor INTO STRICT v_norea   FROM respuestas WHERE res_var='norea'         AND res_ope=new.res_ope AND res_for=new.res_for AND res_mat=new.res_mat AND res_enc=new.res_enc;
      SELECT res_valor INTO STRICT v_hog_tot FROM respuestas WHERE res_var='hog_tot'       AND res_ope=new.res_ope AND res_for=new.res_for AND res_mat=new.res_mat AND res_enc=new.res_enc;
      SELECT res_valor INTO STRICT v_per     FROM respuestas WHERE res_var='per'           AND res_ope=new.res_ope AND res_for=new.res_for AND res_mat=new.res_mat AND res_enc=new.res_enc;
      SELECT res_valor INTO STRICT v_recep   FROM respuestas WHERE res_var='recepcionista' AND res_ope=new.res_ope AND res_for=new.res_for AND res_mat=new.res_mat AND res_enc=new.res_enc;
      SELECT pla_dominio INTO STRICT v_dominio FROM plana_tem_ WHERE pla_enc=new.res_enc;
      SELECT coalesce(tem_lote,0) INTO STRICT v_lote FROM tem WHERE tem_enc=new.res_enc;
      SELECT res_valor INTO STRICT v_per_a_cargar FROM respuestas WHERE res_var='per_a_cargar' AND res_ope=new.res_ope AND res_for=new.res_for AND res_mat=new.res_mat AND res_enc=new.res_enc;
      SELECT res_valor INTO STRICT v_sup_dirigida FROM respuestas WHERE res_var='sup_dirigida' AND res_ope=new.res_ope AND res_for=new.res_for AND res_mat=new.res_mat AND res_enc=new.res_enc;
      if new.res_valor='1' or new.res_valor='3' then -- verificado o fuerza Fin de Campo
        -- calcular el prox_rol
        if v_rol is null then
          raise exception 'no se puede verificar porque falta el rol en la TEM';
        end if;
        if v_rea is null then
          raise exception 'no se puede verificar porque falta REA en la TEM';
        end if;
        if (v_rea=0 or v_rea=2) and (v_norea=0 or v_norea is null) then
            raise exception 'no se puede verificar una no realizada sino aclara un motivo';
        end if;
        if (v_rea=1 or v_rea=3) and (v_norea>0) then
            raise exception 'no se puede verificar una realizada con motivo de no realizada(norea)';
        end if;
        if (v_per_a_cargar>0) then
            raise exception 'no se puede verificar una encuesta asignada (per_a_cargar)';
        end if;
      end if;
      if new.res_valor='1' then -- verificado
        if v_rol=1 then -- estaba en posesión del encuestador
          if v_dominio=5 or v_dominio=4 then
            v_prox_rol:=9;
          elsif v_rea=0 then -- ver si se supervisa o recupera
            if v_norea=61 or v_norea=18 or v_norea=91 or v_norea=93 or v_norea=94 then
              v_prox_rol:=9;
            elsif v_norea=10 then
              v_prox_rol:=2;
            elsif v_norea<70 then
              v_prox_rol:=3;
            else
              v_prox_rol:=2;
            end if;
          else
            if v_hog_tot>1 then
              v_prox_rol:=3;
            else
              case (new.res_enc+v_lote*7) % 10
                when 1 then
                    v_prox_rol:=3;
                when 2 then
                    if v_dominio<>4 then
                        v_prox_rol:=4;
                    end if;
                when 5 then
                    v_prox_rol:=3;
                else
                    v_prox_rol:=9;                    
              end case;
            end if;
          end if;
          UPDATE respuestas SET res_valor=v_norea WHERE res_var='norea_e' AND res_ope=new.res_ope AND res_for=new.res_for AND res_mat=new.res_mat AND res_enc=new.res_enc;
          UPDATE respuestas SET res_valor=v_per WHERE res_var='cod_enc' AND res_ope=new.res_ope AND res_for=new.res_for AND res_mat=new.res_mat AND res_enc=new.res_enc;
        elsif v_rol=2 then -- estaba en posesión del recuperador
          if v_rea in (0,2) then -- ver si se supervisa o recupera
            if v_norea=61 or v_norea=18 or v_norea=91 or v_norea=93 or v_norea=94 then
              v_prox_rol:=9;
            elsif v_norea<70 then
              v_prox_rol:=3;
            else
              v_prox_rol:=9;
            end if;
          else
            if v_hog_tot>1 then
              v_prox_rol:=3;
            else
              case (new.res_enc*3+v_lote*7) % 10
                when 1 then
                    v_prox_rol:=3;
                when 2 then
                    v_prox_rol:=4;
                when 5 then
                    v_prox_rol:=3;
                else
                    v_prox_rol:=9;                    
              end case;
            end if;
          end if;
          UPDATE respuestas SET res_valor=v_norea WHERE res_var='norea_r' AND res_ope=new.res_ope AND res_for=new.res_for AND res_mat=new.res_mat AND res_enc=new.res_enc;
          UPDATE respuestas SET res_valor=v_per WHERE res_var='cod_recu' AND res_ope=new.res_ope AND res_for=new.res_for AND res_mat=new.res_mat AND res_enc=new.res_enc;
        elsif v_rol=3 then
          UPDATE respuestas SET res_valor=v_per WHERE res_var='cod_sup' AND res_ope=new.res_ope AND res_for=new.res_for AND res_mat=new.res_mat AND res_enc=new.res_enc;
          v_prox_rol:=9;
        elsif v_rol=4 then
          UPDATE respuestas SET res_valor=v_recep WHERE res_var='cod_sup' AND res_ope=new.res_ope AND res_for=new.res_for AND res_mat=new.res_mat AND res_enc=new.res_enc;
          v_prox_rol:=9;
        else
          v_prox_rol:=9;
        end if;
        UPDATE respuestas SET res_valor=v_prox_rol WHERE res_var='prox_rol' AND res_ope=new.res_ope AND res_for=new.res_for AND res_mat=new.res_mat AND res_enc=new.res_enc;
      elsif new.res_valor='2' then -- reemplazo no usado
        if v_rea is not null and v_rea<>0 then
          raise exception 'no se puede verificar como "reemplazo no usado" porque tiene REA en la TEM';
        end if;
        if v_dominio is distinct from 4 and v_sup_dirigida is distinct from 22 then
          raise exception 'el verificado=2 es solo para inquilinato';
        end if;
        UPDATE respuestas SET res_valor=null  WHERE res_var='prox_rol'     AND res_ope=new.res_ope AND res_for=new.res_for AND res_mat=new.res_mat AND res_enc=new.res_enc;
        UPDATE respuestas SET res_valor=null  WHERE res_var='per_a_cargar' AND res_ope=new.res_ope AND res_for=new.res_for AND res_mat=new.res_mat AND res_enc=new.res_enc;
        UPDATE respuestas SET res_valor='2'   WHERE res_var='estado_carga' AND res_valor='1'       AND res_ope=new.res_ope AND res_for=new.res_for AND res_mat=new.res_mat AND res_enc=new.res_enc;
      elsif new.res_valor ='3' then -- forzar fin de campo --prox_rol=9
        UPDATE respuestas SET res_valor='9'  WHERE res_var='prox_rol'     AND res_ope=new.res_ope AND res_for=new.res_for AND res_mat=new.res_mat AND res_enc=new.res_enc;
      elsif new.res_valor is not null then -- ni 1 ni 2 ni 3
        raise exception 'solo puede ponerse 1, 2 o 3 en "verificado" 1=0k 2=reemplazo no usado 3=forzar fin de campo ';
      end if;
    end if;
    -- #    
    if  new.res_var in ('sup_dirigida','verificado','estado_procesamiento','devolucion_campo','devolucion_tematico','fin_campo') then
        SELECT CASE WHEN new.res_var='verificado'           THEN new.res_valor ELSE res_valor END INTO STRICT v_verificado           FROM respuestas WHERE res_var='verificado'            AND res_ope=new.res_ope AND res_for=new.res_for AND res_mat=new.res_mat AND res_enc=new.res_enc;    
        SELECT CASE WHEN new.res_var='estado_procesamiento' THEN new.res_valor ELSE res_valor END INTO STRICT v_estado_procesamiento FROM respuestas WHERE res_var='estado_procesamiento'  AND res_ope=new.res_ope AND res_for=new.res_for AND res_mat=new.res_mat AND res_enc=new.res_enc;    
        SELECT CASE WHEN new.res_var='devolucion_campo'     THEN new.res_valor ELSE res_valor END INTO STRICT v_devolucion_campo     FROM respuestas WHERE res_var='devolucion_campo'      AND res_ope=new.res_ope AND res_for=new.res_for AND res_mat=new.res_mat AND res_enc=new.res_enc;    
        SELECT CASE WHEN new.res_var='devolucion_tematico'  THEN new.res_valor ELSE res_valor END INTO STRICT v_devolucion_tematico  FROM respuestas WHERE res_var='devolucion_tematico'   AND res_ope=new.res_ope AND res_for=new.res_for AND res_mat=new.res_mat AND res_enc=new.res_enc; 
        SELECT CASE WHEN new.res_var='fin_campo'            THEN new.res_valor ELSE res_valor END INTO STRICT v_fin_campo            FROM respuestas WHERE res_var='fin_campo'             AND res_ope=new.res_ope AND res_for=new.res_for AND res_mat=new.res_mat AND res_enc=new.res_enc; 
        SELECT res_valor INTO STRICT v_bolsa FROM respuestas WHERE res_var='bolsa' AND res_ope=new.res_ope AND res_for=new.res_for AND res_mat=new.res_mat AND res_enc=new.res_enc;
        -- dbo.tem_estado(v_fin_campo,v_estado_procesamiento,v_devolucion_campo,v_devolucion_tematico)
        v_estado=dbo.tem_estado(v_fin_campo,v_estado_procesamiento,v_devolucion_campo,v_devolucion_tematico,v_verificado,new.res_var,v_bolsa);
        UPDATE respuestas SET res_valor=v_estado WHERE res_var='estado' AND res_ope=new.res_ope AND res_for=new.res_for AND res_mat=new.res_mat AND res_enc=new.res_enc;
    end if;
  end if;
  RETURN new;
END
$BODY$
  LANGUAGE plpgsql;

/*
CREATE TRIGGER tem_verificado_trg
  AFTER UPDATE
  ON respuestas
  FOR EACH ROW
  EXECUTE PROCEDURE tem_verificado_trg();
-- */