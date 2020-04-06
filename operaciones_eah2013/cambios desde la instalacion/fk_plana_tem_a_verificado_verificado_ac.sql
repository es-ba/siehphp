ALTER TABLE encu.plana_tem_
  ADD CONSTRAINT plana_tem__verificado_ac_fk FOREIGN KEY (pla_verificado_ac)
      REFERENCES encu.verificado (ver_ver) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;
