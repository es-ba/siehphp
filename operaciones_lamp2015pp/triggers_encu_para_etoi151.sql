SET search_path = encu, pg_catalog;

--
-- Name: calculo_estado_trg; Type: TRIGGER; Schema: encu; Owner: tedede_php
--

CREATE TRIGGER calculo_estado_trg AFTER UPDATE ON respuestas FOR EACH ROW EXECUTE PROCEDURE calculo_estado_trg();


--
-- Name: calculo_variables_calculadas_i1__trg; Type: TRIGGER; Schema: encu; Owner: tedede_php
--

CREATE TRIGGER calculo_variables_calculadas_i1__trg BEFORE UPDATE ON plana_i1_ FOR EACH ROW EXECUTE PROCEDURE calculo_variables_calculadas_i1__trg();


--
-- Name: calculo_variables_calculadas_s1__trg; Type: TRIGGER; Schema: encu; Owner: tedede_php
--

CREATE TRIGGER calculo_variables_calculadas_s1__trg BEFORE UPDATE ON plana_s1_ FOR EACH ROW EXECUTE PROCEDURE calculo_variables_calculadas_s1__trg();


--
-- Name: claves_campos_aux_trg; Type: TRIGGER; Schema: encu; Owner: tedede_php
--

--CREATE TRIGGER claves_campos_aux_trg BEFORE INSERT ON claves FOR EACH ROW EXECUTE PROCEDURE claves_campos_aux_trg();


--
-- Name: claves_ins_trg; Type: TRIGGER; Schema: encu; Owner: tedede_php
--

--CREATE TRIGGER claves_ins_trg AFTER INSERT ON claves FOR EACH ROW EXECUTE PROCEDURE claves_ins_trg();


--
-- Name: consistencias_upd_trg; Type: TRIGGER; Schema: encu; Owner: tedede_php
--

--CREATE TRIGGER consistencias_upd_trg BEFORE UPDATE ON consistencias FOR EACH ROW EXECUTE PROCEDURE consistencias_upd_trg();


--
-- Name: controlar_modificacion_semana_trg; Type: TRIGGER; Schema: encu; Owner: tedede_php
--

CREATE TRIGGER controlar_modificacion_semana_trg AFTER UPDATE ON plana_tem_ FOR EACH ROW EXECUTE PROCEDURE controlar_modificacion_semana_trg();


--
-- Name: disparar_calculo_estado_tem_trg; Type: TRIGGER; Schema: encu; Owner: tedede_php
--

CREATE TRIGGER disparar_calculo_estado_tem_trg AFTER UPDATE ON plana_tem_ FOR EACH ROW EXECUTE PROCEDURE disparar_calculo_estado_tem_trg();


--
-- Name: his_inconsistencias_trg; Type: TRIGGER; Schema: encu; Owner: tedede_php
--

--CREATE TRIGGER his_inconsistencias_trg BEFORE DELETE ON inconsistencias FOR EACH ROW EXECUTE PROCEDURE his_inconsistencias_trg();


--
-- Name: his_inconsistencias_upd_trg; Type: TRIGGER; Schema: encu; Owner: tedede_php
--

--CREATE TRIGGER his_inconsistencias_upd_trg BEFORE INSERT ON inconsistencias FOR EACH ROW EXECUTE PROCEDURE his_inconsistencias_upd_trg();


--
-- Name: respuestas_a_planas_trg; Type: TRIGGER; Schema: encu; Owner: tedede_php
--

--CREATE TRIGGER respuestas_a_planas_trg BEFORE UPDATE ON respuestas FOR EACH ROW EXECUTE PROCEDURE respuestas_a_planas_trg();


--
-- Name: respuestas_control_editable_trg; Type: TRIGGER; Schema: encu; Owner: tedede_php
--

CREATE TRIGGER respuestas_control_editable_trg BEFORE UPDATE ON respuestas FOR EACH ROW EXECUTE PROCEDURE respuestas_control_editable_trg();


--
-- Name: respuestas_control_justificaciones_trg; Type: TRIGGER; Schema: encu; Owner: tedede_php
--

CREATE TRIGGER respuestas_control_justificaciones_trg BEFORE UPDATE ON respuestas FOR EACH ROW EXECUTE PROCEDURE respuestas_control_justificaciones_trg();


--
-- Name: respuestas_control_pk_trg; Type: TRIGGER; Schema: encu; Owner: tedede_php
--

--CREATE TRIGGER respuestas_control_pk_trg AFTER INSERT ON respuestas FOR EACH ROW EXECUTE PROCEDURE respuestas_control_pk_trg();


--
-- Name: respuestas_sinc_tem_trg; Type: TRIGGER; Schema: encu; Owner: tedede_php
--

CREATE TRIGGER respuestas_sinc_tem_trg AFTER UPDATE ON respuestas FOR EACH ROW EXECUTE PROCEDURE respuestas_sinc_tem_trg();


--
-- Name: tabulados_controlar_modificacion_tabulados_trg; Type: TRIGGER; Schema: encu; Owner: tedede_php
--

CREATE TRIGGER tabulados_controlar_modificacion_tabulados_trg BEFORE UPDATE ON tabulados FOR EACH ROW EXECUTE PROCEDURE permitir_modificacion_tabulados_trg();


--
-- Name: varcal_controlar_modificacion_varcalopc_trg; Type: TRIGGER; Schema: encu; Owner: tedede_php
--

CREATE TRIGGER varcal_controlar_modificacion_varcalopc_trg BEFORE UPDATE ON varcal FOR EACH ROW EXECUTE PROCEDURE permitir_modificacion_variables_calculadas_trg();


--
-- Name: varcalopc_controlar_modificacion_varcalopc_trg; Type: TRIGGER; Schema: encu; Owner: tedede_php
--

CREATE TRIGGER varcalopc_controlar_modificacion_varcalopc_trg BEFORE INSERT OR DELETE OR UPDATE ON varcalopc FOR EACH ROW EXECUTE PROCEDURE permitir_modificacion_variables_calculadas_trg();


--
-- Name: variables_ins_trg; Type: TRIGGER; Schema: encu; Owner: tedede_php
--

--CREATE TRIGGER variables_ins_trg AFTER INSERT ON variables FOR EACH ROW EXECUTE PROCEDURE variables_ins_trg();

CREATE TRIGGER controlar_modificacion_semana_trg  AFTER UPDATE ON encu.plana_tem_  FOR EACH ROW  EXECUTE PROCEDURE encu.controlar_modificacion_semana_trg();
CREATE TRIGGER disparar_calculo_estado_tem_trg  AFTER UPDATE ON encu.plana_tem_  FOR EACH ROW  EXECUTE PROCEDURE encu.disparar_calculo_estado_tem_trg();
CREATE TRIGGER pase_a_procesamiento_trg  AFTER UPDATE  ON encu.plana_tem_  FOR EACH ROW  EXECUTE PROCEDURE encu.pase_a_procesamiento_trg();