-- en la base eah2013_desa_db o probar en la base tedede sin instalar

----------------
--drop table encu.tipo_nov;
create table encu.tipo_nov
(tiponov_tipo character varying(50) not null, 
tiponov_tlg bigint,
CONSTRAINT tiponov_tipo_pk PRIMARY KEY (tiponov_tipo)
);

INSERT INTO encu.tipo_nov VALUES ('novedad',1);
INSERT INTO encu.tipo_nov VALUES ('circular',1);
INSERT INTO encu.tipo_nov VALUES ('manual',1);

---------------

--drop table encu.importancia
create table encu.importancia
(importancia_importancia character varying(50) not null, 
importancia_tlg bigint,
CONSTRAINT importancia_importancia_pk PRIMARY KEY (importancia_importancia)
);

INSERT INTO encu.importancia VALUES ('alta',1);
INSERT INTO encu.importancia VALUES ('media',1);
INSERT INTO encu.importancia VALUES ('baja',1);

---------------
-- drop table encu.novedades
create table encu.novedades
 (nov_ope character varying(50) not null, 	
 nov_nov character varying(10),  			
 nov_titulo character varying(100),
 nov_tipo character varying(20), 		
 nov_importancia character varying(20), 	
 nov_detalle character varying(1000),
 nov_origen text,
 nov_destino character varying(30), 
 nov_tlg bigint,
CONSTRAINT nov_ope_nov_nov_pk PRIMARY KEY (nov_ope, nov_nov),
CONSTRAINT nov_tipo_fk FOREIGN KEY (nov_tipo) REFERENCES encu.tipo_nov (tiponov_tipo) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
CONSTRAINT nov_importancia_fk FOREIGN KEY (nov_importancia) REFERENCES encu.importancia (importancia_importancia) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION,
CONSTRAINT nov_destino_fk FOREIGN KEY (nov_destino) REFERENCES encu.roles (rol_rol) MATCH SIMPLE ON UPDATE NO ACTION ON DELETE NO ACTION
 );

----------------

create table encu.nov_usu
(
novusu_ope character varying(50) not null,
novusu_nov integer not null,
novusu_usu character varying(100),
novusu_archivado boolean not null default false, 
novusu_importante boolean not null default false,
novusu_tlg bigint,
CONSTRAINT nov_ope_nov_nov_novusu_usu_pk PRIMARY KEY (novusu_ope, novusu_nov, novusu_usu)
);

-----------------

create table encu.nov_adjuntos
(
novadj_ope character varying(50) not null,
novadj_nov integer not null,
novadj_adj serial,
novadj_nombre_archivo character varying(100),
novadj_descripcion character varying(100),
novadj_tipo character varying(100),
novadj_tlg bigint,
CONSTRAINT nov_ope_nov_nov_novadj_adj_pk PRIMARY KEY (novadj_ope , novadj_nov, novadj_adj)
);


---------------
