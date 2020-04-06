-- Table: encu.varcalopc

-- DROP TABLE encu.varcalopc;

CREATE TABLE encu.varcalopc
(
  varcalopc_ope character varying(50) NOT NULL,
  varcalopc_varcal character varying(50) NOT NULL,
  varcalopc_opcion integer NOT NULL,
  varcalopc_expresion character varying(500) NOT NULL,
  varcalopc_etiqueta character varying(200),
  varcalopc_confirmado boolean,
  varcalopc_tlg bigint NOT NULL,
  CONSTRAINT varcalopc_pkey PRIMARY KEY (varcalopc_ope, varcalopc_varcal, varcalopc_opcion),
  CONSTRAINT varcalopc_operativos_fk FOREIGN KEY (varcalopc_ope)
      REFERENCES encu.operativos (ope_ope) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT varcalopc_varcal_fk FOREIGN KEY (varcalopc_ope, varcalopc_varcal)
      REFERENCES encu.varcal (varcal_ope, varcal_varcal) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT varcalopc_tiempo_logico_fk FOREIGN KEY (varcalopc_tlg)
      REFERENCES encu.tiempo_logico (tlg_tlg) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "texto invalido en varcalopc_ope de tabla varcalopc" CHECK (comun.cadena_valida(varcalopc_ope::text, 'codigo'::text)),
  CONSTRAINT "texto invalido en varcalopc_varcal de tabla varcalopc" CHECK (comun.cadena_valida(varcalopc_varcal::text, 'codigo'::text)),
  CONSTRAINT "texto invalido en varcalopc_expresion de tabla varcalopc" CHECK (comun.cadena_valida(varcalopc_expresion::text, 'formula'::text)),
  CONSTRAINT "texto invalido en varcalopc_etiqueta de tabla varcalopc" CHECK (comun.cadena_valida(varcalopc_etiqueta::text, 'cualquiera'::text))
)
WITH (
  OIDS=FALSE
);
ALTER TABLE encu.varcalopc
  OWNER TO tedede_php;