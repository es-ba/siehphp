ALTER TABLE encu.usuarios
  ADD COLUMN usu_rol_secundario character varying(30);
ALTER TABLE encu.usuarios
  ADD CONSTRAINT usuarios_roles_secundarios_fk FOREIGN KEY (usu_rol_secundario)
      REFERENCES encu.roles (rol_rol) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE encu.usuarios
  ADD CONSTRAINT "texto invalido en usu_rol_secundario de tabla usuarios" CHECK (comun.cadena_valida(usu_rol_secundario::text, 'codigo'::text));