-- Table: encu.planillas

-- DROP TABLE encu.planillas;

CREATE TABLE encu.planillas
(
  planilla_planilla character varying(20) NOT NULL,
  planilla_nombre character varying(200),
  planilla_tlg bigint NOT NULL,
  CONSTRAINT planillas_pkey PRIMARY KEY (planilla_planilla ),
  CONSTRAINT planillas_tiempo_logico_fk FOREIGN KEY (planilla_tlg)
      REFERENCES encu.tiempo_logico (tlg_tlg) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE encu.planillas
  OWNER TO tedede_php;
  
-- Table: encu.pla_var

-- DROP TABLE encu.pla_var;

CREATE TABLE encu.pla_var
(
  plavar_planilla character varying(20) NOT NULL,
  plavar_ope character varying(50) NOT NULL,
  plavar_var character varying(50) NOT NULL,
  plavar_orden integer,
  plavar_tlg bigint NOT NULL,
  CONSTRAINT pla_var_pkey PRIMARY KEY (plavar_planilla , plavar_ope , plavar_var ),
  CONSTRAINT pla_var_operativos_fk FOREIGN KEY (plavar_ope)
      REFERENCES encu.operativos (ope_ope) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT pla_var_planillas_fk FOREIGN KEY (plavar_planilla)
      REFERENCES encu.planillas (planilla_planilla) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT pla_var_tiempo_logico_fk FOREIGN KEY (plavar_tlg)
      REFERENCES encu.tiempo_logico (tlg_tlg) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT pla_var_variables_fk FOREIGN KEY (plavar_ope, plavar_var)
      REFERENCES encu.variables (var_ope, var_var) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE encu.pla_var
  OWNER TO tedede_php;
  

-- Table: encu.estados

-- DROP TABLE encu.estados;

CREATE TABLE encu.estados
(
  est_ope character varying(50) NOT NULL,
  est_est integer NOT NULL,
  est_nombre character varying(200),
  est_criterio character varying(200),
  est_editar_encuesta boolean,
  est_tlg bigint NOT NULL,
  CONSTRAINT estados_pkey PRIMARY KEY (est_ope , est_est ),
  CONSTRAINT estados_operativos_fk FOREIGN KEY (est_ope)
      REFERENCES encu.operativos (ope_ope) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT estados_tiempo_logico_fk FOREIGN KEY (est_tlg)
      REFERENCES encu.tiempo_logico (tlg_tlg) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE encu.estados OWNER TO tedede_php;

-- Table: encu.pla_est

-- DROP TABLE encu.pla_est;

CREATE TABLE encu.pla_est
(
  plaest_planilla character varying(20) NOT NULL,
  plaest_ope character varying(50) NOT NULL,
  plaest_est integer NOT NULL,
  plaest_tlg bigint NOT NULL,
  CONSTRAINT pla_est_pkey PRIMARY KEY (plaest_planilla , plaest_ope , plaest_est ),
  CONSTRAINT pla_est_estados_fk FOREIGN KEY (plaest_ope, plaest_est)
      REFERENCES encu.estados (est_ope, est_est) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT pla_est_operativos_fk FOREIGN KEY (plaest_ope)
      REFERENCES encu.operativos (ope_ope) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT pla_est_planillas_fk FOREIGN KEY (plaest_planilla)
      REFERENCES encu.planillas (planilla_planilla) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT pla_est_tiempo_logico_fk FOREIGN KEY (plaest_tlg)
      REFERENCES encu.tiempo_logico (tlg_tlg) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE encu.pla_est
  OWNER TO tedede_php;

-- Table: encu.est_var

-- DROP TABLE encu.est_var;

CREATE TABLE encu.est_var
(
  estvar_ope character varying(50) NOT NULL,
  estvar_var character varying(50) NOT NULL,
  estvar_est integer NOT NULL,
  estvar_editable boolean,
  estvar_tlg bigint NOT NULL,
  CONSTRAINT est_var_pkey PRIMARY KEY (estvar_ope , estvar_var , estvar_est ),
  CONSTRAINT est_var_estados_fk FOREIGN KEY (estvar_ope, estvar_est)
      REFERENCES encu.estados (est_ope, est_est) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT est_var_operativos_fk FOREIGN KEY (estvar_ope)
      REFERENCES encu.operativos (ope_ope) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT est_var_tiempo_logico_fk FOREIGN KEY (estvar_tlg)
      REFERENCES encu.tiempo_logico (tlg_tlg) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT est_var_variables_fk FOREIGN KEY (estvar_ope, estvar_var)
      REFERENCES encu.variables (var_ope, var_var) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE encu.est_var
  OWNER TO tedede_php;
  
-- Table: encu.rol_pla

-- DROP TABLE encu.rol_pla;

CREATE TABLE encu.rol_pla
(
  rolpla_rol character varying(30) NOT NULL,
  rolpla_planilla character varying(20) NOT NULL,
  rolpla_tlg bigint NOT NULL,
  CONSTRAINT rol_pla_pkey PRIMARY KEY (rolpla_rol, rolpla_planilla),
  CONSTRAINT rol_pla_planillas_fk FOREIGN KEY (rolpla_planilla)
      REFERENCES encu.planillas (planilla_planilla) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT rol_pla_roles_fk FOREIGN KEY (rolpla_rol)
      REFERENCES encu.roles (rol_rol) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT rol_pla_tiempo_logico_fk FOREIGN KEY (rolpla_tlg)
      REFERENCES encu.tiempo_logico (tlg_tlg) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE encu.rol_pla OWNER TO tedede_php;

-- Table: encu.est_rol

-- DROP TABLE encu.est_rol;

CREATE TABLE encu.est_rol
(
  estrol_rol character varying(30) NOT NULL,
  estrol_ope character varying(50) NOT NULL,
  estrol_est integer NOT NULL,
  estrol_tlg bigint NOT NULL,
  CONSTRAINT est_rol_pkey PRIMARY KEY (estrol_rol , estrol_ope , estrol_est ),
  CONSTRAINT est_rol_estados_fk FOREIGN KEY (estrol_ope, estrol_est)
      REFERENCES encu.estados (est_ope, est_est) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT est_rol_operativos_fk FOREIGN KEY (estrol_ope)
      REFERENCES encu.operativos (ope_ope) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE NO ACTION,
  CONSTRAINT est_rol_roles_fk FOREIGN KEY (estrol_rol)
      REFERENCES encu.roles (rol_rol) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT est_rol_tiempo_logico_fk FOREIGN KEY (estrol_tlg)
      REFERENCES encu.tiempo_logico (tlg_tlg) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE encu.est_rol
  OWNER TO tedede_php;
