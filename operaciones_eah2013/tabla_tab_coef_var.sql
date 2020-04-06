-- Table: encu.tab_coef_var

-- DROP TABLE encu.tab_coef_var

CREATE TABLE encu.tab_coef_var
(
  tabcoefvar_poblacion integer NOT NULL,
  tabcoefvar_tabla character varying(50) NOT NULL,
  tabcoefvar_grzona character varying(1) NOT NULL,
  tabcoefvar_zona integer NOT NULL,
  tabcoefvar_dato numeric,
  tabcoefvar_tlg bigint NOT NULL,
  CONSTRAINT tabcoefvar_pkey PRIMARY KEY (tabcoefvar_poblacion, tabcoefvar_tabla, tabcoefvar_grzona, tabcoefvar_zona),
  CONSTRAINT tabcoefvar_tiempo_logico_fk FOREIGN KEY (tabcoefvar_tlg)
      REFERENCES encu.tiempo_logico (tlg_tlg) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);
ALTER TABLE encu.tab_coef_var
  OWNER TO tedede_php;