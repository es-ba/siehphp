INSERT INTO est_rol (estrol_rol, estrol_ope, estrol_est, estrol_tlg) 
select estrol_rol, dbo.ope_actual(), estrol_est, /*CAMPOS_AUDITORIA*/ from encu_anterior.est_rol;