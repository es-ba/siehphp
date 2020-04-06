-- UTF8=Sí
-- Table: bu.eah12_bu_viv
----
DROP SCHEMA if exists bu;
CREATE SCHEMA bu  AUTHORIZATION tedede_php;

DROP TABLE if exists bu.eah12_bu_viv;

CREATE TABLE bu.eah12_bu_viv
(
  id             integer NOT NULL,
  nhogar         integer NOT NULL,
  comuna         integer,
  dominio        integer,
  v2_2           integer,
  v4             integer,
  v12            integer,
  h1             integer,
  h2             integer,
  hacinam_2      integer,
  tipoho         integer,
  fexp           integer,
CONSTRAINT eah12_bu_viv_pk PRIMARY KEY (id, nhogar)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE bu.eah12_bu_viv
  OWNER TO tedede_php;


-- Table: bu.eah12_bu_ind

DROP TABLE if exists bu.eah12_bu_ind;  

CREATE TABLE bu.eah12_bu_ind
(
  id             integer NOT NULL,
  nhogar         integer NOT NULL,
  miembro        integer NOT NULL,
  comuna         integer,
  dominio        integer,
  edad           integer,
  sexo           integer,
  parentes_2     integer,
  p5_2           integer,
  p6_a           integer,
  p6_b           integer,
  estado         integer,
  categori       integer,
  t13            integer,
  t14            integer,
  t15            integer,
  t16            integer,
  t17            integer,
  t18            integer,
  t19_anio       integer,
  t23_cod_2      integer,
  t23_coda_2     integer,
  t24_cod_2      integer,
  t28            integer,
  t29            integer,
  t29a           integer,
  t30            integer,
  sem_hs         numeric,
  t33            integer,
  t34            integer,
  t35            integer,
  t37_cod_2      integer,
  t37_coda_2     integer,
  t38            integer,
  t40            integer,
  t41_cod_2      integer,
  t47            integer,
  t48            integer,
  t49            integer,
  t50a           integer,
  t50b           integer,
  t50c           integer,
  t50d           integer,
  t50e           integer,
  t50f           integer,
  t51            integer,
  t52a           integer,
  t52b           integer,
  t52c           integer,
  t54            integer,
  codlab         integer,
  i2_totx_2      integer,
  codnolab       integer,
  I3_tot_2       integer,
  coding         integer,
  Ingtot_2       integer,
  codi_tot       integer,
  Itfb_2         integer,
  Ipcfb_2        numeric,
  e2             integer,
  e3             integer,
  e3a            integer,
  e4             integer,
  e6             integer,
  e10            integer,
  e11a           integer,
  e12            integer,
  nivel          integer,
  aesc           integer,
  m1             integer,
  m1_2           integer,
  m2_anio        integer,
  m3_anio        integer,
  m4_2           integer,
  m4_3           integer,
  m5             integer,
  tipcob2_2      integer,
  s2             integer,
  s8             integer,
  s9_2           integer,
  s12_2          integer,
  s12a           integer,
  s28            integer,
  s29            integer,
  s30            integer,
  fexp           integer,
CONSTRAINT eah12_bu_ind_pk PRIMARY KEY (id, nhogar, miembro)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE bu.eah12_bu_ind
  OWNER TO tedede_php;
ALTER TABLE bu.eah12_bu_ind ADD CONSTRAINT eah12_bu_viv_eah12_bu_ind_fk FOREIGN KEY (id, nhogar) REFERENCES bu.eah12_bu_viv;

DROP TABLE if exists bu.eah12_bu_rama;

CREATE TABLE bu.eah12_bu_rama
(
  codigo_rama    integer NOT NULL,
  descripcion_rama character varying(500),
  CONSTRAINT eah12_bu_rama_pk PRIMARY KEY (codigo_rama)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE bu.eah12_bu_rama
  OWNER TO tedede_php;

DROP TABLE if exists bu.eah12_bu_ocupacion;

CREATE TABLE bu.eah12_bu_ocupacion
(
  codigo_ocupacion      integer NOT NULL,
  descripcion_ocupacion character varying(500),
  CONSTRAINT eah12_bu_ocupacion_pk PRIMARY KEY (codigo_ocupacion)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE bu.eah12_bu_ocupacion
  OWNER TO tedede_php; 
--ALTER TABLE bu.eah12_bu_ind ADD CONSTRAINT eah12_bu_ind_eah12_bu_rama_fk FOREIGN KEY (t23_cod_2) REFERENCES bu.eah12_bu_rama (codigo_rama);
--ALTER TABLE bu.eah12_bu_ind ADD CONSTRAINT eah12_bu_ind_eah12_bu_ocupacion_fk FOREIGN KEY (t24_cod_2) REFERENCES bu.eah12_bu_ocupacion (codigo_ocupacion); --No pude agregar la foreign key porque las tablas originales de rama y ocupacion no tienen el valor 0.    