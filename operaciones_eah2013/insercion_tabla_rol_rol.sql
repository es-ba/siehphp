INSERT INTO encu.rol_rol(
            rolrol_principal, rolrol_delegado, rolrol_tlg)
SELECT rolrol_principal, rolrol_delegado, 1 rolrol_tlg
  FROM eah2012.rol_rol;
