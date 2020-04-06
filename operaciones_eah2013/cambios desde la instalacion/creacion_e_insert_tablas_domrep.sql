CREATE TABLE encu.dominio
(
  dom_dom integer  NOT NULL,
  dom_descripcion character varying(200),
  dom_marco integer,
  dom_dias_para_fin_campo integer,
    CONSTRAINT dominio_pkey PRIMARY KEY (dom_dom)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE encu.dominio
  OWNER TO tedede_php;
--- insercion
INSERT INTO encu.dominio(
            dom_dom, dom_descripcion, dom_marco, dom_dias_para_fin_campo)
    VALUES (3,'Marco General de Domicilios',1,7 ),
           (4,'IHPCT'                      ,2,10),
           (5,'Villas'                     ,3,1 );

CREATE TABLE encu.replica
(
  rep_rep integer  NOT NULL,
  rep_dominio integer,
    CONSTRAINT replica_pkey PRIMARY KEY (rep_rep)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE encu.replica
  OWNER TO tedede_php;
--- insercion
INSERT INTO encu.replica(
            rep_rep, rep_dominio)
   VALUES (1,3),
          (2,3),
          (3,3),
          (4,3),
          (5,3),
          (6,3),
          (7,5),
          (8,4);
