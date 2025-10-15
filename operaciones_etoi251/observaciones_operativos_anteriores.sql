SET ROLE tedede_php;

create schema operaciones_ope_claves_respuestas
  AUTHORIZATION tedede_php;
--Traemos la información de claves y respuestas 
---claves y respuestas
drop table if exists operaciones_ope_claves_respuestas.claves2024;
drop table if exists operaciones_ope_claves_respuestas.respuestas2024;


drop table if exists operaciones_ope_claves_respuestas.claves244;
drop table if exists operaciones_ope_claves_respuestas.respuestas244;
---claves y respuestas
set role tedede_php;
--SELECT 
select * into operaciones_ope_claves_respuestas.claves2024
  from encu.claves
  where cla_ope='eah2024' and cla_for in ('A1','S1')
  order by cla_ope, cla_for, cla_mat, cla_enc, cla_hog, cla_mie, cla_exm;
--SELECT 
select *  into operaciones_ope_claves_respuestas.respuestas2024
  from encu.respuestas
  where res_ope='eah2024' and res_for in ('A1','S1')
  order by res_ope, res_for, res_mat, res_enc, res_hog, res_mie, res_exm, res_var;

--SELECT 
select * into operaciones_ope_claves_respuestas.claves244
  from encu.claves
  where cla_ope='etoi244' and cla_for in ('A1','S1')
  order by cla_ope, cla_for, cla_mat, cla_enc, cla_hog, cla_mie, cla_exm;
--SELECT 
select *  into operaciones_ope_claves_respuestas.respuestas244
  from encu.respuestas
  where res_ope='etoi244' and res_for in ('A1','S1')
  order by res_ope, res_for, res_mat, res_enc, res_hog, res_mie, res_exm, res_var;
----



--obtener metadatos de operativos anteriores eah2024

set role tedede_php;
CREATE SCHEMA operaciones_metadatos_eah2024
  AUTHORIZATION tedede_php;

select * into operaciones_metadatos_eah2024.bloques2024
  from encu.bloques
  where blo_ope='eah2024' and  blo_for in ('A1', 'S1')
  order by blo_for, blo_blo; 


select * into operaciones_metadatos_eah2024.preguntas2024
  from encu.preguntas
  where pre_ope='eah2024' and pre_for in ('A1', 'S1')
  order by pre_pre; 

select * into operaciones_metadatos_eah2024.con_opc2024
  from encu.con_opc
  where conopc_ope='eah2024' 
  order by conopc_conopc;

select * into operaciones_metadatos_eah2024.variableseah2024
  from encu.variables
  where var_ope='eah2024' and var_for in ('A1', 'S1')
  order by var_var;
  

--para etoi244 tomo metadatos desde el esquema encu_anterior 
 
  
----carga de metadatos

update encu.operativos set ope_ope_anterior='etoi244' where ope_ope='etoi251';
INSERT INTO encu.operativos(
            ope_ope, ope_nombre, ope_ope_anterior, ope_en_campo, ope_tlg)
    VALUES      
    ( 'etoi244', 'Encuesta de Trabajo, Ocupación e Ingreso 2024 4', 'eah2024', false, 1),
    ( 'eah2024', 'Encuesta Anual de Hogares 2024', '', false, 1);
INSERT INTO encu.formularios(
            for_ope, for_for, for_nombre, for_tlg) values         
            ('eah2024', 'A1', 'Vivienda', 1),
            ('eah2024', 'S1', 'Carátula - componentes del hogar', 1),
            ('etoi244', 'A1', 'Vivienda', 1),
            ('etoi244', 'S1', 'Carátula - componentes del hogar', 1);

insert into encu.ua 
select ua_ope, ua_ua, ua_prefijo_respuestas, ua_sufijo_tablas, ua_pk, 
       1
    from encu_anterior.ua 
    where ua_ope='etoi244'
union
select 'eah2024', ua_ua, ua_prefijo_respuestas, ua_sufijo_tablas, ua_pk, 
       1
    from operaciones_metadatos.ua
    where ua_ope='etoi251';

INSERT INTO encu.matrices(
            mat_ope, mat_for, mat_mat, mat_texto, mat_ua, mat_ultimo_campo_pk, 
            mat_orden, mat_blanquear_clave_al_retroceder, mat_tlg)

select      mat_ope, mat_for, mat_mat, mat_texto, mat_ua, mat_ultimo_campo_pk, 
            mat_orden, mat_blanquear_clave_al_retroceder, 1 
    from encu_anterior.matrices 
    where mat_ope = 'etoi244' and mat_for in ('A1', 'S1')
    
union 

select      'eah2024', mat_for, mat_mat, mat_texto, mat_ua, mat_ultimo_campo_pk, 
            mat_orden, mat_blanquear_clave_al_retroceder, 1 
    from operaciones_metadatos.matrices 
    where mat_ope = 'etoi251' and mat_for in ('A1', 'S1');    

INSERT INTO encu.bloques(
            blo_ope, blo_for, blo_blo, blo_mat, blo_texto, blo_incluir_mat, 
            blo_orden, blo_aclaracion, blo_tlg)

select blo_ope, blo_for, blo_blo, blo_mat, blo_texto, blo_incluir_mat, 
            blo_orden, blo_aclaracion, 1 
    from  encu_anterior.bloques
    where blo_ope ='etoi244' and blo_for in ('A1', 'S1')
union 
select blo_ope, blo_for, blo_blo, blo_mat, blo_texto, blo_incluir_mat, 
            blo_orden, blo_aclaracion, 1 
    from operaciones_metadatos_eah2024.bloques
    where blo_ope ='eah2024' and blo_for in ('A1', 'S1')
;


INSERT INTO encu.preguntas(
            pre_ope, pre_pre, pre_texto, pre_abreviado, pre_for, pre_mat, 
            pre_blo, pre_aclaracion, pre_destino, pre_desp_opc, pre_desp_nombre, 
            pre_orden, pre_aclaracion_superior, pre_tlg)
select pre_ope, pre_pre, pre_texto, pre_abreviado, pre_for, pre_mat, 
            pre_blo, pre_aclaracion, pre_destino, pre_desp_opc, pre_desp_nombre, 
            pre_orden, pre_aclaracion_superior, 1 
    from encu_anterior.preguntas
    where pre_ope ='etoi244' and pre_for in ('A1', 'S1')
union
select pre_ope, pre_pre, pre_texto, pre_abreviado, pre_for, pre_mat, 
            pre_blo, pre_aclaracion, pre_destino, pre_desp_opc, pre_desp_nombre, 
            pre_orden, pre_aclaracion_superior, 1 
    from operaciones_metadatos_eah2024.preguntas
    where pre_ope ='eah2024' and pre_for in ('A1', 'S1');

INSERT INTO encu.con_opc(
            conopc_ope, conopc_conopc, conopc_texto, conopc_despliegue, conopc_tlg)

select conopc_ope, conopc_conopc, conopc_texto, conopc_despliegue, 1
    from encu_anterior.con_opc
    where conopc_ope = 'etoi244' 
union
select conopc_ope, conopc_conopc, conopc_texto, conopc_despliegue, 1
    from operaciones_metadatos_eah2024.con_opc
    where conopc_ope = 'eah2024' ;

INSERT INTO encu.variables(
            var_ope, var_for, var_mat, var_pre, var_var, var_texto, var_aclaracion, 
            var_conopc, var_conopc_texto, var_tipovar, var_destino, var_subordinada_var, 
            var_subordinada_opcion, var_desp_nombre, var_expresion_habilitar, 
            var_optativa, var_editable_por, var_orden, var_nsnc_atipico, 
            var_mejor_de_pregunta, var_maximo, var_minimo, var_advertencia_sup, 
            var_advertencia_inf, var_destino_nsnc, var_calculada, var_nombre_dr, 
            var_tlg)
select      var_ope, var_for, var_mat, var_pre, var_var, var_texto, var_aclaracion, 
            var_conopc, var_conopc_texto, var_tipovar, var_destino, var_subordinada_var, 
            var_subordinada_opcion, var_desp_nombre, var_expresion_habilitar, 
            var_optativa, var_editable_por, var_orden, var_nsnc_atipico, 
            var_mejor_de_pregunta, var_maximo, var_minimo, var_advertencia_sup, 
            var_advertencia_inf, var_destino_nsnc, var_calculada, var_nombre_dr, 
            1 
    from encu_anterior.variables
    where var_ope ='etoi244' and var_for in ('A1', 'S1')
 union
select      var_ope, var_for, var_mat, var_pre, var_var, var_texto, var_aclaracion, 
            var_conopc, var_conopc_texto, var_tipovar, var_destino, var_subordinada_var, 
            var_subordinada_opcion, var_desp_nombre, var_expresion_habilitar, 
            var_optativa, var_editable_por, var_orden, var_nsnc_atipico, 
            var_mejor_de_pregunta, var_maximo, var_minimo, var_advertencia_sup, 
            var_advertencia_inf, var_destino_nsnc, var_calculada, var_nombre_dr, 
            1 
    from operaciones_metadatos_eah2024.variables
    where var_ope ='eah2024' and var_for in ('A1', 'S1');
    
----casos a considerar
set role tedede_php;
select pla_participacion, pla_rotaci_n_eah, pla_rotaci_n_etoi, count(*)  
  from encu.plana_tem_   
  where pla_dominio=3 and pla_participacion in (2,3)
    and pla_semana  between 1 and 4
  group by pla_participacion, pla_rotaci_n_eah, pla_rotaci_n_etoi
  order by pla_participacion;
--  2	1	2	300
--  3	1	1	400

set role tedede_php;
alter table encu.claves disable trigger claves_ins_trg;
 
insert into encu.claves (cla_ope, cla_for, cla_mat, cla_enc, 
                         cla_hog, cla_mie, cla_exm, cla_tlg)
  select cla_ope, cla_for, cla_mat, cla_enc, 
       cla_hog, cla_mie, cla_exm, 1
--select distinct  cla_ope,  cla_enc --400
    from operaciones_ope_claves_respuestas.claves2024
    where cla_enc in (select pla_enc from encu.plana_tem_  
                          where pla_dominio=3 and pla_participacion in (3)
    and pla_semana  between 1 and 4)
        and cla_ope in ('eah2024') and cla_for in ('A1', 'S1')
union
select cla_ope, cla_for, cla_mat, cla_enc, 
       cla_hog, cla_mie, cla_exm, 1
--select distinct  cla_ope,  cla_enc -700
    from operaciones_ope_claves_respuestas.claves244
    where cla_enc in (select pla_enc from encu.plana_tem_  
                          where pla_dominio=3 and pla_participacion in (2,3)  and pla_rotaci_n_eah=1
    and pla_semana  between 1 and 4)
        and cla_ope in ('etoi244') and cla_for in ('A1', 'S1');    
--INSERT 0 3083

INSERT INTO encu.respuestas(
            res_ope, res_for, res_mat, res_enc, res_hog, res_mie, res_exm, 
            res_var, res_valor, res_valesp, res_valor_con_error, res_estado, 
            res_anotaciones_marginales, res_tlg)
select res_ope, res_for, res_mat, res_enc, res_hog, res_mie, res_exm, --
       res_var, res_valor, res_valesp, res_valor_con_error, res_estado, 
       res_anotaciones_marginales, 1         
--select distinct  res_ope,  res_enc -- 400
    from operaciones_ope_claves_respuestas.respuestas2024
    where res_enc in (select pla_enc from encu.plana_tem_  
                          where pla_dominio=3 and pla_participacion in (3)
    and pla_semana  between 1 and 4)
        and res_ope in ('eah2024') and res_for in ('A1', 'S1')
union
select res_ope, res_for, res_mat, res_enc, res_hog, res_mie, res_exm, --
       res_var, res_valor, res_valesp, res_valor_con_error, res_estado, 
       res_anotaciones_marginales, 1         
--select distinct  res_ope,  res_enc --  700
    from operaciones_ope_claves_respuestas.respuestas244
    where res_enc in (select pla_enc from encu.plana_tem_  
                          where pla_dominio=3 and pla_participacion in (2,3)  and pla_rotaci_n_eah=1
    and pla_semana  between 1 and 4)
        and res_ope in ('etoi244') and res_for in ('A1', 'S1');
--INSERT 0 55447
alter table encu.claves enable trigger claves_ins_trg; 

--comprobacion
select res_ope,res_enc, count(*) -- 1100 filas 800+300
from encu.respuestas
where res_ope <> 'etoi251' and res_enc 
in (select pla_enc from encu.plana_tem_  where pla_dominio=3 --and  pla_participacion=2
    and pla_semana  between 1 and 4)
group by 1,2
order by 1,2;

select cla_ope,cla_enc, count(*) ----1100 filas
from encu.claves
where cla_ope <> 'etoi251'
and cla_enc in (select pla_enc from encu.plana_tem_  where pla_dominio=3  --and pla_participacion=2
    and pla_semana  between 1 and 4)
group by 1,2
order by 1,2;

select distinct res_ope, res_enc, res_hog,res_for,res_mat, res_valor
--,count(*) --filas --1108 filas
from encu.respuestas
where res_ope <> 'etoi251' and res_var='s1a1_obs' --and res_hog >1
--group by 1,2,3,4,5
--having count(*) >1

/*
----
SEGUNDA TANDA CUANDO LO SOLICITEN
*/
-- SEGUNDA ETAPA
--CARGA SEMANAS DE 5 A 12 
SET ROLE tedede_php;
--Traemos la información NUEVAMENTE de claves y respuestas del último  operativo anterior
---claves y respuestas
drop table if exists operaciones_ope_claves_respuestas.claves244;
drop table if exists operaciones_ope_claves_respuestas.respuestas244;
--SELECT 
select * into operaciones_ope_claves_respuestas.claves244
  from encu.claves
  where cla_ope='etoi244' and cla_for in ('A1','S1')
  order by cla_ope, cla_for, cla_mat, cla_enc, cla_hog, cla_mie, cla_exm;
--SELECT 
select *  into operaciones_ope_claves_respuestas.respuestas244
  from encu.respuestas
  where res_ope='etoi244' and res_for in ('A1','S1')
  order by res_ope, res_for, res_mat, res_enc, res_hog, res_mie, res_exm, res_var;
  
-----
----carga de semanas 5 a 12
 --casos
set role tedede_php;
select pla_participacion, pla_rotaci_n_eah, pla_rotaci_n_etoi, count(*)  
  from encu.plana_tem_   
  where pla_dominio=3 and pla_participacion in (2,3)
    and pla_semana between 5 and 12
  group by pla_participacion, pla_rotaci_n_eah, pla_rotaci_n_etoi
  order by pla_participacion;


set role tedede_php;
alter table encu.claves disable trigger claves_ins_trg;

insert into encu.claves (cla_ope, cla_for, cla_mat, cla_enc, 
                         cla_hog, cla_mie, cla_exm, cla_tlg)

select cla_ope, cla_for, cla_mat, cla_enc, 
       cla_hog, cla_mie, cla_exm, 1
--select distinct  cla_ope,  cla_enc --600
    from operaciones_ope_claves_respuestas.claves2024
    where cla_enc in (select pla_enc from encu.plana_tem_  
                          where pla_dominio=3 and pla_participacion in (3)
    and pla_semana  between 5 and 12)
        and cla_ope in ('eah2024') and cla_for in ('A1', 'S1')
union
select cla_ope, cla_for, cla_mat, cla_enc, 
       cla_hog, cla_mie, cla_exm, 1
--select distinct  cla_ope,  cla_enc --1300
    from operaciones_ope_claves_respuestas.claves244
    where cla_enc in (select pla_enc from encu.plana_tem_  
                          where pla_dominio=3 and pla_participacion in (2,3)  and pla_rotaci_n_eah=1
    and pla_semana  between 5 and 12)
        and cla_ope in ('etoi244') and cla_for in ('A1', 'S1');    

--INSERT 0 5402
--
INSERT INTO encu.respuestas(
            res_ope, res_for, res_mat, res_enc, res_hog, res_mie, res_exm, 
            res_var, res_valor, res_valesp, res_valor_con_error, res_estado, 
            res_anotaciones_marginales, res_tlg)
select res_ope, res_for, res_mat, res_enc, res_hog, res_mie, res_exm, --
       res_var, res_valor, res_valesp, res_valor_con_error, res_estado, 
       res_anotaciones_marginales, 1         
--select distinct  res_ope,  res_enc --  600 casos
    from operaciones_ope_claves_respuestas.respuestas2024
    where res_enc in (select pla_enc from encu.plana_tem_  
                          where pla_dominio=3 and pla_participacion in (3)
    and pla_semana  between 5 and 12)
        and res_ope in ('eah2024') and res_for in ('A1', 'S1')
union
select res_ope, res_for, res_mat, res_enc, res_hog, res_mie, res_exm, --
       res_var, res_valor, res_valesp, res_valor_con_error, res_estado, 
       res_anotaciones_marginales, 1         
--select distinct  res_ope,  res_enc --1300
    from operaciones_ope_claves_respuestas.respuestas244
    where res_enc in (select pla_enc from encu.plana_tem_  
                          where pla_dominio=3 and pla_participacion in (2,3)  and pla_rotaci_n_eah=1
    and pla_semana  between 5 and 12)
        and res_ope in ('etoi244') and res_for in ('A1', 'S1');
--INSERT 0 96873
alter table encu.claves enable trigger claves_ins_trg; 


 --comprobacion
select res_ope,res_enc, count(*) --  1900
from encu.respuestas
where res_ope <> 'etoi251' and res_enc 
in (select pla_enc from encu.plana_tem_  where pla_dominio=3 --and  pla_participacion=2
    and pla_semana  between 5 and 12)
group by 1,2
order by 1,2;

select cla_ope,cla_enc, count(*) ----1900
from encu.claves
where cla_ope <> 'etoi251'
and cla_enc in (select pla_enc from encu.plana_tem_  where pla_dominio=3  --and pla_participacion=2
    and pla_semana  between 5 and 12)
group by 1,2
order by 1,2;

select distinct res_ope, res_enc, res_hog,res_for,res_mat, res_valor
--,count(*) --filas --1922 filas en total todas las semanas
from encu.respuestas
where res_ope <> 'etoi251' and res_var='s1a1_obs' and res_enc in  
  (select pla_enc from encu.plana_tem_  where pla_dominio=3  --and pla_participacion=2
    and pla_semana  between 5 and 12)
--and res_hog >1
--group by 1,2,3,4,5
--having count(*) >1

 

/*ejemplo de  un operativo anterior donde nos pidieron actualizar observaciones anteriores
 --ejemplo EN ETOI242 si llegaran a pedir actualización DE algunas  SEMANAS 5 Y 6
 --traigo de nuevo la info de la etoi241 y restauro el backup en etoi242
drop table if exists operaciones_ope_claves_respuestas.claves241;
drop table if exists operaciones_ope_claves_respuestas.respuestas241;

---claves y respuestas
set role tedede_php;
--SELECT 
select * into operaciones_ope_claves_respuestas.claves242
  from encu.claves
  where cla_ope='etoi242' and cla_for in ('A1','S1')
  order by cla_ope, cla_for, cla_mat, cla_enc, cla_hog, cla_mie, cla_exm;
--SELECT 
select *  into operaciones_ope_claves_respuestas.respuestas242
  from encu.respuestas
  where res_ope='etoi242' and res_for in ('A1','S1')
  order by res_ope, res_for, res_mat, res_enc, res_hog, res_mie, res_exm, res_var;
  
--Consulta para determinar que borrar  
select * --18097 --9565 en semana 6
from encu.respuestas
where res_ope <>'etoi242' 
and res_enc in  (select pla_enc from encu.plana_tem_ where pla_semana in (5,6));

select * --1348 --719 en semana 6
from encu.claves
where cla_ope <>'etoi242'
and cla_enc in  (select pla_enc from encu.plana_tem_ where pla_semana in (5,6));

select pla_estado, pla_dominio --280 filas
from encu.plana_tem_
where pla_semana in (5) and pla_estado>19;
--280 casos 

select pla_estado, pla_dominio --0 filas
from encu.plana_tem_
where pla_semana in (6) and pla_estado>19;

--borro solo semana 6 porque el resto está cargado
set role tedede_php;
select pla_participacion, pla_rotaci_n_eah, pla_rotaci_n_etoi, count(*)  
  from encu.plana_tem_   
  where pla_dominio=3 and pla_participacion in (2,3)
    and pla_semana in (6)
  group by pla_participacion, pla_rotaci_n_eah, pla_rotaci_n_etoi
  order by pla_participacion;
  
2    1    2    80         --150  en semana 5 230
3    1    1    80         --40 en semana 5 120

--delete --
    --select * 
    --select distinct res_ope,  res_enc -- 9565
    from encu.respuestas
    where res_enc in (select pla_enc  from encu.plana_tem_   
                        where pla_dominio=3 and pla_participacion in (2,3)
                         and pla_semana in (6))
        and res_ope in ('eah2023','etoi241') and res_for in ('A1', 'S1');

-- -- delete
    --select * --719
    --select distinct cla_ope, cla_enc  --  240 filas 
    from encu.claves
    where cla_enc in (select pla_enc from encu.plana_tem_   
                        where pla_dominio=3 and pla_participacion in (2,3)
                         and pla_semana in (6))
        and cla_ope in ('eah2023', 'etoi241') and cla_for in ('A1', 'S1');
*/
