INSERT INTO pla_est (plaest_planilla, plaest_ope, plaest_est, plaest_tlg)
select plaest_planilla,  dbo.ope_actual(), plaest_est, /*CAMPOS_AUDITORIA*/ from encu_anterior.pla_est;