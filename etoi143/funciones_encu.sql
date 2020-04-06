set search_path = encu, comun, public;
/*OTRA*/
DROP FUNCTION IF EXISTS encu.generar_trigger_variables_calculadas();
/*OTRA*/
CREATE OR REPLACE FUNCTION encu.generar_trigger_variables_calculadas(p_cual text) RETURNS TEXT
LANGUAGE plpgsql VOLATILE AS
$CUERPO$
DECLARE
  v_enter text:=chr(13)||chr(10);
  v_script_principio text;
  v_script_final text;
  v_script_creador text;
  v_variables record;
  v_opciones record;
  v_sentencia text;
  v_expresion text;
  v_opcion text;
  v_identifica_var_regexp text;
  v_destinos record;
  v_plana_trigger text;
  v_nombre_funcion text;
  v_sentencia_variable text;
  v_alterplanas_add text;
  v_alterplanas_drop text;
  v_alterhisplanas_add text;
  v_alterhisplanas_drop text;
  sent_set text;
  sentencia text;
  v_revisadas integer:=0;
  v_expresion_valor text;
  v_declare text;
  v_variables_declare record;
  v_buscar_total text;
  v_buscar text;
  v_for character varying(50);
  v_mat character varying(50);
  v_blo character varying(50);
  v_variables_otro_formulario record;
  v_otro_formulario record;
  v_buscar_otro text;
  v_buscar_viv text;
  v_into_otro text;
  v_into_viv text;
  v_tabla text;
  v_variable_mensaje text;
  v_sentencia_borrar text;
  v_si_existe integer;
  v_variables_a_borrar record;
  v_tipodatovar text;
  v_tiporiginal text;
  v_pos_error_var integer;
BEGIN
  v_alterplanas_add:='';
  v_alterplanas_drop:='';
  v_alterhisplanas_add:='';
  v_alterhisplanas_drop:='';
  -- v_identifica_var_regexp := '\m(?!AND)(?!OR)(?!NOT)(?!IS)(?!NULL)(?!IN)(?!TRUE)(?!FALSE)(?!EXISTS)(?!DISTINCT)(?!FROM)(?!BETWEEN)(?!dbo)([a-z]\w*)(?!\s*(\(|\$\$))\M';
  FOR v_destinos in
    select destino, plana_destino, otro_destino_1, otro_destino_2, formulario, matriz from (
      select 'hog'::text as destino, 's1_'::text as plana_destino, 'i1_'::text as otro_destino_1, 'a1_x'::text as otro_destino_2, 'S1'::text as formulario, null as matriz
      union select 'mie'::text, 'i1_'::text, 's1_'::text as otro_destino_1, 'a1_x'::text as otro_destino_2, 'I1'::text as formulario, null as matriz
      union select 'exm'::text, 'a1_x'::text, 'i1_'::text as otro_destino_1, 's1_'::text as otro_destino_2, 'A1'::text as formulario, 'X'::text as matriz
    ) x
  LOOP
    --- borro las variables calculadas que fueron eliminadas de varcal y quedan en las planas
    if v_destinos.matriz is null then
      FOR v_variables_a_borrar in
        select column_name as i_var_borrar from information_schema.columns where table_name = 'plana_'||v_destinos.plana_destino and table_schema = 'encu' 
          and substr(column_name,5) not in ('enc','hog','mie','exm','tlg')
          and substr(column_name,5) not in (select var_var from encu.variables where var_ope = dbo.ope_actual() and var_for = v_destinos.formulario) 
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

    ---  recorro las variables calculadas para el formulario plana_destino
    FOR v_variables in
        select distinct(varcal_varcal) as i_variable, varcal_tipodedato as i_tipodedato, varcal_orden 
          from encu.varcal inner join encu.varcalopc on varcal_varcal = varcalopc_varcal
          where varcal_ope = dbo.ope_actual()
            and varcal_destino = v_destinos.destino
            and varcal_activa
            and varcal_tipo not in ('externo','especial')
            and (varcal_varcal=p_cual or p_cual='#todo')
          order by varcal_orden
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
  END LOOP;
  v_script_creador:= v_alterplanas_drop||v_alterhisplanas_drop||v_alterplanas_add||v_alterhisplanas_add; 
  --raise notice 'script creador %', v_script_creador;  
  EXECUTE v_script_creador;
  v_sentencia:='';
  FOR v_destinos in
    select destino, plana_destino, otro_destino_1, otro_destino_2, formulario, matriz from (
      select 'hog'::text as destino, 's1_'::text as plana_destino, 'i1_'::text as otro_destino_1, 'a1_x'::text as otro_destino_2, 'S1'::text as formulario, null as matriz
      union select 'mie'::text, 'i1_'::text, 's1_'::text as otro_destino_1, 'a1_x'::text as otro_destino_2, 'I1'::text as formulario, null as matriz
      union select 'exm'::text, 'a1_x'::text, 'i1_'::text as otro_destino_1, 's1_'::text as otro_destino_2, 'A1'::text as formulario, 'X'::text as matriz
    ) x
  LOOP
    FOR v_variables in
        select distinct(varcal_varcal) as i_variable, varcal_tipodedato as i_tipodedato, varcal_orden 
          from encu.varcal inner join encu.varcalopc on varcal_varcal = varcalopc_varcal
          where varcal_ope = dbo.ope_actual()
            and varcal_destino = v_destinos.destino
            and varcal_activa
            and varcal_tipo not in ('externo','especial')
            and (varcal_varcal=p_cual or p_cual='#todo')
          order by varcal_orden
    LOOP
        --- por cada variable recorro sus opciones
        v_sentencia_variable:='';
        FOR v_opciones IN
            select varcalopc_opcion as i_opcion, varcalopc_expresion_condicion as i_expresion_condicion, varcalopc_expresion_valor as i_expresion_valor
              from encu.varcalopc
              where varcalopc_ope = dbo.ope_actual() and varcalopc_varcal = v_variables.i_variable
        LOOP
           v_expresion:=v_opciones.i_expresion_condicion;
           v_opcion:=v_opciones.i_opcion;
           v_expresion_valor:=v_opciones.i_expresion_valor;
           -- v_expresion:= regexp_replace(v_expresion, v_identifica_var_regexp, 'new.pla_\1'::text,'ig');
           v_expresion:= encu.reemplazar_agregadores(v_expresion);
           v_expresion:= comun.reemplazar_variables(v_expresion, 'new.pla_\1');
           v_expresion:= regexp_replace(v_expresion, '\mnew.pla_(edad|sexo|f_nac_d|f_nac_m|f_nac_a|p4|p5|p5b|p6_a|p6_b|comuna|estado|h2|h3|v2)\M'::text, 'v_\1'::text,'ig');
           -- v_expresion_valor:= regexp_replace(v_expresion_valor, v_identifica_var_regexp, 'new.pla_\1'::text,'ig');
           v_expresion_valor:= encu.reemplazar_agregadores(v_expresion_valor);
           v_expresion_valor:= comun.reemplazar_variables(v_expresion_valor, 'new.pla_\1');
           v_expresion_valor:= regexp_replace(v_expresion_valor, '\mnew.pla_(edad|sexo|f_nac_d|f_nac_m|f_nac_a|p4|p5|p5b|p6_a|p6_b|comuna|h2|h3|v2)\M'::text, 'v_\1'::text,'ig');
           v_sentencia_variable:=v_sentencia_variable||v_enter||'when ('||v_expresion||') then '||coalesce(v_expresion_valor,v_opcion);
        END LOOP;
        IF v_sentencia_variable<>'' THEN
              v_sentencia_variable:=' new.pla_'||v_variables.i_variable||':=case '||v_sentencia_variable||v_enter||' else null end; '||v_enter;
              v_sentencia:=v_sentencia||v_enter||v_sentencia_variable;
        END IF;
    END LOOP;
    IF v_sentencia<>'' THEN
        --- creo el script para generar
        v_buscar_total:='';
        v_buscar:='';
        v_plana_trigger:='encu.plana_'||v_destinos.plana_destino;
        if(p_cual='#todo')then
            v_nombre_funcion:='calculo_variables_calculadas_'||v_destinos.plana_destino||'_trg';
        else
            v_nombre_funcion:='calculo_variables_calculadas_tmp_'||v_destinos.plana_destino||'_trg';
        end if;
        v_declare:='';
        -- PARA variables de formularios cruzados S1, TEM y A1
        FOR v_variables_declare in
            select v_vari, v_tipo from (
                     select 'v_edad'::text      as v_vari, 'integer'::text as v_tipo
               union select 'v_sexo'::text      as v_vari, 'integer'::text as v_tipo
               union select 'v_f_nac_d'::text   as v_vari, 'integer'::text as v_tipo
               union select 'v_f_nac_m'::text   as v_vari, 'integer'::text as v_tipo
               union select 'v_f_nac_a'::text   as v_vari, 'integer'::text as v_tipo
               union select 'v_p4'::text        as v_vari, 'integer'::text as v_tipo
               union select 'v_p5'::text        as v_vari, 'integer'::text as v_tipo
               union select 'v_p5b'::text       as v_vari, 'integer'::text as v_tipo
               union select 'v_p6_a'::text      as v_vari, 'integer'::text as v_tipo
               union select 'v_p6_b'::text      as v_vari, 'integer'::text as v_tipo
               union select 'v_comuna'::text    as v_vari, 'integer'::text as v_tipo
               union select 'v_estado'::text    as v_vari, 'integer'::text as v_tipo
               union select 'v_h2'::text        as v_vari, 'integer'::text as v_tipo
               union select 'v_h3'::text        as v_vari, 'integer'::text as v_tipo
               union select 'v_v2'::text        as v_vari, 'integer'::text as v_tipo
            ) x
        LOOP
            v_declare:=v_declare||'
            '||v_variables_declare.v_vari||' '||v_variables_declare.v_tipo||';';
        END LOOP;
        FOR v_otro_formulario in
            select v_otro_for, v_otra_mat, v_alias, v_condic from (
               select 'S1'::text  as v_otro_for, 'P'::text as v_otra_mat, 's'::text as v_alias, ' s.pla_enc = new.pla_enc and s.pla_hog = new.pla_hog and s.pla_mie = new.pla_mie and s.pla_exm = 0 '::text as v_condic
               union select 'TEM'::text as v_otro_for, ''::text as v_otra_mat, 't'::text as v_alias,    ' t.pla_enc = new.pla_enc and t.pla_hog = 0 and t.pla_mie = 0 and t.pla_exm = 0 '::text as v_condic
               union select 'A1'::text  as v_otro_for, ''::text as v_otra_mat, 'a'::text as v_alias,    ' a.pla_enc = new.pla_enc and a.pla_mie = 0 and a.pla_exm = 0 '::text as v_condic
            ) x
        LOOP
            v_buscar_otro:='';
            v_into_otro:='';
            v_buscar_viv:='';
            v_into_viv:='';
            v_tabla:='encu.plana_'||lower(v_otro_formulario.v_otro_for)||'_'||lower(v_otro_formulario.v_otra_mat)||' '||v_otro_formulario.v_alias;
-- acá van las variables de formularios distintos al del trigger que se está creando
-- en el caso de variables del bloque Viv, hay que leer el hogar 1
            FOR v_variables_otro_formulario in
                select v_vari, coalesce(pre_blo,'') as v_blo, v_formu from (
                         select 'edad'::text      as v_vari,  'S1'::text as v_formu
                   union select 'sexo'::text      as v_vari,  'S1'::text as v_formu
                   union select 'f_nac_d'::text   as v_vari,  'S1'::text as v_formu
                   union select 'f_nac_m'::text   as v_vari,  'S1'::text as v_formu
                   union select 'f_nac_a'::text   as v_vari,  'S1'::text as v_formu
                   union select 'p4'::text        as v_vari,  'S1'::text as v_formu
                   union select 'p5'::text        as v_vari,  'S1'::text as v_formu
                   union select 'p5b'::text       as v_vari,  'S1'::text as v_formu
                   union select 'p6_a'::text      as v_vari,  'S1'::text as v_formu
                   union select 'p6_b'::text      as v_vari,  'S1'::text as v_formu
                   union select 'comuna'::text    as v_vari,  'TEM'::text as v_formu
                   union select 'estado'::text    as v_vari,  'TEM'::text as v_formu
                   union select 'h2'::text        as v_vari,  'A1'::text as v_formu
                   union select 'h3'::text        as v_vari,  'A1'::text as v_formu
                   union select 'v2'::text        as v_vari,  'A1'::text as v_formu
                ) x left join encu.variables on v_vari=var_var and var_for=v_otro_formulario.v_otro_for and var_ope = dbo.ope_actual()
                    left join encu.preguntas on var_pre = pre_pre and pre_ope=var_ope
                where v_formu = v_otro_formulario.v_otro_for
            LOOP
                if(v_variables_otro_formulario.v_blo='Viv' and v_otro_formulario.v_otro_for='A1')then
                    v_buscar_viv:=v_buscar_viv||' pla_'||v_variables_otro_formulario.v_vari||',';
                    v_into_viv:=v_into_viv||' v_'||v_variables_otro_formulario.v_vari||',';
                else
                    v_buscar_otro:=v_buscar_otro||' pla_'||v_variables_otro_formulario.v_vari||',';
                    v_into_otro:=v_into_otro||' v_'||v_variables_otro_formulario.v_vari||',';
                end if;
            END LOOP;
            v_buscar:='';
            if(v_buscar_otro <> '')then
                v_buscar_otro:=substr(v_buscar_otro,1,length(v_buscar_otro)-1);
                v_into_otro:=substr(v_into_otro,1,length(v_into_otro)-1);
                v_buscar_otro:=' select '||v_buscar_otro||' into '||v_into_otro||' FROM '||v_tabla||' WHERE '||v_otro_formulario.v_condic;
                if(v_otro_formulario.v_otro_for='A1')then
                    v_buscar_otro:=v_buscar_otro||' and '||v_otro_formulario.v_alias||'.pla_hog = new.pla_hog ';
                end if;
                v_buscar_otro:=v_buscar_otro||';';
                v_buscar:='
                '||v_buscar_otro;
            end if;
            if(v_buscar_viv <> '')then
                v_buscar_viv:=substr(v_buscar_viv,1,length(v_buscar_viv)-1);
                v_into_viv:=substr(v_into_viv,1,length(v_into_viv)-1);
                v_buscar_viv:=' select '||v_buscar_viv||' into '||v_into_viv||' FROM '||v_tabla||' WHERE '||v_otro_formulario.v_condic;
                if(v_otro_formulario.v_otro_for='A1')then                
                    v_buscar_viv:=v_buscar_viv||' and '||v_otro_formulario.v_alias||'.pla_hog = 1 ';
                end if;
                v_buscar_viv:=v_buscar_viv||';';
                v_buscar:=v_buscar||'
                '||v_buscar_viv;
            end if;
            v_buscar_total:=v_buscar_total||v_buscar;
        END LOOP;

        v_script_principio:='
        CREATE OR REPLACE FUNCTION encu.$1()
        RETURNS trigger AS
        $BODY$
        DECLARE'
        ||v_declare||'
        BEGIN'
        ||v_buscar_total;
        v_script_final:=$SCRIPT2$
        return new;
        END
        $BODY$
        LANGUAGE plpgsql VOLATILE
        COST 100;
        ALTER FUNCTION encu.$1()
        OWNER TO tedede_php;

        DROP TRIGGER IF EXISTS $1 ON $2;


        CREATE TRIGGER $1
        BEFORE UPDATE
        ON $2
        FOR EACH ROW
        EXECUTE PROCEDURE encu.$1();
        $SCRIPT2$;
        v_script_creador:=v_script_principio;
            --raise notice 'script creador %', v_script_creador;
        v_script_creador:=v_script_creador|| v_sentencia;
            --raise notice 'script creador %', v_script_creador;
        v_script_creador:=v_script_creador|| v_script_final;
            --raise notice 'script creador %', v_script_creador;
        v_script_creador:=replace(v_script_creador,'$1',v_nombre_funcion);
        v_script_creador:=replace(v_script_creador,'$2',v_plana_trigger);
        BEGIN
        --raise notice ' v_script_creador % ', v_script_creador;
        EXECUTE v_script_creador;
          BEGIN
           sent_set='';
           sentencia='';
           case  v_destinos.plana_destino
              when 'i1_' then
                 sent_set='  set pla_obs = pla_obs ';
              when 's1_' then
                 sent_set='  set pla_movil = pla_movil ';
              when 'a1_x' then
                 sent_set='  set pla_lugar = pla_lugar ';
           end case;
           sentencia= ' update encu.plana_'||v_destinos.plana_destino||sent_set;
           --raise notice 'sentencia %', sentencia;
           EXECUTE  sentencia;          
          END;
        EXCEPTION
          WHEN OTHERS THEN
            v_pos_error_var:=strpos(sqlerrm, '«pla_');
            if v_pos_error_var>0 then
               v_variable_mensaje:=substr(substr(sqlerrm,v_pos_error_var),6); 
               v_variable_mensaje:=substr(v_variable_mensaje,1,length(v_variable_mensaje)-1);
            else
               v_variable_mensaje:='*indeterminada*';
            end if;
            return 'ERROR: Compilación de variable con error. Variable: '|| v_variable_mensaje||'. Error '|| sqlstate || ': ' || sqlerrm||' SENTENCIA: '||sentencia;
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
CREATE OR REPLACE FUNCTION encu.generar_consistencias_audi_nsnc(p_operativo text)
  RETURNS void AS
$BODY$
DECLARE
    xcon_activa             encu.consistencias.con_activa%type;
    xcon_tipo               encu.consistencias.con_tipo%type;
    xcon_falsos_positivos   encu.consistencias.con_falsos_positivos%type;  
    xcon_importancia        encu.consistencias.con_importancia%type;
    xcon_momento            encu.consistencias.con_momento%type;
    xcon_grupo              encu.consistencias.con_grupo%type;
    xcon_gravedad           encu.consistencias.con_gravedad%type;
    xcon_rel                encu.consistencias.con_rel%type;
BEGIN  
    -- Borrar las automaticas
    DELETE FROM encu.inconsistencias
        WHERE inc_con like 'audi_nsnc%';
    DELETE FROM encu.ano_con
        WHERE anocon_con like 'audi_nsnc%';
    DELETE FROM encu.con_var
        WHERE convar_con like 'audi_nsnc%';
    DELETE FROM encu.consistencias
           WHERE con_con like 'audi_nsnc%';
    xcon_activa=true;   
    xcon_tipo='Auditoría';   
    xcon_falsos_positivos=false;
    xcon_importancia='ALTA';
    xcon_momento='Recepción';
    xcon_grupo='nsnc'; 
    xcon_gravedad='Error';    
    xcon_rel='=>';
    
    INSERT INTO encu.consistencias( con_ope,con_con,con_precondicion,con_rel,
                con_postcondicion,
                con_activa, con_explicacion, con_tipo, con_falsos_positivos,
                con_importancia, con_momento, con_grupo, con_gravedad, con_tlg)
        SELECT  var_ope, 'audi_nsnc_'||var_var, 'informado('||var_var||')' as precondicion, xcon_rel,
                case when var_tipovar in ('anios','numeros','marcar_nulidad','edad','anio'
                                        ,'horas','meses','si_no','opciones','monetaria', 'si_no_nosabe3' ) then
                         var_var ||'<> -1 and '||var_var ||'<> -9 and '||var_var ||'<> -5' 
                     else  --'observaciones','telefono','texto_especificar','fecha_corta','texto','fecha','texto_libre'
                         'not es_cadena_vacia('||var_var ||') and '||
                         'not nsnc('||var_var ||') and '||
                         'not ignorado('||var_var ||') and '||
                         var_var ||'<> a_texto(-1) and '||var_var ||'<> a_texto(-9) and '||var_var ||'<> a_texto(-5)' 
                end as postcondicion,
                xcon_activa, 'Variable ' ||var_var ||' tiene NS/NC' as con_explicacion, xcon_tipo, xcon_falsos_positivos,
                xcon_importancia, xcon_momento, xcon_grupo, xcon_gravedad, 1
            FROM encu.variables_ordenadas
            WHERE var_ope=p_operativo
            ORDER BY orden; 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*OTRA*/  
ALTER FUNCTION encu.generar_consistencias_audi_nsnc(text)
  OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION encu.generar_consistencias_audi_rango(p_operativo text)
  RETURNS void AS
$BODY$
DECLARE
    xcon_activa             encu.consistencias.con_activa%type;
    xcon_tipo               encu.consistencias.con_tipo%type;
    xcon_falsos_positivos   encu.consistencias.con_falsos_positivos%type;  
    xcon_importancia        encu.consistencias.con_importancia%type;
    xcon_momento            encu.consistencias.con_momento%type;
    xcon_grupo              encu.consistencias.con_grupo%type;
    xcon_rel                encu.consistencias.con_rel%type;
BEGIN  
    -- Borrar las automaticas
    DELETE FROM encu.inconsistencias
        WHERE inc_con like 'audi_rango%';
    DELETE FROM encu.ano_con
        WHERE anocon_con like 'audi_rango%';
    DELETE FROM encu.con_var
        WHERE convar_con like 'audi_rango%';
    DELETE FROM encu.consistencias
           WHERE con_con like 'audi_rango%';
    xcon_activa=true;   
    xcon_tipo='Auditoría';   
    xcon_falsos_positivos=false;
    xcon_importancia='ALTA';
    xcon_momento='Recepción';
    xcon_grupo='rango';  
    xcon_rel='=>';
    --advertencias
    INSERT INTO encu.consistencias( con_ope,con_con,
                con_precondicion,con_rel,
                con_postcondicion,con_activa,
                con_explicacion,
                con_tipo, con_falsos_positivos,
                con_importancia, con_momento, con_grupo, con_gravedad, con_tlg)
        SELECT  var_ope, 'audi_rango_adv_'||var_var,
                'informado('||var_var||') and not nsnc('||var_var||') and not ignorado('||var_var||')' as precondicion , xcon_rel,
                   coalesce (var_var||'>='||var_advertencia_inf,'') ||
                   case when var_advertencia_inf is not null and var_advertencia_sup is not null then ' and ' else '' end
                   ||coalesce (var_var||'<='||var_advertencia_sup,'')
                   as postcondicion, xcon_activa,
                'Fuera de rango ' ||var_var ||coalesce(' min:'||var_advertencia_inf,'')||coalesce(' max:'||var_advertencia_sup,'') as con_explicacion,
                xcon_tipo, xcon_falsos_positivos,
                xcon_importancia, xcon_momento, xcon_grupo, 'Advertencia', 1
            FROM encu.variables
            WHERE var_ope=p_operativo
                    and var_for <>'TEM'
                    and var_conopc is null
                    and var_tipovar in ('anios','numeros','edad','anio','horas','meses','monetaria' )
                    and (var_advertencia_inf is not null or var_advertencia_sup is not null)            
            ORDER BY var_var; 
    --error        
    INSERT INTO encu.consistencias( con_ope,con_con,con_precondicion,con_rel,
                con_postcondicion, con_activa,
                con_explicacion,
                con_tipo, con_falsos_positivos,
                con_importancia, con_momento, con_grupo, con_gravedad, con_tlg)
        SELECT  var_ope, 'audi_rango_err_'||var_var, 'informado('||var_var||') and not nsnc('||var_var||') and not ignorado('||var_var||')' as precondicion , xcon_rel,
                   coalesce (var_var||'>='||var_minimo,'') ||
                   case when var_minimo is not null and var_maximo is not null then ' and ' else '' end
                   ||coalesce (var_var||'<='||var_maximo,'')
                   as postcondicion, xcon_activa,
                'Fuera de rango ' ||var_var||coalesce(' min:'||var_minimo,'')||coalesce(' max:'||var_maximo,'') as con_explicacion,
                xcon_tipo, xcon_falsos_positivos,
                xcon_importancia, xcon_momento, xcon_grupo, 'Error', 1
            FROM encu.variables
            WHERE var_ope=p_operativo
                    and var_for <>'TEM'
                    and var_conopc is null
                    and var_tipovar in ('anios','numeros','edad','anio','horas','meses','monetaria' )
                    and (var_minimo is not null or var_maximo is not null)            
            ORDER BY var_var;             
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*OTRA*/  
ALTER FUNCTION encu.generar_consistencias_audi_rango(text)
  OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION encu.generar_consistencias_filtro(p_ope text)
  RETURNS void AS
$BODY$
declare
 v_filtros RECORD;
 v_variables_salteadas RECORD;
 v_matrices RECORD;
 v_preguntas RECORD;
 v_desde integer;
 v_hasta integer;
 v_precondicion text;
 v_postcondicion text;
 v_explicacion text;
 v_cuenta integer;
BEGIN 
    DELETE FROM encu.inconsistencias
        WHERE inc_ope=p_ope and inc_con like 'flujo_f%';
    DELETE FROM encu.ano_con
        WHERE anocon_ope=p_ope and anocon_con like 'flujo_f%';
    DELETE FROM encu.con_var
        WHERE convar_ope=p_ope and convar_con like 'flujo_f%';
    DELETE FROM encu.consistencias
           WHERE con_ope=p_ope and con_con like 'flujo_f%';
    FOR v_matrices in
        SELECT mat_for as formulario, mat_mat as matriz, mat_texto as texto
               from encu.matrices 
               where mat_ope = p_ope and mat_for <> 'TEM'
        LOOP 
        FOR v_filtros in
            SELECT fil_for as formu, fil_mat as matri, fil_blo as bloque, fil_fil as filtro, fil_expresion as expresion, fil_destino as destino, 
                   fil_orden as orden     
               FROM encu.filtros
               WHERE fil_ope = p_ope and fil_for = v_matrices.formulario and fil_mat = v_matrices.matriz
               ORDER BY fil_orden
        LOOP
           v_precondicion:=replace(lower(v_filtros.expresion),'copia_','');
           select 'Filtro '|| for_nombre into v_explicacion from encu.formularios where for_ope = p_ope and for_for = v_matrices.formulario;
           if v_matrices.matriz <> '' then
              v_explicacion:=v_explicacion||' '||v_matrices.texto;
           end if;
           --  verifico si el destino del filtro es una pregunta
           select count(*) into v_cuenta from encu.preguntas where pre_ope = p_ope and pre_pre = v_filtros.destino;
            if v_cuenta = 1 then 
              FOR v_preguntas in
                  select blo_blo as elemento, 'pregunta' as tipo, blo_orden as orden, blo_for as formulario, pre_pre as codigo_elemento, 
                         pre_orden as orden_elemento, (100000 * blo_orden  + pre_orden) as orden_final, '' as filtro_destino
                         from encu.bloques 
                         inner join encu.preguntas on blo_ope = pre_ope and blo_blo = pre_blo and blo_for = pre_for 
                         where blo_for = v_filtros.formu and blo_ope = p_ope and blo_mat = v_filtros.matri
                  union select blo_blo as elemento, 'filtro' as tipo, blo_orden as orden, blo_for as formulario, fil_fil as codigo_elemento, 
                         fil_orden as orden_elemento, (100000* blo_orden + fil_orden) as orden_final, fil_destino as filtro_destino
                         from encu.bloques 
                         inner join encu.filtros on blo_ope = fil_ope and blo_blo = fil_blo and blo_for = fil_for
                         where blo_for = v_filtros.formu and blo_ope = p_ope and blo_mat = v_filtros.matri
                         order by orden, orden_final
              LOOP
                 if v_preguntas.codigo_elemento = v_filtros.filtro then
                    v_desde:= v_preguntas.orden_final;
                 end if;
                 if v_preguntas.codigo_elemento = v_filtros.destino then
                    v_hasta:= v_preguntas.orden_final;
                 end if;
              END LOOP;
            else
              -- verifico si el destino es un bloque
              v_desde:= 0;
              v_hasta:= 0;
              select count(*) into v_cuenta from encu.bloques  where blo_ope = p_ope and blo_blo = v_filtros.destino;
              if v_cuenta = 1 then
                 FOR v_preguntas in
                     select blo_blo as elemento, 'pregunta' as tipo, blo_orden as orden, blo_for as formulario, pre_pre as codigo_elemento, 
                            pre_orden as orden_elemento, (100000 * blo_orden  + pre_orden) as orden_final, '' as filtro_destino
                            from encu.bloques 
                            inner join encu.preguntas on blo_ope = pre_ope and blo_blo = pre_blo and blo_for = pre_for 
                            where blo_for = v_filtros.formu and blo_ope = p_ope and blo_mat = v_filtros.matri
                     union select blo_blo as elemento, 'filtro' as tipo, blo_orden as orden, blo_for as formulario, fil_fil as codigo_elemento, 
                            fil_orden as orden_elemento, (100000* blo_orden + fil_orden) as orden_final, fil_destino as filtro_destino
                            from encu.bloques 
                            inner join encu.filtros on blo_ope = fil_ope and blo_blo = fil_blo and blo_for = fil_for
                            where blo_for = v_filtros.formu and blo_ope = p_ope and blo_mat = v_filtros.matri
                            order by orden, orden_final
                 LOOP
                    if v_preguntas.codigo_elemento = v_filtros.filtro then
                       v_desde:= v_preguntas.orden_final;
                    end if;
                    if v_preguntas.elemento = v_filtros.destino and v_hasta = 0 then
                       raise notice 'para destino bloque % , orden_final % ', v_filtros.destino, v_preguntas.orden_final;
                       v_hasta:= v_preguntas.orden_final;
                    end if;
                 END LOOP;
              else 
                 -- verifico si el destino es un filtro
                 select count(*) into v_cuenta from encu.filtros where fil_ope = p_ope and fil_fil = v_filtros.destino;
                 if v_cuenta = 1 then
                    FOR v_preguntas in
                        select blo_blo as elemento, 'pregunta' as tipo, blo_orden as orden, blo_for as formulario, pre_pre as codigo_elemento, 
                               pre_orden as orden_elemento, (100000 * blo_orden  + pre_orden) as orden_final, '' as filtro_destino
                               from encu.bloques 
                               inner join encu.preguntas on blo_ope = pre_ope and blo_blo = pre_blo and blo_for = pre_for 
                               where blo_for = v_filtros.formu and blo_ope = p_ope and blo_mat = v_filtros.matri
                        union select blo_blo as elemento, 'filtro' as tipo, blo_orden as orden, blo_for as formulario, fil_fil as codigo_elemento, 
                               fil_orden as orden_elemento, (100000* blo_orden + fil_orden) as orden_final, fil_destino as filtro_destino
                               from encu.bloques 
                               inner join encu.filtros on blo_ope = fil_ope and blo_blo = fil_blo and blo_for = fil_for
                               where blo_for = v_filtros.formu and blo_ope = p_ope and blo_mat = v_filtros.matri
                               order by orden, orden_final
                    LOOP
                       if v_preguntas.codigo_elemento = v_filtros.filtro then
                          v_desde:= v_preguntas.orden_final;
                       end if;
                       if v_preguntas.codigo_elemento = v_filtros.destino then
                          v_hasta:= v_preguntas.orden_final;
                       end if;
                    END LOOP;
                 else
                    --- verifico si el destino es 'fin'
                    if v_filtros.destino = 'fin' then
                       FOR v_preguntas in
                           select blo_blo as elemento, 'pregunta' as tipo, blo_orden as orden, blo_for as formulario, pre_pre as codigo_elemento, 
                                  pre_orden as orden_elemento, (100000 * blo_orden  + pre_orden) as orden_final, '' as filtro_destino
                                  from encu.bloques 
                                  inner join encu.preguntas on blo_ope = pre_ope and blo_blo = pre_blo and blo_for = pre_for 
                                  where blo_for = v_filtros.formu and blo_ope = p_ope and blo_mat = v_filtros.matri
                           union select blo_blo as elemento, 'filtro' as tipo, blo_orden as orden, blo_for as formulario, fil_fil as codigo_elemento, 
                                  fil_orden as orden_elemento, (100000* blo_orden + fil_orden) as orden_final, fil_destino as filtro_destino
                                  from encu.bloques 
                                  inner join encu.filtros on blo_ope = fil_ope and blo_blo = fil_blo and blo_for = fil_for
                                  where blo_for = v_filtros.formu and blo_ope = p_ope and blo_mat = v_filtros.matri
                                  order by orden, orden_final
                       LOOP
                          if v_preguntas.codigo_elemento = v_filtros.filtro then
                             v_desde:= v_preguntas.orden_final;
                          end if;
                          v_hasta:=v_preguntas.orden_final;
                       END LOOP;
                       v_hasta:=v_hasta+1;
                    end if;
                 end if;
              end if;
           end if;
           v_postcondicion:='true ';
           FOR v_preguntas in
               select x.codigo_elemento as codigo_pregunta from
               (select blo_blo as elemento, 'pregunta' as tipo, blo_orden as orden, blo_for as formulario, pre_pre as codigo_elemento, 
                       pre_orden as orden_elemento, (100000 * blo_orden  + pre_orden) as orden_final, '' as filtro_destino
                       from encu.bloques 
                       inner join encu.preguntas on blo_ope = pre_ope and blo_blo = pre_blo and blo_for = pre_for 
                       where blo_for = v_filtros.formu and blo_ope = p_ope and blo_mat = v_filtros.matri
               union select blo_blo as elemento, 'filtro' as tipo, blo_orden as orden, blo_for as formulario, fil_fil as codigo_elemento, 
                       fil_orden as orden_elemento, (100000* blo_orden + fil_orden) as orden_final, fil_destino as filtro_destino
                       from encu.bloques 
                       inner join encu.filtros on blo_ope = fil_ope and blo_blo = fil_blo and blo_for = fil_for
                       where blo_for = v_filtros.formu and blo_ope = p_ope and blo_mat = v_filtros.matri
                       order by orden, orden_final) x
               where x.orden_final >= v_desde and x.orden_final < v_hasta
           LOOP
              FOR v_variables_salteadas in        
                   SELECT var_var as lavariable
                          FROM encu.preguntas 
                          inner join encu.variables on var_ope = pre_ope and pre_pre = var_pre
                          WHERE pre_ope = p_ope and pre_pre = v_preguntas.codigo_pregunta
                          ORDER BY var_orden         
              LOOP
                 v_postcondicion:=v_postcondicion || 'and '||v_variables_salteadas.lavariable||' is null ';
              END LOOP;
           END LOOP;
           INSERT INTO encu.consistencias( con_ope,con_con,con_precondicion,con_rel,
                                           con_postcondicion,
                                           con_activa, con_explicacion, con_tipo, con_falsos_positivos,
                                           con_importancia, con_momento, con_grupo, con_gravedad, con_tlg)
           values( p_ope, 'flujo_f_'||v_filtros.filtro, v_precondicion, '=>',
                   v_postcondicion, true, v_explicacion, 'Auditoría', false,
                  'ALTA', 'Recepción', 'flujo', 'Error', 1) ;
       END LOOP;
    END LOOP;
END
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*OTRA*/
ALTER FUNCTION encu.generar_consistencias_filtro(text)
  OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION encu.generar_consistencias_flujo(p_operativo text)
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
        WHERE inc_ope=p_operativo and inc_con like 'flujo%';
    DELETE FROM encu.ano_con
        WHERE anocon_ope=p_operativo and anocon_con like 'flujo%';
    DELETE FROM encu.con_var
        WHERE convar_ope=p_operativo and convar_con like 'flujo%';
    DELETE FROM encu.consistencias
           WHERE con_ope=p_operativo and con_con like 'flujo%';
    
    FOR vvar IN
        select distinct v.var_for, s.sal_var, v.var_destino_nsnc
            from encu.saltos s JOIN encu.variables v ON s.sal_var= v.var_var AND s.sal_ope=v.var_ope
            where s.sal_ope=p_operativo  
            order by v.var_for, s.sal_var            
      LOOP
        opc_saltos='';

        --c/opciones de salto
        FOR vopc_s IN
                select distinct on(sal_var,opc_orden)  
                       sal_var, sal_opc , sal_destino as sal_pre, w.var_var as var_destino,w.var_expresion_habilitar,
                       w.var_optativa as var_destino_optativa
                    from encu.saltos s 
                        JOIN encu.opciones o  ON o.opc_opc=s.sal_opc AND o.opc_ope=s.sal_ope AND o.opc_conopc=s.sal_conopc
                        LEFT JOIN encu.variables w ON  w.var_pre=s.sal_destino and w.var_ope=s.sal_ope and w.var_for=vvar.var_for
                    where s.sal_ope=p_operativo and s.sal_var= vvar.sal_var --and s.sal_destino=vvar.sal_destino 
                    order by sal_var, opc_orden, w.var_orden
        loop            
           --flujo_s_ : variables saltadas en NULL
           r_saltadas=encu.variables_saltadas(poperativo, vvar.sal_var, vopc_s.var_destino );
           IF NOT r_saltadas.psaltadas_str='' THEN
               raise notice '% destino % str_saltadas_condicion % largo %',vopc_s.sal_var,vopc_s.var_destino, r_saltadas.psaltadas_cond_str, length(r_saltadas.psaltadas_cond_str) ; 
               rcons.con_ope=p_operativo;
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
               rcons.con_ope=p_operativo;
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
                WHERE x.var_var= vvar.sal_var  and x.var_ope=p_operativo
                ORDER BY v.orden
                LIMIT 1; 
                
        opc_saltos= substr(opc_saltos,5);
        IF vsiguiente is not null and vsig_optativa is false and opc_saltos<>'' THEN
           --raise notice 'saltos origen % ', opc_saltos;
           rcons.con_ope=p_operativo; 
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
            where var_ope=p_operativo and var_destino_nsnc is not null  
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
               rcons.con_ope=p_operativo; 
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
               rcons.con_ope=p_operativo; 
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
  LANGUAGE plpgsql VOLATILE;
/*OTRA*/
ALTER FUNCTION encu.generar_consistencias_flujo(text)
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
  OWNER TO postgres;
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
CREATE OR REPLACE FUNCTION encu.variables_saltadas(IN pope text, IN porigen text, IN pdestino text, OUT psaltadas_str text, OUT psaltadas_cond_str text)
  RETURNS record AS
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
  LANGUAGE plpgsql VOLATILE;
/*OTRA*/ 
ALTER FUNCTION encu.variables_saltadas(text, text, text)
  OWNER TO tedede_php;
/*OTRA*/ 