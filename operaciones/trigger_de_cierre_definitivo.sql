
CREATE OR REPLACE FUNCTION encu.cierre_definitivo_trg()
  RETURNS trigger AS
$BODY$
BEGIN
  RAISE 'CIERRE DEFINITIVO';
  RETURN NULL;
END
$BODY$
  LANGUAGE plpgsql VOLATILE;

ALTER FUNCTION encu.cierre_definitivo_trg()
  OWNER TO tedede_php;

CREATE TRIGGER cierre_definitivo_trg
  AFTER UPDATE OR INSERT OR DELETE
  ON encu.respuestas
  FOR EACH ROW
  EXECUTE PROCEDURE encu.cierre_definitivo_trg();

