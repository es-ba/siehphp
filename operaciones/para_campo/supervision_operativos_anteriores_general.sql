----supervisiones de operativos anteriores
----NOTA IMPORTANTE  recupero la info de las tablas plana_tem_ aparte desde operativo xxxxxx y operativo zzzzzz y despues las backupeamos al operativo actual
---- teniendo en cuenta que operativo_xxxxx es/son los de participacion 3 y zzzz es son los de participacion 2
---  para algunos operativos puede incluir 4 operativos anteriores (eah's)
set role tedede_php;

CREATE SCHEMA operaciones_supervision
    AUTHORIZATION tedede_php;
select * into operaciones_supervision.platem_xxxxxx
  from encu.plana_tem_
order by pla_enc;

set role tedede_php;
CREATE SCHEMA operaciones_supervision
    AUTHORIZATION tedede_php;
select * into operaciones_supervision.platem_zzzzzz
  from encu.plana_tem_
order by pla_enc;

--Restaurar estos backups en el operativo actual 
set role tedede_php;
select t.pla_enc, max(ps1) ps1ori, max(ps2) ps2ori,t.pla_participacion,max(rs1) rs1, max(rs2) rs2, 
max(ps1)||(case when  coalesce(max(rs1),0) in (1,2) then '1' when coalesce(max(rs1),0) =3 then '3'  when coalesce(max(rs1),0) =4 then '4' when coalesce(max(rs1),0) in (5,6,7,8,9) then '5'  when coalesce(max(rs1),0) = 0 then null  else 'I' end) as ps1,
max(ps2)||(case when  coalesce(max(rs2),0) in (1,2) then '1' when coalesce(max(rs2),0) =3 then '3'  when coalesce(max(rs2),0) =4 then '4' when coalesce(max(rs2),0) in (5,6,7,8,9) then '5'  when coalesce(max(rs2),0) = 0 then null  else 'I' end) as ps2
from 
(
 select  tft.pla_enc pla_enc, tft.pla_rotaci_n_eah, tft.pla_rotaci_n_etoi,tft.pla_participacion, t.pla_participacion, 
   tft.pla_result_sup rs1, 
   null rs2, 
   tft.pla_sup_aleat, tft.pla_sup_dirigida,
   case when (tft.pla_sup_dirigida=3 or tft.pla_sup_aleat=3) then 'P' else 'T' end as ps1,
   null ps2,
   tft.pla_rea_enc, tft.pla_rea_recu, tft.pla_rea--,
  from  operaciones_supervision.platem_xxxxxx tft
  inner join encu.plana_tem_ t on tft.pla_enc=t.pla_enc 
   where  t.pla_participacion in (3) and t.pla_dominio=3 and tft.pla_rotaci_n_eah=1 
     and (tft.pla_sup_aleat is not null or tft.pla_sup_dirigida is not null)
     and tft.pla_rea in (1,3) and t.pla_rotaci_n_eah=1 
  union 
  select tfta.pla_enc pla_enc, tfta.pla_rotaci_n_eah, tfta.pla_rotaci_n_etoi,tfta.pla_participacion,t.pla_participacion, 
    case when tfta.pla_participacion=1 then tfta.pla_result_sup else null end as rs1, 
    case when tfta.pla_participacion=2 then tfta.pla_result_sup else null end as rs2,
    tfta.pla_sup_aleat, tfta.pla_sup_dirigida, 
    case when tfta.pla_participacion=1 then (case when (tfta.pla_sup_dirigida=3 or tfta.pla_sup_aleat=3) then 'P' else 'T' end ) else null end as ps1, 
    case when tfta.pla_participacion=2 then (case when (tfta.pla_sup_dirigida=3 or tfta.pla_sup_aleat=3) then 'P' else 'T' end ) else null end as ps2,
    tfta.pla_rea_enc, tfta.pla_rea_recu, tfta.pla_rea--,
   from  operaciones_supervision.platem_zzzzzz tfta
   inner join encu.plana_tem_ t on tfta.pla_enc=t.pla_enc 
    where  t.pla_participacion in (2,3) and t.pla_dominio=3 and tfta.pla_rotaci_n_eah=1 
      and (tfta.pla_sup_aleat is not null or tfta.pla_sup_dirigida is not null)
      and  tfta.pla_rea in (1,3)   
) as x
,
encu.plana_tem_ t
where x.pla_enc=t.pla_enc 
group by t.pla_enc, t.pla_participacion 
order by t.pla_enc;

-----------verficacion con algunos casos

--para detectar valores nuevos de result_sup, que quedaron indeterminados
select pla_result_sup,count(*)
  from  operaciones_supervision.platem_xxxxxx tft
  where pla_result_sup is not null
  group by pla_result_sup
  order by 1;
---categorías indeterminadas  puede haber o no
--result_sup count
select pla_result_sup,count(*)
  from  operaciones_supervision.platem_zzzzzz tft
  where pla_result_sup is not null
  group by pla_result_sup
  order by 1;  
---categorías indeterminadas  puede haber o no
--result_sup count

--verificacion de valores con alguna encuesta
select pla_enc, pla_sup_aleat, pla_sup_dirigida, pla_participacion, pla_result_sup, pla_semana
  from  operaciones_supervision.platem_xxxxxx tft
  where pla_enc in (encuesta);
----enc     supaleat, supdirigida, participa, result_sup, semana 

select pla_enc, pla_sup_aleat, pla_sup_dirigida, pla_participacion, pla_result_sup, pla_semana
from  operaciones_supervision.platem_zzzzzz
where pla_enc in (encuesta) ;
--enc     supaleat, supdirigida, participa, result_sup, semana

-----------------------------------------
/* --si no estuvieran agregadas las variables correr a continuación */
/*
alter table encu.plana_tem_ add column pla_ps1 text;
alter table encu.plana_tem_ add column pla_ps2 text;

INSERT INTO encu.pla_var( plavar_ope, plavar_var, plavar_planilla, plavar_editable, plavar_orden, plavar_tlg)
values      ('dbo.ope_actual()', 'ps1','MON_TEM_CAMPO', FALSE, 422,1),
            ('dbo.ope_actual()', 'ps2','MON_TEM_CAMPO', FALSE, 424,1);
*/

update encu.plana_tem_ t set pla_ps1=b.ps1, pla_ps2=b.ps2
from (
select t.pla_enc, max(ps1) ps1ori, max(ps2) ps2ori,t.pla_participacion,max(rs1) rs1, max(rs2) rs2, 
max(ps1)||(case when  coalesce(max(rs1),0) in (1,2) then '1' when coalesce(max(rs1),0) =3 then '3'  when coalesce(max(rs1),0) =4 then '4' when coalesce(max(rs1),0) in (5,6,7,8,9) then '5'  when coalesce(max(rs1),0) = 0 then null  else 'I' end) as ps1,
max(ps2)||(case when  coalesce(max(rs2),0) in (1,2) then '1' when coalesce(max(rs2),0) =3 then '3'  when coalesce(max(rs2),0) =4 then '4' when coalesce(max(rs2),0) in (5,6,7,8,9) then '5'  when coalesce(max(rs2),0) = 0 then null  else 'I' end) as ps2
from 
(
 select  tft.pla_enc pla_enc, tft.pla_rotaci_n_eah, tft.pla_rotaci_n_etoi,tft.pla_participacion, t.pla_participacion, 
   tft.pla_result_sup rs1, 
   null rs2, 
   tft.pla_sup_aleat, tft.pla_sup_dirigida,
   case when (tft.pla_sup_dirigida=3 or tft.pla_sup_aleat=3) then 'P' else 'T' end as ps1,
   null ps2,
   tft.pla_rea_enc, tft.pla_rea_recu, tft.pla_rea--,
  from operaciones_supervision.platem_xxxxxx tft  
  inner join encu.plana_tem_ t on tft.pla_enc=t.pla_enc 
   where  t.pla_participacion in (3) and t.pla_dominio=3 and tft.pla_rotaci_n_eah=1 
     and (tft.pla_sup_aleat is not null or tft.pla_sup_dirigida is not null)
     and tft.pla_rea in (1,3)  and t.pla_rotaci_n_eah=1  
 union
  select tfta.pla_enc pla_enc, tfta.pla_rotaci_n_eah, tfta.pla_rotaci_n_etoi,tfta.pla_participacion,t.pla_participacion, 
    case when tfta.pla_participacion=1 then tfta.pla_result_sup else null end as rs1, 
    case when tfta.pla_participacion=2 then tfta.pla_result_sup else null end as rs2,
    tfta.pla_sup_aleat, tfta.pla_sup_dirigida, 
    case when tfta.pla_participacion=1 then (case when (tfta.pla_sup_dirigida=3 or tfta.pla_sup_aleat=3) then 'P' else 'T' end ) else null end as ps1, 
    case when tfta.pla_participacion=2 then (case when (tfta.pla_sup_dirigida=3 or tfta.pla_sup_aleat=3) then 'P' else 'T' end ) else null end as ps2,
    tfta.pla_rea_enc, tfta.pla_rea_recu, tfta.pla_rea--,
   from  operaciones_supervision.platem_zzzzzz tfta
   inner join encu.plana_tem_ t on tfta.pla_enc=t.pla_enc 
    where  t.pla_participacion in (2,3) and t.pla_dominio=3 and tfta.pla_rotaci_n_eah=1 
      and (tfta.pla_sup_aleat is not null or tfta.pla_sup_dirigida is not null)
      and  tfta.pla_rea in (1,3)   
) as x
,
encu.plana_tem_ t
where x.pla_enc=t.pla_enc
group by t.pla_enc, t.pla_participacion 
order by t.pla_enc	
) b
where b.pla_enc= t.pla_enc and t.pla_participacion in (2,3);
----UPDATE ...

select pla_ps1,pla_ps2,pla_enc, pla_participacion,pla_trimestre,pla_rotaci_n_etoi, pla_rotaci_n_eah,*
from encu.plana_tem_
where pla_ps1 in ('PI','TI') or  pla_ps2 in ('PI','TI');
--tantos casos informados.

---------------------------------------------------------------------------------------------
/*
--  si es que faltara agregarlas en preguntas y variables para poder verlas en las planillas.
INSERT INTO encu.preguntas(
             pre_ope,   pre_for, pre_blo,         pre_pre,          pre_texto,                           pre_desp_opc, pre_orden, pre_tlg)
     VALUES (dbo.ope_actual(), 'TEM'  , '',      'ps1'         , 'Supervisión Participación 1', 'vertical',   880,       1);
            

INSERT INTO encu.variables(
             var_ope,   var_for,  var_mat,  var_pre,         var_var,        var_tipovar, var_tlg)
     VALUES (dbo.ope_actual(), 'TEM'  ,  '',       'ps1'         , 'ps1',         'texto'    , 1);

INSERT INTO encu.preguntas(
             pre_ope,   pre_for, pre_blo,         pre_pre,          pre_texto,                           pre_desp_opc, pre_orden, pre_tlg)
     VALUES (dbo.ope_actual(), 'TEM'  , '',      'ps2'         , 'supervisión Participación 2', 'vertical',   882,       1);
            

INSERT INTO encu.variables(
             var_ope,   var_for,  var_mat,  var_pre,         var_var,        var_tipovar, var_tlg)
     VALUES (dbo.ope_actual(), 'TEM'  ,  '',       'ps2'         , 'ps2',         'texto'    , 1);     


select pre_pre, pre_orden
from encu.preguntas
where pre_for='TEM'
order by pre_orden
*/