-- Table: encu.razones

-- DROP TABLE encu.razones;

CREATE TABLE encu.razones
(
  raz_raz integer,
  raz_nombre character varying(10 0),
  raz_prioridad integer,
  raz_tlg bigint NOT NULL,
  CONSTRAINT razones_pkey PRIMARY KEY (raz_raz),  
  CONSTRAINT razones_tiempo_logico_fk FOREIGN KEY (raz_tlg)
      REFERENCES encu.tiempo_logico (tlg_tlg) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE encu.razones
  OWNER TO tedede_php;
