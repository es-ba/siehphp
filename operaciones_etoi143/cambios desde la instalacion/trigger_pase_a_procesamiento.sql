----- Primero crear las tablas planas en his:

CREATE TABLE his.plana_a1_
(
  momento timestamp,
  pla_enc integer NOT NULL,
  pla_hog integer NOT NULL,
  pla_mie integer NOT NULL,
  pla_exm integer NOT NULL,
  pla_v2_esp text,
  pla_v2 integer,
  pla_v4 integer,
  pla_v5 integer,
  pla_v5_esp text,
  pla_v6 integer,
  pla_v7 integer,
  pla_v12 integer,
  pla_h1 integer,
  pla_h2 integer,
  pla_h2_esp text,
  pla_h3 integer,
  pla_h20_1 integer,
  pla_h20_2 integer,
  pla_h20_17 integer,
  pla_h20_18 integer,
  pla_h20_5 integer,
  pla_h20_6 integer,
  pla_h20_7 integer,
  pla_h20_15 integer,
  pla_h20_8 integer,
  pla_h20_19 integer,
  pla_h20_12 integer,
  pla_h20_11 integer,
  pla_h20_14 integer,
  pla_h20_esp text,
  pla_h21 integer,
  pla_h21_bis integer,
  pla_x5 integer,
  pla_x5_tot integer,
  pla_tlg bigint NOT NULL
);
ALTER TABLE his.plana_a1_
  OWNER TO tedede_php;

CREATE TABLE his.plana_a1_x
(
  momento timestamp,
  pla_enc integer NOT NULL,
  pla_hog integer NOT NULL,
  pla_mie integer NOT NULL,
  pla_exm integer NOT NULL,
  pla_sexo_ex integer,
  pla_pais_nac integer,
  pla_edad_ex integer,
  pla_niv_educ integer,
  pla_anio integer,
  pla_lugar_esp3 text,
  pla_lugar_esp1 text,
  pla_lugar integer,
  pla_tlg bigint NOT NULL
);
ALTER TABLE his.plana_a1_x
  OWNER TO tedede_php;

CREATE TABLE his.plana_i1_
(
  momento timestamp,
  pla_enc integer NOT NULL,
  pla_hog integer NOT NULL,
  pla_mie integer NOT NULL,
  pla_exm integer NOT NULL,
  pla_obs text,
  pla_respondi integer,
  pla_t1 integer,
  pla_t2 integer,
  pla_t3 integer,
  pla_t4 integer,
  pla_t5 integer,
  pla_t6 integer,
  pla_t7 integer,
  pla_t8 integer,
  pla_t8_otro text,
  pla_t9 integer,
  pla_t10 integer,
  pla_t11 integer,
  pla_t11_otro text,
  pla_t12 integer,
  pla_t13 integer,
  pla_t14 integer,
  pla_t15 integer,
  pla_t16 integer,
  pla_t17 integer,
  pla_t18 integer,
  pla_t19_anio integer,
  pla_t20 integer,
  pla_t21 integer,
  pla_t22 integer,
  pla_t23 text,
  pla_t24 text,
  pla_t25 text,
  pla_t26 text,
  pla_t27 integer,
  pla_t28 integer,
  pla_t29 integer,
  pla_t29a integer,
  pla_t30 integer,
  pla_t31_d integer,
  pla_t31_l integer,
  pla_t31_ma integer,
  pla_t31_mi integer,
  pla_t31_j integer,
  pla_t31_v integer,
  pla_t31_s integer,
  pla_t32_d integer,
  pla_t32_l integer,
  pla_t32_ma integer,
  pla_t32_mi integer,
  pla_t32_j integer,
  pla_t32_v integer,
  pla_t32_s integer,
  pla_t33 integer,
  pla_t34 integer,
  pla_t35 integer,
  pla_t36b integer,
  pla_t37 text,
  pla_t37sd integer,
  pla_t38 integer,
  pla_t39 integer,
  pla_t39_barrio text,
  pla_t39_otro text,
  pla_t39_bis2 integer,
  pla_t39_bis2_esp text,
  pla_t40 integer,
  pla_t41 text,
  pla_t42 text,
  pla_t43 text,
  pla_t44 integer,
  pla_t45 integer,
  pla_t46 integer,
  pla_t47 integer,
  pla_t48 integer,
  pla_t48a integer,
  pla_t48b integer,
  pla_t48b_esp text,
  pla_t49 integer,
  pla_t50a integer,
  pla_t50b integer,
  pla_t50c integer,
  pla_t50d integer,
  pla_t50e integer,
  pla_t50f integer,
  pla_t51 integer,
  pla_t52a integer,
  pla_t52b integer,
  pla_t52c integer,
  pla_t53_ing integer,
  pla_t53_bis1 integer,
  pla_t53_bis1_sem integer,
  pla_t53_bis1_mes integer,
  pla_t53_bis2 integer,
  pla_t53c_anios integer,
  pla_t53c_meses integer,
  pla_t53c_98 integer,
  pla_t54 integer,
  pla_t54b integer,
  pla_i1 integer,
  pla_i2_totx integer,
  pla_i2_ticx integer,
  pla_i3_1 integer,
  pla_i3_1x integer,
  pla_i3_2 integer,
  pla_i3_2x integer,
  pla_i3_3 integer,
  pla_i3_3x integer,
  pla_i3_4 integer,
  pla_i3_4x integer,
  pla_i3_5 integer,
  pla_i3_5x integer,
  pla_i3_6 integer,
  pla_i3_6x integer,
  pla_i3_7 integer,
  pla_i3_7x integer,
  pla_i3_8 integer,
  pla_i3_8x integer,
  pla_i3_11 integer,
  pla_i3_11x integer,
  pla_i3_12 integer,
  pla_i3_12x integer,
  pla_i3_10 integer,
  pla_i3_10_otro text,
  pla_i3_10x integer,
  pla_i3_tot integer,
  pla_e1 integer,
  pla_e2 integer,
  pla_e3 integer,
  pla_e4 integer,
  pla_e6 integer,
  pla_e8 integer,
  pla_e12 integer,
  pla_e13 integer,
  pla_e14 integer,
  pla_m1 integer,
  pla_m1_esp2 text,
  pla_m1_esp3 text,
  pla_m1_esp4 text,
  pla_m1_anio integer,
  pla_m3 integer,
  pla_m3_anio integer,
  pla_m4 integer,
  pla_m4_esp1 text,
  pla_m4_esp2 text,
  pla_m4_esp3 text,
  pla_m5 integer,
  pla_sn1_1 integer,
  pla_sn1_1_esp text,
  pla_sn1_7 integer,
  pla_sn1_7_esp text,
  pla_sn1_2 integer,
  pla_sn1_2_esp text,
  pla_sn1_3 integer,
  pla_sn1_3_esp text,
  pla_sn1_4 integer,
  pla_sn1_4_esp text,
  pla_sn1_5 integer,
  pla_sn1_6 integer,
  pla_sn2 integer,
  pla_sn2_cant integer,
  pla_sn3 integer,
  pla_sn4 integer,
  pla_sn4_esp text,
  pla_sn5 integer,
  pla_sn5_esp text,
  pla_sn11 integer,
  pla_sn12 integer,
  pla_sn12_esp integer,
  pla_sn13 integer,
  pla_sn13_otro text,
  pla_sn14 integer,
  pla_sn14_esp text,
  pla_sn15a integer,
  pla_sn15b integer,
  pla_sn15c integer,
  pla_sn15d integer,
  pla_sn15e integer,
  pla_sn15f integer,
  pla_sn15g integer,
  pla_sn15h integer,
  pla_sn15i integer,
  pla_sn15j integer,
  pla_sn15k integer,
  pla_sn15k_esp text,
  pla_sn16 integer,
  pla_s28 integer,
  pla_s29 integer,
  pla_s30 integer,
  pla_s31_anio integer,
  pla_s31_mes integer,
  pla_tlg bigint NOT NULL
);
ALTER TABLE his.plana_i1_
  OWNER TO tedede_php;

CREATE TABLE his.plana_s1_
(
  momento timestamp,
  pla_enc integer NOT NULL,
  pla_hog integer NOT NULL,
  pla_mie integer NOT NULL,
  pla_exm integer NOT NULL,
  pla_entrea integer,
  pla_respond integer,
  pla_nombrer text,
  pla_f_realiz_o text,
  pla_telefono text,
  pla_movil text,
  pla_v1 integer,
  pla_total_h integer,
  pla_total_m integer,
  pla_razon1 integer,
  pla_razon2_1 integer,
  pla_razon2_2 integer,
  pla_razon2_3 integer,
  pla_razon2_4 integer,
  pla_razon2_5 integer,
  pla_razon2_6 integer,
  pla_razon3 text,
  pla_razon2_7 integer,
  pla_razon2_8 integer,
  pla_razon2_9 integer,
  pla_s1a1_obs text,
  pla_tlg bigint NOT NULL
);
ALTER TABLE his.plana_s1_
  OWNER TO tedede_php;

CREATE TABLE his.plana_s1_p
(
  momento timestamp,
  pla_enc integer NOT NULL,
  pla_hog integer NOT NULL,
  pla_mie integer NOT NULL,
  pla_exm integer NOT NULL,
  pla_nombre text,
  pla_sexo integer,
  pla_p7 integer,
  pla_p8 integer,
  pla_f_nac_o text,
  pla_edad integer,
  pla_p4 integer,
  pla_p5 integer,
  pla_p5b integer,
  pla_p6_a integer,
  pla_p6_b integer,
  pla_tlg bigint NOT NULL
);
ALTER TABLE his.plana_s1_p
  OWNER TO tedede_php;

--GRANT SELECT ON TABLE his.plana_s1_p TO eah2013_ro;


CREATE OR REPLACE FUNCTION encu.pase_a_procesamiento_trg()
  RETURNS trigger AS
$BODY$
DECLARE
BEGIN
  IF new.pla_estado>=70 AND old.pla_estado<70 THEN
    INSERT INTO his.plana_a1_  SELECT current_timestamp, * FROM encu.plana_a1_  WHERE pla_enc=new.pla_enc;
    INSERT INTO his.plana_a1_x SELECT current_timestamp, * FROM encu.plana_a1_x WHERE pla_enc=new.pla_enc;
    INSERT INTO his.plana_i1_  SELECT current_timestamp, * FROM encu.plana_i1_  WHERE pla_enc=new.pla_enc;
    INSERT INTO his.plana_s1_  SELECT current_timestamp, * FROM encu.plana_s1_  WHERE pla_enc=new.pla_enc;
    INSERT INTO his.plana_s1_p SELECT current_timestamp, * FROM encu.plana_s1_p  WHERE pla_enc=new.pla_enc;
  END IF;
  RETURN new;
END
$BODY$
  LANGUAGE plpgsql;
ALTER FUNCTION encu.pase_a_procesamiento_trg()
  OWNER TO tedede_php;  


CREATE TRIGGER pase_a_procesamiento_trg
  AFTER UPDATE
  ON encu.plana_tem_
  FOR EACH ROW
  EXECUTE PROCEDURE encu.pase_a_procesamiento_trg();