CREATE OR REPLACE FUNCTION bolsas_verificado_trg() RETURNS TRIGGER AS $bolsas_verificado_trg$
  DECLARE
  BEGIN
   
  if new.bol_bol >1000 then
    raise exception 'no se pueden editar bolsas menores a 1000';
  end if;

   RETURN NULL;
  END;
$bolsas_verificado_trg$ LANGUAGE plpgsql;

CREATE TRIGGER bolsas_verificado_trg AFTER UPDATE
    ON bolsas FOR EACH ROW 
    EXECUTE PROCEDURE bolsas_verificado_trg();