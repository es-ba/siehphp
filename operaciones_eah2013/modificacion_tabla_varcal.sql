alter table encu.varcal
  add column varcal_tipo character varying(50) NOT NULL DEFAULT 'normal'::character varying;

alter table encu.varcal
  add column varcal_baseusuario boolean NOT NULL DEFAULT false;
  
alter table encu.varcal
  add column varcal_nombrevar_baseusuario character varying(50);

alter table encu.varcal
  add column varcal_tipodedato character varying(50) NOT NULL DEFAULT 'entero';
  
ALTER TABLE encu.varcal
  ADD CONSTRAINT "tipo de variable calculada inválido (normal,externo)" CHECK (varcal_tipo::text in ('normal','externo'));

ALTER TABLE encu.varcal
 ADD CONSTRAINT "texto invalido en varcal_nombrevar_baseusuario de tabla varcal" CHECK (comun.cadena_valida(varcal_nombrevar_baseusuario::text, 'codigo'::text));

ALTER TABLE encu.varcal
  ADD CONSTRAINT "tipo de dato de variable calculada inválido (entero,decimal)" CHECK (varcal_tipodedato::text in ('entero','decimal')); 
 
INSERT INTO encu.varcal(
            varcal_ope, varcal_varcal, varcal_destino, varcal_orden, varcal_nombre, 
            varcal_comentarios, varcal_tlg, varcal_activa, varcal_tipo, varcal_baseusuario, 
            varcal_nombrevar_baseusuario)
VALUES ('eah2013', 't23_cod',  'mie', 1,  'Código rama de actividad para desoc cesantes', null, 1, true, 'externo', false, null),
	   ('eah2013', 't24_cod',  'mie', 1,  'Código ocupación para desoc cesantes',         null, 1, true, 'externo', false, null),
	   ('eah2013', 't37_cod',  'mie', 1,  'Código rama de actividad para ocupados',       null, 1, true, 'externo', false, null),
	   ('eah2013', 't41_cod',  'mie', 1,  'Código ocupación para ocupados',               null, 1, true, 'externo', false, null),
       ('eah2013', 'fexp',     'tem', 100,'Factor de expansión',                          null, 1, true, 'externo', false, null);

ALTER TABLE encu.plana_i1_
  ADD COLUMN pla_t23_cod integer, 
  ADD COLUMN pla_t24_cod integer,
  ADD COLUMN pla_t37_cod integer,
  ADD COLUMN pla_t41_cod integer;
  

