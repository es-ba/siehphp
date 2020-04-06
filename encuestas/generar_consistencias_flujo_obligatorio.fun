##FUN
generar_consistencias_flujo_obligatorio
##ESQ
encu
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO
set search_path= encu, comun, dbo, public;
CREATE OR REPLACE FUNCTION encu.generar_consistencias_flujo_obligatorio()
  RETURNS void AS
$BODY$
DECLARE
 poperativo TEXT; 
 opc_saltos text;
 rcons encu.consistencias%rowtype;
 r_saltadas RECORD;
 r_destino RECORD;
 vvar RECORD;
 vobli_s RECORD;
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
    poperativo= dbo.ope_actual();
    -- Borrar las automaticas
    DELETE FROM encu.inconsistencias
        WHERE inc_ope=poperativo and inc_con SIMILAR TO 'flujo_o\_(s|v|sv)\_%';
    DELETE FROM encu.ano_con
        WHERE anocon_ope=poperativo and anocon_con SIMILAR TO 'flujo_o\_(s|v|sv)\_%';
    DELETE FROM encu.con_var
        WHERE convar_ope=poperativo and convar_con SIMILAR TO 'flujo_o\_(s|v|sv)\_%';
    DELETE FROM encu.consistencias
        WHERE con_ope=poperativo and con_con SIMILAR TO 'flujo_o\_(s|v|sv)\_%';
    FOR vvar IN --para cada salto
        select distinct v.var_for, v.var_mat, v.var_var, v.var_destino_nsnc
            from encu.variables v
            where v.var_ope=poperativo and v.var_for is distinct from 'SUP' AND var_destino IS NOT NULL and replace(var_destino,' ','') is distinct from ''
            order by v.var_for, v.var_mat, v.var_var            
    LOOP
        FOR vobli_s IN
            select s.var_var, s.var_destino as var_pre_destino, w.var_var as var_destino,w.var_expresion_habilitar,
                   w.var_optativa as var_destino_optativa
                from encu.variables s 
                    LEFT JOIN encu.variables w ON  w.var_pre=s.var_destino and w.var_ope=s.var_ope and w.var_for=vvar.var_for and w.var_mat=vvar.var_mat
                where s.var_ope=poperativo and s.var_var= vvar.var_var --and s.sal_destino=vvar.sal_destino 
                order by var_var, w.var_orden
                limit 1
        loop            
            --flujo_s_ : variables saltadas en NULL
            r_destino=encu.validar_variable_destino(poperativo, vvar.var_for, vvar.var_mat, vvar.var_var, vobli_s.var_pre_destino, vobli_s.var_destino);
            IF r_destino.ptipodestinosalto IS NOT NULL THEN
                r_saltadas=encu.variables_saltadas(poperativo, vvar.var_var, r_destino.pvardestino,r_destino.ptipodestinosalto );
            ELSE
                r_saltadas.psaltadas_str='Revisar. Destino de salto no considerado';
                r_saltadas.psaltadas_cond_str='Revisar. Destino de salto no considerado';
            END IF;
            IF NOT r_saltadas.psaltadas_str='' THEN
               raise notice '% destino % str_saltadas_condicion % largo %',vobli_s.var_var,vobli_s.var_destino, r_saltadas.psaltadas_cond_str, length(r_saltadas.psaltadas_cond_str) ; 
               rcons.con_ope=poperativo;
               rcons.con_con='flujo_o_s_' || vvar.var_var ;
               rcons.con_precondicion= 'informado('||vvar.var_var||')';
               rcons.con_rel='=>';
               rcons.con_postcondicion=r_saltadas.psaltadas_cond_str; 
               rcons.con_explicacion='Con salto obligatorio en '||vvar.var_var||' no debe ingresar '|| r_saltadas.psaltadas_str;
               execute encu.insert_consistencia_flujo(rcons.con_ope, rcons.con_con, rcons.con_precondicion, rcons.con_rel,
                                    rcons.con_postcondicion, rcons.con_explicacion);
           END IF;                                
           --flujo_sv : VARIABLE DESTINO DEBE TENER VALOR
           IF vobli_s.var_destino_optativa IS FALSE AND r_destino.ptipodestinosalto in ('var','pre') THEN
               rcons.con_ope=poperativo;
               rcons.con_con='flujo_o_sv_' || vvar.var_var ;
               --rcons.con_precondicion= vvar.var_var||'='||vobli_s.sal_opc || coalesce (' and '|| vobli_s.var_expresion_habilitar,'') ;
               rcons.con_precondicion= 'informado('||vvar.var_var||')';
               rcons.con_precondicion= rcons.con_precondicion ||case when coalesce(length(trim(vobli_s.var_expresion_habilitar)),0)>0 and rcons.con_precondicion is distinct from vobli_s.var_expresion_habilitar then ' and ('|| vobli_s.var_expresion_habilitar||')' else '' end;
               rcons.con_rel='=>';
               rcons.con_postcondicion= 'informado(' || vobli_s.var_destino || ')'; 
               rcons.con_explicacion='Con salto obligatorio en '||vvar.var_var||' debe informar '|| vobli_s.var_destino;
               execute encu.insert_consistencia_flujo(rcons.con_ope, rcons.con_con, rcons.con_precondicion, rcons.con_rel,
                                    rcons.con_postcondicion, rcons.con_explicacion);
           END IF;         
        END LOOP; 
    END LOOP;
END;
$BODY$
LANGUAGE plpgsql;
/*otra*/
ALTER FUNCTION encu.generar_consistencias_flujo_obligatorio()
  OWNER TO tedede_php;