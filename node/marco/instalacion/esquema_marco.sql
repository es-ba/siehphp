drop schema if exists marco cascade;
create schema marco authorization tedede_php;
grant all on schema marco to tedede_php;

CREATE TABLE marco.usuarios
(
  usu_usu character varying(30) NOT NULL,
  usu_rol character varying(30),
  usu_clave character varying(50),
  usu_activo boolean NOT NULL DEFAULT false,
  usu_nombre character varying(100),
  usu_apellido character varying(100),
  usu_blanquear_clave boolean NOT NULL DEFAULT false,
  usu_interno character varying(30),
  usu_mail character varying(200),
  usu_mail_alternativo character varying(200),
  usu_rol_secundario character varying(30),
  usu_tlg bigint NOT NULL,
  CONSTRAINT usuarios_pkey PRIMARY KEY (usu_usu),
  CONSTRAINT "texto invalido en usu_apellido de tabla usuarios" CHECK (comun.cadena_valida(usu_apellido::text, 'castellano'::text)),
  CONSTRAINT "texto invalido en usu_clave de tabla usuarios" CHECK (comun.cadena_valida(usu_clave::text, 'codigo'::text)),
  CONSTRAINT "texto invalido en usu_interno de tabla usuarios" CHECK (comun.cadena_valida(usu_interno::text, 'extendido'::text)),
  CONSTRAINT "texto invalido en usu_mail de tabla usuarios" CHECK (comun.cadena_valida(usu_mail::text, 'extendido'::text)),
  CONSTRAINT "texto invalido en usu_mail_alternativo de tabla usuarios" CHECK (comun.cadena_valida(usu_mail_alternativo::text, 'codigo'::text)),
  CONSTRAINT "texto invalido en usu_nombre de tabla usuarios" CHECK (comun.cadena_valida(usu_nombre::text, 'castellano'::text)),
  CONSTRAINT "texto invalido en usu_rol de tabla usuarios" CHECK (comun.cadena_valida(usu_rol::text, 'codigo'::text)),
  CONSTRAINT "texto invalido en usu_rol_secundario de tabla usuarios" CHECK (comun.cadena_valida(usu_rol_secundario::text, 'codigo'::text)),
  CONSTRAINT "texto invalido en usu_usu de tabla usuarios" CHECK (comun.cadena_valida(usu_usu::text, 'codigo'::text))
)
WITH (
  OIDS=FALSE
);
ALTER TABLE marco.usuarios
  OWNER TO tedede_php;

INSERT INTO marco.usuarios (usu_usu, usu_rol, usu_clave, usu_activo, usu_nombre, usu_apellido, usu_blanquear_clave, usu_interno, usu_mail, usu_mail_alternativo, usu_rol_secundario, usu_tlg) VALUES ('instalador', NULL, NULL, false, NULL, NULL, false, NULL, NULL, NULL, NULL, 1);
