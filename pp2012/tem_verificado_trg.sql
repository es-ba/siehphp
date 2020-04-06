CREATE OR REPLACE FUNCTION encu.tem_verificado_trg()
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
BEGIN
  -- Este trigger aplica solo a la TEM
  if new.res_for='TEM' then
    -- Aplica cuando se verifica o desverifica
    if new.res_var='verificado' then
      SELECT res_valor INTO STRICT v_rol FROM encu.respuestas WHERE res_var='rol' AND res_ope=new.res_ope AND res_for=new.res_for AND res_mat=new.res_mat AND res_enc=new.res_enc;
      SELECT res_valor INTO STRICT v_rea FROM encu.respuestas WHERE res_var='rea' AND res_ope=new.res_ope AND res_for=new.res_for AND res_mat=new.res_mat AND res_enc=new.res_enc;
      SELECT res_valor INTO STRICT v_norea FROM encu.respuestas WHERE res_var='norea' AND res_ope=new.res_ope AND res_for=new.res_for AND res_mat=new.res_mat AND res_enc=new.res_enc;
      SELECT res_valor INTO STRICT v_hog_tot FROM encu.respuestas WHERE res_var='hog_tot' AND res_ope=new.res_ope AND res_for=new.res_for AND res_mat=new.res_mat AND res_enc=new.res_enc;
      SELECT res_valor INTO STRICT v_per FROM encu.respuestas WHERE res_var='per' AND res_ope=new.res_ope AND res_for=new.res_for AND res_mat=new.res_mat AND res_enc=new.res_enc;
      SELECT coalesce(tem_lote,0) INTO STRICT v_lote FROM encu.tem WHERE tem_enc=new.res_enc;
      if new.res_valor='1' then -- verificado
        -- calcular el prox_rol
        if v_rol is null then
          raise exception 'no se puede verificar porque falta el rol en la TEM';
        end if;
        if v_rea is null then
          raise exception 'no se puede verificar porque falta REA en la TEM';
        end if;
        if v_rol=1 then -- estaba en pocesión del encuestador
          if v_rea=0 then -- ver si se supervisa o recupera
            if v_norea=61 then
              v_prox_rol:=9;
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
                    v_prox_rol:=4;
                else
                    v_prox_rol:=9;                    
              end case;
            end if;
          end if;
          UPDATE encu.respuestas SET res_valor=v_norea WHERE res_var='norea_e' AND res_ope=new.res_ope AND res_for=new.res_for AND res_mat=new.res_mat AND res_enc=new.res_enc;
          UPDATE encu.respuestas SET res_valor=v_per WHERE res_var='cod_enc' AND res_ope=new.res_ope AND res_for=new.res_for AND res_mat=new.res_mat AND res_enc=new.res_enc;
        elsif v_rol=2 then -- estaba en pocesión del recuperador
          if v_rea in (0,2) then -- ver si se supervisa o recupera
            if v_norea=61 then
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
              case (new.res_enc+v_lote*7) % 10
                when 1 then
                    v_prox_rol:=3;
                when 2 then
                    v_prox_rol:=4;
                else
                    v_prox_rol:=9;                    
              end case;
            end if;
          end if;
          UPDATE encu.respuestas SET res_valor=v_norea WHERE res_var='norea_r' AND res_ope=new.res_ope AND res_for=new.res_for AND res_mat=new.res_mat AND res_enc=new.res_enc;
          UPDATE encu.respuestas SET res_valor=v_per WHERE res_var='cod_recu' AND res_ope=new.res_ope AND res_for=new.res_for AND res_mat=new.res_mat AND res_enc=new.res_enc;
        elsif v_rol=3 then
          UPDATE encu.respuestas SET res_valor=v_per WHERE res_var='cod_sup' AND res_ope=new.res_ope AND res_for=new.res_for AND res_mat=new.res_mat AND res_enc=new.res_enc;
          v_prox_rol:=9;
        else
          v_prox_rol:=9;
        end if;
        UPDATE encu.respuestas SET res_valor=v_prox_rol WHERE res_var='prox_rol' AND res_ope=new.res_ope AND res_for=new.res_for AND res_mat=new.res_mat AND res_enc=new.res_enc;
      else -- desverificado:
      end if;
    end if;
  end if;
  RETURN new;
END
$BODY$
  LANGUAGE plpgsql;

-- /*
CREATE TRIGGER tem_verificado_trg
  AFTER UPDATE
  ON encu.respuestas
  FOR EACH ROW
  EXECUTE PROCEDURE encu.tem_verificado_trg();
-- */