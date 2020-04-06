-- Table: encu.varcal

-- DROP TABLE encu.varcal;

CREATE TABLE encu.varcal
(
  varcal_ope character varying(50) NOT NULL,
  varcal_varcal character varying(50) NOT NULL,
  varcal_destino character varying(50) NOT NULL,
  varcal_orden integer NOT NULL,
  varcal_nombre character varying(160),
  varcal_comentarios character varying(200),
  varcal_tlg bigint NOT NULL,
  CONSTRAINT varcal_pkey PRIMARY KEY (varcal_ope, varcal_varcal),
  CONSTRAINT varcal_operativos_fk FOREIGN KEY (varcal_ope)
      REFERENCES encu.operativos (ope_ope) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT varcal_tiempo_logico_fk FOREIGN KEY (varcal_tlg)
      REFERENCES encu.tiempo_logico (tlg_tlg) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "texto invalido en varcal_comentarios de tabla varcal" CHECK (comun.cadena_valida(varcal_comentarios::text, 'cualquiera'::text)),
  CONSTRAINT "texto invalido en varcal_destino de tabla varcal" CHECK (comun.cadena_valida(varcal_destino::text, 'codigo'::text)),
  CONSTRAINT "texto invalido en varcal_nombre de tabla varcal" CHECK (comun.cadena_valida(varcal_nombre::text, 'cualquiera'::text)),
  CONSTRAINT "texto invalido en varcal_ope de tabla varcal" CHECK (comun.cadena_valida(varcal_ope::text, 'codigo'::text)),
  CONSTRAINT "texto invalido en varcal_varcal de tabla varcal" CHECK (comun.cadena_valida(varcal_varcal::text, 'codigo'::text))
)
WITH (
  OIDS=FALSE
);
ALTER TABLE encu.varcal
  OWNER TO tedede_php;
