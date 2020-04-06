--modificación tabla variables
alter table encu.variables
  add column var_baseusuario boolean NOT NULL DEFAULT false;
  
alter table encu.variables
  add column var_nombrevar_baseusuario character varying(50);

alter table encu.variables
  add constraint "texto invalido en var_nombrevar_baseusuario de tabla variables" CHECK (comun.cadena_valida(var_nombrevar_baseusuario::text, 'codigo'::text));

  

