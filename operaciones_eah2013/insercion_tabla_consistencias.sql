INSERT INTO encu.consistencias(
            con_ope, con_con, con_precondicion, con_rel, con_postcondicion, 
            con_activa, con_explicacion, con_expl_ok, con_estado, con_tipo, 
            con_falsos_positivos, con_importancia, con_momento, con_grupo, 
            con_descripcion, con_modulo, con_valida, con_junta, con_clausula_from, 
            con_expresion_sql, con_error_compilacion, con_ultima_variable, 
            con_orden, con_gravedad, con_version, con_rev, con_ultima_modificacion, 
            con_ignorar_nulls, con_observaciones, con_variables_contexto, 
            con_tlg)
SELECT 'eah2013', con_con, con_precondicion, con_rel, con_postcondicion, 
       con_activa, con_explicacion, con_expl_ok, con_estado, con_tipo, 
       con_falsos_positivos, con_importancia, con_momento, con_grupo, 
       con_descripcion, con_modulo, con_valida, con_junta, con_clausula_from, 
       con_expresion_sql, con_error_compilacion, con_ultima_variable, 
       con_orden, con_gravedad, con_version, con_rev, con_ultima_modificacion, 
       con_ignorar_nulls, con_observaciones, con_variables_contexto, 
       1
FROM eah2012.consistencias where con_ope = 'eah2012';
