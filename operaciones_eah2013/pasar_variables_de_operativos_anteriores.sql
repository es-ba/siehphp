/*
INSERT INTO encu.operativos(ope_ope, ope_nombre, ope_ope_anterior, ope_tlg, ope_en_campo) values('eah2012','EAH 2012', 'eah2011', 1, false);
INSERT INTO encu.operativos(ope_ope, ope_nombre, ope_ope_anterior, ope_tlg, ope_en_campo) values('eah2011','EAH 2011', 'eah2010', 1, false);

INSERT INTO encu.formularios(
            for_ope, for_for, for_nombre, for_es_principal, for_orden, for_tlg)
  SELECT ope_ope as for_ope, for_for, for_nombre, for_es_principal, for_orden, for_tlg
       FROM encu.formularios,
            encu.operativos
       WHERE for_for='S1'
         and ope_ope in ('eah2012','eah2011');

INSERT INTO encu.ua(
            ua_ope, ua_ua, ua_prefijo_respuestas, ua_sufijo_tablas, ua_pk, 
            ua_tlg)
  SELECT ope_ope as ua_ope, ua_ua, ua_prefijo_respuestas, ua_sufijo_tablas, ua_pk, 
            ua_tlg
    FROM encu.ua,
         encu.operativos
    WHERE ope_ope in ('eah2012','eah2011');

INSERT INTO encu.matrices(
            mat_ope, mat_for, mat_mat, mat_texto, mat_ua, mat_ultimo_campo_pk, 
            mat_orden, mat_blanquear_clave_al_retroceder, mat_tlg)
  SELECT ope_ope as mat_ope, mat_for, mat_mat, mat_texto, mat_ua, mat_ultimo_campo_pk, 
            mat_orden, mat_blanquear_clave_al_retroceder, mat_tlg
    FROM encu.matrices,
         encu.operativos
    WHERE mat_for='S1'
      and ope_ope in ('eah2012','eah2011');
            
INSERT INTO encu.bloques(
            blo_ope, blo_for, blo_blo, blo_mat, blo_texto, blo_incluir_mat, 
            blo_orden, blo_aclaracion, blo_tlg)
  SELECT ope_ope as blo_ope, blo_for, blo_blo, blo_mat, blo_texto, blo_incluir_mat, 
            blo_orden, blo_aclaracion, blo_tlg
    FROM encu.bloques,
         encu.operativos
    WHERE blo_for='S1'
      and ope_ope in ('eah2012','eah2011');
-- */

INSERT INTO encu.preguntas(
            pre_ope, pre_pre, pre_texto, pre_abreviado, pre_for, pre_mat, 
            pre_blo, pre_aclaracion, pre_destino, pre_desp_opc, pre_desp_nombre, 
            pre_orden, pre_tlg)
  SELECT ope_ope as pre_ope, pre_pre, pre_texto, pre_abreviado, pre_for, pre_mat, 
            pre_blo, pre_aclaracion, pre_destino, pre_desp_opc, pre_desp_nombre, 
            pre_orden, pre_tlg
    FROM encu.preguntas,
         encu.operativos
    WHERE pre_for='S1'
      and ope_ope in ('eah2012','eah2011');

INSERT INTO encu.con_opc(
            conopc_ope, conopc_conopc, conopc_texto, conopc_despliegue, conopc_tlg)
  SELECT ope_ope as conopc_ope, conopc_conopc, conopc_texto, conopc_despliegue, conopc_tlg
    FROM encu.con_opc,
         encu.operativos
    WHERE ope_ope in ('eah2012','eah2011');  

INSERT INTO encu.variables(
            var_ope, var_for, var_mat, var_pre, var_var, var_texto, var_aclaracion, 
            var_conopc, var_conopc_texto, var_tipovar, var_destino, var_subordinada_var, 
            var_subordinada_opcion, var_desp_nombre, var_expresion_habilitar, 
            var_optativa, var_editable_por, var_orden, var_nsnc_atipico, 
            var_mejor_de_pregunta, var_maximo, var_minimo, var_advertencia_sup, 
            var_advertencia_inf, var_destino_nsnc, var_tlg, var_calculada)
    select 
           ope_ope as var_ope, var_for, var_mat, var_pre, var_var, var_texto, var_aclaracion, 
            var_conopc, var_conopc_texto, var_tipovar, var_destino, var_subordinada_var, 
            var_subordinada_opcion, var_desp_nombre, var_expresion_habilitar, 
            var_optativa, var_editable_por, var_orden, var_nsnc_atipico, 
            var_mejor_de_pregunta, var_maximo, var_minimo, var_advertencia_sup, 
            var_advertencia_inf, var_destino_nsnc, var_tlg, var_calculada
      from encu.variables,
           encu.operativos 
      where var_for='S1'
        and ope_ope in ('eah2012','eah2011');

-- */      