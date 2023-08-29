set role tedede_php;
INSERT INTO encu.usuarios(
    usu_usu, usu_rol, usu_clave, usu_activo, usu_nombre, usu_apellido, usu_blanquear_clave, usu_interno, usu_mail, usu_mail_alternativo, usu_rol_secundario, usu_tlg)
select usu_usu, usu_rol, usu_clave, usu_activo, usu_nombre, usu_apellido, usu_blanquear_clave, usu_interno, usu_mail, usu_mail_alternativo, usu_rol_secundario, 1
    from encu_anterior.usuarios
    order by usu_usu;
