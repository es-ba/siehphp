--select * from encu.variables where var_var='cr_ningun_miembro'
select * from encu.variables where var_pre='CR'

select * from encu.filtros where  fil_blo='Hog'
--update encu.filtros set fil_expresion='cr_num_miembro=1' where  fil_blo='Hog'
select * from encu.bloques where blo_for='SM1' order by blo_orden


select * from eah2012.filtros 


select * from encu.respuestas where res_ope='same2013' and res_enc='100004'

select * from encu.plana_sm1_ where pla_enc=100004;
select * from eah2012.plana_s1_ where pla_enc=100004;
select * from encu.respuestas where res_enc=100004 and res_for='SM1' AND RES_MAT=''

select * from encu.matrices where mat_for='SM1' and mat_mat=''


-------------------------------------------------------------------------------
update encu.variables set var_optativa=true where var_var='cr_ningun_miembro';
update encu.variables set var_optativa=true where var_var='it1_monto';
update encu.matrices set mat_blanquear_clave_al_retroceder=  ',tra_mie:0,tra_exm:0' where mat_for='SM1' and mat_mat='';
-------------------------------------------------------------------------------------------------------------------------
update encu.variables set var_destino='FILTRO_1' where var_var='it2';
update encu.filtros set  fil_orden=405 where fil_fil='FILTRO_1';
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
update encu.variables set var_destino='fin' where var_var ='tel2';
update encu.variables set var_for='SM1' where var_var='observaciones';
update encu.preguntas set pre_for='SM1', pre_orden=90, pre_blo='SM1.1' where pre_pre ='Observaciones';
update encu.saltos set sal_conopc='si_no' where sal_var='entreaind';
delete from encu.opciones where opc_conopc='entreaind';
delete from encu.con_opc where conopc_conopc='entreaind';
update encu.variables set var_expresion_habilitar='entreaind=2' where var_var='noreaind';
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




select distinct var_destino from encu.variables
select * from encu.variables where var_var in ('tel2','observaciones')
update encu.variables set var_destino='fin' where var_var in ('tel2','observaciones')
select * from encu.preguntas where pre_pre like 'JH%'
select distinct sal_destino from encu.saltos



select * from encu.filtros where fil_fil='FILTRO_1'--500 Hog 405
update encu.filtros set  fil_orden=405 where fil_fil='FILTRO_1'
select * from encu.preguntas where pre_for='SM1' and pre_mat='' order by pre_orden

select * from encu.filtros
"cr_num_miembro=1"
select * from encu.respuestas where res_ope='same2013' and res_enc= '100006' and res_for='SM1'



select * from encu.preguntas where pre_for='SMI1' order by pre_orden

select * from encu.preguntas where pre_pre ='Observaciones' order by pre_orden --90 bloque: SM1.1 for: SM1

select * from encu.variables where var_var='observaciones';

select * from encu.variables where var_var='entreaind'
select * from encu.saltos where sal_var='entreaind'
select * from encu.con_opc where conopc_conopc='entreaind'
select * from encu.opciones where opc_conopc='entreaind'

update encu.saltos set sal_conopc='si_no' where sal_var='entreaind'
delete from encu.opciones where opc_conopc='entreaind'
delete from encu.con_opc where conopc_conopc='entreaind'


select * from encu.variables where var_var='noreaind';
update encu.variables set var_expresion_habilitar='entreaind=2' where var_var='noreaind';

select * from encu.variables where var_var like '%_esp'