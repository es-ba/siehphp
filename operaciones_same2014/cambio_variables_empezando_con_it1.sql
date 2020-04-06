/*
delete from encu.respuestas where res_var='it1_nsnc';
delete from encu.variables where var_var='it1_nsnc';
alter table encu.plana_sm1_ drop column pla_it1_nsnc;

-- */

INSERT INTO encu.variables(
            var_ope, var_for, var_mat, var_pre, var_var, var_texto, var_aclaracion, 
            var_conopc, var_conopc_texto, var_tipovar, var_destino, var_subordinada_var, 
            var_subordinada_opcion, var_desp_nombre, var_expresion_habilitar, 
            var_optativa, var_editable_por, var_orden, var_nsnc_atipico, 
            var_mejor_de_pregunta, var_maximo, var_minimo, var_advertencia_sup, 
            var_advertencia_inf, var_destino_nsnc, var_tlg)
  select var_ope, var_for, var_mat, var_pre, 'it1' as var_var, var_texto, var_aclaracion, 
            var_conopc, var_conopc_texto, var_tipovar, var_destino, var_subordinada_var, 
            var_subordinada_opcion, var_desp_nombre, var_expresion_habilitar, 
            var_optativa, var_editable_por, var_orden, var_nsnc_atipico, 
            var_mejor_de_pregunta, var_maximo, var_minimo, var_advertencia_sup, 
            var_advertencia_inf, var_destino_nsnc, var_tlg
    from encu.variables where var_var='it1_monto';

alter table encu.plana_sm1_ rename column pla_it1_monto to pla_it1;

update encu.respuestas d 
  set res_valor=o.res_valor, 
      res_valesp=o.res_valesp,
      res_valor_con_error=o.res_valor_con_error, 
      res_estado=o.res_estado, 
      res_anotaciones_marginales=o.res_anotaciones_marginales
    from encu.respuestas o
    where o.res_var='it1_monto'
      and d.res_var='it1'
      and d.res_ope=o.res_ope
      and d.res_for=o.res_for
      and d.res_mat=o.res_mat
      and d.res_enc=o.res_enc
      and d.res_hog=o.res_hog
      and d.res_mie=o.res_mie
      and d.res_exm=o.res_exm;
      -- and d.res_var=o.res_var
    
delete from encu.respuestas where res_var='it1_monto';
delete from encu.variables where var_var='it1_monto';
