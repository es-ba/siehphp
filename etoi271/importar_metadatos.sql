INSERT INTO encu.bloques(
            blo_ope, blo_for, blo_blo, blo_mat, blo_texto, blo_incluir_mat, 
            blo_orden, blo_aclaracion, blo_tlg)
select dbo.ope_actual(), blo_for, blo_blo, blo_mat, blo_texto, blo_incluir_mat, 
            blo_orden, blo_aclaracion, 1 from operaciones_metadatos.bloques;
/*OTRA*/            
INSERT INTO encu.con_opc(
            conopc_ope, conopc_conopc, conopc_texto, conopc_despliegue, conopc_tlg)
select dbo.ope_actual(), conopc_conopc, conopc_texto, conopc_despliegue, 1 from operaciones_metadatos.con_opc;            
/*OTRA*/     
INSERT INTO encu.filtros(
            fil_ope, fil_for, fil_mat, fil_blo, fil_fil, fil_texto, fil_expresion, 
            fil_destino, fil_orden, fil_aclaracion, fil_tlg)
select dbo.ope_actual(), fil_for, fil_mat, fil_blo, fil_fil, fil_texto, fil_expresion, 
            fil_destino, fil_orden, fil_aclaracion, 1 from operaciones_metadatos.filtros;
/*OTRA*/          
INSERT INTO encu.formularios(
            for_ope, for_for, for_nombre, for_es_principal, for_orden, for_tlg, 
            for_tarea)
select dbo.ope_actual(), for_for, for_nombre, for_es_principal, for_orden, 1,
           for_tarea from operaciones_metadatos.formularios;
/*OTRA*/ 
INSERT INTO encu.matrices(
            mat_ope, mat_for, mat_mat, mat_texto, mat_ua, mat_ultimo_campo_pk, 
            mat_orden, mat_blanquear_clave_al_retroceder, mat_tlg)
select dbo.ope_actual(), mat_for, mat_mat, mat_texto, mat_ua, mat_ultimo_campo_pk, 
            mat_orden, mat_blanquear_clave_al_retroceder, 1  from operaciones_metadatos.matrices;            

/*OTRA*/ 
INSERT INTO encu.opciones(
            opc_ope, opc_conopc, opc_opc, opc_texto, opc_aclaracion, opc_orden, 
            opc_proxima_vacia, opc_proxima_opc, opc_proxima_texto, opc_tlg)
select dbo.ope_actual(), opc_conopc, opc_opc, opc_texto, opc_aclaracion, opc_orden, 
            opc_proxima_vacia, opc_proxima_opc, opc_proxima_texto, 1 from operaciones_metadatos.opciones;
            
/*OTRA*/ 
INSERT INTO encu.preguntas(
            pre_ope, pre_pre, pre_texto, pre_abreviado, pre_for, pre_mat, 
            pre_blo, pre_aclaracion, pre_destino, pre_desp_opc, pre_desp_nombre, 
            pre_orden, pre_tlg, pre_aclaracion_superior)
select dbo.ope_actual(), pre_pre, pre_texto, pre_abreviado, pre_for, pre_mat, 
            pre_blo, pre_aclaracion, pre_destino, pre_desp_opc, pre_desp_nombre, 
            pre_orden, 1, pre_aclaracion_superior from operaciones_metadatos.preguntas;
/*OTRA*/
INSERT INTO encu.saltos(
            sal_ope, sal_var, sal_conopc, sal_opc, sal_destino, sal_tlg)
select dbo.ope_actual(), sal_var, sal_conopc, sal_opc, sal_destino, 1 from operaciones_metadatos.saltos;
/*OTRA*/
INSERT INTO encu.variables(
            var_ope, var_for, var_mat, var_pre, var_var, var_texto, var_aclaracion, 
            var_conopc, var_conopc_texto, var_tipovar, var_destino, var_subordinada_var, 
            var_subordinada_opcion, var_desp_nombre, var_expresion_habilitar, 
            var_optativa, var_editable_por, var_orden, var_nsnc_atipico, 
            var_mejor_de_pregunta, var_maximo, var_minimo, var_advertencia_sup, 
            var_advertencia_inf, var_destino_nsnc, var_calculada, var_baseusuario, 
            var_nombrevar_baseusuario, var_tlg, var_nombre_dr)
select dbo.ope_actual(), var_for, var_mat, var_pre, var_var, var_texto, var_aclaracion, 
            var_conopc, var_conopc_texto, var_tipovar, var_destino, var_subordinada_var, 
            var_subordinada_opcion, var_desp_nombre, var_expresion_habilitar, 
            var_optativa, var_editable_por, var_orden, var_nsnc_atipico, 
            var_mejor_de_pregunta, var_maximo, var_minimo, var_advertencia_sup, 
            var_advertencia_inf, var_destino_nsnc, var_calculada, var_baseusuario, 
            var_nombrevar_baseusuario, 1, var_nombre_dr from operaciones_metadatos.variables;