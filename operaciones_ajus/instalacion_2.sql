
CREATE TABLE encu.relaciones
(
  rel_rel character varying(3) NOT NULL,
  rel_nombre character varying(20) NOT NULL,
  rel_tlg bigint NOT NULL,
  CONSTRAINT relaciones_pkey PRIMARY KEY (rel_rel ),
  CONSTRAINT relaciones_tiempo_logico_fk FOREIGN KEY (rel_tlg)
      REFERENCES encu.tiempo_logico (tlg_tlg) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE encu.relaciones
  OWNER TO tedede_php;


CREATE TABLE his.his_inconsistencias
(
  hisinc_ope text,
  hisinc_con text,
  hisinc_enc integer,
  hisinc_hog integer,
  hisinc_mie integer,
  hisinc_variables_y_valores text,
  hisinc_justificacion text,
  hisinc_autor_justificacion text,
  hisinc_tlg bigint
)
WITH (
  OIDS=FALSE
);
ALTER TABLE his.his_inconsistencias
  OWNER TO tedede_php;

CREATE TABLE encu.bolsas
(
  bol_ope character varying(50) NOT NULL,
  bol_bol integer NOT NULL,
  bol_cerrada boolean,
  bol_rea boolean NOT NULL DEFAULT true,
  bol_activa boolean,
  bol_revisada boolean,
  bol_tlg bigint NOT NULL,
  CONSTRAINT bolsas_pkey PRIMARY KEY (bol_ope , bol_bol ),
  CONSTRAINT bolsas_operativos_fk FOREIGN KEY (bol_ope)
      REFERENCES encu.operativos (ope_ope) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT bolsas_tiempo_logico_fk FOREIGN KEY (bol_tlg)
      REFERENCES encu.tiempo_logico (tlg_tlg) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE encu.bolsas
  OWNER TO tedede_php;

  
CREATE TABLE encu.consistencias
(
  con_ope character varying(50) NOT NULL,
  con_con text NOT NULL,
  con_precondicion character varying(800),
  con_rel character varying(3),
  con_postcondicion character varying(800),
  con_activa boolean NOT NULL DEFAULT true,
  con_descripcion character varying(240),
  con_grupo character varying(240),
  con_modulo character varying(240),
  con_tipo character varying(240),
  con_gravedad character varying(240),
  con_momento character varying(240),
  con_version character varying(240),
  con_explicacion character varying(300),
  con_orden integer,
  con_expl_ok boolean NOT NULL DEFAULT false,
  con_rev integer NOT NULL DEFAULT 1,
  con_junta character varying(30),
  con_clausula_from character varying(4000),
  con_expresion_sql character varying(4000),
  con_valida boolean DEFAULT false,
  con_error_compilacion character varying(4000),
  con_ultima_modificacion timestamp without time zone,
  con_ultima_variable character varying(50),
  con_ignorar_nulls boolean,
  con_tlg bigint NOT NULL,
  CONSTRAINT consistencias_pkey PRIMARY KEY (con_ope , con_con ),
  CONSTRAINT consistencias_operativos_fk FOREIGN KEY (con_ope)
      REFERENCES encu.operativos (ope_ope) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT consistencias_relaciones_fk FOREIGN KEY (con_rel)
      REFERENCES encu.relaciones (rel_rel) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT consistencias_tiempo_logico_fk FOREIGN KEY (con_tlg)
      REFERENCES encu.tiempo_logico (tlg_tlg) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE encu.consistencias
  OWNER TO tedede_php;


CREATE TABLE encu.inconsistencias
(
  inc_ope character varying(50) NOT NULL,
  inc_con text NOT NULL,
  inc_enc integer NOT NULL,
  inc_hog integer NOT NULL,
  inc_mie integer NOT NULL,
  inc_variables_y_valores text,
  inc_justificacion character varying(140),
  inc_autor_justificacion character varying(30),
  inc_tlg bigint NOT NULL,
  CONSTRAINT inconsistencias_pkey PRIMARY KEY (inc_ope , inc_con , inc_enc , inc_hog , inc_mie ),
  CONSTRAINT inconsistencias_consistencias_fk FOREIGN KEY (inc_ope, inc_con)
      REFERENCES encu.consistencias (con_ope, con_con) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT inconsistencias_operativos_fk FOREIGN KEY (inc_ope)
      REFERENCES encu.operativos (ope_ope) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT inconsistencias_tiempo_logico_fk FOREIGN KEY (inc_tlg)
      REFERENCES encu.tiempo_logico (tlg_tlg) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE encu.inconsistencias
  OWNER TO tedede_php;

  
CREATE TABLE encu.con_var
(
  convar_ope character varying(50) NOT NULL,
  convar_con text NOT NULL,
  convar_var character varying(50) NOT NULL,
  convar_texto character varying(800),
  convar_for character varying(50) NOT NULL,
  convar_mat character varying(50) DEFAULT ''::character varying,
  convar_orden integer,
  convar_tlg bigint NOT NULL,
  CONSTRAINT con_var_pkey PRIMARY KEY (convar_ope , convar_con , convar_var ),
  CONSTRAINT con_var_consistencias_fk FOREIGN KEY (convar_ope, convar_con)
      REFERENCES encu.consistencias (con_ope, con_con) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT con_var_formularios_fk FOREIGN KEY (convar_ope, convar_for)
      REFERENCES encu.formularios (for_ope, for_for) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT con_var_matrices_fk FOREIGN KEY (convar_ope, convar_for, convar_mat)
      REFERENCES encu.matrices (mat_ope, mat_for, mat_mat) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT con_var_operativos_fk FOREIGN KEY (convar_ope)
      REFERENCES encu.operativos (ope_ope) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT con_var_tiempo_logico_fk FOREIGN KEY (convar_tlg)
      REFERENCES encu.tiempo_logico (tlg_tlg) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT con_var_variables_fk FOREIGN KEY (convar_ope, convar_var)
      REFERENCES encu.variables (var_ope, var_var) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE encu.con_var
  OWNER TO tedede_php;

INSERT INTO encu.relaciones (rel_rel, rel_nombre, rel_tlg) VALUES ('<=>', 'sí y solo sí', 1);
INSERT INTO encu.relaciones (rel_rel, rel_nombre, rel_tlg) VALUES ('=>', 'entonces', 1);
INSERT INTO encu.relaciones (rel_rel, rel_nombre, rel_tlg) VALUES ('X', 'matar', 1);

INSERT INTO encu.consistencias(con_ope,
            con_con, con_descripcion, con_tlg)
    VALUES ('AJUS', 'enc_no_TEM','La encuesta ingresada no figura como realizada en la TEM.',1);
