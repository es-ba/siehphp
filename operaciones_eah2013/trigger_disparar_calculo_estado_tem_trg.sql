-- Function: encu.disparar_calculo_estado_tem_trg()

-- DROP FUNCTION encu.disparar_calculo_estado_tem_trg();

CREATE OR REPLACE FUNCTION encu.disparar_calculo_estado_tem_trg()
  RETURNS trigger AS
$BODY$
    BEGIN
    if new.pla_reserva is distinct from old.pla_reserva or new.pla_nro_enc_de_baja is distinct from old.pla_nro_enc_de_baja then
        update encu.respuestas 
		set res_valor=res_valor
		where res_ope=dbo.ope_actual()
		and res_for='TEM'
		and res_mat=''
		and res_enc=new.pla_enc
		and res_hog=0
		and res_mie=0 
		and res_exm=0
		and res_var='asignable';
    end if;
    return new;
    END
  $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION encu.disparar_calculo_estado_tem_trg()
  OWNER TO tedede_php;

-- Trigger: disparar_calculo_estado_tem_trg on encu.plana_tem_

-- DROP TRIGGER disparar_calculo_estado_tem_trg ON encu.plana_tem_;

CREATE TRIGGER disparar_calculo_estado_tem_trg
  AFTER UPDATE
  ON encu.plana_tem_
  FOR EACH ROW
  EXECUTE PROCEDURE encu.disparar_calculo_estado_tem_trg();
