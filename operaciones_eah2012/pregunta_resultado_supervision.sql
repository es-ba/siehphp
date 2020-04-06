--tabla preguntas
INSERT INTO encu.preguntas(
            pre_ope, pre_pre, pre_texto, pre_abreviado, pre_for, pre_mat, 
            pre_blo, pre_aclaracion, pre_destino, pre_desp_opc, pre_desp_nombre, 
            pre_orden, pre_tlg)
    VALUES ('pp2012', 'RESULTADO_SUPERVISION', null, null, 'TEM', '', 
            '5', null, null, 'vertical', null, 
            553, 1);

--select * from  encu.preguntas where pre_ope='pp2012' and pre_for='TEM' order by pre_orden

-------------tabla variables
--select * from  encu.variables where var_ope='pp2012' and var_for='TEM'

INSERT INTO encu.variables(
            var_ope, var_for, var_mat, var_pre, var_var, var_texto, var_aclaracion, 
            var_conopc, var_conopc_texto, var_tipovar, var_destino, var_subordinada_var, 
            var_subordinada_opcion, var_desp_nombre, var_expresion_habilitar, 
            var_optativa, var_editable_por, var_orden, var_nsnc_atipico, 

            var_mejor_de_pregunta, var_maximo, var_minimo, var_advertencia_sup, 
            var_advertencia_inf, var_destino_nsnc, var_tlg)
    VALUES ('pp2012', 'TEM', '', 'RESULTADO_SUPERVISION', 'resultado_supervision', 'Resultado supervision', null, 
            null, null, 'numeros', null, null, 
            null, null, null, 
            null, null, 554, null, 
            null, null, null, null, 
            null, null, 1);

--select * from  encu.variables where var_ope='pp2012' and var_for='TEM' order by var_orden    

--agregado columna
ALTER TABLE encu.plana_tem_ ADD COLUMN pla_resultado_supervision INTEGER;
