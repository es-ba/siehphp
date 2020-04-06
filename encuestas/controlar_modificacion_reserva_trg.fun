##FUN
controlar_modificacion_reserva_trg
##ESQ
encu
##PARA
produccion
##PUBLICA
no
##PAR

##TIPO_DEVUELTO
trigger
##TIPO_FUNCION
plpgsql
##DESCRIPCION
Funcion trigger que permite la modificacion del campo reserva en plana_tem_ cumpliendo ciertas condiciones

##CUERPO
-- DROP FUNCTION encu.controlar_modificacion_reserva_trg();
CREATE OR REPLACE FUNCTION encu.controlar_modificacion_reserva_trg()
  RETURNS trigger AS
$BODY$
    BEGIN
    if new.pla_reserva is distinct from old.pla_reserva then 
       if not ( new.pla_estado =18 and new.pla_dominio in (4,5) ) then
           raise exception 'No se puede modificar el campo reserva en encuestas que no cumplen: (dominio 4 o dominio 5) y estado =18';    
       end if;
    end if;     
    return new;
    END
  $BODY$
  LANGUAGE plpgsql;
ALTER FUNCTION encu.controlar_modificacion_reserva_trg()
  OWNER TO tedede_php;
  
--DROP TRIGGER controlar_modificacion_reserva_trg ON encu.plana_tem_;
CREATE TRIGGER controlar_modificacion_reserva_trg
  BEFORE UPDATE
  ON encu.plana_tem_
  FOR EACH ROW
  EXECUTE PROCEDURE encu.controlar_modificacion_reserva_trg();
  