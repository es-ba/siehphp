set search_path = encu, comun, public;

DROP FUNCTION IF EXISTS operaciones.generar_trigger_variables_calculadas_trg();
DROP FUNCTION IF EXISTS encu.generar_trigger_variables_calculadas();

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
  -- v_identifica_var_regexp := '\m(?!AND)(?!OR)(?!NOT)(?!IS)(?!NULL)(?!IN)(?!TRUE)(?!FALSE)(?!EXISTS)(?!DISTINCT)(?!FROM)(?!BETWEEN)(?!dbo)([a-z]\w*)(?!\s*(\(|\$\$))\M';
  FOR v_destinos in
    select destino, plana_destino, otro_destino_1, otro_destino_2, formulario, matriz from (
      select 'hog'::text as destino, 's1_'::text as plana_destino, 'i1_'::text as otro_destino_1, 'a1_x'::text as otro_destino_2, 'S1'::text as formulario, null as matriz
      union select 'mie'::text, 'i1_'::text, 's1_'::text as otro_destino_1, 'a1_x'::text as otro_destino_2, 'I1'::text as formulario, null as matriz
      union select 'exm'::text, 'a1_x'::text, 'i1_'::text as otro_destino_1, 's1_'::text as otro_destino_2, 'A1'::text as formulario, 'X'::text as matriz
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
    v_sentencia:='';
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
           v_expresion:= regexp_replace(v_expresion, '\mnew.pla_(edad|sexo|f_nac_o|p4|p5|p5b|p6_a|p6_b|comuna|estado|h3|v2)\M'::text, 'v_\1'::text,'ig');
           -- v_expresion_valor:= regexp_replace(v_expresion_valor, v_identifica_var_regexp, 'new.pla_\1'::text,'ig');
           v_expresion_valor:= encu.reemplazar_agregadores(v_expresion_valor);
           v_expresion_valor:= comun.reemplazar_variables(v_expresion_valor, 'new.pla_\1');
           v_expresion_valor:= regexp_replace(v_expresion_valor, '\mnew.pla_(edad|sexo|f_nac_o|p4|p5|p5b|p6_a|p6_b|comuna|h3|v2)\M'::text, 'v_\1'::text,'ig');
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
               union select 'v_f_nac_o'::text   as v_vari, 'text'::text    as v_tipo
               union select 'v_p4'::text        as v_vari, 'integer'::text as v_tipo
               union select 'v_p5'::text        as v_vari, 'integer'::text as v_tipo
               union select 'v_p5b'::text       as v_vari, 'integer'::text as v_tipo
               union select 'v_p6_a'::text      as v_vari, 'integer'::text as v_tipo
               union select 'v_p6_b'::text      as v_vari, 'integer'::text as v_tipo
               union select 'v_comuna'::text    as v_vari, 'integer'::text as v_tipo
               union select 'v_estado'::text    as v_vari, 'integer'::text as v_tipo
               --union select 'v_h2'::text        as v_vari, 'integer'::text as v_tipo
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
                   union select 'f_nac_o'::text   as v_vari,  'S1'::text as v_formu
                   union select 'p4'::text        as v_vari,  'S1'::text as v_formu
                   union select 'p5'::text        as v_vari,  'S1'::text as v_formu
                   union select 'p5b'::text       as v_vari,  'S1'::text as v_formu
                   union select 'p6_a'::text      as v_vari,  'S1'::text as v_formu
                   union select 'p6_b'::text      as v_vari,  'S1'::text as v_formu
                   union select 'comuna'::text    as v_vari,  'TEM'::text as v_formu
                   union select 'estado'::text    as v_vari,  'TEM'::text as v_formu
                   --union select 'h2'::text        as v_vari,  'A1'::text as v_formu
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
        v_script_creador:= v_alterplanas_drop||v_alterhisplanas_drop||v_alterplanas_add||v_alterhisplanas_add;
        v_script_creador:=v_script_creador|| v_script_principio;
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

--- generar los trigger

select encu.generar_trigger_variables_calculadas('#todo');

-- Function: disparar_variables_calculadas_s1_p_trg()

-- DROP FUNCTION encu.disparar_variables_calculadas_s1_p_trg();

CREATE OR REPLACE FUNCTION encu.disparar_variables_calculadas_s1_p_trg()
  RETURNS trigger AS
$BODY$
    BEGIN
    if new.pla_edad is distinct from old.pla_edad or new.pla_sexo is distinct from old.pla_sexo or new.pla_f_nac_o is distinct from old.pla_f_nac_o or new.pla_p4 is distinct from old.pla_p4 or new.pla_p5 is distinct from old.pla_p5 or new.pla_p5b is distinct from old.pla_p5b or new.pla_p6_a is distinct from old.pla_p6_a or new.pla_p6_b is distinct from old.pla_p6_b then
        update encu.plana_i1_
                set pla_obs = pla_obs
                where pla_enc = new.pla_enc
                and pla_hog = new.pla_hog
                and pla_mie = new.pla_mie
                and pla_exm = 0;
    end if;
    return new;
    END
  $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION encu.disparar_variables_calculadas_s1_p_trg()
  OWNER TO tedede_php;

-- Trigger: disparar_variables_calculadas_s1_p_trg on encu.plana_s1_p_

-- DROP TRIGGER disparar_variables_calculadas_s1_p_trg ON encu.plana_s1_p_;

CREATE TRIGGER disparar_variables_calculadas_s1_p_trg
  AFTER UPDATE
  ON encu.plana_s1_p
  FOR EACH ROW
  EXECUTE PROCEDURE encu.disparar_variables_calculadas_s1_p_trg();

-- Function: disparar_variables_calculadas_a1__trg()

-- DROP FUNCTION encu.disparar_variables_calculadas_a1__trg();

CREATE OR REPLACE FUNCTION encu.disparar_variables_calculadas_a1__trg()
  RETURNS trigger AS
$BODY$
    BEGIN
    if new.pla_h3 is distinct from old.pla_h3 then
        update encu.plana_s1_
                set pla_movil = pla_movil
                where pla_enc = new.pla_enc
                and pla_hog = new.pla_hog
                and pla_mie = 0
                and pla_exm = 0;
    end if;
    if new.pla_v2 is distinct from old.pla_v2 then
        update encu.plana_s1_
                set pla_movil = pla_movil
                where pla_enc = new.pla_enc
--                and pla_hog = new.pla_hog  PORQUE v2 está informada solo en hogar 1
                and pla_mie = 0
                and pla_exm = 0;
        update encu.plana_i1_
                set pla_obs = pla_obs
                where pla_enc = new.pla_enc;
--                and pla_hog = new.pla_hog  PORQUE v2 está informada solo en hogar 1
    end if;
    return new;
    END
  $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION encu.disparar_variables_calculadas_a1__trg()
  OWNER TO tedede_php;

-- Trigger: disparar_variables_calculadas_a1__trg on encu.plana_a1_

-- DROP TRIGGER disparar_variables_calculadas_a1__trg ON encu.plana_a1_;

CREATE TRIGGER disparar_variables_calculadas_a1__trg
  AFTER UPDATE
  ON encu.plana_a1_
  FOR EACH ROW
  EXECUTE PROCEDURE encu.disparar_variables_calculadas_a1__trg();




