SET ROLE tedede_php;

create schema operaciones_ope_claves_respuestas;
--Traemos la información de claves y respuestas 
---claves y respuestas

drop table if exists operaciones_ope_claves_respuestas.claves262;
drop table if exists operaciones_ope_claves_respuestas.respuestas262;
drop table if exists operaciones_ope_claves_respuestas.claves261;
drop table if exists operaciones_ope_claves_respuestas.respuestas261;
drop table if exists operaciones_ope_claves_respuestas.claves2024;
drop table if exists operaciones_ope_claves_respuestas.respuestas2024;
drop table if exists operaciones_ope_claves_respuestas.claves2025;
drop table if exists operaciones_ope_claves_respuestas.respuestas2025;


---claves y respuestas
set role tedede_php;
--SELECT 
select * into operaciones_ope_claves_respuestas.claves261
  from encu.claves
  where cla_ope='etoi261' and cla_for in ('A1','S1')
  order by cla_ope, cla_for, cla_mat, cla_enc, cla_hog, cla_mie, cla_exm;
--SELECT 
select *  into operaciones_ope_claves_respuestas.respuestas261
  from encu.respuestas
  where res_ope='etoi261' and res_for in ('A1','S1')
  order by res_ope, res_for, res_mat, res_enc, res_hog, res_mie, res_exm, res_var;

--SELECT 
select * into operaciones_ope_claves_respuestas.claves262
  from encu.claves
  where cla_ope='etoi262' and cla_for in ('A1','S1')
  order by cla_ope, cla_for, cla_mat, cla_enc, cla_hog, cla_mie, cla_exm;
--SELECT 
select *  into operaciones_ope_claves_respuestas.respuestas262
  from encu.respuestas
  where res_ope='etoi262' and res_for in ('A1','S1')
  order by res_ope, res_for, res_mat, res_enc, res_hog, res_mie, res_exm, res_var;
 
 --SELECT 
select * into operaciones_ope_claves_respuestas.claves2025
  from encu.claves
  where cla_ope='eah2025' and cla_for in ('A1','S1')
  order by cla_ope, cla_for, cla_mat, cla_enc, cla_hog, cla_mie, cla_exm;
--SELECT 
select *  into operaciones_ope_claves_respuestas.respuestas2025
  from encu.respuestas
  where res_ope='eah2025' and res_for in ('A1','S1')
  order by res_ope, res_for, res_mat, res_enc, res_hog, res_mie, res_exm, res_var;  

 
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
----

--en etoi262 sacamos la info de estos metadatos.
 
--
set role tedede_php;
CREATE SCHEMA operaciones_ope_ant
  AUTHORIZATION tedede_php;

select * into operaciones_ope_ant.bloques262
  from encu.bloques
  where blo_ope='etoi262' and  blo_for in ('A1', 'S1')
  order by blo_for, blo_blo; 


select * into operaciones_ope_ant.preguntas262
  from encu.preguntas
  where pre_ope='etoi262' and pre_for in ('A1', 'S1')
  order by pre_pre; 

select * into operaciones_ope_ant.con_opc262
  from encu.con_opc
  where conopc_ope='etoi262' 
  order by conopc_conopc;

select * into operaciones_ope_ant.variablesetoi262
  from encu.variables
  where var_ope='etoi262' and var_for in ('A1', 'S1')
  order by var_var;
  
 --etoi261

 
--
set role tedede_php;
CREATE SCHEMA operaciones_ope_ant
  AUTHORIZATION tedede_php;

select * into operaciones_ope_ant.bloques261
  from encu.bloques
  where blo_ope='etoi261' and  blo_for in ('A1', 'S1')
  order by blo_for, blo_blo; 

select * into operaciones_ope_ant.preguntas261
  from encu.preguntas
  where pre_ope='etoi261' and pre_for in ('A1', 'S1')
  order by pre_pre; 

select * into operaciones_ope_ant.con_opc261
  from encu.con_opc
  where conopc_ope='etoi261' 
  order by conopc_conopc;

select * into operaciones_ope_ant.variablesetoi261
  from encu.variables
  where var_ope='etoi261' and var_for in ('A1', 'S1')
  order by var_var;
 
 
--para eah2024
--
set role tedede_php;
CREATE SCHEMA operaciones_ope_ant
  AUTHORIZATION tedede_php;

select * into operaciones_ope_ant.bloques2024
  from encu.bloques
  where blo_ope='eah2024' and  blo_for in ('A1', 'S1')
  order by blo_for, blo_blo; 


select * into operaciones_ope_ant.preguntas2024
  from encu.preguntas
  where pre_ope='eah2024' and pre_for in ('A1', 'S1')
  order by pre_pre; 

select * into operaciones_ope_ant.con_opc2024
  from encu.con_opc
  where conopc_ope='eah2024' 
  order by conopc_conopc;

select * into operaciones_ope_ant.variables2024
  from encu.variables
  where var_ope='eah2024' and var_for in ('A1', 'S1')
  order by var_var;


----carga de metadatos

update encu.operativos set ope_ope_anterior='eah2025_1' where ope_ope='eah2026'; 
INSERT INTO encu.operativos(
            ope_ope, ope_nombre, ope_ope_anterior, ope_en_campo, ope_tlg)
    VALUES 
    ('eah2025_1', 'Operativos ETOI262 y EAH2025', 'eah2025_2', false, 1),
    ('eah2025_2', 'Operativos ETOI261 y EAH2024', '', false, 1);
INSERT INTO encu.formularios(
            for_ope, for_for, for_nombre, for_tlg) values
            ('eah2025_1', 'A1', 'Vivienda', 1),
            ('eah2025_1', 'S1', 'Carátula - componentes del hogar', 1),
            ('eah2025_2', 'A1', 'Vivienda', 1),
            ('eah2025_2', 'S1', 'Carátula - componentes del hogar', 1);
--4 casos
insert into encu.ua 
select 'eah2025_1', ua_ua, ua_prefijo_respuestas, ua_sufijo_tablas, ua_pk, 
       1
    from encu_anterior.ua 
    where ua_ope='eah2025'
union
select 'eah2025_2', ua_ua, ua_prefijo_respuestas, ua_sufijo_tablas, ua_pk, 
       1
    from encu_anterior.ua 
    where ua_ope='eah2025';
--8 casos
INSERT INTO encu.matrices(
            mat_ope, mat_for, mat_mat, mat_texto, mat_ua, mat_ultimo_campo_pk, 
            mat_orden, mat_blanquear_clave_al_retroceder, mat_tlg)

select     'eah2025_1', mat_for, mat_mat, mat_texto, mat_ua, mat_ultimo_campo_pk, 
            mat_orden, mat_blanquear_clave_al_retroceder, 1 
    from encu_anterior.matrices 
    where mat_ope = 'eah2025' and mat_for in ('A1', 'S1')
union    
select      'eah2025_2', mat_for, mat_mat, mat_texto, mat_ua, mat_ultimo_campo_pk, 
            mat_orden, mat_blanquear_clave_al_retroceder, 1 
    from encu_anterior.matrices 
    where mat_ope = 'eah2025' and mat_for in ('A1', 'S1');    
--6 casos

INSERT INTO encu.bloques(
            blo_ope, blo_for, blo_blo, blo_mat, blo_texto, blo_incluir_mat, 
            blo_orden, blo_aclaracion, blo_tlg)
select 'eah2025_1', blo_for, blo_blo, blo_mat, blo_texto, blo_incluir_mat, 
            blo_orden, blo_aclaracion, 1 
    from  encu_anterior.bloques
    where blo_ope ='eah2025' and blo_for in ('A1', 'S1')
--insert 10
--union
INSERT INTO encu.bloques(
            blo_ope, blo_for, blo_blo, blo_mat, blo_texto, blo_incluir_mat, 
            blo_orden, blo_aclaracion, blo_tlg)

select 'eah2025_1', blo_for, blo_blo, blo_mat, blo_texto, blo_incluir_mat, 
            blo_orden, blo_aclaracion, 1 
    from  operaciones_ope_ant.bloques262
    where blo_ope ='etoi262' and blo_for in ('A1', 'S1') and blo_blo not in ( select blo_blo from encu.bloques 
	where blo_ope='eah2025_1' )
--0 casos	 

INSERT INTO encu.bloques(
            blo_ope, blo_for, blo_blo, blo_mat, blo_texto, blo_incluir_mat, 
            blo_orden, blo_aclaracion, blo_tlg)

select 'eah2025_2', blo_for, blo_blo, blo_mat, blo_texto, blo_incluir_mat, 
            blo_orden, blo_aclaracion, 1 
    from  operaciones_ope_ant.bloques2024
    where blo_ope ='eah2024' and blo_for in ('A1', 'S1')  and blo_blo not in ( select blo_blo from encu.bloques 
	where blo_ope='eah2025_2' )
--12filas	

--union 
INSERT INTO encu.bloques(
            blo_ope, blo_for, blo_blo, blo_mat, blo_texto, blo_incluir_mat, 
            blo_orden, blo_aclaracion, blo_tlg)

select 'eah2025_2', blo_for, blo_blo, blo_mat, blo_texto, blo_incluir_mat, 
            blo_orden, blo_aclaracion, 1 
    from  operaciones_ope_ant.bloques261
    where blo_ope ='etoi261' and blo_for in ('A1', 'S1') and blo_blo not in ( select blo_blo from encu.bloques 
	where blo_ope='eah2025_2' )
;

--INSERT 0 0
/*control*/
select *
from encu.bloques
where blo_ope <>'eah2026'
order by blo_blo --22 filas

INSERT INTO encu.preguntas(
            pre_ope, pre_pre, pre_texto, pre_abreviado, pre_for, pre_mat, 
            pre_blo, pre_aclaracion, pre_destino, pre_desp_opc, pre_desp_nombre, 
            pre_orden, pre_aclaracion_superior, pre_tlg)
select 'eah2025_1', pre_pre, pre_texto, pre_abreviado, pre_for, pre_mat, 
            pre_blo, pre_aclaracion, pre_destino, pre_desp_opc, pre_desp_nombre, 
            pre_orden, pre_aclaracion_superior, 1 
    from encu_anterior.preguntas
    where pre_ope ='eah2025' and pre_for in ('A1', 'S1');
	--46 filas
	
--union
INSERT INTO encu.preguntas(
            pre_ope, pre_pre, pre_texto, pre_abreviado, pre_for, pre_mat, 
            pre_blo, pre_aclaracion, pre_destino, pre_desp_opc, pre_desp_nombre, 
            pre_orden, pre_aclaracion_superior, pre_tlg)

select 'eah2025_1', pre_pre, pre_texto, pre_abreviado, pre_for, pre_mat, 
            pre_blo, pre_aclaracion, pre_destino, pre_desp_opc, pre_desp_nombre, 
            pre_orden, pre_aclaracion_superior, 1 
    from operaciones_ope_ant.preguntas262
    where pre_ope ='etoi262' and pre_for in ('A1', 'S1') 
	and pre_pre not in ( select pre_pre from encu.preguntas where pre_ope='eah2025_1')	;
--union
--4filas
INSERT INTO encu.preguntas(
            pre_ope, pre_pre, pre_texto, pre_abreviado, pre_for, pre_mat, 
            pre_blo, pre_aclaracion, pre_destino, pre_desp_opc, pre_desp_nombre, 
            pre_orden, pre_aclaracion_superior, pre_tlg)
select 'eah2025_2', pre_pre, pre_texto, pre_abreviado, pre_for, pre_mat, 
            pre_blo, pre_aclaracion, pre_destino, pre_desp_opc, pre_desp_nombre, 
            pre_orden, pre_aclaracion_superior, 1 
    from operaciones_ope_ant.preguntas2024
    where pre_ope ='eah2024' and pre_for in ('A1', 'S1');
--47 filas	
--union	
INSERT INTO encu.preguntas(
            pre_ope, pre_pre, pre_texto, pre_abreviado, pre_for, pre_mat, 
            pre_blo, pre_aclaracion, pre_destino, pre_desp_opc, pre_desp_nombre, 
            pre_orden, pre_aclaracion_superior, pre_tlg)

select 'eah2025_2', pre_pre, pre_texto, pre_abreviado, pre_for, pre_mat, 
            pre_blo, pre_aclaracion, pre_destino, pre_desp_opc, pre_desp_nombre, 
            pre_orden, pre_aclaracion_superior, 1 
    from operaciones_ope_ant.preguntas261
    where pre_ope ='etoi261' and pre_for in ('A1', 'S1')
	and pre_pre not in ( select pre_pre from encu.preguntas where pre_ope='eah2025_2')	;
--0filas

INSERT INTO encu.con_opc(
            conopc_ope, conopc_conopc, conopc_texto, conopc_despliegue, conopc_tlg)
select 'eah2025_1', conopc_conopc, conopc_texto, conopc_despliegue, 1
    from encu_anterior.con_opc
    where conopc_ope = 'eah2025' 
--291 filas
INSERT INTO encu.con_opc(
            conopc_ope, conopc_conopc, conopc_texto, conopc_despliegue, conopc_tlg)

select 'eah2025_1', conopc_conopc, conopc_texto, conopc_despliegue, 1
    from operaciones_ope_ant.con_opc262
    where conopc_ope = 'etoi262' 
	and conopc_conopc not in ( select conopc_conopc from encu.con_opc where conopc_ope='eah2025_1')	;
--INSERT 0 2
--union
INSERT INTO encu.con_opc(
            conopc_ope, conopc_conopc, conopc_texto, conopc_despliegue, conopc_tlg)

select 'eah2025_2', conopc_conopc, conopc_texto, conopc_despliegue, 1
    from operaciones_ope_ant.con_opc2024
    where conopc_ope = 'eah2024' ;
--INSERT 0 300	
--union
INSERT INTO encu.con_opc(
           conopc_ope, conopc_conopc, conopc_texto, conopc_despliegue, conopc_tlg)

select 'eah2025_2', conopc_conopc, conopc_texto, conopc_despliegue, 1
    from operaciones_ope_ant.con_opc261
    where conopc_ope = 'etoi261' 
	and conopc_conopc not in ( select conopc_conopc from encu.con_opc where conopc_ope='eah2025_2')	;
--0 filas
INSERT INTO encu.variables(
            var_ope, var_for, var_mat, var_pre, var_var, var_texto, var_aclaracion, 
            var_conopc, var_conopc_texto, var_tipovar, var_destino, var_subordinada_var, 
            var_subordinada_opcion, var_desp_nombre, var_expresion_habilitar, 
            var_optativa, var_editable_por, var_orden, var_nsnc_atipico, 
            var_mejor_de_pregunta, var_maximo, var_minimo, var_advertencia_sup, 
            var_advertencia_inf, var_destino_nsnc, var_calculada, var_nombre_dr, 
            var_tlg)
select      'eah2025_1', var_for, var_mat, var_pre, var_var, var_texto, var_aclaracion, 
            var_conopc, var_conopc_texto, var_tipovar, var_destino, var_subordinada_var, 
            var_subordinada_opcion, var_desp_nombre, var_expresion_habilitar, 
            var_optativa, var_editable_por, var_orden, var_nsnc_atipico, 
            var_mejor_de_pregunta, var_maximo, var_minimo, var_advertencia_sup, 
            var_advertencia_inf, var_destino_nsnc, var_calculada, var_nombre_dr, 
            1 
    from encu_anterior.variables
    where var_ope ='eah2025' and var_for in ('A1', 'S1');
--53 filas 
-- union
INSERT INTO encu.variables(
            var_ope, var_for, var_mat, var_pre, var_var, var_texto, var_aclaracion, 
            var_conopc, var_conopc_texto, var_tipovar, var_destino, var_subordinada_var, 
            var_subordinada_opcion, var_desp_nombre, var_expresion_habilitar, 
            var_optativa, var_editable_por, var_orden, var_nsnc_atipico, 
            var_mejor_de_pregunta, var_maximo, var_minimo, var_advertencia_sup, 
            var_advertencia_inf, var_destino_nsnc, var_calculada, var_nombre_dr, 
            var_tlg)
 select  'eah2025_1', var_for, var_mat, var_pre, var_var, var_texto, var_aclaracion, 
            var_conopc, var_conopc_texto, var_tipovar, var_destino, var_subordinada_var, 
            var_subordinada_opcion, var_desp_nombre, var_expresion_habilitar, 
            var_optativa, var_editable_por, var_orden, var_nsnc_atipico, 
            var_mejor_de_pregunta, var_maximo, var_minimo, var_advertencia_sup, 
            var_advertencia_inf, var_destino_nsnc, var_calculada, var_nombre_dr, 
            1 
    from operaciones_ope_ant.variablesetoi262
    where var_ope ='etoi262' and var_for in ('A1', 'S1')
	  and var_var not in ( select var_var from encu.variables where var_ope='eah2025_1')	 ;
--INSERT 0 2  
--union 
INSERT INTO encu.variables(
            var_ope, var_for, var_mat, var_pre, var_var, var_texto, var_aclaracion, 
            var_conopc, var_conopc_texto, var_tipovar, var_destino, var_subordinada_var, 
            var_subordinada_opcion, var_desp_nombre, var_expresion_habilitar, 
            var_optativa, var_editable_por, var_orden, var_nsnc_atipico, 
            var_mejor_de_pregunta, var_maximo, var_minimo, var_advertencia_sup, 
            var_advertencia_inf, var_destino_nsnc, var_calculada, var_nombre_dr, 
            var_tlg)
select      'eah2025_2', var_for, var_mat, var_pre, var_var, var_texto, var_aclaracion, 
            var_conopc, var_conopc_texto, var_tipovar, var_destino, var_subordinada_var, 
            var_subordinada_opcion, var_desp_nombre, var_expresion_habilitar, 
            var_optativa, var_editable_por, var_orden, var_nsnc_atipico, 
            var_mejor_de_pregunta, var_maximo, var_minimo, var_advertencia_sup, 
            var_advertencia_inf, var_destino_nsnc, var_calculada, var_nombre_dr, 
            1 
    from operaciones_ope_ant.variables2024
    where var_ope ='eah2024' and var_for in ('A1', 'S1') ;
	--57 filas
--union
INSERT INTO encu.variables(
            var_ope, var_for, var_mat, var_pre, var_var, var_texto, var_aclaracion, 
            var_conopc, var_conopc_texto, var_tipovar, var_destino, var_subordinada_var, 
            var_subordinada_opcion, var_desp_nombre, var_expresion_habilitar, 
            var_optativa, var_editable_por, var_orden, var_nsnc_atipico, 
            var_mejor_de_pregunta, var_maximo, var_minimo, var_advertencia_sup, 
            var_advertencia_inf, var_destino_nsnc, var_calculada, var_nombre_dr, 
            var_tlg)
select      'eah2025_2', var_for, var_mat, var_pre, var_var, var_texto, var_aclaracion, 
            var_conopc, var_conopc_texto, var_tipovar, var_destino, var_subordinada_var, 
            var_subordinada_opcion, var_desp_nombre, var_expresion_habilitar, 
            var_optativa, var_editable_por, var_orden, var_nsnc_atipico, 
            var_mejor_de_pregunta, var_maximo, var_minimo, var_advertencia_sup, 
            var_advertencia_inf, var_destino_nsnc, var_calculada, var_nombre_dr, 
            1 
    from operaciones_ope_ant.variablesetoi261
    where var_ope ='etoi261' and var_for in ('A1', 'S1')
	   and var_var not in ( select var_var from encu.variables where var_ope='eah2025_2')	 ;
  --1 filas  
----casos a considerar
set role tedede_php;
select pla_participacion, pla_rotaci_n_eah, pla_rotaci_n_etoi, count(*)  
  from encu.plana_tem_   
  where pla_dominio=3 and pla_participacion in (2,3)
    and pla_semana  between 1 and 4
  group by pla_participacion, pla_rotaci_n_eah, pla_rotaci_n_etoi
  order by pla_participacion;
----
pla_participacion, pla_rotaci_n_eah, pla_rotaci_n_etoi
--2	1	2	300
--2	3	4	680
--3	2	4	700
--3	1	1	400
--carga de claves y respuestas--carga de claves y respuestas

set role tedede_php;

alter table encu.claves disable trigger claves_ins_trg;
 
insert into encu.claves (cla_ope, cla_for, cla_mat, cla_enc, 
                         cla_hog, cla_mie, cla_exm, cla_tlg)

select 'eah2025_2', cla_for, cla_mat, cla_enc, 
       cla_hog, cla_mie, cla_exm, 1
--select distinct  cla_ope,  cla_enc --400
    from operaciones_ope_claves_respuestas.claves261
    where cla_enc in (select pla_enc from encu.plana_tem_  
                          where pla_dominio=3 and pla_participacion in (3) and pla_rotaci_n_eah=1
    and pla_semana  between 1 and 4)
        and cla_ope in ('etoi261') and cla_for in ('A1', 'S1') --de las etoi
union
select 'eah2025_2', cla_for, cla_mat, cla_enc, 
       cla_hog, cla_mie, cla_exm, 1
--select distinct  cla_ope,  cla_enc --700
    from operaciones_ope_claves_respuestas.claves2024
    where cla_enc in (select pla_enc from encu.plana_tem_  
                          where pla_dominio=3 and pla_participacion in (3) and pla_rotaci_n_etoi=4
    and pla_semana  between 1 and 4)
        and cla_ope in ('eah2024') and cla_for in ('A1', 'S1');  
--INSERT 2743 
insert into encu.claves (cla_ope, cla_for, cla_mat, cla_enc, 
                         cla_hog, cla_mie, cla_exm, cla_tlg)
		
select 'eah2025_1', cla_for, cla_mat, cla_enc, 
       cla_hog, cla_mie, cla_exm, 1
--select distinct  cla_ope,  cla_enc --700
    from operaciones_ope_claves_respuestas.claves262
    where cla_enc in (select pla_enc from encu.plana_tem_  
                          where pla_dominio=3 and pla_participacion in (2,3) and pla_rotaci_n_eah=1
    and pla_semana  between 1 and 4)
        and cla_ope in ('etoi262') and cla_for in ('A1', 'S1') 
union
select 'eah2025_1', cla_for, cla_mat, cla_enc, 
       cla_hog, cla_mie, cla_exm, 1
--select distinct  cla_ope,  cla_enc --1380
    from operaciones_ope_claves_respuestas.claves2025
    where cla_enc in (select pla_enc from encu.plana_tem_  
                          where pla_dominio=3 and pla_participacion in (2,3) and pla_rotaci_n_etoi=4
    and pla_semana  between 1 and 4)
        and cla_ope in ('eah2025') and cla_for in ('A1', 'S1');    

--INSERT 5747
--
INSERT INTO encu.respuestas(
            res_ope, res_for, res_mat, res_enc, res_hog, res_mie, res_exm, 
            res_var, res_valor, res_valesp, res_valor_con_error, res_estado, 
            res_anotaciones_marginales, res_tlg)
select 'eah2025_2', res_for, res_mat, res_enc, res_hog, res_mie, res_exm, --20287
       res_var, res_valor, res_valesp, res_valor_con_error, res_estado, 
       res_anotaciones_marginales, 1         
--select distinct  res_ope,  res_enc --  400
    from operaciones_ope_claves_respuestas.respuestas261
    where res_enc in (select pla_enc from encu.plana_tem_  
                          where pla_dominio=3 and pla_participacion in (3) and pla_rotaci_n_eah=1
    and pla_semana  between 1 and 4)
        and res_ope in ('etoi261') and res_for in ('A1', 'S1')           --de las etoi
union
select 'eah2025_2', res_for, res_mat, res_enc, res_hog, res_mie, res_exm, --
       res_var, res_valor, res_valesp, res_valor_con_error, res_estado, 
       res_anotaciones_marginales, 1         
--select distinct  res_ope,  res_enc --  700
    from operaciones_ope_claves_respuestas.respuestas2024
    where res_enc in (select pla_enc from encu.plana_tem_  
                          where pla_dominio=3 and pla_participacion in (3)
                            and  ( /*pla_rotaci_n_eah  in (2,4) or pla_rotaci_n_etoi =3*/ pla_rotaci_n_etoi=4)   --verificar
    and pla_semana  between 1 and 4)
        and res_ope in ('eah2024') and res_for in ('A1', 'S1');
;
--INSERT 0 INSERT 0 54081

INSERT INTO encu.respuestas(
            res_ope, res_for, res_mat, res_enc, res_hog, res_mie, res_exm, 
            res_var, res_valor, res_valesp, res_valor_con_error, res_estado, 
            res_anotaciones_marginales, res_tlg)

select 'eah2025_1', res_for, res_mat, res_enc, res_hog, res_mie, res_exm, --37479
       res_var, res_valor, res_valesp, res_valor_con_error, res_estado, 
       res_anotaciones_marginales, 1         
--select distinct  res_ope,  res_enc --  700
    from operaciones_ope_claves_respuestas.respuestas262
    where res_enc in (select pla_enc from encu.plana_tem_  
                          where pla_dominio=3 and pla_participacion in (2,3) and pla_rotaci_n_eah=1
    and pla_semana  between 1 and 4)
        and res_ope in ('etoi262') and res_for in ('A1', 'S1')
union
select 'eah2025_1', res_for, res_mat, res_enc, res_hog, res_mie, res_exm, --
       res_var, res_valor, res_valesp, res_valor_con_error, res_estado, 
       res_anotaciones_marginales, 1 
--select distinct  res_ope,  res_enc --  1380
    from operaciones_ope_claves_respuestas.respuestas2025
    where res_enc in (select pla_enc from encu.plana_tem_  
                          where pla_dominio=3 and pla_participacion in (2,3)
                            and  ( /*pla_rotaci_n_eah  in (2,4) or pla_rotaci_n_etoi =3*/ pla_rotaci_n_etoi=4)   --verificar
    and pla_semana  between 1 and 4)
        and res_ope in ('eah2025') and res_for in ('A1', 'S1');


--INSERT 0 109587
alter table encu.claves enable trigger claves_ins_trg; 

--comprobacion
select 700 +400+1100+980;  --3180;
select res_ope,res_enc, count(*) --  filas 700 +400+1100+980= 3180;
from encu.respuestas
where res_ope <> 'eah2026'   and res_enc 
in (select pla_enc from encu.plana_tem_  where pla_dominio=3 --and  pla_participacion=2
    and pla_semana  between 1 and 4)
group by 1,2
order by 1,2;

select cla_ope,cla_enc, count(*) ----3180 filas
from encu.claves
where cla_ope <> 'eah2026'
and cla_enc in (select pla_enc from encu.plana_tem_  where pla_dominio=3  --and pla_participacion=2
    and pla_semana  between 1 and 4)
group by 1,2
order by 1,2;

select distinct res_ope, res_enc, res_hog,res_for,res_mat, res_valor   --3201 filas
--,count(*) --filas --
from encu.respuestas
where res_ope <> 'eah2026' and res_var='s1a1_obs' --and res_hog >1
--group by 1,2,3,4,5
--having count(*) >1
/*
select distinct res_ope, res_enc, res_hog,res_for,res_mat, res_valor   
--,count(*) --filas --1009 filas
from encu.respuestas
where res_ope <> 'eah2026' and res_var='s1a1_obs' and res_enc=504549 --and res_hog >1 
--group by 1,2,3,4,5
--having count(*) >1
select *
from operaciones_ope_claves_respuestas.respuestas2024
where res_ope='eah2024' and res_enc=504549

------
select pla_participacion,pla_enc,pla_semana,pla_rotaci_n_etoi,pla_rotaci_n_eah
from encu.plana_tem_
where pla_semana=1 and pla_participacion in (2,3) --and pla_rotaci_n_eah=1
and pla_enc=504549;
--3	504549	1	4	4
select *
from operaciones_ope_claves_respuestas.respuestas262
where res_ope ='etoi262' and res_enc=504549
*/

SET ROLE tedede_php;
--vuelvo a traer backup de claves y respuestas 262
----casos a considerar
set role tedede_php;
select pla_participacion, pla_rotaci_n_eah, pla_rotaci_n_etoi, count(*)  
  from encu.plana_tem_   
  where pla_dominio=3 and pla_participacion in (2,3)
    and pla_semana  between 5 and 12
  group by pla_participacion, pla_rotaci_n_eah, pla_rotaci_n_etoi
  order by pla_participacion;
--2	1	2	700
--2	3	4	1360
--3	2	4	1340
--3	1	1	600
set role tedede_php;

alter table encu.claves disable trigger claves_ins_trg;
 
insert into encu.claves (cla_ope, cla_for, cla_mat, cla_enc, 
                         cla_hog, cla_mie, cla_exm, cla_tlg)

select 'eah2025_2', cla_for, cla_mat, cla_enc, 
       cla_hog, cla_mie, cla_exm, 1
--select distinct  cla_ope,  cla_enc --600
    from operaciones_ope_claves_respuestas.claves261
    where cla_enc in (select pla_enc from encu.plana_tem_  
                          where pla_dominio=3 and pla_participacion in (3) and pla_rotaci_n_eah=1
    and pla_semana  between 5 and 12)
        and cla_ope in ('etoi261') and cla_for in ('A1', 'S1') --de las etoi
union
select 'eah2025_2', cla_for, cla_mat, cla_enc, 
       cla_hog, cla_mie, cla_exm, 1
--select distinct  cla_ope,  cla_enc --1340
    from operaciones_ope_claves_respuestas.claves2024
    where cla_enc in (select pla_enc from encu.plana_tem_  
                          where pla_dominio=3 and pla_participacion in (3) and pla_rotaci_n_etoi=4
    and pla_semana  between 5 and 12)
        and cla_ope in ('eah2024') and cla_for in ('A1', 'S1');  
--INSERT 0 5597	
insert into encu.claves (cla_ope, cla_for, cla_mat, cla_enc, 
                         cla_hog, cla_mie, cla_exm, cla_tlg)
		
select 'eah2025_1', cla_for, cla_mat, cla_enc, 
       cla_hog, cla_mie, cla_exm, 1
--select distinct  cla_ope,  cla_enc --1300
    from operaciones_ope_claves_respuestas.claves262
    where cla_enc in (select pla_enc from encu.plana_tem_  
                          where pla_dominio=3 and pla_participacion in (2,3) and pla_rotaci_n_eah=1
    and pla_semana  between 5 and 12)
        and cla_ope in ('etoi262') and cla_for in ('A1', 'S1') 
union
select 'eah2025_1', cla_for, cla_mat, cla_enc, 
       cla_hog, cla_mie, cla_exm, 1
--select distinct  cla_ope,  cla_enc --2700
    from operaciones_ope_claves_respuestas.claves2025
    where cla_enc in (select pla_enc from encu.plana_tem_  
                          where pla_dominio=3 and pla_participacion in (2,3) and pla_rotaci_n_etoi=4
    and pla_semana  between 5 and 12)
        and cla_ope in ('eah2025') and cla_for in ('A1', 'S1');    

--INSERT 0 11365
--
INSERT INTO encu.respuestas(
            res_ope, res_for, res_mat, res_enc, res_hog, res_mie, res_exm, 
            res_var, res_valor, res_valesp, res_valor_con_error, res_estado, 
            res_anotaciones_marginales, res_tlg)
select 'eah2025_2', res_for, res_mat, res_enc, res_hog, res_mie, res_exm, --
       res_var, res_valor, res_valesp, res_valor_con_error, res_estado, 
       res_anotaciones_marginales, 1         
--select distinct  res_ope,  res_enc --  600
    from operaciones_ope_claves_respuestas.respuestas261
    where res_enc in (select pla_enc from encu.plana_tem_  
                          where pla_dominio=3 and pla_participacion in (3) and pla_rotaci_n_eah=1
    and pla_semana  between 5 and 12)
        and res_ope in ('etoi261') and res_for in ('A1', 'S1')           --de las etoi
union
select 'eah2025_2', res_for, res_mat, res_enc, res_hog, res_mie, res_exm, --
       res_var, res_valor, res_valesp, res_valor_con_error, res_estado, 
       res_anotaciones_marginales, 1         
--select distinct  res_ope,  res_enc --  1340
    from operaciones_ope_claves_respuestas.respuestas2024
    where res_enc in (select pla_enc from encu.plana_tem_  
                          where pla_dominio=3 and pla_participacion in (3)
                            and  (  pla_rotaci_n_etoi=4)   --verificar
    and pla_semana  between 5 and 12)
        and res_ope in ('eah2024') and res_for in ('A1', 'S1');

--INSERT 0 108297

INSERT INTO encu.respuestas(
            res_ope, res_for, res_mat, res_enc, res_hog, res_mie, res_exm, 
            res_var, res_valor, res_valesp, res_valor_con_error, res_estado, 
            res_anotaciones_marginales, res_tlg)

select 'eah2025_1', res_for, res_mat, res_enc, res_hog, res_mie, res_exm, --
       res_var, res_valor, res_valesp, res_valor_con_error, res_estado, 
       res_anotaciones_marginales, 1         
--select distinct  res_ope,  res_enc --  1300
    from operaciones_ope_claves_respuestas.respuestas262
    where res_enc in (select pla_enc from encu.plana_tem_  
                          where pla_dominio=3 and pla_participacion in (2,3) and pla_rotaci_n_eah=1
    and pla_semana  between 5 and 12)
        and res_ope in ('etoi262') and res_for in ('A1', 'S1')
union
select 'eah2025_1', res_for, res_mat, res_enc, res_hog, res_mie, res_exm, --
       res_var, res_valor, res_valesp, res_valor_con_error, res_estado, 
       res_anotaciones_marginales, 1         
--select distinct  res_ope,  res_enc -- 2700
    from operaciones_ope_claves_respuestas.respuestas2025
    where res_enc in (select pla_enc from encu.plana_tem_  
                          where pla_dominio=3 and pla_participacion in (2,3)
                            and  ( pla_rotaci_n_etoi=4)   --verificar
    and pla_semana  between 5 and 12)
        and res_ope in ('eah2025') and res_for in ('A1', 'S1');

--INSERT 0 215704
alter table encu.claves enable trigger claves_ins_trg; 


--comprobacion
select res_ope,res_enc, count(*) -- 5940 filas  1340+600+1300+2700  ;
from encu.respuestas
where res_ope <> 'eah2026' and res_enc 
in (select pla_enc from encu.plana_tem_  where pla_dominio=3 --and  pla_participacion=2
    and pla_semana  between 5 and 12)
group by 1,2
order by 1,2;

select cla_ope,cla_enc, count(*) ----5940 filas
from encu.claves
where cla_ope <> 'eah2026'
and cla_enc in (select pla_enc from encu.plana_tem_  where pla_dominio=3  --and pla_participacion=2
    and pla_semana  between 5 and 12)
group by 1,2
order by 1,2;



select 1340+600+1300+2700  ;=5940
--2	1	2	700
--2	3	4	1360
--3	2	4	1340
--3	1	1	600
select distinct res_ope, res_enc, res_hog,res_for,res_mat, res_valor   --9187 filas
--,count(*) --filas --1009 filas
from encu.respuestas
where res_ope <> 'eah2026' and res_var='s1a1_obs' --and res_hog >1
--group by 1,2,3,4,5
--having count(*) >1


