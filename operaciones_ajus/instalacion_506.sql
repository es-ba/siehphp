CREATE OR REPLACE FUNCTION encu.consistencias_upd_trg()
  RETURNS trigger AS
$BODY$
BEGIN
  if new.con_precondicion is distinct from old.con_precondicion 
    or new.con_postcondicion is distinct from old.con_postcondicion
    or new.con_rel is distinct from old.con_rel
  then
    -- estos campos se anulan ante cualquier cambio, solo pueden ser restaurados por el sistema cambiando en forma simultánea la revision
    -- new.con_junta=null;
    new.con_expresion_sql:=null;
    new.con_clausula_from:=null;
    new.con_error_compilacion:='Modificada desde la compilacion anterior';
    new.con_valida:=false;
  end if;
  return new;
END
$BODY$
LANGUAGE plpgsql VOLATILE;
/*OTRA*/
ALTER FUNCTION encu.consistencias_upd_trg()
  OWNER TO tedede_php;
/*OTRA*/
CREATE TRIGGER consistencias_upd_trg
    BEFORE UPDATE
  ON encu.consistencias
  FOR EACH ROW
  EXECUTE PROCEDURE encu.consistencias_upd_trg();
