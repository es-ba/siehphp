INSERT INTO encu.con_opc (conopc_ope, conopc_conopc, conopc_texto, conopc_tlg) VALUES ('AJUS', 'marquesi', NULL, 1);

INSERT INTO encu.opciones (opc_ope, opc_conopc, opc_opc, opc_texto, opc_aclaracion, opc_orden, opc_proxima_vacia, opc_proxima_opc, opc_proxima_texto, opc_tlg) VALUES ('AJUS', 'marquesi', '1', 'Sí', NULL, 0, NULL, NULL, NULL, 1);

INSERT INTO encu.bloques (blo_ope, blo_for, blo_blo, blo_mat, blo_texto, blo_incluir_mat, blo_tlg) VALUES ('AJUS', 'TEM', 't_ing', '', 'TAREAS DE INGRESO', NULL, 1);

INSERT INTO encu.preguntas (pre_ope, pre_pre, pre_texto, pre_abreviado, pre_for, pre_mat, pre_blo, pre_aclaracion, pre_destino, pre_desp_opc, pre_desp_nombre, pre_orden, pre_tlg) VALUES ('AJUS', '21', NULL, NULL, 'TEM', '', 't_ing', NULL, NULL, 'vertical', NULL, 563, 1);
INSERT INTO encu.preguntas (pre_ope, pre_pre, pre_texto, pre_abreviado, pre_for, pre_mat, pre_blo, pre_aclaracion, pre_destino, pre_desp_opc, pre_desp_nombre, pre_orden, pre_tlg) VALUES ('AJUS', '22', NULL, NULL, 'TEM', '', 't_ing', NULL, NULL, 'vertical', NULL, 565, 1);

INSERT INTO encu.variables (var_ope, var_for, var_mat, var_pre, var_var, var_texto, var_aclaracion, var_conopc, var_conopc_texto, var_tipovar, var_destino, var_subordinada_var, var_subordinada_opcion, var_desp_nombre, var_expresion_habilitar, var_optativa, var_editable_por, var_orden, var_tlg) VALUES ('AJUS', 'TEM', '', '21', 'comenzo_ingreso', '¿Comenzó el ingreso?', NULL, 'marquesi', NULL, NULL, NULL, NULL, NULL, '', NULL, NULL, 'nadie', 564, 1);
INSERT INTO encu.variables (var_ope, var_for, var_mat, var_pre, var_var, var_texto, var_aclaracion, var_conopc, var_conopc_texto, var_tipovar, var_destino, var_subordinada_var, var_subordinada_opcion, var_desp_nombre, var_expresion_habilitar, var_optativa, var_editable_por, var_orden, var_tlg) VALUES ('AJUS', 'TEM', '', '22', 'comenzo_consistencias', '¿Se corrieron las consistencias?', NULL, 'marquesi', NULL, NULL, NULL, NULL, NULL, '', NULL, NULL, 'nadie', 566, 1);
INSERT INTO encu.variables (var_ope, var_for, var_mat, var_pre, var_var, var_texto, var_aclaracion, var_conopc, var_conopc_texto, var_tipovar, var_destino, var_subordinada_var, var_subordinada_opcion, var_desp_nombre, var_expresion_habilitar, var_optativa, var_editable_por, var_orden, var_tlg) VALUES ('AJUS', 'TEM', '', '22', 'cantidad_inconsistencias', 'Cantidad de inconsistencias', NULL, NULL, NULL, 'numeros', NULL, NULL, NULL, '', NULL, NULL, 'nadie', 567, 1);

ALTER TABLE encu.plana_tem_ ADD COLUMN pla_comenzo_ingreso integer;
ALTER TABLE encu.plana_tem_ ADD COLUMN pla_comenzo_consistencias integer;
ALTER TABLE encu.plana_tem_ ADD COLUMN pla_cantidad_inconsistencias integer;

----- 
CREATE INDEX res_var_i
   ON encu.respuestas (res_var ASC NULLS LAST);
CREATE INDEX res_enc_i
   ON encu.respuestas (res_enc ASC NULLS LAST);
   
update encu.respuestas d 
   set res_valor=1,
       res_tlg=(select min(res_tlg)
           from encu.respuestas o
           where o.res_ope=d.res_ope
             and o.res_enc=d.res_enc
             and o.res_for<>'TEM'
             and o.res_valor is not null
        )
  where res_var='comenzo_ingreso'
    and res_valor is null
    and (select max(res_valor)
           from encu.respuestas o
           where o.res_ope=d.res_ope
             and o.res_enc=d.res_enc
             and o.res_for<>'TEM'
        ) is not null
