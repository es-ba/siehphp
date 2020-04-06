set search_path=comun,public;
CREATE OR REPLACE FUNCTION comun.a_texto(valor boolean) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
  IF valor IS NULL THEN
    RETURN '';
  ELSIF valor=TRUE THEN
    RETURN 'TRUE';
  ELSE
    RETURN 'FALSE';
  END IF;
END;
$$;
/*OTRA*/
ALTER FUNCTION comun.a_texto(valor boolean) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.a_texto(valor double precision) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
  IF valor IS NULL THEN
    RETURN '';
  ELSE
    RETURN valor::TEXT;
  END IF;
END;
$$;
/*OTRA*/
ALTER FUNCTION comun.a_texto(valor double precision) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.a_texto(valor integer) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
  IF valor IS NULL THEN
    RETURN '';
  ELSE
    RETURN valor::TEXT;
  END IF;
END;
$$;
/*OTRA*/
ALTER FUNCTION comun.a_texto(valor integer) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.a_texto(valor text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
  IF valor IS NULL THEN
    RETURN '';
  ELSIF valor='' THEN
    RETURN '''''';
  ELSE
    RETURN valor;
  END IF;
END;
$$;
/*OTRA*/
ALTER FUNCTION comun.a_texto(valor text) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.a_texto(valor timestamp without time zone) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
  IF valor IS NULL THEN
    RETURN '';
  ELSE
    RETURN TO_CHAR(valor,'dd/mm/yyyy');
  END IF;
END;
$$;
/*OTRA*/
ALTER FUNCTION comun.a_texto(valor timestamp without time zone) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.adaptarestructura(p_version_commit_desde numeric, p_sentencias text) RETURNS void
    LANGUAGE plpgsql
    AS $$
declare 
  vVersionActual numeric;
begin
    select estructuraVersionCommit
      into vVersionActual
      from parametros
      where unicoRegistro;
    if p_version_commit_desde>vVersionActual then
      execute p_sentencias;
      update parametros set estructuraVersionCommit=p_version_commit_desde where unicoregistro;
    end if;
end;
$$;
/*OTRA*/
ALTER FUNCTION comun.adaptarestructura(p_version_commit_desde numeric, p_sentencias text) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.agregar_constraints_caracteres_validos(nombre_esquema character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
  vCampos record;
  vDummy boolean;
BEGIN
  FOR vCampos in 
    SELECT table_name, column_name from information_schema.columns 
      where data_type in ('character varying','text') 
        and table_schema = nombre_esquema
        and is_updatable='YES'
        /* OJO Falta Generalizar
        Es mejor poner la restricción acá que pasarla como parámetro 
        (porque no queremos que accidentalmente se agreguen restricciones en esta tabla)
        */
        and table_name not in ('sesiones','modificaciones','claves','respuestas') and table_name not like 'plana_%'
  LOOP 
    vDummy:=comun.agregar_mejor_constraint_caracteres_validos(nombre_esquema, vCampos.table_name,vCampos.column_name,false);
  END LOOP;
  RETURN true;
  /* Para correrlo:
     SELECT comun.agregar_constraints_caracteres_validos('encu');
  */
END;
$$;
/*OTRA*/
ALTER FUNCTION comun.agregar_constraints_caracteres_validos(nombre_esquema character varying) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.agregar_mejor_constraint_caracteres_validos(p_nombre_esquema text, p_nombre_tabla text, p_nombre_columna text, p_mejorar_antes boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_nombre_constraint varchar;
    v_sql text;
    vVersion record;
BEGIN
    if p_mejorar_antes then
      EXECUTE 'UPDATE '||p_nombre_esquema||'.'||p_nombre_tabla||' SET '||p_nombre_columna||' = TRIM('||p_nombre_columna||') WHERE '||p_nombre_columna||' <> TRIM('||p_nombre_columna||')'; 
      EXECUTE 'UPDATE '||p_nombre_esquema||'.'||p_nombre_tabla||' SET '||p_nombre_columna||' = comun.buscar_reemplazar_espacios_raros('||p_nombre_columna||') WHERE '||p_nombre_columna||' <> comun.buscar_reemplazar_espacios_raros('||p_nombre_columna||')'; 
    end if;
    v_nombre_constraint := 'texto invalido en ' || p_nombre_columna || ' de tabla ' || p_nombre_tabla;
    v_sql:='ALTER TABLE '||p_nombre_esquema||'.'||p_nombre_tabla||' DROP CONSTRAINT "'|| v_nombre_constraint || '";';
    BEGIN
      EXECUTE v_sql;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    FOR vVersion in 
	select 1 AS orden,'codigo' as version 
	union select 2,'extendido' 
	union select 3,'castellano' 
	union select 4,'formula'
	union select 5,'json'
	union select 6,'castellano y formula'
	union select 99,'cualquiera'
	ORDER BY orden
    LOOP
      BEGIN
        v_sql:='ALTER TABLE '||p_nombre_esquema||'.'||p_nombre_tabla||' ADD CONSTRAINT "'|| v_nombre_constraint || '" CHECK (comun.cadena_valida('||p_nombre_columna||','''||vVersion.version||'''));';
        EXECUTE v_sql;
        EXIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
  END LOOP;
  RETURN true;
  /* Para correrlo:
    select comun.agregar_mejor_constraint_caracteres_validos('encu','consistencias','con_importancia',true);
  */
END;
$$;
/*OTRA*/
ALTER FUNCTION comun.agregar_mejor_constraint_caracteres_validos(p_nombre_esquema text, p_nombre_tabla text, p_nombre_columna text, p_mejorar_antes boolean) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.blanco("P_valor" integer) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT $1 IS NULL$_$;
/*OTRA*/
ALTER FUNCTION comun.blanco("P_valor" integer) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.blanco("P_valor" text) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT $1 IS NULL$_$;
/*OTRA*/
ALTER FUNCTION comun.blanco("P_valor" text) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.boolint(p_valor boolean, p_valor_por_falso integer DEFAULT 0, p_valor_por_true integer DEFAULT 1) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
  IF p_valor THEN
    RETURN p_valor_por_true;
  ELSE 
    RETURN p_valor_por_falso;
  END IF;
  /*
select 1, comun.boolint(true)
union select 0, comun.boolint(false)
union select 2, comun.boolint(false, 2)
union select 3, comun.boolint(true, 2, 3);
  */
END;
$$;
/*OTRA*/
ALTER FUNCTION comun.boolint(p_valor boolean, p_valor_por_falso integer, p_valor_por_true integer) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.buscar_reemplazar_espacios_raros(cadena text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$DECLARE
i integer:= 1;
cuantos integer:= 0;
nueva_cadena text:= '';
BEGIN
/*
-- Pruebas:
select entrada, esperado, comun.buscar_reemplazar_espacios_raros(entrada)
    , esperado is distinct from comun.buscar_reemplazar_espacios_raros(entrada)
  from (
  select 'algo '||chr(160)||'asi' as entrada, 'algo asi' as esperado
  union select 'algo '||chr(9)||chr(160)||'asi tambien', 'algo asi tambien'
  union select 'algo'||chr(13)||chr(10)||' bueno', 'algo bueno'
  union select E'algo\rcon\tvarias\rcosas', 'algo con varias cosas'
  union select '\r adelante y atras \n', ' adelante y atras '
  union select ' '||chr(10)||'nuevo caso', ' nuevo caso') casos
  where esperado is distinct from comun.buscar_reemplazar_espacios_raros(entrada);
*/
WHILE (i <= char_length(cadena)) LOOP
   WHILE (ascii(substr(cadena,i,1)) <> 9 and ascii(substr(cadena,i,1)) <> 10 and ascii(substr(cadena,i,1)) <> 13 and ascii(substr(cadena,i,1)) <> 160 and i <= char_length(cadena)) LOOP
         nueva_cadena := nueva_cadena || substr(cadena,i,1);
         i := i +1;
   END LOOP;
   cuantos:= 0;
   WHILE ((ascii(substr(cadena,i,1)) = 9 or ascii(substr(cadena,i,1)) = 10 or ascii(substr(cadena,i,1)) = 13 or ascii(substr(cadena,i,1)) = 160) and i <= char_length(cadena)) LOOP
         cuantos:= cuantos+1;
         i:= i +1;
   END LOOP;
   IF (cuantos > 0) THEN
      cuantos := 0;
      IF (i <= char_length(cadena)) THEN
         IF (ascii(substr(cadena,i,1)) <> 32) THEN
            IF (ascii(substr(nueva_cadena,char_length(nueva_cadena),1)) <> 32) THEN
               nueva_cadena := nueva_cadena || CHR(32);
            END IF;
         END IF;
      ELSE
         IF (ascii(substr(nueva_cadena,char_length(nueva_cadena),1)) <> 32) THEN
           nueva_cadena := nueva_cadena || CHR(32);
         END IF;
      END IF;
   END IF;
END LOOP;
RETURN nueva_cadena;
END;$$;
/*OTRA*/
ALTER FUNCTION comun.buscar_reemplazar_espacios_raros(cadena text) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.cadena_valida(p_cadena text, p_version text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
DECLARE
  /*
  select comun.cadena_valida(entrada, version)=resultado as ok, entrada, version, resultado as esperado, comun.cadena_valida(entrada, version) as recibido
    from (
	  select 'Mauro01' as entrada, 'codigo' as version, true as resultado
	  union select '/xñz1', 'codigo', false
	  union select '/xñz1', 'castellano', true
	  union select '/xñz1', 'formula', false
	  union select '{"pepe":"\\esto;",[]}', 'formula', false
	  union select '{"pepe":"\\esto;",[]}', 'json', true
	  union select 'a<99-', 'formula', true
	  union select 'a<99-', 'codigo', false) x
    where comun.cadena_valida(entrada, version) is distinct from resultado 
  
  */
  caracteres_permitidos_codigo text:='A-Za-z0-9_';
  caracteres_permitidos_extendido text:='-'||caracteres_permitidos_codigo||' ,/*+().$@!#:';
  caracteres_permitidos_castellano text:=caracteres_permitidos_extendido||'ÁÉÍÓÚÜÑñáéíóúüçÇ¿¡';
  caracteres_permitidos_formula text:=caracteres_permitidos_extendido||'<>=';
  caracteres_permitidos_castellano_formula text:=caracteres_permitidos_castellano||'<>=';
  caracteres_permitidos_json text:=caracteres_permitidos_formula||'{}"\[\]\\|&^~'';';
  caracteres_permitidos text;
  explicar boolean:=false;
  largo integer;
  expresion_regular text;
  v_juego_caracteres text:=p_version;
BEGIN
  if p_version like 'explicar%' then
    explicar:=true;
    v_juego_caracteres:=substr(p_version,length('explicar ')+1);
  end if;
  if v_juego_caracteres='cualquiera' then
    return true;
  end if;
  caracteres_permitidos:=case v_juego_caracteres
    when 'codigo' then caracteres_permitidos_codigo
    when 'extendido' then caracteres_permitidos_extendido
    when 'castellano' then caracteres_permitidos_castellano
    when 'formula' then caracteres_permitidos_formula
    when 'json' then caracteres_permitidos_json
    when 'castellano y formula' then caracteres_permitidos_castellano_formula
  end;
  if caracteres_permitidos is null then
    raise exception 'Parametro invalido para p_version "%"',p_version;
  end if;
  expresion_regular:='^['||caracteres_permitidos||']*$';
  if explicar then
    largo := char_length(p_cadena);
    for i IN 1..largo LOOP
      if not (substr(p_cadena,i,1) ~ expresion_regular) THEN
        raise exception 'El caracter % es invalido (%)', substr(p_cadena,i,1), ascii(substr(p_cadena,i,1));
      END IF;
    END LOOP;
  end if;
  return p_cadena ~ expresion_regular;
END;
$_$;
/*OTRA*/
ALTER FUNCTION comun.cadena_valida(p_cadena text, p_version text) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.caracteres_invalidos(p_cadena text, p_version text DEFAULT NULL::text, p_forma text DEFAULT NULL::text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $_$DECLARE
  caracteres_invalidos text := '';
  caracteres_permitidos_codigo text:='A-Za-z0-9_';
  caracteres_permitidos_extendido text:='-'||caracteres_permitidos_codigo||' ,/*().+$@!#:';
  caracteres_permitidos_castellano text:=caracteres_permitidos_extendido||'ÁÉÍÓÚÜÑñáéíóúüçÇ¿¡';
  caracteres_permitidos_formula text:=caracteres_permitidos_extendido||'<>=';
  caracteres_permitidos_json text:=caracteres_permitidos_formula||'{}"\[\]\\|&^~'';';
  caracteres_permitidos_castellano_formula text:=caracteres_permitidos_castellano||'<>=';
  caracteres_permitidos text;
  expresion_regular text;
  expresion_regular_codigo text;
  expresion_regular_extendido text;
  expresion_regular_castellano text;
  expresion_regular_formula text;
  expresion_regular_json text;
  expresion_regular_castellano_formula text;
  caracter_ascii int;
  largo int;
BEGIN/*
-- Pruebas:
select version, entrada, comun.caracteres_invalidos(entrada,version,forma)
     from (
  select '+?af'::text as entrada, 'codigo'::text as version, null as forma, 1 as caso
  union select '+?af', 'codigo', 'esc', 2 
  union select '+af', 'codigo', null, 3
  union select '+af', 'codigo', 'esc', 4 
  union select '☻☺defg', 'codigo', null, 5 
  union select '☻☺defg', 'codigo', 'esc', 6 
  union select 'defg', 'codigo', null, 7   
  union select 'defg', 'codigo', 'esc', 8 
  union select 'asdjfhasd', 'cualquiera', null, 9 
  union select 'asdjfhasd', 'cualquiera', 'esc', 10 
  union select 'Áñ= u', 'castellano', null, 11 
  union select 'Áñ= u', 'castellano', 'esc', 12
  union select 'á><=¿', 'formula', null, 13 
  union select 'á><=¿', 'formula', 'esc', 14
  union select 'úÑ=☻', 'castellano y formula', null, 15
  union select 'úÑ=☻', 'castellano y formula', null, 16
  union select 'sdfasd☺>Ñ?¿asdfas', null, null, 17
  union select 'sdfasd☺>Ñ?¿asdfas', null, 'esc', 18) casos order by caso;
*/
if (p_version = 'cualquiera') then
   return caracteres_invalidos;
end if;
if (p_version ISNULL) then
   expresion_regular_codigo:='^['||caracteres_permitidos_codigo||']*$';
   expresion_regular_extendido:='^['||caracteres_permitidos_extendido||']*$';
   expresion_regular_castellano:='^['||caracteres_permitidos_castellano||']*$';
   expresion_regular_formula:='^['||caracteres_permitidos_formula||']*$';
   expresion_regular_json:='^['||caracteres_permitidos_json||']*$';
   expresion_regular_castellano_formula:='^['||caracteres_permitidos_castellano_formula||']*$';
/*   caracteres_permitidos :=caracteres_permitidos_castellano_formula;
   expresion_regular:='^['||caracteres_permitidos||']*$';*/
   largo := char_length(p_cadena);
   for i in 1..largo LOOP
       if ((substr(p_cadena,i,1) !~ expresion_regular_codigo) and (substr(p_cadena,i,1) !~ expresion_regular_extendido) and (substr(p_cadena,i,1) !~ expresion_regular_castellano) and (substr(p_cadena,i,1) !~ expresion_regular_formula) and (substr(p_cadena,i,1) !~ expresion_regular_castellano_formula)) then
/*       if (substr(p_cadena,i,1) !~ expresion_regular) then*/
          if (p_forma = 'esc') then 
             caracteres_invalidos := caracteres_invalidos||chr(92)||chr(92)||'u'||to_hex(ascii(substr(p_cadena,i,1)));
          else
             caracteres_invalidos := caracteres_invalidos||substr(p_cadena,i,1);
          end if;
       end if;
   end loop;
   return caracteres_invalidos;
else
    case p_version
       when 'codigo' then caracteres_permitidos := caracteres_permitidos_codigo;
       when 'extendido' then caracteres_permitidos :=caracteres_permitidos_extendido;
       when 'castellano' then caracteres_permitidos := caracteres_permitidos_castellano;
       when 'formula' then caracteres_permitidos := caracteres_permitidos_formula;
       when 'json' then caracteres_permitidos := caracteres_permitidos_json;
       when 'castellano y formula' then caracteres_permitidos := caracteres_permitidos_castellano_formula;
       else raise exception 'Parametro invalido para "version" "%"',"p_version";
    end case;
    expresion_regular:='^['||caracteres_permitidos||']*$';
    largo := char_length(p_cadena);
    for i in 1..largo LOOP
        if (substr(p_cadena,i,1) !~ expresion_regular) then
           if (p_forma = 'esc') then 
              caracteres_invalidos := caracteres_invalidos||chr(92)||chr(92)||'u'||to_hex(ascii(substr(p_cadena,i,1)));
           else
              caracteres_invalidos := caracteres_invalidos||substr(p_cadena,i,1);
           end if;
        end if;
    end loop;
    return caracteres_invalidos;
end if;
end;$_$;
/*OTRA*/
ALTER FUNCTION comun.caracteres_invalidos(p_cadena text, p_version text, p_forma text) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.completar_fecha(p_fecha text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
  v_fecha_construida text;
  v_array_fecha text[];
begin
     if(comun.es_fecha(p_fecha)) then
        return p_fecha;
     else
       v_array_fecha:=regexp_split_to_array(p_fecha, '/');
       v_fecha_construida:='15/'||v_array_fecha[array_length(v_array_fecha, 1)-1]||'/'||v_array_fecha[array_length(v_array_fecha, 1)];
       return v_fecha_construida;
     end if;	
end;
$$;
/*OTRA*/
ALTER FUNCTION comun.completar_fecha(p_fecha text) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.concato_add(p_uno text, p_dos text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
  if p_uno IS NULL OR p_uno='' then
    if p_dos IS NULL OR p_dos='' then
	  RETURN '';
	else
	  RETURN p_dos;
	end if;
  else 
    if p_dos IS NULL OR p_dos='' then
	  RETURN p_uno;
	else
	  RETURN p_uno || ' ' || p_dos;
	end if;
  end if;  
END;
$$;
/*OTRA*/
ALTER FUNCTION comun.concato_add(p_uno text, p_dos text) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.concato_fin(p_uno text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
  RETURN trim(p_uno);
END;
$$;
/*OTRA*/
ALTER FUNCTION comun.concato_fin(p_uno text) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.crear_genericas_maxlen(tipo text) RETURNS void
    LANGUAGE plpgsql
    AS $_$
BEGIN

EXECUTE replace(
$ESTO$
CREATE OR REPLACE FUNCTION comun.maxlen_unir(p_uno _TIPO_, p_dos _TIPO_) returns _TIPO_
as
$$
BEGIN
  if length(coalesce(p_uno::text,''))>length(coalesce(p_dos::text,'')) then
    RETURN p_uno;
  else 
    RETURN p_dos;
  end if;  
END;
$$
  LANGUAGE 'plpgsql' IMMUTABLE;

CREATE OR REPLACE FUNCTION comun.maxlen_fin(p_uno _TIPO_) returns _TIPO_
as
$$
BEGIN
  RETURN p_uno;
END;
$$
  LANGUAGE 'plpgsql' IMMUTABLE;

DROP AGGREGATE IF EXISTS comun.maxlen (_TIPO_);
CREATE AGGREGATE comun.maxlen (_TIPO_)
(
    sfunc = comun.maxlen_unir,
    stype = _TIPO_,
    finalfunc = comun.maxlen_fin
);

GRANT EXECUTE ON FUNCTION comun.maxlen(_TIPO_) TO public; 
GRANT EXECUTE ON FUNCTION comun.maxlen_unir(_TIPO_, _TIPO_) TO public; 
GRANT EXECUTE ON FUNCTION comun.maxlen_fin(_TIPO_) TO public; 

$ESTO$, '_TIPO_', tipo);

END;
$_$;
/*OTRA*/
ALTER FUNCTION comun.crear_genericas_maxlen(tipo text) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.date_from_epoch(p_epoch integer) RETURNS timestamp with time zone
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
  return TIMESTAMP WITH TIME ZONE 'epoch' + p_epoch * INTERVAL '1 second';
END;
$$;
/*OTRA*/
ALTER FUNCTION comun.date_from_epoch(p_epoch integer) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.enrango("P_valor" integer, "P_minimo" integer, "P_maximo" integer) RETURNS integer
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT CASE WHEN ($1>=$2 and $1<=$3) THEN 1 ELSE 0 END$_$;
/*OTRA*/
ALTER FUNCTION comun.enrango("P_valor" integer, "P_minimo" integer, "P_maximo" integer) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.es_cadena_vacia(ptexto text) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $$  
    select (length(ptexto)=0) is true ; 
$$;
/*OTRA*/
ALTER FUNCTION comun.es_cadena_vacia(ptexto text) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.es_fecha(valor text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
  valor_fecha timestamp;
BEGIN
  if valor is null THEN
     RETURN false;
  end if;
  valor_fecha :=comun.valor_fecha(valor);
  RETURN true;
EXCEPTION
  WHEN invalid_datetime_format THEN
    RETURN false;  
  WHEN datetime_field_overflow THEN
    RETURN false;  
  WHEN raise_exception THEN
    RETURN false;  
  WHEN others THEN     return false;
END;
$$;
/*OTRA*/
ALTER FUNCTION comun.es_fecha(valor text) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.es_fecha_parcial(p_fecha text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
  v_fecha_construida text;
  v_array_fecha text[];
begin
     if(comun.es_fecha(p_fecha)) then
        return true;
     else
       v_array_fecha:=regexp_split_to_array(p_fecha, '/');
       if array_length(v_array_fecha, 1) < 2 then
          return false;
       else
          v_fecha_construida:='15/'||v_array_fecha[array_length(v_array_fecha, 1)-1]||'/'||v_array_fecha[array_length(v_array_fecha, 1)];
          if(comun.es_fecha(v_fecha_construida)) then
	      return true;
	  else
	      return false;
	  end if;
       end if;
     end if;	
end;
$$;
/*OTRA*/
ALTER FUNCTION comun.es_fecha_parcial(p_fecha text) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.es_numero(valor text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
  valor_numerico double precision;
BEGIN
  valor_numerico:=valor::double precision;
  RETURN true;
EXCEPTION
  WHEN invalid_text_representation THEN
    RETURN false;  
  -- WHEN others THEN     return false;
END;
$$;
/*OTRA*/
ALTER FUNCTION comun.es_numero(valor text) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.final_mediana(anyarray) RETURNS double precision
    LANGUAGE sql IMMUTABLE
    AS $_$ 
  WITH q AS
  (
     SELECT val
     FROM unnest($1) val
     WHERE VAL IS NOT NULL
     ORDER BY 1
  ),
  cnt AS
  (
    SELECT COUNT(*) AS c FROM q
  )
  SELECT AVG(val)::float8
  FROM 
  (
    SELECT val FROM q
    LIMIT  2 - MOD((SELECT c FROM cnt), 2)
    OFFSET GREATEST(CEIL((SELECT c FROM cnt) / 2.0) - 1,0)  
  ) q2;
$_$;
/*OTRA*/
ALTER FUNCTION comun.final_mediana(anyarray) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.ignorado(valor integer) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
  IF valor = -1 THEN
     RETURN true;
  END IF;
RETURN false;
END;
$$;
/*OTRA*/
ALTER FUNCTION comun.ignorado(valor integer) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.ignorado(valor text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
  IF valor = '--' THEN
     RETURN true;
  END IF;
RETURN false;
END;
$$;
/*OTRA*/
ALTER FUNCTION comun.ignorado(valor text) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.informado("P_valor" integer) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT $1 IS NOT NULL$_$;
/*OTRA*/
ALTER FUNCTION comun.informado("P_valor" integer) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.informado("P_valor" text) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT $1 IS NOT NULL$_$;
/*OTRA*/
ALTER FUNCTION comun.informado("P_valor" text) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.json_encode(datos text[]) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE 
  /*
    select comun.json_encode(enviado) is not distinct from esperado as ok, enviado, esperado, comun.json_encode(enviado) as recibido
    from (
	    select array['hola','che'] as enviado, '["hola","che"]' as esperado
	    union select array[E'ho\nla','ch"e"'] , E'["ho\\nla","ch\\"e\\""]' ) x
    where comun.json_encode(enviado) is not distinct from esperado
  */
  i integer;
  json text:='[';
  coma text:='';
BEGIN
  FOR i in array_lower(datos,1)..array_upper(datos,1) 
  LOOP
    json:=json||coma||'"'||replace(replace(replace(datos[i],'"',E'\\"'),chr(10),E'\\n'),chr(13),E'\\r')||'"';
    coma:=',';
  END LOOP;
  return json||']';
END;
$$;
/*OTRA*/
ALTER FUNCTION comun.json_encode(datos text[]) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.lanza(p_mensaje text) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
  raise exception 'lanza %',p_mensaje;
end;
$$;
/*OTRA*/
ALTER FUNCTION comun.lanza(p_mensaje text) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.maxlen_fin(p_uno boolean) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
  RETURN p_uno;
END;
$$;
/*OTRA*/
ALTER FUNCTION comun.maxlen_fin(p_uno boolean) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.maxlen_fin(p_uno date) RETURNS date
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
  RETURN p_uno;
END;
$$;
/*OTRA*/
ALTER FUNCTION comun.maxlen_fin(p_uno date) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.maxlen_fin(p_uno double precision) RETURNS double precision
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
  RETURN p_uno;
END;
$$;
/*OTRA*/
ALTER FUNCTION comun.maxlen_fin(p_uno double precision) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.maxlen_fin(p_uno integer) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
  RETURN p_uno;
END;
$$;
/*OTRA*/
ALTER FUNCTION comun.maxlen_fin(p_uno integer) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.maxlen_fin(p_uno text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
  RETURN p_uno;
END;
$$;
/*OTRA*/
ALTER FUNCTION comun.maxlen_fin(p_uno text) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.maxlen_unir(p_uno boolean, p_dos boolean) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
  if length(coalesce(p_uno::text,''))>length(coalesce(p_dos::text,'')) then
    RETURN p_uno;
  else 
    RETURN p_dos;
  end if;  
END;
$$;
/*OTRA*/
ALTER FUNCTION comun.maxlen_unir(p_uno boolean, p_dos boolean) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.maxlen_unir(p_uno date, p_dos date) RETURNS date
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
  if length(coalesce(p_uno::text,''))>length(coalesce(p_dos::text,'')) then
    RETURN p_uno;
  else 
    RETURN p_dos;
  end if;  
END;
$$;
/*OTRA*/
ALTER FUNCTION comun.maxlen_unir(p_uno date, p_dos date) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.maxlen_unir(p_uno double precision, p_dos double precision) RETURNS double precision
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
  if length(coalesce(p_uno::text,''))>length(coalesce(p_dos::text,'')) then
    RETURN p_uno;
  else 
    RETURN p_dos;
  end if;  
END;
$$;
/*OTRA*/
ALTER FUNCTION comun.maxlen_unir(p_uno double precision, p_dos double precision) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.maxlen_unir(p_uno integer, p_dos integer) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
  if length(coalesce(p_uno::text,''))>length(coalesce(p_dos::text,'')) then
    RETURN p_uno;
  else 
    RETURN p_dos;
  end if;  
END;
$$;
/*OTRA*/
ALTER FUNCTION comun.maxlen_unir(p_uno integer, p_dos integer) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.maxlen_unir(p_uno text, p_dos text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
  if length(coalesce(p_uno::text,''))>length(coalesce(p_dos::text,'')) then
    RETURN p_uno;
  else 
    RETURN p_dos;
  end if;  
END;
$$;
/*OTRA*/
ALTER FUNCTION comun.maxlen_unir(p_uno text, p_dos text) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.mostrar_rango_simplificado(p_minvalor text, p_maxvalor text, p_count bigint) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
begin
  /* Pruebas
  select comun.mostrar_rango_simplificado(mini::text,maxi::text,canti) is not distinct from esperado as ok,
         mini,maxi,canti,
         comun.mostrar_rango_simplificado(mini::text,maxi::text,canti), esperado
    from
    (select 1 as mini, 1 as maxi, 1 as canti, '1' as esperado
    union select 1,2,2,'1, 2'
    union select 8,14,3,'8...14'
    union select null,null,0,null
    union select 11,22,6,'11......22') x
  where comun.mostrar_rango_simplificado(mini::text,maxi::text,canti) is distinct from esperado
  */
  if p_minvalor is distinct from p_maxvalor then
    if p_count=2 then
      return p_minvalor||', '||p_maxvalor;
    else
      return p_minvalor||rpad('',p_count::integer,'.')||p_maxvalor;
    end if;
  else
    return p_minvalor;
  end if;
end;
$$;
/*OTRA*/
ALTER FUNCTION comun.mostrar_rango_simplificado(p_minvalor text, p_maxvalor text, p_count bigint) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.nsnc(valor integer) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
  IF valor = -9 THEN
     RETURN true;
  END IF;
RETURN false;
END;
$$;
/*OTRA*/
ALTER FUNCTION comun.nsnc(valor integer) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.nsnc(valor text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
  IF valor = '//' THEN
     RETURN true;
  END IF;
RETURN false;
END;
$$;
/*OTRA*/
ALTER FUNCTION comun.nsnc(valor text) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.nulo_a_neutro(integer) RETURNS integer
    LANGUAGE sql IMMUTABLE
    AS $_$
  select coalesce($1,0);
$_$;
/*OTRA*/
ALTER FUNCTION comun.nulo_a_neutro(integer) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.nulo_a_neutro(text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $_$
  select coalesce($1,'');
$_$;
/*OTRA*/
ALTER FUNCTION comun.nulo_a_neutro(text) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.para_ordenar_numeros(texto_con_numeros text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
declare
	rta text='';
	vPar record;
begin
	for vPar in 
		select regexp_matches(texto_con_numeros, E'([^0-9.]*|\\.)([0-9]*)', 'g') as conjunto
	loop
		rta=rta||vPar.conjunto[1];
		if vPar.conjunto[1]='.' then
			rta=rta||vPar.conjunto[2];
		elsif(length(vPar.conjunto[2])>0) then
			rta=rta||lpad(vPar.conjunto[2],9);
		end if;
	end loop;
	return rta;
end;
$$;
/*OTRA*/
ALTER FUNCTION comun.para_ordenar_numeros(texto_con_numeros text) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.probar(p_sentencia text) RETURNS text
    LANGUAGE plpgsql
    AS $$
begin
  execute p_sentencia;
  return 'Ejecuto sin excepciones';
exception
  when others then
    return sqlstate || ': ' || sqlerrm;
end;
  $$;
/*OTRA*/
ALTER FUNCTION comun.probar(p_sentencia text) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.rango("P_valor" integer, "P_minimo" integer, "P_maximo" integer) RETURNS integer
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT CASE WHEN ($1>=$2 and $1<=$3) THEN $1 ELSE 0 END$_$;
/*OTRA*/
ALTER FUNCTION comun.rango("P_valor" integer, "P_minimo" integer, "P_maximo" integer) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.reemplazar_variables(p_expresion text, p_reemplazante text) RETURNS text
    LANGUAGE sql
    AS $_$ select regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace(regexp_replace($1,
                 '(?!\mAND\M)(?!\mOR\M)(?!\mNOT\M)(?!\mIS\M)(?!\mNULL\M)(?!\mIN\M)(?!\mTRUE\M)(?!\mFALSE\M)(?!\mEXISTS\M)(?!\mDISTINCT\M)(?!\mFROM\M)(?!\mBETWEEN\M)((\m[a-z][a-z0-9_.]*?\M)|\$\$[^$]*?\$\$|"@[^"]*?@"\()(?!\.)(?!\s*\()',
                 '¬¬¬¬1234¬¬¬¬\1¬¬¬¬4321¬¬¬¬','ig'),
                 '¬¬¬¬1234¬¬¬¬(\$\$.*?\$\$)¬¬¬¬4321¬¬¬¬','\1::text','ig'),
                 '::¬¬¬¬1234¬¬¬¬(.*?)¬¬¬¬4321¬¬¬¬','::\1','ig'),
                 '¬¬¬¬1234¬¬¬¬(\W.*?)¬¬¬¬4321¬¬¬¬','\1','ig'),
                 '¬¬¬¬1234¬¬¬¬(.*?)¬¬¬¬4321¬¬¬¬',$2,'ig'),
                 '/','::numeric/','ig'),
                 '((::numeric *|\*)::numeric *)/|::numeric/(\*)','\2/\3','ig')
   $_$;
/*OTRA*/
ALTER FUNCTION comun.reemplazar_variables(p_expresion text, p_reemplazante text) OWNER TO postgres;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.valor_fecha(p_valor text) RETURNS timestamp without time zone
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
DECLARE
  valor_fecha timestamp;
BEGIN
  if p_valor ~ '^[\s]*[0-9][0-9][0-9][0-9][-/][0-1]?[0-9][-/][0-3]?[0-9]([\s][0-9][0-9][:][0-9][0-9]([:][0-9][0-9])?)?[\s]*$' THEN
     valor_fecha :=TO_TIMESTAMP(p_valor,'YYYY-MM-DD HH24:MI:SS'); 
  elseif p_valor  ~ '^[\s]*[0-3]?[0-9][-/][0-1]?[0-9][-/][0-9][0-9][0-9][0-9]([\s][0-9][0-9][:][0-9][0-9]([:][0-9][0-9])?)?[\s]*$' THEN
     valor_fecha :=TO_TIMESTAMP(p_valor,'DD-MM-YYYY HH24 MI SS');     
  else
    raise exception 'no se pudo';
  end if;
  RETURN valor_fecha;
EXCEPTION
  WHEN invalid_datetime_format THEN
    RETURN null; 
  -- when others THEN     return null; 
END;
$_$;
/*OTRA*/
ALTER FUNCTION comun.valor_fecha(p_valor text) OWNER TO tedede_php;
/*OTRA*/
CREATE AGGREGATE concato(text) (
    SFUNC = concato_add,
    STYPE = text,
    INITCOND = '',
    FINALFUNC = concato_fin
);
/*OTRA*/
ALTER AGGREGATE concato(text) OWNER TO tedede_php;
/*OTRA*/
CREATE AGGREGATE comun.maxlen(boolean) (
    SFUNC = comun.maxlen_unir,
    STYPE = boolean,
    FINALFUNC = comun.maxlen_fin
);
/*OTRA*/
ALTER AGGREGATE comun.maxlen(boolean) OWNER TO tedede_php;
/*OTRA*/
CREATE AGGREGATE comun.maxlen(date) (
    SFUNC = comun.maxlen_unir,
    STYPE = date,
    FINALFUNC = comun.maxlen_fin
);
/*OTRA*/
ALTER AGGREGATE comun.maxlen(date) OWNER TO tedede_php;
/*OTRA*/
CREATE AGGREGATE comun.maxlen(double precision) (
    SFUNC = comun.maxlen_unir,
    STYPE = double precision,
    FINALFUNC = comun.maxlen_fin
);
/*OTRA*/
ALTER AGGREGATE comun.maxlen(double precision) OWNER TO tedede_php;
/*OTRA*/
CREATE AGGREGATE comun.maxlen(integer) (
    SFUNC = comun.maxlen_unir,
    STYPE = integer,
    FINALFUNC = comun.maxlen_fin
);
/*OTRA*/
ALTER AGGREGATE comun.maxlen(integer) OWNER TO tedede_php;
/*OTRA*/
CREATE AGGREGATE comun.maxlen(text) (
    SFUNC = comun.maxlen_unir,
    STYPE = text,
    FINALFUNC = comun.maxlen_fin
);
/*OTRA*/
ALTER AGGREGATE comun.maxlen(text) OWNER TO tedede_php;
/*OTRA*/
CREATE OR REPLACE FUNCTION comun.boolint(p_valor boolean, p_valor_por_falso integer DEFAULT 0, p_valor_por_true integer DEFAULT 1)
  RETURNS integer AS
$BODY$
BEGIN
  IF p_valor THEN
    RETURN p_valor_por_true;
  ELSE 
    RETURN p_valor_por_falso;
  END IF;  
END;
$BODY$
  LANGUAGE plpgsql IMMUTABLE;
/*OTRA*/ 
ALTER FUNCTION comun.boolint(boolean, integer, integer)
  OWNER TO tedede_php;

