INSERT INTO dispositivo (dis_dis, dis_descripcion, dis_tlg) 
select dis_dis, dis_descripcion, /*CAMPOS_AUDITORIA*/ from encu_anterior.dispositivo;