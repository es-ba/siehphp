
ALTER TABLE REPSIC.planilla_ps DROP CONSTRAINT planilla_ps_zona_fkey;

ALTER TABLE REPSIC.planilla_ps
  ADD CONSTRAINT planilla_ps_zona_fkey FOREIGN KEY (zona, fraccion, radio, manzana, segmento, dia)
      REFERENCES REPSIC.planilla_ts (zona, fraccion, radio, manzana, segmento, dia) MATCH SIMPLE
      ON UPDATE cascade ON DELETE NO ACTION;


ALTER TABLE REPSIC.planilla_ts DROP CONSTRAINT planilla_ts_zona_fkey;

ALTER TABLE REPSIC.planilla_ts
  ADD CONSTRAINT planilla_ts_zona_fkey FOREIGN KEY (zona, fraccion, radio, manzana, segmento)
      REFERENCES REPSIC.planilla_rr (zona, fraccion, radio, manzana, segmento) MATCH SIMPLE
      ON UPDATE cascade ON DELETE NO ACTION;

ALTER TABLE REPSIC.planilla_rr DROP CONSTRAINT planilla_rr_zona_fkey;

ALTER TABLE REPSIC.planilla_rr
  ADD CONSTRAINT planilla_rr_zona_fkey FOREIGN KEY (zona, fraccion, radio)
      REFERENCES REPSIC.planilla_rz (zona, fraccion, radio) MATCH SIMPLE
      ON UPDATE cascade ON DELETE NO ACTION;
