--primera etapa borrado de planas

set search_path=encu;
drop table plana_i1_;
drop table plana_s1_p;
drop table plana_sup_;
drop table plana_a1_;
drop table plana_s1_;
drop table plana_tem_;

--segunda etapa borrar información de metadatos cargada
set search_path=encu;
delete from varcal_destinos;
delete from saltos;
delete from variables;
delete from preguntas;
delete from opciones;
delete from filtros;
delete from con_opc;
delete from bloques;
delete from matrices;
delete from ua;
delete from formularios;



--tercer etapa agregar información de los metadatos de la eah2025
{{{
INSERT INTO encu.formularios(
            for_ope, for_for, for_nombre, for_es_principal, for_orden, for_tlg, 
            for_tarea)
select dbo.ope_actual(), for_for, for_nombre, for_es_principal, for_orden, 1,
           for_tarea from operaciones_metadatos_eah2025.formularios;
/*OTRA*/ 
INSERT INTO encu.ua(
            ua_ope, ua_ua, ua_prefijo_respuestas, ua_sufijo_tablas, ua_pk, 
            ua_tlg)
select dbo.ope_actual(), ua_ua, ua_prefijo_respuestas, ua_sufijo_tablas, ua_pk,  1
           from operaciones_metadatos_eah2025.ua;    
/*OTRA*/ 
INSERT INTO encu.matrices(
            mat_ope, mat_for, mat_mat, mat_texto, mat_ua, mat_ultimo_campo_pk, 
            mat_orden, mat_blanquear_clave_al_retroceder, mat_tlg)
select dbo.ope_actual(), mat_for, mat_mat, mat_texto, mat_ua, mat_ultimo_campo_pk, 
            mat_orden, mat_blanquear_clave_al_retroceder, 1  from operaciones_metadatos_eah2025.matrices;            

/*OTRA*/ 
INSERT INTO encu.bloques(
            blo_ope, blo_for, blo_blo, blo_mat, blo_texto, blo_incluir_mat, 
            blo_orden, blo_aclaracion, blo_tlg)
select dbo.ope_actual(), blo_for, blo_blo, blo_mat, blo_texto, blo_incluir_mat, 
            blo_orden, blo_aclaracion, 1 from operaciones_metadatos_eah2025.bloques;
/*OTRA*/            
INSERT INTO encu.con_opc(
            conopc_ope, conopc_conopc, conopc_texto, conopc_despliegue, conopc_tlg)
select dbo.ope_actual(), conopc_conopc, conopc_texto, conopc_despliegue, 1 from operaciones_metadatos_eah2025.con_opc;            
/*OTRA*/     
INSERT INTO encu.filtros(
            fil_ope, fil_for, fil_mat, fil_blo, fil_fil, fil_texto, fil_expresion, 
            fil_destino, fil_orden, fil_aclaracion, fil_tlg)
select dbo.ope_actual(), fil_for, fil_mat, fil_blo, fil_fil, fil_texto, fil_expresion, 
            fil_destino, fil_orden, fil_aclaracion, 1 from operaciones_metadatos_eah2025.filtros;
/*OTRA*/          
INSERT INTO encu.opciones(
            opc_ope, opc_conopc, opc_opc, opc_texto, opc_aclaracion, opc_orden, 
            opc_proxima_vacia, opc_proxima_opc, opc_proxima_texto, opc_tlg)
select dbo.ope_actual(), opc_conopc, opc_opc, opc_texto, opc_aclaracion, opc_orden, 
            opc_proxima_vacia, opc_proxima_opc, opc_proxima_texto, 1 from operaciones_metadatos_eah2025.opciones;
            
/*OTRA*/ 
INSERT INTO encu.preguntas(
            pre_ope, pre_pre, pre_texto, pre_abreviado, pre_for, pre_mat, 
            pre_blo, pre_aclaracion, pre_destino, pre_desp_opc, pre_desp_nombre, 
            pre_orden, pre_tlg, pre_aclaracion_superior)
select dbo.ope_actual(), pre_pre, pre_texto, pre_abreviado, pre_for, pre_mat, 
            pre_blo, pre_aclaracion, pre_destino, pre_desp_opc, pre_desp_nombre, 
            pre_orden, 1, pre_aclaracion_superior from operaciones_metadatos_eah2025.preguntas;
/*OTRA*/
INSERT INTO encu.variables(
            var_ope, var_for, var_mat, var_pre, var_var, var_texto, var_aclaracion, 
            var_conopc, var_conopc_texto, var_tipovar, var_destino, var_subordinada_var, 
            var_subordinada_opcion, var_desp_nombre, var_expresion_habilitar, 
            var_optativa, var_editable_por, var_orden, var_nsnc_atipico, 
            var_mejor_de_pregunta, var_maximo, var_minimo, var_advertencia_sup, 
            var_advertencia_inf, var_destino_nsnc, var_calculada,  
            var_tlg, var_nombre_dr)
select dbo.ope_actual(), var_for, var_mat, var_pre, var_var, var_texto, var_aclaracion, 
            var_conopc, var_conopc_texto, var_tipovar, var_destino, var_subordinada_var, 
            var_subordinada_opcion, var_desp_nombre, var_expresion_habilitar, 
            var_optativa, var_editable_por, var_orden, var_nsnc_atipico, 
            var_mejor_de_pregunta, var_maximo, var_minimo, var_advertencia_sup, 
            var_advertencia_inf, var_destino_nsnc, var_calculada, 
             1, var_nombre_dr from operaciones_metadatos_eah2025.variables;/*OTRA*/
/*OTRA*/
INSERT INTO encu.saltos(
            sal_ope, sal_var, sal_conopc, sal_opc, sal_destino, sal_tlg)
select dbo.ope_actual(), sal_var, sal_conopc, sal_opc, sal_destino, 1 from operaciones_metadatos_eah2025.saltos;

--cuarta etapa borrar formulario PMD

delete from encu.saltos
--select *  from encu.saltos
  where sal_ope=dbo.ope_actual()
    and sal_var in (select var_var from encu.variables where var_ope=dbo.ope_actual() and  (var_for ='PMD' 
       or (  var_for='SUP' and var_pre in (select pre_pre from encu.preguntas where pre_blo='SPPMD' )) ))
;
--DELETE 34


--delete from encu.variables 
--select *   from  operaciones_metadatos_eah2025.variables
 -- from operaciones_metadatos_eah2025
    where var_ope=dbo.ope_actual() and var_var in (select var_var from encu.variables where var_ope=dbo.ope_actual() and  (var_for ='PMD' 
       or (  var_for='SUP' and var_pre in (select pre_pre from encu.preguntas where pre_blo='SPPMD' )) ))
;
--delete 119

delete 
--select * 
  from encu.preguntas
  where pre_ope=dbo.ope_actual() and (pre_for ='PMD'  OR  (pre_for='SUP' and  pre_blo='SPPMD' ) )
 -- order by pre_orden;
 --91 casos
 
--conopc 
select conopc_conopc
from (
select * 
  from encu.con_opc   
    --and   
    where conopc_ope=dbo.ope_actual() and conopc_conopc in  (select var_conopc from operaciones_metadatos_eah2025.variables where var_ope='eah2025' and  (var_for ='PMD' 
       or (  var_for='SUP' and var_pre in (select pre_pre from operaciones_metadatos_eah2025.preguntas where pre_blo='SPPMD' )) ))
)       ;
--con estos que me da esta consulta busco cuales no borrar
"entrea"
"si_no"
"notiene"
"algunos"
"algunos_m"
"aninguno"
"noaplica"
"noasiste"
"razon_pmd"
"noescuela"
"50a"
"algunos_as"
select * from encu.con_opc
where conopc_conopc  in (select var_conopc  from encu.variables where var_ope=dbo.ope_actual() and  var_conopc in (
'entrea',
'si_no',
'notiene',
'algunos',
'algunos_m',
'aninguno',
'noaplica',
'noasiste',
'razon_pmd',
'noescuela',
'50a',
'algunos_as'
));
--no borrar entrea y si_no de conopc
--borrar de opciones primero
delete 
--select * 
  from encu.opciones --where opc_ope=dbo.ope_actual()
    where opc_ope=dbo.ope_actual() and opc_conopc in  (
    'notiene',
'algunos',
'algunos_m',
'aninguno',
'noaplica',
'noasiste',
'razon_pmd',
'noescuela',
'50a',
'algunos_as');
--29 casos    
    
 

delete 
--select *
from  encu.con_opc
where  conopc_ope=dbo.ope_actual() and  conopc_conopc in (
'notiene',
'algunos',
'algunos_m',
'aninguno',
'noaplica',
'noasiste',
'razon_pmd',
'noescuela',
'50a',
'algunos_as'
);
 --10 casos

delete
--select *
  from encu.filtros where fil_ope=dbo.ope_actual()
     and fil_for='PMD'; --correcto
--8 casos     
delete
--select * 
  from encu.bloques where blo_ope=dbo.ope_actual()
    and  ( blo_for='PMD'  or  (  blo_for='SUP' and blo_blo ='SPPMD' ) ) ;
 --2 casos
delete 
--select *  --from  operaciones_metadatos_eah2025.matrices
  from encu.matrices where mat_ope=dbo.ope_actual()
     and mat_for='PMD';
--1 caso

delete 
--select *  
  from encu.formularios
  where for_for='PMD';
--1 caso  

 

--quinta etapa insertar nuevamente en varcal_destinos
INSERT INTO encu.varcal_destinos(
            varcaldes_ope, varcaldes_destino, varcaldes_ua, varcaldes_for, varcaldes_mat, 
            varcaldes_orden, varcaldes_tlg)
select mat_ope, case when mat_ua='enc' then 'tem' else mat_ua end , mat_ua, mat_for, mat_mat, 0,1 from encu.matrices 
where mat_ope=dbo.ope_actual() and (mat_for in ('S1', 'I1','TEM') AND mat_mat= '' or mat_for='A1' and mat_mat='X');
--sexta etapa correcciones
select *
from encu.saltos
where sal_var='sp20';
update encu.saltos set sal_destino='fin'
where sal_var='sp20' and sal_opc='3';
update encu.saltos set sal_destino='SP22'
where sal_var='sp20' and sal_opc='2';
update encu.saltos set sal_destino='fin'
where sal_var='sp22' and sal_destino='SPPMD1';
update encu.variables set var_destino='fin'
where var_var='sp21';
----septima etapa
--La réplica la necesitaríamos sin Migraciones,  Fecundidad, Derechos Humanos

delete from encu.saltos
--select *  from encu.saltos
  where sal_ope=dbo.ope_actual()
    and sal_var in (select var_var from encu.variables where var_ope=dbo.ope_actual() and var_var in (select var_var from encu.variables where var_ope=dbo.ope_actual() 
    and var_pre in ( select pre_pre from encu.preguntas where pre_for ='I1'   and  pre_blo in ('MIG', 'SMM','DDHH' ) )) )
--DELETE 2


--delete from encu.variables 
--select *   from  encu.variables
 -- from operaciones_metadatos_eah2025
    where var_ope=dbo.ope_actual() and var_var in (select var_var from encu.variables where var_ope=dbo.ope_actual() 
    and var_pre in ( select pre_pre from encu.preguntas where pre_for ='I1'   and  pre_blo in ('MIG', 'SMM','DDHH' ) ))
;
--delete 16

delete 
--select * 
  from encu.preguntas
  where pre_ope=dbo.ope_actual() and (pre_for ='I1'   and  pre_blo in ('MIG', 'SMM','DDHH' ) )
 -- order by pre_orden;
 --8 casos
 
--conopc 
select conopc_conopc
from (
select * 
  from encu.con_opc   
    --and   
    where conopc_ope='eah2025' and conopc_conopc in  (select var_conopc from operaciones_metadatos_eah2025.variables where var_ope='eah2025' and  (var_for ='I1' 
       and var_pre in ( select pre_pre from operaciones_metadatos_eah2025.preguntas where pre_for ='I1'   and  pre_blo in ('MIG', 'SMM','DDHH' ) ) ))
)       ;
--con estos que me da esta consulta busco cuales no borrar
"dh1"
"dh2"
"s28"
"dh3"
"m1"
"m3"
select * from encu.con_opc
where conopc_conopc  in (select var_conopc  from operaciones_metadatos_eah2025.variables where var_ope='eah2025' and  var_conopc in (
'dh1',
'dh2',
's28',
'dh3',
'm1',
'm3'
));
--controlo nuevamente en variables si ninguna hace referencia a esos con_opc
select *
 from encu.variables
 where var_conopc is not null and  var_conopc in ('dh1',
'dh2',
's28',
'dh3',
'm1',
'm3'
); 
--borrar de opciones primero
delete 
--select * 
  from encu.opciones    --where opc_ope=dbo.ope_actual()
    where opc_ope=dbo.ope_actual() and opc_conopc in  (
'dh1',
'dh2',
's28',
'dh3',
'm1',
'm3');
--24 casos    
    
 

delete 
--select *
from  encu.con_opc
where  conopc_ope=dbo.ope_actual() and  conopc_conopc in (
'dh1',
'dh2',
's28',
'dh3',
'm1',
'm3'
);
 --6 casos

delete
--select *
  from encu.filtros where fil_ope=dbo.ope_actual()
     and fil_for='I1' and fiL_blo in ('MIG', 'SMM','DDHH' ); --correcto
--2 casos     
delete
--select * 
  from encu.bloques where blo_ope=dbo.ope_actual()
    and   blo_for='I1'   and blo_blo in ('MIG', 'SMM','DDHH' ) ;
 --3 casos
--octava etapa correcciones 

select *
from encu.saltos
where sal_var='e2';
update encu.saltos set sal_destino='SN1'
where sal_var='e2' and sal_opc='3';
update encu.saltos set sal_destino='SN1'
where sal_var='e6';
update encu.saltos set sal_destino='SN1'
where sal_var='e12';
update encu.saltos set sal_destino='SN1'
where sal_var='e13' and sal_opc='1';
update encu.saltos set sal_destino='fin'
where sal_var='sp22' and sal_destino='SPPMD1';

select * from  encu.variables 
where var_destino_nsnc='MIG';
update encu.variables set var_destino_nsnc=null
where var_var='e2' and var_destino_nsnc='MIG';
update encu.variables set var_destino='SN1'
where var_var='e8' and var_destino='M1';