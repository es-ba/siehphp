##FUN
borrar_variables_calculadas_planas
##ESQ
encu
##PARA
revisar 
##DETALLE
##PROVISORIO
set search_path = encu, comun, dbo, public;

-- DROP FUNCTION IF EXISTS encu.borrar_variables_calculadas_planas(text);

CREATE OR REPLACE FUNCTION encu.borrar_variables_calculadas_planas(p_cual text) RETURNS TEXT
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

    
BEGIN
  v_tab=repeat(' ',4);
  -- v_identifica_var_regexp := '\m(?!AND)(?!OR)(?!NOT)(?!IS)(?!NULL)(?!IN)(?!TRUE)(?!FALSE)(?!EXISTS)(?!DISTINCT)(?!FROM)(?!BETWEEN)(?!dbo)([a-z]\w*)(?!\s*(\(|\$\$))\M';
  FOR v_destinos in
    select destino, plana_destino, otro_destino_1, otro_destino_2, formulario, matriz 
        from (
              select 'hog'::text as destino, 's1_'::text as plana_destino, 'i1_'::text as otro_destino_1, (select lower(mat_for||'_'||mat_mat) from encu.matrices where mat_for='A1' and mat_mat='X') as otro_destino_2, 'S1'::text as formulario, null as matriz
              union select 'mie'::text, 'i1_'::text, 's1_'::text as otro_destino_1, (select lower(mat_for||'_'||mat_mat) from encu.matrices where mat_for='A1' and mat_mat='X') as otro_destino_2, 'I1'::text as formulario, null as matriz
              union select 'exm'::text, lower(mat_for||'_'||mat_mat)as plana_destino, 'i1_'::text as otro_destino_1, 's1_'::text as otro_destino_2 , mat_for as formulario, mat_mat as matriz
                        from encu.matrices
                        where mat_ope= dbo.ope_actual() and mat_for='A1' and mat_mat='X'
             ) x
  LOOP
    v_alterplanas_add:='';
    v_alterplanas_drop:='';
    v_alterhisplanas_add:='';
    v_alterhisplanas_drop:='';
    --- borro las variables calculadas que fueron eliminadas de varcal y quedan en las planas
    if v_destinos.matriz is null then
      FOR v_variables_a_borrar in
        select column_name as i_var_borrar from information_schema.columns where table_name = 'plana_'||v_destinos.plana_destino and table_schema = 'encu' 
          and substr(column_name,5) not in ('enc','hog','mie','exm','tlg')
          and substr(column_name,5) not in (select var_var from encu.variables where var_ope = dbo.ope_actual() and var_for = v_destinos.formulario) 
          -- and substr(column_name,5) not in (select distinct(varcal_varcal) from encu.varcal inner join encu.varcalopc on varcal_varcal=varcalopc_varcal where varcal_ope = dbo.ope_actual() and varcal_destino = v_destinos.destino and varcal_tipo ='normal')
          and substr(column_name,5) not in (select varcal_varcal from encu.varcal where varcal_ope = dbo.ope_actual() and varcal_destino = v_destinos.destino and varcal_activa and varcal_tipo ='externo')
          and substr(column_name,5) not in (select varcal_varcal from encu.varcal where varcal_ope = dbo.ope_actual() and varcal_destino = v_destinos.destino and varcal_activa and varcal_tipo ='especial')
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
          and substr(column_name,5) not in (select varcal_varcal from encu.varcal where varcal_ope = dbo.ope_actual() and varcal_destino = v_destinos.destino and varcal_activa and varcal_tipo ='especial')
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
                   union select 'VALCAN'::text as v_otro_for, ''::text as v_otra_mat, '' as v_otro_blo,'v'::text as v_alias,
                               ' v.pla_ope ='''|| dbo.ope_actual()||''''::text as v_condic         
         
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
                            (var_mat='P' or pre_blo in ('Viv','Hog','HEH'))
                    union select 'comuna'::text  as var_var, 'TEM'::text as var_for, '' as var_mat,'' as v_blo, 'integer' as var_tipovar, 1 pre_orden, 1 var_orden
                    union select 'estado'::text  as var_var, 'TEM'::text as var_for, '' as var_mat,'' as v_blo, 'integer' as var_tipovar, 2 pre_orden, 2 var_orden
                    union select 'dominio'::text as var_var, 'TEM'::text as var_for, '' as var_mat,'' as v_blo, 'integer' as var_tipovar ,3 pre_orden, 3 var_orden
                    union select  varcal_varcal, 'VALCAN'::text as var_for, '' var_mat ,'' as v_blo, 'decimal' as var_tipovar, 0 pre_orden, varcal_orden 
                             from encu.varcal where varcal_ope=dbo.ope_actual() and varcal_destino='vcan' and varcal_tipo='interno' 
                    order by var_for,var_mat, v_blo,pre_orden, var_orden
                    ) x 
            where var_for = v_otro_formulario.v_otro_for and var_mat=v_otro_formulario.v_otra_mat and v_blo=v_otro_formulario.v_otro_blo;
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
    END LOOP;
    v_script_creador:= v_alterplanas_drop||v_alterhisplanas_drop;
    raise notice ' v_script_creador % ', v_script_creador;
    EXECUTE v_script_creador;
  END LOOP;
  RETURN 'procesadas '||v_revisadas||' variables.';
END;
$CUERPO$;

-- select encu.borrar_variables_calculadas_planas('#todo');