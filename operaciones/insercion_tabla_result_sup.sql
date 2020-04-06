INSERT INTO result_sup (ressup_ressup, ressup_descripcion, ressup_tlg)
select ressup_ressup, ressup_descripcion,/*CAMPOS_AUDITORIA*/ from encu_anterior.result_sup;