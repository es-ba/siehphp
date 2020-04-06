set search_path = encu, comun, public;
/*OTRA*/
CREATE OR REPLACE FUNCTION encu.fin_de_campo_automatico()
  RETURNS void AS
$BODY$
INSERT INTO encu.sesiones(ses_usu, ses_activa,ses_borro_localStorage, ses_phpsessid, ses_httpua, ses_remote_addr) 
  values ('instalador', true, false, 'internal', (select httpua_httpua from encu.http_user_agent where httpua_texto='PostgreSQL internal'),'127.0.0.1');

INSERT INTO encu.tiempo_logico(tlg_ses) select max(ses_ses) from encu.sesiones where ses_usu='instalador';

update encu.respuestas r
     set res_valor='1',
         res_tlg=(
                select max(tlg_tlg) 
                  from encu.tiempo_logico  
                  where tlg_ses=(
                          select max(ses_ses) 
                            from encu.sesiones 
                            where ses_usu='instalador'
                   )
                )
     from (
          select t_69.*, f_ult_mod_est,  extract(days from (now() - f_ult_mod_est)) dias,
               case when (extract(days from (now() - f_ult_mod_est))> t_69.dom_dias_para_fin) then 'FinCampo' else 'NoFinaliza' end as accion
          from
              (
                select  pla_enc, pla_dominio, pla_rea, d.dom_dias_para_fin_norea,d.dom_dias_para_fin_campo,
                        case when pla_rea in (0,2) then d.dom_dias_para_fin_norea else d.dom_dias_para_fin_campo end as dom_dias_para_fin           
                    from encu.plana_tem_ left join encu.dominio d on pla_dominio= d.dom_dom
                    where pla_estado=69
               ) as t_69,
               (select res_enc  as enc, tlg_momento f_ult_mod_est
                    from encu.respuestas r join encu.tiempo_logico t on r.res_tlg=t.tlg_tlg 
                    where res_ope=dbo.ope_actual() and res_for ='TEM' and res_var='estado'
                ) as r_t
          where t_69.pla_enc= r_t.enc
          and extract(days from (now() - f_ult_mod_est))>= t_69.dom_dias_para_fin 
          ) as x 
     where x.pla_enc= r.res_enc AND r.res_ope=dbo.ope_actual() 
        and r.res_for='TEM'
        and r.res_var='fin_de_campo';
$BODY$
  LANGUAGE sql VOLATILE;
/*OTRA*/
ALTER FUNCTION encu.fin_de_campo_automatico()
  OWNER TO tedede_php;
/*OTRA*/  
CREATE OR REPLACE FUNCTION encu.reconocer_agregadores(IN p_cual text, OUT p_funcion text, OUT p_expresion text, OUT p_filtro text)
  RETURNS record AS
$BODY$
  SELECT trim(v_obtenido[1]), trim(v_obtenido[2]), trim(v_obtenido[4]) from regexp_matches(p_cual,'@\(([^@]*)@([^@]*)(@([^@]*))?\)@') as v_obtenido;
/*
  SELECT entrada, funcion, expresion, filtro, encu.reconocer_agregadores(entrada)
    FROM (SELECT 't55>@(sumap@ i3_x + i3_t @ edad>14)@' as entrada, 'sumap' as funcion, 'i3_x + i3_t' as expresion, 'edad>14' as filtro
         UNION SELECT 't55>@( sumap @X25)@ + 44' as entrada, 'sumap' as funcion, 'X25' as expresion, null as filtro
         UNION SELECT 't55 + 1 ' as entrada, 'sumap' as funcion, 'X25' as expresion, null as filtro
         UNION SELECT '@( sumap @ sarasa sasa )@' as entrada, 'sumap' as funcion, 'sarasa sasa' as expresion, null as filtro) x
    WHERE (funcion, expresion, filtro) is distinct from encu.reconocer_agregadores(entrada);
--*/
$BODY$
  LANGUAGE sql IMMUTABLE;
/*OTRA*/  
ALTER FUNCTION encu.reconocer_agregadores(text)
  OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION encu.reemplazar_agregadores(p_cual text)
  RETURNS text AS
$BODY$
DECLARE
  v_cursor RECORD;
  v_obtenido TEXT:=p_cual;
  v_max_num integer;
  v_fun_abreviado text;
  v_fun_codigo text;
  v_funcion text;
  v_expresion text;
  v_filtro text;
BEGIN
  --RAISE NOTICE 'ENTRO CON %',p_cual;
  FOR v_cursor IN
    SELECT x[1] as encontrado, fun_fun, fun_abreviado
      FROM regexp_matches(p_cual,'@\(.*?\)@','g') x 
         LEFT JOIN dbx.funciones_automaticas ON x[1]=fun_fun
  LOOP
    --RAISE NOTICE 'ENCUENTRO % / % / %',v_cursor.encontrado,v_cursor.fun_fun,v_cursor.fun_abreviado;
    if v_cursor.fun_fun is null then
      if length(v_cursor.encontrado)>56 then
        RAISE NOTICE 'LARGO %',length(v_cursor.encontrado);
        select max(substr(fun_fun,57,4)::integer)
          into v_max_num
          from dbx.funciones_automaticas
          where substr(fun_fun,1,56)=substr(p_cual,1,56);
        v_fun_abreviado:=substr(v_cursor.encontrado,1,56)||'_'||trim(to_char(coalesce(v_max_num,1),'0000'))||')@';
      else
        v_fun_abreviado:=v_cursor.encontrado;
      end if;
      SELECT * FROM encu.reconocer_agregadores(v_cursor.encontrado) INTO v_funcion, v_expresion, v_filtro;
      RAISE NOTICE 'RECONOCER: % / % / % / %',v_fun_abreviado,v_funcion, v_expresion, v_filtro;
      IF v_funcion<>'sumap' and v_funcion<>'contarc' THEN 
        RAISE 'No se reconoce la funcion agregada %',v_funcion;
      END IF;
      v_expresion:=reemplazar_variables(v_expresion,'pla_\1');
      v_filtro:=reemplazar_variables(v_filtro,'pla_\1');
      if v_funcion='sumap' then
        v_fun_codigo:=$$
            CREATE OR REPLACE FUNCTION dbx.$$||quote_ident(v_fun_abreviado)||$$(p_enc integer, p_hog integer) RETURNS BIGINT 
            LANGUAGE SQL AS
            $SQL$ SELECT SUM(CASE WHEN $$||v_expresion||$$>0 THEN $$||v_expresion||$$ ELSE NULL END) 
                    FROM plana_i1_ i1 INNER JOIN plana_s1_p s1p ON i1.pla_enc=s1p.pla_enc AND i1.pla_hog=s1p.pla_hog AND i1.pla_mie=s1p.pla_mie
                        INNER JOIN plana_s1_ s1 ON i1.pla_enc=s1.pla_enc AND i1.pla_hog=s1.pla_hog 
                        INNER JOIN plana_a1_ a1 ON i1.pla_enc=a1.pla_enc AND i1.pla_hog=a1.pla_hog 
                        INNER JOIN plana_tem_ t ON i1.pla_enc=t.pla_enc 
                    WHERE i1.pla_enc=p_enc and i1.pla_hog=p_hog and 
                        $$||coalesce(v_filtro,'TRUE')||$$ 
                        /* $$||v_cursor.encontrado||$$  */
                    $SQL$;
        $$;
      else 
        if v_funcion='contarc' then
            v_fun_codigo:=$$
                CREATE OR REPLACE FUNCTION dbx.$$||quote_ident(v_fun_abreviado)||$$(p_enc integer, p_hog integer) RETURNS BIGINT 
                LANGUAGE SQL AS
                $SQL$ SELECT COUNT($$||v_expresion||$$) 
                        FROM plana_i1_ i1 INNER JOIN plana_s1_p s1p ON i1.pla_enc=s1p.pla_enc AND i1.pla_hog=s1p.pla_hog AND i1.pla_mie=s1p.pla_mie
                            INNER JOIN plana_s1_ s1 ON i1.pla_enc=s1.pla_enc AND i1.pla_hog=s1.pla_hog 
                            INNER JOIN plana_a1_ a1 ON i1.pla_enc=a1.pla_enc AND i1.pla_hog=a1.pla_hog 
                            INNER JOIN plana_tem_ t ON i1.pla_enc=t.pla_enc 
                        WHERE i1.pla_enc=p_enc and i1.pla_hog=p_hog and 
                            $$||coalesce(v_filtro,'TRUE')||$$ 
                            /* $$||v_cursor.encontrado||$$  */
                        $SQL$;
            $$;
        end if;
      end if;
      EXECUTE v_fun_codigo;
      INSERT INTO dbx.funciones_automaticas (fun_fun, fun_abreviado, fun_codigo)
        VALUES (v_cursor.encontrado, v_fun_abreviado, v_fun_codigo);
    else
      v_fun_abreviado:=v_cursor.fun_abreviado;
    end if;
    -- v_obtenido:=replace(v_obtenido,v_cursor.encontrado, quote_ident(v_fun_abreviado)||'(enc,hog)');
    v_obtenido:=replace(v_obtenido,v_cursor.encontrado, 'dbx.'||quote_ident(v_fun_abreviado)||'(enc,hog)');
  END LOOP;
  return v_obtenido;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*OTRA*/  
ALTER FUNCTION encu.reemplazar_agregadores(text)
  OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION encu.sincronizacion_tem_datos(IN p_ope text, IN p_enc integer, OUT p_rea integer, OUT p_norea integer, OUT p_rea_enc integer, OUT p_norea_enc integer, OUT p_con_dato_enc integer, OUT p_rea_recu integer, OUT p_norea_recu integer, OUT p_con_dato_recu integer, OUT p_pob_tot integer, OUT p_pob_pre integer, OUT p_hog_tot integer, OUT p_hog_pre integer)
  RETURNS record AS
$BODY$
DECLARE
    v_max_entrea    integer;
    v_min_entrea    integer;
    v_cod_recu      integer;
    v_norea         integer;
    v_rol           text;
    v_con_dato      integer;
    v_for_hogar     text;
    v_sentencia     text;
    v_where         text;
    v_n_entrea4     integer;    
BEGIN
    p_rea:=null;
    p_norea:=null;
    p_rea_enc:=null;
    p_norea_enc:=null;
    p_con_dato_enc:=null;
    p_rea_recu:=null;
    p_norea_recu:=null;
    p_con_dato_recu:=null; 
    p_pob_tot:=null;
    p_pob_pre:=null;
    p_hog_tot:=null;
    p_hog_pre:=null;
    SELECT pla_cod_recu,pla_rol
        INTO v_cod_recu, v_rol
        FROM plana_tem_ t 
        WHERE pla_enc=p_enc;
    --PARA GENERALIZAR FORMULARIO DE LA PLANA_xx_
    select for_for into v_for_hogar from formularios where for_es_principal and for_ope=p_ope; 
    v_sentencia:= $$
        SELECT max(pla_total_h) as hog_tot, count(case when pla_entrea=1 then 1 else null end) as hog_pre,
               max(coalesce(pla_entrea,-1)) as max_entrea, min(coalesce(pla_entrea,-1)) as min_entrea,
               count(case when pla_entrea=4 then 1 else null end) as cant_entrea4                
    $$; 
    v_where:= $$
        WHERE pla_enc=$1
    $$;
    EXECUTE v_sentencia || ' FROM plana_' || v_for_hogar || '_ ' || v_where  INTO p_hog_tot, p_hog_pre, v_max_entrea, v_min_entrea, v_n_entrea4 using  p_enc;   
    v_sentencia:= $$
        SELECT nullif(
                (coalesce(pla_razon1,0)::text || 
                coalesce(case s1.pla_razon1 
                when 1 then case when s1.pla_razon2_1 > 0 then s1.pla_razon2_1 else '0' end::text 
                when 2 then case when s1.pla_razon2_2 > 0 then s1.pla_razon2_2 else '0' end::text 
                when 3 then case when s1.pla_razon2_3 > 0 then s1.pla_razon2_3 else '0' end::text 
                when 4 then case when s1.pla_razon2_4 > 0 then s1.pla_razon2_4 else '0' end::text 
                when 5 then case when s1.pla_razon2_5 > 0 then s1.pla_razon2_5 else '0' end::text 
                when 6 then case when s1.pla_razon2_6 > 0 then s1.pla_razon2_6 else '0' end::text
                when 7 then case when s1.pla_razon2_7 > 0 then s1.pla_razon2_7 else '0' end::text 
                when 8 then case when s1.pla_razon2_8 > 0 then s1.pla_razon2_8 else '0' end::text 
                when 9 then case when s1.pla_razon2_9 > 0 then s1.pla_razon2_9 else '0' end::text end,'0')),'00') 
    $$;
    v_where:= $$
        WHERE s1.pla_enc=$1 and s1.pla_hog=1
    $$;
    EXECUTE v_sentencia || ' FROM plana_' || v_for_hogar || '_ s1 ' || v_where INTO v_norea using p_enc;
    v_sentencia:= $$            
        SELECT count(distinct res_hog::text||'-'||res_mie::text) FROM respuestas 
    $$;
    v_where:=$$
        WHERE res_ope=$1 and res_enc=$2 and res_for=$3 and res_mat='' 
            and res_valor is not null and trim(res_valor)<>''
    $$;
    EXECUTE v_sentencia || v_where into p_pob_pre using p_ope, p_enc, 'I1'; -- OJO GENERALIZAR 
    v_sentencia:= $$
        SELECT count(distinct m.res_hog::text||'-'||m.res_mie::text) FROM respuestas m
    $$;
    v_where:= $$
        WHERE m.res_ope=$1 and m.res_enc=$2 and m.res_for=$3 and m.res_mat='P' 
            and (m.res_valor is not null or trim(m.res_valor)<>'')
            and m.res_mie in (
            SELECT res_mie FROM encu.respuestas
                WHERE res_ope=$1 and res_enc=$2 and res_for=$3 and res_mat='P' 
                    and res_hog=m.res_hog and res_mie=m.res_mie                
                    and res_var ='p7' 
                    and (res_valor is null or res_valor not in ('3','4')));
    $$;  
    EXECUTE v_sentencia || v_where  into p_pob_tot using p_ope, p_enc, v_for_hogar;  
    if v_max_entrea=2 and v_min_entrea=2 then
        if v_cod_recu is null then
            p_rea:=0;
        else
            p_rea:=2;
        end if;
        p_norea:=v_norea;
    elsif v_max_entrea=v_min_entrea and v_max_entrea in (1,4,5) then
        if v_max_entrea in (4,5) then
            p_rea=v_max_entrea;
        else
            if v_cod_recu is null then
                p_rea:=1;
            else
                p_rea:=3;
            end if;
        end if;
    elsif v_n_entrea4>0 then
            p_rea=4;   
    else
        if v_cod_recu is null then
            p_rea:=0;
            p_norea:=10;
        else
            p_rea:=2;
            p_norea:=18;
        end if;            
    end if;
    SELECT distinct 1 into v_con_dato
      FROM encu.respuestas 
      WHERE res_ope=p_ope and res_enc=p_enc and res_for<>'TEM' and (res_valor is not null or trim(res_valor)<>'');
    v_con_dato:=coalesce (v_con_dato,0);
    IF v_rol='encuestador' THEN
        p_rea_enc=p_rea;
        p_norea_enc=p_norea;
        p_con_dato_enc=v_con_dato;
    END IF;
    IF v_rol='recuperador' THEN
        p_rea_recu=p_rea;
        p_norea_recu=p_norea;
        p_con_dato_recu=v_con_dato;
    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*OTRA*/  
ALTER FUNCTION encu.sincronizacion_tem_datos(text, integer)
  OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION encu.variables_base_usuarios(p_base text)
  RETURNS void AS
$BODY$
DECLARE
   v_sentencia_var text;
   v_sentencia_var_hog text;
   v_sentencia_var_pers text;
   v_var_seleccionadas record;
   v_sentencia text;
   v_clausula text;
   v_vista text;
   v_campos_select text;
BEGIN
    v_sentencia= '';
    v_clausula='';
    v_sentencia_var:='';
    v_sentencia_var_hog:='';
    v_sentencia_var_pers:='';
    v_campos_select:='';
    v_vista:='';
    FOR v_var_seleccionadas in
       select column_name as var_bu, 
              case when varcal_nombrevar_baseusuario is not null then varcal_nombrevar_baseusuario  
              when var_nombrevar_baseusuario is not null then var_nombrevar_baseusuario 
              else substr(column_name,5) end as var_nombrebu,
              case when table_name in ('plana_i1_', 'plana_s1_p') then 'personas' 
                   when table_name in ('plana_a1_', 'plana_tem_', 'plana_s1_') then 'hogar' else '' end as tabla,
              case when varcal_nombrevar_baseusuario is not null then 2  
                   when var_nombrevar_baseusuario is not null then 1
                   else 0 end as var_orden      
          from information_schema.columns
            left join encu.varcal on varcal_ope = dbo.ope_actual() and varcal_activa and varcal_varcal=substr(column_name,5)
            left join encu.variables on var_ope = dbo.ope_actual() and var_var=substr(column_name,5) 
          where table_name in ('plana_a1_', 'plana_tem_', 'plana_s1_','plana_s1_p','plana_i1_') and table_schema='encu'
             and  substr(column_name,5) not in ('enc','hog','mie','exm','tlg')
             and  (varcal_baseusuario or var_baseusuario)
          order by tabla,var_orden,var_bu 
    LOOP
       IF p_base='basehogar' AND v_var_seleccionadas.tabla='hogar' THEN
         v_sentencia_var_hog:=v_sentencia_var_hog||v_var_seleccionadas.var_bu||' as '||v_var_seleccionadas.var_nombrebu||' ,';
       END IF;
       IF p_base='basepersonas' AND v_var_seleccionadas.tabla='personas' THEN
         v_sentencia_var_pers:=v_sentencia_var_pers||v_var_seleccionadas.var_bu||' as '||v_var_seleccionadas.var_nombrebu||' ,';
       END IF;  
    END LOOP;
       IF p_base='basehogar' THEN 
          v_clausula:=' from encu.plana_a1_ a
                         inner join encu.plana_s1_ as s1 on a.pla_enc=s1.pla_enc and a.pla_hog=s1.pla_hog
                         inner join encu.plana_tem_ t on a.pla_enc=t.pla_enc 
                         where t.pla_estado =79
                         order by a.pla_enc, a.pla_hog  ';
          v_sentencia_var:=substr(v_sentencia_var_hog,1,length(v_sentencia_var_hog)-1);
          v_campos_select:=' select a.pla_enc as enc, a.pla_hog as hog, ';          
       END IF;
       IF p_base='basepersonas' THEN                
       /* seria para personas*/                   
          v_clausula='  from encu.plana_s1_p s1_p 
                        inner join encu.plana_i1_ i1 on s1_p.pla_enc=i1.pla_enc and s1_p.pla_hog=i1.pla_hog and s1_p.pla_mie=i1.pla_mie
                        inner join encu.plana_tem_ t on t.pla_enc=i1.pla_enc and t.pla_hog=0 and t.pla_mie=0
                        where t.pla_estado =79                        
                        order by s1_p.pla_enc, s1_p.pla_hog, s1_p.pla_mie  ';
          v_sentencia_var:=substr(v_sentencia_var_pers,1,length(v_sentencia_var_pers)-1);
          v_campos_select:=' select s1_p.pla_enc as enc, s1_p.pla_hog as hog, s1_p.pla_mie as mie, ';
       END IF;
       v_vista:=' drop view if exists encu.v_'||p_base||' ; '|| ' create view encu.v_'||p_base||' as ' ;
      -- raise notice 'v_vista %', v_vista;
       v_sentencia:=v_vista||v_campos_select||v_sentencia_var||v_clausula||';';
      -- raise notice 'Sentencia  %', v_sentencia;  
       execute v_sentencia;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*OTRA*/   
ALTER FUNCTION encu.variables_base_usuarios(text)
  OWNER TO tedede_php;
/*OTRA*/ 