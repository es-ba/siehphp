INSERT INTO encu.ocupacion(
	ocu_ocu, ocu_descripcion, ocu_tlg)
select ocu_ocu, ocu_descripcion, /*CAMPOS_AUDITORIA*/ from encu_anterior.ocupacion;