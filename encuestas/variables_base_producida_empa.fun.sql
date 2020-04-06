-- Function: encu.variables_base_producida(text, text, integer, integer, text, text)

-- DROP FUNCTION encu.variables_base_producida(text, text, integer, integer, text, text);

CREATE OR REPLACE FUNCTION encu.variables_base_producida(
    p_base text,
    p_producida text,
    p_estado_desde integer,
    p_estado_hasta integer,
    p_modo text,
    p_filtro_sector integer,
    p_filtro_ue integer)
  RETURNS void AS
$BODY$
DECLARE
   v_sentencia_var text;
   v_sentencia_var_hog text;
   v_sentencia_var_pers text;
   v_sentencia_var_exm text;
   v_var_seleccionadas record;
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
   v_filtro_sector text;
   v_filtro_ue text;
   v_alias text;
BEGIN
    v_sentencia= '';
    v_clausula='';
    v_sentencia_var:='';
    v_sentencia_var_hog:='';
    v_sentencia_var_pers:='';
    v_sentencia_var_exm:='';
    v_campos_select:='';
    v_vista:='';
    v_hoy_es:='';
    v_transformada:='';
    v_filtro_sector:='';
    v_filtro_ue:='';
    v_alias='';
    FOR v_var_seleccionadas in
       select pre_blo, table_name, column_name as var_bu, 
              coalesce(basprovar_alias,basprovar_var) as var_nombrebu,
              case when table_name = 'pla_ext_hog' and varcal_destino in ('hog','tem') then 'hogar'
                   when table_name = 'pla_ext_hog' and varcal_destino ='mie' then 'personas'
                   when table_name in ('plana_i1_', 'plana_s1_p') then 'personas' 
                   when table_name in ('plana_a1_', 'plana_tem_', 'plana_s1_') then 'hogar' 
                   when table_name in ('plana_a1_x') then 'exm' 
                   when table_name in ('plana_a1_m') then 'exm_men' 
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
            left join encu.baspro_var on baspro_ope = basprovar_ope and baspro_baspro = basprovar_baspro
            left join (SELECT table_name, column_name, substr(column_name,5) as infovariable, data_type
                         FROM information_schema.columns
                         WHERE table_name in ('plana_a1_', 'plana_tem_', 'plana_s1_','plana_s1_p','plana_i1_', 'plana_a1_x', 'plana_a1_m','pla_ext_hog') and table_schema='encu'
                           and (substr(column_name,5) not in ('enc','hog','exm','mie','tlg') or column_name='pla_exm' and table_name in ('plana_a1_x'))) i ON basprovar_var = infovariable
            left join encu.varcal on varcal_ope = basprovar_ope and varcal_activa and varcal_varcal= infovariable
            left join encu.variables on var_ope = basprovar_ope and var_var= infovariable
            left join encu.preguntas on var_ope = pre_ope and var_pre = pre_pre
          where baspro_ope = dbo.ope_actual() and baspro_baspro = p_producida
          order by orden,tabla,var_orden,var_bu 
    LOOP  
        v_join_pla_ext_hog='';
        if p_modo!='' then
            val_modo=dbo.ope_actual();
            if p_modo='ETOI' then
                val_modo=p_modo;
            end if;
            v_join_pla_ext_hog=' inner join encu.pla_ext_hog x on x.pla_enc= s1.pla_enc and x.pla_hog= s1.pla_hog and x.pla_modo='''|| val_modo ||'''';
        end if;
       CASE WHEN ( (dbo.ope_actual()= 'same2014' or substr(dbo.ope_actual(),1,2)= 'ut' or substr(dbo.ope_actual(),1,4)='empa'  or substr(dbo.ope_actual(),1,3)='vcm' ) and v_var_seleccionadas.table_name = 'plana_s1_') or v_var_seleccionadas.table_name = 'plana_a1_' and v_var_seleccionadas.var_bu<>'pla_exm'
         THEN CASE WHEN v_var_seleccionadas.pre_blo = 'Viv'
                THEN v_var_bu = 'v.'||v_var_seleccionadas.var_bu;
                ELSE v_var_bu = 'a.'||v_var_seleccionadas.var_bu;
                END CASE;
         ELSE
           v_var_bu = v_var_seleccionadas.var_bu;
       END CASE;
       IF v_var_bu='pla_exm' THEN
         v_var_bu:='a1_x.pla_exm';
       END IF;
       v_tipo:=v_var_seleccionadas.var_tipo;
       v_sindato:=v_var_seleccionadas.baspro_cambiar_sindato_por;
       v_null:=v_var_seleccionadas.baspro_cambiar_null_por;
       v_atipico:=v_var_seleccionadas.nsnc_atipico;
       v_cambiar:=v_var_seleccionadas.baspro_cambiar_especiales;
       if substr(dbo.ope_actual(),1,4)='empa' then 
         CASE WHEN p_base = 'basehogar'
              THEN v_alias=' and a.';
              ELSE v_alias=' and s1.';
         END CASE;
           if p_filtro_sector is distinct from 0 then
              v_filtro_sector:=v_alias||'pla_sector_b_s='||p_filtro_sector;
           end if;
           if p_filtro_ue is distinct from 0 then 
              v_filtro_ue:=v_alias||'pla_rel_ue='||p_filtro_ue;
           end if;
       end if;
       /* VER, CONFIRMAR si es para todas las bases, probar
       if v_sindato=9 and v_var_seleccionadas.baspro_cambiar_nsnc_por=9 then
            v_sindato=v_atipico;
       end if;
       */
       CASE 
       WHEN v_cambiar THEN 
         v_transformada := ' when '||v_var_bu||' in ((-1)::'||v_tipo||',(-5)::'||v_tipo||') then '||case when v_sindato is null then 'null ' else '('||v_sindato||')::'||v_tipo end||
                           ' when '||v_var_bu||' is null then '||case when v_null is null then 'null ' else '('||v_null||')::'||v_tipo end||
                           ' when '||v_var_bu||' =(-9)::'||v_tipo||' then '||case when v_atipico is null then 'null ' else '('||v_atipico||')::'||v_tipo end||
                           ' else '||v_var_bu||' end';
         if v_tipo in ('character varying','text') then
           v_transformada := ' when '||v_var_bu||' in ($$//$$,$$-9$$) then $$NS/NC$$'||
                             ' when '||v_var_bu||' is null or '||v_var_bu||' in ($$-1$$,$$-5$$) then $$$$'||
                             v_transformada;
         end if;
         v_transformada:='case'||v_transformada;
       ELSE 
         v_transformada := v_var_bu; 
       END CASE;
       IF p_base='basehogar' AND v_var_seleccionadas.tabla='hogar' AND coalesce(v_var_seleccionadas.basprovar_exportar_en,'ambas')='ambas' THEN
         v_sentencia_var_hog:=v_sentencia_var_hog||
         case when v_var_seleccionadas.var_tipo = 'numeric' and v_var_seleccionadas.cantdecimales is not null then 
           'round('||v_transformada||'::decimal,'||v_var_seleccionadas.cantdecimales||')' 
           else v_transformada end||' as '||v_var_seleccionadas.var_nombrebu||' ,';
       END IF;
       IF p_base='basepersonas' AND ((v_var_seleccionadas.tabla='personas' and v_var_seleccionadas.basprovar_exportar_en is null) 
          OR v_var_seleccionadas.basprovar_exportar_en IN ('mie','ambas')) THEN
         v_sentencia_var_pers:=v_sentencia_var_pers||
         case when v_var_seleccionadas.var_tipo = 'numeric' and v_var_seleccionadas.cantdecimales is not null then 
           'round('||v_transformada||'::decimal,'||v_var_seleccionadas.cantdecimales||')' 
           else v_transformada end||' as '||v_var_seleccionadas.var_nombrebu||' ,';
       END IF;  
       IF p_base='baseexm' AND ((v_var_seleccionadas.tabla='exm' and v_var_seleccionadas.basprovar_exportar_en is null) 
          OR v_var_seleccionadas.basprovar_exportar_en IN ('exm','ambas')) THEN
         v_sentencia_var_exm:=v_sentencia_var_exm||
         case when v_var_seleccionadas.var_tipo = 'numeric' and v_var_seleccionadas.cantdecimales is not null then 
           'round('||v_transformada||'::decimal,'||v_var_seleccionadas.cantdecimales||')' 
           else v_transformada end||' as '||v_var_seleccionadas.var_nombrebu||' ,';
       END IF;  
       IF p_base='baseexm_men' AND ((v_var_seleccionadas.tabla='exm_men' and v_var_seleccionadas.basprovar_exportar_en is null) 
          OR v_var_seleccionadas.basprovar_exportar_en IN ('exm_men','ambas')) THEN
         v_sentencia_var_exm:=v_sentencia_var_exm||
         case when v_var_seleccionadas.var_tipo = 'numeric' and v_var_seleccionadas.cantdecimales is not null then 
           'round('||v_transformada||'::decimal,'||v_var_seleccionadas.cantdecimales||')' 
           else v_transformada end||' as '||v_var_seleccionadas.var_nombrebu||' ,';
       END IF;  
    END LOOP;
    IF p_base='basehogar' THEN 
          CASE WHEN (dbo.ope_actual()= 'same2014' or substr(dbo.ope_actual(),1,2)= 'ut' or substr(dbo.ope_actual(),1,4)='empa' or substr(dbo.ope_actual(),1,3)='vcm' )  THEN
            v_clausula:=' from encu.plana_s1_ as a
                         inner join encu.plana_tem_ t on a.pla_enc=t.pla_enc
                         LEFT JOIN encu.plana_s1_ v ON a.pla_enc = v.pla_enc AND 1 = v.pla_hog                         
                         where t.pla_estado between '||p_estado_desde||' and '||p_estado_hasta||v_filtro_sector||v_filtro_ue||' 
                         order by 1,2,3  ';
          ELSE
            v_clausula:=' from encu.plana_a1_ a
                     inner join encu.plana_s1_ as s1 on a.pla_enc=s1.pla_enc and a.pla_hog=s1.pla_hog
                     inner join encu.plana_tem_ t on a.pla_enc=t.pla_enc
                     LEFT JOIN encu.plana_a1_ v ON a.pla_enc = v.pla_enc AND 1 = v.pla_hog ' 
                     || v_join_pla_ext_hog
                     || ' where t.pla_estado between '||p_estado_desde||' and '||p_estado_hasta||'
                     order by 1,2,3  ';
          END CASE;
      IF length(v_sentencia_var_hog)>0 THEN 
        v_sentencia_var:=substr(v_sentencia_var_hog,1,length(v_sentencia_var_hog)-1); 
      END IF;
      v_campos_select:=' a.pla_enc as enc, a.pla_hog as hog, ';          
    END IF;
    IF p_base='basepersonas' THEN                
    /* seria para personas*/                   
      v_clausula='  from encu.plana_s1_p s1_p 
                    inner join encu.plana_i1_ i1 on s1_p.pla_enc=i1.pla_enc and s1_p.pla_hog=i1.pla_hog and s1_p.pla_mie=i1.pla_mie
                    inner join encu.plana_tem_ t on t.pla_enc=i1.pla_enc and t.pla_hog=0 and t.pla_mie=0
                    left join encu.plana_s1_ s1 on s1_p.pla_enc=s1.pla_enc and s1_p.pla_hog=s1.pla_hog
                        left join encu.'||case when (dbo.ope_actual()= 'same2014' or substr(dbo.ope_actual(),1,2)= 'ut' or substr(dbo.ope_actual(),1,4)='empa' or substr(dbo.ope_actual(),1,3)='vcm' ) then 'plana_s1_' else 'plana_a1_' end
                        ||' v  ON s1_p.pla_enc = v.pla_enc AND s1_p.pla_hog = v.pla_hog '
                        ||case when (dbo.ope_actual()= 'same2014' or substr(dbo.ope_actual(),1,2)= 'ut' or substr(dbo.ope_actual(),1,4)='empa' or substr(dbo.ope_actual(),1,3)='vcm' ) then ' left join encu.plana_s1_ a on s1_p.pla_enc = a.pla_enc AND s1_p.pla_hog = a.pla_hog ' else '' end||
                    v_join_pla_ext_hog ||    
                    ' where t.pla_estado between '||p_estado_desde||' and '||p_estado_hasta||v_filtro_sector||v_filtro_ue||'                        
                    order by 1,2,3,4  ';
      IF length(v_sentencia_var_pers)>0 THEN 
        v_sentencia_var:=substr(v_sentencia_var_pers,1,length(v_sentencia_var_pers)-1); 
      END IF;
      v_campos_select:=' s1_p.pla_enc as enc, s1_p.pla_hog as hog, s1_p.pla_mie as mie, ';
    END IF;
    IF p_base='baseexm' THEN                
      v_clausula='  from encu.plana_a1_x a1_x 
                    inner join encu.plana_tem_ t on t.pla_enc=a1_x.pla_enc and t.pla_hog=0 and t.pla_mie=0
                    left join encu.plana_s1_ s1 on a1_x.pla_enc=s1.pla_enc and a1_x.pla_hog=s1.pla_hog
                    left join encu.plana_a1_ v  ON s1.pla_enc = v.pla_enc AND s1.pla_hog = v.pla_hog
                    where t.pla_estado between '||p_estado_desde||' and '||p_estado_hasta||'                        
                    order by 1,2,3  ';
      IF length(v_sentencia_var_exm)>0 THEN 
        v_sentencia_var:=substr(v_sentencia_var_exm,1,length(v_sentencia_var_exm)-1); 
      END IF;
      v_campos_select:=' a1_x.pla_enc as enc, a1_x.pla_hog as hog, a1_x.pla_exm as exm, ';
    END IF;
    IF p_base='baseexm_men' THEN
      v_clausula='  from encu.plana_a1_m a1_x 
                    inner join encu.plana_tem_ t on t.pla_enc=a1_x.pla_enc and t.pla_hog=0 and t.pla_mie=0
                    left join encu.plana_s1_ s1 on a1_x.pla_enc=s1.pla_enc and a1_x.pla_hog=s1.pla_hog
                    left join encu.plana_a1_ v  ON s1.pla_enc = v.pla_enc AND s1.pla_hog = v.pla_hog
                    where t.pla_estado between '||p_estado_desde||' and '||p_estado_hasta||'                       
                    order by 1,2,3  ';
      IF length(v_sentencia_var_exm)>0 THEN 
        v_sentencia_var:=substr(v_sentencia_var_exm,1,length(v_sentencia_var_exm)-1); 
      END IF;
      v_campos_select:=' a1_x.pla_enc as enc, a1_x.pla_hog as hog, a1_x.pla_exm as exm, ';
    END IF;
    v_vista:=' drop view if exists encu.'||dbo.ope_actual()||'_'||p_producida||'_'||substr(p_base,5)||' ; '|| ' create view encu.'||dbo.ope_actual()||'_'||p_producida||'_'||substr(p_base,5)||' as ' ;
  -- raise notice 'v_vista %', v_vista;
    SELECT baspro_sin_pk INTO STRICT v_exporta_pks
        FROM encu.baspro
        WHERE baspro_ope = dbo.ope_actual() and baspro_baspro = p_producida;
    v_sentencia:=v_vista||' select'||case when not v_exporta_pks then v_campos_select else ' ' end||v_sentencia_var||v_clausula||';';
     --raise notice 'Sentencia  %', v_sentencia;
    IF v_sentencia_var <> '' THEN 
        execute v_sentencia;
    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION encu.variables_base_producida(text, text, integer, integer, text, integer, integer)
  OWNER TO tedede_php;