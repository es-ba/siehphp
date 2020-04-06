CREATE or replace FUNCTION comun.contiene_findelinea(p_cadena text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
  v2  text;
BEGIN
    select (regexp_matches(p_cadena, '\n')) into v2;
    if  v2 is not null THEN
        --raise exception 'Existe al menos un fin de línea en el texto (%)',p_cadena;
        return true;
    end if;
  return false;
END;
$$;

ALTER FUNCTION comun.contiene_findelinea(p_cadena text) OWNER TO tedede_php;

CREATE  or replace FUNCTION comun.extraer_identificadores(p_texto text) RETURNS SETOF text
    LANGUAGE plpgsql
    AS $_$
DECLARE
    v_operadores_logicos_regexp   text;
    v_pg_identifica_var_regexp    text;             
BEGIN
    --variables definidas en consistencias.php y utilizadas como pattern para buscar nombre de variables en proceso_compilar_consistencia.php
    v_operadores_logicos_regexp='or|and|is|end|in|not|true|false|null|case|when|else';
    v_pg_identifica_var_regexp='([A-Za-z][A-Za-z_.0-9]*)(\s*)($|[-+)<=>,*/!|]|\s(\m(is null|is true|is false|{'||v_operadores_logicos_regexp||'})\M))';
    return query SELECT distinct x.v_ident  
                        from (select (regexp_matches(p_texto, v_pg_identifica_var_regexp, 'g'))[1] as v_ident) as x;                  
END;
$_$;


ALTER FUNCTION comun.extraer_identificadores(p_texto text) OWNER TO tedede_php;

CREATE or replace FUNCTION dbo.largo_cadena(cvalor text) RETURNS integer
    LANGUAGE sql IMMUTABLE
    AS $_$SELECT length($1)$_$;


ALTER FUNCTION dbo.largo_cadena(cvalor text) OWNER TO tedede_php;

CREATE or replace FUNCTION dbo.edadjefe(p_enc integer, p_nhogar integer) RETURNS integer
    LANGUAGE sql STABLE
    AS $$
  select pla_edad 
      from encu.plana_s1_p 
      where pla_enc = p_enc and pla_hog = p_nhogar and pla_p10=1
      limit 1;
$$;


CREATE OR REPLACE FUNCTION dbo.edadjefe(
    p_enc integer,
    p_nhogar integer)
  RETURNS integer AS
$BODY$
  select pla_edad 
      from encu.plana_s1_p 
      where pla_enc = p_enc and pla_hog = p_nhogar and pla_p10=1
      limit 1;
$BODY$
  LANGUAGE sql STABLE
  COST 100;
ALTER FUNCTION dbo.edadjefe(p_enc integer, p_nhogar integer) OWNER TO tedede_php;


CREATE or replace FUNCTION dbo.existejefe(p_enc integer, p_hog integer) RETURNS integer
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE v_cantjefes integer;
BEGIN
    v_cantjefes := count(*) from encu.respuestas where res_ope=dbo.ope_actual() and res_for='S1' and res_mat='P' and res_enc = p_enc and res_hog = p_hog and res_var = 'p10' and res_valor ='1';
    if (v_cantjefes > 1) then
      v_cantjefes := 2;
    end if;
    return v_cantjefes;
END;
$$;


ALTER FUNCTION dbo.existejefe(p_enc integer, p_hog integer) OWNER TO tedede_php;


CREATE or replace FUNCTION dbo.parentescofamiliar(p_enc integer, p_hog integer, p_mie integer) RETURNS integer
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE v_p10 integer;
BEGIN
    select res_valor::integer into v_p10 
      from encu.respuestas 
      where res_ope=dbo.ope_actual() and res_for='S1' and res_mat='P' and res_enc = p_enc and res_hog = p_hog and res_mie=p_mie and res_var = 'p10';
    if v_p10 is not null then
        return v_p10;
    else
        return 0;
    end if;	
END;
$$;


ALTER FUNCTION dbo.parentescofamiliar(p_enc integer, p_hog integer, p_mie integer) OWNER TO tedede_php;


CREATE OR REPLACE FUNCTION dbo.sexojefe(p_enc integer, p_hog integer) RETURNS integer
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE v_sexojefe integer;
BEGIN
    select res_valor::integer into v_sexojefe 
      from encu.respuestas where res_ope=dbo.ope_actual() and res_for='S1' and res_mat='P' and
       res_enc = p_enc and res_hog = p_hog and res_var = 'sexo' and
       res_mie in (select res_mie from encu.respuestas where res_ope=dbo.ope_actual() and res_for='S1' and res_mat='P' and res_enc = p_enc and res_hog = p_hog and res_var = 'p10' and (res_valor ='1' ) limit 1);
    return v_sexojefe;
END;
$$;

ALTER FUNCTION dbo.sexojefe(p_enc integer, p_hog integer) OWNER TO tedede_php;