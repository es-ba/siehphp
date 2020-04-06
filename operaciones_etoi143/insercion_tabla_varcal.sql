INSERT INTO encu.varcal(
            varcal_ope, varcal_varcal, varcal_destino, varcal_orden, varcal_nombre, 
            varcal_comentarios, varcal_tlg, varcal_activa, varcal_tipo, varcal_baseusuario, 
            varcal_nombrevar_baseusuario, varcal_tipodedato)
select dbo.ope_actual(), varcal_varcal, varcal_destino, varcal_orden, varcal_nombre, 
            varcal_comentarios, /*CAMPOS_AUDITORIA*/, varcal_activa, varcal_tipo, varcal_baseusuario, 
            varcal_nombrevar_baseusuario, varcal_tipodedato from encu_anterior.varcal;