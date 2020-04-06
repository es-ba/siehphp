/*
INSERT INTO encu.formularios (for_ope, for_for, for_nombre, for_es_principal, for_tlg) VALUES ('eah2011', 'TEM', 'TEM', NULL, 1);
INSERT INTO encu.matrices (mat_ope, mat_for, mat_mat, mat_texto, mat_ua, mat_ultimo_campo_pk, mat_orden, mat_blanquear_clave_al_retroceder, mat_tlg) 
                   VALUES ('eah2011', 'TEM', '', 'Principal', 'enc', 'enc', NULL, ',tra_hog:0,tra_mie:0', 1);
*/
delete from encu.saltos where sal_ope='eah2011';
delete from encu.con_var where convar_ope='eah2011';
delete from encu.variables where var_ope='eah2011';
delete from encu.consistencias where con_ope='eah2011';

delete from encu.preguntas where pre_ope='eah2011';
delete from encu.filtros where fil_ope='eah2011';

delete from encu.opciones where opc_ope='eah2011';
delete from encu.con_opc where  conopc_ope='eah2011';

--select * from encu.bloques where blo_ope='eah2011'
delete from encu.bloques where blo_ope='eah2011';
INSERT INTO encu.bloques(
            blo_ope, blo_for, blo_blo, blo_mat, blo_texto, blo_incluir_mat, 
            blo_orden, blo_tlg)
select 'eah2011', blo_for, blo_blo, blo_mat, blo_texto, blo_incluir_mat, 
            blo_orden, blo_tlg from encu.bloques where blo_ope = 'pp2012'; --and blo_for='TEM'

            
--select * from encu.filtros where fil_ope='eah2011'
INSERT INTO encu.filtros(
            fil_ope, fil_for, fil_mat, fil_blo, fil_fil, fil_texto, fil_expresion, 
            fil_destino, fil_orden, fil_tlg)
select 'eah2011', fil_for, fil_mat, fil_blo, fil_fil, fil_texto, fil_expresion, 
            fil_destino, fil_orden, fil_tlg from encu.filtros where fil_ope = 'pp2012'; --and fil_for='TEM'


--select * from encu.preguntas where pre_ope='eah2011'
--delete from encu.preguntas where pre_ope='eah2011'
INSERT INTO encu.preguntas(
            pre_ope, pre_pre, pre_texto, pre_abreviado, pre_for, pre_mat, 
            pre_blo, pre_aclaracion, pre_destino, pre_desp_opc, pre_desp_nombre, 
            pre_orden, pre_tlg)
select 'eah2011', pre_pre, pre_texto, pre_abreviado, pre_for, pre_mat, 
            pre_blo, pre_aclaracion, pre_destino, pre_desp_opc, pre_desp_nombre, 
            pre_orden, pre_tlg from encu.preguntas where pre_ope='pp2012'; --and pre_for='TEM'


----delete from encu.con_opc where  conopc_ope='eah2011'
INSERT INTO encu.con_opc(
            conopc_ope, conopc_conopc, conopc_texto, conopc_tlg)
select 'eah2011', conopc_conopc, conopc_texto, conopc_tlg from encu.con_opc where conopc_ope='pp2012';


--delete from encu.opciones where opc_ope='eah2011'
INSERT INTO encu.opciones(
            opc_ope, opc_conopc, opc_opc, opc_texto, opc_aclaracion, opc_orden, 
            opc_proxima_vacia, opc_proxima_opc, opc_proxima_texto, opc_tlg)
select 'eah2011', opc_conopc, opc_opc, opc_texto, opc_aclaracion, opc_orden, 
            opc_proxima_vacia, opc_proxima_opc, opc_proxima_texto, opc_tlg from encu.opciones where opc_ope='pp2012';


--delete from encu.variables where var_ope='eah2011'
INSERT INTO encu.variables(
            var_ope, var_for, var_mat, var_pre, var_var, var_texto, var_aclaracion, 
            var_conopc, var_conopc_texto, var_tipovar, var_destino, var_subordinada_var, 
            var_subordinada_opcion, var_desp_nombre, var_expresion_habilitar, 
            var_optativa, var_editable_por, var_orden, var_nsnc_atipico, 
            var_mejor_de_pregunta, var_maximo, var_minimo, var_advertencia_sup, 
            var_advertencia_inf, var_tlg)
select 'eah2011', var_for, var_mat, var_pre, var_var, var_texto, var_aclaracion, 
            var_conopc, var_conopc_texto, var_tipovar, var_destino, var_subordinada_var, 
            var_subordinada_opcion, var_desp_nombre, var_expresion_habilitar, 
            var_optativa, var_editable_por, var_orden, var_nsnc_atipico, 
            var_mejor_de_pregunta, var_maximo, var_minimo, var_advertencia_sup, 
            var_advertencia_inf, var_tlg from encu.variables where var_ope='pp2012' ;--and var_for='TEM'

--select * from encu.consistencias where con_ope='eah2011'

INSERT INTO encu.consistencias(
            con_ope, con_con, con_precondicion, con_rel, con_postcondicion, 
            con_activa, con_explicacion, con_expl_ok, con_estado, con_tipo, 
            con_falsos_positivos, con_importancia, con_momento, con_grupo, 
            con_descripcion, con_modulo, con_valida, con_junta, con_clausula_from, 
            con_expresion_sql, con_error_compilacion, con_ultima_variable, 
            con_orden, con_gravedad, con_version, con_rev, con_ultima_modificacion, 
            con_ignorar_nulls, con_observaciones, con_variables_contexto, 
            con_tlg)
select 'eah2011', con_con, con_precondicion, con_rel, con_postcondicion, 
            con_activa, con_explicacion, con_expl_ok, con_estado, con_tipo, 
            con_falsos_positivos, con_importancia, con_momento, con_grupo, 
            con_descripcion, con_modulo, con_valida, con_junta, con_clausula_from, 
            con_expresion_sql, con_error_compilacion, con_ultima_variable, 
            con_orden, con_gravedad, con_version, con_rev, con_ultima_modificacion, 
            con_ignorar_nulls, con_observaciones, con_variables_contexto, 
            con_tlg from encu.consistencias where con_ope = 'pp2012';

INSERT INTO encu.con_var(
            convar_ope, convar_con, convar_var, convar_texto, convar_for, 
            convar_mat, convar_orden, convar_tlg)
select 'eah2011', convar_con, convar_var, convar_texto, convar_for, 
            convar_mat, convar_orden, convar_tlg from encu.con_var where convar_ope='pp2012' ;--and convar_for='TEM'


INSERT INTO encu.saltos(
            sal_ope, sal_var, sal_conopc, sal_opc, sal_destino, sal_tlg)
select 'eah2011', sal_var, sal_conopc, sal_opc, sal_destino, sal_tlg from encu.saltos where sal_ope='pp2012';
