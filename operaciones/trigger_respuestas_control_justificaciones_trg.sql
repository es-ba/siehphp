-- Function: encu.respuestas_control_justificaciones_trg()

-- DROP FUNCTION encu.respuestas_control_justificaciones_trg();

CREATE OR REPLACE FUNCTION encu.respuestas_control_justificaciones_trg()
  RETURNS trigger AS
$BODY$
DECLARE
  v_nojustificadas integer;
  v_select text;
  v_from text;
  v_where text;
  v_rol text;
  v_valor text;
  v_norea text;
  v_estado integer;
BEGIN
  if (new.res_var like 'verificado%' or new.res_var='fin_anacon') and new.res_valor in ( '1','3') then
     v_nojustificadas := 0;
     SELECT COUNT(*) into v_nojustificadas 
       FROM encu.inconsistencias
       WHERE inc_ope= new.res_ope and inc_enc= new.res_enc and (inc_justificacion is null or trim(inc_justificacion)='')
             and inc_con <> 'opc_inconsistente' 
             and inc_con not in(select con_con from encu.consistencias where con_ope=new.res_ope and con_momento = 'Procesamiento');
     if v_nojustificadas> 0 then
         raise 'NO SE PUEDE VERIFICAR LA ENCUESTA % TIENE % INCONSISTENCIAS SIN JUSTIFICAR',new.res_enc, v_nojustificadas;
     end if;
  end if;
  if ((new.res_var like 'verificado%' and new.res_var not like '%_ac') or new.res_var='fin_anacon') and (new.res_valor = '1' or new.res_valor = '4') then
     v_valor = null;
     v_select = $$
        SELECT res_valor
     $$;
     v_from := $$
        FROM encu.respuestas
     $$;
     v_where := $$
        WHERE res_ope = $1 AND res_for = $2 AND res_mat = $3 AND res_enc = $4 and res_hog = $5 AND 
              res_mie = $6 AND res_exm = $7 AND res_var = 'cod_'||split_part($8, '_', 2);        
        --PK DE encu.respuestas :res_ope, res_for, res_mat, res_enc, res_hog, res_mie, res_exm, res_var
     $$;
     EXECUTE v_select||v_from||v_where INTO v_valor USING new.res_ope, new.res_for, new.res_mat, new.res_enc, new.res_hog, new.res_mie, new.res_exm, new.res_var;
     IF v_valor IS NULL THEN
         v_rol := case when new.res_var like '%_enc'    then 'ENCUESTADOR'
                       when new.res_var like '%_sup'    then 'SUPERVISOR'
                       when new.res_var like '%_recu'   then 'RECUPERADOR'
                       when new.res_var like '%_anacon' then 'ANACON'
                  end;          
         raise 'NO SE PUEDE VERIFICAR LA ENCUESTA % PORQUE NO SE HA ESPECIFICADO EL CODIGO DE %',new.res_enc, v_rol;
     END IF;
  end if;
  if new.res_var like 'verificado%' and new.res_valor = '1' then
     SELECT res_valor INTO v_norea
     FROM encu.respuestas
     WHERE res_ope = new.res_ope AND res_for = new.res_for AND res_mat = new.res_mat AND res_enc = new.res_enc and res_hog = new.res_hog AND 
           res_mie = new.res_mie AND res_exm = new.res_exm AND res_var = 'norea';
     if v_norea = '18' then
       raise 'NOREA=18 solo permite verificado=4';
     end if;     
  end if;
  if new.res_var like 'verificado%' and new.res_valor = '1' then
     SELECT pla_estado into v_estado
     FROM encu.plana_tem_ 
     WHERE pla_enc = new.res_enc and pla_hog = new.res_hog and pla_mie = new.res_mie and pla_exm = new.res_exm;
     IF v_estado = 23 or v_estado = 24 or v_estado = 33 or v_estado = 34 then
         raise 'NO SE PUEDE VERIFICAR LA ENCUESTA % PORQUE SE ENCUENTRA EN ESTADO %',new.res_enc, v_estado;
     END IF;
  end if;
  RETURN new;
END
$BODY$
  LANGUAGE plpgsql STABLE;
ALTER FUNCTION encu.respuestas_control_justificaciones_trg()
  OWNER TO tedede_php;


-- Trigger: respuestas_control_justificaciones_trg on encu.respuestas

-- DROP TRIGGER respuestas_control_justificaciones_trg ON encu.respuestas;

CREATE TRIGGER respuestas_control_justificaciones_trg
  BEFORE UPDATE
  ON encu.respuestas
  FOR EACH ROW
  EXECUTE PROCEDURE encu.respuestas_control_justificaciones_trg();
