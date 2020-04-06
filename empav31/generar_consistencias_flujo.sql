--UTF8: SÍ;

UPDATE encu.variables
        set var_orden=1
        where var_ope='empav31' and var_var='v5_esp';
UPDATE encu.variables
        set var_orden=1
        where var_ope='empav31' and var_var='lugar_esp1';
UPDATE encu.variables
        set var_orden=3
        where var_ope='empav31' and var_var='lugar_esp3';
UPDATE encu.variables
        set var_orden=12
        where var_ope='empav31' and var_var='sn15k_esp';
        
set search_path= encu, comun, public;

CREATE OR REPLACE VIEW encu.variables_ordenadas AS
        select blo_for,blo_blo, blo_texto, blo_incluir_mat, blo_orden,
               v.var_ope, v.var_for, v.var_mat, v.var_pre, v.var_var, v.var_texto, v.var_aclaracion, 
               v.var_conopc, v.var_conopc_texto, v.var_tipovar, v.var_destino, v.var_subordinada_var, 
               v.var_subordinada_opcion, v.var_desp_nombre, v.var_expresion_habilitar, 
               v.var_optativa, v.var_editable_por, v.var_orden, v.var_nsnc_atipico, 
               v.var_destino_nsnc, v.var_calculada, p.pre_orden,
               row_number() 
                   over( order by f.for_orden, b.blo_mat,b.blo_orden, p.pre_orden, v.var_orden,coalesce(var_subordinada_var,'')) as orden,
               last_value(v.var_var) 
                    over (partition by blo_for            
                          order by f.for_orden, b.blo_mat,b.blo_orden, p.pre_orden, v.var_orden,coalesce(var_subordinada_var,'')
                          rows between unbounded preceding and unbounded following
                         ) as var_ultima_for,             
               lead(var_var, 1, 'fin' ) 
                    over (--partition by f.for_orden, b.blo_mat,b.blo_orden, p.pre_orden, var_pre               
                            order by f.for_orden, b.blo_mat,b.blo_orden, p.pre_orden, v.var_orden,var_pre
                            --rows between unbounded preceding  and unbounded following
                          ) as var_siguiente
            from encu.variables v 
                join encu.preguntas p    on p.pre_ope=v.var_ope and p.pre_pre= v.var_pre and 
                                            p.pre_for=v.var_for and p.pre_mat=v.var_mat
                join encu.bloques b      on b.blo_blo=p.pre_blo and b.blo_ope=p.pre_ope and 
                                            b.blo_for=p.pre_for and b.blo_mat=p.pre_mat
                join encu.formularios f  on f.for_for= b.blo_for AND f.for_ope=b.blo_ope
            where f.for_for<>'TEM'--and v.var_for='S1'
            order by f.for_orden, b.blo_mat,b.blo_orden, p.pre_orden, v.var_orden, coalesce(v.var_subordinada_var,'');
ALTER TABLE encu.variables_ordenadas
  OWNER TO tedede_php;

CREATE OR REPLACE FUNCTION encu.insert_consistencia_flujo(
                                       pcon_ope encu.consistencias.con_ope%type,
                                       pcon_con encu.consistencias.con_con%type, 
                                       pcon_precondicion encu.consistencias.con_precondicion%type,
                                       pcon_rel encu.consistencias.con_rel%type,
                                       pcon_postcondicion encu.consistencias.con_postcondicion%type,
                                       pcon_explicacion encu.consistencias.con_explicacion%type)
  RETURNS VOID AS
$BODY$
DECLARE
    xcon_activa             encu.consistencias.con_activa%type;
    xcon_tipo               encu.consistencias.con_tipo%type;
    xcon_falsos_positivos   encu.consistencias.con_falsos_positivos%type;  
    xcon_importancia        encu.consistencias.con_importancia%type;
    xcon_momento            encu.consistencias.con_momento%type;
    xcon_grupo              encu.consistencias.con_grupo%type;
    xcon_gravedad           encu.consistencias.con_gravedad%type;
BEGIN
   --xcon_expl_ok= false;
    --xcon_estado
   xcon_activa=true;   
   xcon_tipo='Auditoría';   
   xcon_falsos_positivos=false;
   xcon_importancia='ALTA';
   xcon_momento='Recepción';
   xcon_grupo='flujo'; 
   xcon_gravedad='Error';
    --con_descripcion	
    --con_modulo	
    --con_valida	
    --con_junta	
    --con_clausula_from	
    --con_expresion_sql	
    --con_error_compilacion	
    --con_ultima_variable	
    --con_orden	
  INSERT INTO encu.consistencias( con_ope,con_con,con_precondicion,con_rel, con_postcondicion,
            con_activa, con_explicacion, con_tipo, con_falsos_positivos,
            con_importancia, con_momento, con_grupo, con_gravedad, con_tlg)
   values( pcon_ope, pcon_con, pcon_precondicion, pcon_rel, pcon_postcondicion,
           xcon_activa, pcon_explicacion, xcon_tipo, xcon_falsos_positivos,
           xcon_importancia, xcon_momento, xcon_grupo, xcon_gravedad, 1) ;                        

END;
$BODY$
LANGUAGE plpgsql;
ALTER FUNCTION encu.insert_consistencia_flujo(pcon_ope encu.consistencias.con_ope%type,
                                       pcon_con encu.consistencias.con_con%type, 
                                       pcon_precondicion encu.consistencias.con_precondicion%type,
                                       pcon_rel encu.consistencias.con_rel%type,
                                       pcon_postcondicion encu.consistencias.con_postcondicion%type,
                                       pcon_explicacion encu.consistencias.con_explicacion%type)
  OWNER TO tedede_php;

DROP FUNCTION if exists encu.variables_saltadas(text, text, text) ;
CREATE OR REPLACE FUNCTION encu.variables_saltadas(pope text, porigen TEXT, pdestino TEXT, OUT psaltadas_str TEXT, OUT psaltadas_cond_str TEXT)
  AS
$BODY$
DECLARE
  c_all_vars RECORD;
BEGIN
    psaltadas_str='';
    psaltadas_cond_str='';
    FOR c_all_vars IN
      select var_var
         from encu.variables_ordenadas v,
                (SELECT orden FROM encu.variables_ordenadas where var_ope=pope and var_var=porigen) as origen,
                (SELECT orden 
                    FROM encu.variables_ordenadas 
                    where var_ope=pope and 
                          var_var=CASE WHEN pdestino IS NOT NULL THEN pdestino
                                       ELSE (SELECT var_ultima_for 
                                                 FROM encu.variables_ordenadas 
                                                 WHERE var_ope=pope and var_var= porigen
                                            )
                                       END  
                 ) as destino
         where v.var_ope=pope and v.orden >origen.orden and 
              (v.orden<destino.orden or (pdestino is null and  v.orden=destino.orden))           
         order by v.orden
    LOOP
         psaltadas_cond_str=  psaltadas_cond_str ||' and '|| c_all_vars.var_var|| ' is null' ;
         psaltadas_str= psaltadas_str || ', ' ||c_all_vars.var_var;
    END LOOP;
    IF psaltadas_str <>'' THEN
        psaltadas_cond_str= substr( psaltadas_cond_str,6);
        psaltadas_str= substr( psaltadas_str,3);
    END IF;
END;
$BODY$
LANGUAGE plpgsql;
ALTER FUNCTION encu.variables_saltadas(pope TEXT, porigen TEXT, pdestino TEXT)
  OWNER TO tedede_php;

--SELECT encu.variables_saltadas('empav31','t3','t13'), ('t3') --{t4,t5,t6,t7,t8,t8_otro,t9,t10,t11,t11_otro,t12}

CREATE OR REPLACE FUNCTION encu.generar_consistencias_flujo(poperativo TEXT)
  RETURNS void AS
$BODY$
DECLARE
 opc_saltos text;
 rcons encu.consistencias%rowtype;
 r_saltadas RECORD;
 vvar RECORD;
 vopc_s RECORD;
 vsiguiente TEXT;
 vsig_optativa boolean;
 vsig_expresion_habilitar TEXT;
 cond_nsnc text;
 v_nsnc RECORD;
 nsnc_destino TEXT;
 nsnc_optativa BOOLEAN;
 nsnc_expresion_habilitar TEXT;
 val_nsnc varchar(50)[];
BEGIN  
    -- Borrar las automaticas
    DELETE FROM encu.inconsistencias
        WHERE inc_ope=poperativo and inc_con like 'flujo%';
    DELETE FROM encu.ano_con
        WHERE anocon_ope=poperativo and anocon_con like 'flujo%';
    DELETE FROM encu.con_var
        WHERE convar_ope=poperativo and convar_con like 'flujo%';
    DELETE FROM encu.consistencias
        WHERE con_ope=poperativo and con_con like 'flujo%';
    FOR vvar IN
        select distinct v.var_for, v.var_mat, s.sal_var, v.var_destino_nsnc
            from encu.saltos s JOIN encu.variables v ON s.sal_var= v.var_var AND s.sal_ope=v.var_ope
            where s.sal_ope=poperativo  
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
           r_saltadas=encu.variables_saltadas(poperativo, vvar.sal_var, vopc_s.var_destino );
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
           IF vopc_s.var_destino_optativa IS FALSE  THEN
               rcons.con_ope=poperativo;
               rcons.con_con='flujo_sv_' || vvar.sal_var ||'_' || vopc_s.sal_opc;
               rcons.con_precondicion= vvar.sal_var||'='||vopc_s.sal_opc || coalesce (' and '|| vopc_s.var_expresion_habilitar,'') ;
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
                JOIN encu.variables_ordenadas x on x.var_ope=v.var_ope and x.orden<v.orden
                               and x.pre_orden<=v.pre_orden and v.var_for=x.var_for
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
                                   coalesce (' and ('|| vsig_expresion_habilitar||')','')  ;
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
            where var_ope=poperativo and var_destino_nsnc is not null  
            order by orden         
    LOOP
      -- var_destino, str_saltadas, cond_saltadas, var_destino_optativa, expresion_habilitar_destino
        SELECT v.var_var, v.var_optativa, v.var_expresion_habilitar
            INTO nsnc_destino, nsnc_optativa, nsnc_expresion_habilitar
            FROM encu.variables_ordenadas v 
            WHERE v.var_ope= poperativo AND 
                 (v.var_var= v_nsnc.var_destino_nsnc or v.var_pre=v_nsnc.var_destino_nsnc or v.blo_blo=v_nsnc.var_destino_nsnc)
            ORDER BY v.var_ope, v.var_orden
            LIMIT 1;
        r_saltadas=encu.variables_saltadas(poperativo, v_nsnc.var_var, nsnc_destino );
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
            rcons.con_precondicion= '('||v_nsnc.var_var||'='||val_nsnc[1]||' or '||v_nsnc.var_var||'='||val_nsnc[2]||')' || coalesce (' and '|| nsnc_expresion_habilitar,'') ;
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
ALTER FUNCTION encu.generar_consistencias_flujo(TEXT)
  OWNER TO tedede_php;