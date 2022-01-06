/* verificar que el operativo anterior tenga agregados para coor_campo y subcoor_campo los roles delegados  encuestador, supervisor y recuperador */
INSERT INTO encu.rol_rol(
            rolrol_principal, rolrol_delegado, rolrol_tlg)
SELECT rolrol_principal, rolrol_delegado, /*CAMPOS_AUDITORIA*/ rolrol_tlg
  FROM encu_anterior.rol_rol;
