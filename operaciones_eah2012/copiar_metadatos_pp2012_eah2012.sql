insert into encu.operativos (ope_ope, ope_nombre, ope_ope_anterior, ope_tlg)
  values ('eah2012','Encuesta Anual de Hogares 2012','eah2011',1);
  
INSERT INTO encu.formularios(
            for_ope, for_for, for_nombre, for_es_principal, for_orden, for_tlg)
  SELECT 'eah2012' as for_ope, for_for, for_nombre, for_es_principal, for_orden, for_tlg
    FROM encu.formularios
    WHERE for_ope='pp2012';

INSERT INTO encu.ua(
            ua_ope, ua_ua, ua_prefijo_respuestas, ua_sufijo_tablas, ua_pk, 
            ua_tlg)
  SELECT 'eah2012' as ua_ope, ua_ua, ua_prefijo_respuestas, ua_sufijo_tablas, ua_pk, 
         ua_tlg
    FROM encu.ua
    WHERE ua_ope='pp2012';
            
INSERT INTO encu.matrices(
            mat_ope, mat_for, mat_mat, mat_texto, mat_ua, mat_ultimo_campo_pk, 
            mat_orden, mat_blanquear_clave_al_retroceder, mat_tlg)
  SELECT 'eah2012' as mat_ope, mat_for, mat_mat, mat_texto, mat_ua, mat_ultimo_campo_pk, 
         mat_orden, mat_blanquear_clave_al_retroceder, mat_tlg
    FROM encu.matrices
    WHERE mat_ope='pp2012';

            
INSERT INTO encu.bloques(
            blo_ope, blo_for, blo_blo, blo_mat, blo_texto, blo_incluir_mat, 
            blo_orden, blo_aclaracion, blo_tlg)
  SELECT 'eah2012' as blo_ope, blo_for, blo_blo, blo_mat, blo_texto, blo_incluir_mat, 
            blo_orden, blo_aclaracion, blo_tlg
    FROM  encu.bloques
    WHERE blo_ope='pp2012';
    
INSERT INTO encu.consistencias(
            con_ope, con_con, con_precondicion, con_rel, con_postcondicion, 
            con_activa, con_explicacion, con_expl_ok, con_estado, con_tipo, 
            con_falsos_positivos, con_importancia, con_momento, con_grupo, 
            con_descripcion, con_modulo, con_valida, con_junta, con_clausula_from, 
            con_expresion_sql, con_error_compilacion, con_ultima_variable, 
            con_orden, con_gravedad, con_version, con_rev, con_ultima_modificacion, 
            con_ignorar_nulls, con_observaciones, con_variables_contexto, 
            con_tlg)
  SELECT 'eah2012' as con_ope, con_con, con_precondicion, con_rel, con_postcondicion, 
       con_activa, con_explicacion, con_expl_ok, con_estado, con_tipo, 
       con_falsos_positivos, con_importancia, con_momento, con_grupo, 
       con_descripcion, con_modulo, con_valida, con_junta, con_clausula_from, 
       con_expresion_sql, con_error_compilacion, con_ultima_variable, 
       con_orden, con_gravedad, con_version, con_rev, con_ultima_modificacion, 
       con_ignorar_nulls, con_observaciones, con_variables_contexto, 
       con_tlg
    FROM encu.consistencias
    WHERE con_ope='pp2012'; 
    
INSERT INTO encu.filtros(
            fil_ope, fil_for, fil_mat, fil_blo, fil_fil, fil_texto, fil_expresion, 
            fil_destino, fil_orden, fil_aclaracion, fil_tlg)
  SELECT 'eah2012' as fil_ope, fil_for, fil_mat, fil_blo, fil_fil, fil_texto, fil_expresion, 
       fil_destino, fil_orden, fil_aclaracion, fil_tlg
  FROM encu.filtros
  WHERE fil_ope='pp2012';

INSERT INTO encu.con_opc(
            conopc_ope, conopc_conopc, conopc_texto, conopc_tlg)
  SELECT 'eah2012' as conopc_ope, conopc_conopc, conopc_texto, conopc_tlg
    FROM encu.con_opc
    WHERE conopc_ope='pp2012';

INSERT INTO encu.preguntas(
            pre_ope, pre_pre, pre_texto, pre_abreviado, pre_for, pre_mat, 
            pre_blo, pre_aclaracion, pre_destino, pre_desp_opc, pre_desp_nombre, 
            pre_orden, pre_tlg)
SELECT 'eah2012' as pre_ope, pre_pre, pre_texto, pre_abreviado, pre_for, pre_mat, 
       pre_blo, pre_aclaracion, pre_destino, pre_desp_opc, pre_desp_nombre, 
       pre_orden, pre_tlg
  FROM encu.preguntas
  WHERE pre_ope='pp2012';
    
INSERT INTO encu.opciones(
            opc_ope, opc_conopc, opc_opc, opc_texto, opc_aclaracion, opc_orden, 
            opc_proxima_vacia, opc_proxima_opc, opc_proxima_texto, opc_tlg)
SELECT 'eah2012' as opc_ope, opc_conopc, opc_opc, opc_texto, opc_aclaracion, opc_orden, 
       opc_proxima_vacia, opc_proxima_opc, opc_proxima_texto, opc_tlg
  FROM encu.opciones
  WHERE opc_ope='pp2012';
            
INSERT INTO encu.ano_con(
            anocon_ope, anocon_con, anocon_num, anocon_anotacion, anocon_autor, 
            anocon_tlg)
  SELECT 'eah2012' as anocon_ope, anocon_con, anocon_num, anocon_anotacion, anocon_autor, 
            anocon_tlg
    FROM encu.ano_con
    WHERE anocon_ope='pp2012';
    
INSERT INTO encu.variables(
            var_ope, var_for, var_mat, var_pre, var_var, var_texto, var_aclaracion, 
            var_conopc, var_conopc_texto, var_tipovar, var_destino, var_subordinada_var, 
            var_subordinada_opcion, var_desp_nombre, var_expresion_habilitar, 
            var_optativa, var_editable_por, var_orden, var_nsnc_atipico, 
            var_mejor_de_pregunta, var_maximo, var_minimo, var_advertencia_sup, 
            var_advertencia_inf, var_destino_nsnc, var_tlg)
  SELECT 'eah2012' as var_ope, var_for, var_mat, var_pre, var_var, var_texto, var_aclaracion, 
       var_conopc, var_conopc_texto, var_tipovar, var_destino, var_subordinada_var, 
       var_subordinada_opcion, var_desp_nombre, var_expresion_habilitar, 
       var_optativa, var_editable_por, var_orden, var_nsnc_atipico, 
       var_mejor_de_pregunta, var_maximo, var_minimo, var_advertencia_sup, 
       var_advertencia_inf, var_destino_nsnc, var_tlg
    FROM encu.variables
    WHERE var_ope='pp2012';
        
INSERT INTO encu.saltos(
            sal_ope, sal_var, sal_conopc, sal_opc, sal_destino, sal_tlg)
  SELECT 'eah2012' as sal_ope, sal_var, sal_conopc, sal_opc, sal_destino, sal_tlg
    FROM encu.saltos
    WHERE sal_ope='pp2012';
    