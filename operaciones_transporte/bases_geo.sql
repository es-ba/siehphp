-- invocar >sqlite3 bases_geo.db
-- -----------------------------
 
-- 1. creacion tablas
CREATE TABLE paloba(
    paloba_paloba    NUMERIC(3) NOT NULL,
    paloba_partido   VARCHAR(4) NOT NULL,
    paloba_loc       CHAR(5)    NOT NULL,
    paloba_nomloc    TEXT,
    paloba_nompart   TEXT,
    CONSTRAINT paloba_pk PRIMARY KEY(paloba_paloba)
); 
CREATE TABLE aux_esquinas(
    auxesq_esq         INTEGER,
    auxesq_longitude   INTEGER NOT NULL,
    auxesq_latitude    INTEGER NOT NULL,
    auxesq_nomloc      TEXT,
    auxesq_nompart     TEXT,
    CONSTRAINT auxesquinas_pk PRIMARY KEY(auxesq_esq)
  );
CREATE TABLE esquinas(
    esq_esq         INTEGER,
    esq_longitude   INTEGER NOT NULL,
    esq_latitude    INTEGER NOT NULL,
    esq_paloba      INTEGER,
    CONSTRAINT esquinas_pk PRIMARY KEY(esq_esq),
    CONSTRAINT esquinas_paloba_fk FOREIGN KEY(esq_paloba) REFERENCES paloba(paloba_paloba)
  );
  
CREATE TABLE nombrescalles(
    nom_calle  TEXT,
    CONSTRAINT nombrescalle_pk PRIMARY KEY(nom_calle)
    );

CREATE TABLE arcos_esquinas(
    arcesq_esq         INTEGER,
    arcesq_nombre      TEXT,
    arcesq_arc         INTEGER NOT NULL, 
    CONSTRAINT arcesq_esq_fk FOREIGN KEY(arcesq_esq) REFERENCES esquinas(esq_esq)
    CONSTRAINT arcesq_nombrescalle_fk FOREIGN KEY(arcesq_nombre) REFERENCES nombrescalles(nom_calle)

  ); 
--      CONSTRAINT arcesq_pk PRIMARY KEY(arcesq_esq, arcesq_arc),

CREATE TABLE nombrescalles(
    nom_calle  TEXT,
    CONSTRAINT nombrescalle_pk PRIMARY KEY(nom_calle)
    );
    
CREATE VIEW esq_paloba AS
    SELECT esq_esq, esq_longitude, esq_latitude, paloba_nomloc, paloba_nompart 
        FROM esquinas e JOIN paloba p ON e.esq_paloba=p.paloba_paloba; 

PRAGMA foreign_keys= on; -- prende testeo de foreign keys

--2. carga de tablas
.read load_paloba.sql
  --nombrepart =BUENOS AIRES EN paloba (como esta en esquinas)
UPDATE paloba
  set paloba_nompart='BUENOS AIRES'
  WHERE paloba_partido='CABA';
.read load_esquinas.sql -- en aux_esquinas
  
  --carga de esquinas :  
INSERT INTO esquinas(esq_esq, esq_longitude, esq_latitude, esq_paloba)
    SELECT a.auxesq_esq, a.auxesq_longitude, a.auxesq_latitude, p.paloba_paloba
        FROM aux_esquinas a JOIN paloba p ON coalesce(a.auxesq_nomloc,' ')=coalesce(p.paloba_nomloc,' ') and coalesce(a.auxesq_nompart,' ')=coalesce(p.paloba_nompart,' ');

PRAGMA foreign_keys= off;        
.read load_arcos_esquinas.sql        
PRAGMA foreign_keys= on;        

INSERT INTO nombrescalles
    select distinct arcesq_nombre 
        from arcos_esquinas;

--3. VARIOS 
--limpiar arcos_esquinas
delete from arcos_esquinas
where not exists(select e.esq_esq from esquinas e where e.esq_esq=arcos_esquinas.arcesq_esq);  

-- indices
create index esquinas_paloba_idx on esquinas(esq_paloba);
create index arc_esquinas_idx    on arcos_esquinas(arcesq_esq);
create index arcesq_calle_idx    on arcos_esquinas(arcesq_nombre);


        
/* ** LOADS con import
.import paloba.txt paloba
.import esquinas.txt aux_esquinas
.import arcos_esquinas.txt arcos_esquinas
*/

        
/*        
   --VER
   SELECT  a.auxesq_nomloc, a.auxesq_nompart, count(*) nesquinas
       --a.auxesq_esq, a.auxesq_longitude, a.auxesq_latitude, p.paloba_paloba
    FROM aux_esquinas a left JOIN paloba p ON coalesce(a.auxesq_nomloc,' ')=coalesce(p.paloba_nomloc,' ') and coalesce(a.auxesq_nompart,' ')=coalesce(p.paloba_nompart,' ')
    WHERE p.paloba_paloba is null and NOT (a.auxesq_nompart='BUENOS AIRES')
    group by a.auxesq_nomloc, a.auxesq_nompart ; 
   
   
   SELECT a.* 
     from aux_esquinas a left join esquinas e on a.auxesq_esq=e.esq_esq
     where e.esq_esq is null
     limit 30;
   select *
   from paloba
   where paloba_nompart LIKE 'CA%';   
sqlite> select count(*) from esquinas where esq_paloba ='';
0
sqlite> select count(*) from esquinas where esq_paloba  is null;
29025
sqlite> select count(*) from aux_esquinas where auxesq_nompart='BUENOS AIRES';
16503
   SELECT COUNT(*) 
     from aux_esquinas a left join esquinas e on a.auxesq_esq=e.esq_esq
     where e.esq_esq is null AND  NOT (a.auxesq_nompart='BUENOS AIRES')
     limit 30;
   
*/   

/* 
   ...
select charrr(241);

select * from "cvp"."Relpre"

create or replace function "char"(x integer) returns text language sql as 
'select chr(x)';

create or replace function charrr(x integer) returns text language sql as 
'select chr(x)';
   
*/

