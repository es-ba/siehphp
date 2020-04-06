
CREATE TABLE encu.excepciones
(
  exc_ope character varying(50) NOT NULL,
  exc_enc integer NOT NULL,
  exc_excepcion text,
  exc_tlg bigint NOT NULL,
  CONSTRAINT excepciones_pkey PRIMARY KEY (exc_ope, exc_enc),
  CONSTRAINT excepciones_operativos_fk FOREIGN KEY (exc_ope)
      REFERENCES encu.operativos (ope_ope) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT excepciones_tiempo_logico_fk FOREIGN KEY (exc_tlg)
      REFERENCES encu.tiempo_logico (tlg_tlg) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "texto invalido en exc_excepcion de tabla excepciones" CHECK (comun.cadena_valida(exc_excepcion, 'cualquiera'::text))
)
WITH (
  OIDS=FALSE
);
ALTER TABLE encu.excepciones OWNER TO tedede_php;
