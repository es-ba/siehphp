CREATE OR REPLACE FUNCTION encu.respuestas_control_dm_trg()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE
  v_estado integer;
  --v_volver_a_cargar_enc integer;
  --v_volver_a_cargar_recu integer;
  --v_a_ingreso_enc integer;
  --v_a_ingreso_recu integer;
BEGIN
select pla_estado
    into   v_estado
    from encu.plana_tem_ 
    where pla_enc = new.res_enc;
    if (v_estado=23 and new.res_for='TEM' and new.res_var='volver_a_cargar_enc' and new.res_valor>='1' ) or (v_estado=33 and new.res_for='TEM' and new.res_var='volver_a_cargar_recu' and new.res_valor>='1'  ) then
        raise 'ENCUESTA % NO HABILITADA PARA VOLVER A CARGAR. ESTADO %', new.res_enc,  v_estado;
    end if;  
    if (v_estado=23 and new.res_for='TEM' and new.res_var='a_ingreso_enc' and new.res_valor='1') or (v_estado=33 and new.res_for='TEM' and new.res_var='a_ingreso_recu' and new.res_valor='1'  ) then
        raise 'ENCUESTA % NO HABILITADA PARA SETEAR A_INGRESO. ESTADO %', new.res_enc,  v_estado;
    end if;  

RETURN new;
END
$BODY$;

ALTER FUNCTION encu.respuestas_control_dm_trg()
    OWNER TO tedede_php;
--------------

CREATE OR REPLACE TRIGGER respuestas_control_dm_trg
    --BEFORE UPDATE OF  volver_a_cargar_enc, volver_a_cargar_recu, a_ingreso_enc, a_ingreso_recu
    BEFORE UPDATE 
    ON encu.respuestas
    FOR EACH ROW
    EXECUTE FUNCTION encu.respuestas_control_dm_trg();