
--
-- PostgreSQL database dump
--

-- Dumped from database version 9.3.5
-- Dumped by pg_dump version 9.3.5
-- Started on 2015-02-11 11:45:02

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 14 (class 2615 OID 34042)
-- Name: his; Type: SCHEMA; Schema: -; Owner: tedede_owner
--

CREATE SCHEMA his;
GRANT ALL ON SCHEMA his TO tedede_php;
GRANT ALL ON SCHEMA his TO tedede_owner;

SET search_path = his, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 270 (class 1259 OID 34958)
-- Name: his_inconsistencias; Type: TABLE; Schema: his; Owner: tedede_php; Tablespace: 
--

CREATE TABLE his_inconsistencias (
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
);


ALTER TABLE his.his_inconsistencias OWNER TO tedede_php;

--
-- TOC entry 271 (class 1259 OID 34964)
-- Name: his_respuestas; Type: TABLE; Schema: his; Owner: tedede_owner; Tablespace: 
--

CREATE TABLE his_respuestas (
    hisres_ope character varying(50) NOT NULL,
    hisres_for character varying(50) NOT NULL,
    hisres_mat character varying(50) DEFAULT ''::character varying NOT NULL,
    hisres_enc integer DEFAULT 0 NOT NULL,
    hisres_hog integer DEFAULT 0 NOT NULL,
    hisres_mie integer DEFAULT 0 NOT NULL,
    hisres_exm integer DEFAULT 0 NOT NULL,
    hisres_var character varying(50) NOT NULL,
    hisres_valor text,
    hisres_valesp character varying(50),
    hisres_valor_con_error text,
    hisres_estado text,
    hisres_anotaciones_marginales text,
    hisres_tlg bigint NOT NULL,
    hisres_operacion character varying(1)
);


ALTER TABLE his.his_respuestas OWNER TO tedede_owner;

--
-- TOC entry 272 (class 1259 OID 34975)
-- Name: modificaciones; Type: TABLE; Schema: his; Owner: tedede_owner; Tablespace: 
--

CREATE TABLE modificaciones (
    mdf_mdf integer NOT NULL,
    mdf_tabla character varying(50) NOT NULL,
    mdf_operacion character varying(1) NOT NULL,
    mdf_pk character varying(2000) NOT NULL,
    mdf_campo character varying(2000) NOT NULL,
    mdf_actual text,
    mdf_anterior text,
    mdf_tlg bigint
);
ALTER TABLE his.modificaciones OWNER TO tedede_php;

ALTER TABLE his.modificaciones OWNER TO tedede_owner;

--
-- TOC entry 273 (class 1259 OID 34981)
-- Name: modificaciones_mdf_mdf_seq; Type: SEQUENCE; Schema: his; Owner: tedede_owner
--

CREATE SEQUENCE modificaciones_mdf_mdf_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE his.modificaciones_mdf_mdf_seq OWNER TO tedede_owner;

--
-- TOC entry 2629 (class 0 OID 0)
-- Dependencies: 273
-- Name: modificaciones_mdf_mdf_seq; Type: SEQUENCE OWNED BY; Schema: his; Owner: tedede_owner
--

ALTER SEQUENCE modificaciones_mdf_mdf_seq OWNED BY modificaciones.mdf_mdf;


--
-- TOC entry 274 (class 1259 OID 34983)
-- Name: plana_a1_; Type: TABLE; Schema: his; Owner: tedede_php; Tablespace: 
--

CREATE TABLE plana_a1_ (
    momento timestamp with time zone,
    pla_enc integer,
    pla_hog integer,
    pla_mie integer,
    pla_exm integer,
    pla_v2 integer,
    pla_v2_esp text,
    pla_v4 integer,
    pla_h2 integer,
    pla_h2_esp text,
    pla_h3 integer,
    pla_tlg bigint,
    pla_telefono text,
    pla_movil text
);


ALTER TABLE his.plana_a1_ OWNER TO tedede_php;

--
-- TOC entry 275 (class 1259 OID 34989)
-- Name: plana_a1_x; Type: TABLE; Schema: his; Owner: tedede_php; Tablespace: 
--

CREATE TABLE plana_a1_x (
    momento timestamp with time zone,
    pla_enc integer,
    pla_hog integer,
    pla_mie integer,
    pla_exm integer,
    pla_v2 integer,
    pla_v2_esp text,
    pla_v4 integer,
    pla_h2 integer,
    pla_h2_esp text,
    pla_h3 integer,
    pla_tlg bigint,
    pla_telefono text,
    pla_movil text
);


ALTER TABLE his.plana_a1_x OWNER TO tedede_php;

--
-- TOC entry 276 (class 1259 OID 34995)
-- Name: plana_i1_; Type: TABLE; Schema: his; Owner: tedede_php; Tablespace: 
--

CREATE TABLE plana_i1_ (
    momento timestamp with time zone,
    pla_enc integer,
    pla_hog integer,
    pla_mie integer,
    pla_exm integer,
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
    pla_t37 text,
    pla_t37sd integer,
    pla_t38 integer,
    pla_t39 integer,
    pla_t39_barrio text,
    pla_t39_otro text,
    pla_t41 text,
    pla_t42 text,
    pla_t44 integer,
    pla_t45 integer,
    pla_t46 integer,
    pla_t47 integer,
    pla_t48 integer,
    pla_t48a integer,
    pla_t48b integer,
    pla_t48b_esp text,
    pla_t51 integer,
    pla_tsd1 integer,
    pla_tsd2_anios integer,
    pla_tsd2_meses integer,
    pla_tsd2_dias integer,
    pla_tsd3 integer,
    pla_tsd4 integer,
    pla_tsd5 integer,
    pla_i1 integer,
    pla_i4 integer,
    pla_i5 integer,
    pla_i6_1 integer,
    pla_i6_2 integer,
    pla_i6_3 integer,
    pla_i6_4 integer,
    pla_i6_5 integer,
    pla_i6_6 integer,
    pla_i6_7 integer,
    pla_i6_8 integer,
    pla_i6_9 integer,
    pla_i6_10 integer,
    pla_i7a integer,
    pla_i7b integer,
    pla_i7c integer,
    pla_i10 integer,
    pla_i11 integer,
    pla_i12 integer,
    pla_i13 integer,
    pla_i14 integer,
    pla_t53_bis1 integer,
    pla_t53_bis1_sem integer,
    pla_t53_bis1_mes integer,
    pla_t53_bis2 integer,
    pla_i17 integer,
    pla_i17a integer,
    pla_i17b integer,
    pla_i20 integer,
    pla_i20a integer,
    pla_i20b integer,
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
    pla_i3_13 integer,
    pla_i3_13x integer,
    pla_i3_81 integer,
    pla_i3_81x integer,
    pla_i3_82 integer,
    pla_i3_82x integer,
    pla_i3_11 integer,
    pla_i3_11x integer,
    pla_i3_31 integer,
    pla_i3_31x integer,
    pla_i3_12 integer,
    pla_i3_12x integer,
    pla_i3_10 integer,
    pla_i3_10x integer,
    pla_i3_10_otro text,
    pla_e2 integer,
    pla_e6 integer,
    pla_e8 integer,
    pla_e12 integer,
    pla_e13 integer,
    pla_e14 integer,
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
    pla_t23_cod integer,
    pla_t24_cod integer,
    pla_t37_cod integer,
    pla_t41_cod integer,
    pla_e4_agr integer,
    pla_edad10a integer,
    pla_zona_3_1 integer,
    pla_edad10b integer,
    pla_t_ocup integer,
    pla_t_suboc3 integer,
    pla_t_edad integer,
    pla_sc_edad integer,
    pla_t_desoc integer,
    pla_fp5_r integer,
    pla_fp5_agr integer,
    pla_t_ina integer,
    pla_cond_activ integer,
    pla_t_activ integer,
    pla_t_empleo integer,
    pla_t_desocup integer,
    pla_t_subocup integer,
    pla_v2_2_mie integer,
    pla_e_nivela integer,
    pla_e_nivelb integer,
    pla_e_nivelc integer,
    pla_e_edad integer,
    pla_e_nivel integer,
    pla_e_nivel_agr integer,
    pla_e_aesc integer,
    pla_edad_30 integer,
    pla_e_raesc integer,
    pla_s_edad integer,
    pla_sn1_1a7 integer,
    pla_sn1_99 integer,
    pla_s_tipco integer,
    pla_s_tipco3 integer,
    pla_s_tipco3r integer,
    pla_s_tipco2 integer,
    pla_tsemref integer,
    pla_t_diastra1p integer,
    pla_t_diastra2p integer,
    pla_t_diasnotr1p integer,
    pla_t_diasnotr2p integer,
    pla_t_intens integer,
    pla_t_ramocu integer,
    pla_t_ramoc2 integer,
    pla_t_categ integer,
    pla_categori integer,
    pla_t51_re integer,
    pla_t39_comu integer,
    pla_t39_zona integer,
    pla_t39_rec integer,
    pla_tipodes integer,
    pla_t_ramdes integer,
    pla_t_ramde2 integer,
    pla_t_deman integer,
    pla_f_edad integer,
    pla_f_n_hij integer,
    pla_categdes integer,
    pla_codlab integer,
    pla_codnolab integer,
    pla_coding integer,
    pla_ingtot integer,
    pla_tiene_hijo integer,
    pla_tip_paren integer,
    pla_tip_paren12 integer,
    pla_p5_2 integer,
    pla_parentes integer,
    pla_parentes2 integer,
    pla_t23_coda integer,
    pla_t37_coda integer,
    pla_t37_rec integer,
    pla_t_calocu integer,
    pla_tlg bigint,
    pla_i6_10_esp text,
    pla_t40a integer,
    pla_t40b integer,
    pla_t39_partido text,
    pla_sem_hs1p numeric,
    pla_sem_hs2p numeric,
    pla_sem_hs numeric,
    pla_i7a_nsnr integer,
    pla_i7b_nsnr integer,
    pla_i7c_nsnr integer,
    pla_i12_nsnr integer,
    pla_i13_nsnr integer,
    pla_i14_nsnr integer,
    pla_codlab_ind integer,
    pla_iopi_nsnr integer,
    pla_ingop_nsnr integer,
    pla_i3_10x_nsnr integer,
    pla_i3_11x_nsnr integer,
    pla_i3_2x_nsnr integer,
    pla_i3_1x_nsnr integer,
    pla_i3_3x_nsnr integer,
    pla_i3_4x_nsnr integer,
    pla_i3_5x_nsnr integer,
    pla_i3_6x_nsnr integer,
    pla_i3_7x_nsnr integer,
    pla_i3_81x_nsnr integer,
    pla_i3_82x_nsnr integer,
    pla_i3_31x_nsnr integer,
    pla_i3_12x_nsnr integer,
    pla_i3_13x_nsnr integer,
    pla_jubilac integer,
    pla_jerarq integer,
    pla_t51_bis integer,
    pla_grupoc integer,
    pla_codi12 integer,
    pla_codi13 integer,
    pla_codi14 integer,
    pla_ioph integer,
    pla_ioph_ctrol integer,
    pla_codioph integer,
    pla_ioph_neto integer,
    pla_ioph_net_ctrol integer,
    pla_codioph_neto integer,
    pla_codi17a integer,
    pla_codi17b integer,
    pla_codi20a integer,
    pla_codi20b integer,
    pla_categos integer,
    pla_categoa integer,
    pla_ios integer,
    pla_ios_ctrol integer,
    pla_ioa integer,
    pla_ioa_ctrol integer,
    pla_codios integer,
    pla_codioa integer,
    pla_iop_ctrol integer,
    pla_iop integer,
    pla_iopneioph integer,
    pla_codiop integer,
    pla_iop_neto integer,
    pla_iop_net_ctrol integer,
    pla_codiop_neto integer,
    pla_ctrolcateg integer,
    pla_ingnolab integer,
    pla_inglab integer,
    pla_codi3_10x integer,
    pla_codi3_1x integer,
    pla_codi3_2x integer,
    pla_codi3_3x integer,
    pla_codi3_4x integer,
    pla_codi3_5x integer,
    pla_codi3_6x integer,
    pla_codi3_7x integer,
    pla_codi3_81x integer,
    pla_codi3_82x integer,
    pla_codi3_11x integer,
    pla_codi3_12x integer,
    pla_codi3_13x integer,
    pla_codi3_31x integer,
    pla_t_suboc_d integer,
    pla_t_suboc_nd integer,
    pla_meshst53bis numeric,
    pla_semhst53bis numeric,
    pla_t_intens2 integer,
    pla_rsemhst53 integer,
    pla_rsemhst53_2 integer,
    pla_copiacomuna integer,
    pla_copiaedad integer,
    pla_t40bis integer,
    pla_mie_bu integer,
    pla_ctrol_codiop integer,
    pla_codiopnectrolc integer,
    pla_ctrol_codioph integer,
    pla_rsem_hs_op integer,
    pla_tsemrefop integer,
    pla_tsd2 numeric,
    pla_rsem_hs_os integer,
    pla_codiop_as integer,
    pla_iop_as integer,
    pla_codiop_neto_as integer,
    pla_iop_neto_as integer,
    pla_codioph_as integer,
    pla_codioph_neto_as integer,
    pla_ioph_as integer,
    pla_ioph_neto_as integer,
    pla_codiop_ind integer,
    pla_iop_ind integer,
    pla_edad_quinque integer,
    pla_iop_neto_2 integer,
    pla_iop_neto_as_2 integer,
    pla_ioph_neto_2 integer,
    pla_ioph_neto_as_2 integer,
    pla_i3_10x_2 integer,
    pla_i3_11x_2 integer,
    pla_i3_12x_2 integer,
    pla_i3_13x_2 integer,
    pla_i3_1x_2 integer,
    pla_i3_2x_2 integer,
    pla_i3_31x_2 integer,
    pla_i3_3x_2 integer,
    pla_i3_4x_2 integer,
    pla_i3_5x_2 integer,
    pla_i3_6x_2 integer,
    pla_i3_7x_2 integer,
    pla_i3_81x_2 integer,
    pla_i3_82x_2 integer,
    pla_inglab_2 integer,
    pla_ingtot_2 integer,
    pla_ioa_2 integer,
    pla_iop_2 integer,
    pla_iop_as_2 integer,
    pla_iop_ind_2 integer,
    pla_ioph_2 integer,
    pla_ioph_as_2 integer,
    pla_ios_2 integer,
    pla_ingnolab_2 integer
);


ALTER TABLE his.plana_i1_ OWNER TO tedede_php;

--
-- TOC entry 277 (class 1259 OID 35001)
-- Name: plana_s1_; Type: TABLE; Schema: his; Owner: tedede_php; Tablespace: 
--

CREATE TABLE plana_s1_ (
    momento timestamp with time zone,
    pla_enc integer,
    pla_hog integer,
    pla_mie integer,
    pla_exm integer,
    pla_entrea integer,
    pla_respond integer,
    pla_nombrer text,
    pla_f_realiz_o text,
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
    pla_qitf integer,
    pla_qipcf integer,
    pla_ditf integer,
    pla_dipcf integer,
    pla_zona_3 integer,
    pla_tot_mi integer,
    pla_pobnosd integer,
    pla_tot_mr integer,
    pla_h2_re integer,
    pla_h2_re_bu integer,
    pla_h2_2 integer,
    pla_h_hacina integer,
    pla_hacinam_2 integer,
    pla_hacinam integer,
    pla_v2_re integer,
    pla_v2_2 integer,
    pla_codi_tot integer,
    pla_itf integer,
    pla_tipho12 integer,
    pla_tipho13 integer,
    pla_tip_ho integer,
    pla_sexoj integer,
    pla_estadoj integer,
    pla_men_04_h integer,
    pla_tlg bigint,
    pla_h_perhab numeric,
    pla_ipcf numeric,
    pla_hogar_bu integer,
    pla_ipcf_2 numeric,
    pla_itf_2 integer,
    pla_v4_bu integer
);


ALTER TABLE his.plana_s1_ OWNER TO tedede_php;

--
-- TOC entry 278 (class 1259 OID 35007)
-- Name: plana_s1_p; Type: TABLE; Schema: his; Owner: tedede_php; Tablespace: 
--

CREATE TABLE plana_s1_p (
    momento timestamp with time zone,
    pla_enc integer,
    pla_hog integer,
    pla_mie integer,
    pla_exm integer,
    pla_nombre text,
    pla_sexo integer,
    pla_edad integer,
    pla_p4 integer,
    pla_p5 integer,
    pla_tlg bigint,
    pla_f_nac_a integer,
    pla_f_nac_m integer,
    pla_f_nac_d integer
);


ALTER TABLE his.plana_s1_p OWNER TO tedede_php;

--
-- TOC entry 2506 (class 2604 OID 35170)
-- Name: mdf_mdf; Type: DEFAULT; Schema: his; Owner: tedede_owner
--

ALTER TABLE ONLY modificaciones ALTER COLUMN mdf_mdf SET DEFAULT nextval('modificaciones_mdf_mdf_seq'::regclass);


--
-- TOC entry 2510 (class 2606 OID 35741)
-- Name: modificaciones_pkey; Type: CONSTRAINT; Schema: his; Owner: tedede_owner; Tablespace: 
--

ALTER TABLE ONLY modificaciones
    ADD CONSTRAINT modificaciones_pkey PRIMARY KEY (mdf_mdf);


--
-- TOC entry 2507 (class 1259 OID 35748)
-- Name: his_res_var_i; Type: INDEX; Schema: his; Owner: tedede_owner; Tablespace: 
--

CREATE INDEX his_res_var_i ON his_respuestas USING btree (hisres_var);


--
-- TOC entry 2508 (class 1259 OID 35749)
-- Name: his_respuestas_idx1; Type: INDEX; Schema: his; Owner: tedede_owner; Tablespace: 
--

CREATE INDEX his_respuestas_idx1 ON his_respuestas USING btree (hisres_ope, hisres_for, hisres_mat, hisres_var, hisres_enc, hisres_hog, hisres_mie, hisres_exm);


--
-- TOC entry 2625 (class 0 OID 0)
-- Dependencies: 14
-- Name: his; Type: ACL; Schema: -; Owner: tedede_owner
--

REVOKE ALL ON SCHEMA his FROM PUBLIC;
REVOKE ALL ON SCHEMA his FROM tedede_owner;
GRANT ALL ON SCHEMA his TO tedede_owner;
GRANT USAGE ON SCHEMA his TO tedede_php;
GRANT USAGE ON SCHEMA his TO yeah_solo_lectura_formularios;


--
-- TOC entry 2626 (class 0 OID 0)
-- Dependencies: 270
-- Name: his_inconsistencias; Type: ACL; Schema: his; Owner: tedede_php
--

REVOKE ALL ON TABLE his_inconsistencias FROM PUBLIC;
REVOKE ALL ON TABLE his_inconsistencias FROM tedede_php;
GRANT ALL ON TABLE his_inconsistencias TO tedede_php;
GRANT SELECT ON TABLE his_inconsistencias TO yeah_solo_lectura_formularios;


--
-- TOC entry 2627 (class 0 OID 0)
-- Dependencies: 271
-- Name: his_respuestas; Type: ACL; Schema: his; Owner: tedede_owner
--

REVOKE ALL ON TABLE his_respuestas FROM PUBLIC;
REVOKE ALL ON TABLE his_respuestas FROM tedede_owner;
GRANT ALL ON TABLE his_respuestas TO tedede_owner;
GRANT ALL ON TABLE his_respuestas TO tedede_php;
GRANT SELECT ON TABLE his_respuestas TO yeah_solo_lectura_formularios;


--
-- TOC entry 2628 (class 0 OID 0)
-- Dependencies: 272
-- Name: modificaciones; Type: ACL; Schema: his; Owner: tedede_owner
--

REVOKE ALL ON TABLE modificaciones FROM PUBLIC;
REVOKE ALL ON TABLE modificaciones FROM tedede_owner;
GRANT ALL ON TABLE modificaciones TO tedede_owner;
GRANT ALL ON TABLE modificaciones TO tedede_php;


--
-- TOC entry 2630 (class 0 OID 0)
-- Dependencies: 273
-- Name: modificaciones_mdf_mdf_seq; Type: ACL; Schema: his; Owner: tedede_owner
--

REVOKE ALL ON SEQUENCE modificaciones_mdf_mdf_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE modificaciones_mdf_mdf_seq FROM tedede_owner;
GRANT ALL ON SEQUENCE modificaciones_mdf_mdf_seq TO tedede_owner;
GRANT ALL ON SEQUENCE modificaciones_mdf_mdf_seq TO tedede_php;


-- Completed on 2015-02-11 11:45:03

--
-- PostgreSQL database dump complete
--

