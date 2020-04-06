--
-- PostgreSQL database dump
--

-- Dumped from database version 9.0.4
-- Dumped by pg_dump version 9.0.4
-- Started on 2012-01-16 11:57:41

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- TOC entry 8 (class 2615 OID 94226)
-- Name: comun; Type: SCHEMA; Schema: -; Owner: tedede_owner
--

CREATE SCHEMA comun;


ALTER SCHEMA comun OWNER TO tedede_owner;

SET search_path = comun, pg_catalog;

--
-- TOC entry 27 (class 1255 OID 94237)
-- Dependencies: 739 8
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
-- TOC entry 28 (class 1255 OID 94238)
-- Dependencies: 739 8
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
-- TOC entry 29 (class 1255 OID 94239)
-- Dependencies: 739 8
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
-- TOC entry 30 (class 1255 OID 94240)
-- Dependencies: 8 739
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
-- TOC entry 31 (class 1255 OID 94241)
-- Dependencies: 8 739
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
-- TOC entry 32 (class 1255 OID 94242)
-- Dependencies: 8 739
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
-- TOC entry 33 (class 1255 OID 94243)
-- Dependencies: 8 739
-- Name: agregar_constraints_caracteres_validos(character varying); Type: FUNCTION; Schema: comun; Owner: tedede_owner
--

CREATE FUNCTION agregar_constraints_caracteres_validos(nombre_esquema character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
  tabla_cambio varchar;
  columna_cambio varchar;
  nombre_constraint varchar;
  sql text;
  vCampos record;
  vVersion record;
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
        and table_name not in ('sesiones','modificaciones')
  LOOP 
    nombre_constraint := 'texto invalido en ' || vCampos.column_name || ' de tabla ' || vCampos.table_name;
    sql:='ALTER TABLE '||nombre_esquema||'.'||vCampos.table_name||' DROP CONSTRAINT "'|| nombre_constraint || '";';
    BEGIN
      EXECUTE sql;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    FOR vVersion in 
	select 1 AS orden,'codigo' as version 
	union select 2,'extendido' 
	union select 3,'castellano' 
	union select 4,'formula'
	union select 5,'castellano y formula'
	union select 99,'cualquiera'
	ORDER BY orden
    LOOP
      BEGIN
        sql:='ALTER TABLE '||nombre_esquema||'.'||vCampos.table_name||' ADD CONSTRAINT "'|| nombre_constraint || '" CHECK (comun.cadena_valida('||vCampos.column_name||','''||vVersion.version||'''));';
        EXECUTE sql;
        EXIT;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END LOOP;
  END LOOP;
  RETURN true;
  /* Para correrlo:
     SELECT comun.agregar_constraints_caracteres_validos('yeah');
  */
END;
$$;


ALTER FUNCTION comun.agregar_constraints_caracteres_validos(nombre_esquema character varying) OWNER TO tedede_owner;

--
-- TOC entry 40 (class 1255 OID 94244)
-- Dependencies: 739 8
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
-- TOC entry 41 (class 1255 OID 94245)
-- Dependencies: 8 739
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
	  union select 'a<99-', 'formula', true
	  union select 'a<99-', 'codigo', false) x
    where comun.cadena_valida(entrada, version) is distinct from resultado 
  
  */
  caracteres_permitidos_codigo text:='A-Za-z0-9_';
  caracteres_permitidos_extendido text:='-'||caracteres_permitidos_codigo||' ,/*+().$@!#:';
  caracteres_permitidos_castellano text:=caracteres_permitidos_extendido||'ÁÉÍÓÚÜÑñáéíóúüçÇ¿¡';
  caracteres_permitidos_formula text:=caracteres_permitidos_extendido||'<>=';
  caracteres_permitidos_castellano_formula text:=caracteres_permitidos_castellano||'<>=';
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
-- TOC entry 42 (class 1255 OID 94246)
-- Dependencies: 8 739
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
  caracteres_permitidos_castellano_formula text:=caracteres_permitidos_castellano||'<>=';
  caracteres_permitidos text;
  expresion_regular text;
  expresion_regular_codigo text;
  expresion_regular_extendido text;
  expresion_regular_castellano text;
  expresion_regular_formula text;
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
-- TOC entry 43 (class 1255 OID 94247)
-- Dependencies: 8 739
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
-- TOC entry 44 (class 1255 OID 94248)
-- Dependencies: 8 739
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
-- TOC entry 45 (class 1255 OID 94249)
-- Dependencies: 739 8
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
-- TOC entry 46 (class 1255 OID 94250)
-- Dependencies: 8 739
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
-- TOC entry 47 (class 1255 OID 94251)
-- Dependencies: 8 739
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
-- TOC entry 48 (class 1255 OID 94252)
-- Dependencies: 8 739
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
-- TOC entry 34 (class 1255 OID 94253)
-- Dependencies: 739 8
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
-- TOC entry 35 (class 1255 OID 94254)
-- Dependencies: 739 8
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
-- TOC entry 36 (class 1255 OID 94255)
-- Dependencies: 739 8
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
-- TOC entry 37 (class 1255 OID 94256)
-- Dependencies: 739 8
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
-- TOC entry 38 (class 1255 OID 94257)
-- Dependencies: 739 8
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
-- TOC entry 39 (class 1255 OID 94258)
-- Dependencies: 8 739
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
-- TOC entry 49 (class 1255 OID 94259)
-- Dependencies: 8 739
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
-- TOC entry 50 (class 1255 OID 94260)
-- Dependencies: 8 739
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
-- TOC entry 51 (class 1255 OID 94261)
-- Dependencies: 8 739
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
-- TOC entry 52 (class 1255 OID 94262)
-- Dependencies: 739 8
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
-- TOC entry 53 (class 1255 OID 94263)
-- Dependencies: 739 8
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
-- TOC entry 54 (class 1255 OID 94264)
-- Dependencies: 739 8
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
-- TOC entry 55 (class 1255 OID 94265)
-- Dependencies: 8
-- Name: nulo_a_neutro(text); Type: FUNCTION; Schema: comun; Owner: tedede_owner
--

CREATE FUNCTION nulo_a_neutro(text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $_$
  select coalesce($1,'');
$_$;


ALTER FUNCTION comun.nulo_a_neutro(text) OWNER TO tedede_owner;

--
-- TOC entry 56 (class 1255 OID 94266)
-- Dependencies: 8
-- Name: nulo_a_neutro(integer); Type: FUNCTION; Schema: comun; Owner: tedede_owner
--

CREATE FUNCTION nulo_a_neutro(integer) RETURNS integer
    LANGUAGE sql IMMUTABLE
    AS $_$
  select coalesce($1,0);
$_$;


ALTER FUNCTION comun.nulo_a_neutro(integer) OWNER TO tedede_owner;

--
-- TOC entry 57 (class 1255 OID 94267)
-- Dependencies: 739 8
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
-- TOC entry 58 (class 1255 OID 94268)
-- Dependencies: 8 739
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
-- TOC entry 740 (class 1255 OID 94332)
-- Dependencies: 44 43 8
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
-- TOC entry 741 (class 1255 OID 94333)
-- Dependencies: 35 49 8
-- Name: maxlen(text); Type: AGGREGATE; Schema: comun; Owner: tedede_owner
--

CREATE AGGREGATE maxlen(text) (
    SFUNC = comun.maxlen_unir,
    STYPE = text,
    FINALFUNC = comun.maxlen_fin
);


ALTER AGGREGATE comun.maxlen(text) OWNER TO tedede_owner;

--
-- TOC entry 742 (class 1255 OID 94334)
-- Dependencies: 8 50 36
-- Name: maxlen(integer); Type: AGGREGATE; Schema: comun; Owner: tedede_owner
--

CREATE AGGREGATE maxlen(integer) (
    SFUNC = comun.maxlen_unir,
    STYPE = integer,
    FINALFUNC = comun.maxlen_fin
);


ALTER AGGREGATE comun.maxlen(integer) OWNER TO tedede_owner;

--
-- TOC entry 743 (class 1255 OID 94335)
-- Dependencies: 51 8 37
-- Name: maxlen(double precision); Type: AGGREGATE; Schema: comun; Owner: tedede_owner
--

CREATE AGGREGATE maxlen(double precision) (
    SFUNC = comun.maxlen_unir,
    STYPE = double precision,
    FINALFUNC = comun.maxlen_fin
);


ALTER AGGREGATE comun.maxlen(double precision) OWNER TO tedede_owner;

--
-- TOC entry 744 (class 1255 OID 94336)
-- Dependencies: 8 52 38
-- Name: maxlen(date); Type: AGGREGATE; Schema: comun; Owner: tedede_owner
--

CREATE AGGREGATE maxlen(date) (
    SFUNC = comun.maxlen_unir,
    STYPE = date,
    FINALFUNC = comun.maxlen_fin
);


ALTER AGGREGATE comun.maxlen(date) OWNER TO tedede_owner;

--
-- TOC entry 745 (class 1255 OID 94337)
-- Dependencies: 39 53 8
-- Name: maxlen(boolean); Type: AGGREGATE; Schema: comun; Owner: tedede_owner
--

CREATE AGGREGATE maxlen(boolean) (
    SFUNC = comun.maxlen_unir,
    STYPE = boolean,
    FINALFUNC = comun.maxlen_fin
);


ALTER AGGREGATE comun.maxlen(boolean) OWNER TO tedede_owner;

--
-- TOC entry 2360 (class 0 OID 0)
-- Dependencies: 8
-- Name: comun; Type: ACL; Schema: -; Owner: tedede_owner
--

REVOKE ALL ON SCHEMA comun FROM PUBLIC;
REVOKE ALL ON SCHEMA comun FROM tedede_owner;
GRANT ALL ON SCHEMA comun TO tedede_owner;
GRANT USAGE ON SCHEMA comun TO yeah_test;
GRANT USAGE ON SCHEMA comun TO tedede_php;


-- Completed on 2012-01-16 11:57:42

--
-- PostgreSQL database dump complete
--

GRANT USAGE ON SCHEMA comun TO public;
