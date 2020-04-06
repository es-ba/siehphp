INSERT INTO encu.planillas(
            planilla_planilla, planilla_nombre, planilla_tlg)
select planilla_planilla, planilla_nombre, /*CAMPOS_AUDITORIA*/ from encu_anterior.planillas;