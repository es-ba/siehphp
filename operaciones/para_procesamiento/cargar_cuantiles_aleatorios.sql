set search_path=encu, dbo, comun;

--1- Crear y cargar tabla axiliar asociada al excel que entrega procesamiento. Definirlas en el schema operaciones
--   usar el paquete txt-to-sql. REvisar nulos y tipos de datos
--   Agregar esquema operaciones al create e insert en el script generado por txt-to-sql
--   Revisar las variables involucradas que sean las mismas de siempre. Sino Actualizar
--   Tener en cuenta la cantidad de filas de datos de los archivos


--2 cuantiles de individuos (a plana_i1_)
-- Agregar columnas para los cuantiles
 --"daleaioph_neto_2" integer,
 --"daleaipcf_2pob0" integer,
 --"qaleaingtot_neto_2" integer,
 --"daleaingtot_neto_2" integer,
Alter table encu.plana_i1_ add column pla_daleaioph_neto_2   integer;
Alter table encu.plana_i1_ add column pla_daleaipcf_2pob0    integer;
Alter table encu.plana_i1_ add column pla_qaleaingtot_neto_2 integer;
Alter table encu.plana_i1_ add column pla_daleaingtot_neto_2 integer;
Alter table his.plana_i1_ add column pla_daleaioph_neto_2   integer;
Alter table his.plana_i1_ add column pla_daleaipcf_2pob0    integer;
Alter table his.plana_i1_ add column pla_qaleaingtot_neto_2 integer;
Alter table his.plana_i1_ add column pla_daleaingtot_neto_2 integer;

--carga
set search_path= encu, comun, dbo, dbx, public;
update encu.plana_i1_ i
set
  pla_daleaioph_neto_2= coalesce(o.daleaioph_neto_2,0),
  pla_daleaipcf_2pob0= coalesce(o.daleaipcf_2pob0,0),
  pla_qaleaingtot_neto_2= coalesce(o.qaleaingtot_neto_2,0),
  pla_daleaingtot_neto_2= coalesce(o.daleaingtot_neto_2,0)
from operaciones."etoi242_deciles_alea_individuos" o
where o.enc=i.pla_enc and o.hog=i.pla_hog and o.mie=i.pla_mie;
--UPDATE 4628

select 'i1't,sum(pla_daleaioph_neto_2),sum(pla_daleaipcf_2pob0),sum(pla_qaleaingtot_neto_2),sum(pla_daleaingtot_neto_2)
from encu.plana_i1_
union select 'aux't,sum(daleaioph_neto_2),sum(daleaipcf_2pob0),sum(qaleaingtot_neto_2),sum(daleaingtot_neto_2)
from operaciones."etoi242_deciles_alea_individuos" ;
--"aux"	12169	24219	9440	17245
--"i1"	12169	24219	9440	17245

-- varcal asociadas
select *
 from encu.varcal
 where varcal_varcal in ('daleaioph_neto_2','daleaipcf_2pob0','qaleaingtot_neto_2','daleaingtot_neto_2')
--0

--en el ticket, Luciana pone lo que va en la columna varcal_nombre
insert into encu.varcal(varcal_ope, varcal_varcal, varcal_destino,varcal_orden, varcal_nombre, varcal_activa,varcal_valida, varcal_tipo,varcal_tipodedato, varcal_grupo,varcal_tlg) values
(dbo.ope_actual(),'daleaioph_neto_2'  ,'mie',1, 'Grupo decílico de ingreso de la ocu ppal neto de aguin (grupos de igual tamaño; desempate aleatorio de valores repetidos en límites de grupo, incluye valores imput)',true,true,'externo','entero','ingresos externa imputada',1),
(dbo.ope_actual(),'daleaipcf_2pob0'   ,'mie',1, 'Grupo decílico IPCF de la POBLACIÓN (incluye pob en hog sin ingresos, desempate aleatorio de valores repetidos en límites de grupo, incluye valores imput)',true,true,'externo','entero','ingresos externa imputada',1),
(dbo.ope_actual(),'qaleaingtot_neto_2','mie',1, 'Grupo quintílico de ing total indiv neto de aguin (desempate aleatorio de valores repetidos en límites de grupo, incluye valores imput)',true,true,'externo','entero','ingresos externa imputada',1),
(dbo.ope_actual(),'daleaingtot_neto_2','mie',1, 'Grupo decílico de ing total indiv neto de aguin (desempate aleatorio de valores repetidos en límites de grupo, incluye valores imput)',true,true,'externo','entero','ingresos externa imputada',1);
--INSERT 0 4

----------
--3 Cuantiles de hogar ( a plana_s1_)

select  count(*), 
(select count(*) from operaciones."etoi242_ntiles_alea_hogares") auxiliar --s.pla_enc, s.pla_hog, t.pla_estado, t.pla_rea, t.pla_norea, t.pla_hog_tot, t.pla_hog_pre, s.pla_entrea, i.pla_mie 
from encu.plana_s1_ s join encu.plana_tem_ t on t.pla_enc=s.pla_enc 
    left join operaciones."etoi242_ntiles_alea_hogares" q on q.enc=s.pla_enc and q.hog=s.pla_hog 
where pla_entrea IS DISTINCT FROM 4 AND
    t.pla_estado=77 and q.enc is not null and q.hog is not null;
--1956	1956

 "qaleaipcf_2inc0ing" integer,
 "qaleaipcf_2exc0ing" integer,
 "daleaipcf_2exc0ing" integer,
 "daleaitf_2exc0ing" integer,
 "qaleaitf_2exc0ing" integer,
alter table his.plana_s1_ add column pla_qaleaipcf_2inc0ing   integer;
alter table his.plana_s1_ add column pla_qaleaipcf_2exc0ing   integer;
alter table his.plana_s1_ add column pla_daleaipcf_2exc0ing   integer;
alter table his.plana_s1_ add column pla_daleaitf_2exc0ing    integer;
alter table his.plana_s1_ add column pla_qaleaitf_2exc0ing    integer;
set search_path= encu, comun, dbo, dbx, public;
alter table plana_s1_ add column pla_qaleaipcf_2inc0ing   integer;
alter table plana_s1_ add column pla_qaleaipcf_2exc0ing   integer;
alter table plana_s1_ add column pla_daleaipcf_2exc0ing   integer;
alter table plana_s1_ add column pla_daleaitf_2exc0ing    integer;
alter table plana_s1_ add column pla_qaleaitf_2exc0ing    integer;

update encu.plana_s1_ s
set
  pla_qaleaipcf_2inc0ing   =coalesce(o.qaleaipcf_2inc0ing,0),
  pla_qaleaipcf_2exc0ing   =coalesce(o.qaleaipcf_2exc0ing,0),
  pla_daleaipcf_2exc0ing   =coalesce(o.daleaipcf_2exc0ing,0),
  pla_daleaitf_2exc0ing    =coalesce(o.daleaitf_2exc0ing,0),
  pla_qaleaitf_2exc0ing    =coalesce(o.qaleaitf_2exc0ing,0)
from operaciones."etoi242_ntiles_alea_hogares" o
where o.enc=s.pla_enc and o.hog=s.pla_hog ;
--UPDATE 1956

--control por sumas
select 'S1' t, sum(pla_qaleaipcf_2inc0ing) sqaleaipcf_2inc0inc,sum(pla_qaleaipcf_2exc0ing) sqaleaipcf_2exc0ing,sum(pla_daleaipcf_2exc0ing) sdaleaipcf_2exc0ing, sum(pla_daleaitf_2exc0ing)sdaleaitf_2exc0ing,sum(pla_qaleaitf_2exc0ing) sqaleaitf_2exc0ing
from encu.plana_S1_ union
select 'aux' t, sum(qaleaipcf_2inc0ing) sqaleaipcf_2inc0ing,sum(qaleaipcf_2exc0ing) sqaleaipcf_2exc0ing,sum(daleaipcf_2exc0ing) sdaleaipcf_2exc0ing, sum(daleaitf_2exc0ing)sdaleaitf_2exc0ing,sum(qaleaitf_2exc0ing) sqaleaitf_2exc0ing
from operaciones."etoi242_ntiles_alea_hogares" ;
"aux"	5667	5614	10241	10444	5703
"S1"	5667	5614	10241	10444	5703

--revisar varcal 
select *
 from encu.varcal
 where varcal_varcal in ('qaleaipcf_2inc0ing', 'qaleaipcf_2exc0ing', 'daleaipcf_2exc0ing', 'daleaitf_2exc0ing', 'qaleaitf_2exc0ing')
--0 rows

insert into encu.varcal(varcal_ope, varcal_varcal, varcal_destino,varcal_orden, varcal_nombre, varcal_activa,varcal_valida, varcal_tipo,varcal_tipodedato, varcal_grupo,varcal_tlg) values
(dbo.ope_actual(),'qaleaipcf_2inc0ing'  ,'hog',1, 'Grupo quintílico de IPCF del hogar (INCLUYE hogs sin ing, desempate aleatorio de valores repetidos en límites de grupo, construido a partir ing con valores imput.)',true,true,'externo','entero','ingresos externa imputada',1),
(dbo.ope_actual(),'qaleaipcf_2exc0ing' ,'hog',1, 'Grupo quintílico de IPCF del hogar (EXCLUYE hogs sin ing, desempate aleatorio de valores repetidos en límites de grupo, a partir de ing con val imput)',true,true,'externo','entero','ingresos externa imputada',1),
(dbo.ope_actual(),'daleaipcf_2exc0ing' ,'hog',1, 'Grupo decílico de IPCF del hogar (EXCLUYE hogs sin ing, desempate aleatorio de valores repetidos en límites de grupo, a partir de ing con val imput)',true,true,'externo','entero','ingresos externa imputada',1),
(dbo.ope_actual(),'daleaitf_2exc0ing' ,'hog',1, 'Grupo decílico de ITF del hogar (EXCLUYE hogs sin ing, desempate aleatorio de valores repetidos en límites de grupo, a partir de ing con val imput)',true,true,'externo','entero','ingresos externa imputada',1),
(dbo.ope_actual(),'qaleaitf_2exc0ing' ,'hog',1, 'Grupo quintílico de ITF del hogar (EXCLUYE hogs sin ing, desempate aleatorio de valores repetidos en límites de grupo, a partir de ing con val imput)',true,true,'externo','entero','ingresos externa imputada',1);
--INSERT 0 5


--4 --actualizar instalacion desde la app
