INSERT INTO volver_a_cargar (vol_vol, vol_descripcion, vol_tlg) 
select vol_vol, vol_descripcion, /*CAMPOS_AUDITORIA*/ from encu_anterior.volver_a_cargar;