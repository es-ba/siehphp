ALTER TABLE cvp.selprod 
  ADD COLUMN rubro character varying(50),
  ADD COLUMN proveedor character varying(250),
  ADD COLUMN cantidad character varying(50),
  ADD COLUMN observaciones character varying(250),
  ADD COLUMN especificacion character varying(250),
  ADD COLUMN valordesde double precision,
  ADD COLUMN valorhasta double precision,
  ADD COLUMN excluir character varying(250);
