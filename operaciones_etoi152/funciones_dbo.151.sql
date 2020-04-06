--
-- TOC entry 7 (class 2615 OID 623113)
-- Name: dbo; Type: SCHEMA; Schema: -; Owner: tedede_php
--


SET search_path = dbo, pg_catalog,encu;

--
-- TOC entry 478 (class 1255 OID 623171)
-- Name: anio(); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION anio() RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $$
begin
    return 2015;
end;
$$;


ALTER FUNCTION dbo.anio() OWNER TO tedede_php;

--
-- TOC entry 476 (class 1255 OID 623172)
-- Name: anionac(integer, integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION anionac(p_enc integer, p_hog integer, p_mie integer) RETURNS integer
    LANGUAGE sql STABLE
    AS $$
    select pla_f_nac_a 
      from plana_s1_p
      where pla_enc = p_enc and pla_hog = p_hog and pla_mie = p_mie;
$$;


ALTER FUNCTION dbo.anionac(p_enc integer, p_hog integer, p_mie integer) OWNER TO tedede_php;

--
-- TOC entry 479 (class 1255 OID 623173)
-- Name: cadena_normalizar(text); Type: FUNCTION; Schema: dbo; Owner: tedede_owner
--

CREATE OR REPLACE FUNCTION cadena_normalizar(p_cadena text) RETURNS text
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
-- TOC entry 480 (class 1255 OID 623174)
-- Name: cant_a1(integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION cant_a1(p_enc integer) RETURNS bigint
    LANGUAGE sql STABLE
    AS $$
  select count(cla_hog)
    from encu.claves 
    where cla_ope=dbo.ope_actual() and cla_for='A1' and cla_mat='' and cla_enc=p_enc ;
$$;


ALTER FUNCTION dbo.cant_a1(p_enc integer) OWNER TO tedede_php;

--
-- TOC entry 481 (class 1255 OID 623175)
-- Name: cant_hog_norea_con_motivo(integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION cant_hog_norea_con_motivo(p_enc integer) RETURNS integer
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
-- TOC entry 482 (class 1255 OID 623176)
-- Name: cant_hog_rea(integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION cant_hog_rea(p_enc integer) RETURNS bigint
    LANGUAGE sql IMMUTABLE
    AS $_$
  select count(pla_hog)
    from encu.plana_s1_ 
    where pla_enc = $1
      and pla_entrea=1;
$_$;


ALTER FUNCTION dbo.cant_hog_rea(p_enc integer) OWNER TO tedede_php;

--
-- TOC entry 483 (class 1255 OID 623177)
-- Name: cant_hog_tot_sin95(integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION cant_hog_tot_sin95(p_enc integer) RETURNS bigint
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
-- TOC entry 484 (class 1255 OID 623178)
-- Name: cant_i1_x_enc(integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION cant_i1_x_enc(p_enc integer) RETURNS bigint
    LANGUAGE sql IMMUTABLE
    AS $_$
  select count(cla_mie)
  from encu.claves where cla_ope=dbo.ope_actual() 
	and cla_for='I1' 
	and cla_enc=$1;
$_$;


ALTER FUNCTION dbo.cant_i1_x_enc(p_enc integer) OWNER TO tedede_php;

--
-- TOC entry 485 (class 1255 OID 623179)
-- Name: cant_i1_x_hog(integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION cant_i1_x_hog(p_enc integer, p_hog integer) RETURNS integer
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
-- TOC entry 486 (class 1255 OID 623180)
-- Name: cant_menores(integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION cant_menores(p_enc integer, p_hog integer) RETURNS integer
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
-- TOC entry 487 (class 1255 OID 623181)
-- Name: cant_menores(integer, integer, integer); Type: FUNCTION; Schema: dbo; Owner: postgres
--

CREATE OR REPLACE FUNCTION cant_menores(p_enc integer, p_hog integer, p_edad integer) RETURNS integer
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
-- TOC entry 488 (class 1255 OID 623182)
-- Name: cant_pg1m_x_hog(integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION cant_pg1m_x_hog(p_enc integer, p_hog integer) RETURNS integer
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
 v_cantidad integer;
BEGIN 
  select count(*) into v_cantidad 
  from encu.plana_pg1_m where pla_enc=p_enc and pla_hog=p_hog;
  return v_cantidad;
END;
$$;


ALTER FUNCTION dbo.cant_pg1m_x_hog(p_enc integer, p_hog integer) OWNER TO tedede_php;

--
-- TOC entry 489 (class 1255 OID 623183)
-- Name: cant_registros_exm(integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION cant_registros_exm(p_enc integer, p_hog integer) RETURNS integer
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
-- TOC entry 490 (class 1255 OID 623184)
-- Name: cant_s1p_x_hog(integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION cant_s1p_x_hog(p_enc integer, p_hog integer) RETURNS integer
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
-- TOC entry 491 (class 1255 OID 623185)
-- Name: cantex(integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION cantex(p_enc integer, p_hog integer) RETURNS integer
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
-- TOC entry 492 (class 1255 OID 623186)
-- Name: dic_parte(text, text, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_owner
--

CREATE OR REPLACE FUNCTION dic_parte(p_dic text, p_origen text, p_destino integer) RETURNS boolean
    LANGUAGE sql
    AS $$
  select p_origen ~* 
    ('(\m' || coalesce((select string_agg(dictra_ori, '\M|\m') 
      from encu.dictra
      where dictra_dic=p_dic and dictra_des=p_destino),'')|| '\M)' )
$$;


ALTER FUNCTION dbo.dic_parte(p_dic text, p_origen text, p_destino integer) OWNER TO tedede_owner;

--
-- TOC entry 493 (class 1255 OID 623187)
-- Name: dic_tradu(text, text); Type: FUNCTION; Schema: dbo; Owner: tedede_owner
--

CREATE OR REPLACE FUNCTION dic_tradu(p_dic text, p_origen text) RETURNS integer
    LANGUAGE sql
    AS $$
  select dictra_des from encu.dictra where dictra_dic=p_dic and dictra_ori=dbo.cadena_normalizar(p_origen)
$$;


ALTER FUNCTION dbo.dic_tradu(p_dic text, p_origen text) OWNER TO tedede_owner;

--
-- TOC entry 494 (class 1255 OID 623188)
-- Name: dma_a_fecha(integer, integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION dma_a_fecha(p_dia integer, p_mes integer, p_annio integer) RETURNS date
    LANGUAGE plpgsql IMMUTABLE
    AS $$
begin 
 return to_date(p_annio||'/'||p_mes||'/'||p_dia,'YYYY/MM/DD');
end;
$$;


ALTER FUNCTION dbo.dma_a_fecha(p_dia integer, p_mes integer, p_annio integer) OWNER TO tedede_php;

--
-- TOC entry 495 (class 1255 OID 623189)
-- Name: edad_a_la_fecha(text, text); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION edad_a_la_fecha(p_f_nac text, p_f_realiz text) RETURNS integer
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
-- TOC entry 496 (class 1255 OID 623190)
-- Name: edad_participacion_anterior(integer, integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION edad_participacion_anterior(enc integer, hogar integer, miembro integer) RETURNS integer
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
-- TOC entry 497 (class 1255 OID 623191)
-- Name: edadfamiliar(integer, integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION edadfamiliar(p_enc integer, p_hog integer, p_mie integer) RETURNS integer
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
-- TOC entry 498 (class 1255 OID 623192)
-- Name: edadjefe(integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION edadjefe(p_enc integer, p_nhogar integer) RETURNS integer
    LANGUAGE sql STABLE
    AS $$
  select pla_edad 
      from encu.plana_s1_p 
      where pla_enc = p_enc and pla_hog = p_nhogar and pla_p4=1
      limit 1;
$$;


ALTER FUNCTION dbo.edadjefe(p_enc integer, p_nhogar integer) OWNER TO tedede_php;

--
-- TOC entry 499 (class 1255 OID 623193)
-- Name: es_fecha(text); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION es_fecha(valor text) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $$
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
  v_anio_actual := extract (year from current_date)::integer;
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
-- TOC entry 500 (class 1255 OID 623194)
-- Name: estadofamiliar(integer, integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION estadofamiliar(p_enc integer, p_hog integer, p_mie integer) RETURNS integer
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE v_estado integer;
BEGIN
	v_estado := 0;
	select res_valor from encu.respuestas
	where res_ope=dbo.ope_actual() and res_for='S1' and res_mat='P' and res_enc = p_enc and res_hog = p_hog and res_mie = p_mie and res_var = 'p5b' into v_estado;
	return v_estado;
END;
$$;


ALTER FUNCTION dbo.estadofamiliar(p_enc integer, p_hog integer, p_mie integer) OWNER TO tedede_php;

--
-- TOC entry 501 (class 1255 OID 623195)
-- Name: estadojefe(integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION estadojefe(p_enc integer, p_hog integer) RETURNS integer
    LANGUAGE plpgsql STABLE
    AS $$
declare v_estadojefe text;
begin
    select res_valor into v_estadojefe from encu.respuestas 
    where res_ope=dbo.ope_actual() and res_for='S1' and res_mat='P' and res_enc = p_enc and res_hog = p_hog and res_var = 'p5' and res_mie in (select res_mie from encu.respuestas where res_enc=p_enc and res_hog=p_hog and res_var ='p4' and (res_valor ='1') limit 1);
    return v_estadojefe;
end;
$$;


ALTER FUNCTION dbo.estadojefe(p_enc integer, p_hog integer) OWNER TO tedede_php;

--
-- TOC entry 502 (class 1255 OID 623196)
-- Name: existe_a1(integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION existe_a1(enc integer, hog integer) RETURNS bigint
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
-- TOC entry 503 (class 1255 OID 623197)
-- Name: existe_hogar(integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION existe_hogar(p_enc integer, p_hog integer) RETURNS integer
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE v_existe integer;
BEGIN
    v_existe := count(distinct (res_hog)) from encu.respuestas where res_ope=dbo.ope_actual() and res_enc = p_enc and res_hog = p_hog;
    return v_existe;
END;
$$;


ALTER FUNCTION dbo.existe_hogar(p_enc integer, p_hog integer) OWNER TO tedede_php;

--
-- TOC entry 504 (class 1255 OID 623198)
-- Name: existe_s1(integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION existe_s1(enc integer) RETURNS integer
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
-- TOC entry 505 (class 1255 OID 623199)
-- Name: existeindividual(integer, integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION existeindividual(enc integer, hog integer, mie integer) RETURNS bigint
    LANGUAGE sql STABLE
    AS $_$
  	select count(distinct(pla_mie)) from encu.plana_i1_ 
		where pla_enc = $1 
		and pla_hog = $2 
		and pla_mie = $3;
$_$;


ALTER FUNCTION dbo.existeindividual(enc integer, hog integer, mie integer) OWNER TO tedede_php;

--
-- TOC entry 506 (class 1255 OID 623200)
-- Name: existejefe(integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION existejefe(p_enc integer, p_hog integer) RETURNS integer
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
-- TOC entry 507 (class 1255 OID 623201)
-- Name: existemiembro(integer, integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION existemiembro(p_enc integer, p_hog integer, p_mie integer) RETURNS integer
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
-- TOC entry 514 (class 1255 OID 623202)
-- Name: fam_serv_dom(integer, integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--
/*
CREATE OR REPLACE FUNCTION fam_serv_dom(p_enc integer, p_hog integer, p_mie integer) RETURNS boolean
    LANGUAGE sql
    AS $$
SELECT case when m.pla_p4=13 then true when m.pla_p4=14 then
          (
           SELECT true
             FROM encu.plana_s1_p p -- pariente
             WHERE p.pla_enc=m.pla_enc
               AND p.pla_hog=m.pla_hog
               AND p.pla_p4 = 13 
               AND (p.pla_mie = m.pla_p5b OR p.pla_mie = m.pla_p6_a OR p.pla_mie = m.pla_p6_b
                   OR m.pla_mie = p.pla_p5b OR m.pla_mie = p.pla_p6_a OR m.pla_mie = p.pla_p6_b)
           LIMIT 1
          ) is true
       else false end
  FROM encu.plana_s1_p m
  WHERE m.pla_enc=p_enc
    AND m.pla_hog=p_hog
    AND m.pla_mie=p_mie;
$$;


ALTER FUNCTION dbo.fam_serv_dom(p_enc integer, p_hog integer, p_mie integer) OWNER TO tedede_php;
*/
--
-- TOC entry 515 (class 1255 OID 623203)
-- Name: fecha_30junio(); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION fecha_30junio() RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
begin
	return '30/06/'||dbo.anio()::text;
end;
$$;


ALTER FUNCTION dbo.fecha_30junio() OWNER TO tedede_php;

--
-- TOC entry 516 (class 1255 OID 623204)
-- Name: form_familiar(); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION form_familiar() RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
begin
	return 'S1';
end;
$$;


ALTER FUNCTION dbo.form_familiar() OWNER TO tedede_php;

--
-- TOC entry 517 (class 1255 OID 623205)
-- Name: madre_con_hijos_mayor_de(integer, integer, integer, integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION madre_con_hijos_mayor_de(p_enc integer, p_hog integer, p_mie integer, p_edad integer, p_unidad_tiempo integer) RETURNS boolean
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
 v_respuesta boolean;
BEGIN 
  case p_unidad_tiempo
     when 1 then
	  select case when count(pla_mie)>0 then true else false end into v_respuesta from encu.plana_s1_p where pla_enc = p_enc and pla_hog = p_hog and pla_p6_b = p_mie and pla_edad > p_edad;
     when 2 then
	  select case when count(p.pla_mie)>0 then true else false end into v_respuesta from encu.plana_s1_p p
                                                                                           inner join encu.plana_s1_ s on p.pla_enc = s.pla_enc and p.pla_hog = s.pla_hog
                                                                                           where p.pla_enc = p_enc and p.pla_hog = p_hog and p.pla_p6_b = p_mie 
                                                                                           and dbo.meses_a_la_fecha(fechadma(pla_f_nac_d,pla_f_nac_m,pla_f_nac_a), pla_f_realiz_o) > p_edad;
     else
	v_respuesta:=false;
  end case;
  return v_respuesta;
END;
$$;


ALTER FUNCTION dbo.madre_con_hijos_mayor_de(p_enc integer, p_hog integer, p_mie integer, p_edad integer, p_unidad_tiempo integer) OWNER TO tedede_php;

--
-- TOC entry 518 (class 1255 OID 623206)
-- Name: madre_con_hijos_menor_de(integer, integer, integer, integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION madre_con_hijos_menor_de(p_enc integer, p_hog integer, p_mie integer, p_edad integer, p_unidad_tiempo integer) RETURNS boolean
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
 v_respuesta boolean;
BEGIN 
  case p_unidad_tiempo
     when 1 then
	  select case when count(pla_mie)>0 then true else false end into v_respuesta from encu.plana_s1_p where pla_enc = p_enc and pla_hog = p_hog and pla_p6_b = p_mie and pla_edad < p_edad;
     when 2 then
	  select case when count(p.pla_mie)>0 then true else false end into v_respuesta from encu.plana_s1_p p                                                                                           inner join encu.plana_s1_ s on p.pla_enc = s.pla_enc and p.pla_hog = s.pla_hog                                                                                           where p.pla_enc = p_enc and p.pla_hog = p_hog and p.pla_p6_b = p_mie                                                                                            and dbo.meses_a_la_fecha(                                                                                           fechadma(pla_f_nac_d, pla_f_nac_m,pla_f_nac_a)                                                                                           , pla_f_realiz_o) < p_edad;
     else
	  v_respuesta:=false;
  end case;
  return v_respuesta;
END;
$$;


ALTER FUNCTION dbo.madre_con_hijos_menor_de(p_enc integer, p_hog integer, p_mie integer, p_edad integer, p_unidad_tiempo integer) OWNER TO tedede_php;

--
-- TOC entry 477 (class 1255 OID 623207)
-- Name: max_hog_ingresado(integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION max_hog_ingresado(p_enc integer) RETURNS integer
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
-- TOC entry 625 (class 1255 OID 716840)
-- Name: max_mie_ingresado(integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION max_mie_ingresado(p_enc integer, p_hog integer) RETURNS integer
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
 v_mie_max integer;
BEGIN 
  select max(pla_mie) into v_mie_max
  from encu.plana_s1_p where pla_enc=p_enc and pla_hog=p_hog;
  return v_mie_max;
END;
$$;


ALTER FUNCTION dbo.max_mie_ingresado(p_enc integer, p_hog integer) OWNER TO tedede_php;

--
-- TOC entry 522 (class 1255 OID 623208)
-- Name: mediana_expandida(text, text); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION mediana_expandida(p_variable text, p_filtro text) RETURNS numeric
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
-- TOC entry 523 (class 1255 OID 623209)
-- Name: mediana_expandida_agrupada(text, text, text, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION mediana_expandida_agrupada(p_variable text, p_filtro text, p_groupby text, p_valor integer) RETURNS numeric
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
-- TOC entry 524 (class 1255 OID 623210)
-- Name: no_coin_c(integer, integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--
/*
CREATE OR REPLACE FUNCTION no_coin_c(p_enc integer, p_hog integer, p_mie integer) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
    SELECT m.pla_p5 in (1,2) is true <> (m.pla_p5b<>95) is true  
        OR m.pla_p5 in (1,2) is true AND c.pla_p5b is distinct from m.pla_mie 
        OR m.pla_p5 in (1,2) is true AND m.pla_p5 is distinct from c.pla_p5 
      FROM encu.plana_s1_p m 
        LEFT JOIN encu.plana_s1_p c 
          ON m.pla_enc=c.pla_enc 
            AND m.pla_hog=c.pla_hog 
            AND m.pla_p5b=c.pla_mie 
            AND m.pla_exm=c.pla_exm -- !PK verificada
      WHERE m.pla_enc=p_enc
        AND m.pla_hog=p_hog
        AND m.pla_mie=p_mie;
$$;


ALTER FUNCTION dbo.no_coin_c(p_enc integer, p_hog integer, p_mie integer) OWNER TO tedede_php;
*/
--
-- TOC entry 525 (class 1255 OID 623211)
-- Name: norea_recuperable(integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION norea_recuperable(p_norea integer) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $$
 select p_norea = 10 or (p_norea >=70 and p_norea not in (91,95,96));
$$;


ALTER FUNCTION dbo.norea_recuperable(p_norea integer) OWNER TO tedede_php;

--
-- TOC entry 526 (class 1255 OID 623212)
-- Name: norea_supervisable(integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION norea_supervisable(p_norea integer) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $$
 select p_norea in (91,95,96) or (p_norea not in (10,18) and (p_norea <70));
$$;


ALTER FUNCTION dbo.norea_supervisable(p_norea integer) OWNER TO tedede_php;

--
-- TOC entry 527 (class 1255 OID 623213)
-- Name: nroconyuges(integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION nroconyuges(p_enc integer, p_hog integer) RETURNS integer
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
-- TOC entry 528 (class 1255 OID 623214)
-- Name: nrojefes(integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION nrojefes(p_enc integer, p_hog integer) RETURNS integer
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
-- TOC entry 532 (class 1255 OID 623215)
-- Name: ope_actual(); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION ope_actual() RETURNS text
    LANGUAGE plpgsql IMMUTABLE
    AS $$
begin
    return 'etoi152';
end;
$$;


ALTER FUNCTION dbo.ope_actual() OWNER TO tedede_php;

--
-- TOC entry 529 (class 1255 OID 623216)
-- Name: p5bfamiliar(integer, integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION p5bfamiliar(p_enc integer, p_hog integer, p_mie integer) RETURNS integer
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
-- TOC entry 530 (class 1255 OID 623217)
-- Name: p7_min(integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION p7_min(p_enc integer, p_hog integer) RETURNS integer
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
-- TOC entry 531 (class 1255 OID 623218)
-- Name: recalcular_mie_bu(integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--
/*
CREATE OR REPLACE FUNCTION recalcular_mie_bu(p_enc integer) RETURNS void
    LANGUAGE sql
    AS $$
     update plana_i1_ i
         set pla_mie_bu = x.mie_bu
         from 
           (select s.pla_enc, s.pla_hog, s.pla_mie, s.pla_p4, rank() OVER (PARTITION BY s.pla_enc, s.pla_hog ORDER BY s.pla_p4 = 1 DESC, s.pla_mie) AS mie_bu
            from encu.plana_s1_p s
            inner join encu.plana_i1_ i on i.pla_enc=s.pla_enc and i.pla_hog=s.pla_hog and i.pla_mie=s.pla_mie where s.pla_enc = p_enc) x
         where i.pla_enc = x.pla_enc and i.pla_hog = x.pla_hog and i.pla_mie = x.pla_mie
$$;


ALTER FUNCTION dbo.recalcular_mie_bu(p_enc integer) OWNER TO tedede_php;
*/
--
-- TOC entry 508 (class 1255 OID 623219)
-- Name: sexo_participacion_anterior(integer, integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION sexo_participacion_anterior(enc integer, hogar integer, miembro integer) RETURNS integer
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
-- TOC entry 509 (class 1255 OID 623220)
-- Name: sexofamiliar(integer, integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION sexofamiliar(p_enc integer, p_hog integer, p_mie integer) RETURNS integer
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
-- TOC entry 510 (class 1255 OID 623221)
-- Name: sexojefe(integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION sexojefe(p_enc integer, p_hog integer) RETURNS integer
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
-- TOC entry 511 (class 1255 OID 623222)
-- Name: suma_md(integer, integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION suma_md(p_enc integer, p_hog integer, p_mie integer) RETURNS integer
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
-- TOC entry 533 (class 1255 OID 623223)
-- Name: suma_t1at54b(integer, integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION suma_t1at54b(p_enc integer, p_hog integer, p_mie integer) RETURNS integer
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
-- TOC entry 534 (class 1255 OID 623224)
-- Name: suma_t28a54b(integer, integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION suma_t28a54b(p_enc integer, p_hog integer, p_mie integer) RETURNS integer
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
-- TOC entry 535 (class 1255 OID 623225)
-- Name: sumah3(integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION sumah3(p_enc integer) RETURNS integer
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
-- TOC entry 536 (class 1255 OID 623226)
-- Name: texto_a_fecha(text); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION texto_a_fecha(p_valor text) RETURNS date
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
-- TOC entry 537 (class 1255 OID 623227)
-- Name: textoinformado(character varying); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION textoinformado(p_valor character varying) RETURNS integer
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
-- TOC entry 538 (class 1255 OID 623228)
-- Name: textoinformado(integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION textoinformado(p_valor integer) RETURNS integer
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
-- TOC entry 539 (class 1255 OID 623229)
-- Name: textoinformado(text); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION textoinformado(p_valor text) RETURNS integer
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
-- TOC entry 540 (class 1255 OID 623230)
-- Name: tiene_hijo(integer, integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION tiene_hijo(p_enc integer, p_hog integer, p_mie integer) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
 v_cantidad integer; 
BEGIN 
  select count(*) into v_cantidad
    from encu.plana_s1_p s1p 
    where pla_enc=p_enc and pla_hog=p_hog  and (pla_p6_a=p_mie or pla_p6_b=p_mie);
  if v_cantidad>0 then
     return TRUE;
  else
     return FALSE;
  end if;
END;
$$;


ALTER FUNCTION dbo.tiene_hijo(p_enc integer, p_hog integer, p_mie integer) OWNER TO tedede_php;

--
-- TOC entry 542 (class 1255 OID 623231)
-- Name: tipo_hogar(integer, integer, integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--
/*
CREATE OR REPLACE FUNCTION tipo_hogar(p_enc integer, p_hog integer, p_variante integer) RETURNS integer
    LANGUAGE sql
    AS $$
select case when p_variante=7 then split_part(tipo_hogar_7, ' ', 1)::integer else -5 end
from (
select 
   case when miembros<>jefes+parejas+hijos+otros_familiares+no_familiares+serv_dom then 'Miembros ' else '' end 
    || case when hijos<>hijos_solteros+hijos_no_solteros then 'Hijos ' else '' end 
    || case when hijos_solteros<>hijos_solteros_sin_hijos+hijos_solteros_con_hijos then 'HSolteros ' else '' end 
    || case when hijos<>hijos_solteros_sin_hijos+otros_hijos then 'OHijos' else '' end as controles
   , case when miembros-serv_dom=1 then '1 No Fam Unipersonal' 
          when miembros-serv_dom-no_familiares=1 then '2 No Fam Multipersonal'
          when parejas>0 and otros_familiares=0 and no_familiares=0 and otros_hijos=0 then '3 Fam Nuclear de Nucleo completo'
          when parejas=0 and hijos_solteros_sin_hijos>0 and otros_familiares=0 and no_familiares=0 and otros_hijos=0 then '4 Fam Nuclear de Nucleo incompleto'
          when parejas>0 and otros_familiares+no_familiares+otros_hijos>0 then '5 Fam Extendido y Complejo de Nucleo completo'
          when parejas=0 and hijos_solteros_sin_hijos>0 and otros_familiares+no_familiares+otros_hijos>0 then '6 Fam Extendido y Complejo de Nucleo incompleto'
          when parejas=0 and hijos_solteros_sin_hijos=0 and otros_familiares+otros_hijos>0 then '7 Fam Extendido y Complejo sin Nucleo'
          else '-5 error' end as tipo_hogar_7 
   , *
from (
select pla_enc, pla_hog
       , sum(1) as miembros
       , sum(case when pla_p4=1 then 1 else 0 end) as jefes
       , sum(case when pla_p4=2 then 1 else 0 end) as parejas
       , sum(case when pla_p4 in (3,4) then 1 else 0 end) as hijos
       , sum(case when pla_p4 in (3,4) and (pla_p5=8 or pla_p5 is null) then 1 else 0 end) as hijos_solteros
       , sum(case when pla_p4 in (3,4) and (pla_p5=8 or pla_p5 is null) and cantidad_hijos is null then 1 else 0 end) as hijos_solteros_sin_hijos
       , sum(case when pla_p4 in (3,4) and (pla_p5=8 or pla_p5 is null) and cantidad_hijos>0 then 1 else 0 end) as hijos_solteros_con_hijos
       , sum(case when pla_p4 in (3,4) and (pla_p5<>8) then 1 else 0 end) as hijos_no_solteros
       , sum(case when pla_p4 in (3,4) and ((pla_p5<>8) or cantidad_hijos>0) then 1 else 0 end) as otros_hijos
       , sum(case when pla_p4 in (5,6,7,8,9,10,11,12) then 1 else 0 end) as otros_familiares
       , sum(case when pla_p4 in (14) and not dbo.fam_serv_dom(pla_enc, pla_hog, pla_mie) then 1 else 0 end) as no_familiares
       , sum(case when dbo.fam_serv_dom(pla_enc, pla_hog, pla_mie) then 1 else 0 end) as serv_dom
  from (
         select m.*, (select sum(1) from encu.plana_s1_p h where h.pla_enc=m.pla_enc and h.pla_hog=m.pla_hog and (h.pla_p6_a=m.pla_mie or h.pla_p6_b=m.pla_mie)) cantidad_hijos
           from encu.plana_s1_p m inner join encu.plana_i1_ i on m.pla_enc=i.pla_enc and m.pla_hog=i.pla_hog and m.pla_mie=i.pla_mie
	   -- where m.pla_enc<=130100 
	   where m.pla_enc=p_enc and m.pla_hog=p_hog
	   order by 1,2,3
        ) x
  group by pla_enc,pla_hog
) y
) z
--else -5 end
-- where controles<>'' or tipo_hogar='-5 error'
$$;


ALTER FUNCTION dbo.tipo_hogar(p_enc integer, p_hog integer, p_variante integer) OWNER TO tedede_php;
*/
--
-- TOC entry 543 (class 1255 OID 623232)
-- Name: total_hogares(integer); Type: FUNCTION; Schema: dbo; Owner: tedede_php
--

CREATE OR REPLACE FUNCTION total_hogares(p_enc integer) RETURNS integer
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

-- Completed on 2015-03-12 12:07:27

--
-- PostgreSQL database dump complete
--

