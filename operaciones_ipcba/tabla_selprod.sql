-- Table: cvp.selprod
-- DROP TABLE cvp.selprod;

CREATE TABLE cvp.selprod
(
  producto character varying(8) NOT NULL,
  sel_nro integer NOT NULL,
  descripcion character varying(500),
  CONSTRAINT selprod_pkey PRIMARY KEY (producto, sel_nro),
  CONSTRAINT selprod_productos_fk FOREIGN KEY (producto)
     REFERENCES cvp.productos (producto) MATCH SIMPLE
     ON UPDATE NO ACTION ON DELETE NO ACTION
);
ALTER TABLE cvp.selprod
  OWNER TO cvpowner;