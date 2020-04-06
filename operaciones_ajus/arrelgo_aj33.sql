INSERT INTO encu.con_opc(
            conopc_ope, conopc_conopc, conopc_texto, conopc_tlg)
    VALUES ('AJUS','AJ33','TARJETA 7',1);

INSERT INTO encu.variables (var_ope, var_for, var_mat, var_pre, var_var, var_texto, var_aclaracion, var_conopc, var_conopc_texto, var_tipovar, var_destino, var_subordinada_var, var_subordinada_opcion, var_desp_nombre, var_expresion_habilitar, var_optativa, var_editable_por, var_orden, var_tlg) VALUES ('AJUS', 'AJI1', '', 'aj33', 'aj33', NULL, NULL, 'AJ33', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 469, 1);

INSERT INTO encu.opciones (opc_ope, opc_conopc, opc_opc, opc_texto, opc_aclaracion, opc_orden, opc_proxima_vacia, opc_proxima_opc, opc_proxima_texto, opc_tlg) VALUES ('AJUS', 'AJ33', '1', 'POR REFERENCIA DE ALGÚN VECINO O FAMILIAR', NULL, 59, NULL, NULL, NULL, 1);
INSERT INTO encu.opciones (opc_ope, opc_conopc, opc_opc, opc_texto, opc_aclaracion, opc_orden, opc_proxima_vacia, opc_proxima_opc, opc_proxima_texto, opc_tlg) VALUES ('AJUS', 'AJ33', '2', 'PORQUE ME INFORMÓ LA POLICIA', NULL, 60, NULL, NULL, NULL, 1);
INSERT INTO encu.opciones (opc_ope, opc_conopc, opc_opc, opc_texto, opc_aclaracion, opc_orden, opc_proxima_vacia, opc_proxima_opc, opc_proxima_texto, opc_tlg) VALUES ('AJUS', 'AJ33', '3', 'PORQUE EN MI BARRIO HAY UNA DEPENDENCIA JUDICIAL DE LA CIUDAD', NULL, 61, NULL, NULL, NULL, 1);
INSERT INTO encu.opciones (opc_ope, opc_conopc, opc_opc, opc_texto, opc_aclaracion, opc_orden, opc_proxima_vacia, opc_proxima_opc, opc_proxima_texto, opc_tlg) VALUES ('AJUS', 'AJ33', '4', 'A TRAVÉS DE LOS MEDIOS PERIODÍSTICOS', NULL, 62, NULL, NULL, NULL, 1);
INSERT INTO encu.opciones (opc_ope, opc_conopc, opc_opc, opc_texto, opc_aclaracion, opc_orden, opc_proxima_vacia, opc_proxima_opc, opc_proxima_texto, opc_tlg) VALUES ('AJUS', 'AJ33', '5', 'POR LA PUBLICIDAD DEL MINISTERIO PÚBLICO FISCAL DE LA CIUDAD', NULL, 63, NULL, NULL, NULL, 1);
INSERT INTO encu.opciones (opc_ope, opc_conopc, opc_opc, opc_texto, opc_aclaracion, opc_orden, opc_proxima_vacia, opc_proxima_opc, opc_proxima_texto, opc_tlg) VALUES ('AJUS', 'AJ33', '6', 'POR LA PUBLICIDAD DEL MINISTERIO PÚBLICO DE LA DEFENSA DE LA CIUDAD', NULL, 64, NULL, NULL, NULL, 1);
INSERT INTO encu.opciones (opc_ope, opc_conopc, opc_opc, opc_texto, opc_aclaracion, opc_orden, opc_proxima_vacia, opc_proxima_opc, opc_proxima_texto, opc_tlg) VALUES ('AJUS', 'AJ33', '7', 'PORQUE ME LO INFORMARON EL CGPC U OTRO ORGANISMO DEL GOBIERNO DE LA CIUDAD', NULL, 65, NULL, NULL, NULL, 1);
INSERT INTO encu.opciones (opc_ope, opc_conopc, opc_opc, opc_texto, opc_aclaracion, opc_orden, opc_proxima_vacia, opc_proxima_opc, opc_proxima_texto, opc_tlg) VALUES ('AJUS', 'AJ33', '8', 'PORQUE ESTUVE INVOLUCRADO EN UN PROCESO JUDICIAL', NULL, 66, NULL, NULL, NULL, 1);
INSERT INTO encu.opciones (opc_ope, opc_conopc, opc_opc, opc_texto, opc_aclaracion, opc_orden, opc_proxima_vacia, opc_proxima_opc, opc_proxima_texto, opc_tlg) VALUES ('AJUS', 'AJ33', '9', 'PORQUE ME INFORMÓ UN ABOGADO PRIVADO', NULL, 67, NULL, NULL, NULL, 1);
INSERT INTO encu.opciones (opc_ope, opc_conopc, opc_opc, opc_texto, opc_aclaracion, opc_orden, opc_proxima_vacia, opc_proxima_opc, opc_proxima_texto, opc_tlg) VALUES ('AJUS', 'AJ33', '10', 'PORQUE ME INFORMÓ UNA ONG', NULL, 68, NULL, NULL, NULL, 1);
INSERT INTO encu.opciones (opc_ope, opc_conopc, opc_opc, opc_texto, opc_aclaracion, opc_orden, opc_proxima_vacia, opc_proxima_opc, opc_proxima_texto, opc_tlg) VALUES ('AJUS', 'AJ33', '11', 'POR INTERNET/RED SOCIAL', NULL, 69, NULL, NULL, NULL, 1);
INSERT INTO encu.opciones (opc_ope, opc_conopc, opc_opc, opc_texto, opc_aclaracion, opc_orden, opc_proxima_vacia, opc_proxima_opc, opc_proxima_texto, opc_tlg) VALUES ('AJUS', 'AJ33', '12', 'PORQUE PARTICIPO EN UNA AGRUPACION VECINAL Y/O SOCIAL', NULL, 70, NULL, NULL, NULL, 1);
INSERT INTO encu.opciones (opc_ope, opc_conopc, opc_opc, opc_texto, opc_aclaracion, opc_orden, opc_proxima_vacia, opc_proxima_opc, opc_proxima_texto, opc_tlg) VALUES ('AJUS', 'AJ33', '13', 'POR LA ESCUELA', NULL, 71, NULL, NULL, NULL, 1);
INSERT INTO encu.opciones (opc_ope, opc_conopc, opc_opc, opc_texto, opc_aclaracion, opc_orden, opc_proxima_vacia, opc_proxima_opc, opc_proxima_texto, opc_tlg) VALUES ('AJUS', 'AJ33', '14', 'NO RECUERDA', NULL, 72, NULL, NULL, NULL, 1);

-- cuando hacíamos esto a mano comprobamos que estaban los registros con: 
select * from encu.respuestas where res_var='aj33';

-- me guardo los datos antes de cambiar la estructura de la tabla plana:
create table encu.tmp_plana_aji1_ as select * from encu.plana_aji1_;

DROP TABLE encu.plana_aji1_;

CREATE TABLE encu.plana_aji1_
(
  pla_enc integer NOT NULL,
  pla_hog integer NOT NULL,
  pla_mie integer NOT NULL,
  pla_pr1 integer,
  pla_pr2 text,
  pla_t1 integer,
  pla_t2 integer,
  pla_t3 integer,
  pla_t4 integer,
  pla_t9 integer,
  pla_t10 integer,
  pla_t11 integer,
  pla_t11_esp text,
  pla_t44 integer,
  pla_t51 integer,
  pla_t46 integer,
  pla_aj1_1 integer,
  pla_aj1_1_cual text,
  pla_aj1_2 integer,
  pla_aj1_2_cual text,
  pla_aj1_3 integer,
  pla_aj1_3_cual text,
  pla_aj1_4 integer,
  pla_aj1_4_cual text,
  pla_aj1_5 integer,
  pla_aj1_5_cual text,
  pla_aj1_6 integer,
  pla_aj1_6_cual text,
  pla_aj1_7 integer,
  pla_aj1_7_cual text,
  pla_aj1_8 integer,
  pla_aj1_8_cual text,
  pla_aj1_9 integer,
  pla_aj1_9_cual text,
  pla_aj1_10 integer,
  pla_aj1_10_cual text,
  pla_aj2 integer,
  pla_aj3 integer,
  pla_aj4_1 text,
  pla_aj4_2 text,
  pla_aj4_3 text,
  pla_aj4_4 text,
  pla_aj4_5 text,
  pla_aj4_6 text,
  pla_aj4_7 text,
  pla_aj4_8 text,
  pla_aj4_9 text,
  pla_aj4_10 text,
  pla_aj4_11 text,
  pla_aj4_12 text,
  pla_aj4_99 text,
  pla_aj4_a integer,
  pla_aj5_1 text,
  pla_aj5_2 text,
  pla_aj5_3 text,
  pla_aj5_4 text,
  pla_aj5_5 text,
  pla_aj5_6 text,
  pla_aj5_7 text,
  pla_aj5_8 text,
  pla_aj5_9 text,
  pla_aj5_99 text,
  pla_aj5_a integer,
  pla_aj6_1_1 text,
  pla_aj6_1_2 text,
  pla_aj6_1_3 text,
  pla_aj6_1_4 text,
  pla_aj6_1_5 text,
  pla_aj6_1_6 text,
  pla_aj6_1_7 text,
  pla_aj6_1_8 text,
  pla_aj6_1_9 text,
  pla_aj6_1_9_otro text,
  pla_aj6_2_1 text,
  pla_aj6_2_2 text,
  pla_aj6_2_3 text,
  pla_aj6_2_4 text,
  pla_aj6_2_5 text,
  pla_aj6_2_6 text,
  pla_aj6_2_7 text,
  pla_aj6_2_8 text,
  pla_aj6_2_9 text,
  pla_aj6_2_9_otro text,
  pla_aj6_3_1 text,
  pla_aj6_3_2 text,
  pla_aj6_3_3 text,
  pla_aj6_3_4 text,
  pla_aj6_3_5 text,
  pla_aj6_3_6 text,
  pla_aj6_3_7 text,
  pla_aj6_3_8 text,
  pla_aj6_3_9 text,
  pla_aj6_3_9_otro text,
  pla_aj6_4_1 text,
  pla_aj6_4_2 text,
  pla_aj6_4_3 text,
  pla_aj6_4_4 text,
  pla_aj6_4_5 text,
  pla_aj6_4_6 text,
  pla_aj6_4_7 text,
  pla_aj6_4_8 text,
  pla_aj6_4_9 text,
  pla_aj6_4_9_otro text,
  pla_aj6_5_1 text,
  pla_aj6_5_2 text,
  pla_aj6_5_3 text,
  pla_aj6_5_4 text,
  pla_aj6_5_5 text,
  pla_aj6_5_6 text,
  pla_aj6_5_7 text,
  pla_aj6_5_8 text,
  pla_aj6_5_9 text,
  pla_aj6_5_9_otro text,
  pla_aj6_6_1 text,
  pla_aj6_6_2 text,
  pla_aj6_6_3 text,
  pla_aj6_6_4 text,
  pla_aj6_6_5 text,
  pla_aj6_6_6 text,
  pla_aj6_6_7 text,
  pla_aj6_6_8 text,
  pla_aj6_6_9 text,
  pla_aj6_6_9_otro text,
  pla_aj6_7_1 text,
  pla_aj6_7_2 text,
  pla_aj6_7_3 text,
  pla_aj6_7_4 text,
  pla_aj6_7_5 text,
  pla_aj6_7_6 text,
  pla_aj6_7_7 text,
  pla_aj6_7_8 text,
  pla_aj6_7_9 text,
  pla_aj6_7_9_otro text,
  pla_aj6_8_1 text,
  pla_aj6_8_2 text,
  pla_aj6_8_3 text,
  pla_aj6_8_4 text,
  pla_aj6_8_5 text,
  pla_aj6_8_6 text,
  pla_aj6_8_7 text,
  pla_aj6_8_8 text,
  pla_aj6_8_9 text,
  pla_aj6_8_9_otro text,
  pla_aj7_1 integer,
  pla_aj7_2 integer,
  pla_aj7_3 integer,
  pla_aj8 integer,
  pla_aj9 integer,
  pla_aj10 integer,
  pla_aj11 integer,
  pla_aj12_1 integer,
  pla_aj12_2 integer,
  pla_aj12_3 integer,
  pla_aj12_4 integer,
  pla_aj13_1 integer,
  pla_aj13_2 integer,
  pla_aj13_3 integer,
  pla_aj14_1 integer,
  pla_aj14_2 integer,
  pla_aj14_3 integer,
  pla_aj14_4 integer,
  pla_aj14_5 integer,
  pla_aj14_6 integer,
  pla_aj14_7 integer,
  pla_aj14_8 integer,
  pla_aj14_otros text,
  pla_aj14_a integer,
  pla_aj15_1 integer,
  pla_aj15_2 integer,
  pla_aj15_3 integer,
  pla_aj16_1 integer,
  pla_aj16_2 integer,
  pla_aj16_3 integer,
  pla_aj16_4 integer,
  pla_aj16_5 integer,
  pla_aj16_6 integer,
  pla_aj16_otros text,
  pla_aj16_a integer,
  pla_aj17 integer,
  pla_aj18 integer,
  pla_aj19 integer,
  pla_aj20 integer,
  pla_aj20_otro text,
  pla_aj21 integer,
  pla_aj22 integer,
  pla_aj23_1 integer,
  pla_aj23_2 integer,
  pla_aj23_3 integer,
  pla_aj23_4 integer,
  pla_aj23_5 integer,
  pla_aj23_6 integer,
  pla_aj23_a integer,
  pla_aj24 integer,
  pla_aj25 integer,
  pla_aj26_1 integer,
  pla_aj26_2 integer,
  pla_aj26_3 integer,
  pla_aj26_4 integer,
  pla_aj26_5 integer,
  pla_aj26_6 integer,
  pla_aj26_7 integer,
  pla_aj26_8 integer,
  pla_aj27 integer,
  pla_aj28 integer,
  pla_aj28_1 text,
  pla_aj29_1 integer,
  pla_aj29_2 integer,
  pla_aj29_3 integer,
  pla_aj29_4 integer,
  pla_aj29_5 integer,
  pla_aj29_otro text,
  pla_aj29_a integer,
  pla_aj30 integer,
  pla_aj31 integer,
  pla_aj32 integer,
  pla_aj33 integer,
  pla_aj34_1 integer,
  pla_aj34_2 integer,
  pla_aj34_3 integer,
  pla_aj34_4 integer,
  pla_aj34_5 integer,
  pla_aj34_6 integer,
  pla_aj34_7 integer,
  pla_aj34_8 integer,
  pla_aj34_9 integer,
  pla_aj34_10 integer,
  pla_aj34_11 integer,
  pla_aj34_12 integer,
  pla_aj34_13 integer,
  pla_aj34_14 integer,
  pla_aj34_15 integer,
  pla_aj35 integer,
  pla_aj36 text,
  pla_aj37_1 integer,
  pla_aj37_2 integer,
  pla_aj37_3 integer,
  pla_aj37_4 integer,
  pla_aj38_1 integer,
  pla_aj38_2 integer,
  pla_aj38_3 integer,
  pla_tlg bigint NOT NULL,
  CONSTRAINT plana_aji1__pkey PRIMARY KEY (pla_enc , pla_hog , pla_mie ),
  CONSTRAINT plana_aji1__tiempo_logico_fk FOREIGN KEY (pla_tlg)
      REFERENCES encu.tiempo_logico (tlg_tlg) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE encu.plana_aji1_
  OWNER TO tedede_php;

INSERT INTO encu.plana_aji1_(
            pla_enc, pla_hog, pla_mie, pla_pr1, pla_pr2, pla_t1, pla_t2, 
            pla_t3, pla_t4, pla_t9, pla_t10, pla_t11, pla_t11_esp, pla_t44, 
            pla_t51, pla_t46, pla_aj1_1, pla_aj1_1_cual, pla_aj1_2, pla_aj1_2_cual, 
            pla_aj1_3, pla_aj1_3_cual, pla_aj1_4, pla_aj1_4_cual, pla_aj1_5, 
            pla_aj1_5_cual, pla_aj1_6, pla_aj1_6_cual, pla_aj1_7, pla_aj1_7_cual, 
            pla_aj1_8, pla_aj1_8_cual, pla_aj1_9, pla_aj1_9_cual, pla_aj1_10, 
            pla_aj1_10_cual, pla_aj2, pla_aj3, pla_aj4_1, pla_aj4_2, pla_aj4_3, 
            pla_aj4_4, pla_aj4_5, pla_aj4_6, pla_aj4_7, pla_aj4_8, pla_aj4_9, 
            pla_aj4_10, pla_aj4_11, pla_aj4_12, pla_aj4_99, pla_aj4_a, pla_aj5_1, 
            pla_aj5_2, pla_aj5_3, pla_aj5_4, pla_aj5_5, pla_aj5_6, pla_aj5_7, 
            pla_aj5_8, pla_aj5_9, pla_aj5_99, pla_aj5_a, pla_aj6_1_1, pla_aj6_1_2, 
            pla_aj6_1_3, pla_aj6_1_4, pla_aj6_1_5, pla_aj6_1_6, pla_aj6_1_7, 
            pla_aj6_1_8, pla_aj6_1_9, pla_aj6_1_9_otro, pla_aj6_2_1, pla_aj6_2_2, 
            pla_aj6_2_3, pla_aj6_2_4, pla_aj6_2_5, pla_aj6_2_6, pla_aj6_2_7, 
            pla_aj6_2_8, pla_aj6_2_9, pla_aj6_2_9_otro, pla_aj6_3_1, pla_aj6_3_2, 
            pla_aj6_3_3, pla_aj6_3_4, pla_aj6_3_5, pla_aj6_3_6, pla_aj6_3_7, 
            pla_aj6_3_8, pla_aj6_3_9, pla_aj6_3_9_otro, pla_aj6_4_1, pla_aj6_4_2, 
            pla_aj6_4_3, pla_aj6_4_4, pla_aj6_4_5, pla_aj6_4_6, pla_aj6_4_7, 
            pla_aj6_4_8, pla_aj6_4_9, pla_aj6_4_9_otro, pla_aj6_5_1, pla_aj6_5_2, 
            pla_aj6_5_3, pla_aj6_5_4, pla_aj6_5_5, pla_aj6_5_6, pla_aj6_5_7, 
            pla_aj6_5_8, pla_aj6_5_9, pla_aj6_5_9_otro, pla_aj6_6_1, pla_aj6_6_2, 
            pla_aj6_6_3, pla_aj6_6_4, pla_aj6_6_5, pla_aj6_6_6, pla_aj6_6_7, 
            pla_aj6_6_8, pla_aj6_6_9, pla_aj6_6_9_otro, pla_aj6_7_1, pla_aj6_7_2, 
            pla_aj6_7_3, pla_aj6_7_4, pla_aj6_7_5, pla_aj6_7_6, pla_aj6_7_7, 
            pla_aj6_7_8, pla_aj6_7_9, pla_aj6_7_9_otro, pla_aj6_8_1, pla_aj6_8_2, 
            pla_aj6_8_3, pla_aj6_8_4, pla_aj6_8_5, pla_aj6_8_6, pla_aj6_8_7, 
            pla_aj6_8_8, pla_aj6_8_9, pla_aj6_8_9_otro, pla_aj7_1, pla_aj7_2, 
            pla_aj7_3, pla_aj8, pla_aj9, pla_aj10, pla_aj11, pla_aj12_1, 
            pla_aj12_2, pla_aj12_3, pla_aj12_4, pla_aj13_1, pla_aj13_2, pla_aj13_3, 
            pla_aj14_1, pla_aj14_2, pla_aj14_3, pla_aj14_4, pla_aj14_5, pla_aj14_6, 
            pla_aj14_7, pla_aj14_8, pla_aj14_otros, pla_aj14_a, pla_aj15_1, 
            pla_aj15_2, pla_aj15_3, pla_aj16_1, pla_aj16_2, pla_aj16_3, pla_aj16_4, 
            pla_aj16_5, pla_aj16_6, pla_aj16_otros, pla_aj16_a, pla_aj17, 
            pla_aj18, pla_aj19, pla_aj20, pla_aj20_otro, pla_aj21, pla_aj22, 
            pla_aj23_1, pla_aj23_2, pla_aj23_3, pla_aj23_4, pla_aj23_5, pla_aj23_6, 
            pla_aj23_a, pla_aj24, pla_aj25, pla_aj26_1, pla_aj26_2, pla_aj26_3, 
            pla_aj26_4, pla_aj26_5, pla_aj26_6, pla_aj26_7, pla_aj26_8, pla_aj27, 
            pla_aj28, pla_aj28_1, pla_aj29_1, pla_aj29_2, pla_aj29_3, pla_aj29_4, 
            pla_aj29_5, pla_aj29_otro, pla_aj29_a, pla_aj30, pla_aj31, pla_aj32, 
            pla_aj33, pla_aj34_1, pla_aj34_2, pla_aj34_3, pla_aj34_4, pla_aj34_5, 
            pla_aj34_6, pla_aj34_7, pla_aj34_8, pla_aj34_9, pla_aj34_10, 
            pla_aj34_11, pla_aj34_12, pla_aj34_13, pla_aj34_14, pla_aj34_15, 
            pla_aj35, pla_aj36, pla_aj37_1, pla_aj37_2, pla_aj37_3, pla_aj37_4, 
            pla_aj38_1, pla_aj38_2, pla_aj38_3, pla_tlg)
    select pla_enc, pla_hog, pla_mie, pla_pr1, pla_pr2, pla_t1, pla_t2, 
            pla_t3, pla_t4, pla_t9, pla_t10, pla_t11, pla_t11_esp, pla_t44, 
            pla_t51, pla_t46, pla_aj1_1, pla_aj1_1_cual, pla_aj1_2, pla_aj1_2_cual, 
            pla_aj1_3, pla_aj1_3_cual, pla_aj1_4, pla_aj1_4_cual, pla_aj1_5, 
            pla_aj1_5_cual, pla_aj1_6, pla_aj1_6_cual, pla_aj1_7, pla_aj1_7_cual, 
            pla_aj1_8, pla_aj1_8_cual, pla_aj1_9, pla_aj1_9_cual, pla_aj1_10, 
            pla_aj1_10_cual, pla_aj2, pla_aj3, pla_aj4_1, pla_aj4_2, pla_aj4_3, 
            pla_aj4_4, pla_aj4_5, pla_aj4_6, pla_aj4_7, pla_aj4_8, pla_aj4_9, 
            pla_aj4_10, pla_aj4_11, pla_aj4_12, pla_aj4_99, pla_aj4_a, pla_aj5_1, 
            pla_aj5_2, pla_aj5_3, pla_aj5_4, pla_aj5_5, pla_aj5_6, pla_aj5_7, 
            pla_aj5_8, pla_aj5_9, pla_aj5_99, pla_aj5_a, pla_aj6_1_1, pla_aj6_1_2, 
            pla_aj6_1_3, pla_aj6_1_4, pla_aj6_1_5, pla_aj6_1_6, pla_aj6_1_7, 
            pla_aj6_1_8, pla_aj6_1_9, pla_aj6_1_9_otro, pla_aj6_2_1, pla_aj6_2_2, 
            pla_aj6_2_3, pla_aj6_2_4, pla_aj6_2_5, pla_aj6_2_6, pla_aj6_2_7, 
            pla_aj6_2_8, pla_aj6_2_9, pla_aj6_2_9_otro, pla_aj6_3_1, pla_aj6_3_2, 
            pla_aj6_3_3, pla_aj6_3_4, pla_aj6_3_5, pla_aj6_3_6, pla_aj6_3_7, 
            pla_aj6_3_8, pla_aj6_3_9, pla_aj6_3_9_otro, pla_aj6_4_1, pla_aj6_4_2, 
            pla_aj6_4_3, pla_aj6_4_4, pla_aj6_4_5, pla_aj6_4_6, pla_aj6_4_7, 
            pla_aj6_4_8, pla_aj6_4_9, pla_aj6_4_9_otro, pla_aj6_5_1, pla_aj6_5_2, 
            pla_aj6_5_3, pla_aj6_5_4, pla_aj6_5_5, pla_aj6_5_6, pla_aj6_5_7, 
            pla_aj6_5_8, pla_aj6_5_9, pla_aj6_5_9_otro, pla_aj6_6_1, pla_aj6_6_2, 
            pla_aj6_6_3, pla_aj6_6_4, pla_aj6_6_5, pla_aj6_6_6, pla_aj6_6_7, 
            pla_aj6_6_8, pla_aj6_6_9, pla_aj6_6_9_otro, pla_aj6_7_1, pla_aj6_7_2, 
            pla_aj6_7_3, pla_aj6_7_4, pla_aj6_7_5, pla_aj6_7_6, pla_aj6_7_7, 
            pla_aj6_7_8, pla_aj6_7_9, pla_aj6_7_9_otro, pla_aj6_8_1, pla_aj6_8_2, 
            pla_aj6_8_3, pla_aj6_8_4, pla_aj6_8_5, pla_aj6_8_6, pla_aj6_8_7, 
            pla_aj6_8_8, pla_aj6_8_9, pla_aj6_8_9_otro, pla_aj7_1, pla_aj7_2, 
            pla_aj7_3, pla_aj8, pla_aj9, pla_aj10, pla_aj11, pla_aj12_1, 
            pla_aj12_2, pla_aj12_3, pla_aj12_4, pla_aj13_1, pla_aj13_2, pla_aj13_3, 
            pla_aj14_1, pla_aj14_2, pla_aj14_3, pla_aj14_4, pla_aj14_5, pla_aj14_6, 
            pla_aj14_7, pla_aj14_8, pla_aj14_otros, pla_aj14_a, pla_aj15_1, 
            pla_aj15_2, pla_aj15_3, pla_aj16_1, pla_aj16_2, pla_aj16_3, pla_aj16_4, 
            pla_aj16_5, pla_aj16_6, pla_aj16_otros, pla_aj16_a, pla_aj17, 
            pla_aj18, pla_aj19, pla_aj20, pla_aj20_otro, pla_aj21, pla_aj22, 
            pla_aj23_1, pla_aj23_2, pla_aj23_3, pla_aj23_4, pla_aj23_5, pla_aj23_6, 
            pla_aj23_a, pla_aj24, pla_aj25, pla_aj26_1, pla_aj26_2, pla_aj26_3, 
            pla_aj26_4, pla_aj26_5, pla_aj26_6, pla_aj26_7, pla_aj26_8, pla_aj27, 
            pla_aj28, pla_aj28_1, pla_aj29_1, pla_aj29_2, pla_aj29_3, pla_aj29_4, 
            pla_aj29_5, pla_aj29_otro, pla_aj29_a, pla_aj30, pla_aj31, pla_aj32, 
            null as pla_aj33, pla_aj34_1, pla_aj34_2, pla_aj34_3, pla_aj34_4, pla_aj34_5, 
            pla_aj34_6, pla_aj34_7, pla_aj34_8, pla_aj34_9, pla_aj34_10, 
            pla_aj34_11, pla_aj34_12, pla_aj34_13, pla_aj34_14, pla_aj34_15, 
            pla_aj35, pla_aj36, pla_aj37_1, pla_aj37_2, pla_aj37_3, pla_aj37_4, 
            pla_aj38_1, pla_aj38_2, pla_aj38_3, pla_tlg
    from encu.tmp_plana_aji1_;

update encu.respuestas d 
  set res_valor=(
        select max(case when o.res_valor='1' then substr(o.res_var,6) else o.res_valor end)
            from encu.respuestas o 
            where o.res_ope=d.res_ope 
              and o.res_for=d.res_for 
              and o.res_mat=d.res_mat
              and o.res_enc=d.res_enc
              and o.res_hog=d.res_hog
              and o.res_mie=d.res_mie
              and o.res_var like 'aj33%'),
     res_valesp=(
        select max(o.res_valesp)
            from encu.respuestas o 
            where o.res_ope=d.res_ope 
              and o.res_for=d.res_for 
              and o.res_mat=d.res_mat
              and o.res_enc=d.res_enc
              and o.res_hog=d.res_hog
              and o.res_mie=d.res_mie
              and o.res_var like 'aj33%')
  where res_var='aj33'
    and ((
        select max(case when o.res_valor='1' then substr(o.res_var,6) else o.res_valor end)
            from encu.respuestas o 
            where o.res_ope=d.res_ope 
              and o.res_for=d.res_for 
              and o.res_mat=d.res_mat
              and o.res_enc=d.res_enc
              and o.res_hog=d.res_hog
              and o.res_mie=d.res_mie
              and o.res_var like 'aj33%') is not null or (
        select max(o.res_valesp)
            from encu.respuestas o 
            where o.res_ope=d.res_ope 
              and o.res_for=d.res_for 
              and o.res_mat=d.res_mat
              and o.res_enc=d.res_enc
              and o.res_hog=d.res_hog
              and o.res_mie=d.res_mie
              and o.res_var like 'aj33%') is not null);
              
-- vemos cómo quedó
select d.pla_enc, d.pla_hog, d.pla_aj33, 
  t.pla_aj33_1,
  t.pla_aj33_2,
  t.pla_aj33_3,
  t.pla_aj33_4,
  t.pla_aj33_5,
  t.pla_aj33_6,
  t.pla_aj33_7,
  t.pla_aj33_8,
  t.pla_aj33_9,
  t.pla_aj33_10,
  t.pla_aj33_11,
  t.pla_aj33_12,
  t.pla_aj33_13
  from encu.plana_aji1_ d inner join encu.tmp_plana_aji1_ t on t.pla_enc=d.pla_enc and t.pla_hog=d.pla_hog and d.pla_mie=t.pla_mie;
-- bien

-- veamos el ns/nc
select *
  from encu.respuestas 
  where res_valesp='//'
    and res_var like 'aj33%'
  order by res_enc, res_hog, res_var;
-- no había!

DELETE from encu.respuestas where res_var in
  ( 'aj33_1',
    'aj33_2',
    'aj33_3',
    'aj33_4',
    'aj33_5',
    'aj33_6',
    'aj33_7',
    'aj33_8',
    'aj33_9',
    'aj33_10',
    'aj33_11',
    'aj33_12',
    'aj33_13');
    
DELETE from encu.variables where var_var in
  ( 'aj33_1',
    'aj33_2',
    'aj33_3',
    'aj33_4',
    'aj33_5',
    'aj33_6',
    'aj33_7',
    'aj33_8',
    'aj33_9',
    'aj33_10',
    'aj33_11',
    'aj33_12',
    'aj33_13');
    