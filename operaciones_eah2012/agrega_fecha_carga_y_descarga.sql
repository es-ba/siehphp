
ALTER TABLE encu.plana_tem_ ADD COLUMN pla_fecha_carga character varying(255);
ALTER TABLE encu.plana_tem_ ADD COLUMN pla_fecha_descarga character varying(255);
INSERT INTO encu.preguntas(pre_ope, pre_pre, pre_for, pre_blo, pre_desp_opc, pre_orden, pre_tlg)
    VALUES ('eah2012', 'FECHA_CARGA', 'TEM', 'CARGA', 'vertical', 115, 1);
INSERT INTO encu.preguntas(pre_ope, pre_pre, pre_for, pre_blo, pre_desp_opc, pre_orden, pre_tlg)
    VALUES ('eah2012', 'FECHA_DESCARGA', 'TEM', 'RESULTADO', 'vertical', 205, 1);
INSERT INTO encu.variables(var_ope, var_for, var_pre, var_var, var_texto, var_aclaracion, var_tipovar, var_tlg)
    VALUES ('eah2012', 'TEM', 'FECHA_CARGA', 'fecha_carga', 'FECHA_CARGA', 'fecha de carga', 'fecha', 1);
INSERT INTO encu.variables(var_ope, var_for, var_pre, var_var, var_texto, var_aclaracion, var_tipovar, var_tlg)
    VALUES ('eah2012', 'TEM', 'FECHA_DESCARGA', 'fecha_descarga', 'FECHA_DESCARGA', 'fecha de descarga', 'fecha', 1);
