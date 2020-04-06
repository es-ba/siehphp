CREATE OR REPLACE FUNCTION encu.calcular_valhor_trg()
  RETURNS trigger AS
$BODY$
DECLARE
  v_val integer;
BEGIN
     CASE TG_OP
            WHEN 'INSERT' THEN
                select dbo.sd_valor_hora(new.pla_enc, new.pla_hog, new.pla_sd1, new.pla_sd2, new.pla_sd3, new.pla_sd4, new.pla_sd5, new.pla_sd6, new.pla_sd7, new.pla_sd7_1, new.pla_sd7_2, new.pla_sd7_3, new.pla_sd7_4 ) into v_val;
                new.pla_sd_valhor:=v_val;
                RETURN NEW;
            WHEN 'UPDATE' THEN 
                IF (new.pla_sd1 is distinct from old.pla_sd1 or new.pla_sd2 is distinct from old.pla_sd2 or new.pla_sd3 is distinct from old.pla_sd3 or new.pla_sd4 is distinct from old.pla_sd4 or 
                    new.pla_sd5 is distinct from old.pla_sd5 or new.pla_sd6 is distinct from old.pla_sd6 or new.pla_sd7 is distinct from old.pla_sd7 or new.pla_sd7_1 is distinct from old.pla_sd7_1 or 
                    new.pla_sd7_2 is distinct from old.pla_sd7_2 or new.pla_sd7_3 is distinct from old.pla_sd7_3 or new.pla_sd7_4 is distinct from old.pla_sd7_4) THEN
                    select dbo.sd_valor_hora(new.pla_enc, new.pla_hog, new.pla_sd1, new.pla_sd2, new.pla_sd3, new.pla_sd4, new.pla_sd5, new.pla_sd6, new.pla_sd7, new.pla_sd7_1, new.pla_sd7_2, new.pla_sd7_3, new.pla_sd7_4 ) into v_val;
                    new.pla_sd_valhor:=v_val;
                END IF; 
                RETURN NEW;
            ELSE
                RETURN NULL;                
    END CASE;
END
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION encu.calcular_valhor_trg()
  OWNER TO tedede_php;
 --------
CREATE TRIGGER calcular_valhor_i_trg
  BEFORE INSERT
  ON encu.plana_gh_
  FOR EACH ROW
  EXECUTE PROCEDURE encu.calcular_valhor_trg();  
 --------
CREATE TRIGGER calcular_valhor_u_trg
 BEFORE UPDATE
  ON encu.plana_gh_
  FOR EACH ROW
  EXECUTE PROCEDURE encu.calcular_valhor_trg();  
---------

INSERT INTO encu.varcal(varcal_ope, varcal_varcal, varcal_destino, varcal_orden, varcal_nombre, varcal_activa, varcal_tipo, varcal_baseusuario, varcal_nombrevar_baseusuario, varcal_tipodedato, varcal_tlg, varcal_valida, varcal_opciones_excluyentes) VALUES 
 ('empav31', 'sd_valhor', 'gh', 1, 'Valor hora del servicio doméstico', true, 'especial', false, NULL, 'entero', 1, true, false);
 
set search_path= encu, dbo, comun;
 ALTER TABLE plana_gh_ ADD COLUMN pla_sd_valhor integer; 
set search_path= his, dbo, comun;
 ALTER TABLE plana_gh_ ADD COLUMN pla_sd_valhor integer; 
 
---------
--para actualizar los casos ya existentes en plana_gh_
update encu.plana_gh_ g set pla_sd_valhor=g2.p_valor_hora
from 
 (select pla_enc, pla_hog, dbo.sd_valor_hora(pla_enc, pla_hog, pla_sd1, pla_sd2, pla_sd3, pla_sd4, pla_sd5, pla_sd6, pla_sd7, pla_sd7_1, pla_sd7_2, pla_sd7_3, pla_sd7_4 ) as p_valor_hora
    from encu.plana_gh_ ) g2
 where g.pla_enc=g2.pla_enc and g.pla_hog=g2.pla_hog; 
