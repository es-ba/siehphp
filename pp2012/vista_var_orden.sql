create or replace view encu.var_orden as 
    select var_ope as varord_ope, var_var as varord_var , 
        trim(to_char(coalesce(for_orden,0),'000000'))||rpad(blo_mat,10)||
            trim(to_char(coalesce(blo_orden,0),'000000'))||
            trim(to_char(coalesce(pre_orden,0),'000000'))||
            trim(to_char(coalesce(var_orden,0),'000000')) as varord_orden_total 
    from encu.formularios
        inner join encu.bloques on blo_ope=for_ope and blo_for=for_for
        inner join encu.preguntas on blo_ope=pre_ope and blo_for=pre_for and blo_blo=pre_blo 
        inner join encu.variables on pre_ope=var_ope and pre_pre=var_pre 
    order by varord_orden_total;