INSERT INTO verificado (ver_ver, ver_descripcion, ver_tlg) 
select ver_ver, ver_descripcion, /*CAMPOS_AUDITORIA*/ from encu_anterior.verificado;