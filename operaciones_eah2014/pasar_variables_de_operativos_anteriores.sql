/*

delete from encu.variables where var_ope='etoi143';
delete from encu.preguntas where pre_ope='etoi143';
delete from encu.con_opc where conopc_ope='etoi143';

delete from encu.bloques where blo_ope='etoi143';
delete from encu.matrices where mat_ope='etoi143';
delete from encu.ua where ua_ope='etoi143';
delete from encu.formularios where for_ope='etoi143';
delete from encu.operativos where ope_ope='etoi143';

delete from encu.respuestas where res_ope='etoi143';
delete from encu.claves where cla_ope='etoi143';

*/


INSERT INTO encu.operativos(ope_ope, ope_nombre, ope_ope_anterior, ope_tlg, ope_en_campo) values('etoi143','ETOI 2014 trim 3', null, 1, false);
update encu.operativos set ope_ope_anterior='etoi143' where ope_ope='eah2014';


INSERT INTO encu.formularios(
            for_ope, for_for, for_nombre, for_es_principal, for_orden, for_tlg)
            values
            ('etoi143', 'S1' , 'S1', false, 10, 1);

/*
delete from encu.bloques where blo_ope='etoi143';
delete from encu.matrices where mat_ope='etoi143';
delete from encu.ua where ua_ope='etoi143';
*/
INSERT INTO encu.ua(
            ua_ope, ua_ua, ua_prefijo_respuestas, ua_sufijo_tablas, ua_pk, 
            ua_tlg)
  SELECT ua_ope, ua_ua, ua_prefijo_respuestas, ua_sufijo_tablas, ua_pk, 
           1
    FROM etoi143.ua         
    WHERE ua_ope ='etoi143';

INSERT INTO encu.matrices(
            mat_ope, mat_for, mat_mat, mat_texto, mat_ua, mat_ultimo_campo_pk, 
            mat_orden, mat_blanquear_clave_al_retroceder, mat_tlg)
SELECT mat_ope, mat_for, mat_mat, mat_texto, mat_ua, mat_ultimo_campo_pk, 
            mat_orden, mat_blanquear_clave_al_retroceder, 1
    FROM etoi143.matrices
    WHERE mat_for='S1'
      and mat_ope ='etoi143';


INSERT INTO encu.bloques(
            blo_ope, blo_for, blo_blo, blo_mat, blo_texto, blo_incluir_mat, 
            blo_orden, blo_aclaracion, blo_tlg)
  SELECT blo_ope, blo_for, blo_blo, blo_mat, blo_texto, blo_incluir_mat, 
            blo_orden, blo_aclaracion, 1
    FROM etoi143.bloques
   WHERE blo_for='S1'
      and blo_ope in ('etoi143');

INSERT INTO encu.preguntas(
            pre_ope, pre_pre, pre_texto, pre_abreviado, pre_for, pre_mat, 
            pre_blo, pre_aclaracion, pre_destino, pre_desp_opc, pre_desp_nombre, 
            pre_orden, pre_tlg)
  SELECT pre_ope, pre_pre, pre_texto, pre_abreviado, pre_for, pre_mat, 
            pre_blo, pre_aclaracion, pre_destino, pre_desp_opc, pre_desp_nombre, 
            pre_orden, 1
    FROM etoi143.preguntas
    WHERE pre_for='S1'
      and pre_ope in ('etoi143');

INSERT INTO encu.con_opc(
            conopc_ope, conopc_conopc, conopc_texto, conopc_despliegue, conopc_tlg)
  SELECT conopc_ope, conopc_conopc, conopc_texto, conopc_despliegue, 1
    FROM etoi143.con_opc
    WHERE conopc_ope in ('etoi143');  

INSERT INTO encu.variables(
            var_ope, var_for, var_mat, var_pre, var_var, var_texto, var_aclaracion, 
            var_conopc, var_conopc_texto, var_tipovar, var_destino, var_subordinada_var, 
            var_subordinada_opcion, var_desp_nombre, var_expresion_habilitar, 
            var_optativa, var_editable_por, var_orden, var_nsnc_atipico, 
            var_mejor_de_pregunta, var_maximo, var_minimo, var_advertencia_sup, 
            var_advertencia_inf, var_destino_nsnc, var_tlg, var_calculada)
    select 
           var_ope, var_for, var_mat, var_pre, var_var, var_texto, var_aclaracion, 
            var_conopc, var_conopc_texto, var_tipovar, var_destino, var_subordinada_var, 
            var_subordinada_opcion, var_desp_nombre, var_expresion_habilitar, 
            var_optativa, var_editable_por, var_orden, var_nsnc_atipico, 
            var_mejor_de_pregunta, var_maximo, var_minimo, var_advertencia_sup, 
            var_advertencia_inf, var_destino_nsnc, 1, var_calculada
      from etoi143.variables
      where var_for='S1'
        and var_ope in ('etoi143');



select pla_enc into etoi143.encuestas_eah_de_etoi from encu.plana_tem_ where pla_rotaci_n_etoi in (2,3);

INSERT INTO encu.claves(
            cla_ope, cla_for, cla_mat, cla_enc, cla_hog, cla_mie, cla_exm, 
            cla_aux_es_enc, cla_aux_es_hog, cla_aux_es_mie, cla_aux_es_exm, 
            cla_ultimo_coloreo_tlg, cla_tlg)
SELECT cla_ope, cla_for, cla_mat, cla_enc, cla_hog, cla_mie, cla_exm, 
       cla_aux_es_enc, cla_aux_es_hog, cla_aux_es_mie, cla_aux_es_exm, 
       cla_ultimo_coloreo_tlg, 1
  FROM etoi143.claves inner join etoi143.encuestas_eah_de_etoi on pla_enc=cla_enc
  where cla_for='S1'
        and cla_ope in ('etoi143');


delete from encu.respuestas where res_ope='etoi143';

INSERT INTO encu.respuestas(
            res_ope, res_for, res_mat, res_enc, res_hog, res_mie, res_exm, 
            res_var, res_valor, res_valesp, res_valor_con_error, res_estado, 
            res_anotaciones_marginales, res_tlg)
            select 
            res_ope, res_for, res_mat, res_enc, res_hog, res_mie, res_exm, 
            res_var, res_valor, res_valesp, res_valor_con_error, res_estado, 
            res_anotaciones_marginales, 1
            from 
            etoi143.respuestas inner join etoi143.encuestas_eah_de_etoi on pla_enc=res_enc
            where res_for='S1' and res_ope='etoi143';


--select * from encu.claves where cla_ope='etoi143'
select distinct (res_enc) from encu.respuestas where res_ope='etoi143';


 */      

