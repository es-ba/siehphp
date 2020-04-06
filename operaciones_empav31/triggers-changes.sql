CREATE TRIGGER changes_trg
  AFTER INSERT OR UPDATE OR DELETE
  ON empa.planilla_ps
  FOR EACH ROW
  EXECUTE PROCEDURE his.changes_trg('zona,fraccion,radio,manzana,segmento,dia,orden,hogar');

CREATE TRIGGER changes_trg
  AFTER INSERT OR UPDATE OR DELETE
  ON empa.planilla_ts
  FOR EACH ROW
  EXECUTE PROCEDURE his.changes_trg('zona,fraccion,radio,manzana,segmento,dia');

CREATE TRIGGER changes_trg
  AFTER INSERT OR UPDATE OR DELETE
  ON empa.planilla_rr
  FOR EACH ROW
  EXECUTE PROCEDURE his.changes_trg('zona,fraccion,radio,manzana,segmento');

CREATE TRIGGER changes_trg
  AFTER INSERT OR UPDATE OR DELETE
  ON empa.planilla_rz
  FOR EACH ROW
  EXECUTE PROCEDURE his.changes_trg('zona,fraccion,radio');

CREATE TRIGGER changes_trg
  AFTER INSERT OR UPDATE OR DELETE
  ON empa.planilla_z
  FOR EACH ROW
  EXECUTE PROCEDURE his.changes_trg('zona,fraccion');
