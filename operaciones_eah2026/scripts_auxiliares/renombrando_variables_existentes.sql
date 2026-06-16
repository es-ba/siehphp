set role tedede_php;
--modificando variables
--La tt1_esp debería cambiar de nombre a t11_otro. El pase de esta especificación debe ir a T12_bis
 --h36_6otro debería cambiar el nombre a h36_6_esp. 
select *
from encu.variables
where var_var in ('tt1_esp', 'h36_6otro');
--"eah2026"	"I1"		"T11"	"tt1_esp"					"texto_especificar"		"t11"	"4"		"t11=4"	false		7											151
--"eah2026"	"A1"		"H36"	"h36_6otro"	"Especificar"				"texto_especificar"		"h36_6"	"1"		"h36_6=1"	false		22											1612
select *
from encu.saltos
where sal_var in ('tt1_esp', 'h36_6otro') --no hay

/* esto sería para el caso donde no hay información aun cargada de encuestas 
update encu.variables set var_var='t11_otro' where var_var='tt1_esp';
update encu.respuestas set res_var='t11_otro' where res_var='tt1_esp';
update encu.variables set var_var='h36_6_esp' where var_var='h36_6otro';
update encu.respuestas set res_var='h36_6_esp' where res_var='h36_6otro';

--insert into encu.variables 
--select *
--from encu.variables
--where var_var='tt1_esp'


ALTER TABLE encu.plana_i1_ RENAME  COLUMN pla_tt1_esp TO pla_t11_otro;
ALTER TABLE encu.plana_a1_ RENAME  COLUMN pla_h36_6otro TO pla_h36_6_esp;


*/
Insertar nuevas variables en tabla variables:

--la actualización de la pregunta de TP5B a P5B permite hacerla por el sistema en produc y test por el update CASCADE
--la variable no se puede actualizar en test desde el sistema porque ya existe info cargada en respuestas (de encuestas ingresadas)
INSERT INTO encu.variables 
(var_ope, var_for, var_mat, var_var, var_pre, var_texto, var_aclaracion, 
            var_conopc, var_conopc_texto, var_tipovar, var_destino, var_subordinada_var, 
            var_subordinada_opcion, var_desp_nombre, var_expresion_habilitar, 
            var_optativa, var_orden, var_nsnc_atipico, 
            var_mejor_de_pregunta, var_maximo, var_minimo, var_advertencia_sup, 
            var_advertencia_inf, var_destino_nsnc, var_calculada, var_tlg)
select dbo.ope_actual(), var_for, var_mat,  't11_otro',  var_pre, var_texto, var_aclaracion, 
            var_conopc, var_conopc_texto, var_tipovar, var_destino, var_subordinada_var, 
            var_subordinada_opcion, var_desp_nombre, var_expresion_habilitar, 
            var_optativa, var_orden, var_nsnc_atipico, 
            var_mejor_de_pregunta, var_maximo, var_minimo, var_advertencia_sup, 
            var_advertencia_inf, var_destino_nsnc, var_calculada, var_tlg
            from encu.variables 
            where var_ope = 'eah2026' and var_var = 'tt1_esp';
 
INSERT INTO encu.variables 
(var_ope, var_for, var_mat, var_var, var_pre, var_texto, var_aclaracion, 
            var_conopc, var_conopc_texto, var_tipovar, var_destino, var_subordinada_var, 
            var_subordinada_opcion, var_desp_nombre, var_expresion_habilitar, 
            var_optativa, var_orden, var_nsnc_atipico, 
            var_mejor_de_pregunta, var_maximo, var_minimo, var_advertencia_sup, 
            var_advertencia_inf, var_destino_nsnc, var_calculada, var_tlg)
select dbo.ope_actual(), var_for, var_mat,  'h36_6_esp',  var_pre, var_texto, var_aclaracion, 
            var_conopc, var_conopc_texto, var_tipovar, var_destino, var_subordinada_var, 
            var_subordinada_opcion, var_desp_nombre, var_expresion_habilitar, 
            var_optativa, var_orden, var_nsnc_atipico, 
            var_mejor_de_pregunta, var_maximo, var_minimo, var_advertencia_sup, 
            var_advertencia_inf, var_destino_nsnc, var_calculada, var_tlg
            from encu.variables 
            where var_ope = 'eah2026' and var_var = 'h36_6otro';

 

select * from encu.con_var where convar_ope = 'eah2026' and convar_var = 'tt1_esp';
--24 casos
select * from encu.con_var where convar_ope = 'eah2026' and convar_var = 'h36_6otro';
--3 casos
--Si esta en la tabla con_var, borrar los registros:

delete from encu.con_var where convar_ope = 'eah2026' and convar_var = 'tt1_esp';
delete from encu.con_var where convar_ope = 'eah2026' and convar_var = 'h36_6otro';
--Agregar en la plana correspondiente,las nuevas variables
alter table encu.plana_i1_
  add column pla_t11_otro text;
  
ALTER TABLE encu.plana_a1_  
  add column pla_h36_6_esp text;
--Luego repetir las respuestas con la nueva res_var:
--158 filas
--select *
delete from encu.respuestas where res_ope='eah2026' and res_for='I1'  and res_mat='' and res_var='t11_otro'; --la variable que entra 
--delete 158
update encu.respuestas set res_var='t11_otro' where res_ope='eah2026' and res_for='I1' and res_mat='' and res_var='tt1_esp';

--select * 
delete from encu.respuestas where res_ope='eah2026' and res_for='A1'  and res_mat='' and res_var='h36_6_esp'; --la variable que entra
--78 casos
update encu.respuestas set res_var='h36_6_esp' where res_ope='eah2026' and res_for='A1' and res_mat='' and res_var='h36_6otro';

--Cambiar en tabla saltos sal_var 'tt1_esp' por 't11_otro'; --por ejemplo si es que hubiera casos
--ejemplo
--update encu.saltos set sal_var = 't11_otro' where sal_ope = 'eah2026' and sal_var = 't11_otro'; --no hay
--Eliminar la variable original:

--
delete from encu.variables where var_ope = 'eah2026' and var_var = 'tt1_esp';
delete from encu.variables where var_ope = 'eah2026' and var_var = 'h36_6otro';
--Borrar de la plana la variable original:

alter table encu.plana_i1_
  drop column pla_tt1_esp;
  
alter table encu.plana_a1_
  drop column pla_h36_6otro;  
--Y por último, Actualizar instalación (jsones varios, post cambios metadatos)