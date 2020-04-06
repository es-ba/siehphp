INSERT INTO encu.diccionario(
            dic_dic, dic_completo, dic_tlg)
select dic_dic, dic_completo, /*CAMPOS_AUDITORIA*/ from encu_anterior.diccionario;