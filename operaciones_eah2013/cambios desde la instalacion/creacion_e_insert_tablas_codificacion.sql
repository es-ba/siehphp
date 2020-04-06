-- Table: encu.verificado

-- DROP TABLE encu.verificado;

CREATE TABLE encu.verificado
(
  ver_ver integer  NOT NULL,
  ver_descripcion character varying(200) NOT NULL,
  ver_tlg bigint NOT NULL,
    CONSTRAINT verificado_pkey PRIMARY KEY (ver_ver)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE encu.verificado
  OWNER TO tedede_php;
--- insercion
INSERT INTO encu.verificado(
            ver_ver, ver_descripcion, ver_tlg)
    VALUES (1, 'verificado',1),
           (2, 'registro de inquilinato no necesario',1),
           (4, 'duda',1);
--- en plana_tem_
ALTER TABLE IF EXISTS encu.plana_tem_
 ADD CONSTRAINT plana_tem__verificado_enc_fk FOREIGN KEY (pla_verificado_enc)
      REFERENCES encu.verificado (ver_ver) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE IF EXISTS encu.plana_tem_
 ADD CONSTRAINT plana_tem__verificado_recu_fk FOREIGN KEY (pla_verificado_recu)
      REFERENCES encu.verificado (ver_ver) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE IF EXISTS encu.plana_tem_
 ADD CONSTRAINT plana_tem__verificado_supe_fk FOREIGN KEY (pla_verificado_supe)
      REFERENCES encu.verificado (ver_ver) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE IF EXISTS encu.plana_tem_
 ADD CONSTRAINT plana_tem__verificado_supr_fk FOREIGN KEY (pla_verificado_supr)
      REFERENCES encu.verificado (ver_ver) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;

-- Table: encu.dispositivo

-- DROP TABLE encu.dispositivo;

CREATE TABLE encu.dispositivo
(
  dis_dis integer  NOT NULL,
  dis_descripcion character varying(50) NOT NULL,
  dis_tlg bigint NOT NULL,
    CONSTRAINT dispositivo_pkey PRIMARY KEY (dis_dis)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE encu.dispositivo
  OWNER TO tedede_php;
--- insercion
INSERT INTO encu.dispositivo(
            dis_dis, dis_descripcion, dis_tlg)
    VALUES (1, 'DM',1),
           (2, 'papel',1);
--- en plana_tem_
ALTER TABLE IF EXISTS encu.plana_tem_
 ADD CONSTRAINT plana_tem__dispositivo_enc_fk FOREIGN KEY (pla_dispositivo_enc)
      REFERENCES encu.dispositivo (dis_dis) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE IF EXISTS encu.plana_tem_
 ADD CONSTRAINT plana_tem__dispositivo_recu_fk FOREIGN KEY (pla_dispositivo_recu)
      REFERENCES encu.dispositivo (dis_dis) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;

-- Table: encu.a_ingreso

-- DROP TABLE encu.a_ingreso;

CREATE TABLE encu.a_ingreso
(
  ing_ing integer  NOT NULL,
  ing_descripcion character varying(50) NOT NULL,
  ing_tlg bigint NOT NULL,
    CONSTRAINT a_ingreso_pkey PRIMARY KEY (ing_ing)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE encu.a_ingreso
  OWNER TO tedede_php;
--- insercion
INSERT INTO encu.a_ingreso(
            ing_ing, ing_descripcion, ing_tlg)
    VALUES (0, 'apagado',1),
           (1, 'encendido',1);
--- en plana_tem_
ALTER TABLE IF EXISTS encu.plana_tem_
 ADD CONSTRAINT plana_tem__a_ingreso_enc_fk FOREIGN KEY (pla_a_ingreso_enc)
      REFERENCES encu.a_ingreso (ing_ing) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE IF EXISTS encu.plana_tem_
 ADD CONSTRAINT plana_tem__a_ingreso_recu_fk FOREIGN KEY (pla_a_ingreso_recu)
      REFERENCES encu.a_ingreso (ing_ing) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;

-- Table: encu.volver_a_cargar

-- DROP TABLE encu.volver_a_cargar;

CREATE TABLE encu.volver_a_cargar
(
  vol_vol integer  NOT NULL,
  vol_descripcion character varying(50) NOT NULL,
  vol_tlg bigint NOT NULL,
    CONSTRAINT volver_a_cargar_pkey PRIMARY KEY (vol_vol)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE encu.volver_a_cargar
  OWNER TO tedede_php;
--- insercion
INSERT INTO encu.volver_a_cargar(
            vol_vol, vol_descripcion, vol_tlg)
    VALUES (0, 'apagado',1),
           (1, 'encendido',1);
--- en plana_tem_
ALTER TABLE IF EXISTS encu.plana_tem_
 ADD CONSTRAINT plana_tem__volver_a_cargar_enc_fk FOREIGN KEY (pla_volver_a_cargar_enc)
      REFERENCES encu.volver_a_cargar (vol_vol) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE IF EXISTS encu.plana_tem_
 ADD CONSTRAINT plana_tem__volver_a_cargar_recu_fk FOREIGN KEY (pla_volver_a_cargar_recu)
      REFERENCES encu.volver_a_cargar (vol_vol) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;

