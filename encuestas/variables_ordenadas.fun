##FUN
variables_ordenadas
##ESQ
encu
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO
set search_path= encu, comun, dbo, public;
CREATE OR REPLACE VIEW encu.variables_ordenadas AS
        select blo_for,blo_blo, blo_texto, blo_incluir_mat, blo_orden,
               v.var_ope, v.var_for, v.var_mat, v.var_pre, v.var_var, v.var_texto, v.var_aclaracion, 
               v.var_conopc, v.var_conopc_texto, v.var_tipovar, v.var_destino, v.var_subordinada_var, 
               v.var_subordinada_opcion, v.var_desp_nombre, v.var_expresion_habilitar, 
               v.var_optativa, v.var_editable_por, v.var_orden, v.var_nsnc_atipico, 
               v.var_destino_nsnc, v.var_calculada, p.pre_orden,
               row_number() 
                   over( order by f.for_orden, b.blo_orden, b.blo_mat, p.pre_orden, comun.para_ordenar_numeros(coalesce(v.var_orden::text,v.var_var)),coalesce(var_subordinada_var,'')) as orden,
               last_value(v.var_var) 
                    over (partition by blo_for            
                          order by f.for_orden, b.blo_orden, b.blo_mat, p.pre_orden, comun.para_ordenar_numeros(coalesce(v.var_orden::text,v.var_var)),coalesce(var_subordinada_var,'')
                          rows between unbounded preceding and unbounded following
                         ) as var_ultima_for,             
               lead(var_var, 1, 'fin' ) 
                    over (--partition by f.for_orden, b.blo_mat,b.blo_orden, p.pre_orden, var_pre               
                            order by f.for_orden, b.blo_orden, b.blo_mat,p.pre_orden, comun.para_ordenar_numeros(coalesce(v.var_orden::text,v.var_var)),var_pre
                            --rows between unbounded preceding  and unbounded following
                          ) as var_siguiente
            from encu.variables v 
                join encu.preguntas p    on p.pre_ope=v.var_ope and p.pre_pre= v.var_pre and 
                                            p.pre_for=v.var_for and p.pre_mat=v.var_mat
                join encu.bloques b      on b.blo_blo=p.pre_blo and b.blo_ope=p.pre_ope and 
                                            b.blo_for=p.pre_for and b.blo_mat=p.pre_mat
                join encu.formularios f  on f.for_for= b.blo_for AND f.for_ope=b.blo_ope
            where f.for_for<>'TEM'--and v.var_for='S1'
            order by f.for_orden, b.blo_orden, b.blo_mat,p.pre_orden, comun.para_ordenar_numeros(coalesce(v.var_orden::text,v.var_var)), coalesce(v.var_subordinada_var,'');
/*otra*/
ALTER TABLE encu.variables_ordenadas
  OWNER TO tedede_php;