INSERT INTO encu.roles(
            rol_rol, rol_descripcion, rol_tlg)
SELECT rol_rol, rol_descripcion, 1 rol_tlg
  FROM eah2012.roles;
