/*en eah2018*/
set role tedede_php;
create schema operaciones_metadatos_md
   authorization tedede_php;

select * into operaciones_metadatos_md.formularios 
  from encu.formularios
  where for_for='MD';
update operaciones_metadatos_md.formularios set for_tlg=1;

select * into operaciones_metadatos_md.bloques
  from encu.bloques where blo_ope=dbo.ope_actual()
    and  ( blo_for='MD' or ( (  blo_for='I1' and blo_blo in ('BD') ) or  (  blo_for='SUP' and blo_blo ='SPBD' ) ) );
update operaciones_metadatos_md.bloques set blo_tlg=1;

select *  into operaciones_metadatos_md.con_opc 
  from encu.con_opc where conopc_ope=dbo.ope_actual()
    and   conopc_conopc in  (select var_conopc from encu.variables where var_ope=dbo.ope_actual() and  (var_for ='MD' 
       or (  var_for='I1' and var_pre in (select pre_pre from encu.preguntas where pre_blo='BD' ) )
       or (  var_for='SUP' and var_pre in (select pre_pre from encu.preguntas where pre_blo='SPBD' )) )
       
);
update operaciones_metadatos_md.con_opc set conopc_tlg=1;

select *  into operaciones_metadatos_md.filtros 
  from encu.filtros where fil_ope=dbo.ope_actual()
     and fil_for='MD'; --correcto
update operaciones_metadatos_md.filtros set fil_tlg=1;
/*
select * --into operaciones_metadatos.formularios 
from encu.formularios where for_ope=dbo.ope_actual();

update operaciones_metadatos.formularios set for_tlg=1;
*/

select *  into operaciones_metadatos_md.matrices
  from encu.matrices where mat_ope=dbo.ope_actual()
     and mat_for='MD';
update operaciones_metadatos_md.matrices set mat_tlg=1;

select * into operaciones_metadatos_md.opciones 
  from encu.opciones where opc_ope=dbo.ope_actual()
    and   opc_conopc in  (select var_conopc from encu.variables where var_ope=dbo.ope_actual() and  (var_for ='MD' 
       or (  var_for='I1' and var_pre in (select pre_pre from encu.preguntas where pre_blo='BD' ) )
       or (  var_for='SUP' and var_pre in (select pre_pre from encu.preguntas where pre_blo='SPBD' )) ))
--and opc_conpoc not in (select con_opc from encu.opciones where opc_ope=dbo.ope_actual());
update operaciones_metadatos_md.opciones set opc_tlg=1;

select * into operaciones_metadatos_md.preguntas 
  from encu.preguntas
  where pre_ope=dbo.ope_actual() and (pre_for ='MD' or  ( pre_for='I1' and  pre_blo='BD') OR  (pre_for='SUP' and  pre_blo='SPBD' ) );
update operaciones_metadatos_md.preguntas set pre_tlg=1;

select * into operaciones_metadatos_md.saltos 
  from encu.saltos where sal_ope=dbo.ope_actual()
    and sal_var in (select var_var from encu.variables where var_ope=dbo.ope_actual() and  (var_for ='MD' 
    or (  var_for='I1' and var_pre in (select pre_pre from encu.preguntas where pre_blo='BD' ) )
       or (  var_for='SUP' and var_pre in (select pre_pre from encu.preguntas where pre_blo='SPBD' )) ))
;
update operaciones_metadatos_md.saltos set sal_tlg=1;


select * into operaciones_metadatos_md.variables
  from encu.variables where var_ope=dbo.ope_actual()
    and var_var in (select var_var from encu.variables where var_ope=dbo.ope_actual() and  (var_for ='MD' 
    or (  var_for='I1' and var_pre in (select pre_pre from encu.preguntas where pre_blo='BD' ) )
       or (  var_for='SUP' and var_pre in (select pre_pre from encu.preguntas where pre_blo='SPBD' )) ))
;
update operaciones_metadatos_md.variables set var_tlg=1;

/*
select * into operaciones_metadatos_md.ua 
  from encu.ua where ua_ope=dbo.ope_actual();
update operaciones_metadatos_md.ua set ua_tlg=1;

*/

/* hacer el backup del schema y restaurar en la base nueva eah2024 */
set role tedede_php;
create schema operaciones_metadatos_md
   authorization tedede_php;
   
INSERT INTO encu.formularios(
            for_ope, for_for, for_nombre, for_es_principal, for_orden, for_tlg, 
            for_tarea)
select dbo.ope_actual(), for_for, for_nombre, for_es_principal, for_orden, 1,
           for_tarea from operaciones_metadatos_md.formularios;
/*OTRA*/ 

/*
INSERT INTO encu.ua(
            ua_ope, ua_ua, ua_prefijo_respuestas, ua_sufijo_tablas, ua_pk, 
            ua_tlg)
select dbo.ope_actual(), ua_ua, ua_prefijo_respuestas, ua_sufijo_tablas, ua_pk,  1
           from operaciones_metadatos_md.ua
           where ua_ua not in (select ua_ua from encu.ua where ua_ope=dbo.ope_actual());   
*/           
/*OTRA*/ 
INSERT INTO encu.matrices(
            mat_ope, mat_for, mat_mat, mat_texto, mat_ua, mat_ultimo_campo_pk, 
            mat_orden, mat_blanquear_clave_al_retroceder, mat_tlg)
select dbo.ope_actual(), mat_for, mat_mat, mat_texto, mat_ua, mat_ultimo_campo_pk, 
            mat_orden, mat_blanquear_clave_al_retroceder, 1  from operaciones_metadatos_md.matrices;            

/*OTRA*/ 
INSERT INTO encu.bloques(
            blo_ope, blo_for, blo_blo, blo_mat, blo_texto, blo_incluir_mat, 
            blo_orden, blo_aclaracion, blo_tlg)
select dbo.ope_actual(), blo_for, blo_blo, blo_mat, blo_texto, blo_incluir_mat, 
            blo_orden, blo_aclaracion, 1 from operaciones_metadatos_md.bloques;
/*OTRA*/            
INSERT INTO encu.con_opc(
            conopc_ope, conopc_conopc, conopc_texto, conopc_despliegue, conopc_tlg)
select dbo.ope_actual(), conopc_conopc, conopc_texto, conopc_despliegue, 1 from operaciones_metadatos_md.con_opc
     where conopc_conopc not in (select conopc_conopc from encu.con_opc where conopc_ope=dbo.ope_actual());            
/*OTRA*/     
INSERT INTO encu.filtros(
            fil_ope, fil_for, fil_mat, fil_blo, fil_fil, fil_texto, fil_expresion, 
            fil_destino, fil_orden, fil_aclaracion, fil_tlg)
select dbo.ope_actual(), fil_for, fil_mat, fil_blo, fil_fil, fil_texto, fil_expresion, 
            fil_destino, fil_orden, fil_aclaracion, 1 from operaciones_metadatos_md.filtros;
/*OTRA*/          
INSERT INTO encu.opciones(
            opc_ope, opc_conopc, opc_opc, opc_texto, opc_aclaracion, opc_orden, 
            opc_proxima_vacia, opc_proxima_opc, opc_proxima_texto, opc_tlg)
select dbo.ope_actual(), opc_conopc, opc_opc, opc_texto, opc_aclaracion, opc_orden, 
            opc_proxima_vacia, opc_proxima_opc, opc_proxima_texto, 1 from operaciones_metadatos_md.opciones
              where opc_conopc not in (select opc_conopc from encu.opciones where opc_ope=dbo.ope_actual() ); 
            
/*OTRA*/ 
INSERT INTO encu.preguntas(
            pre_ope, pre_pre, pre_texto, pre_abreviado, pre_for, pre_mat, 
            pre_blo, pre_aclaracion, pre_destino, pre_desp_opc, pre_desp_nombre, 
            pre_orden, pre_tlg, pre_aclaracion_superior)
select dbo.ope_actual(), pre_pre, pre_texto, pre_abreviado, pre_for, pre_mat, 
            pre_blo, pre_aclaracion, pre_destino, pre_desp_opc, pre_desp_nombre, 
            pre_orden, 1, pre_aclaracion_superior from operaciones_metadatos_md.preguntas;
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
             1, var_nombre_dr from operaciones_metadatos_md.variables;/*OTRA*/
/*OTRA*/
INSERT INTO encu.saltos(
            sal_ope, sal_var, sal_conopc, sal_opc, sal_destino, sal_tlg)
select dbo.ope_actual(), sal_var, sal_conopc, sal_opc, sal_destino, 1 from operaciones_metadatos_md.saltos;
 
 
update encu.bloques set blo_orden=90 where blo_blo='SPBD' and blo_for='SUP';