##FUN
generar_consistencias_flujo
##ESQ
encu
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO
set search_path= encu, comun, dbo, public;
CREATE OR REPLACE FUNCTION encu.generar_consistencias_flujo(poperativo TEXT)
  RETURNS void AS
$BODY$
DECLARE
 opc_saltos text;
 rcons encu.consistencias%rowtype;
 r_saltadas RECORD;
 r_destino RECORD;
 vvar RECORD;
 vopc_s RECORD;
 vsiguiente TEXT;
 vsig_optativa boolean;
 vsig_expresion_habilitar TEXT;
 cond_nsnc text;
 v_nsnc RECORD;
 nsnc_destino TEXT;
 nsnc_tipodestino TEXT; 
 nsnc_optativa BOOLEAN;
 nsnc_expresion_habilitar TEXT;
 val_nsnc varchar(50)[];
BEGIN  
    -- Borrar las automaticas
    DELETE FROM encu.inconsistencias
        WHERE inc_ope=poperativo and inc_con SIMILAR TO 'flujo\_(s|v|sv)\_%';
    DELETE FROM encu.ano_con
        WHERE anocon_ope=poperativo and anocon_con SIMILAR TO 'flujo\_(s|v|sv)\_%';
    DELETE FROM encu.con_var
        WHERE convar_ope=poperativo and convar_con SIMILAR TO 'flujo\_(s|v|sv)\_%';
    DELETE FROM encu.consistencias
        WHERE con_ope=poperativo and con_con SIMILAR TO 'flujo\_(s|v|sv)\_%';
    FOR vvar IN --para cada salto
        select distinct v.var_for, v.var_mat, s.sal_var, v.var_destino_nsnc
            from encu.saltos s JOIN encu.variables v ON s.sal_var= v.var_var AND s.sal_ope=v.var_ope
            where s.sal_ope=poperativo and v.var_for is distinct from 'SUP'
            order by v.var_for, v.var_mat, s.sal_var            
    LOOP
        opc_saltos='';
        --c/opciones de salto
        FOR vopc_s IN
            select distinct on(sal_var,opc_orden)  
                   sal_var, sal_opc , sal_destino as sal_pre, w.var_var as var_destino,w.var_expresion_habilitar,
                   w.var_optativa as var_destino_optativa
                from encu.saltos s 
                    JOIN encu.opciones o  ON o.opc_opc=s.sal_opc AND o.opc_ope=s.sal_ope AND o.opc_conopc=s.sal_conopc
                    LEFT JOIN encu.variables w ON  w.var_pre=s.sal_destino and w.var_ope=s.sal_ope and w.var_for=vvar.var_for and w.var_mat=vvar.var_mat
                where s.sal_ope=poperativo and s.sal_var= vvar.sal_var --and s.sal_destino=vvar.sal_destino 
                order by sal_var, opc_orden, w.var_orden
        loop            
            --flujo_s_ : variables saltadas en NULL
            r_destino=encu.validar_variable_destino(poperativo, vvar.var_for, vvar.var_mat, vvar.sal_var, vopc_s.sal_pre, vopc_s.var_destino);
            IF r_destino.ptipodestinosalto IS NOT NULL THEN
                r_saltadas=encu.variables_saltadas(poperativo, vvar.sal_var, r_destino.pvardestino,r_destino.ptipodestinosalto );
            ELSE
                r_saltadas.psaltadas_str='Revisar. Destino de salto no considerado';
                r_saltadas.psaltadas_cond_str='Revisar. Destino de salto no considerado';
            END IF;
            IF NOT r_saltadas.psaltadas_str='' THEN
               raise notice '% destino % str_saltadas_condicion % largo %',vopc_s.sal_var,vopc_s.var_destino, r_saltadas.psaltadas_cond_str, length(r_saltadas.psaltadas_cond_str) ; 
               rcons.con_ope=poperativo;
               rcons.con_con='flujo_s_' || vvar.sal_var ||'_' || vopc_s.sal_opc;
               rcons.con_precondicion= vvar.sal_var||'='||vopc_s.sal_opc;
               rcons.con_rel='=>';
               rcons.con_postcondicion=r_saltadas.psaltadas_cond_str; 
               rcons.con_explicacion='Con salto en '||vvar.sal_var||'='||vopc_s.sal_opc ||' no debe ingresar '|| r_saltadas.psaltadas_str;
               execute encu.insert_consistencia_flujo(rcons.con_ope, rcons.con_con, rcons.con_precondicion, rcons.con_rel,
                                    rcons.con_postcondicion, rcons.con_explicacion);
           END IF;                                
           --flujo_sv : VARIABLE DESTINO DEBE TENER VALOR
           IF vopc_s.var_destino_optativa IS FALSE AND r_destino.ptipodestinosalto in ('var','pre') THEN
               rcons.con_ope=poperativo;
               rcons.con_con='flujo_sv_' || vvar.sal_var ||'_' || vopc_s.sal_opc;
               --rcons.con_precondicion= vvar.sal_var||'='||vopc_s.sal_opc || coalesce (' and '|| vopc_s.var_expresion_habilitar,'') ;
               rcons.con_precondicion= vvar.sal_var||'='||vopc_s.sal_opc ;
               rcons.con_precondicion= rcons.con_precondicion ||case when coalesce(length(trim(vopc_s.var_expresion_habilitar)),0)>0 and rcons.con_precondicion is distinct from vopc_s.var_expresion_habilitar then ' and ('|| vopc_s.var_expresion_habilitar||')' else '' end;
               rcons.con_rel='=>';
               rcons.con_postcondicion= 'informado(' || vopc_s.var_destino || ')'; 
               rcons.con_explicacion='Con salto en '||vvar.sal_var||'='||vopc_s.sal_opc||' debe informar '|| vopc_s.var_destino;
               execute encu.insert_consistencia_flujo(rcons.con_ope, rcons.con_con, rcons.con_precondicion, rcons.con_rel,
                                    rcons.con_postcondicion, rcons.con_explicacion);
           END IF;         
           opc_saltos= opc_saltos || ' or ' ||  vopc_s.sal_var || '=' || vopc_s.sal_opc  ;
        END LOOP; 
        --flujo_v_
        -- consultar siguiente
        SELECT v.var_var, v.var_optativa , v.var_expresion_habilitar
            INTO vsiguiente, vsig_optativa, vsig_expresion_habilitar
            FROM encu.variables_ordenadas v 
                JOIN encu.variables_ordenadas x on x.var_ope=v.var_ope and v.var_for=x.var_for
                               and x.var_siguiente=v.var_var
            WHERE x.var_var= vvar.sal_var  and x.var_ope=poperativo
            ORDER BY v.orden
            LIMIT 1; 
        opc_saltos= substr(opc_saltos,5);
        IF vsiguiente is not null and vsig_optativa is false and opc_saltos<>'' THEN
           --raise notice 'saltos origen % ', opc_saltos;
           rcons.con_ope=poperativo; 
           rcons.con_con='flujo_v_' || vvar.sal_var;
           cond_nsnc='';
           IF vvar.var_destino_nsnc IS NOT NULL THEN
             cond_nsnc= 'and not ('||vvar.sal_var||'=-1 or '||vvar.sal_var||'=-9)';
           END IF;
           rcons.con_precondicion= 'informado(' ||vvar.sal_var||') and not('|| opc_saltos ||') '||
                                   cond_nsnc|| 
                                   case when coalesce(length(trim(vsig_expresion_habilitar)),0)>0 then ' and ('|| vsig_expresion_habilitar||')' else '' end;
           rcons.con_rel='=>';
           rcons.con_postcondicion= 'informado('||vsiguiente || ')'; 
           rcons.con_explicacion='Sin salto en '||vvar.sal_var||' debe informar '|| vsiguiente;
           execute encu.insert_consistencia_flujo(rcons.con_ope, rcons.con_con, rcons.con_precondicion, rcons.con_rel,
                                rcons.con_postcondicion, rcons.con_explicacion);
        END IF;
    END LOOP;
    FOR v_nsnc IN
        select var_for, var_var, var_destino_nsnc, var_tipovar
            from encu.variables_ordenadas  
            where var_ope=poperativo and var_for is distinct from 'SUP' and var_destino_nsnc is not null  
            order by orden         
    LOOP
      -- var_destino, str_saltadas, cond_saltadas, var_destino_optativa, expresion_habilitar_destino
        SELECT v.var_var, v.var_optativa, v.var_expresion_habilitar,
                case when v.var_var= v_nsnc.var_destino_nsnc then 'var' 
                     when v.var_pre=v_nsnc.var_destino_nsnc then 'pre' 
                     when v.blo_blo=v_nsnc.var_destino_nsnc then 'blo' 
                     else 'fil'
                end
            INTO nsnc_destino, nsnc_optativa, nsnc_expresion_habilitar, nsnc_tipodestino
            FROM encu.variables_ordenadas v 
            WHERE v.var_ope= poperativo AND 
                 (v.var_var= v_nsnc.var_destino_nsnc or v.var_pre=v_nsnc.var_destino_nsnc or v.blo_blo=v_nsnc.var_destino_nsnc)
            ORDER BY v.var_ope, v.var_orden
            LIMIT 1;
        --r_destino=encu.validar_variable_destino(poperativo, vvar.var_for, vvar.var_mat, vvar.sal_var, nsnc_destino, case when nsnc_tipodestino= then end );
        /*
        IF r_destino.ptipodestinosalto IS NOT NULL THEN
            r_saltadas=encu.variables_saltadas(poperativo, vvar.sal_var, r_destino.pvardestino );
        ELSE
            r_saltadas.psaltadas_str='Revisar. Destino de salto no considerado';
            r_saltadas.psaltadas_cond_str='Revisar. Destino de salto no considerado';
        END IF;            
        */    
        r_saltadas=encu.variables_saltadas(poperativo, v_nsnc.var_var, nsnc_destino,'var' );
        raise notice '% destino % saltadas_str % largo %',v_nsnc.var_var,nsnc_destino, r_saltadas.psaltadas_str, length(r_saltadas.psaltadas_str) ; 
        raise notice ' % destino % saltadas_cond_str %',v_nsnc.var_var,nsnc_destino, r_saltadas.psaltadas_cond_str;
        val_nsnc[1]='-1';
        val_nsnc[2]='-9';            
        IF v_nsnc.var_tipovar IN ('fecha','fecha_corta','observaciones','telefono','texto','texto_especificar','texto_libre','timestamp') THEN
            val_nsnc[1]='a_texto('||val_nsnc[1]||')';
            val_nsnc[2]='a_texto('||val_nsnc[2]||')';            
        END IF;
        IF NOT r_saltadas.psaltadas_str='' THEN
            -- flujo_s_xvar_nsnc
            rcons.con_ope=poperativo; 
            rcons.con_con='flujo_s_' || v_nsnc.var_var||'_nsnc';
            rcons.con_precondicion= v_nsnc.var_var||'='|| val_nsnc[1]||' or '||v_nsnc.var_var||'='|| val_nsnc[2];
            rcons.con_rel='=>';
            rcons.con_postcondicion= r_saltadas.psaltadas_cond_str; 
            rcons.con_explicacion='Con salto en '||v_nsnc.var_var||' por NSNC, no debe ingresar '|| r_saltadas.psaltadas_str ;
            execute encu.insert_consistencia_flujo(rcons.con_ope, rcons.con_con, rcons.con_precondicion, rcons.con_rel,
                                 rcons.con_postcondicion, rcons.con_explicacion);
        END IF;  
        IF nsnc_optativa IS FALSE  THEN
            -- flujo_sv_xvar_nsnc
            rcons.con_ope=poperativo; 
            rcons.con_con='flujo_sv_' || v_nsnc.var_var||'_nsnc';
            rcons.con_precondicion= '('||v_nsnc.var_var||'='||val_nsnc[1]||' or '||v_nsnc.var_var||'='||val_nsnc[2]||')' ||
                            case when coalesce(length(trim(nsnc_expresion_habilitar)),0)>0 then ' and '|| nsnc_expresion_habilitar else '' end ;
            rcons.con_rel='=>';
            rcons.con_postcondicion= 'informado(' || nsnc_destino || ')'; 
            rcons.con_explicacion='Con salto en '||v_nsnc.var_var||' por NSNC, debe informar '|| nsnc_destino;
            execute encu.insert_consistencia_flujo(rcons.con_ope, rcons.con_con, rcons.con_precondicion, rcons.con_rel,
                                 rcons.con_postcondicion, rcons.con_explicacion);
        END IF;        
    END LOOP;
END;
$BODY$
LANGUAGE plpgsql;
/*otra*/
ALTER FUNCTION encu.generar_consistencias_flujo(TEXT)
  OWNER TO tedede_php;