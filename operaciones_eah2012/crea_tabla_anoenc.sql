-- Table: encu.anoenc

-- DROP TABLE encu.anoenc;

CREATE TABLE encu.anoenc
(
  anoenc_ope character varying(50) NOT NULL,
  anoenc_enc integer NOT NULL,
  anoenc_anoenc integer NOT NULL,
  anoenc_rol character varying(30),
  anoenc_per integer,
  anoenc_usu character varying(30),
  anoenc_fecha character varying(30),
  anoenc_hora character varying(30),
  anoenc_anotacion character varying(1000),
  anoenc_tlg bigint NOT NULL,
  CONSTRAINT anoenc_pkey PRIMARY KEY (anoenc_ope , anoenc_enc , anoenc_anoenc),
  CONSTRAINT anoenc_operativos_fk FOREIGN KEY (anoenc_ope)
      REFERENCES encu.operativos (ope_ope) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT anoenc_roles_fk FOREIGN KEY (anoenc_rol)
      REFERENCES encu.roles (rol_rol) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT anoenc_tiempo_logico_fk FOREIGN KEY (anoenc_tlg)
      REFERENCES encu.tiempo_logico (tlg_tlg) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT anoenc_usuarios_fk FOREIGN KEY (anoenc_usu)
      REFERENCES encu.usuarios (usu_usu) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE encu.anoenc
  OWNER TO tedede_php;
