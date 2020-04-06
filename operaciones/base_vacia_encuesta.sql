--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: comun; Type: SCHEMA; Schema: -; Owner: tedede_php
--

CREATE SCHEMA comun;


ALTER SCHEMA comun OWNER TO tedede_php;

--
-- Name: dbo; Type: SCHEMA; Schema: -; Owner: tedede_php
--

CREATE SCHEMA dbo;


ALTER SCHEMA dbo OWNER TO tedede_php;

--
-- Name: dbx; Type: SCHEMA; Schema: -; Owner: tedede_php
--

CREATE SCHEMA dbx;


ALTER SCHEMA dbx OWNER TO tedede_php;

--
-- Name: de_ejemplo; Type: SCHEMA; Schema: -; Owner: tedede_php
--

CREATE SCHEMA de_ejemplo;


ALTER SCHEMA de_ejemplo OWNER TO tedede_php;

--
-- Name: his; Type: SCHEMA; Schema: -; Owner: tedede_owner
--

CREATE SCHEMA his;


ALTER SCHEMA his OWNER TO tedede_owner;

--
-- Name: operaciones; Type: SCHEMA; Schema: -; Owner: tedede_php
--

CREATE SCHEMA operaciones;


ALTER SCHEMA operaciones OWNER TO tedede_php;

SET search_path = comun, pg_catalog;

--
-- Name: a_texto(boolean); Type: FUNCTION; Schema: comun; Owner: tedede_owner
--

CREATE FUNCTION a_texto(valor boolean) RETURNS text
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


ALTER FUNCTION comun.a_texto(valor boolean) OWNER TO tedede_owner;

--
-- Name: a_texto(double precision); Type: FUNCTION; Schema: comun; Owner: tedede_owner
--

CREATE FUNCTION a_texto(valor double precision) RETURNS text
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


ALTER FUNCTION comun.a_texto(valor double precision) OWNER TO tedede_owner;

--
-- Name: a_texto(integer); Type: FUNCTION; Schema: comun; Owner: tedede_owner
--

CREATE FUNCTION a_texto(valor integer) RETURNS text
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


ALTER FUNCTION comun.a_texto(valor integer) OWNER TO tedede_owner;

--
-- Name: a_texto(text); Type: FUNCTION; Schema: comun; Owner: tedede_owner
--

CREATE FUNCTION a_texto(valor text) RETURNS text
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


ALTER FUNCTION comun.a_texto(valor text) OWNER TO tedede_owner;

--
-- Name: a_texto(timestamp without time zone); Type: FUNCTION; Schema: comun; Owner: tedede_owner
--

CREATE FUNCTION a_texto(valor timestamp without time zone) RETURNS text
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


ALTER FUNCTION comun.a_texto(valor timestamp without time zone) OWNER TO tedede_owner;

--
-- Name: adaptarestructura(numeric, text); Type: FUNCTION; Schema: comun; Owner: tedede_owner
--

CREATE FUNCTION adaptarestructura(p_version_commit_desde numeric, p_sentencias text) RETURNS void
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


ALTER FUNCTION comun.adaptarestructura(p_version_commit_desde numeric, p_sentencias text) OWNER TO tedede_owner;

--
-- Name: agregar_constraints_caracteres_validos(character varying); Type: FUNCTION; Schema: comun; Owner: tedede_owner
--

CREATE FUNCTION agregar_constraints_caracteres_validos(nombre_esquema character varying) RETURNS boolean
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


ALTER FUNCTION comun.agregar_constraints_caracteres_validos(nombre_esquema character varying) OWNER TO tedede_owner;

--
-- Name: agregar_mejor_constraint_caracteres_validos(text, text, text, boolean); Type: FUNCTION; Schema: comun; Owner: postgres
--

CREATE FUNCTION agregar_mejor_constraint_caracteres_validos(p_nombre_esquema text, p_nombre_tabla text, p_nombre_columna text, p_mejorar_antes boolean) RETURNS boolean
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


ALTER FUNCTION comun.agregar_mejor_constraint_caracteres_validos(p_nombre_esquema text, p_nombre_tabla text, p_nombre_columna text, p_mejorar_antes boolean) OWNER TO postgres;

--
-- Name: blanco(integer); Type: FUNCTION; Schema: comun; Owner: tedede_php
--

CREATE FUNCTION blanco("P_valor" integer) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT $1 IS NULL$_$;


ALTER FUNCTION comun.blanco("P_valor" integer) OWNER TO tedede_php;

--
-- Name: blanco(text); Type: FUNCTION; Schema: comun; Owner: tedede_php
--

CREATE FUNCTION blanco("P_valor" text) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT $1 IS NULL$_$;


ALTER FUNCTION comun.blanco("P_valor" text) OWNER TO tedede_php;

--
-- Name: buscar_reemplazar_espacios_raros(text); Type: FUNCTION; Schema: comun; Owner: tedede_owner
--

CREATE FUNCTION buscar_reemplazar_espacios_raros(cadena text) RETURNS text
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


ALTER FUNCTION comun.buscar_reemplazar_espacios_raros(cadena text) OWNER TO tedede_owner;

--
-- Name: cadena_valida(text, text); Type: FUNCTION; Schema: comun; Owner: tedede_owner
--

CREATE FUNCTION cadena_valida(p_cadena text, p_version text) RETURNS boolean
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


ALTER FUNCTION comun.cadena_valida(p_cadena text, p_version text) OWNER TO tedede_owner;

--
-- Name: caracteres_invalidos(text, text, text); Type: FUNCTION; Schema: comun; Owner: tedede_owner
--

CREATE FUNCTION caracteres_invalidos(p_cadena text, p_version text DEFAULT NULL::text, p_forma text DEFAULT NULL::text) RETURNS text
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


ALTER FUNCTION comun.caracteres_invalidos(p_cadena text, p_version text, p_forma text) OWNER TO tedede_owner;

--
-- Name: completar_fecha(text); Type: FUNCTION; Schema: comun; Owner: tedede_php
--

CREATE FUNCTION completar_fecha(p_fecha text) RETURNS text
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


ALTER FUNCTION comun.completar_fecha(p_fecha text) OWNER TO tedede_php;

--
-- Name: concato_add(text, text); Type: FUNCTION; Schema: comun; Owner: tedede_owner
--

CREATE FUNCTION concato_add(p_uno text, p_dos text) RETURNS text
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


ALTER FUNCTION comun.concato_add(p_uno text, p_dos text) OWNER TO tedede_owner;

--
-- Name: concato_fin(text); Type: FUNCTION; Schema: comun; Owner: tedede_owner
--

CREATE FUNCTION concato_fin(p_uno text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
  RETURN trim(p_uno);
END;
$$;


ALTER FUNCTION comun.concato_fin(p_uno text) OWNER TO tedede_owner;

--
-- Name: crear_genericas_maxlen(text); Type: FUNCTION; Schema: comun; Owner: tedede_owner
--

CREATE FUNCTION crear_genericas_maxlen(tipo text) RETURNS void
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


ALTER FUNCTION comun.crear_genericas_maxlen(tipo text) OWNER TO tedede_owner;

--
-- Name: date_from_epoch(integer); Type: FUNCTION; Schema: comun; Owner: tedede_owner
--

CREATE FUNCTION date_from_epoch(p_epoch integer) RETURNS timestamp with time zone
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
  return TIMESTAMP WITH TIME ZONE 'epoch' + p_epoch * INTERVAL '1 second';
END;
$$;


ALTER FUNCTION comun.date_from_epoch(p_epoch integer) OWNER TO tedede_owner;

--
-- Name: enrango(integer, integer, integer); Type: FUNCTION; Schema: comun; Owner: tedede_php
--

CREATE FUNCTION enrango("P_valor" integer, "P_minimo" integer, "P_maximo" integer) RETURNS integer
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT CASE WHEN ($1>=$2 and $1<=$3) THEN 1 ELSE 0 END$_$;


ALTER FUNCTION comun.enrango("P_valor" integer, "P_minimo" integer, "P_maximo" integer) OWNER TO tedede_php;

--
-- Name: es_cadena_vacia(text); Type: FUNCTION; Schema: comun; Owner: tedede_php
--

CREATE FUNCTION es_cadena_vacia(ptexto text) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $$  
    select (length(ptexto)=0) is true ; 
$$;


ALTER FUNCTION comun.es_cadena_vacia(ptexto text) OWNER TO tedede_php;

--
-- Name: es_fecha(text); Type: FUNCTION; Schema: comun; Owner: tedede_owner
--

CREATE FUNCTION es_fecha(valor text) RETURNS boolean
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


ALTER FUNCTION comun.es_fecha(valor text) OWNER TO tedede_owner;

--
-- Name: es_fecha_parcial(text); Type: FUNCTION; Schema: comun; Owner: tedede_php
--

CREATE FUNCTION es_fecha_parcial(p_fecha text) RETURNS boolean
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


ALTER FUNCTION comun.es_fecha_parcial(p_fecha text) OWNER TO tedede_php;

--
-- Name: es_numero(text); Type: FUNCTION; Schema: comun; Owner: tedede_owner
--

CREATE FUNCTION es_numero(valor text) RETURNS boolean
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


ALTER FUNCTION comun.es_numero(valor text) OWNER TO tedede_owner;

--
-- Name: final_mediana(anyarray); Type: FUNCTION; Schema: comun; Owner: tedede_owner
--

CREATE FUNCTION final_mediana(anyarray) RETURNS double precision
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


ALTER FUNCTION comun.final_mediana(anyarray) OWNER TO tedede_owner;

--
-- Name: ignorado(integer); Type: FUNCTION; Schema: comun; Owner: tedede_php
--

CREATE FUNCTION ignorado(valor integer) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
  IF valor = -1 THEN
     RETURN true;
  END IF;
RETURN false;
END;
$$;


ALTER FUNCTION comun.ignorado(valor integer) OWNER TO tedede_php;

--
-- Name: ignorado(text); Type: FUNCTION; Schema: comun; Owner: tedede_php
--

CREATE FUNCTION ignorado(valor text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
  IF valor = '--' THEN
     RETURN true;
  END IF;
RETURN false;
END;
$$;


ALTER FUNCTION comun.ignorado(valor text) OWNER TO tedede_php;

--
-- Name: informado(integer); Type: FUNCTION; Schema: comun; Owner: tedede_php
--

CREATE FUNCTION informado("P_valor" integer) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT $1 IS NOT NULL$_$;


ALTER FUNCTION comun.informado("P_valor" integer) OWNER TO tedede_php;

--
-- Name: informado(text); Type: FUNCTION; Schema: comun; Owner: tedede_php
--

CREATE FUNCTION informado("P_valor" text) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT $1 IS NOT NULL$_$;


ALTER FUNCTION comun.informado("P_valor" text) OWNER TO tedede_php;

--
-- Name: json_encode(text[]); Type: FUNCTION; Schema: comun; Owner: tedede_owner
--

CREATE FUNCTION json_encode(datos text[]) RETURNS text
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


ALTER FUNCTION comun.json_encode(datos text[]) OWNER TO tedede_owner;

--
-- Name: lanza(text); Type: FUNCTION; Schema: comun; Owner: tedede_owner
--

CREATE FUNCTION lanza(p_mensaje text) RETURNS void
    LANGUAGE plpgsql
    AS $$
begin
  raise exception 'lanza %',p_mensaje;
end;
$$;


ALTER FUNCTION comun.lanza(p_mensaje text) OWNER TO tedede_owner;

--
-- Name: maxlen_fin(boolean); Type: FUNCTION; Schema: comun; Owner: tedede_owner
--

CREATE FUNCTION maxlen_fin(p_uno boolean) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
  RETURN p_uno;
END;
$$;


ALTER FUNCTION comun.maxlen_fin(p_uno boolean) OWNER TO tedede_owner;

--
-- Name: maxlen_fin(date); Type: FUNCTION; Schema: comun; Owner: tedede_owner
--

CREATE FUNCTION maxlen_fin(p_uno date) RETURNS date
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
  RETURN p_uno;
END;
$$;


ALTER FUNCTION comun.maxlen_fin(p_uno date) OWNER TO tedede_owner;

--
-- Name: maxlen_fin(double precision); Type: FUNCTION; Schema: comun; Owner: tedede_owner
--

CREATE FUNCTION maxlen_fin(p_uno double precision) RETURNS double precision
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
  RETURN p_uno;
END;
$$;


ALTER FUNCTION comun.maxlen_fin(p_uno double precision) OWNER TO tedede_owner;

--
-- Name: maxlen_fin(integer); Type: FUNCTION; Schema: comun; Owner: tedede_owner
--

CREATE FUNCTION maxlen_fin(p_uno integer) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
  RETURN p_uno;
END;
$$;


ALTER FUNCTION comun.maxlen_fin(p_uno integer) OWNER TO tedede_owner;

--
-- Name: maxlen_fin(text); Type: FUNCTION; Schema: comun; Owner: tedede_owner
--

CREATE FUNCTION maxlen_fin(p_uno text) RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
  RETURN p_uno;
END;
$$;


ALTER FUNCTION comun.maxlen_fin(p_uno text) OWNER TO tedede_owner;

--
-- Name: maxlen_unir(boolean, boolean); Type: FUNCTION; Schema: comun; Owner: tedede_owner
--

CREATE FUNCTION maxlen_unir(p_uno boolean, p_dos boolean) RETURNS boolean
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


ALTER FUNCTION comun.maxlen_unir(p_uno boolean, p_dos boolean) OWNER TO tedede_owner;

--
-- Name: maxlen_unir(date, date); Type: FUNCTION; Schema: comun; Owner: tedede_owner
--

CREATE FUNCTION maxlen_unir(p_uno date, p_dos date) RETURNS date
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


ALTER FUNCTION comun.maxlen_unir(p_uno date, p_dos date) OWNER TO tedede_owner;

--
-- Name: maxlen_unir(double precision, double precision); Type: FUNCTION; Schema: comun; Owner: tedede_owner
--

CREATE FUNCTION maxlen_unir(p_uno double precision, p_dos double precision) RETURNS double precision
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


ALTER FUNCTION comun.maxlen_unir(p_uno double precision, p_dos double precision) OWNER TO tedede_owner;

--
-- Name: maxlen_unir(integer, integer); Type: FUNCTION; Schema: comun; Owner: tedede_owner
--

CREATE FUNCTION maxlen_unir(p_uno integer, p_dos integer) RETURNS integer
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


ALTER FUNCTION comun.maxlen_unir(p_uno integer, p_dos integer) OWNER TO tedede_owner;

--
-- Name: maxlen_unir(text, text); Type: FUNCTION; Schema: comun; Owner: tedede_owner
--

CREATE FUNCTION maxlen_unir(p_uno text, p_dos text) RETURNS text
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


ALTER FUNCTION comun.maxlen_unir(p_uno text, p_dos text) OWNER TO tedede_owner;

--
-- Name: mostrar_rango_simplificado(text, text, bigint); Type: FUNCTION; Schema: comun; Owner: tedede_owner
--

CREATE FUNCTION mostrar_rango_simplificado(p_minvalor text, p_maxvalor text, p_count bigint) RETURNS text
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


ALTER FUNCTION comun.mostrar_rango_simplificado(p_minvalor text, p_maxvalor text, p_count bigint) OWNER TO tedede_owner;

--
-- Name: nsnc(integer); Type: FUNCTION; Schema: comun; Owner: tedede_php
--

CREATE FUNCTION nsnc(valor integer) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
  IF valor = -9 THEN
     RETURN true;
  END IF;
RETURN false;
END;
$$;


ALTER FUNCTION comun.nsnc(valor integer) OWNER TO tedede_php;

--
-- Name: nsnc(text); Type: FUNCTION; Schema: comun; Owner: tedede_php
--

CREATE FUNCTION nsnc(valor text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
  IF valor = '//' THEN
     RETURN true;
  END IF;
RETURN false;
END;
$$;


ALTER FUNCTION comun.nsnc(valor text) OWNER TO tedede_php;

--
-- Name: nulo_a_neutro(integer); Type: FUNCTION; Schema: comun; Owner: tedede_owner
--

CREATE FUNCTION nulo_a_neutro(integer) RETURNS integer
    LANGUAGE sql IMMUTABLE
    AS $_$
  select coalesce($1,0);
$_$;


ALTER FUNCTION comun.nulo_a_neutro(integer) OWNER TO tedede_owner;

--
-- Name: nulo_a_neutro(text); Type: FUNCTION; Schema: comun; Owner: tedede_owner
--

CREATE FUNCTION nulo_a_neutro(text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $_$
  select coalesce($1,'');
$_$;


ALTER FUNCTION comun.nulo_a_neutro(text) OWNER TO tedede_owner;

--
-- Name: para_ordenar_numeros(text); Type: FUNCTION; Schema: comun; Owner: tedede_owner
--

CREATE FUNCTION para_ordenar_numeros(texto_con_numeros text) RETURNS text
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


ALTER FUNCTION comun.para_ordenar_numeros(texto_con_numeros text) OWNER TO tedede_owner;

--
-- Name: probar(text); Type: FUNCTION; Schema: comun; Owner: tedede_owner
--

CREATE FUNCTION probar(p_sentencia text) RETURNS text
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


ALTER FUNCTION comun.probar(p_sentencia text) OWNER TO tedede_owner;

--
-- Name: rango(integer, integer, integer); Type: FUNCTION; Schema: comun; Owner: tedede_php
--

CREATE FUNCTION rango("P_valor" integer, "P_minimo" integer, "P_maximo" integer) RETURNS integer
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT CASE WHEN ($1>=$2 and $1<=$3) THEN $1 ELSE 0 END$_$;


ALTER FUNCTION comun.rango("P_valor" integer, "P_minimo" integer, "P_maximo" integer) OWNER TO tedede_php;

--
-- Name: reemplazar_variables(text, text); Type: FUNCTION; Schema: comun; Owner: postgres
--

CREATE FUNCTION reemplazar_variables(p_expresion text, p_reemplazante text) RETURNS text
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


ALTER FUNCTION comun.reemplazar_variables(p_expresion text, p_reemplazante text) OWNER TO postgres;

--
-- Name: valor_fecha(text); Type: FUNCTION; Schema: comun; Owner: tedede_owner
--

CREATE FUNCTION valor_fecha(p_valor text) RETURNS timestamp without time zone
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


ALTER FUNCTION comun.valor_fecha(p_valor text) OWNER TO tedede_owner;

SET search_path = dbo, pg_catalog;

--
-- Name: anio(); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE FUNCTION anio() RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $$
begin
	return 2013;
end;
$$;


ALTER FUNCTION dbo.anio() OWNER TO tedede_php;

--
-- Name: anionac(integer, integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE FUNCTION anionac(p_enc integer, p_hog integer, p_mie integer) RETURNS integer
    LANGUAGE plpgsql STABLE
    AS $$
declare v_annio integer;
begin
	v_annio := 0;
	select extract(year from to_date(res_valor, 'DD/MM/YYYY')) from 
	encu.respuestas where res_ope=dbo.ope_actual() and res_for='S1' and res_mat='P' and res_enc = p_enc and res_hog = p_hog and res_mie = p_mie and res_var='f_nac_o' into v_annio;
	return v_annio;
EXCEPTION
  WHEN invalid_datetime_format THEN
    return 0;
end;
$$;


ALTER FUNCTION dbo.anionac(p_enc integer, p_hog integer, p_mie integer) OWNER TO tedede_php;

--
-- Name: cadena_normalizar(text); Type: FUNCTION; Schema: dbo; Owner: tedede_owner
--

CREATE FUNCTION cadena_normalizar(p_cadena text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $_$

/*
-- Pruebas:
select entrada, esperado, dbo.cadena_normalizar(entrada)
    , esperado is distinct from dbo.cadena_normalizar(entrada)
  from (
  select 'hola' as entrada, 'HOLA' as esperado
  union select 'Cañuelas', 'CAÑUELAS'
  union select 'ÁCÉNTÍTÓSÚCü','ACENTITOSUCU'
  union select 'CON.SIGNOS/DE-PUNTUACION    Y MUCHOS ESPACIOS','CON SIGNOS DE-PUNTUACION Y MUCHOS ESPACIOS'
  union select 'CONÁÀÃÄÂáàãäâ   A', 'CONAAAAAAAAAA A'
  union select 'vocalesÁÒöÈÉüÙAeùúÍî?j', 'VOCALESAOOEEUUAEUUII J'
  union select 'ÅåÕõ.e', 'AAOO E'
) casos
  where esperado is distinct from dbo.cadena_normalizar(entrada);
*/
  select upper(trim(regexp_replace(translate ($1, 'ÁÀÃÄÂÅÉÈËÊÍÌÏÎÓÒÖÔÕÚÙÜÛáàãäâåéèëêíìïîóòöôõúùüûçÇ¿¡!:;,?¿"./,()_^[]*$', 'AAAAAAEEEEIIIIOOOOOUUUUaaaaaaeeeeiiiiooooouuuu                      '), ' {2,}',' ','g')));
$_$;


ALTER FUNCTION dbo.cadena_normalizar(p_cadena text) OWNER TO tedede_owner;

--
-- Name: cant_hog_norea_con_motivo(integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE FUNCTION cant_hog_norea_con_motivo(p_enc integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
 v_cantidad integer;
BEGIN 
  select count(*) into v_cantidad 
    from encu.plana_s1_
    where pla_enc=p_enc and pla_entrea=2 and pla_razon1 is not null;
  return v_cantidad;
END;
$$;


ALTER FUNCTION dbo.cant_hog_norea_con_motivo(p_enc integer) OWNER TO tedede_php;

--
-- Name: cant_hog_rea(integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE FUNCTION cant_hog_rea(p_enc integer) RETURNS bigint
    LANGUAGE sql IMMUTABLE
    AS $_$
  select count(pla_hog)
    from encu.plana_s1_ 
    where pla_enc = $1
      and pla_entrea=1;
$_$;


ALTER FUNCTION dbo.cant_hog_rea(p_enc integer) OWNER TO tedede_php;

--
-- Name: cant_hog_tot_sin95(integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE FUNCTION cant_hog_tot_sin95(p_enc integer) RETURNS bigint
    LANGUAGE sql IMMUTABLE
    AS $_$
  select count(res_hog)
	from encu.respuestas where res_ope = dbo.ope_actual() 
		and res_for = 'S1' 
		and res_enc = $1
		and res_var = 'entrea' 
		and res_valor <> '95';
$_$;


ALTER FUNCTION dbo.cant_hog_tot_sin95(p_enc integer) OWNER TO tedede_php;

--
-- Name: cant_i1_x_enc(integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE FUNCTION cant_i1_x_enc(p_enc integer) RETURNS bigint
    LANGUAGE sql IMMUTABLE
    AS $_$
  select count(cla_mie)
  from encu.claves where cla_ope=dbo.ope_actual() 
	and cla_for='I1' 
	and cla_enc=$1;
$_$;


ALTER FUNCTION dbo.cant_i1_x_enc(p_enc integer) OWNER TO tedede_php;

--
-- Name: cant_i1_x_hog(integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE FUNCTION cant_i1_x_hog(p_enc integer, p_hog integer) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
 v_cantidad integer;
BEGIN 
  select count(*) into v_cantidad 
  from encu.plana_i1_ where pla_enc=p_enc and pla_hog=p_hog;
  return v_cantidad;
END;
$$;


ALTER FUNCTION dbo.cant_i1_x_hog(p_enc integer, p_hog integer) OWNER TO tedede_php;

--
-- Name: cant_menores(integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE FUNCTION cant_menores(p_enc integer, p_hog integer) RETURNS integer
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE v_cant_menores integer;
BEGIN
    select count(*) into v_cant_menores from encu.respuestas
    inner join encu.variables on var_var=res_var and var_ope=res_ope and res_for=var_for and res_mat=var_mat
    where res_ope=dbo.ope_actual()
    and res_enc=p_enc
    and res_hog=p_hog
    and res_exm=0
    and res_var='edad'
    and res_valor::integer<18;
    
    return v_cant_menores;
END;
$$;


ALTER FUNCTION dbo.cant_menores(p_enc integer, p_hog integer) OWNER TO tedede_php;

--
-- Name: cant_menores(integer, integer, integer); Type: FUNCTION; Schema: dbo; Owner: postgres
--

CREATE FUNCTION cant_menores(p_enc integer, p_hog integer, p_edad integer) RETURNS integer
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE v_cant_menores integer;
BEGIN
    select count(*) into v_cant_menores from encu.respuestas
    inner join encu.variables on var_var=res_var and var_ope=res_ope and res_for=var_for and res_mat=var_mat
    where res_ope=dbo.ope_actual()
    and res_enc=p_enc
    and res_hog=p_hog
    and res_exm=0
    and res_var='edad'
    and res_valor::integer<p_edad;
    
    return v_cant_menores;
END;
$$;


ALTER FUNCTION dbo.cant_menores(p_enc integer, p_hog integer, p_edad integer) OWNER TO postgres;

--
-- Name: cant_registros_exm(integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE FUNCTION cant_registros_exm(p_enc integer, p_hog integer) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
 v_cantidad integer;
BEGIN 

	SELECT count(distinct res_exm) INTO v_cantidad 
	FROM encu.respuestas 
	WHERE res_ope=dbo.ope_actual() and res_for='A1'  and res_mat='X' and res_enc=p_enc and res_hog=p_hog and res_valor is not null;  
    
	return v_cantidad;
END;
$$;


ALTER FUNCTION dbo.cant_registros_exm(p_enc integer, p_hog integer) OWNER TO tedede_php;

--
-- Name: cant_s1p_x_hog(integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE FUNCTION cant_s1p_x_hog(p_enc integer, p_hog integer) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
 v_cantidad integer;
BEGIN 
  select count(*) into v_cantidad 
  from encu.plana_s1_p where pla_enc=p_enc and pla_hog=p_hog;
  return v_cantidad;
END;
$$;


ALTER FUNCTION dbo.cant_s1p_x_hog(p_enc integer, p_hog integer) OWNER TO tedede_php;

--
-- Name: cantex(integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE FUNCTION cantex(p_enc integer, p_hog integer) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
 v_cantidad integer;
BEGIN 
  select count(cla_exm) into v_cantidad 
  from encu.claves where cla_ope=dbo.ope_actual() and cla_for='A1'  and cla_mat='X' and cla_enc=p_enc  and cla_hog=p_hog;
  return v_cantidad;
END;
$$;


ALTER FUNCTION dbo.cantex(p_enc integer, p_hog integer) OWNER TO tedede_php;

--
-- Name: dic_parte(text, text, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_owner
--

CREATE FUNCTION dic_parte(p_dic text, p_origen text, p_destino integer) RETURNS boolean
    LANGUAGE sql
    AS $$
  select p_origen ~ 
    ('(\m' || coalesce((select string_agg(dictra_ori, '\M|\m') 
      from encu.dictra
      where dictra_dic=p_dic and dictra_des=p_destino),'')|| '\M)' )
$$;


ALTER FUNCTION dbo.dic_parte(p_dic text, p_origen text, p_destino integer) OWNER TO tedede_owner;

--
-- Name: dic_tradu(text, text); Type: FUNCTION; Schema: dbo; Owner: tedede_owner
--

CREATE FUNCTION dic_tradu(p_dic text, p_origen text) RETURNS integer
    LANGUAGE sql
    AS $$
  select dictra_des from encu.dictra where dictra_dic=p_dic and dictra_ori=dbo.cadena_normalizar(p_origen)
$$;


ALTER FUNCTION dbo.dic_tradu(p_dic text, p_origen text) OWNER TO tedede_owner;

--
-- Name: dma_a_fecha(integer, integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE FUNCTION dma_a_fecha(p_dia integer, p_mes integer, p_annio integer) RETURNS date
    LANGUAGE plpgsql IMMUTABLE
    AS $$
begin 
 return to_date(p_annio||'/'||p_mes||'/'||p_dia,'YYYY/MM/DD');
end;
$$;


ALTER FUNCTION dbo.dma_a_fecha(p_dia integer, p_mes integer, p_annio integer) OWNER TO tedede_php;

--
-- Name: edad_a_la_fecha(text, text); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE FUNCTION edad_a_la_fecha(p_f_nac text, p_f_realiz text) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE v_edad integer;
BEGIN
  if dbo.texto_a_fecha(p_f_nac) > dbo.texto_a_fecha(p_f_realiz) then 
    return null;
  end if;
  v_edad=extract(year from age(dbo.texto_a_fecha(p_f_realiz),dbo.texto_a_fecha(p_f_nac)));
  if v_edad>130 or v_edad<0 then
    return null;
  end if;
  return v_edad;
EXCEPTION
  WHEN invalid_datetime_format THEN
    return null;
  WHEN datetime_field_overflow THEN
    return null;
END;
$$;


ALTER FUNCTION dbo.edad_a_la_fecha(p_f_nac text, p_f_realiz text) OWNER TO tedede_php;

--
-- Name: edad_participacion_anterior(integer, integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE FUNCTION edad_participacion_anterior(enc integer, hogar integer, miembro integer) RETURNS integer
    LANGUAGE sql STABLE
    AS $_$
	select res_valor::integer from encu.respuestas 
	where res_ope = 'eah'||(dbo.anio()-1)::text
	and res_for = 'S1' 
	and res_mat = 'P'
	and res_enc = $1 
	and res_hog = $2 
	and res_mie = $3 
	and res_var = 'edad';
$_$;


ALTER FUNCTION dbo.edad_participacion_anterior(enc integer, hogar integer, miembro integer) OWNER TO tedede_php;

--
-- Name: edadfamiliar(integer, integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE FUNCTION edadfamiliar(p_enc integer, p_hog integer, p_mie integer) RETURNS integer
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE v_edad integer;
BEGIN
	v_edad := 0;
	select res_valor from encu.respuestas 
	where res_ope=dbo.ope_actual() and res_for='S1' and res_mat='P' and res_enc = p_enc and res_hog = p_hog and res_mie = p_mie and res_var='edad' into v_edad;
	return v_edad;	
END;
$$;


ALTER FUNCTION dbo.edadfamiliar(p_enc integer, p_hog integer, p_mie integer) OWNER TO tedede_php;

--
-- Name: edadjefe(integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE FUNCTION edadjefe(p_enc integer, p_nhogar integer) RETURNS integer
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE 
  v_edad_jefe integer;
BEGIN
  select pla_edad
    into v_edad_jefe 
    from encu.plana_s1_p 
    where pla_enc = p_enc and pla_hog = p_nhogar and pla_p4=1;
  return v_edad_jefe;	
END;
$$;


ALTER FUNCTION dbo.edadjefe(p_enc integer, p_nhogar integer) OWNER TO tedede_php;

--
-- Name: es_fecha(text); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE FUNCTION es_fecha(valor text) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE v_fecha date;
DECLARE bisiesto boolean;
DECLARE v_fechas_array integer[];
DECLARE v_anio_extraido integer;
DECLARE v_mes_extraido integer;
DECLARE v_dia_extraido integer;
DECLARE v_anio_actual integer;
DECLARE dias_mes integer[12]:= array[31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
BEGIN
  if valor is null then
    return 0;
  end if;  
  v_fecha:=to_date(valor,'DD/MM/YYYY');
  v_anio_actual :=  dbo.anio();
  v_fechas_array := regexp_split_to_array(valor,'/');  
  v_anio_extraido := v_fechas_array[3];
  v_mes_extraido := v_fechas_array[2];
  v_dia_extraido := v_fechas_array[1];
  if v_anio_extraido is null then
    v_anio_extraido := v_anio_actual;
  end if;  
  if v_anio_extraido%4=0 then
	if v_anio_extraido%100=0 then
		if v_anio_extraido%400=0 then
			bisiesto = true;
		else
			bisiesto = false;
		end if;
	else
		bisiesto = true;
	end if;
  else
	bisiesto = false;
  end if;
  if v_anio_extraido is null or v_mes_extraido is null or v_dia_extraido is null then
	return 0;
  end if;
  if v_anio_extraido < 1890 or v_anio_extraido > v_anio_actual then
	return 0;
  end if;
  if v_mes_extraido <= 0 or v_mes_extraido > 12 or v_dia_extraido <=0 then
	return 0;
  end if;
  if v_mes_extraido <> 2 or bisiesto = false then
	if v_dia_extraido>dias_mes[v_mes_extraido] then
		return 0;
	end if;
  else
	if v_dia_extraido>dias_mes[2]+1 then
		return 0;
	end if;
  end if;
  return 1;  
EXCEPTION
  WHEN invalid_text_representation THEN
    return 0;
  WHEN invalid_datetime_format THEN
    return 0;
  WHEN datetime_field_overflow THEN
    return 0;     
END;
$$;


ALTER FUNCTION dbo.es_fecha(valor text) OWNER TO tedede_php;

--
-- Name: estadofamiliar(integer, integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE FUNCTION estadofamiliar(p_enc integer, p_hog integer, p_mie integer) RETURNS integer
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE v_estado integer;
BEGIN
	v_estado := 0;
	select res_valor from encu.respuestas
	where res_ope=dbo.ope_actual() and res_for='S1' and res_mat='P' and res_enc = p_enc and res_hog = p_hog and res_mie = p_mie and res_var = 'p5' into v_estado;
	return v_estado;
END;
$$;


ALTER FUNCTION dbo.estadofamiliar(p_enc integer, p_hog integer, p_mie integer) OWNER TO tedede_php;

--
-- Name: estadojefe(integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE FUNCTION estadojefe(p_enc integer, p_hog integer) RETURNS integer
    LANGUAGE plpgsql STABLE
    AS $$
declare v_estadojefe text;
declare v_ope text;
begin
    v_ope := dbo.ope_actual();
    select res_valor into v_estadojefe from encu.respuestas 
    where res_ope=v_ope and res_for='S1' and res_mat='P' and res_enc = p_enc and res_hog = p_hog and res_var = 'p5' and res_mie in 
    (select res_mie from encu.respuestas where res_ope=v_ope and res_enc=p_enc and res_hog=p_hog and res_var ='p4' and (res_valor ='1') limit 1);
    return v_estadojefe;
    
end;
$$;


ALTER FUNCTION dbo.estadojefe(p_enc integer, p_hog integer) OWNER TO tedede_php;

--
-- Name: existe_a1(integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE FUNCTION existe_a1(enc integer, hog integer) RETURNS bigint
    LANGUAGE sql IMMUTABLE
    AS $_$
  select count(cla_enc)
  from encu.claves where cla_ope=dbo.ope_actual() 
	and cla_for='A1'
	and cla_mat=''
	and cla_enc=$1
	and cla_hog=$2
	limit 1;
$_$;


ALTER FUNCTION dbo.existe_a1(enc integer, hog integer) OWNER TO tedede_php;

--
-- Name: existe_hogar(integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE FUNCTION existe_hogar(p_enc integer, p_hog integer) RETURNS integer
    LANGUAGE sql STABLE
    AS $$
SELECT 1 from encu.plana_s1_ where pla_enc = p_enc and pla_hog = p_hog;
$$;


ALTER FUNCTION dbo.existe_hogar(p_enc integer, p_hog integer) OWNER TO tedede_php;

--
-- Name: existe_s1(integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE FUNCTION existe_s1(enc integer) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $_$
DECLARE v_valor integer;
BEGIN
  select coalesce(count(cla_enc),0) into v_valor
  from encu.claves where cla_ope=dbo.ope_actual() 
	and cla_for='S1'
	and cla_mat=''
	and cla_enc=$1
	limit 1;
  return v_valor;
END;		
$_$;


ALTER FUNCTION dbo.existe_s1(enc integer) OWNER TO tedede_php;

--
-- Name: existeindividual(integer, integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE FUNCTION existeindividual(enc integer, hog integer, mie integer) RETURNS bigint
    LANGUAGE sql STABLE
    AS $_$
  	select count(distinct(pla_mie)) from encu.plana_i1_ 
		where pla_enc = $1 
		and pla_hog = $2 
		and pla_mie = $3;
$_$;


ALTER FUNCTION dbo.existeindividual(enc integer, hog integer, mie integer) OWNER TO tedede_php;

--
-- Name: existejefe(integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE FUNCTION existejefe(p_enc integer, p_hog integer) RETURNS integer
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE v_cantjefes integer;
BEGIN
    v_cantjefes := count(*) from encu.respuestas where res_ope=dbo.ope_actual() and res_for='S1' and res_mat='P' and res_enc = p_enc and res_hog = p_hog and res_var = 'p4' and res_valor ='1';
    if (v_cantjefes > 1) then
	v_cantjefes := 2;
    end if;
    return v_cantjefes;
END;
$$;


ALTER FUNCTION dbo.existejefe(p_enc integer, p_hog integer) OWNER TO tedede_php;

--
-- Name: existemiembro(integer, integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE FUNCTION existemiembro(p_enc integer, p_hog integer, p_mie integer) RETURNS integer
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE v_existe integer;
BEGIN
    v_existe := count(distinct (res_mie)) from encu.respuestas where res_ope=dbo.ope_actual() and res_for='S1' and res_mat='P' and res_enc = p_enc and res_hog = p_hog and res_mie = p_mie;
    return v_existe;
END;
$$;


ALTER FUNCTION dbo.existemiembro(p_enc integer, p_hog integer, p_mie integer) OWNER TO tedede_php;

--
-- Name: fecha_30junio(); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE FUNCTION fecha_30junio() RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
begin
	return '30/06/'||dbo.anio()::text;
end;
$$;


ALTER FUNCTION dbo.fecha_30junio() OWNER TO tedede_php;

--
-- Name: form_familiar(); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE FUNCTION form_familiar() RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
begin
	return 'S1';
end;
$$;


ALTER FUNCTION dbo.form_familiar() OWNER TO tedede_php;

--
-- Name: max_hog_ingresado(integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE FUNCTION max_hog_ingresado(p_enc integer) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
 v_cantidad integer;
BEGIN 
  select max(pla_hog) into v_cantidad 
  from encu.plana_s1_ where pla_enc=p_enc;
  return v_cantidad;
END;
$$;


ALTER FUNCTION dbo.max_hog_ingresado(p_enc integer) OWNER TO tedede_php;

--
-- Name: mediana_expandida(text, text); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE FUNCTION mediana_expandida(p_variable text, p_filtro text) RETURNS numeric
    LANGUAGE plpgsql
    AS $$ 
DECLARE
  v_variable text;
  v_resultado decimal;
  v_comando text;
BEGIN
  v_variable:='pla_'||p_variable;
  v_comando:= '
    SELECT round(AVG('||v_variable||')::numeric,1) from
        (select '||v_variable||', generate_series(1,pla_fexp) from plana_s1_p s1_p 
        inner join plana_i1_ i1 on s1_p.pla_enc=i1.pla_enc and s1_p.pla_hog=i1.pla_hog and s1_p.pla_mie=i1.pla_mie 
        inner join plana_s1_ s1 on s1.pla_enc=i1.pla_enc and s1.pla_hog=i1.pla_hog and s1.pla_mie=0 
        inner join plana_tem_ t on t.pla_enc=i1.pla_enc and t.pla_hog=0 and s1.pla_mie=0
        where '||v_variable||' is not null and '||p_filtro||' 
        order by 1
        LIMIT  2 - MOD((select sum(pla_fexp)  from encu.plana_i1_ i1 
        inner join plana_s1_p s1_p on s1_p.pla_enc=i1.pla_enc and s1_p.pla_hog=i1.pla_hog and s1_p.pla_mie=i1.pla_mie 
        inner join plana_s1_ s1 on s1.pla_enc=i1.pla_enc and s1.pla_hog=i1.pla_hog and s1.pla_mie=0 
        inner join plana_tem_ t on t.pla_enc=i1.pla_enc and t.pla_hog=0 and s1.pla_mie=0
        where '||v_variable||' is not null and '||p_filtro||'), 2)        
        OFFSET GREATEST(CEIL((select sum(pla_fexp)  from encu.plana_i1_ i1 
        inner join plana_s1_p s1_p on s1_p.pla_enc=i1.pla_enc and s1_p.pla_hog=i1.pla_hog and s1_p.pla_mie=i1.pla_mie 
        inner join plana_s1_ s1 on s1.pla_enc=i1.pla_enc and s1.pla_hog=i1.pla_hog and s1.pla_mie=0 
        inner join plana_tem_ t on t.pla_enc=i1.pla_enc and t.pla_hog=0 and s1.pla_mie=0
        where '||v_variable||' is not null and '||p_filtro||') / 2.0) - 1,0) ) x';
    execute v_comando into v_resultado;
    return v_resultado;
END;
$$;


ALTER FUNCTION dbo.mediana_expandida(p_variable text, p_filtro text) OWNER TO tedede_php;

--
-- Name: mediana_expandida_agrupada(text, text, text, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE FUNCTION mediana_expandida_agrupada(p_variable text, p_filtro text, p_groupby text, p_valor integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $$ 
DECLARE
  v_resultado decimal;
  v_variable text;
  v_comando text;
  v_groupby text;
BEGIN
  v_variable:='pla_'||p_variable;
  v_groupby:='pla_'||p_groupby;
  v_comando:= '
    SELECT round(AVG('||v_variable||')::numeric,1) from
        (select '||v_variable||', generate_series(1,pla_fexp) from plana_s1_p s1_p 
        inner join plana_i1_ i1 on s1_p.pla_enc=i1.pla_enc and s1_p.pla_hog=i1.pla_hog and s1_p.pla_mie=i1.pla_mie 
        inner join plana_s1_ s1 on s1.pla_enc=i1.pla_enc and s1.pla_hog=i1.pla_hog and s1.pla_mie=0 
        inner join plana_tem_ t on t.pla_enc=i1.pla_enc and t.pla_hog=0 and s1.pla_mie=0
        where '||v_variable||' is not null and '||p_filtro|| ' and '||v_groupby||' = '||p_valor|| ' 
        order by '||v_variable||'
        LIMIT  2 - MOD((select sum(pla_fexp)  from encu.plana_i1_ i1 
        inner join plana_s1_p s1_p on s1_p.pla_enc=i1.pla_enc and s1_p.pla_hog=i1.pla_hog and s1_p.pla_mie=i1.pla_mie 
        inner join plana_s1_ s1 on s1.pla_enc=i1.pla_enc and s1.pla_hog=i1.pla_hog and s1.pla_mie=0 
        inner join plana_tem_ t on t.pla_enc=i1.pla_enc and t.pla_hog=0 and s1.pla_mie=0
        where '||p_filtro|| ' and '||v_groupby||' = '||p_valor||'), 2)
        OFFSET GREATEST(CEIL((select sum(pla_fexp)  from encu.plana_i1_ i1 
        inner join plana_s1_p s1_p on s1_p.pla_enc=i1.pla_enc and s1_p.pla_hog=i1.pla_hog and s1_p.pla_mie=i1.pla_mie 
        inner join plana_s1_ s1 on s1.pla_enc=i1.pla_enc and s1.pla_hog=i1.pla_hog and s1.pla_mie=0 
        inner join plana_tem_ t on t.pla_enc=i1.pla_enc and t.pla_hog=0 and s1.pla_mie=0 
        where '||p_filtro|| ' and '||v_groupby||' = '||p_valor||') / 2.0) - 1,0) ) x';    
    execute v_comando into v_resultado;
    return v_resultado;
END;
$$;


ALTER FUNCTION dbo.mediana_expandida_agrupada(p_variable text, p_filtro text, p_groupby text, p_valor integer) OWNER TO tedede_php;

--
-- Name: nroconyuges(integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE FUNCTION nroconyuges(p_enc integer, p_hog integer) RETURNS integer
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE v_nroconyuges integer;
BEGIN
    v_nroconyuges := count(*) from encu.respuestas where res_ope=dbo.ope_actual() and res_for='S1' and res_mat='P' and res_enc=p_enc and res_hog=p_hog and res_var='p4' and (res_valor='2');
    return v_nroconyuges;
END;
$$;


ALTER FUNCTION dbo.nroconyuges(p_enc integer, p_hog integer) OWNER TO tedede_php;

--
-- Name: nrojefes(integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE FUNCTION nrojefes(p_enc integer, p_hog integer) RETURNS integer
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE v_cantjefes integer;
BEGIN
    v_cantjefes := count(*) from encu.respuestas where res_ope=dbo.ope_actual() and res_for='S1' and res_mat='P' and res_enc = p_enc and res_hog = p_hog and res_var = 'p4' and res_valor ='1';
    return v_cantjefes;
END;
$$;


ALTER FUNCTION dbo.nrojefes(p_enc integer, p_hog integer) OWNER TO tedede_php;

--
-- Name: ope_actual(); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE FUNCTION ope_actual() RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
begin
	return 'eah2013';
end;
$$;


ALTER FUNCTION dbo.ope_actual() OWNER TO tedede_php;

--
-- Name: p5bfamiliar(integer, integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE FUNCTION p5bfamiliar(p_enc integer, p_hog integer, p_mie integer) RETURNS integer
    LANGUAGE plpgsql STABLE
    AS $$
declare 
  v_p5b integer;
begin
  select res_valor
    into v_p5b 
    from encu.respuestas where res_ope=dbo.ope_actual() and res_for='S1' and res_mat='P' and res_enc = p_enc and res_hog = p_hog and res_mie=p_mie and res_var = 'p5b';
  return v_p5b;
end;
$$;


ALTER FUNCTION dbo.p5bfamiliar(p_enc integer, p_hog integer, p_mie integer) OWNER TO tedede_php;

--
-- Name: p7_min(integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE FUNCTION p7_min(p_enc integer, p_hog integer) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE v_valor integer;
BEGIN
  v_valor := 0;
  select coalesce(min(res_valor::integer),0) into v_valor
	from encu.respuestas where res_ope = dbo.ope_actual() 
		and res_for = 'S1' 
		and res_mat = 'P'
		and res_enc = p_enc
		and res_hog = p_hog
		and res_var = 'p7';
  return v_valor;
END;		
$$;


ALTER FUNCTION dbo.p7_min(p_enc integer, p_hog integer) OWNER TO tedede_php;

--
-- Name: sexo_participacion_anterior(integer, integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE FUNCTION sexo_participacion_anterior(enc integer, hogar integer, miembro integer) RETURNS integer
    LANGUAGE sql STABLE
    AS $_$
	select res_valor::integer from encu.respuestas 
	where res_ope = 'eah'||(dbo.anio()-1)::text
	and res_for = 'S1'
	and res_mat = 'P'
	and res_enc = $1 
	and res_hog = $2 
	and res_mie = $3 
	and res_var = 'sexo';
$_$;


ALTER FUNCTION dbo.sexo_participacion_anterior(enc integer, hogar integer, miembro integer) OWNER TO tedede_php;

--
-- Name: sexofamiliar(integer, integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE FUNCTION sexofamiliar(p_enc integer, p_hog integer, p_mie integer) RETURNS integer
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE v_sexo integer;
BEGIN
    select res_valor::integer into v_sexo from encu.respuestas where res_ope=dbo.ope_actual() and res_for='S1' and res_mat='P' and res_enc = p_enc and res_hog = p_hog and res_mie=p_mie and res_var = 'sexo';
    if v_sexo in(1,2) then
	return v_sexo;
    else
	return 0;
    end if;	
END;
$$;


ALTER FUNCTION dbo.sexofamiliar(p_enc integer, p_hog integer, p_mie integer) OWNER TO tedede_php;

--
-- Name: sexojefe(integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE FUNCTION sexojefe(p_enc integer, p_hog integer) RETURNS integer
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE v_sexojefe integer;
BEGIN
    select res_valor::integer into v_sexojefe from encu.respuestas where res_ope=dbo.ope_actual() and res_for='S1' and res_mat='P' and res_enc = p_enc and res_hog = p_hog and res_var = 'sexo' and res_mie in (select res_mie from encu.respuestas where res_ope=dbo.ope_actual() and res_for='S1' and res_mat='P' and res_enc = p_enc and res_hog = p_hog and res_var = 'p4' and (res_valor ='1' ) limit 1);
    return v_sexojefe;
END;
$$;


ALTER FUNCTION dbo.sexojefe(p_enc integer, p_hog integer) OWNER TO tedede_php;

--
-- Name: suma_md(integer, integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE FUNCTION suma_md(p_enc integer, p_hog integer, p_mie integer) RETURNS integer
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
	v_md integer;
BEGIN
   select sum(res_valor::integer) into v_md from encu.respuestas 
   where res_ope=dbo.ope_actual() and res_for='I1' and res_mat='' and res_enc = p_enc and res_hog = p_hog and res_mie = p_mie and res_var IN ('md1', 'md2', 'md3', 'md4', 'md5', 'md6', 'md7', 'md8', 'md9', 'md10', 'md11');
return v_md;
END;
$$;


ALTER FUNCTION dbo.suma_md(p_enc integer, p_hog integer, p_mie integer) OWNER TO tedede_php;

--
-- Name: suma_t1at54b(integer, integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE FUNCTION suma_t1at54b(p_enc integer, p_hog integer, p_mie integer) RETURNS integer
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE v_res integer;
BEGIN
  select sum(dbo.textoinformado(res_valor)) into v_res from encu.respuestas
   where res_ope=dbo.ope_actual() and res_for='I1' and res_mat='' and res_enc = p_enc and res_hog = p_hog and res_mie = p_mie and res_var IN ('t54b','t54','t53c_meses','t53c_anios','t53c_98','t53_ing','t53_bis2','t53_bis1_sem','t53_bis1_mes','t53_bis1','t52c','t52b','t52a','t51','t50f','t50e','t50d','t50c','t50b','t50a',
't49','t48b_esp','t48b','t48a','t48','t47','t46','t45','t44','t43','t42','t41','t40','t39_otro','t39_bis_cuantos','t39_bis2_esp','t39_bis2',
't39_bis','t39_barrio','t39','t38','t37sd','t37','t36_a','t36_8_otro','t36_8','t36_7_otro','t36_7','t36_6','t36_5','t36_4','t36_3',
't36_2','t36_1','t35','t34','t33','t32_v','t32_s','t32_mi','t32_ma','t32_l','t32_j','t32_d','t31_v','t31_s','t31_mi','t31_ma',
't31_l','t31_j','t31_d','t30','t29a','t29','t28','t27','t26','t25','t24','t23','t22','t21','t20','t19_anio','t18','t17','t16',
't15','t14','t13','t12','t11_otro','t11','t10','t9','t8_otro','t8','t7','t6','t5','t4','t3','t2','t1');
return v_res;
END;
$$;


ALTER FUNCTION dbo.suma_t1at54b(p_enc integer, p_hog integer, p_mie integer) OWNER TO tedede_php;

--
-- Name: suma_t28a54b(integer, integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE FUNCTION suma_t28a54b(p_enc integer, p_hog integer, p_mie integer) RETURNS integer
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE v_res integer;
BEGIN
  select sum(dbo.textoinformado(res_valor)) into v_res from encu.respuestas
   where res_ope=dbo.ope_actual() and res_for='I1' and res_mat='' and res_enc = p_enc and res_hog = p_hog and res_mie = p_mie and res_var IN ('t54b','t54','t53c_meses','t53c_anios','t53c_98','t53_ing','t53_bis2','t53_bis1_sem','t53_bis1_mes','t53_bis1','t52c',
't52b','t52a','t51','t50f','t50e','t50d','t50c','t50b','t50a','t49','t48b_esp','t48b','t48a','t48','t47','t46','t45',
't44','t43','t42','t41','t40','t39_otro','t39_bis_cuantos','t39_bis2_esp','t39_bis2','t39_bis','t39_barrio','t39','t38',
't37sd','t37','t36_a','t36_8_otro','t36_8','t36_7_otro','t36_7','t36_6','t36_5','t36_4','t36_3','t36_2','t36_1','t35',
't34','t33','t32_v','t32_s','t32_mi','t32_ma','t32_l','t32_j','t32_d','t31_v','t31_s','t31_mi','t31_ma','t31_l','t31_j',
't31_d','t30','t29a','t29','t28');
return v_res;
END;
$$;


ALTER FUNCTION dbo.suma_t28a54b(p_enc integer, p_hog integer, p_mie integer) OWNER TO tedede_php;

--
-- Name: sumah3(integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE FUNCTION sumah3(p_enc integer) RETURNS integer
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE v_res integer;
BEGIN
select sum(pla_h3) into v_res from encu.plana_a1_ where pla_enc=p_enc and pla_h3>=0;
if v_res is null then 
	v_res=0;
end if;
return v_res;
END;

$$;


ALTER FUNCTION dbo.sumah3(p_enc integer) OWNER TO tedede_php;

--
-- Name: texto_a_fecha(text); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE FUNCTION texto_a_fecha(p_valor text) RETURNS date
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE v_fecha date;
DECLARE v_anio_extraido integer;
DECLARE v_mes_extraido integer;
DECLARE v_dia_extraido integer;
DECLARE v_anio_actual integer;
BEGIN
  if p_valor is null then
    return null;
  end if;
  v_anio_actual := dbo.anio();
  v_anio_extraido := extract(year from to_date(p_valor, 'DD/MM/YYYY'))::integer;
  v_mes_extraido := extract(month from to_date(p_valor, 'DD/MM/YYYY'))::integer;
  v_dia_extraido := extract(day from to_date(p_valor, 'DD/MM/YYYY'))::integer;
  if v_anio_extraido = -1 then
    v_fecha := to_date(p_valor || '/' || v_anio_actual, 'DD/MM/YYYY');
  else
    if v_anio_extraido < 100 and v_anio_extraido > 11 then 
      v_anio_extraido := v_anio_extraido + 1900;
      v_fecha := to_date(v_dia_extraido || '/' || v_mes_extraido || '/' || v_anio_extraido, 'DD/MM/YYYY');
    elsif v_anio_extraido < 12 then 
      v_anio_extraido := v_anio_extraido + 2000;
      v_fecha := to_date(v_dia_extraido || '/' || v_mes_extraido || '/' || v_anio_extraido, 'DD/MM/YYYY');
    elseif v_anio_extraido > 99 then
      v_fecha := to_date(p_valor, 'DD/MM/YYYY');
    end if;
  end if;
  return v_fecha;
EXCEPTION
  WHEN invalid_datetime_format THEN
    return null;
  WHEN datetime_field_overflow THEN
    return null; 
END;
$$;


ALTER FUNCTION dbo.texto_a_fecha(p_valor text) OWNER TO tedede_php;

--
-- Name: textoinformado(character varying); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE FUNCTION textoinformado(p_valor character varying) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
  if p_valor is null or length(trim(p_valor))=0 then
     return 0;
  else 
     return 1;
  end if;
END;
$$;


ALTER FUNCTION dbo.textoinformado(p_valor character varying) OWNER TO tedede_php;

--
-- Name: textoinformado(integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE FUNCTION textoinformado(p_valor integer) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
  if p_valor is null then
     return 0;
  else 
	if p_valor=0 then
		return 0;
	else
		return 1;
	end if;
  end if;END;
$$;


ALTER FUNCTION dbo.textoinformado(p_valor integer) OWNER TO tedede_php;

--
-- Name: textoinformado(text); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE FUNCTION textoinformado(p_valor text) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
  if p_valor is null or length(trim(p_valor))=0 then
     return 0;
  else 
     return 1;
  end if;
END;
$$;


ALTER FUNCTION dbo.textoinformado(p_valor text) OWNER TO tedede_php;

--
-- Name: total_hogares(integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE FUNCTION total_hogares(p_enc integer) RETURNS integer
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_cant integer;
BEGIN
    select count(distinct(cla_hog)) 
      into v_cant 
      from encu.claves 
      where cla_enc=p_enc 
        and cla_ope=dbo.ope_actual()
        and cla_for=dbo.form_familiar()
        and cla_mat=''
        and cla_mie=0;
    return v_cant;
END;
$$;


ALTER FUNCTION dbo.total_hogares(p_enc integer) OWNER TO tedede_php;

SET search_path = dbx, pg_catalog;

--
-- Name: @(contarc@coding@coding=-9 and p4 is distinct from 13)@(integer, integer); Type: FUNCTION; Schema: dbx; Owner: tedede_php
--

CREATE FUNCTION "@(contarc@coding@coding=-9 and p4 is distinct from 13)@"(p_enc integer, p_hog integer) RETURNS bigint
    LANGUAGE sql
    AS $$ SELECT COUNT(pla_coding) 
                        FROM plana_i1_ i1 INNER JOIN plana_s1_p s1p ON i1.pla_enc=s1p.pla_enc AND i1.pla_hog=s1p.pla_hog AND i1.pla_mie=s1p.pla_mie
                            INNER JOIN plana_s1_ s1 ON i1.pla_enc=s1.pla_enc AND i1.pla_hog=s1.pla_hog 
                            INNER JOIN plana_a1_ a1 ON i1.pla_enc=a1.pla_enc AND i1.pla_hog=a1.pla_hog 
                            INNER JOIN plana_tem_ t ON i1.pla_enc=t.pla_enc 
                        WHERE i1.pla_enc=p_enc and i1.pla_hog=p_hog and 
                            pla_coding=-9 and pla_p4 is distinct from 13 
                            /* @(contarc@coding@coding=-9 and p4 is distinct from 13)@  */
                        $$;


ALTER FUNCTION dbx."@(contarc@coding@coding=-9 and p4 is distinct from 13)@"(p_enc integer, p_hog integer) OWNER TO tedede_php;

--
-- Name: @(contarc@coding@coding=0 and p4 is distinct from 13)@(integer, integer); Type: FUNCTION; Schema: dbx; Owner: tedede_php
--

CREATE FUNCTION "@(contarc@coding@coding=0 and p4 is distinct from 13)@"(p_enc integer, p_hog integer) RETURNS bigint
    LANGUAGE sql
    AS $$ SELECT COUNT(pla_coding) 
                        FROM plana_i1_ i1 INNER JOIN plana_s1_p s1p ON i1.pla_enc=s1p.pla_enc AND i1.pla_hog=s1p.pla_hog AND i1.pla_mie=s1p.pla_mie
                            INNER JOIN plana_s1_ s1 ON i1.pla_enc=s1.pla_enc AND i1.pla_hog=s1.pla_hog 
                            INNER JOIN plana_a1_ a1 ON i1.pla_enc=a1.pla_enc AND i1.pla_hog=a1.pla_hog 
                            INNER JOIN plana_tem_ t ON i1.pla_enc=t.pla_enc 
                        WHERE i1.pla_enc=p_enc and i1.pla_hog=p_hog and 
                            pla_coding=0 and pla_p4 is distinct from 13 
                            /* @(contarc@coding@coding=0 and p4 is distinct from 13)@  */
                        $$;


ALTER FUNCTION dbx."@(contarc@coding@coding=0 and p4 is distinct from 13)@"(p_enc integer, p_hog integer) OWNER TO tedede_php;

--
-- Name: @(contarc@coding@coding=1 and p4 is distinct from 13)@(integer, integer); Type: FUNCTION; Schema: dbx; Owner: tedede_php
--

CREATE FUNCTION "@(contarc@coding@coding=1 and p4 is distinct from 13)@"(p_enc integer, p_hog integer) RETURNS bigint
    LANGUAGE sql
    AS $$ SELECT COUNT(pla_coding) 
                        FROM plana_i1_ i1 INNER JOIN plana_s1_p s1p ON i1.pla_enc=s1p.pla_enc AND i1.pla_hog=s1p.pla_hog AND i1.pla_mie=s1p.pla_mie
                            INNER JOIN plana_s1_ s1 ON i1.pla_enc=s1.pla_enc AND i1.pla_hog=s1.pla_hog 
                            INNER JOIN plana_a1_ a1 ON i1.pla_enc=a1.pla_enc AND i1.pla_hog=a1.pla_hog 
                            INNER JOIN plana_tem_ t ON i1.pla_enc=t.pla_enc 
                        WHERE i1.pla_enc=p_enc and i1.pla_hog=p_hog and 
                            pla_coding=1 and pla_p4 is distinct from 13 
                            /* @(contarc@coding@coding=1 and p4 is distinct from 13)@  */
                        $$;


ALTER FUNCTION dbx."@(contarc@coding@coding=1 and p4 is distinct from 13)@"(p_enc integer, p_hog integer) OWNER TO tedede_php;

--
-- Name: @(contarc@coding@coding=2 and p4 is distinct from 13)@(integer, integer); Type: FUNCTION; Schema: dbx; Owner: tedede_php
--

CREATE FUNCTION "@(contarc@coding@coding=2 and p4 is distinct from 13)@"(p_enc integer, p_hog integer) RETURNS bigint
    LANGUAGE sql
    AS $$ SELECT COUNT(pla_coding) 
                        FROM plana_i1_ i1 INNER JOIN plana_s1_p s1p ON i1.pla_enc=s1p.pla_enc AND i1.pla_hog=s1p.pla_hog AND i1.pla_mie=s1p.pla_mie
                            INNER JOIN plana_s1_ s1 ON i1.pla_enc=s1.pla_enc AND i1.pla_hog=s1.pla_hog 
                            INNER JOIN plana_a1_ a1 ON i1.pla_enc=a1.pla_enc AND i1.pla_hog=a1.pla_hog 
                            INNER JOIN plana_tem_ t ON i1.pla_enc=t.pla_enc 
                        WHERE i1.pla_enc=p_enc and i1.pla_hog=p_hog and 
                            pla_coding=2 and pla_p4 is distinct from 13 
                            /* @(contarc@coding@coding=2 and p4 is distinct from 13)@  */
                        $$;


ALTER FUNCTION dbx."@(contarc@coding@coding=2 and p4 is distinct from 13)@"(p_enc integer, p_hog integer) OWNER TO tedede_php;

--
-- Name: @(contarc@coding@coding=9 and p4 is distinct from 13)@(integer, integer); Type: FUNCTION; Schema: dbx; Owner: tedede_php
--

CREATE FUNCTION "@(contarc@coding@coding=9 and p4 is distinct from 13)@"(p_enc integer, p_hog integer) RETURNS bigint
    LANGUAGE sql
    AS $$ SELECT COUNT(pla_coding) 
                        FROM plana_i1_ i1 INNER JOIN plana_s1_p s1p ON i1.pla_enc=s1p.pla_enc AND i1.pla_hog=s1p.pla_hog AND i1.pla_mie=s1p.pla_mie
                            INNER JOIN plana_s1_ s1 ON i1.pla_enc=s1.pla_enc AND i1.pla_hog=s1.pla_hog 
                            INNER JOIN plana_a1_ a1 ON i1.pla_enc=a1.pla_enc AND i1.pla_hog=a1.pla_hog 
                            INNER JOIN plana_tem_ t ON i1.pla_enc=t.pla_enc 
                        WHERE i1.pla_enc=p_enc and i1.pla_hog=p_hog and 
                            pla_coding=9 and pla_p4 is distinct from 13 
                            /* @(contarc@coding@coding=9 and p4 is distinct from 13)@  */
                        $$;


ALTER FUNCTION dbx."@(contarc@coding@coding=9 and p4 is distinct from 13)@"(p_enc integer, p_hog integer) OWNER TO tedede_php;

--
-- Name: @(contarc@respondi@p4 is distinct from 13 and edad>=10 a_0001)@(integer, integer); Type: FUNCTION; Schema: dbx; Owner: tedede_php
--

CREATE FUNCTION "@(contarc@respondi@p4 is distinct from 13 and edad>=10 a_0001)@"(p_enc integer, p_hog integer) RETURNS bigint
    LANGUAGE sql
    AS $$ SELECT COUNT(pla_respondi) 
                        FROM plana_i1_ i1 INNER JOIN plana_s1_p s1p ON i1.pla_enc=s1p.pla_enc AND i1.pla_hog=s1p.pla_hog AND i1.pla_mie=s1p.pla_mie
                            INNER JOIN plana_s1_ s1 ON i1.pla_enc=s1.pla_enc AND i1.pla_hog=s1.pla_hog 
                            INNER JOIN plana_a1_ a1 ON i1.pla_enc=a1.pla_enc AND i1.pla_hog=a1.pla_hog 
                            INNER JOIN plana_tem_ t ON i1.pla_enc=t.pla_enc 
                        WHERE i1.pla_enc=p_enc and i1.pla_hog=p_hog and 
                            pla_p4 is distinct from 13 and pla_edad>=10 and pla_entrea is distinct from 4 
                            /* @(contarc@respondi@p4 is distinct from 13 and edad>=10 and entrea is distinct from 4)@  */
                        $$;


ALTER FUNCTION dbx."@(contarc@respondi@p4 is distinct from 13 and edad>=10 a_0001)@"(p_enc integer, p_hog integer) OWNER TO tedede_php;

--
-- Name: @(contarc@respondi@p4 is distinct from 13 and edad>=10)@(integer, integer); Type: FUNCTION; Schema: dbx; Owner: tedede_php
--

CREATE FUNCTION "@(contarc@respondi@p4 is distinct from 13 and edad>=10)@"(p_enc integer, p_hog integer) RETURNS bigint
    LANGUAGE sql
    AS $$ SELECT COUNT(pla_respondi) 
                        FROM plana_i1_ i1 INNER JOIN plana_s1_p s1p ON i1.pla_enc=s1p.pla_enc AND i1.pla_hog=s1p.pla_hog AND i1.pla_mie=s1p.pla_mie
                            INNER JOIN plana_s1_ s1 ON i1.pla_enc=s1.pla_enc AND i1.pla_hog=s1.pla_hog 
                            INNER JOIN plana_a1_ a1 ON i1.pla_enc=a1.pla_enc AND i1.pla_hog=a1.pla_hog 
                            INNER JOIN plana_tem_ t ON i1.pla_enc=t.pla_enc 
                        WHERE i1.pla_enc=p_enc and i1.pla_hog=p_hog and 
                            pla_p4 is distinct from 13 and pla_edad>=10 
                            /* @(contarc@respondi@p4 is distinct from 13 and edad>=10)@  */
                        $$;


ALTER FUNCTION dbx."@(contarc@respondi@p4 is distinct from 13 and edad>=10)@"(p_enc integer, p_hog integer) OWNER TO tedede_php;

--
-- Name: @(contarc@respondi@p4 is distinct from 13 and entrea is _0001)@(integer, integer); Type: FUNCTION; Schema: dbx; Owner: tedede_php
--

CREATE FUNCTION "@(contarc@respondi@p4 is distinct from 13 and entrea is _0001)@"(p_enc integer, p_hog integer) RETURNS bigint
    LANGUAGE sql
    AS $$ SELECT COUNT(pla_respondi) 
                        FROM plana_i1_ i1 INNER JOIN plana_s1_p s1p ON i1.pla_enc=s1p.pla_enc AND i1.pla_hog=s1p.pla_hog AND i1.pla_mie=s1p.pla_mie
                            INNER JOIN plana_s1_ s1 ON i1.pla_enc=s1.pla_enc AND i1.pla_hog=s1.pla_hog 
                            INNER JOIN plana_a1_ a1 ON i1.pla_enc=a1.pla_enc AND i1.pla_hog=a1.pla_hog 
                            INNER JOIN plana_tem_ t ON i1.pla_enc=t.pla_enc 
                        WHERE i1.pla_enc=p_enc and i1.pla_hog=p_hog and 
                            pla_p4 is distinct from 13 and pla_entrea is distinct from 4 
                            /* @(contarc@respondi@p4 is distinct from 13 and entrea is distinct from 4)@  */
                        $$;


ALTER FUNCTION dbx."@(contarc@respondi@p4 is distinct from 13 and entrea is _0001)@"(p_enc integer, p_hog integer) OWNER TO tedede_php;

--
-- Name: @(contarc@respondi@p4 is distinct from 13)@(integer, integer); Type: FUNCTION; Schema: dbx; Owner: tedede_php
--

CREATE FUNCTION "@(contarc@respondi@p4 is distinct from 13)@"(p_enc integer, p_hog integer) RETURNS bigint
    LANGUAGE sql
    AS $$ SELECT COUNT(pla_respondi) 
                        FROM plana_i1_ i1 INNER JOIN plana_s1_p s1p ON i1.pla_enc=s1p.pla_enc AND i1.pla_hog=s1p.pla_hog AND i1.pla_mie=s1p.pla_mie
                            INNER JOIN plana_s1_ s1 ON i1.pla_enc=s1.pla_enc AND i1.pla_hog=s1.pla_hog 
                            INNER JOIN plana_a1_ a1 ON i1.pla_enc=a1.pla_enc AND i1.pla_hog=a1.pla_hog 
                            INNER JOIN plana_tem_ t ON i1.pla_enc=t.pla_enc 
                        WHERE i1.pla_enc=p_enc and i1.pla_hog=p_hog and 
                            pla_p4 is distinct from 13 
                            /* @(contarc@respondi@p4 is distinct from 13)@  */
                        $$;


ALTER FUNCTION dbx."@(contarc@respondi@p4 is distinct from 13)@"(p_enc integer, p_hog integer) OWNER TO tedede_php;

--
-- Name: @(sumap @ i2_totx @ not informado(t37sd) )@(integer, integer); Type: FUNCTION; Schema: dbx; Owner: tedede_php
--

CREATE FUNCTION "@(sumap @ i2_totx @ not informado(t37sd) )@"(p_enc integer, p_hog integer) RETURNS bigint
    LANGUAGE sql
    AS $$ SELECT SUM(CASE WHEN pla_i2_totx>0 THEN pla_i2_totx ELSE NULL END) 
                  FROM plana_i1_ i1 INNER JOIN plana_s1_p s1p ON i1.pla_enc=s1p.pla_enc AND i1.pla_hog=s1p.pla_hog AND i1.pla_mie=s1p.pla_mie
                       INNER JOIN plana_s1_ s1 ON i1.pla_enc=s1.pla_enc AND i1.pla_hog=s1.pla_hog 
                       INNER JOIN plana_a1_ a1 ON i1.pla_enc=a1.pla_enc AND i1.pla_hog=a1.pla_hog 
                       INNER JOIN plana_tem_ t ON i1.pla_enc=t.pla_enc 
                  WHERE i1.pla_enc=p_enc and i1.pla_hog=p_hog and 
                    not informado(pla_t37sd) 
                    /* @(sumap @ i2_totx @ not informado(t37sd) )@  */
                  $$;


ALTER FUNCTION dbx."@(sumap @ i2_totx @ not informado(t37sd) )@"(p_enc integer, p_hog integer) OWNER TO tedede_php;

--
-- Name: @(sumap @ ingtot @ p4 is distinct from 13 )@(integer, integer); Type: FUNCTION; Schema: dbx; Owner: tedede_php
--

CREATE FUNCTION "@(sumap @ ingtot @ p4 is distinct from 13 )@"(p_enc integer, p_hog integer) RETURNS bigint
    LANGUAGE sql
    AS $$ SELECT SUM(CASE WHEN pla_ingtot>0 THEN pla_ingtot ELSE NULL END) 
                  FROM plana_i1_ i1 INNER JOIN plana_s1_p s1p ON i1.pla_enc=s1p.pla_enc AND i1.pla_hog=s1p.pla_hog AND i1.pla_mie=s1p.pla_mie
                       INNER JOIN plana_s1_ s1 ON i1.pla_enc=s1.pla_enc AND i1.pla_hog=s1.pla_hog 
                       INNER JOIN plana_a1_ a1 ON i1.pla_enc=a1.pla_enc AND i1.pla_hog=a1.pla_hog 
                       INNER JOIN plana_tem_ t ON i1.pla_enc=t.pla_enc 
                  WHERE i1.pla_enc=p_enc and i1.pla_hog=p_hog and 
                    pla_p4 is distinct from 13 
                    /* @(sumap @ ingtot @ p4 is distinct from 13 )@  */
                  $$;


ALTER FUNCTION dbx."@(sumap @ ingtot @ p4 is distinct from 13 )@"(p_enc integer, p_hog integer) OWNER TO tedede_php;

--
-- Name: @(sumap@ i2_totx @ edad>9)@(integer, integer); Type: FUNCTION; Schema: dbx; Owner: postgres
--

CREATE FUNCTION "@(sumap@ i2_totx @ edad>9)@"(p_enc integer, p_hog integer) RETURNS bigint
    LANGUAGE sql
    AS $$ SELECT SUM(CASE WHEN pla_i2_totx>0 THEN pla_i2_totx ELSE NULL END) 
                  FROM plana_i1_ i1 INNER JOIN plana_s1_p s1p ON i1.pla_enc=s1p.pla_enc AND i1.pla_hog=s1p.pla_hog AND i1.pla_mie=s1p.pla_mie
                       INNER JOIN plana_s1_ s1 ON i1.pla_enc=s1.pla_enc AND i1.pla_hog=s1.pla_hog 
                       INNER JOIN plana_a1_ a1 ON i1.pla_enc=a1.pla_enc AND i1.pla_hog=a1.pla_hog 
                       INNER JOIN plana_tem_ t ON i1.pla_enc=t.pla_enc 
                  WHERE i1.pla_enc=p_enc and i1.pla_hog=p_hog and 
                    pla_edad>9 
                    /* @(sumap@ i2_totx @ edad>9)@  */
                  $$;


ALTER FUNCTION dbx."@(sumap@ i2_totx @ edad>9)@"(p_enc integer, p_hog integer) OWNER TO postgres;

--
-- Name: @(sumap@ i3_1x @ edad>10 and edad>11 and edad>12 and eda_0001)@(integer, integer); Type: FUNCTION; Schema: dbx; Owner: postgres
--

CREATE FUNCTION "@(sumap@ i3_1x @ edad>10 and edad>11 and edad>12 and eda_0001)@"(p_enc integer, p_hog integer) RETURNS bigint
    LANGUAGE sql
    AS $$ SELECT SUM(CASE WHEN pla_i3_1x>0 THEN pla_i3_1x ELSE NULL END) 
                  FROM plana_i1_ i1 INNER JOIN plana_s1_p s1p ON i1.pla_enc=s1p.pla_enc AND i1.pla_hog=s1p.pla_hog AND i1.pla_mie=s1p.pla_mie
                       INNER JOIN plana_s1_ s1 ON i1.pla_enc=s1.pla_enc AND i1.pla_hog=s1.pla_hog 
                       INNER JOIN plana_a1_ a1 ON i1.pla_enc=a1.pla_enc AND i1.pla_hog=a1.pla_hog 
                       INNER JOIN plana_tem_ t ON i1.pla_enc=t.pla_enc 
                  WHERE i1.pla_enc=p_enc and i1.pla_hog=p_hog and 
                    pla_edad>10 and pla_edad>11 and pla_edad>12 and pla_edad>11 and pla_edad>12 and pla_edad>11 and pla_edad>12 and pla_edad>11 and pla_edad>12 
                    /* @(sumap@ i3_1x @ edad>10 and edad>11 and edad>12 and edad>11 and edad>12 and edad>11 and edad>12 and edad>11 and edad>12 )@  */
                  $$;


ALTER FUNCTION dbx."@(sumap@ i3_1x @ edad>10 and edad>11 and edad>12 and eda_0001)@"(p_enc integer, p_hog integer) OWNER TO postgres;

--
-- Name: @(sumap@ingtot@ (p4>0 and p4<13) or p4=14)@(integer, integer); Type: FUNCTION; Schema: dbx; Owner: tedede_php
--

CREATE FUNCTION "@(sumap@ingtot@ (p4>0 and p4<13) or p4=14)@"(p_enc integer, p_hog integer) RETURNS bigint
    LANGUAGE sql
    AS $$ SELECT SUM(CASE WHEN pla_ingtot>0 THEN pla_ingtot ELSE NULL END) 
                  FROM plana_i1_ i1 INNER JOIN plana_s1_p s1p ON i1.pla_enc=s1p.pla_enc AND i1.pla_hog=s1p.pla_hog AND i1.pla_mie=s1p.pla_mie
                       INNER JOIN plana_s1_ s1 ON i1.pla_enc=s1.pla_enc AND i1.pla_hog=s1.pla_hog 
                       INNER JOIN plana_a1_ a1 ON i1.pla_enc=a1.pla_enc AND i1.pla_hog=a1.pla_hog 
                       INNER JOIN plana_tem_ t ON i1.pla_enc=t.pla_enc 
                  WHERE i1.pla_enc=p_enc and i1.pla_hog=p_hog and 
                    (pla_p4>0 and pla_p4<13) or pla_p4=14 
                    /* @(sumap@ingtot@ (p4>0 and p4<13) or p4=14)@  */
                  $$;


ALTER FUNCTION dbx."@(sumap@ingtot@ (p4>0 and p4<13) or p4=14)@"(p_enc integer, p_hog integer) OWNER TO tedede_php;

--
-- Name: @(sumap@ingtot@(p4>0 and p4<13) or p4=14)@(integer, integer); Type: FUNCTION; Schema: dbx; Owner: tedede_php
--

CREATE FUNCTION "@(sumap@ingtot@(p4>0 and p4<13) or p4=14)@"(p_enc integer, p_hog integer) RETURNS bigint
    LANGUAGE sql
    AS $$ SELECT SUM(CASE WHEN pla_ingtot>0 THEN pla_ingtot ELSE NULL END) 
                  FROM plana_i1_ i1 INNER JOIN plana_s1_p s1p ON i1.pla_enc=s1p.pla_enc AND i1.pla_hog=s1p.pla_hog AND i1.pla_mie=s1p.pla_mie
                       INNER JOIN plana_s1_ s1 ON i1.pla_enc=s1.pla_enc AND i1.pla_hog=s1.pla_hog 
                       INNER JOIN plana_a1_ a1 ON i1.pla_enc=a1.pla_enc AND i1.pla_hog=a1.pla_hog 
                       INNER JOIN plana_tem_ t ON i1.pla_enc=t.pla_enc 
                  WHERE i1.pla_enc=p_enc and i1.pla_hog=p_hog and 
                    (pla_p4>0 and pla_p4<13) or pla_p4=14 
                    /* @(sumap@ingtot@(p4>0 and p4<13) or p4=14)@  */
                  $$;


ALTER FUNCTION dbx."@(sumap@ingtot@(p4>0 and p4<13) or p4=14)@"(p_enc integer, p_hog integer) OWNER TO tedede_php;

--
-- Name: @(sumap@ingtot@p4 is distinct from 13 and (coding=1 or c_0001)@(integer, integer); Type: FUNCTION; Schema: dbx; Owner: tedede_php
--

CREATE FUNCTION "@(sumap@ingtot@p4 is distinct from 13 and (coding=1 or c_0001)@"(p_enc integer, p_hog integer) RETURNS bigint
    LANGUAGE sql
    AS $$ SELECT SUM(CASE WHEN pla_ingtot>0 THEN pla_ingtot ELSE NULL END) 
                  FROM plana_i1_ i1 INNER JOIN plana_s1_p s1p ON i1.pla_enc=s1p.pla_enc AND i1.pla_hog=s1p.pla_hog AND i1.pla_mie=s1p.pla_mie
                       INNER JOIN plana_s1_ s1 ON i1.pla_enc=s1.pla_enc AND i1.pla_hog=s1.pla_hog 
                       INNER JOIN plana_a1_ a1 ON i1.pla_enc=a1.pla_enc AND i1.pla_hog=a1.pla_hog 
                       INNER JOIN plana_tem_ t ON i1.pla_enc=t.pla_enc 
                  WHERE i1.pla_enc=p_enc and i1.pla_hog=p_hog and 
                    pla_p4 is distinct from 13 and (pla_coding=1 or pla_coding=2) 
                    /* @(sumap@ingtot@p4 is distinct from 13 and (coding=1 or coding=2))@  */
                  $$;


ALTER FUNCTION dbx."@(sumap@ingtot@p4 is distinct from 13 and (coding=1 or c_0001)@"(p_enc integer, p_hog integer) OWNER TO tedede_php;

--
-- Name: @(sumap@ingtot@p4 is distinct from 13)@(integer, integer); Type: FUNCTION; Schema: dbx; Owner: tedede_php
--

CREATE FUNCTION "@(sumap@ingtot@p4 is distinct from 13)@"(p_enc integer, p_hog integer) RETURNS bigint
    LANGUAGE sql
    AS $$ SELECT SUM(CASE WHEN pla_ingtot>0 THEN pla_ingtot ELSE NULL END) 
                  FROM plana_i1_ i1 INNER JOIN plana_s1_p s1p ON i1.pla_enc=s1p.pla_enc AND i1.pla_hog=s1p.pla_hog AND i1.pla_mie=s1p.pla_mie
                       INNER JOIN plana_s1_ s1 ON i1.pla_enc=s1.pla_enc AND i1.pla_hog=s1.pla_hog 
                       INNER JOIN plana_a1_ a1 ON i1.pla_enc=a1.pla_enc AND i1.pla_hog=a1.pla_hog 
                       INNER JOIN plana_tem_ t ON i1.pla_enc=t.pla_enc 
                  WHERE i1.pla_enc=p_enc and i1.pla_hog=p_hog and 
                    pla_p4 is distinct from 13 
                    /* @(sumap@ingtot@p4 is distinct from 13)@  */
                  $$;


ALTER FUNCTION dbx."@(sumap@ingtot@p4 is distinct from 13)@"(p_enc integer, p_hog integer) OWNER TO tedede_php;

--
-- Name: @(sumap@ingtot@p4<>13)@(integer, integer); Type: FUNCTION; Schema: dbx; Owner: tedede_php
--

CREATE FUNCTION "@(sumap@ingtot@p4<>13)@"(p_enc integer, p_hog integer) RETURNS bigint
    LANGUAGE sql
    AS $$ SELECT SUM(CASE WHEN pla_ingtot>0 THEN pla_ingtot ELSE NULL END) 
                  FROM plana_i1_ i1 INNER JOIN plana_s1_p s1p ON i1.pla_enc=s1p.pla_enc AND i1.pla_hog=s1p.pla_hog AND i1.pla_mie=s1p.pla_mie
                       INNER JOIN plana_s1_ s1 ON i1.pla_enc=s1.pla_enc AND i1.pla_hog=s1.pla_hog 
                       INNER JOIN plana_a1_ a1 ON i1.pla_enc=a1.pla_enc AND i1.pla_hog=a1.pla_hog 
                       INNER JOIN plana_tem_ t ON i1.pla_enc=t.pla_enc 
                  WHERE i1.pla_enc=p_enc and i1.pla_hog=p_hog and 
                    pla_p4<>13 
                    /* @(sumap@ingtot@p4<>13)@  */
                  $$;


ALTER FUNCTION dbx."@(sumap@ingtot@p4<>13)@"(p_enc integer, p_hog integer) OWNER TO tedede_php;

SET search_path = operaciones, pg_catalog;

--
-- Name: generar_calculo_estado_trg(); Type: FUNCTION; Schema: operaciones; Owner: postgres
--

CREATE FUNCTION generar_calculo_estado_trg() RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE
  v_enter text:=chr(13)||chr(10);
  v_script_creador text;
  v_reemplazo_1 text;
  v_reemplazos record;
  otro_orden integer;
BEGIN
v_script_creador:=$SCRIPT$
-- alter table encu.plana_tem_ drop column if exists pla_sup_dirigida_enc; alter table encu.plana_tem_ add column pla_sup_dirigida_enc integer; /*G*/

-- DROP FUNCTION encu.calculo_estado_trg();
-- set search_path = encu, comun, public;

CREATE OR REPLACE FUNCTION encu.calculo_estado_trg()
  RETURNS trigger AS
$BODY$
DECLARE
  v_estado_final integer;
  
  v_sup_dirigida_enc encu.plana_tem_.pla_sup_dirigida_enc%type; /*G*/
  
  v_en_campo_nuevo encu.plana_tem_.pla_en_campo%type; v_en_campo_viejo encu.plana_tem_.pla_en_campo%type; /*G*/
  
  v_rol_nuevo encu.plana_tem_.pla_rol%type; v_rol_viejo encu.plana_tem_.pla_rol%type; /*G_amano*/
  
  v_per_nuevo encu.plana_tem_.pla_per%type; v_per_viejo encu.plana_tem_.pla_per%type; /*G_amano*/
  
  v_calculo_enc integer;  
  v_calculo_recu integer;  
  i_sufijo integer;
  v_sufijo text;
  v_aux_aleat_enc text;
  v_aux_aleat_recu text;
BEGIN
  if new.res_for='TEM' and 
        (new.res_valor is distinct from old.res_valor 
        or new.res_valesp is distinct from old.res_valesp 
        or new.res_valor_con_error is distinct from old.res_valor_con_error 
        or new.res_var = 'asignable'
        ) 
     and new.res_var<>'estado' -- porque vamos a actualizar el estado
  then
    if new.res_var='verificado_enc' and new.res_valor::integer<>2 then
        select pla_rea_enc, pla_dominio, (pla_enc*23 + pla_replica + pla_comuna*7 + coalesce(pla_id_marco,0)*21 + coalesce(pla_ccodigo,0)) % 10
            into   v_rea_enc, v_dominio, v_calculo_enc
            from encu.plana_tem_
            where pla_enc=new.res_enc and pla_hog=new.res_hog and pla_mie=new.res_mie and pla_exm=new.res_exm;  
        if v_rea_enc = 1 and v_dominio = 3 then
            if v_calculo_enc = 1 then
                v_aux_aleat_enc := '3';
            elsif v_calculo_enc = 0 then
                v_aux_aleat_enc='4';
            end if;
            UPDATE encu.respuestas
                SET res_valor=v_aux_aleat_enc, res_valesp=null, res_valor_con_error=null, res_tlg=new.res_tlg
                    WHERE res_ope=new.res_ope
                        and res_for=new.res_for
                        and res_mat=new.res_mat
                        and res_enc=new.res_enc
                        and res_hog=new.res_hog
                        and res_mie=new.res_mie 
                        and res_exm=new.res_exm 
                        and res_var='sup_aleat'; 
        end if;
    elsif new.res_var='verificado_recu' and new.res_valor::integer<>2 then
        select pla_rea_recu, pla_dominio, ((pla_enc*23 + pla_replica + pla_comuna*7 + coalesce(pla_id_marco,0)*21 + coalesce(pla_ccodigo,0)) % 10)
            into   v_rea_recu, v_dominio, v_calculo_recu
            from encu.plana_tem_
            where pla_enc=new.res_enc and pla_hog=new.res_hog and pla_mie=new.res_mie and pla_exm=new.res_exm;  
        if v_rea_recu = 3 and v_dominio = 3 then
            if v_calculo_recu = 8 then
                v_aux_aleat_recu := '3';
            elsif v_calculo_recu = 7 then
                v_aux_aleat_recu := '4';
            end if;
            UPDATE encu.respuestas
                SET res_valor=v_aux_aleat_recu::text, res_valesp=null, res_valor_con_error=null, res_tlg=new.res_tlg
                    WHERE res_ope=new.res_ope
                        and res_for=new.res_for
                        and res_mat=new.res_mat
                        and res_enc=new.res_enc
                        and res_hog=new.res_hog
                        and res_mie=new.res_mie 
                        and res_exm=new.res_exm 
                        and res_var='sup_aleat'; 
        end if;
    end if;
    select pla_sup_dirigida_enc /*G*/
      into   v_sup_dirigida_enc /*G*/
      from encu.plana_tem_
      where pla_enc=new.res_enc and pla_hog=new.res_hog and pla_mie=new.res_mie and pla_exm=new.res_exm; /*G:PK*/ -- pk_verificada
    if v_estado_final is null and (v_result_supe>0 /*G:C*/) then v_estado_final:=47 /*G:NumE*/; end if; /*G:E*/
    if v_estado_final is distinct from v_estado then
      UPDATE encu.respuestas
        SET res_valor=v_estado_final, res_valesp=null, res_valor_con_error=null, res_tlg=new.res_tlg
        WHERE res_ope=new.res_ope
          and res_for=new.res_for
          and res_mat=new.res_mat
          and res_enc=new.res_enc
          and res_hog=new.res_hog
          and res_mie=new.res_mie 
          and res_exm=new.res_exm /*G:PK*/ 
          and res_var='estado'; -- pk_verificada
    end if;
  end if;
  for i_sufijo in 1..2 loop
      if i_sufijo=1 then
          v_sufijo='enc';
      else
          v_sufijo='recu';
      end if;
      if new.res_var='volver_a_cargar_'||v_sufijo and new.res_valor>='1' then
         UPDATE encu.respuestas
           SET res_valor=null, res_valesp=null, res_valor_con_error=null, res_tlg=new.res_tlg
           WHERE res_ope=new.res_ope
             and res_for=new.res_for
             and res_mat=new.res_mat
             and res_enc=new.res_enc
             and res_hog=new.res_hog
             and res_mie=new.res_mie 
             and res_exm=new.res_exm 
             and res_var in ('fecha_carga_'||v_sufijo,'fecha_descarga_'||v_sufijo,'a_ingreso_'||v_sufijo,'con_dato_'||v_sufijo,'fin_ingreso_'||v_sufijo) -- pk_verificada
             and (res_valor is not null or res_valesp is not null or res_valor_con_error is not null);
      end if;
      if new.res_var='fecha_carga_'||v_sufijo and new.res_valor>'1' then
         UPDATE encu.respuestas
           SET res_valor=null, res_valesp=null, res_valor_con_error=null, res_tlg=new.res_tlg
           WHERE res_ope=new.res_ope
             and res_for=new.res_for
             and res_mat=new.res_mat
             and res_enc=new.res_enc
             and res_hog=new.res_hog
             and res_mie=new.res_mie 
             and res_exm=new.res_exm 
             and res_var = 'volver_a_cargar_'||v_sufijo -- pk_verificada
             and (res_valor is not null or res_valesp is not null or res_valor_con_error is not null);
      end if;
      if new.res_var='a_ingreso_'||v_sufijo and new.res_valor='1' then
         UPDATE encu.respuestas
           SET res_valor='2', res_valesp=null, res_valor_con_error=null, res_tlg=new.res_tlg
           WHERE res_ope=new.res_ope
             and res_for=new.res_for
             and res_mat=new.res_mat
             and res_enc=new.res_enc
             and res_hog=new.res_hog
             and res_mie=new.res_mie 
             and res_exm=new.res_exm 
             and res_var = 'con_dato_'||v_sufijo -- pk_verificada
             and (res_valor is distinct from '2' or res_valesp is not null or res_valor_con_error is not null);
      end if;
  end loop;
-- seccion variables calculadas
  select 
      case when pla_estado in (23,24,33,34,44,54) then 1 else 0 end, pla_en_campo, /*G*/
      case when pla_estado<=29 then 'encuestador'  when pla_estado<=39 then 'recuperador' 
           when pla_estado<59 then  'supervisor'  else null end, pla_rol, /*G_amano*/
      case when pla_estado<=29 then pla_cod_enc when pla_estado<=39 then pla_cod_recu when pla_estado<49 then pla_cod_sup 
           when pla_estado<59 then pla_cod_sup else null end, pla_per /*G_amano*/
    into 
      v_en_campo_nuevo, v_en_campo_viejo, /*G*/
      v_rol_nuevo, v_rol_viejo, /*G_amano*/
      v_per_nuevo, v_per_viejo /*G_amano*/
    from encu.plana_tem_
    where pla_enc=new.res_enc and pla_hog=new.res_hog and pla_mie=new.res_mie and pla_exm=new.res_exm;
  if v_en_campo_nuevo is distinct from v_en_campo_viejo then
    UPDATE encu.respuestas
       SET res_valor=v_en_campo_nuevo, res_valesp=null, res_valor_con_error=null, res_tlg=new.res_tlg
       WHERE res_ope=new.res_ope
         and res_for=new.res_for
         and res_mat=new.res_mat
         and res_enc=new.res_enc
         and res_hog=new.res_hog
         and res_mie=new.res_mie 
         and res_exm=new.res_exm 
         and res_var = 'en_campo'; -- pk_verificada
  end if; /*G*/
  if v_rol_nuevo is distinct from v_rol_viejo then
    UPDATE encu.respuestas
       SET res_valor=v_rol_nuevo, res_valesp=null, res_valor_con_error=null, res_tlg=new.res_tlg
       WHERE res_ope=new.res_ope
         and res_for=new.res_for
         and res_mat=new.res_mat
         and res_enc=new.res_enc
         and res_hog=new.res_hog
         and res_mie=new.res_mie 
         and res_exm=new.res_exm 
         and res_var = 'rol'; -- pk_verificada
  end if; /*G_amano*/
  if v_per_nuevo is distinct from v_per_viejo then
    UPDATE encu.respuestas
       SET res_valor=v_per_nuevo, res_valesp=null, res_valor_con_error=null, res_tlg=new.res_tlg
       WHERE res_ope=new.res_ope
         and res_for=new.res_for
         and res_mat=new.res_mat
         and res_enc=new.res_enc
         and res_hog=new.res_hog
         and res_mie=new.res_mie 
         and res_exm=new.res_exm 
         and res_var = 'per'; -- pk_verificada
  end if; /*G_amano*/
  RETURN new;
END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION encu.calculo_estado_trg()
  OWNER TO tedede_php;

DROP TRIGGER IF EXISTS calculo_estado_trg ON encu.respuestas;


CREATE TRIGGER calculo_estado_trg
  AFTER UPDATE
  ON encu.respuestas
  FOR EACH ROW
  EXECUTE PROCEDURE encu.calculo_estado_trg();
$SCRIPT$;
  SELECT MAX(pre_orden)+100 INTO otro_orden 
  FROM encu.variables INNER JOIN encu.preguntas ON pre_ope=var_ope AND pre_pre=var_pre WHERE pre_for='TEM';

  FOR v_reemplazos IN
    SELECT v_enter as separador, '-- alter table encu.plana_tem_ drop column if exists pla_sup_dirigida_enc; alter table encu.plana_tem_ add column pla_sup_dirigida_enc integer; /*G*/' as que_reemplazar
    UNION SELECT v_enter,'  v_sup_dirigida_enc encu.plana_tem_.pla_sup_dirigida_enc%type; /*G*/'
    UNION SELECT ', '   ,'pla_sup_dirigida_enc /*G*/'
    UNION SELECT ','    ,'  v_sup_dirigida_enc /*G*/'
  LOOP
    SELECT string_agg(replace(replace(v_reemplazos.que_reemplazar,'sup_dirigida_enc',var_var),'integer',case when var_tipovar='timestamp' then 'timestamp without time zone' when var_tipovar = 'texto' then 'text' else 'integer' end),v_reemplazos.separador ORDER BY pre_orden)
        INTO v_reemplazo_1
        FROM (select var_var, var_tipovar, pre_orden from encu.variables 
              inner join encu.preguntas on pre_ope=var_ope and pre_pre=var_pre where pre_for='TEM'
              union select 'dominio' as var_var, 'numeros' as var_tipovar, otro_orden as pre_orden ) as a;
    v_script_creador:=replace(v_script_creador,v_reemplazos.que_reemplazar,v_reemplazo_1);
  END LOOP;
  FOR v_reemplazos IN
    SELECT v_enter as separador, '    if v_estado_final is null and (v_result_supe>0 /*G:C*/) then v_estado_final:=47 /*G:NumE*/; end if; /*G:E*/'::text as que_reemplazar
  LOOP
    SELECT string_agg(replace(replace(v_reemplazos.que_reemplazar,
             'v_result_supe>0 /*G:C*/',comun.reemplazar_variables(est_criterio,'v_\1')),
             '47 /*G:NumE*/',est_est::text
             ),v_reemplazos.separador ORDER BY est_est DESC)
       INTO v_reemplazo_1
        FROM encu.estados
        WHERE trim(est_criterio)<>'';
    v_script_creador:=replace(v_script_creador,v_reemplazos.que_reemplazar,v_reemplazo_1);
  END LOOP;
  EXECUTE v_script_creador;
  RETURN NULL;
--  RETURN v_script_creador;
END;
$_$;


ALTER FUNCTION operaciones.generar_calculo_estado_trg() OWNER TO postgres;

--
-- Name: migrar_una_clave(text, text, text, text, text, text, text, text); Type: FUNCTION; Schema: operaciones; Owner: postgres
--

CREATE FUNCTION migrar_una_clave(p_ope text, p_tabla_origen text, p_for text, p_mat text, p_venc text, p_vhog text, p_vmie text, p_vexm text) RETURNS void
    LANGUAGE plpgsql
    AS $_$
declare
  v_sql text;  
begin
    v_sql:=replace(replace(replace(replace(replace(replace($sql$
        INSERT INTO encu.claves(
                    cla_ope, cla_for, cla_mat, cla_enc, cla_hog, cla_mie, cla_exm, cla_tlg)
            SELECT '#p_ope#' as cla_ope, $1, $2, #p_venc# as cla_enc, #p_vhog# as cla_hog, coalesce(#p_vmie#,0) as cla_mie, coalesce(#p_vexm#,0) as cla_exm, 
                    1 as cla_tlg
              FROM #p_tabla_origen# INNER JOIN encu.tem ON #p_venc#=tem_enc
              --where #p_venc# BETWEEN  100001 AND 999999
    $sql$,'#p_tabla_origen#',p_tabla_origen),'#p_venc#',p_venc),'#p_vhog#',p_vhog),'#p_vmie#',p_vmie),'#p_vexm#',p_vexm),'#p_ope#',p_ope);
    execute v_sql using p_for, p_mat;
end;
$_$;


ALTER FUNCTION operaciones.migrar_una_clave(p_ope text, p_tabla_origen text, p_for text, p_mat text, p_venc text, p_vhog text, p_vmie text, p_vexm text) OWNER TO postgres;

--
-- Name: migrar_una_variable(text, text, text, text, text, text, text, text, text); Type: FUNCTION; Schema: operaciones; Owner: postgres
--

CREATE FUNCTION migrar_una_variable(p_ope text, p_tabla_origen text, p_for text, p_mat text, p_var text, p_venc text, p_vhog text, p_vmie text, p_vexm text) RETURNS void
    LANGUAGE plpgsql
    AS $_$
declare
  v_sql text;
begin
    v_sql:=replace(replace(replace(replace(replace(replace(replace(replace($sql$    
        UPDATE encu.respuestas
            SET res_valor=case when #p_var#::text not in (#nsnc_var#::text,'-1') then #p_var# else null end 
              , res_valesp=case #p_var#::text when #nsnc_var#::text then '//' when '-1' then '--' else null end 
            FROM #p_tabla_origen# INNER JOIN encu.tem ON #p_venc#=tem_enc
            WHERE res_ope='#p_ope#' and res_for=$1 and res_mat=$2 and res_enc=#p_venc# 
                AND res_hog=#p_vhog# 
                and res_mie=coalesce(#p_vmie#,0) 
                and res_exm=coalesce(#p_vexm#,0) 
                and res_var='#p_var#' and #p_venc# BETWEEN  100001 AND 999999
    $sql$,'#p_tabla_origen#',p_tabla_origen),'#p_var#',p_var),'#nsnc_var#','9'),'#p_venc#',p_venc),'#p_vhog#',p_vhog),'#p_vmie#',p_vmie),'#p_ope#',p_ope),'#p_vexm#',p_vexm);
    execute v_sql using p_for, p_mat;    
end;
$_$;


ALTER FUNCTION operaciones.migrar_una_variable(p_ope text, p_tabla_origen text, p_for text, p_mat text, p_var text, p_venc text, p_vhog text, p_vmie text, p_vexm text) OWNER TO postgres;

SET search_path = public, pg_catalog;

--
-- Name: algo(date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION algo(p date) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN 'ERA UNA FECHA '||P;
END;
$$;


ALTER FUNCTION public.algo(p date) OWNER TO postgres;

--
-- Name: algo(numeric); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION algo(p numeric) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN 'ES UN NUMERO '||P;
END;
$$;


ALTER FUNCTION public.algo(p numeric) OWNER TO postgres;

--
-- Name: algo(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION algo(p text) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN 'ERA UN TEXTO LINDO '||P;
END;
$$;


ALTER FUNCTION public.algo(p text) OWNER TO postgres;

--
-- Name: claves_campos_aux_trg(); Type: FUNCTION; Schema: public; Owner: tedede_php
--

CREATE FUNCTION claves_campos_aux_trg() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN

    new.cla_aux_es_enc:=null;
    new.cla_aux_es_hog:=null;
    new.cla_aux_es_mie:=null;
    new.cla_aux_es_exm:=null;
  if new.cla_hog=0 then
    new.cla_aux_es_enc:=true;
    if new.cla_mie=0 then
      null;
    else
      raise 'si la clave es de hogar no puede tener especificado el miembro (en encuesta %)',new.cla_enc;
    end if;
    if new.cla_exm=0 then
      null;
    else
      raise 'si la clave es de hogar no puede tener especificado el emigrante (en encuesta %)',new.cla_enc;
    end if;
  elsif new.cla_mie=0 then
    new.cla_aux_es_hog:=true;
    if new.cla_exm=0 then
      new.cla_aux_es_hog:=true;
    else
      new.cla_aux_es_hog:=null;
      new.cla_aux_es_exm:=null;
    end if;
  else
    if new.cla_exm=0 then
      null;
    else
      raise 'si la clave es de hogar no puede tener especificado el emigrante y el miembro (en encuesta %)',new.cla_enc;
    end if;
    new.cla_aux_es_mie:=true;
  end if;
  RETURN new;
END
$$;


ALTER FUNCTION public.claves_campos_aux_trg() OWNER TO tedede_php;

--
-- Name: migrar_una_clave(text, text, text, text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION migrar_una_clave(p_tabla_origen text, p_for text, p_mat text, p_venc text, p_vhog text, p_vmie text) RETURNS void
    LANGUAGE plpgsql
    AS $_$
declare
  v_sql text;  
begin
    v_sql:=replace(replace(replace(replace($sql$
        INSERT INTO encu.claves(
                    cla_ope, cla_for, cla_mat, cla_enc, cla_hog, cla_mie, cla_tlg)
            SELECT 'pp2012' as cla_ope, $1, $2, #p_venc# as cla_enc, #p_vhog# as cla_hog, coalesce(#p_vmie#,0) as cla_mie, 
                    1 as cla_tlg
              FROM yeah_2011.#p_tabla_origen# where #p_venc# BETWEEN  500001 AND 999999
    $sql$,'#p_tabla_origen#',p_tabla_origen),'#p_venc#',p_venc),'#p_vhog#',p_vhog),'#p_vmie#',p_vmie);
    execute v_sql using p_for, p_mat;
end;
$_$;


ALTER FUNCTION public.migrar_una_clave(p_tabla_origen text, p_for text, p_mat text, p_venc text, p_vhog text, p_vmie text) OWNER TO postgres;

--
-- Name: migrar_una_clave(text, text, text, text, text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION migrar_una_clave(p_tabla_origen text, p_for text, p_mat text, p_venc text, p_vhog text, p_vmie text, p_vexm text) RETURNS void
    LANGUAGE plpgsql
    AS $_$
declare
  v_sql text;  
begin
    v_sql:=replace(replace(replace(replace(replace($sql$
        INSERT INTO encu.claves(
                    cla_ope, cla_for, cla_mat, cla_enc, cla_hog, cla_mie, cla_exm, cla_tlg)
            SELECT 'pp2012' as cla_ope, $1, $2, #p_venc# as cla_enc, #p_vhog# as cla_hog, coalesce(#p_vmie#,0) as cla_mie, coalesce(#p_vexm#,0) as cla_exm, 
                    1 as cla_tlg
              FROM yeah_2011.#p_tabla_origen# where #p_venc# BETWEEN  100001 AND 100100
    $sql$,'#p_tabla_origen#',p_tabla_origen),'#p_venc#',p_venc),'#p_vhog#',p_vhog),'#p_vmie#',p_vmie),'#p_vexm#',p_vexm);
    execute v_sql using p_for, p_mat;
end;
$_$;


ALTER FUNCTION public.migrar_una_clave(p_tabla_origen text, p_for text, p_mat text, p_venc text, p_vhog text, p_vmie text, p_vexm text) OWNER TO postgres;

--
-- Name: migrar_una_variable(text, text, text, text, text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION migrar_una_variable(p_tabla_origen text, p_for text, p_mat text, p_var text, p_venc text, p_vhog text, p_vmie text) RETURNS void
    LANGUAGE plpgsql
    AS $_$
declare
  v_sql text;
begin
    v_sql:=replace(replace(replace(replace(replace(replace($sql$    
        UPDATE encu.respuestas
            SET res_valor=case when #p_var#::text not in (#nsnc_var#::text,'-1') then #p_var# else null end 
              , res_valesp=case #p_var#::text when #nsnc_var#::text then '//' when '-1' then '--' else null end 
            FROM yeah_2011.#p_tabla_origen#
            WHERE res_ope='pp2012' and res_for=$1 and res_mat=$2 and res_enc=#p_venc# 
                AND res_hog=#p_vhog# and res_mie=coalesce(#p_vmie#,0) and res_var='#p_var#' and #p_venc# BETWEEN  500001 AND 999999
    $sql$,'#p_tabla_origen#',p_tabla_origen),'#p_var#',p_var),'#nsnc_var#','9'),'#p_venc#',p_venc),'#p_vhog#',p_vhog),'#p_vmie#',p_vmie);
    execute v_sql using p_for, p_mat;    
end;
$_$;


ALTER FUNCTION public.migrar_una_variable(p_tabla_origen text, p_for text, p_mat text, p_var text, p_venc text, p_vhog text, p_vmie text) OWNER TO postgres;

--
-- Name: migrar_una_variable(text, text, text, text, text, text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION migrar_una_variable(p_tabla_origen text, p_for text, p_mat text, p_var text, p_venc text, p_vhog text, p_vmie text, p_vexm text) RETURNS void
    LANGUAGE plpgsql
    AS $_$
declare
  v_sql text;
begin
    v_sql:=replace(replace(replace(replace(replace(replace(replace($sql$    
        UPDATE encu.respuestas
            SET res_valor=case when #p_var#::text not in (#nsnc_var#::text,'-1') then #p_var# else null end 
              , res_valesp=case #p_var#::text when #nsnc_var#::text then '//' when '-1' then '--' else null end 
            FROM yeah_2011.#p_tabla_origen#
            WHERE res_ope='pp2012' and res_for=$1 and res_mat=$2 and res_enc=#p_venc# 
                AND res_hog=#p_vhog# 
		and res_mie=coalesce(#p_vmie#,0) 
		and res_exm=coalesce(#p_vexm#,0) 
                and res_var='#p_var#' and #p_venc# BETWEEN  100001 AND 100100
    $sql$,'#p_tabla_origen#',p_tabla_origen),'#p_var#',p_var),'#nsnc_var#','9'),'#p_venc#',p_venc),'#p_vhog#',p_vhog),'#p_vmie#',p_vmie),'#p_vexm#',p_vexm);
    execute v_sql using p_for, p_mat;    
end;
$_$;


ALTER FUNCTION public.migrar_una_variable(p_tabla_origen text, p_for text, p_mat text, p_var text, p_venc text, p_vhog text, p_vmie text, p_vexm text) OWNER TO postgres;

--
-- Name: sortear_una_variable(text, text, text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION sortear_una_variable(p_for text, p_mat text, p_var text, p_tipovar text, p_conopc text) RETURNS void
    LANGUAGE plpgsql
    AS $$
declare
  v_sql text;
begin
    update encu.respuestas
        set res_valor=1
        where res_for=p_for
            and res_mat=p_mat
            and res_var=p_var
            and res_valor is null;
end;
$$;


ALTER FUNCTION public.sortear_una_variable(p_for text, p_mat text, p_var text, p_tipovar text, p_conopc text) OWNER TO postgres;

SET search_path = comun, pg_catalog;

--
-- Name: concato(text); Type: AGGREGATE; Schema: comun; Owner: tedede_owner
--

CREATE AGGREGATE concato(text) (
    SFUNC = concato_add,
    STYPE = text,
    INITCOND = '',
    FINALFUNC = concato_fin
);


ALTER AGGREGATE comun.concato(text) OWNER TO tedede_owner;

--
-- Name: maxlen(boolean); Type: AGGREGATE; Schema: comun; Owner: tedede_owner
--

CREATE AGGREGATE maxlen(boolean) (
    SFUNC = comun.maxlen_unir,
    STYPE = boolean,
    FINALFUNC = comun.maxlen_fin
);


ALTER AGGREGATE comun.maxlen(boolean) OWNER TO tedede_owner;

--
-- Name: maxlen(date); Type: AGGREGATE; Schema: comun; Owner: tedede_owner
--

CREATE AGGREGATE maxlen(date) (
    SFUNC = comun.maxlen_unir,
    STYPE = date,
    FINALFUNC = comun.maxlen_fin
);


ALTER AGGREGATE comun.maxlen(date) OWNER TO tedede_owner;

--
-- Name: maxlen(double precision); Type: AGGREGATE; Schema: comun; Owner: tedede_owner
--

CREATE AGGREGATE maxlen(double precision) (
    SFUNC = comun.maxlen_unir,
    STYPE = double precision,
    FINALFUNC = comun.maxlen_fin
);


ALTER AGGREGATE comun.maxlen(double precision) OWNER TO tedede_owner;

--
-- Name: maxlen(integer); Type: AGGREGATE; Schema: comun; Owner: tedede_owner
--

CREATE AGGREGATE maxlen(integer) (
    SFUNC = comun.maxlen_unir,
    STYPE = integer,
    FINALFUNC = comun.maxlen_fin
);


ALTER AGGREGATE comun.maxlen(integer) OWNER TO tedede_owner;

--
-- Name: maxlen(text); Type: AGGREGATE; Schema: comun; Owner: tedede_owner
--

CREATE AGGREGATE maxlen(text) (
    SFUNC = comun.maxlen_unir,
    STYPE = text,
    FINALFUNC = comun.maxlen_fin
);


ALTER AGGREGATE comun.maxlen(text) OWNER TO tedede_owner;

SET search_path = public, pg_catalog;

--
-- Name: mediana(anyelement); Type: AGGREGATE; Schema: public; Owner: postgres
--

CREATE AGGREGATE mediana(anyelement) (
    SFUNC = array_append,
    STYPE = anyarray,
    INITCOND = '{}',
    FINALFUNC = comun.final_mediana
);


ALTER AGGREGATE public.mediana(anyelement) OWNER TO postgres;

SET search_path = dbx, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: funciones_automaticas; Type: TABLE; Schema: dbx; Owner: tedede_php; Tablespace: 
--

CREATE TABLE funciones_automaticas (
    fun_fun character varying(300) NOT NULL,
    fun_abreviado character varying(63) NOT NULL,
    fun_codigo text
);


ALTER TABLE dbx.funciones_automaticas OWNER TO tedede_php;

SET search_path = de_ejemplo, pg_catalog;

--
-- Name: de_ejemplo4; Type: TABLE; Schema: de_ejemplo; Owner: tedede_php; Tablespace: 
--

CREATE TABLE de_ejemplo4 (
    codigo character varying(10) NOT NULL,
    numero integer,
    logico boolean DEFAULT false
);


ALTER TABLE de_ejemplo.de_ejemplo4 OWNER TO tedede_php;

--
-- Name: de_ejemplo_abuelo; Type: TABLE; Schema: de_ejemplo; Owner: tedede_php; Tablespace: 
--

CREATE TABLE de_ejemplo_abuelo (
    abuelo_abuelo character varying(10) NOT NULL
);


ALTER TABLE de_ejemplo.de_ejemplo_abuelo OWNER TO tedede_php;

--
-- Name: de_ejemplo_hija; Type: TABLE; Schema: de_ejemplo; Owner: tedede_php; Tablespace: 
--

CREATE TABLE de_ejemplo_hija (
    hija_abuelo character varying(10) NOT NULL,
    hija_padre character varying(10) NOT NULL,
    hija_hija character varying(11) NOT NULL,
    hija_dato text DEFAULT 'este texto'::text
);


ALTER TABLE de_ejemplo.de_ejemplo_hija OWNER TO tedede_php;

--
-- Name: de_ejemplo_padre; Type: TABLE; Schema: de_ejemplo; Owner: tedede_php; Tablespace: 
--

CREATE TABLE de_ejemplo_padre (
    padre_abuelo character varying(10) NOT NULL,
    padre_padre character varying(10) NOT NULL,
    padre_dato text
);


ALTER TABLE de_ejemplo.de_ejemplo_padre OWNER TO tedede_php;

SET search_path = his, pg_catalog;

--
-- Name: his_inconsistencias; Type: TABLE; Schema: his; Owner: tedede_php; Tablespace: 
--

CREATE TABLE his_inconsistencias (
    hisinc_ope text,
    hisinc_con text,
    hisinc_enc integer,
    hisinc_hog integer,
    hisinc_mie integer,
    hisinc_exm integer,
    hisinc_variables_y_valores text,
    hisinc_justificacion text,
    hisinc_autor_justificacion text,
    hisinc_tlg bigint
);


ALTER TABLE his.his_inconsistencias OWNER TO tedede_php;

--
-- Name: his_respuestas; Type: TABLE; Schema: his; Owner: tedede_owner; Tablespace: 
--

CREATE TABLE his_respuestas (
    hisres_ope character varying(50) NOT NULL,
    hisres_for character varying(50) NOT NULL,
    hisres_mat character varying(50) DEFAULT ''::character varying NOT NULL,
    hisres_enc integer DEFAULT 0 NOT NULL,
    hisres_hog integer DEFAULT 0 NOT NULL,
    hisres_mie integer DEFAULT 0 NOT NULL,
    hisres_exm integer DEFAULT 0 NOT NULL,
    hisres_var character varying(50) NOT NULL,
    hisres_valor text,
    hisres_valesp character varying(50),
    hisres_valor_con_error text,
    hisres_estado text,
    hisres_anotaciones_marginales text,
    hisres_tlg bigint NOT NULL,
    hisres_operacion character varying(1)
);


ALTER TABLE his.his_respuestas OWNER TO tedede_owner;

--
-- Name: modificaciones; Type: TABLE; Schema: his; Owner: tedede_owner; Tablespace: 
--

CREATE TABLE modificaciones (
    mdf_mdf integer NOT NULL,
    mdf_tabla character varying(50) NOT NULL,
    mdf_operacion character varying(1) NOT NULL,
    mdf_pk character varying(2000) NOT NULL,
    mdf_campo character varying(2000) NOT NULL,
    mdf_actual text,
    mdf_anterior text,
    mdf_tlg bigint
);


ALTER TABLE his.modificaciones OWNER TO tedede_owner;

--
-- Name: modificaciones_mdf_mdf_seq; Type: SEQUENCE; Schema: his; Owner: tedede_owner
--

CREATE SEQUENCE modificaciones_mdf_mdf_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE his.modificaciones_mdf_mdf_seq OWNER TO tedede_owner;

--
-- Name: modificaciones_mdf_mdf_seq; Type: SEQUENCE OWNED BY; Schema: his; Owner: tedede_owner
--

ALTER SEQUENCE modificaciones_mdf_mdf_seq OWNED BY modificaciones.mdf_mdf;


--
-- Name: plana_a1_; Type: TABLE; Schema: his; Owner: tedede_php; Tablespace: 
--

CREATE TABLE plana_a1_ (
    momento timestamp without time zone,
    pla_enc integer NOT NULL,
    pla_hog integer NOT NULL,
    pla_mie integer NOT NULL,
    pla_exm integer NOT NULL,
    pla_v2_esp text,
    pla_v2 integer,
    pla_v4 integer,
    pla_v5 integer,
    pla_v5_esp text,
    pla_v6 integer,
    pla_v7 integer,
    pla_v12 integer,
    pla_h1 integer,
    pla_h2 integer,
    pla_h2_esp text,
    pla_h3 integer,
    pla_h20_1 integer,
    pla_h20_2 integer,
    pla_h20_17 integer,
    pla_h20_18 integer,
    pla_h20_5 integer,
    pla_h20_6 integer,
    pla_h20_7 integer,
    pla_h20_15 integer,
    pla_h20_8 integer,
    pla_h20_19 integer,
    pla_h20_12 integer,
    pla_h20_11 integer,
    pla_h20_14 integer,
    pla_h20_esp text,
    pla_h21 integer,
    pla_h21_bis integer,
    pla_x5 integer,
    pla_x5_tot integer,
    pla_tlg bigint NOT NULL
);


ALTER TABLE his.plana_a1_ OWNER TO tedede_php;

--
-- Name: plana_a1_x; Type: TABLE; Schema: his; Owner: tedede_php; Tablespace: 
--

CREATE TABLE plana_a1_x (
    momento timestamp without time zone,
    pla_enc integer NOT NULL,
    pla_hog integer NOT NULL,
    pla_mie integer NOT NULL,
    pla_exm integer NOT NULL,
    pla_sexo_ex integer,
    pla_pais_nac integer,
    pla_edad_ex integer,
    pla_niv_educ integer,
    pla_anio integer,
    pla_lugar_esp3 text,
    pla_lugar_esp1 text,
    pla_lugar integer,
    pla_tlg bigint NOT NULL
);


ALTER TABLE his.plana_a1_x OWNER TO tedede_php;

--
-- Name: plana_i1_; Type: TABLE; Schema: his; Owner: tedede_php; Tablespace: 
--

CREATE TABLE plana_i1_ (
    momento timestamp without time zone,
    pla_enc integer NOT NULL,
    pla_hog integer NOT NULL,
    pla_mie integer NOT NULL,
    pla_exm integer NOT NULL,
    pla_obs text,
    pla_respondi integer,
    pla_t1 integer,
    pla_t2 integer,
    pla_t3 integer,
    pla_t4 integer,
    pla_t5 integer,
    pla_t6 integer,
    pla_t7 integer,
    pla_t8 integer,
    pla_t8_otro text,
    pla_t9 integer,
    pla_t10 integer,
    pla_t11 integer,
    pla_t11_otro text,
    pla_t12 integer,
    pla_t13 integer,
    pla_t14 integer,
    pla_t15 integer,
    pla_t16 integer,
    pla_t17 integer,
    pla_t18 integer,
    pla_t19_anio integer,
    pla_t20 integer,
    pla_t21 integer,
    pla_t22 integer,
    pla_t23 text,
    pla_t24 text,
    pla_t25 text,
    pla_t26 text,
    pla_t27 integer,
    pla_t28 integer,
    pla_t29 integer,
    pla_t29a integer,
    pla_t30 integer,
    pla_t31_d integer,
    pla_t31_l integer,
    pla_t31_ma integer,
    pla_t31_mi integer,
    pla_t31_j integer,
    pla_t31_v integer,
    pla_t31_s integer,
    pla_t32_d integer,
    pla_t32_l integer,
    pla_t32_ma integer,
    pla_t32_mi integer,
    pla_t32_j integer,
    pla_t32_v integer,
    pla_t32_s integer,
    pla_t33 integer,
    pla_t34 integer,
    pla_t35 integer,
    pla_t36b integer,
    pla_t37 text,
    pla_t37sd integer,
    pla_t38 integer,
    pla_t39 integer,
    pla_t39_barrio text,
    pla_t39_otro text,
    pla_t39_bis2 integer,
    pla_t39_bis2_esp text,
    pla_t40 integer,
    pla_t41 text,
    pla_t42 text,
    pla_t43 text,
    pla_t44 integer,
    pla_t45 integer,
    pla_t46 integer,
    pla_t47 integer,
    pla_t48 integer,
    pla_t48a integer,
    pla_t48b integer,
    pla_t48b_esp text,
    pla_t49 integer,
    pla_t50a integer,
    pla_t50b integer,
    pla_t50c integer,
    pla_t50d integer,
    pla_t50e integer,
    pla_t50f integer,
    pla_t51 integer,
    pla_t52a integer,
    pla_t52b integer,
    pla_t52c integer,
    pla_t53_ing integer,
    pla_t53_bis1 integer,
    pla_t53_bis1_sem integer,
    pla_t53_bis1_mes integer,
    pla_t53_bis2 integer,
    pla_t53c_anios integer,
    pla_t53c_meses integer,
    pla_t53c_98 integer,
    pla_t54 integer,
    pla_t54b integer,
    pla_i1 integer,
    pla_i2_totx integer,
    pla_i2_ticx integer,
    pla_i3_1 integer,
    pla_i3_1x integer,
    pla_i3_2 integer,
    pla_i3_2x integer,
    pla_i3_3 integer,
    pla_i3_3x integer,
    pla_i3_4 integer,
    pla_i3_4x integer,
    pla_i3_5 integer,
    pla_i3_5x integer,
    pla_i3_6 integer,
    pla_i3_6x integer,
    pla_i3_7 integer,
    pla_i3_7x integer,
    pla_i3_8 integer,
    pla_i3_8x integer,
    pla_i3_11 integer,
    pla_i3_11x integer,
    pla_i3_12 integer,
    pla_i3_12x integer,
    pla_i3_10 integer,
    pla_i3_10_otro text,
    pla_i3_10x integer,
    pla_i3_tot integer,
    pla_e1 integer,
    pla_e2 integer,
    pla_e3 integer,
    pla_e4 integer,
    pla_e6 integer,
    pla_e8 integer,
    pla_e12 integer,
    pla_e13 integer,
    pla_e14 integer,
    pla_m1 integer,
    pla_m1_esp2 text,
    pla_m1_esp3 text,
    pla_m1_esp4 text,
    pla_m1_anio integer,
    pla_m3 integer,
    pla_m3_anio integer,
    pla_m4 integer,
    pla_m4_esp1 text,
    pla_m4_esp2 text,
    pla_m4_esp3 text,
    pla_m5 integer,
    pla_sn1_1 integer,
    pla_sn1_1_esp text,
    pla_sn1_7 integer,
    pla_sn1_7_esp text,
    pla_sn1_2 integer,
    pla_sn1_2_esp text,
    pla_sn1_3 integer,
    pla_sn1_3_esp text,
    pla_sn1_4 integer,
    pla_sn1_4_esp text,
    pla_sn1_5 integer,
    pla_sn1_6 integer,
    pla_sn2 integer,
    pla_sn2_cant integer,
    pla_sn3 integer,
    pla_sn4 integer,
    pla_sn4_esp text,
    pla_sn5 integer,
    pla_sn5_esp text,
    pla_sn11 integer,
    pla_sn12 integer,
    pla_sn12_esp integer,
    pla_sn13 integer,
    pla_sn13_otro text,
    pla_sn14 integer,
    pla_sn14_esp text,
    pla_sn15a integer,
    pla_sn15b integer,
    pla_sn15c integer,
    pla_sn15d integer,
    pla_sn15e integer,
    pla_sn15f integer,
    pla_sn15g integer,
    pla_sn15h integer,
    pla_sn15i integer,
    pla_sn15j integer,
    pla_sn15k integer,
    pla_sn15k_esp text,
    pla_sn16 integer,
    pla_s28 integer,
    pla_s29 integer,
    pla_s30 integer,
    pla_s31_anio integer,
    pla_s31_mes integer,
    pla_tlg bigint NOT NULL,
    pla_e_aesc integer,
    pla_zona_3_1 integer,
    pla_edad10b integer,
    pla_t_ocup integer,
    pla_t_desoc integer,
    pla_t_ina integer,
    pla_cond_activ integer,
    pla_v2_2_mie integer,
    pla_e_nivela integer,
    pla_m1_2 integer,
    pla_e_nivelb integer,
    pla_e_nivelc integer,
    pla_e_nivel integer,
    pla_e_raesc integer,
    pla_m_limit integer,
    pla_m_ln1 integer,
    pla_m_rallp integer,
    pla_tsemref integer,
    pla_t_intens integer,
    pla_t_categ integer,
    pla_categori integer,
    pla_t51_re integer,
    pla_t39_comu integer,
    pla_tipodes integer,
    pla_t_deman integer,
    pla_f_edad integer,
    pla_s28r integer,
    pla_f_n_hij integer,
    pla_categdes integer,
    pla_codlab integer,
    pla_codnolab integer,
    pla_coding integer,
    pla_ingtot integer,
    pla_s_edad integer,
    pla_sn1_99 integer,
    pla_sn1_1a7 integer,
    pla_s_tipco integer,
    pla_s_tipco2 integer,
    pla_s_tipco3 integer,
    pla_s_tipco3r integer,
    pla_edad10a integer,
    pla_igtot integer,
    pla_t_activ integer,
    pla_t_suboc3 integer,
    pla_t_empleo integer,
    pla_t_desocup integer,
    pla_t39_zona integer,
    pla_t39_rec integer,
    pla_t_diasnotr1p integer,
    pla_t_diastra1p integer,
    pla_t_diastra2p integer,
    pla_t_diasnotr2p integer,
    pla_t_edad integer,
    pla_fp5_r integer,
    pla_fp5_agr integer,
    pla_sc_edad integer,
    pla_t_ramocu integer,
    pla_t_ramoc2 integer,
    pla_sem_hs1p numeric,
    pla_sem_hs2p numeric,
    pla_sem_hs numeric
);


ALTER TABLE his.plana_i1_ OWNER TO tedede_php;

--
-- Name: plana_s1_; Type: TABLE; Schema: his; Owner: tedede_php; Tablespace: 
--

CREATE TABLE plana_s1_ (
    momento timestamp without time zone,
    pla_enc integer NOT NULL,
    pla_hog integer NOT NULL,
    pla_mie integer NOT NULL,
    pla_exm integer NOT NULL,
    pla_entrea integer,
    pla_respond integer,
    pla_nombrer text,
    pla_f_realiz_o text,
    pla_telefono text,
    pla_movil text,
    pla_v1 integer,
    pla_total_h integer,
    pla_total_m integer,
    pla_razon1 integer,
    pla_razon2_1 integer,
    pla_razon2_2 integer,
    pla_razon2_3 integer,
    pla_razon2_4 integer,
    pla_razon2_5 integer,
    pla_razon2_6 integer,
    pla_razon3 text,
    pla_razon2_7 integer,
    pla_razon2_8 integer,
    pla_razon2_9 integer,
    pla_s1a1_obs text,
    pla_tlg bigint NOT NULL,
    pla_zona_3 integer,
    pla_tot_mi integer,
    pla_tot_mr integer,
    pla_h2_re integer,
    pla_h2_2 integer,
    pla_h_hacina integer,
    pla_v2_re integer,
    pla_v2_2 integer,
    pla_itf integer,
    pla_itf_calc integer,
    pla_pobnosd integer,
    pla_codi_tot integer,
    pla_hacinam_2 integer,
    pla_h_perhab numeric,
    pla_ipcf_calc numeric,
    pla_ipcf numeric
);


ALTER TABLE his.plana_s1_ OWNER TO tedede_php;

--
-- Name: plana_s1_p; Type: TABLE; Schema: his; Owner: tedede_php; Tablespace: 
--

CREATE TABLE plana_s1_p (
    momento timestamp without time zone,
    pla_enc integer NOT NULL,
    pla_hog integer NOT NULL,
    pla_mie integer NOT NULL,
    pla_exm integer NOT NULL,
    pla_nombre text,
    pla_sexo integer,
    pla_p7 integer,
    pla_p8 integer,
    pla_f_nac_o text,
    pla_edad integer,
    pla_p4 integer,
    pla_p5 integer,
    pla_p5b integer,
    pla_p6_a integer,
    pla_p6_b integer,
    pla_tlg bigint NOT NULL
);


ALTER TABLE his.plana_s1_p OWNER TO tedede_php;

--
-- Name: mdf_mdf; Type: DEFAULT; Schema: his; Owner: tedede_owner
--

ALTER TABLE ONLY modificaciones ALTER COLUMN mdf_mdf SET DEFAULT nextval('modificaciones_mdf_mdf_seq'::regclass);


SET search_path = dbx, pg_catalog;

--
-- Name: funciones_automaticas_fun_abreviado_key; Type: CONSTRAINT; Schema: dbx; Owner: tedede_php; Tablespace: 
--

ALTER TABLE ONLY funciones_automaticas
    ADD CONSTRAINT funciones_automaticas_fun_abreviado_key UNIQUE (fun_abreviado);


--
-- Name: funciones_automaticas_pkey; Type: CONSTRAINT; Schema: dbx; Owner: tedede_php; Tablespace: 
--

ALTER TABLE ONLY funciones_automaticas
    ADD CONSTRAINT funciones_automaticas_pkey PRIMARY KEY (fun_fun);


SET search_path = de_ejemplo, pg_catalog;

--
-- Name: de_ejemplo4_pkey; Type: CONSTRAINT; Schema: de_ejemplo; Owner: tedede_php; Tablespace: 
--

ALTER TABLE ONLY de_ejemplo4
    ADD CONSTRAINT de_ejemplo4_pkey PRIMARY KEY (codigo);


--
-- Name: de_ejemplo_abuelo_pkey; Type: CONSTRAINT; Schema: de_ejemplo; Owner: tedede_php; Tablespace: 
--

ALTER TABLE ONLY de_ejemplo_abuelo
    ADD CONSTRAINT de_ejemplo_abuelo_pkey PRIMARY KEY (abuelo_abuelo);


--
-- Name: de_ejemplo_hija_pkey; Type: CONSTRAINT; Schema: de_ejemplo; Owner: tedede_php; Tablespace: 
--

ALTER TABLE ONLY de_ejemplo_hija
    ADD CONSTRAINT de_ejemplo_hija_pkey PRIMARY KEY (hija_abuelo, hija_padre, hija_hija);


--
-- Name: de_ejemplo_padre_pkey; Type: CONSTRAINT; Schema: de_ejemplo; Owner: tedede_php; Tablespace: 
--

ALTER TABLE ONLY de_ejemplo_padre
    ADD CONSTRAINT de_ejemplo_padre_pkey PRIMARY KEY (padre_abuelo, padre_padre);


SET search_path = his, pg_catalog;

--
-- Name: modificaciones_pkey; Type: CONSTRAINT; Schema: his; Owner: tedede_owner; Tablespace: 
--

ALTER TABLE ONLY modificaciones
    ADD CONSTRAINT modificaciones_pkey PRIMARY KEY (mdf_mdf);


--
-- Name: his_res_var_i; Type: INDEX; Schema: his; Owner: tedede_owner; Tablespace: 
--

CREATE INDEX his_res_var_i ON his_respuestas USING btree (hisres_var);


--
-- Name: his_respuestas_idx1; Type: INDEX; Schema: his; Owner: tedede_owner; Tablespace: 
--

CREATE INDEX his_respuestas_idx1 ON his_respuestas USING btree (hisres_ope, hisres_for, hisres_mat, hisres_var, hisres_enc, hisres_hog, hisres_mie, hisres_exm);


SET search_path = de_ejemplo, pg_catalog;

--
-- Name: de_ejemplo_hija_de_ejemplo_abuelo_fk; Type: FK CONSTRAINT; Schema: de_ejemplo; Owner: tedede_php
--

ALTER TABLE ONLY de_ejemplo_hija
    ADD CONSTRAINT de_ejemplo_hija_de_ejemplo_abuelo_fk FOREIGN KEY (hija_abuelo) REFERENCES de_ejemplo_abuelo(abuelo_abuelo);


--
-- Name: de_ejemplo_hija_de_ejemplo_padre_fk; Type: FK CONSTRAINT; Schema: de_ejemplo; Owner: tedede_php
--

ALTER TABLE ONLY de_ejemplo_hija
    ADD CONSTRAINT de_ejemplo_hija_de_ejemplo_padre_fk FOREIGN KEY (hija_abuelo, hija_padre) REFERENCES de_ejemplo_padre(padre_abuelo, padre_padre);


--
-- Name: de_ejemplo_padre_de_ejemplo_abuelo_fk; Type: FK CONSTRAINT; Schema: de_ejemplo; Owner: tedede_php
--

ALTER TABLE ONLY de_ejemplo_padre
    ADD CONSTRAINT de_ejemplo_padre_de_ejemplo_abuelo_fk FOREIGN KEY (padre_abuelo) REFERENCES de_ejemplo_abuelo(abuelo_abuelo);


--
-- Name: comun; Type: ACL; Schema: -; Owner: tedede_php
--

REVOKE ALL ON SCHEMA comun FROM PUBLIC;
REVOKE ALL ON SCHEMA comun FROM tedede_php;
GRANT ALL ON SCHEMA comun TO tedede_php;
GRANT USAGE ON SCHEMA comun TO yeah_test;
GRANT USAGE ON SCHEMA comun TO PUBLIC;


--
-- Name: his; Type: ACL; Schema: -; Owner: tedede_owner
--

REVOKE ALL ON SCHEMA his FROM PUBLIC;
REVOKE ALL ON SCHEMA his FROM tedede_owner;
GRANT ALL ON SCHEMA his TO tedede_owner;
GRANT USAGE ON SCHEMA his TO tedede_php;
GRANT USAGE ON SCHEMA his TO yeah_solo_lectura_formularios;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


SET search_path = his, pg_catalog;

--
-- Name: his_inconsistencias; Type: ACL; Schema: his; Owner: tedede_php
--

REVOKE ALL ON TABLE his_inconsistencias FROM PUBLIC;
REVOKE ALL ON TABLE his_inconsistencias FROM tedede_php;
GRANT ALL ON TABLE his_inconsistencias TO tedede_php;
GRANT SELECT ON TABLE his_inconsistencias TO yeah_solo_lectura_formularios;


--
-- Name: his_respuestas; Type: ACL; Schema: his; Owner: tedede_owner
--

REVOKE ALL ON TABLE his_respuestas FROM PUBLIC;
REVOKE ALL ON TABLE his_respuestas FROM tedede_owner;
GRANT ALL ON TABLE his_respuestas TO tedede_owner;
GRANT ALL ON TABLE his_respuestas TO tedede_php;
GRANT SELECT ON TABLE his_respuestas TO yeah_solo_lectura_formularios;


--
-- Name: modificaciones; Type: ACL; Schema: his; Owner: tedede_owner
--

REVOKE ALL ON TABLE modificaciones FROM PUBLIC;
REVOKE ALL ON TABLE modificaciones FROM tedede_owner;
GRANT ALL ON TABLE modificaciones TO tedede_owner;
GRANT ALL ON TABLE modificaciones TO tedede_php;


--
-- Name: modificaciones_mdf_mdf_seq; Type: ACL; Schema: his; Owner: tedede_owner
--

REVOKE ALL ON SEQUENCE modificaciones_mdf_mdf_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE modificaciones_mdf_mdf_seq FROM tedede_owner;
GRANT ALL ON SEQUENCE modificaciones_mdf_mdf_seq TO tedede_owner;
GRANT ALL ON SEQUENCE modificaciones_mdf_mdf_seq TO tedede_php;


--
-- PostgreSQL database dump complete
--

