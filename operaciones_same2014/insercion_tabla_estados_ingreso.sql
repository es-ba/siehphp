INSERT INTO encu.estados_ingreso(
            esting_estado, esting_descripcion, esting_tlg)
select esting_estado, esting_descripcion,/*CAMPOS_AUDITORIA*/ from encu_anterior.estados_ingreso;
