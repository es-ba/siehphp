##FUN
generar_trigger_variables_calculadas
##ESQ
encu
##PARA
revisar 
##DETALLE
##PROVISORIO
set search_path = encu, comun, dbo, public;

-- DROP FUNCTION encu.generar_trigger_variables_calculadas(text);

CREATE OR REPLACE FUNCTION encu.generar_trigger_variables_calculadas(p_cual text) RETURNS TEXT
LANGUAGE plpgsql VOLATILE AS
$CUERPO$
DECLARE
    v_enter text:=chr(13)||chr(10);
    v_tab TEXT;
    v_script_principio text;
    v_script_final     text;
    v_script_creador   text;
    v_script_trigger   text;    
    v_variables record;
    v_opciones record;
    v_sentencia_calculo text:='';
    v_sentencia text:='';
    v_expresion text;
    v_opcion text;
    v_identifica_var_regexp text;
    v_destinos record;
    v_plana_trigger text;
    v_nombre_funcion text;
    v_sentencia_variable  text;
    v_alterplanas_add     text;
    v_alterplanas_drop    text;
    v_alterhisplanas_add  text;
    v_alterhisplanas_drop text;
    v_set_update     text;
    v_revisadas integer:=0;
    v_expresion_valor text;
    v_declare text;
    v_declare_total text;
    v_select_str_otro_for text;
    v_listaselect text;
    v_variables_otro_formulario record;
    v_otro_formulario record;
    v_listainto  text;
    v_variable_mensaje text:='indeterminado';
    v_sentencia_borrar text;
    v_si_existe integer;
    v_variables_a_borrar record;
    v_tipodatovar text;
    v_tiporiginal text;
    v_pos_error_var integer;
    v_listavar    text;
    v_listavar_total    text;
    v_listareemplazo text;
    v_campo_set  text;
    error_mensaje TEXT;
    error_mensaje_detalle TEXT;
    error_mensaje_ayuda TEXT;
    error_mensaje_linea TEXT;
    error_codigo TEXT;
    v_cond_valcan text;
    v_sincro     text;
    v_sincro_fin text;

    
BEGIN
  v_tab=repeat(' ',4);
  -- v_identifica_var_regexp := '\m(?!AND)(?!OR)(?!NOT)(?!IS)(?!NULL)(?!IN)(?!TRUE)(?!FALSE)(?!EXISTS)(?!DISTINCT)(?!FROM)(?!BETWEEN)(?!dbo)([a-z]\w*)(?!\s*(\(|\$\$))\M';
  FOR v_destinos in
    select destino, plana_destino, otro_destino_1, otro_destino_2, formulario, matriz, orden 
        from (
              select 'hog'::text as destino, 's1_'::text as plana_destino, 'i1_'::text as otro_destino_1,
                (select lower(mat_for||'_'||mat_mat) from encu.matrices where mat_for='A1' and mat_mat='X') as otro_destino_2,
                'S1'::text as formulario, null as matriz, 4 orden
              union select 'mie'::text, 'i1_'::text, 's1_'::text as otro_destino_1,
                (select lower(mat_for||'_'||mat_mat) from encu.matrices where mat_for='A1' and mat_mat='X') as otro_destino_2,
                    'I1'::text as formulario, null as matriz, 3 orden
              union select 'per'::text, 's1_p'::text, 'i1_'::text as otro_destino_1,
                (select lower(mat_for||'_'||mat_mat) from encu.matrices where mat_for='A1' and mat_mat='X') as otro_destino_2,
                'S1'::text as formulario, 'P' as matriz, 2 orden
              union select 'exm'::text, lower(mat_for||'_'||mat_mat)as plana_destino, 'i1_'::text as otro_destino_1,
                's1_'::text as otro_destino_2 , mat_for as formulario, mat_mat as matriz, 1 orden
                        from encu.matrices
                        where mat_ope= dbo.ope_actual() and mat_for='A1' and mat_mat='X'
             ) x
        order by orden
  LOOP
    v_alterplanas_add:='';
    v_alterplanas_drop:='';
    v_alterhisplanas_add:='';
    v_alterhisplanas_drop:='';
    v_sincro='';
    v_sincro_fin='';
    if v_destinos.plana_destino ='s1_' or v_destinos.plana_destino ='i1_' then
       v_sincro=v_enter||'if coalesce(new.pla_sync_'||substr(v_destinos.plana_destino,1,2)||',0)=0 then';
       v_sincro_fin=v_enter||'end if;'||v_enter;  
    end if;
    --- borro las variables calculadas que fueron eliminadas de varcal y quedan en las planas
    if v_destinos.matriz is null then
      FOR v_variables_a_borrar in
        select column_name as i_var_borrar from information_schema.columns where table_name = 'plana_'||v_destinos.plana_destino and table_schema = 'encu' 
          and substr(column_name,5) not in ('enc','hog','mie','exm','tlg')
          and substr(column_name,5) not in (select var_var from encu.variables where var_ope = dbo.ope_actual() and var_for = v_destinos.formulario) 
          and substr(column_name,5) not in (select distinct(varcal_varcal) from encu.varcal inner join encu.varcalopc on varcal_varcal=varcalopc_varcal where varcal_ope = dbo.ope_actual() and varcal_destino = v_destinos.destino and varcal_tipo ='normal')
          and substr(column_name,5) not in (select varcal_varcal from encu.varcal where varcal_ope = dbo.ope_actual() and varcal_destino = v_destinos.destino  and varcal_tipo ='externo')
          and substr(column_name,5) not in (select varcal_varcal from encu.varcal where varcal_ope = dbo.ope_actual() and varcal_destino = v_destinos.destino  and varcal_tipo ='especial')
      LOOP
        v_si_existe:=0;
        select count(*) into v_si_existe from information_schema.columns where table_schema = 'his' and table_name = 'plana_'||v_destinos.plana_destino and lower(column_name) = lower(v_variables_a_borrar.i_var_borrar);
          if v_si_existe=1 then
              v_alterhisplanas_drop:=v_alterhisplanas_drop||'alter table his.plana_'||v_destinos.plana_destino||' drop column '||v_variables_a_borrar.i_var_borrar||';'||v_enter;
          end if;
          v_alterplanas_drop:=v_alterplanas_drop||'alter table encu.plana_'||v_destinos.plana_destino||' drop column '||v_variables_a_borrar.i_var_borrar||';'||v_enter;
      END LOOP;
    else
      FOR v_variables_a_borrar in
        select column_name as i_var_borrar from information_schema.columns where table_name = 'plana_'||v_destinos.plana_destino and table_schema = 'encu' 
          and substr(column_name,5) not in ('enc','hog','mie','exm','tlg')
          and substr(column_name,5) not in (select var_var from encu.variables where var_ope = dbo.ope_actual() and var_for = v_destinos.formulario and var_mat = v_destinos.matriz) 
          and substr(column_name,5) not in (select distinct(varcal_varcal) from encu.varcal inner join encu.varcalopc on varcal_varcal=varcalopc_varcal where varcal_ope = dbo.ope_actual() and varcal_destino = v_destinos.destino and varcal_tipo ='normal')
          and substr(column_name,5) not in (select varcal_varcal from encu.varcal where varcal_ope = dbo.ope_actual() and varcal_destino = v_destinos.destino and varcal_activa and varcal_tipo ='externo')
          and substr(column_name,5) not in (select varcal_varcal from encu.varcal where varcal_ope = dbo.ope_actual() and varcal_destino = v_destinos.destino and varcal_tipo ='especial')
      LOOP
        v_si_existe:=0;
        select count(*) into v_si_existe from information_schema.columns where table_schema = 'his' and table_name = 'plana_'||v_destinos.plana_destino and lower(column_name) = lower(v_variables_a_borrar.i_var_borrar);
          if v_si_existe=1 then
              v_alterhisplanas_drop:=v_alterhisplanas_drop||'alter table his.plana_'||v_destinos.plana_destino||' drop column '||v_variables_a_borrar.i_var_borrar||';'||v_enter;
          end if;
          v_alterplanas_drop:=v_alterplanas_drop||'alter table encu.plana_'||v_destinos.plana_destino||' drop column '||v_variables_a_borrar.i_var_borrar||';'||v_enter;
      END LOOP;
    end if;
    --generar variables de otros formularios
    v_select_str_otro_for='';
    v_listavar_total='';
    v_declare_total='';
    v_cond_valcan='';
    if ( substr(dbo.ope_actual(),1,4)='etoi' and substr(dbo.ope_actual(),7,1)='s' ) then
           v_cond_valcan =' (select pla_operativo_original from encu.plana_tem_ where  pla_enc = new.pla_enc and pla_hog=0 and pla_mie = 0 and pla_exm = 0 ) ';
    else 
           v_cond_valcan=''''|| dbo.ope_actual()||'''';
    end if;
    FOR v_otro_formulario in
    
        select v_otro_for, v_otra_mat, v_otro_blo, v_alias, v_condic, case when v_otro_for='VALCAN' THEN 'encu.valcan '||v_alias  else 'encu.plana_'||lower(v_otro_for)||'_'||lower(v_otra_mat)||' '||v_alias  end  as v_tabla

            from (
                   select 'S1'::text  as v_otro_for, 'P'::text as v_otra_mat, '' as v_otro_blo,'s'::text as v_alias,
                                ' s.pla_enc = new.pla_enc and s.pla_hog = new.pla_hog and s.pla_mie = new.pla_mie and s.pla_exm = 0 '::text as v_condic
                   union select 'TEM'::text as v_otro_for, ''::text as v_otra_mat,'' as v_otro_blo,'t'::text as v_alias,
                                ' t.pla_enc = new.pla_enc and t.pla_hog = 0 and t.pla_mie = 0 and t.pla_exm = 0 '::text as v_condic
                   union select blo_for as v_otro_for, blo_mat as v_otra_mat, 'Viv' as v_ptro_blo,'a'::text as v_alias,
                                ' a.pla_enc = new.pla_enc and a.pla_hog=1 and a.pla_mie = 0 and a.pla_exm = 0 '::text as v_condic
                            from encu.bloques where blo_blo ='Viv'
                   union select blo_for as v_otro_for, blo_mat as v_otra_mat, '' as v_otro_blo,'a'::text as v_alias,
                               ' a.pla_enc = new.pla_enc and a.pla_hog=new.pla_hog and a.pla_mie = 0 and a.pla_exm = 0 '::text as v_condic
                            from encu.bloques where blo_blo in ('Hog','HEH')
                   union select blo_for as v_otro_for, blo_mat as v_otra_mat, '' as v_otro_blo,'a'::text as v_alias,
                               ' a.pla_enc = new.pla_enc and a.pla_hog=new.pla_hog and a.pla_mie = 0 and a.pla_exm = 0 '::text as v_condic
                            from encu.bloques where blo_blo in ('CR') and blo_for='S1' and blo_ope='ut2016'        
                   union select 'VALCAN'::text as v_otro_for, ''::text as v_otra_mat, '' as v_otro_blo,'v'::text as v_alias,
                               ' v.pla_ope ='||v_cond_valcan::text as v_condic        
        ) x
    LOOP
        -- acá van las variables de formularios distintos al del trigger que se está creando
        -- en el caso de variables del bloque Viv, hay que leer el hogar 1
        select string_agg(var_var, '|'),
                   string_agg(v_enter||v_tab||'v_'||var_var||' '||CASE when var_tipovar in ('integer','anio','anios','numeros','opciones','si_no') then 'integer'  when var_tipovar ='decimal' then 'numeric' else 'text' END, ';'),
                   string_agg('pla_'||var_var, ','),
                   string_agg('v_'||var_var, ',')
            into v_listavar, v_declare,
                 v_listaselect, v_listainto 
            from (
                    select var_var, var_for, var_mat, CASE WHEN coalesce(pre_blo,'') ='Viv' THEN pre_blo ELSE '' END as v_blo,var_tipovar, pre_orden, var_orden
                        from encu.variables join encu.preguntas on var_pre = pre_pre and pre_ope=var_ope
                        where var_ope = dbo.ope_actual() and
                            (var_mat='P' or pre_blo in ('Viv','Hog','HEH', 'CR'))
                    union select 'comuna'::text  as var_var, 'TEM'::text as var_for, '' as var_mat,'' as v_blo, 'integer' as var_tipovar, 1 pre_orden, 1 var_orden
                    union select 'estado'::text  as var_var, 'TEM'::text as var_for, '' as var_mat,'' as v_blo, 'integer' as var_tipovar, 2 pre_orden, 2 var_orden
                    union select 'dominio'::text as var_var, 'TEM'::text as var_for, '' as var_mat,'' as v_blo, 'integer' as var_tipovar ,3 pre_orden, 3 var_orden
                    union select  varcal_varcal, 'VALCAN'::text as var_for, '' var_mat ,'' as v_blo, 'decimal' as var_tipovar, 0 pre_orden, varcal_orden 
                             from encu.varcal where varcal_ope=dbo.ope_actual() and varcal_destino='vcan' and varcal_tipo='interno' 
                    order by var_for,var_mat, v_blo,pre_orden, var_orden
                    ) x 
            where var_for = v_otro_formulario.v_otro_for and var_mat=v_otro_formulario.v_otra_mat and v_blo=v_otro_formulario.v_otro_blo;
        if v_listavar is not null then      
            v_select_str_otro_for:=v_select_str_otro_for||
                          v_tab||' SELECT '||v_listaselect||v_enter||
                          v_tab||'   INTO '||v_listainto||v_enter||
                          v_tab||'   FROM '||v_otro_formulario.v_tabla||v_enter||
                          v_tab||'   WHERE '||v_otro_formulario.v_condic||';'||v_enter;
            v_declare_total=v_declare_total || v_declare||';';
            v_listavar_total= v_listavar_total|| v_listavar||'|';
            --raise notice 'v_buscar: %', v_buscar;          
            --raise notice 'v_into: %', v_into;            
            raise notice 'consultas: %', v_select_str_otro_for;            
        end if;
    END LOOP;        
    v_sentencia_calculo:='';
    ---  recorro las variables calculadas para el formulario plana_destino
    FOR v_variables in
        select distinct(varcal_varcal) as i_variable, varcal_tipodedato as i_tipodedato, varcal_orden 
            from encu.varcal inner join encu.varcalopc on varcal_varcal = varcalopc_varcal
            where varcal_ope = dbo.ope_actual()
                and varcal_destino = v_destinos.destino
                and varcal_activa
                and varcal_tipo not in ('externo','especial','interno')
                and (varcal_varcal=p_cual or p_cual='#todo')
            order by varcal_orden, varcal_varcal
    LOOP
        v_revisadas:=v_revisadas+1;
        v_tipodatovar:='';
        case v_variables.i_tipodedato
            when 'entero' then v_tipodatovar:='integer';
            when 'decimal' then v_tipodatovar:='numeric';
            else v_tipodatovar:='integer';
        end case;  
        -- agregamos si no existe
        select count(*) into v_si_existe from information_schema.columns where table_schema = 'encu' and table_name = 'plana_'||v_destinos.plana_destino and lower(column_name) = 'pla_'||lower(v_variables.i_variable);
        if v_si_existe=0 then
            v_alterplanas_add:=v_alterplanas_add||'alter table encu.plana_'||v_destinos.plana_destino||' add column pla_'||v_variables.i_variable||' '||v_tipodatovar||'; '||v_enter;
        else 
            select data_type into v_tiporiginal from information_schema.columns where table_schema = 'encu' and table_name = 'plana_'||v_destinos.plana_destino and lower(column_name) = 'pla_'||lower(v_variables.i_variable);
            if v_tiporiginal <> v_tipodatovar then
                v_alterplanas_add:=v_alterplanas_add||'alter table encu.plana_'||v_destinos.plana_destino||' add column pla_'||v_variables.i_variable||' '||v_tipodatovar||'; '||v_enter;
                v_alterplanas_drop:=v_alterplanas_drop||'alter table encu.plana_'||v_destinos.plana_destino||' drop column pla_'||v_variables.i_variable||';'||v_enter;
            end if;
        end if;
        select count(*) into v_si_existe from information_schema.columns where table_schema = 'his' and table_name = 'plana_'||v_destinos.plana_destino and lower(column_name) = 'pla_'||lower(v_variables.i_variable);
        if v_si_existe=0 then
            v_alterhisplanas_add:=v_alterhisplanas_add||'alter table his.plana_'||v_destinos.plana_destino||' add column pla_'||v_variables.i_variable||' '||v_tipodatovar||'; '||v_enter;
        else
            select data_type into v_tiporiginal from information_schema.columns where table_schema = 'his' and table_name = 'plana_'||v_destinos.plana_destino and lower(column_name) = 'pla_'||lower(v_variables.i_variable);
            if v_tiporiginal <> v_tipodatovar then
                v_alterplanas_add:=v_alterplanas_add||'alter table his.plana_'||v_destinos.plana_destino||' add column pla_'||v_variables.i_variable||' '||v_tipodatovar||'; '||v_enter;
                v_alterplanas_drop:=v_alterplanas_drop||'alter table his.plana_'||v_destinos.plana_destino||' drop column pla_'||v_variables.i_variable||';'||v_enter;
            end if;
        end if;
        -- borramos si existe en otra plana
        select count(*) into v_si_existe from information_schema.columns where table_schema = 'encu' and table_name = 'plana_'||v_destinos.otro_destino_1 and lower(column_name) = 'pla_'||lower(v_variables.i_variable);
        if v_si_existe=1 then
            v_alterplanas_drop:=v_alterplanas_drop||'alter table encu.plana_'||v_destinos.otro_destino_1||' drop column pla_'||v_variables.i_variable||';'||v_enter;
        end if;
        select count(*) into v_si_existe from information_schema.columns where table_schema = 'his' and table_name = 'plana_'||v_destinos.otro_destino_1 and lower(column_name) = 'pla_'||lower(v_variables.i_variable);
        if v_si_existe=1 then
            v_alterhisplanas_drop:=v_alterhisplanas_drop||'alter table his.plana_'||v_destinos.otro_destino_1||' drop column pla_'||v_variables.i_variable||';'||v_enter;
        end if;
        select count(*) into v_si_existe from information_schema.columns where table_schema = 'encu' and table_name = 'plana_'||v_destinos.otro_destino_2 and lower(column_name) = 'pla_'||lower(v_variables.i_variable);
        if v_si_existe=1 then
            v_alterplanas_drop:=v_alterplanas_drop||'alter table encu.plana_'||v_destinos.otro_destino_2||' drop column pla_'||v_variables.i_variable||';'||v_enter;
        end if;
        select count(*) into v_si_existe from information_schema.columns where table_schema = 'his' and table_name = 'plana_'||v_destinos.otro_destino_2 and lower(column_name) = 'pla_'||lower(v_variables.i_variable);
        if v_si_existe=1 then
            v_alterhisplanas_drop:=v_alterhisplanas_drop||'alter table his.plana_'||v_destinos.otro_destino_2||' drop column pla_'||v_variables.i_variable||';'||v_enter;
        end if;
        
        v_listareemplazo= '\mnew.pla_('||v_listavar_total||')\M';
        --- por cada variable recorro sus opciones
        v_sentencia_variable:='';
        FOR v_opciones IN
            select varcalopc_opcion as i_opcion, varcalopc_expresion_condicion as i_expresion_condicion,
                    varcalopc_expresion_valor as i_expresion_valor
                from encu.varcalopc
                where varcalopc_ope = dbo.ope_actual() and varcalopc_varcal = v_variables.i_variable
                order by varcalopc_ope, varcalopc_varcal, varcalopc_opcion  
        LOOP
            v_expresion:=v_opciones.i_expresion_condicion;
            v_opcion:=v_opciones.i_opcion;
            v_expresion_valor:=v_opciones.i_expresion_valor;
            v_expresion:= encu.reemplazar_agregadores(v_expresion);
            v_expresion:= comun.reemplazar_variables(v_expresion, 'new.pla_\1');
            v_expresion:= regexp_replace(v_expresion, v_listareemplazo::text, 'v_\1'::text,'ig');
            v_expresion_valor:= encu.reemplazar_agregadores(v_expresion_valor);
            v_expresion_valor:= comun.reemplazar_variables(v_expresion_valor, 'new.pla_\1');
            v_expresion_valor:= regexp_replace(v_expresion_valor, v_listareemplazo::text, 'v_\1'::text,'ig');
            v_sentencia_variable:=v_sentencia_variable||v_enter||v_tab||v_tab||'when ('||v_expresion||') then '||coalesce(v_expresion_valor,v_opcion);
        END LOOP;
        IF v_sentencia_variable<>'' THEN
            v_sentencia_variable:=v_tab||' new.pla_'||v_variables.i_variable||':=case '||v_sentencia_variable||v_enter||v_tab||v_tab||' else null end; '||v_enter;
            v_sentencia_calculo:=v_sentencia_calculo||v_enter||v_sentencia_variable;
        END IF;
    END LOOP;
    IF v_sentencia_calculo<>'' THEN
        --- creo el script para generar
        v_plana_trigger:='encu.plana_'||v_destinos.plana_destino;
        v_nombre_funcion:='calculo_variables_calculadas_tmp'||v_destinos.plana_destino||'_trg';
        if(p_cual='#todo')then
            v_nombre_funcion:=replace(v_nombre_funcion,'tmp','');
        end if;

        v_script_principio:='
    CREATE OR REPLACE FUNCTION encu.$1()
         RETURNS trigger AS
    $BODY$
    DECLARE'
    ||v_declare_total||'
    BEGIN'||v_enter
    ||v_sincro||v_enter
    ||v_select_str_otro_for ;
    
    
        v_script_final:=$SCRIPT2$
     $v_sincro_fin   
    return new;
    END;
    $BODY$
    LANGUAGE plpgsql;
    ALTER FUNCTION encu.$1()
            OWNER TO tedede_php;
    $SCRIPT2$;
        v_script_trigger= $SCRIPT3$;
    DROP TRIGGER IF EXISTS $1 ON $2;
    DROP TRIGGER IF EXISTS z$1 ON $2;
    CREATE TRIGGER z$1
        BEFORE UPDATE
            ON $2
            FOR EACH ROW
            EXECUTE PROCEDURE encu.$1();
    $SCRIPT3$;
        
        v_script_creador:= v_alterplanas_drop||v_alterhisplanas_drop||
                           v_alterplanas_add||v_alterhisplanas_add;
        v_script_creador:=v_script_creador
                        || v_script_principio
                        || v_sentencia_calculo
                        || v_script_final;
         --raise notice 'script creador %', v_script_creador;
        v_script_creador:=replace(v_script_creador,'$1',v_nombre_funcion);
        v_script_creador:=replace(v_script_creador,'$v_sincro_fin',v_sincro_fin);
        v_script_trigger:=replace(replace(v_script_trigger,'$1',v_nombre_funcion),'$2',v_plana_trigger);
        BEGIN
          raise notice ' v_script_creador % ', v_script_creador;
          EXECUTE v_script_creador;
          EXECUTE v_script_trigger;
          
          --Forzar la ejecucion del trigger recien generado
          BEGIN
            v_set_update='  set pla_#campo_set = pla_#campo_set ';
            v_sentencia='';
            select x.var_var 
              into v_campo_set
              from
                (select var_var ,orden
                    from encu.variables_ordenadas
                    where var_ope=dbo.ope_actual() and var_for=v_destinos.formulario
                      and var_mat=coalesce(v_destinos.matriz,'')
                union 
                  select 'obs' var_var, 1 as orden
                    where (dbo.ope_actual()='colon2015' or dbo.ope_actual() like 'empa%') and v_destinos.formulario='I1'
                ) x 
              order by x.orden        
              limit 1;
            v_set_update= replace(v_set_update,'#campo_set',v_campo_set);
            v_sentencia= 'update encu.plana_'||v_destinos.plana_destino||v_set_update;
            raise notice 'sentencia %', v_sentencia;
            EXECUTE  v_sentencia;  
            UPDATE encu.varcal
                SET varcal_valida=TRUE
                WHERE varcal_activa = TRUE and varcal_cerrado is not true ;
          END;
          EXCEPTION
              WHEN OTHERS THEN
                    GET STACKED DIAGNOSTICS error_mensaje = MESSAGE_TEXT,
                          error_mensaje_detalle = PG_EXCEPTION_DETAIL,
                          error_mensaje_ayuda = PG_EXCEPTION_HINT,
                          error_mensaje_linea = PG_EXCEPTION_CONTEXT,
                          error_codigo= RETURNED_SQLSTATE;              
                v_pos_error_var:=strpos(sqlerrm, '«pla_'); 
                if v_pos_error_var>0 then
                   v_variable_mensaje:=substr(substr(sqlerrm,v_pos_error_var),6); 
                   v_variable_mensaje:=substr(v_variable_mensaje,1,length(v_variable_mensaje)-1);
                else
                   v_variable_mensaje:='*indeterminada*';
                end if;
                return 'ERROR: Compilación de variable con error. Variable: '|| v_variable_mensaje||'. Error '|| sqlstate || ': ' || sqlerrm||' SENTENCIA: '||v_sentencia
                          || 'Detalle:'||error_mensaje_detalle 
                          || 'Ayuda:'||error_mensaje_ayuda
                     --     || 'linea err:'||error_mensaje_linea
                          || 'cod err:'||error_codigo;
          END; 
        if(p_cual<>'#todo')then 
          v_sentencia_borrar:= ' DROP TRIGGER '||v_nombre_funcion||' ON '||v_plana_trigger||';';
          EXECUTE v_sentencia_borrar;
          v_sentencia_borrar:= ' DROP FUNCTION encu.'||v_nombre_funcion||'();';
          EXECUTE v_sentencia_borrar;
        end if;            
    END IF;
  END LOOP;
  RETURN 'procesadas '||v_revisadas||' variables.';
END;
$CUERPO$;

--- generar los trigger

select encu.generar_trigger_variables_calculadas('#todo');

-----
CREATE OR REPLACE FUNCTION encu.generar_trigger_dispara_variables_calculadas() RETURNS TEXT
LANGUAGE plpgsql VOLATILE AS
$CUERPO$
DECLARE
 xs1p   TEXT;
 xs1vh  text;
 xs1v   text;
 v_script_dispara_varcal_s1_p TEXT;
 v_for_vh   text;
 v_mat_vh   text;
 v_sc_script_vh TEXT;
 v_var_set_i1 TEXT;
 v_var_set_s1 TEXT;
 v_sent TEXT;
 
BEGIN  
select string_agg ('new.pla_'||var_var||' is distinct from old.pla_'||var_var ,' or ')
  into xs1p
 from encu.variables
 where var_ope=dbo.ope_actual()
    and var_mat='P';
RAISE NOTICE ' XS1P: %', xs1p; 
v_sent=$a$
  select var_var 
    from encu.variables_ordenadas
    where var_ope=dbo.ope_actual() and var_for=$1 
    limit 1; 
$a$; 
v_sent=replace(v_sent,'#v_for', 'S1');
EXECUTE v_sent  INTO v_var_set_s1 using 'S1';
EXECUTE v_sent  INTO v_var_set_i1 using 'I1';
   
v_script_dispara_varcal_s1_p=$a$
    CREATE OR REPLACE FUNCTION encu.disparar_variables_calculadas_s1_p_trg()
      RETURNS trigger AS
    $BODY$
        BEGIN
        if $campos_s1_p then
            update encu.plana_i1_
                    set pla_$var_i1 = pla_$var_i1
                    where pla_enc = new.pla_enc
                    and pla_hog = new.pla_hog
                    and pla_mie = new.pla_mie
                    and pla_exm = 0;
        end if;
        return new;
        END
    $BODY$
    LANGUAGE plpgsql ;
    ALTER FUNCTION encu.disparar_variables_calculadas_s1_p_trg()
      OWNER TO tedede_php;
$a$;
RAISE NOTICE ' script s1p %', v_script_dispara_varcal_s1_p;    

v_script_dispara_varcal_s1_p=replace(replace(v_script_dispara_varcal_s1_p,'$campos_s1_p',xs1p),'$var_i1',v_var_set_i1);
RAISE NOTICE ' script s1p %', v_script_dispara_varcal_s1_p;    

EXECUTE v_script_dispara_varcal_s1_p;

-- 
SELECT distinct  blo_for, blo_mat 
    INTO v_for_vh, v_mat_vh  
    FROM encu.bloques 
    where blo_blo in ('Viv','Hog', 'HEH');

select string_agg ('new.pla_'||var_var||' is distinct from old.pla_'||var_var ,' or ' order by v.var_var),
       string_agg (case when p.pre_blo='Viv' then 'new.pla_'||var_var||' is distinct from old.pla_'||var_var else null end,' or ' order by v.var_var)
    into xs1vh, xs1v
    from encu.variables v 
        join encu.preguntas p on p.pre_ope=v.var_ope and p.pre_mat=v.var_mat and
             p.pre_pre= v.var_pre and p.pre_blo in ('Viv', 'Hog','HEH');
RAISE NOTICE ' condiciones %, %, %, %', v_for_vh, v_mat_vh,xs1vh, xs1v; 
v_sc_script_vh= $a$
        CREATE OR REPLACE FUNCTION encu.disparar_variables_calculadas_$xplanavh_trg()
          RETURNS trigger AS
        $BODY$
            BEGIN
            if $xcond_var_vh then
                update encu.plana_s1_
                        set pla_$var_s1 = pla_$var_s1
                        where pla_enc = new.pla_enc
                        and pla_hog = new.pla_hog
                        and pla_mie = 0
                        and pla_exm = 0;
            end if;
            if $xcond_var_v then
                update encu.plana_s1_
                        set pla_$var_s1 = pla_$var_s1
                        where pla_enc = new.pla_enc
        --                and pla_hog = new.pla_hog  PORQUE v2 está informada solo en hogar 1
                        and pla_mie = 0
                        and pla_exm = 0;
                update encu.plana_i1_
                        set pla_$var_i1 = pla_$var_i1
                        where pla_enc = new.pla_enc;
        --                and pla_hog = new.pla_hog  PORQUE v2 está informada solo en hogar 1
            end if;
            return new;
            END;
          $BODY$
          LANGUAGE plpgsql;
        ALTER FUNCTION encu.disparar_variables_calculadas_$xplanavh_trg()
          OWNER TO tedede_php;             
$a$;  
--RAISE NOTICE ' script s1 %', v_sc_script_vh;    
  
v_sc_script_vh=replace(v_sc_script_vh,'$xplanavh',v_for_vh||'_'||v_mat_vh);
v_sc_script_vh=replace(v_sc_script_vh,'$xcond_var_vh',xs1vh);
v_sc_script_vh=replace(v_sc_script_vh,'$xcond_var_v',xs1v);
v_sc_script_vh=replace(replace(v_sc_script_vh,'$var_i1',v_var_set_i1),'$var_s1', v_var_set_s1);
RAISE NOTICE ' script s1 luego del reemplazo %', v_sc_script_vh;
EXECUTE v_sc_script_vh;

v_sent= ' DROP TRIGGER IF EXISTS disparar_variables_calculadas_$xplanavh_trg ON encu.plana_$xplanavh;';
v_sent= replace(v_sent, '$xplanavh',v_for_vh||'_'||v_mat_vh);
EXECUTE v_sent;

v_sent=$a$
CREATE TRIGGER disparar_variables_calculadas_$xplanavh_trg
  AFTER UPDATE
  ON encu.plana_$xplanavh
  FOR EACH ROW
  EXECUTE PROCEDURE encu.disparar_variables_calculadas_$xplanavh_trg();
$a$;
v_sent= replace(v_sent, '$xplanavh',v_for_vh||'_'||v_mat_vh);
EXECUTE v_sent;

   
RETURN 'ok';
END;
$CUERPO$;

select encu.generar_trigger_dispara_variables_calculadas();

ALTER FUNCTION encu.generar_trigger_dispara_variables_calculadas()
  OWNER TO tedede_php;

DROP TRIGGER IF EXISTS disparar_variables_calculadas_s1_p_trg ON encu.plana_s1_p;
CREATE TRIGGER disparar_variables_calculadas_s1_p_trg
  AFTER UPDATE
  ON encu.plana_s1_p
  FOR EACH ROW
  EXECUTE PROCEDURE encu.disparar_variables_calculadas_s1_p_trg();

