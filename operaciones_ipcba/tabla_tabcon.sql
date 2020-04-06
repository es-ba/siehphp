set search_path=cvp,comun,public;

CREATE TABLE cvp.tabcon
(
  tablero text NOT NULL,
  control text NOT NULL,
  orden integer,
  descripcion text,
  expresion text,
  esperado_desde_dia integer,
  esperado_hasta_dia integer,
  CONSTRAINT tabcon_pkey PRIMARY KEY (tablero, control)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE cvp.tabcon
  OWNER TO cvpowner;
  
  
insert into cvp.tabcon(tablero, control, orden, descripcion, esperado_desde_dia, esperado_hasta_dias, expresion) values
  ('principal', 'generacion', 10, 'Generación de paneles', -5, 25, $$
    select min(fechaGeneracionPanel) as desde, max(fechaGeneracionPanel) as hasta, coalesce(count(fechaGeneracionPanel),0) as hecho, 20 as total
      from relpan
      where periodo='a2013m12'
  $$), 
  ('principal', 'ingreso_C', 20, 'Ingreso de tareas de campo', 1, 33, $$
    select min(fechaIngreso) as desde, max(fechaIngreso) as hasta, count(fechaIngreso) as hecho, count(*) as total
      from relvis r inner join formularios f on r.formulario=f.formulario
      where periodo='a2013m12'
        and f.operativo='C'
  $$), 
  ('principal', 'ingreso_G', 30, 'Ingreso de tareas de gabinete', 1, 45, $$
    select min(fechaIngreso) as desde, max(fechaIngreso) as hasta, count(fechaIngreso) as hecho, count(*) as total
      from relvis r inner join formularios f on r.formulario=f.formulario
      where periodo='a2013m12'
        and f.operativo is distinct from 'C'
  $$), 
  ('principal', 'generacion', 10, 'Generación de paneles', -5, 15, $$
  $$), 
  