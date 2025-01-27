set search_path= encu, dbo, comun;
set role tedede_php;
--FALTA
--parametrizarlo, pasarlo a una funcion  y hacer un proceso
--agregar condicion de corrida :
--    .todas las encuestas con estado >=77
--    . marca en operativos fin_revision_tem=true
--revisar que haya casos no residentes
--agregar bitacora del proc
--Por el momento la tarea se realiza una vez cuando estan dados las condiciones de corrida
--fijarse que puede haber otro formularios de personas a borrar
--dar acceso por spss a las tabla s1_p_noresidentes para que vea proie

--revision previa
--estados
select pla_estado, count(*)
from plana_tem_
group by 1
order by 1
--todos deben ser >=77

--no residentes
select count(*)
    --s.pla_enc, s.pla_hog, s.pla_mie, t.pla_estado, case when i.pla_enc is null then false else true end tiene_i1
    from plana_s1_p s left join plana_i1_ i using (pla_enc, pla_hog, pla_mie)
      join plana_tem_ t on t.pla_enc= s.pla_enc
    where pla_r0=2 and pla_estado>=77;
--88

select * 
    from plana_md_ d 
    left join plana_s1_p  p on d.pla_enc= p.pla_enc and d.pla_hog= p.pla_hog and d.pla_mie= p.pla_mie      
where pla_r0 is distinct from 1 and d.pla_enc is not null;
--no hay no residentes en el md

select * 
    from plana_i1_ d 
    left join plana_s1_p  p on d.pla_enc= p.pla_enc and d.pla_hog= p.pla_hog and d.pla_mie= p.pla_mie      
where pla_r0 is distinct from 1 and d.pla_enc is not null;
--no hay no residentes en el i1

--conteo previos
with no_residentes as (
  select s.pla_enc, s.pla_hog, s.pla_mie, t.pla_estado, case when i.pla_enc is null then false else true end tiene_i1
    from plana_s1_p s left join plana_i1_ i using (pla_enc, pla_hog, pla_mie)
      join plana_tem_ t on t.pla_enc= s.pla_enc
    where pla_r0=2 and pla_estado>=77 
), res_noresi as ( 
select count(*) res_noresi
  from respuestas r join no_residentes nr on 
     res_ope= dbo.ope_actual()
     and res_for not in ('TEM', 'SUP')
     and res_mat ='P'
     and res_enc=nr.pla_enc 
     and res_hog=nr.pla_hog
     and res_mie=nr.pla_mie
), cla_noresi as (
select count(*) n_cla_noresi
  from claves c join no_residentes nr on 
     cla_ope= dbo.ope_actual()
     and cla_for not in ('TEM', 'SUP')
     and cla_mat ='P'
     and cla_enc=nr.pla_enc 
     and cla_hog=nr.pla_hog
     and cla_mie=nr.pla_mie
), i1_noresi as (
select count(*)n_i1_noresi from plana_i1_ i join no_residentes nr on 
     nr.tiene_i1 is true 
     and i.pla_enc=nr.pla_enc 
     and i.pla_hog=nr.pla_hog
     and i.pla_mie=nr.pla_mie
), s1p_noresi  as (
select count(*)n_s1p_noresi from plana_s1_p p join no_residentes nr on  
     p.pla_enc=nr.pla_enc 
     and p.pla_hog=nr.pla_hog
     and p.pla_mie=nr.pla_mie   
)
select *
    from res_noresi, cla_noresi, i1_noresi, s1p_noresi;
--1672	88	0	88

--creacion de tablas para no residentes
CREATE TABLE respuestas_noresidentes (LIKE respuestas INCLUDING ALL);
CREATE TABLE claves_noresidentes (LIKE claves INCLUDING ALl);
CREATE TABLE plana_i1__noresidentes (LIKE plana_i1_ INCLUDING ALl);
CREATE TABLE plana_s1_p_noresidentes (LIKE plana_s1_p INCLUDING ALl);


--bkp_previo_sacar_noresi
CREATE SCHEMA IF NOT EXISTS operaciones_noresidentes
    AUTHORIZATION tedede_php;
select * into operaciones_noresidentes.respuestas
from respuestas
order by res_ope, res_for, res_mat, res_enc, res_hog, res_mie, res_exm, res_var;--6401099
select * into operaciones_noresidentes.claves
  from claves
  order by cla_ope, cla_for, cla_mat, cla_enc, cla_hog, cla_mie, cla_exm	;--81774
select * into operaciones_noresidentes.plana_i1_
  from plana_i1_
  order by pla_enc, pla_hog, pla_mie, pla_exm	;--13128
select * into operaciones_noresidentes.plana_s1_p_
  from plana_s1_p 
  order by pla_enc, pla_hog, pla_mie, pla_exm	; --13216

--conteo inicial
select 'inicial' etapa,  (select count(*) from respuestas) n_res,
    (select  count(*) from claves) n_cla,
    (select  count(*) from plana_i1_) n_i1,
    (select  count(*) from plana_s1_p) n_s1p ;
--"inicial"	6401099	81774	13128	13216

--sacando no residentes
with no_residentes as (
  select s.pla_enc, s.pla_hog, s.pla_mie, t.pla_estado, case when i.pla_enc is null then false else true end tiene_i1
    from plana_s1_p s left join plana_i1_ i using (pla_enc, pla_hog, pla_mie)
      join plana_tem_ t on t.pla_enc= s.pla_enc
    where pla_r0=2 and pla_estado>=77
), res_noresi as ( 
delete 
  from respuestas r 
  using no_residentes nr 
  where 
     res_ope= dbo.ope_actual()
     and res_for not in ('TEM', 'SUP')
     and res_mat ='P'
     and res_enc=nr.pla_enc 
     and res_hog=nr.pla_hog
     and res_mie=nr.pla_mie
 returning r.*
), bkp_resp as (
insert into respuestas_noresidentes
  select * from res_noresi
 ), cla_noresi as (
delete 
  from claves c 
  using  no_residentes nr
  where
     cla_ope= dbo.ope_actual()
     and cla_for not in ('TEM', 'SUP')
     and cla_mat ='P'
     and cla_enc=nr.pla_enc 
     and cla_hog=nr.pla_hog
     and cla_mie=nr.pla_mie
  returning c.*
), bkp_cla as (
insert into claves_noresidentes
  select * from cla_noresi
), i1_noresi as (
delete 
  from plana_i1_ i 
  using no_residentes nr 
  where
     nr.tiene_i1 is true 
     and i.pla_enc=nr.pla_enc 
     and i.pla_hog=nr.pla_hog
     and i.pla_mie=nr.pla_mie
  returning i.*
), bkp_i1 as (
insert into plana_i1__noresidentes
  select * from i1_noresi
), s1p_noresi  as (
delete from plana_s1_p p 
  using  no_residentes nr 
  where 
     p.pla_enc=nr.pla_enc 
     and p.pla_hog=nr.pla_hog
     and p.pla_mie=nr.pla_mie   
  returning p.*
), bkp_s1p as (
insert into plana_s1_p_noresidentes
  select * from s1p_noresi
)
select  'eliminados' etapa, (select count(*) from res_noresi) n_res,
    (select  count(*) from cla_noresi) n_cla,
    (select  count(*) from i1_noresi) n_i1,
    (select  count(*) from s1p_noresi) n_s1p 
;
--"eliminados"	1672	88	0	88

select 'final' etapa,  (select count(*) from respuestas) n_res,
    (select  count(*) from claves) n_cla,
    (select  count(*) from plana_i1_) n_i1,
    (select  count(*) from plana_s1_p) n_s1p ;
--"final"	6399427	81686	13128	13128

--revisar total_r, total_m 
select s.pla_enc, s.pla_hog, t.pla_estado,s.pla_total_m , s.pla_total_r, count(*)
	from plana_s1_ s join plana_s1_p p using (pla_enc, pla_hog)
	join plana_tem_ t using (pla_enc)
	where pla_estado>=77 and pla_entrea  is distinct from 4
    group by 1,2,3,4,5
    having count(*) is distinct from s.pla_total_r
    order by 1,2,3,4;
--total_r coincide con el total de registros de s1_p
	
select res_for, res_mat, count(*)
from respuestas_noresi
group by 1,2
order by 1,2;

--consistir nuevamente las encuestas con noresidente?
--habrá que desactivar la consistencia total_m contra cant s1P? No recuerdo si hay otras
--hacer grillas de las tablas de noresidente?
-- cambiar al rol adecuado
grant select on plana_s1_p_noresidentes to eah2024_ro;
