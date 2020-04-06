-- Table: encu.tabulados

-- DROP TABLE encu.tabulados;

CREATE TABLE encu.tabulados
(
  tab_tab character varying(30) NOT NULL,
  tab_titulo character varying(1000),
  tab_fila1 character varying(50),
  tab_fila2 character varying(50),
  tab_columna character varying(50),
  tab_cel_exp character varying(100),
  tab_cel_tipo character varying(30),
  tab_filtro text,
  tab_notas text,
  tab_observaciones text,
  tab_tlg bigint NOT NULL,
  CONSTRAINT tabulados_pkey PRIMARY KEY (tab_tab),
  CONSTRAINT tabulados_tiempo_logico_fk FOREIGN KEY (tab_tlg)
      REFERENCES encu.tiempo_logico (tlg_tlg) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);
ALTER TABLE encu.tabulados
  OWNER TO tedede_php;
