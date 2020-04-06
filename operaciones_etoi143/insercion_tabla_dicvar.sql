INSERT INTO encu.dicvar(
            dicvar_dic, dicvar_var, dicvar_tlg)
select dicvar_dic, dicvar_var, /*CAMPOS_AUDITORIA*/ from encu_anterior.dicvar;