CREATE TABLE encu.tablas
(
  tab_tab character varying(50) NOT NULL,
  tab_raiz_json boolean NOT NULL DEFAULT true,
  tab_orden numeric,
  tab_prefijo_campos character varying(20),
  CONSTRAINT tablas_pkey PRIMARY KEY (tab_tab ),
  CONSTRAINT "texto invalido en tab_prefijo_campos de tabla tablas" CHECK (comun.cadena_valida(tab_prefijo_campos::text, 'codigo'::text)),
  CONSTRAINT "texto invalido en tab_tab de tabla tablas" CHECK (comun.cadena_valida(tab_tab::text, 'codigo'::text))
)
WITH (
  OIDS=FALSE
);
ALTER TABLE encu.tablas
  OWNER TO tedede_php;
GRANT ALL ON TABLE encu.tablas TO tedede_php;

/*
INSERT INTO encu.tablas(
            tab_tab, tab_prefijo_campos)
  select t.table_name, substr(c.column_name,1,strpos(c.column_name,'_'))
    from information_schema.tables t, information_schema.columns c
    where t.table_type='BASE TABLE'
      and t.table_schema='encu'
      and c.table_name=t.table_name
      and c.table_schema=t.table_schema
      and c.ordinal_position=1;
*/

INSERT INTO tablas (tab_tab, tab_raiz_json, tab_orden, tab_prefijo_campos) VALUES 
('plana_s1_p', true, NULL, 'pla_'),
('plana_s1_', true, NULL, 'pla_'),
('plana_a1_x', true, NULL, 'pla_'),
('plana_i1_', true, NULL, 'pla_'),
('plana_a1_', true, NULL, 'pla_'),
('sesiones', true, NULL, 'ses_'),
('http_user_agent', true, NULL, 'httpua_'),
('bolsas', true, NULL, 'bol_'),
('usuarios', true, NULL, 'usu_'),
('relaciones', true, NULL, 'rel_'),
('tem', true, NULL, 'tem_'),
('personal', true, NULL, 'per_'),
('inconsistencias', true, NULL, 'inc_'),
('roles', true, NULL, 'rol_'),
('estados_ingreso', true, NULL, 'esting_'),
('tiempo_logico', true, NULL, 'tlg_'),
('filtros', true, NULL, 'fil_'),
('operativos', true, NULL, 'ope_'),
('claves', true, NULL, 'cla_'),
('tablas', true, NULL, 'tab_'),
('bloques', false, NULL, 'blo_'),
('con_opc', false, NULL, 'conopc_'),
('con_var', false, NULL, 'convar_'),
('consistencias', false, NULL, 'con_'),
('formularios', false, NULL, 'for_'),
('matrices', false, NULL, 'mat_'),
('opciones', false, NULL, 'opc_'),
('preguntas', false, NULL, 'pre_'),
('respuestas', false, NULL, 'res_'),
('rol_rol', false, NULL, 'rolrol_'),
('saltos', false, NULL, 'sal_'),
('ua', false, NULL, 'ua_'),
('variables', false, NULL, 'var_');
