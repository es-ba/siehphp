/*
CREATE EXTENSION dblink;

select dblink_connect('db_13','host=localhost dbname=ebcp_20140513_db user=tedede_php password=laclave');
select dblink_connect('db_14','host=localhost dbname=ebcp_20140514_db user=tedede_php password=laclave');

create table operaciones.s1_13 as
select * from dblink('db_13','select pla_enc, pla_hog, pla_mie, pla_p9 from encu.plana_s1_p') t(pla_enc integer, pla_hog integer, pla_mie integer, pla_p9 integer);

create table operaciones.respuestas_13 as
select * from dblink('db_13',$$select 
 res_ope 
  ,res_for
  ,res_mat
  ,res_enc
  ,res_hog
  ,res_mie
  ,res_exm
  ,res_var
  ,res_valor
  ,res_valesp
  ,res_valor_con_error
  ,res_estado 
  ,res_anotaciones_marginales 
  ,res_tlg 
  from encu.respuestas
  where res_var='p9'$$) t( res_ope character varying(50) ,
  res_for character varying(50) ,
  res_mat character varying(50) ,
  res_enc integer ,
  res_hog integer ,
  res_mie integer ,
  res_exm integer ,
  res_var character varying(50) ,
  res_valor text,
  res_valesp character varying(50),
  res_valor_con_error text,
  res_estado text,
  res_anotaciones_marginales text,
  res_tlg bigint);

create table operaciones.s1_14 as
select * from dblink('db_14','select pla_enc, pla_hog, pla_mie from encu.plana_s1_p') t(pla_enc integer, pla_hog integer, pla_mie integer);

alter table operaciones.s1_13 add primary key (pla_enc, pla_hog, pla_mie);

alter table operaciones.s1_14 add primary key (pla_enc, pla_hog, pla_mie);

select distinct n.pla_enc
  from operaciones.s1_14 n left join operaciones.s1_13 v
       on n.pla_enc=v.pla_enc and n.pla_hog=v.pla_hog and n.pla_mie=v.pla_mie
  where v.pla_enc is null;
-- encuestas con falta que no tenemos en el backup diario:
-- 53 rows

select n.pla_p9_1 is null, v.pla_enc is null, count(*)
  from encu.plana_s1_p n left join operaciones.s1_14 v
       on n.pla_enc=v.pla_enc and n.pla_hog=v.pla_hog and n.pla_mie=v.pla_mie
  group by n.pla_p9_1 is null, v.pla_enc is null; 
-- verificamos que no hay problemas con las nuevas (a partir del día 15)

select n.pla_p9_1 is null, v.pla_enc is null, count(*)
  from encu.plana_s1_p n left join operaciones.s1_13 v
       on n.pla_enc=v.pla_enc and n.pla_hog=v.pla_hog and n.pla_mie=v.pla_mie
  group by n.pla_p9_1 is null, v.pla_enc is null; 
*/

-- update  encu.respuestas  set res_valor=1 
select * from encu.respuestas 
  where res_ope='ebcp2014' 
    and res_for='S1' 
    and res_mat='P' 
    and (res_enc,res_hog,res_mie,res_exm, res_var) in 
        (select res_enc, res_hog,res_mie,res_exm,res_var || '_' || res_valor 
           from operaciones.respuestas_13
           WHERE res_ope='ebcp2014' and res_for='S1' and res_mat='P' and res_var='p9' and   res_valor is not null
        );

select *
  from