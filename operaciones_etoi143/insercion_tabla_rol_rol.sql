INSERT INTO encu.rol_rol(
            rolrol_principal, rolrol_delegado, rolrol_tlg)
SELECT rolrol_principal, rolrol_delegado, /*CAMPOS_AUDITORIA*/ rolrol_tlg
  FROM encu_anterior.rol_rol;
