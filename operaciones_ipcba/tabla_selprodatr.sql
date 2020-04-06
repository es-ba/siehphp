-- Table: cvp.selprodatr
-- DROP TABLE cvp.selprodatr;

CREATE TABLE cvp.selprodatr
(
  producto character varying(8) NOT NULL,
  sel_nro integer NOT NULL,
  atributo integer NOT NULL,
  valor character varying(250),
  CONSTRAINT selprodatr_pkey PRIMARY KEY (producto, sel_nro, atributo),
  CONSTRAINT selprodatr_selprod_fk FOREIGN KEY (producto, sel_nro)
     REFERENCES cvp.selprod (producto, sel_nro) MATCH SIMPLE
     ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT selprodatr_prodatr_fk FOREIGN KEY (producto,atributo)
     REFERENCES cvp.prodatr (producto,atributo) MATCH SIMPLE
     ON UPDATE NO ACTION ON DELETE NO ACTION
);
ALTER TABLE cvp.selprodatr
  OWNER TO cvpowner;