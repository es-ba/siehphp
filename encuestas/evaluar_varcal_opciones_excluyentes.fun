/* ##FUN
evaluar_varcal_opciones_excluyentes
##ESQ
encu
##PARA
provisoria
##DETALLE */
set search_path=encu, comun, dbo, public;
-- Function: encu.evaluar_varcal_opciones_excluyentes(p_cual text, p_destino TEXT, p_opciones_excluyente boolean, p_filtro text)

-- DROP FUNCTION encu.evaluar_varcal_opciones_excluyentes(p_cual text, p_destino TEXT, p_opciones_excluyente boolean, p_filtro text);

CREATE OR REPLACE FUNCTION encu.evaluar_varcal_opciones_excluyentes(p_cual text, p_destino TEXT, p_opciones_excluyente boolean, p_filtro text)
returns text 
LANGUAGE plpgsql  AS
$CUERPO$
  DECLARE
    v_sent_opc          TEXT;
    v_sent_opc_todas    TEXT;
    var_viv_str         TEXT;
    var_hog_str         TEXT;
    var_per_str         TEXT;
    var_tem_str         TEXT;
    for_hog             TEXT;
    v_tabla_viv         TEXT;
    v_sent              TEXT;
    v_sent_cant         TEXT;
    v_sent_excl         TEXT;
    c_opciones          RECORD;
    v_control_condicion TEXT;
    v_tiene_resto       boolean=false;
    v_alias_destino     character varying(10);
    v_alias_hogar       character varying(10);
    v_join_personas     TEXT;
    v_join_hogar        TEXT;
    v_limit             TEXT;
    v_lista_select      TEXT;
    v_casos     text;
    v_enc1       text;
    v_hog1       text;
    v_mie1       text;
    v_enc2       text;
    v_hog2       text;
    v_mie2       text;
    v_lista_clave       text;
    v_filtro            text;
    v_filtro_varcal     text;
    v_opcs1             text;
    v_opcs2             text;
    v_mensaje           TEXT;
    v_mostrar_no_clasificado TEXT;

  BEGIN
    v_filtro='t.pla_estado between 77 and 89'; -- SIEMPRE filtro de estado
    v_filtro_varcal=' true';
    select string_agg(case when p.pre_blo='Viv' then var_var else null end ,'|' order by pre_ope, pre_for, pre_orden, var_orden),
            string_agg(case when p.pre_blo in ('Hog','HEH') then var_var else null end,'|'  order by pre_ope, pre_for, pre_orden, var_orden),
            string_agg(case when p.pre_mat='P' then var_var else null end,'|'  order by pre_ope, pre_for, pre_orden, var_orden),
            (select distinct pre_for from encu.preguntas where pre_blo in ('Hog','HEH'))
        into var_viv_str, var_hog_str, var_per_str, for_hog
        from encu.variables v 
            join encu.preguntas p on v.var_ope=p.pre_ope and v.var_for=p.pre_for and
                v.var_pre=p.pre_pre and (p.pre_blo in ('Viv', 'Hog','HEH') or p.pre_mat='P');
    var_tem_str='dominio|estrato|comuna';
    v_sent_opc_todas='';
    v_tiene_resto=false;
    v_join_personas='';
    v_alias_destino='h';
    v_lista_clave='h.pla_enc, h.pla_hog, h.pla_mie';
    if for_hog='A1' then
       v_join_hogar=' join encu.plana_a1_ a on h.pla_enc=a.pla_enc and h.pla_hog=a.pla_hog '||chr(13);
       v_alias_hogar='a';
       v_tabla_viv = 'encu.plana_a1_';
    else
       v_join_hogar='';
       v_alias_hogar='h';       
       v_tabla_viv = 'encu.plana_s1_';
    end if;
    if p_destino='mie' then
        v_join_personas=' join encu.plana_s1_p p on h.pla_enc=p.pla_enc and h.pla_hog=p.pla_hog '||chr(13)||
                  repeat(' ',16)||' join encu.plana_i1_ i on i.pla_enc=p.pla_enc and i.pla_hog=p.pla_hog and i.pla_mie=p.pla_mie'; 
        v_alias_destino='i';  
        v_lista_clave=replace(v_lista_clave, 'h.', 'i.');        
    end if;

    FOR c_opciones IN
        select varcalopc_opcion as i_opcion,
               varcalopc_expresion_condicion as i_expresion_condicion,
               varcalopc_expresion_valor as i_expresion_valor,
               varcalopc_etiqueta as i_etiqueta
          from encu.varcalopc
          where varcalopc_ope = dbo.ope_actual() and varcalopc_varcal = p_cual
        order by varcalopc_ope, varcalopc_varcal, varcalopc_opcion  
    LOOP
        if coalesce(c_opciones.i_expresion_condicion,'')='' then
            RETURN '1|otro: expresion_condicion sin dato en la opcion '||c_opciones.i_opcion;
        end if;
        v_sent_opc=encu.reemplazar_agregadores(c_opciones.i_expresion_condicion);
        v_sent_opc=comun.reemplazar_variables(v_sent_opc, v_alias_destino||'.pla_\1');
        v_sent_opc=regexp_replace(v_sent_opc, '\m'||v_alias_destino||'.pla_('||var_viv_str||')\M'::text, 'v.pla_\1'::text,'ig');
        v_sent_opc=regexp_replace(v_sent_opc, '\m'||v_alias_destino||'.pla_('||var_tem_str||')\M'::text, 't.pla_\1'::text,'ig');
        v_sent_opc=regexp_replace(v_sent_opc, '\m'||v_alias_destino||'.pla_('||var_hog_str||')\M'::text, v_alias_hogar||'.pla_\1'::text,'ig');
        if p_destino='mie' then
            v_sent_opc=regexp_replace(v_sent_opc, '\m'||v_alias_destino||'.pla_('||var_per_str||')\M'::text, 'p.pla_\1'::text,'ig');
        end if;
        if c_opciones.i_etiqueta is distinct from 'Resto' then
            v_sent_opc_todas= v_sent_opc_todas||chr(13)||repeat(' ',8)||'case when ('|| v_sent_opc||') then '''||c_opciones.i_opcion||'*'||''' else '''' end ||';
        else
            v_tiene_resto=true;        
        end if;
    END LOOP;
    if coalesce(replace(p_filtro,' ',''),'')<> '' then
        v_filtro_varcal=regexp_replace(p_filtro, '\m'||v_alias_destino||'.pla_('||var_viv_str||')\M'::text, 'v.pla_\1'::text,'ig');
        v_filtro_varcal=regexp_replace(v_filtro_varcal, '\m'||v_alias_destino||'.pla_('||var_tem_str||')\M'::text, 't.pla_\1'::text,'ig');
        v_filtro_varcal=regexp_replace(v_filtro_varcal, '\m'||v_alias_destino||'.pla_('||var_hog_str||')\M'::text, v_alias_hogar||'.pla_\1'::text,'ig');
        if p_destino='mie' then
            v_filtro_varcal=regexp_replace(v_filtro_varcal, '\m'||v_alias_destino||'.pla_('||var_per_str||')\M'::text, 'p.pla_\1'::text,'ig');
        end if;
    end if;
    v_mostrar_no_clasificado= true;   
    if p_opciones_excluyente is true then
        if v_tiene_resto THEN
          v_control_condicion='cant<=1';
        else
          v_control_condicion='cant=1';
        end if;
    else
       if v_tiene_resto THEN
          v_control_condicion='cant>=0';  -- no haría falta controlar
          v_mostrar_no_clasificado= false; 
       else
          v_control_condicion='cant>=1';
       end if;
    end if;
    v_lista_select='count(*)';
    v_limit='';
    v_sent =$$
        select #lista_select
        from
            (select #lista_clave, #expresion opcs, 
                    case when length(#expresion)>0 then array_length(string_to_array(substr(#expresion,1,length(#expresion)-1), '*'),1) 
                         else 0 end cant
                from encu.plana_s1_ h join #tabla_viv v on h.pla_enc=v.pla_enc and v.pla_hog=1
                                  join encu.plana_tem_ t on t.pla_enc=h.pla_enc
                                  #join_personas
                                  #join_hogar
                #filtro
            )as x
        where not #control
        #limit
$$;
    raise notice 'varcal %, v_sent_todas:%',p_cual,v_sent_opc_todas;
    if coalesce(v_sent_opc_todas,'')='' then
        RETURN '1|otro: Variable sin opciones' ;
    end if;    
    v_sent=replace(v_sent,'#expresion',substr(v_sent_opc_todas,1,length(v_sent_opc_todas)-2)); 
    --v_sent=replace(v_sent,'#control',v_control_condicion); 
    v_sent=replace(v_sent,'#join_personas',v_join_personas);
    v_sent=replace(v_sent,'#lista_clave',v_lista_clave);
    v_sent=replace(v_sent,'#filtro','where '||v_filtro ||' and '||v_filtro_varcal);
    v_sent=replace(v_sent,'#join_hogar',v_join_hogar);
    v_sent=replace(v_sent,'#tabla_viv',v_tabla_viv);
    v_sent_cant=replace(replace(replace(v_sent,'#lista_select',v_lista_select),'#limit', v_limit),'#control',v_control_condicion);    
    raise notice 'varcal %, v_sent_todas:%',p_cual,v_sent_opc_todas;    
    raise notice 'varcal %, v_sent_cant:%',p_cual,v_sent_cant;
    EXECUTE v_sent_cant INTO v_casos;
    if v_casos::integer>0 then
        v_mensaje= v_casos;
        if p_opciones_excluyente is true then
            v_sent_excl =replace(replace(replace(v_sent,'#lista_select','pla_enc,pla_hog,pla_mie,opcs' ),'#limit', 'limit 1'),'#control',v_control_condicion|| ' and cant>1'); 
            raise notice 'v_sent_excl:%',v_sent_excl;     
            EXECUTE v_sent_excl INTO v_enc1, v_hog1, v_mie1, v_opcs1;
            if v_enc1 is not null then
                v_mensaje=v_mensaje||'|NoEx: e '||v_enc1||' h '||v_hog1||' m '||v_mie1||' opciones:'||v_opcs1 ; 
            end if;    
        end if;
        if v_mostrar_no_clasificado then
            v_sent =replace(replace(replace(v_sent,'#lista_select','pla_enc,pla_hog,pla_mie,opcs' ),'#limit', 'limit 1'),'#control',v_control_condicion|| ' and cant=0'); 
            raise notice 'v_sent:%',v_sent;     
            EXECUTE v_sent INTO v_enc2, v_hog2, v_mie2, v_opcs2;
            if v_enc2 is not null then
                v_mensaje=v_mensaje||'|NoCl: e '||v_enc2||' h '||v_hog2||' m '||v_mie2 ; 
            end if;
        end if;
    else
        v_mensaje='OK';
    end if; 
    RETURN v_mensaje;
  END;
$CUERPO$;
ALTER FUNCTION encu.evaluar_varcal_opciones_excluyentes(text, text, boolean, text)
  OWNER TO tedede_php; 

select varcal_varcal, varcal_destino, varcal_opciones_excluyentes, varcal_filtro, encu.evaluar_varcal_opciones_excluyentes(varcal_varcal,varcal_destino, false, varcal_filtro)      
from encu.varcal
where varcal_activa=true and varcal_valida=true and varcal_tipo='normal'
order by varcal_destino, varcal_orden
   