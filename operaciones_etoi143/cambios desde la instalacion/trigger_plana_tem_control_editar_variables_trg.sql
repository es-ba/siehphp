-- Function: encu.plana_tem_control_editar_variables_trg()

-- DROP FUNCTION encu.plana_tem_control_editar_variables_trg();

CREATE OR REPLACE FUNCTION encu.plana_tem_control_editar_variables_trg()
  RETURNS trigger AS
$BODY$
DECLARE

BEGIN
  if new.pla_cnombre <> old.pla_cnombre OR new.pla_hn <> old.pla_hn then
    if new.pla_dominio <> 5 then
       raise 'NO PUEDE MODIFICAR LA DIRECCION Y/O NRO. DOMINIO % ', new.pla_dominio;
    end if;
  end if;
  RETURN new;
END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION encu.plana_tem_control_editar_variables_trg()
  OWNER TO tedede_php;

-- Trigger: plana_tem_control_editar_variables_trg on encu.respuestas

-- DROP TRIGGER plana_tem_control_editar_variables_trg ON encu.respuestas;

CREATE TRIGGER plana_tem_control_editar_variables_trg
  BEFORE UPDATE
  ON encu.plana_tem_
  FOR EACH ROW
  EXECUTE PROCEDURE encu.plana_tem_control_editar_variables_trg();