set role tedede_php;
--modificando variables 
select *
from encu.variables
where var_var='tp5b'

select *
from encu.saltos
where sal_var='tp5b' --no hay


update encu.variables set var_var='p5b' where var_var='tp5b'
update encu.respuestas set res_var='p5b' where res_var='tp5b';
insert into encu.variables 
select *
from encu.variables
where var_var='tp5b'


ALTER TABLE encu.plana_s1_p RENAME  COLUMN pla_tp5b TO pla_p5b;



Insertar nueva variable en tabla variables:

--la actualización de la pregunta de TP5B a P5B permite hacerla por el sistema en produc y test por el update CASCADE
--la variable no se puede actualizar en test desde el sistema porque ya existe info cargada en respuestas
INSERT INTO encu.variables 
(var_ope, var_for, var_mat, var_var, var_pre, var_texto, var_aclaracion, 
            var_conopc, var_conopc_texto, var_tipovar, var_destino, var_subordinada_var, 
            var_subordinada_opcion, var_desp_nombre, var_expresion_habilitar, 
            var_optativa, var_orden, var_nsnc_atipico, 
            var_mejor_de_pregunta, var_maximo, var_minimo, var_advertencia_sup, 
            var_advertencia_inf, var_destino_nsnc, var_calculada, var_tlg)
select dbo.ope_actual(), var_for, var_mat,  'p5b',  'P5B', var_texto, var_aclaracion, 
            var_conopc, var_conopc_texto, var_tipovar, var_destino, var_subordinada_var, 
            var_subordinada_opcion, var_desp_nombre, var_expresion_habilitar, 
            var_optativa, var_orden, var_nsnc_atipico, 
            var_mejor_de_pregunta, var_maximo, var_minimo, var_advertencia_sup, 
            var_advertencia_inf, var_destino_nsnc, var_calculada, var_tlg
            from encu.variables 
            where var_ope = 'eah2024' and var_var = 'tp5b';
            

select * from encu.con_var where convar_ope = 'eah2024' and convar_var = 'tp5b';
--Si esta en la tabla con_var, borrar los registros:

--delete from encu.con_var where convar_ope = 'eah2024' and convar_var = 'tp5b';
Agregar en la plana correspondiente, plana_s1_p la variable pla_p5b

alter table encu.plana_s1_p
  add column pla_p5b integer;
Luego repetir las respuestas con la nueva res_var:

delete from encu.respuestas where res_ope='eah2024' and res_for='S1'  and res_mat='P' and res_var='p5b';
update encu.respuestas set res_var='p5b' where res_ope='eah2024' and res_for='S1' and res_mat='P' and res_var='tp5b';
--Cambiar en tabla saltos sal_var 'tp5b' por 'p5b':
--update encu.saltos set sal_var = 'p5b' where sal_ope = 'eah2024' and sal_var = 'tp5b'; --no hay
--Eliminar la variable original:

delete from encu.variables where var_ope = 'eah2024' and var_var = 'tp5b';
--Borrar de la plana la variable original:

alter table encu.plana_s1_p
  drop column pla_tp5b;
--Y por último, Actualizar instalación (jsones varios, post cambios metadatos)