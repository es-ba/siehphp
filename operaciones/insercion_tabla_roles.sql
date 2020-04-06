INSERT INTO encu.roles(
            rol_rol, rol_descripcion, rol_ver_con_hasta_nivel,rol_tlg)
SELECT rol_rol, rol_descripcion, rol_ver_con_hasta_nivel, /*CAMPOS_AUDITORIA*/ rol_tlg
  FROM encu_anterior.roles;