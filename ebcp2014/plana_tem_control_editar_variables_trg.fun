##FUN
plana_tem_control_editar_variables_trg
##ESQ
encu
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO
set search_path = encu, dbo, comun, public;

CREATE OR REPLACE FUNCTION encu.plana_tem_control_editar_variables_trg()
  RETURNS trigger AS
$BODY$
DECLARE

BEGIN
  if new.pla_cnombre <> old.pla_cnombre  then
    if new.pla_estado is distinct from 18 then
       raise 'NO PUEDE MODIFICAR nombre de calle % porque la encuesta no esta en estado 18, estado actual:%', new.pla_cnombre, new.pla_estado;    
    end if; 
  end if;
  RETURN new;
END
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION encu.plana_tem_control_editar_variables_trg()
  OWNER TO tedede_php;
