
CREATE OR REPLACE FUNCTION encu.vista_base_producida_ut(
    p_base text,
    p_producida text,
    p_estado_desde integer,
    p_estado_hasta integer,
    p_modo text)
  RETURNS void AS
$BODY$
DECLARE
   v_var_seleccionadas record;
   v_salida record;
   v_sentencia text;
   v_clausula text;
   v_vista text;
   v_campos_select text;
   v_var_bu text;
   v_hoy_es text;
   v_transformada text;
   v_tipo character varying;
   v_sindato integer;
   v_null integer;
   v_atipico integer;
   v_cambiar boolean;
   v_exporta_pks boolean;
   v_join_pla_ext_hog text;
   val_modo text;
   v_clave TEXT;
   v_nombre     text;
   
BEGIN
    v_sentencia= '';
    v_clausula='';
    v_campos_select:='';
    v_vista:='';
    v_hoy_es:='';
    v_transformada:='';
    FOR v_var_seleccionadas in
       select pre_blo, table_name, column_name as var_bu, 
              coalesce(basprovar_alias,basprovar_var) as var_nombrebu,
              case when table_name = 'pla_ext_hog' and varcal_destino in ('hog','tem')  then 'hogar'
                   when table_name = 'pla_ext_hog' and varcal_destino ='mie'            then 'personas'
                   when table_name in ('plana_i1_')                                     then 'individual'
                   when table_name in ('plana_s1_p')                                    then 'personas' 
                   when table_name in ('plana_a1_', 'plana_tem_', 'plana_s1_')          then 'hogar' 
                   when table_name in ('plana_a1_x')                                    then 'exm' 
                   when table_name in ('plana_a1_m')                                    then 'exm_men' 
                   when table_name in ('diario_actividades_ajustado_vw')                then 'diario' 
                   else '' end as tabla,
              case when varcal_varcal is not null then 2  
                   when var_var is not null then 1
                   else 0 end as var_orden, data_type as var_tipo, basprovar_cantdecimales as cantdecimales,
                   basprovar_orden as orden, baspro_cambiar_especiales, baspro_cambiar_nsnc_por, baspro_cambiar_sindato_por, baspro_cambiar_null_por,
              case when table_name='plana_tem_' then baspro_cambiar_nsnc_por
                   when varcal_varcal is null then coalesce(var_nsnc_atipico, baspro_cambiar_nsnc_por) 
                   when var_var is null then coalesce(varcal_nsnc_atipico, baspro_cambiar_nsnc_por) end as nsnc_atipico,
              basprovar_exportar_en
          from encu.baspro
            left join encu.baspro_var_ut on baspro_ope = basprovar_ope and baspro_baspro = basprovar_baspro
            left join (SELECT table_name, column_name, substr(column_name,5) as infovariable, data_type
                         FROM information_schema.columns
                         WHERE table_name in ('plana_a1_', 'plana_tem_', 'plana_s1_','plana_s1_p','plana_i1_', 'plana_a1_x', 'plana_a1_m','pla_ext_hog','diario_actividades_ajustado_vw') and table_schema='encu'
                           and (substr(column_name,5) not in ('enc','hog','exm','mie','tlg') or column_name='pla_exm' and table_name in ('plana_a1_x'))) i ON basprovar_var = infovariable
            left join encu.varcal on varcal_ope = basprovar_ope and varcal_activa and varcal_varcal= infovariable
            left join encu.variables on var_ope = basprovar_ope and var_var= infovariable
            left join encu.preguntas on var_ope = pre_ope and var_pre = pre_pre
          where baspro_ope = dbo.ope_actual() and baspro_baspro = p_producida and basprovar_salida = p_base 
          order by basprovar_orden, orden,tabla,var_orden,var_bu 
    LOOP  
        v_join_pla_ext_hog='';
        if p_modo!='' then
            val_modo=dbo.ope_actual();
            if p_modo='ETOI' then
                val_modo=p_modo;
            end if;
            v_join_pla_ext_hog=' inner join encu.pla_ext_hog x on x.pla_enc= s1.pla_enc and x.pla_hog= s1.pla_hog and x.pla_modo='''|| val_modo ||'''';
        end if;
        CASE 
            WHEN ( (dbo.ope_actual()= 'same2014' or dbo.ope_actual()= 'ut2015' or dbo.ope_actual()='ut2016') and    v_var_seleccionadas.table_name = 'plana_s1_') or v_var_seleccionadas.table_name = 'plana_a1_' and v_var_seleccionadas.var_bu<>'pla_exm'
            THEN CASE WHEN v_var_seleccionadas.pre_blo = 'Viv'
                THEN v_var_bu = 'v.'||v_var_seleccionadas.var_bu;
                ELSE v_var_bu = 's.'||v_var_seleccionadas.var_bu;
                END CASE;
            ELSE
                v_var_bu = v_var_seleccionadas.var_bu;
        END CASE;
        IF v_var_bu='pla_exm' THEN
          v_var_bu:='a1_x.pla_exm';
        END IF;
        v_tipo   :=v_var_seleccionadas.var_tipo;
        v_sindato:=v_var_seleccionadas.baspro_cambiar_sindato_por;
        v_null   :=v_var_seleccionadas.baspro_cambiar_null_por;
        v_atipico:=v_var_seleccionadas.nsnc_atipico;
        v_cambiar:=v_var_seleccionadas.baspro_cambiar_especiales;
        CASE 
        WHEN v_cambiar THEN 
            v_transformada := ' when '||v_var_bu||' in ((-1)::'||v_tipo||',(-5)::'||v_tipo||') then '||
                                    case when v_sindato is null then 'null ' else '('||v_sindato||')::'||v_tipo end||
                           ' when '||v_var_bu||' is null then '||
                                case when v_null is null then 'null ' else '('||v_null||')::'||v_tipo end||
                           ' when '||v_var_bu||' =(-9)::'||v_tipo||' then '||
                                case when v_atipico is null then 'null ' else '('||v_atipico||')::'||v_tipo end||
                           ' else '||v_var_bu||
                           ' end';
            if v_tipo in ('character varying','text') then
                v_transformada := ' when '||v_var_bu||' in ($$//$$,$$-9$$) then $$NS/NC$$'||
                             ' when '||v_var_bu||' is null or '||v_var_bu||' in ($$-1$$,$$-5$$) then $$$$'||
                             v_transformada;
            end if;
            v_transformada:='case'||v_transformada;
        ELSE 
            v_transformada := v_var_bu; 
        END CASE;
        v_campos_select:=v_campos_select||
            case when v_var_seleccionadas.var_tipo = 'numeric' and v_var_seleccionadas.cantdecimales is not null then 
                'round('||v_transformada||'::decimal,'||v_var_seleccionadas.cantdecimales||')' 
            else v_transformada end||' as '||v_var_seleccionadas.var_nombrebu||' , ';
    END LOOP;
    IF length(v_campos_select)>0 THEN 
        v_campos_select:=substr(v_campos_select,1,length(v_campos_select)-2); 
    END IF;
    raise notice 'v_campos_select  % v_transformada %', v_campos_select,v_transformada;    
    select * into v_salida
        from encu.baspro_salidas
        where basprosal_sal=p_base;

    v_clave=comun.reemplazar_variables(v_salida.basprosal_claves, v_salida.basprosal_alias||'.pla_\1');
    v_clausula=' from '||v_salida.basprosal_qfrom ||
            ' where s.pla_entrea <>4 and t.pla_estado between '||p_estado_desde||' and '||p_estado_hasta||'
                         order by 1,2,3  ';
    v_nombre= dbo.ope_actual()||'_'||p_producida||'_'||replace(p_base,' ','_');
    v_vista:=' drop view if exists encu.'||v_nombre||' ; '|| ' create view encu.'||v_nombre||' as ' ;
    raise notice 'v_vista %', v_vista;
    SELECT baspro_sin_pk INTO STRICT v_exporta_pks
        FROM encu.baspro
        WHERE baspro_ope = dbo.ope_actual() and baspro_baspro = p_producida;
    v_sentencia:=v_vista||' select '||case when not v_exporta_pks then v_clave||', ' else ' ' end||v_campos_select||v_clausula||';';
     raise notice 'Sentencia  %', v_sentencia;
    IF v_campos_select <> '' THEN 
        execute v_sentencia;
    END IF;
END;
$BODY$
  LANGUAGE plpgsql;
ALTER FUNCTION encu.vista_base_producida_ut(text, text, integer, integer, text)
  OWNER TO tedede_php;
