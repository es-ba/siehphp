##FUN
generar_consistencias_continuidad
##ESQ
encu
##PARA
revisar 
##DETALLE
consistencia de flujo sobre variables que no tienen salto ni filtro inmediatamente posterior, que exige que la siguiente variable tenga valor
NUEVA
##PROVISORIO
set search_path= encu, comun, dbo, public;
CREATE OR REPLACE FUNCTION encu.generar_consistencias_continuidad()
  RETURNS void AS
$BODY$
DECLARE
 rcons encu.consistencias%rowtype;
 vvar                   RECORD;
 vsiguiente             TEXT;
 vsig_optativa boolean;
 vsig_expresion_habilitar   TEXT;
 vsig_subordinada_var   text;
 cond_nsnc              text;
 v_hay_filtro_antes     boolean;
 poperativo             text;
BEGIN
    poperativo= dbo.ope_actual();
    -- Borrar las automaticas
    DELETE FROM encu.inconsistencias
        WHERE inc_ope=poperativo and inc_con SIMILAR TO 'flujo\_c\_%';
    DELETE FROM encu.ano_con
        WHERE anocon_ope=poperativo and anocon_con SIMILAR TO 'flujo\_c\_%';
    DELETE FROM encu.con_var
        WHERE convar_ope=poperativo and convar_con SIMILAR TO 'flujo\_c\_%';
    DELETE FROM encu.consistencias
        WHERE con_ope=poperativo and con_con SIMILAR TO 'flujo\_c\_%';
    FOR vvar IN --para cada variable sin salto
        select v.var_for, v.var_mat, v.var_var, v.var_siguiente, v.var_destino_nsnc, v.var_destino, v.pre_orden, v.blo_orden, v.blo_blo
            from encu.variables_ordenadas v 
            where v.var_ope=poperativo  and 
                v.var_destino is null  and 
                not exists (select * from encu.saltos s where s.sal_var= v.var_var AND s.sal_ope=v.var_ope)
                and v.var_for is distinct from 'SUP'
            order by v.var_for, v.var_mat, v.var_var            
    LOOP
        -- consultar siguiente
        SELECT v.var_var, v.var_optativa , v.var_expresion_habilitar,v.var_subordinada_var
            INTO vsiguiente, vsig_optativa, vsig_expresion_habilitar, vsig_subordinada_var
            FROM encu.variables_ordenadas v 
                JOIN encu.variables_ordenadas x on x.var_ope=v.var_ope
                               and v.var_for=x.var_for and v.var_mat=x.var_mat
                               and x.blo_orden<= v.blo_orden and x.orden<v.orden
            WHERE x.var_var= vvar.var_var  and x.var_ope=poperativo and
                  x.var_for=vvar.var_for  and x.blo_blo=vvar.blo_blo and  x.var_mat=v.var_mat
            ORDER BY v.orden
            LIMIT 1; 
        select case when tipo='fil' then true else false end 
            into v_hay_filtro_antes 
            from (
                select pre_ope ope, pre_for fo, pre_mat mat , pre_blo blo, pre_orden orden, pre_pre ele, 'pre' tipo, blo_orden, mat_orden
                     from encu.preguntas join encu.bloques on blo_ope= pre_ope and blo_for=pre_for and blo_blo=pre_blo and blo_mat=pre_mat join encu.matrices on mat_ope= blo_ope and mat_for=blo_for and mat_mat =blo_mat
                     where pre_ope=dbo.ope_actual()
                union 
                  select fil_ope ope, fil_for fo, fil_mat mat , fil_blo blo, fil_orden orden, fil_fil ele, 'fil' tipo, blo_orden, mat_orden
                     from encu.filtros join encu.bloques on blo_ope= fil_ope and blo_for=fil_for and blo_blo=fil_blo join encu.matrices on mat_ope= blo_ope and mat_for=blo_for and mat_mat =blo_mat
                     where fil_ope=dbo.ope_actual()
                 ) as x
             where fo= vvar.var_for and mat= vvar.var_mat and (blo_orden> vvar.blo_orden or (blo_orden= vvar.blo_orden and orden>vvar.pre_orden))
            order by ope, fo, mat_orden, blo_orden, orden 
            limit 1; 
        --raise notice 'var: %, hay_filtro %, var_sig % orden pre %', vvar.var_var, v_hay_filtro_antes, vsiguiente, vvar.pre_orden;       
        
        IF vsiguiente is not null and vsig_optativa is false and vsig_subordinada_var is distinct from vvar.var_var and not v_hay_filtro_antes THEN  
           rcons.con_ope=poperativo; 
           rcons.con_con='flujo_c_' || vvar.var_var;
           cond_nsnc='';
           IF vvar.var_destino_nsnc IS NOT NULL THEN
             cond_nsnc= 'and not ('||vvar.var_var||'=-1 or '||vvar.var_var||'=-9)';
           END IF;
           rcons.con_precondicion= 'informado(' ||vvar.var_var||')'||
                                   cond_nsnc|| 
                                   case when coalesce(length(trim(vsig_expresion_habilitar)),0)>0 then ' and ('|| vsig_expresion_habilitar||')' else '' end;
           rcons.con_rel='=>';
           rcons.con_postcondicion= 'informado('||vsiguiente || ')'; 
           rcons.con_explicacion='Variables continuas, si informa '||vvar.var_var||' debe informar '|| vsiguiente;
           execute encu.insert_consistencia_flujo(rcons.con_ope, rcons.con_con, rcons.con_precondicion, rcons.con_rel,
                                rcons.con_postcondicion, rcons.con_explicacion);
        END IF;    
    END LOOP;
END;
$BODY$
LANGUAGE plpgsql;
/*otra*/
ALTER FUNCTION encu.generar_consistencias_continuidad()
  OWNER TO tedede_php;