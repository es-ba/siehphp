INSERT INTO encu.varcal(
            varcal_ope, varcal_varcal, varcal_destino, varcal_orden, varcal_nombre, 
            varcal_comentarios, varcal_tlg, varcal_activa, varcal_tipo, varcal_baseusuario, 
            varcal_nombrevar_baseusuario, varcal_tipodedato, varcal_nombre_dr, 
            varcal_nsnc_atipico, varcal_grupo, varcal_tem, varcal_valida,varcal_opciones_excluyentes,varcal_filtro,varcal_cerrado)
select dbo.ope_actual(), varcal_varcal, varcal_destino, varcal_orden, varcal_nombre, 
       varcal_comentarios, /*CAMPOS_AUDITORIA*/, varcal_activa, varcal_tipo, varcal_baseusuario, 
       varcal_nombrevar_baseusuario, varcal_tipodedato, varcal_nombre_dr, 
       varcal_nsnc_atipico, varcal_grupo, varcal_tem, varcal_valida,varcal_opciones_excluyentes,varcal_filtro,varcal_cerrado from encu_anterior.varcal;
	   
	   
	   