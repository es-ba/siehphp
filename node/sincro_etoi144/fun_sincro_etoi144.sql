create or replace function operaciones.sincro_etoi144(p_username text, p_password text) returns text
  language plpgsql as
$BODY$
declare
  v_dummy text;
  v_conn_name text:='eah_conn';
  v_rowcount bigint;
  v_def record;
  v_varext_faltantes text;
begin
  raise notice 'arranco %',current_timestamp;
  if not (p_username||p_password ~ '^\w+$') then
    raise exception 'nombre de usuario o clave con caracteres invalidos';
  end if;
  raise notice 'creando la conexión entre bases';
  select dblink_disconnect(v_conn_name) 
    into v_dummy
    from unnest(dblink_get_connections())
    where unnest=v_conn_name;
  select dblink_connect(v_conn_name , 'dbname=eah2014_produc_db user='||p_username||' password='||p_password) into v_dummy;
  for v_def in
    SELECT operacion, c.table_name, prefijo, 
           string_agg(kcu.column_name, ', ') as col_pk_coma,
           string_agg(  c.column_name, ', ') as col_todos_coma,
           string_agg(kcu.column_name||' '||c.data_type||coalesce('('||c.character_maximum_length||')',''), ', ') as col_pk_tipos_coma,
           string_agg(  c.column_name||' '||c.data_type||coalesce('('||c.character_maximum_length||')',''), ', ') as col_todos_tipos_coma,
           string_agg('des.'||kcu.column_name||' = ori.'||c.column_name,' and ') as col_igual_pk_and,
           string_agg('des.'||kcu.column_name||' = ori.'||c.column_name,', ') as col_igual_pk,
           string_agg(          c.column_name||' = ori.'||c.column_name,', ') as col_igual_todos,
           string_agg('des.'||  c.column_name||' is distinct from ori.'||c.column_name,' or ') as col_igual_todos_distor
      FROM information_schema.columns c 
        INNER JOIN information_schema.table_constraints tc ON tc.table_schema=c.table_schema and tc.table_name=c.table_name 
        INNER JOIN (
          select 'tabulados' as table_name, 1 as orden, 'tab' as prefijo, 'true' as filtro
            union select 'varcal'         , 2         , 'varcal'        , 'true'
            union select 'varcalopc'      , 3         , 'varcalopc'     , 'true'
            union select 'claves'         , 4         , 'cla'           , 'cla_tlg>300236'
        ) def ON def.table_name=c.table_name
        CROSS JOIN (select 'delete' as operacion, -1 as orden_operacion 
                      union select 'insert', 1) x
        LEFT JOIN information_schema.key_column_usage kcu ON c.table_schema=kcu.table_schema and c.table_name=kcu.table_name and c.column_name=kcu.column_name and tc.constraint_name=kcu.constraint_name
      WHERE c.table_schema='encu'
        AND tc.constraint_type='PRIMARY KEY'
        AND c.column_name not like '%_tlg'
      GROUP BY c.table_name, orden, orden_operacion, operacion, prefijo
      ORDER BY orden_operacion, orden_operacion*orden
  loop
    raise notice 'definición de %, %',v_def.table_name,v_def.operacion;
    if v_def.operacion='delete' then
      SELECT dblink_open(v_conn_name, v_def.table_name, $$select $$||v_def.col_pk_coma||$$ from encu.$$||v_def.table_name) into v_dummy;
      EXECUTE $$
        delete from encu.$$||v_def.table_name||$$
          where ($$||v_def.col_pk_coma||$$) not in (
            select $$||v_def.col_pk_coma||$$
              from dblink_fetch('$$||v_conn_name||$$', '$$||v_def.table_name||$$', 99999) as ($$||v_def.col_pk_tipos_coma||$$)
          );$$;
      GET DIAGNOSTICS v_rowcount = ROW_COUNT;
      raise notice 'borrados % registros',v_rowcount;
    else
      SELECT dblink_open(v_conn_name, v_def.table_name, $$select $$||v_def.col_todos_coma||$$ from encu.$$||v_def.table_name) into v_dummy;
      EXECUTE $$
        update encu.$$||v_def.table_name||$$ as des
          set $$||v_def.col_igual_todos||$$
          from (
            select $$||v_def.col_todos_coma||$$
              from dblink_fetch('$$||v_conn_name||$$', '$$||v_def.table_name||$$', 99999) as ($$||v_def.col_todos_tipos_coma||$$)
          ) ori
          where $$||v_def.col_igual_pk_and||$$
            and ($$||v_def.col_igual_todos_distor||$$);$$;
      GET DIAGNOSTICS v_rowcount = ROW_COUNT;
      raise notice 'actualizados % registros',v_rowcount;
      SELECT dblink_close(v_conn_name, v_def.table_name) into v_dummy;
      SELECT dblink_open(v_conn_name, v_def.table_name, $$select $$||v_def.col_todos_coma||$$ from encu.$$||v_def.table_name) into v_dummy;
      EXECUTE $$
        insert into encu.$$||v_def.table_name||$$ ($$||v_def.col_todos_coma||$$,$$||v_def.prefijo||$$_tlg) 
          select $$||v_def.col_todos_coma||$$,1
            from dblink_fetch('$$||v_conn_name||$$', '$$||v_def.table_name||$$', 99999) as ($$||v_def.col_todos_tipos_coma||$$)
            where ($$||v_def.col_pk_coma||$$) not in (select $$||v_def.col_pk_coma||$$ from encu.$$||v_def.table_name||$$);$$;
      GET DIAGNOSTICS v_rowcount = ROW_COUNT;
      raise notice 'agregados % registros',v_rowcount;
    end if;
    SELECT dblink_close(v_conn_name, v_def.table_name) into v_dummy;
  end loop;
  raise notice 'controlando que las variables externas tengan su indicación de si deben ser pasadas o no en operaciones.var_ext';
  SELECT $$'$$||string_agg(varcal_varcal, $$', '$$ order by varcal_varcal)||$$'$$
    INTO v_varext_faltantes
    FROM encu.varcal LEFT JOIN operaciones.varext ON varext_ope=varcal_ope AND varext_varext=varcal_varcal
    WHERE varcal_tipo='externo'
      AND varext_pasar IS NULL;
  if v_varext_faltantes is not null then
    raise exception 'Falta indicar si deben pasarse o no las siguientes variables externas %',v_varext_faltantes;
  end if;
  return 'listo';
end;
$BODY$;

alter function operaciones.sincro_etoi144(p_username text, p_password text) owner to tedede_php;

--FIN FUN

select operaciones.sincro_etoi144('tedede_php','laclave');
