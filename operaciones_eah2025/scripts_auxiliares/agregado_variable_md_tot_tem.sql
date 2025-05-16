set search_path=encu;
/* consulto las ya existentes _tot*/
select *
from encu.variables
where  var_for='TEM' and var_var ilike'%tot'

select  *
from encu.preguntas
where  pre_for='TEM' and pre_pre ilike'%tot';
select  distinct res_var
from encu.respuestas
where  res_for='TEM' and res_var ilike'%tot';

--desde eah2018 busco la md_tot
select pre_ope, pre_pre, pre_texto, pre_for, pre_desp_opc, pre_orden, pre_tlg
from encu.preguntas
where pre_pre='md_tot';
"eah2018"	"md_tot"	"Formularios MD existentes"		"TEM"					"vertical"		860		1
--agregado
insert into preguntas(pre_ope, pre_pre, pre_texto, pre_for, pre_desp_opc, pre_orden, pre_blo, pre_tlg)
  select dbo.ope_actual(), 'md_tot', 'Formularios MD existentes', pre_for, pre_desp_opc, 860,pre_blo, 1
  from encu.preguntas
  where pre_pre='pyg_tot';
  
INSERT INTO encu.variables 
(var_ope, var_for, var_mat, var_var, var_pre, var_texto, var_aclaracion, 
            var_conopc, var_conopc_texto, var_tipovar, var_destino, var_subordinada_var, 
            var_subordinada_opcion, var_desp_nombre, var_expresion_habilitar, 
            var_optativa, var_orden, var_nsnc_atipico, 
            var_mejor_de_pregunta, var_maximo, var_minimo, var_advertencia_sup, 
            var_advertencia_inf, var_destino_nsnc, var_calculada, var_tlg)
select dbo.ope_actual(), var_for, var_mat,  'md_tot', 'md_tot', var_texto, var_aclaracion, 
            var_conopc, var_conopc_texto, var_tipovar, var_destino, var_subordinada_var, 
            var_subordinada_opcion, var_desp_nombre, var_expresion_habilitar, 
            var_optativa, var_orden, var_nsnc_atipico, 
            var_mejor_de_pregunta, var_maximo, var_minimo, var_advertencia_sup, 
            var_advertencia_inf, var_destino_nsnc, var_calculada, 1
            from encu.variables 
            where var_ope = 'eah2025' and var_var = 'pyg_tot';
			
alter table plana_tem_ add column pla_md_tot integer;			