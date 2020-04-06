CREATE TABLE his.modificaciones
(
  mdf_mdf serial NOT NULL,
  mdf_tabla character varying(50) NOT NULL,
  mdf_operacion character varying(1) NOT NULL,
  mdf_pk character varying(2000) NOT NULL,
  mdf_campo character varying(2000) NOT NULL,
  mdf_actual text,
  mdf_anterior text,
  mdf_tlg bigint,
  CONSTRAINT modificaciones_pkey PRIMARY KEY (mdf_mdf )
)
WITH (
  OIDS=FALSE
);
ALTER TABLE his.modificaciones OWNER TO tedede_owner;

GRANT ALL ON his.modificaciones TO tedede_php;

CREATE TABLE his.his_respuestas
(
  hisres_ope character varying(50) NOT NULL,
  hisres_for character varying(50) NOT NULL,
  hisres_mat character varying(50) NOT NULL DEFAULT ''::character varying,
  hisres_enc integer NOT NULL DEFAULT 0,
  hisres_hog integer NOT NULL DEFAULT 0,
  hisres_mie integer NOT NULL DEFAULT 0,
  hisres_exm integer NOT NULL DEFAULT 0,
  hisres_var character varying(50) NOT NULL,
  hisres_valor text,
  hisres_valesp character varying(50),
  hisres_valor_con_error text,
  hisres_estado text,
  hisres_anotaciones_marginales text,
  hisres_tlg bigint NOT NULL,
  hisres_operacion varchar(1)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE his.his_respuestas
  OWNER TO tedede_owner;
GRANT ALL ON his.his_respuestas
  TO tedede_php;
GRANT SELECT ON TABLE his.his_respuestas 
  TO yeah_solo_lectura_formularios;

CREATE INDEX his_res_var_i
  ON his.his_respuestas
  USING btree
  (hisres_var COLLATE pg_catalog."default");
  
CREATE INDEX his_respuestas_idx1
  ON his.his_respuestas
  USING btree
  (hisres_ope COLLATE pg_catalog."default", hisres_for COLLATE pg_catalog."default", hisres_mat COLLATE pg_catalog."default", hisres_var COLLATE pg_catalog."default", hisres_enc, hisres_hog, hisres_mie, hisres_exm);
  
CREATE TABLE his.his_inconsistencias
(
  hisinc_ope text,
  hisinc_con text,
  hisinc_enc integer,
  hisinc_hog integer,
  hisinc_mie integer,
  hisinc_exm integer,
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

GRANT SELECT ON TABLE his.his_inconsistencias TO yeah_solo_lectura_formularios;