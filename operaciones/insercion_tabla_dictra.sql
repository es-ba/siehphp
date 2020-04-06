INSERT INTO encu.dictra(
            dictra_dic, dictra_ori, dictra_des, dictra_tlg)
select dictra_dic, dictra_ori, dictra_des, /*CAMPOS_AUDITORIA*/ from encu_anterior.dictra;
