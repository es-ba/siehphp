--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: dbo; Type: SCHEMA; Schema: -; Owner: yeahowner
--

CREATE SCHEMA dbo;


ALTER SCHEMA dbo OWNER TO yeahowner;

--
-- Name: yeah; Type: SCHEMA; Schema: -; Owner: yeahowner
--

CREATE SCHEMA yeah;


ALTER SCHEMA yeah OWNER TO yeahowner;

SET search_path = dbo, pg_catalog;

--
-- Name: anio(); Type: FUNCTION; Schema: dbo; Owner: yeahowner
--

CREATE FUNCTION anio() RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	return 2011;
end;
$$;


ALTER FUNCTION dbo.anio() OWNER TO yeahowner;

--
-- Name: anionac(integer, integer, integer); Type: FUNCTION; Schema: dbo; Owner: yeahowner
--

CREATE FUNCTION anionac(p_id integer, p_nhogar integer, p_miembro integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$declare v_annio integer;begin	v_annio := 0;	select extract(year from to_date(f_nac_o, 'DD/MM/YYYY')) from yeah_2011.eah11_fam where nenc = p_id and nhogar = p_nhogar and p0 = p_miembro into v_annio;	return v_annio;	EXCEPTION  WHEN invalid_datetime_format THEN    return 0;end;$$;


ALTER FUNCTION dbo.anionac(p_id integer, p_nhogar integer, p_miembro integer) OWNER TO yeahowner;

--
-- Name: cantex(integer, integer); Type: FUNCTION; Schema: dbo; Owner: yeahowner
--

CREATE FUNCTION cantex(p_encues integer, p_nhogar integer) RETURNS integer
    LANGUAGE plpgsql STABLE
    AS $$
--devuelve un count de la tabla ExMiembro? para un ID , hogar
DECLARE
 v_cantidad integer;
BEGIN 
  SELECT count(*) into v_cantidad
    from eah11_ex 
    where nenc=p_encues
      and nhogar=p_nhogar;
  return v_cantidad;
END;
$$;


ALTER FUNCTION dbo.cantex(p_encues integer, p_nhogar integer) OWNER TO yeahowner;

--
-- Name: dma_a_fecha(integer, integer, integer); Type: FUNCTION; Schema: dbo; Owner: yeahowner
--

CREATE FUNCTION dma_a_fecha(p_dia integer, p_mes integer, p_annio integer) RETURNS date
    LANGUAGE plpgsql IMMUTABLE
    AS $$
begin
 return to_date(p_annio||'/'||p_mes||'/'||p_dia,'YYYY/MM/DD');
end;
$$;


ALTER FUNCTION dbo.dma_a_fecha(p_dia integer, p_mes integer, p_annio integer) OWNER TO yeahowner;

--
-- Name: edad_a_la_fecha(text, text); Type: FUNCTION; Schema: dbo; Owner: yeahowner
--

CREATE FUNCTION edad_a_la_fecha(p_f_nac text, p_f_realiz text) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $$declare 	v_edad integer;begin  if dbo.texto_a_fecha(p_f_nac) > dbo.texto_a_fecha(p_f_realiz) then     return null;  end if;  v_edad=extract(year from age(dbo.texto_a_fecha(p_f_realiz),dbo.texto_a_fecha(p_f_nac)));  if v_edad>130 or v_edad<0 then    return null;  end if;  return v_edad;EXCEPTION  WHEN invalid_datetime_format THEN    return null;  WHEN datetime_field_overflow THEN    return null;end;$$;


ALTER FUNCTION dbo.edad_a_la_fecha(p_f_nac text, p_f_realiz text) OWNER TO yeahowner;

--
-- Name: edadfamiliar(integer, integer, integer); Type: FUNCTION; Schema: dbo; Owner: yeahowner
--

CREATE FUNCTION edadfamiliar(p_id integer, p_nhogar integer, p_miembro integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$declare v_edad integer;begin	v_edad := 0;	select edad from yeah_2011.eah11_fam where nenc = p_id and nhogar = p_nhogar and p0 = p_miembro into v_edad;	return v_edad;	end;$$;


ALTER FUNCTION dbo.edadfamiliar(p_id integer, p_nhogar integer, p_miembro integer) OWNER TO yeahowner;

--
-- Name: edadjefe(integer, integer); Type: FUNCTION; Schema: dbo; Owner: yeahowner
--

CREATE FUNCTION edadjefe(p_id integer, p_nhogar integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$declare v_edad_jefe integer;begin	v_edad_jefe := 0;	select edad from yeah_2011.eah11_fam where p4=1 and nenc = p_id and nhogar = p_nhogar into v_edad_jefe;	return v_edad_jefe;	end;$$;


ALTER FUNCTION dbo.edadjefe(p_id integer, p_nhogar integer) OWNER TO yeahowner;

--
-- Name: es_fecha(text); Type: FUNCTION; Schema: dbo; Owner: yeahowner
--

CREATE FUNCTION es_fecha(valor text) RETURNS integer
    LANGUAGE plpgsql
    AS $$DECLARE  v_fecha date;BEGIN  if valor is null then    return 0;  end if;    v_fecha:=to_Date(valor,'DD/MM/YYYY');  return 1;EXCEPTION  WHEN invalid_datetime_format THEN    return 0;  WHEN datetime_field_overflow THEN    return 0;     END;$$;


ALTER FUNCTION dbo.es_fecha(valor text) OWNER TO yeahowner;

--
-- Name: estadofamiliar(integer, integer, integer); Type: FUNCTION; Schema: dbo; Owner: yeahowner
--

CREATE FUNCTION estadofamiliar(p_id integer, p_nhogar integer, p_miembro integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$declare v_estado integer;begin	v_estado := 0;	select p5b from yeah_2011.eah11_fam where nenc = p_id and nhogar = p_nhogar and p0 = p_miembro into v_estado;	return v_estado;	end;$$;


ALTER FUNCTION dbo.estadofamiliar(p_id integer, p_nhogar integer, p_miembro integer) OWNER TO yeahowner;

--
-- Name: estadojefe(integer, integer); Type: FUNCTION; Schema: dbo; Owner: yeahowner
--

CREATE FUNCTION estadojefe(p_enc integer, p_hogar integer) RETURNS integer
    LANGUAGE plpgsql STABLE
    AS $$declare 	v_res integer;begin    select p5 into v_res from yeah_2011.eah11_fam where nenc = p_enc and nhogar = p_hogar and p4 = 1;    return v_res;end;$$;


ALTER FUNCTION dbo.estadojefe(p_enc integer, p_hogar integer) OWNER TO yeahowner;

--
-- Name: existe_hogar(integer, integer); Type: FUNCTION; Schema: dbo; Owner: yeahowner
--

CREATE FUNCTION existe_hogar(p_encues integer, p_nhogar integer) RETURNS integer
    LANGUAGE plpgsql STABLE
    AS $$
--devuelve un 1 si existe el hogar.
DECLARE
 v_existe integer;
BEGIN 
  SELECT 1 into v_existe
    from eah11_viv_s1a1 
    where nenc=p_encues
      and nhogar=p_nhogar;
  return coalesce(v_existe,0);
END;
$$;


ALTER FUNCTION dbo.existe_hogar(p_encues integer, p_nhogar integer) OWNER TO yeahowner;

--
-- Name: existejefe(integer, integer); Type: FUNCTION; Schema: dbo; Owner: yeahowner
--

CREATE FUNCTION existejefe(p_encues integer, p_nhogar integer) RETURNS integer
    LANGUAGE plpgsql STABLE
    AS $$
--devuelve un 1 si existe el hogar. 2 si hay más de uno y 0 si no hay ninguno
DECLARE
 v_existe integer;
BEGIN 
  SELECT 1 into  strict v_existe
    from eah11_fam
    where nenc=p_encues
      and nhogar=p_nhogar
      and p4=1;
  return v_existe;
exception
  when too_many_rows then
    return 2;
  when no_data_found then
    return 0;
END;
$$;


ALTER FUNCTION dbo.existejefe(p_encues integer, p_nhogar integer) OWNER TO yeahowner;

--
-- Name: existemiembro(integer, integer, integer); Type: FUNCTION; Schema: dbo; Owner: yeahowner
--

CREATE FUNCTION existemiembro(v_id integer, v_nhogar integer, v_miembro integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$declare v_cant integer;begin	v_cant := 0;	select count(*) from yeah_2011.eah11_i1 where nenc = v_id and nhogar = v_nhogar and miembro = v_miembro into v_cant;	return  v_cant;EXCEPTION  WHEN invalid_text_representation THEN    return 0;	end;$$;


ALTER FUNCTION dbo.existemiembro(v_id integer, v_nhogar integer, v_miembro integer) OWNER TO yeahowner;

--
-- Name: nroconyuges(integer, integer); Type: FUNCTION; Schema: dbo; Owner: yeahowner
--

CREATE FUNCTION nroconyuges(p_enc integer, p_hogar integer) RETURNS integer
    LANGUAGE plpgsql STABLE
    AS $$declare v_nroconyuges integer;begin    v_nroconyuges := count(*) from yeah_2011.eah11_fam where nenc = p_enc and nhogar = p_hogar and p4=2;    return v_nroconyuges;end;$$;


ALTER FUNCTION dbo.nroconyuges(p_enc integer, p_hogar integer) OWNER TO yeahowner;

--
-- Name: nrojefes(integer, integer); Type: FUNCTION; Schema: dbo; Owner: yeahowner
--

CREATE FUNCTION nrojefes(p_enc integer, p_hogar integer) RETURNS integer
    LANGUAGE plpgsql STABLE
    AS $$declare v_cant integer;begin    v_cant :=  count(nenc) from yeah_2011.eah11_fam where nenc = p_enc and nhogar = p_hogar and p4 = 1;    return v_cant;end;$$;


ALTER FUNCTION dbo.nrojefes(p_enc integer, p_hogar integer) OWNER TO yeahowner;

--
-- Name: p5bfamiliar(integer, integer, integer); Type: FUNCTION; Schema: dbo; Owner: yeahowner
--

CREATE FUNCTION p5bfamiliar(p_encues integer, p_nhogar integer, p_miembro integer) RETURNS integer
    LANGUAGE plpgsql STABLE
    AS $$declare 
  v_p5b integer;begin  select P5B 
    into v_p5b 
    from yeah_2011.eah11_fam 
    where nenc = p_encues and nhogar = p_nhogar and p0 = p_miembro;  return v_p5b;end;$$;


ALTER FUNCTION dbo.p5bfamiliar(p_encues integer, p_nhogar integer, p_miembro integer) OWNER TO yeahowner;

--
-- Name: sexofamiliar(integer, integer, integer); Type: FUNCTION; Schema: dbo; Owner: yeahowner
--

CREATE FUNCTION sexofamiliar(p_enc integer, p_hogar integer, p_miembro integer) RETURNS integer
    LANGUAGE plpgsql STABLE
    AS $$declare v_sexo integer;begin    v_sexo :=  sexo from yeah_2011.eah11_fam where nenc = p_enc and nhogar = p_hogar and p0 = p_miembro;    if v_sexo in(1,2) then	return v_sexo;    else	return 0;    end if;	end;$$;


ALTER FUNCTION dbo.sexofamiliar(p_enc integer, p_hogar integer, p_miembro integer) OWNER TO yeahowner;

--
-- Name: sexojefe(integer, integer); Type: FUNCTION; Schema: dbo; Owner: yeahowner
--

CREATE FUNCTION sexojefe(p_enc integer, p_hogar integer) RETURNS integer
    LANGUAGE plpgsql STABLE
    AS $$declare 	v_res integer;begin    select sexo into v_res from yeah_2011.eah11_fam where nenc = p_enc and nhogar = p_hogar and p4 = 1;    return v_res;end;$$;


ALTER FUNCTION dbo.sexojefe(p_enc integer, p_hogar integer) OWNER TO yeahowner;

--
-- Name: suma_md(integer, integer, integer); Type: FUNCTION; Schema: dbo; Owner: yeahowner
--

CREATE FUNCTION suma_md(p_encues integer, p_hogar integer, p_miembro integer) RETURNS integer
    LANGUAGE plpgsql STABLE
    AS $$declare 	v_md integer;beginSELECTcoalesce(md1,0)+coalesce(md2,0)+coalesce(md3,0)+coalesce(md4,0)+coalesce(md5,0)+coalesce(md6,0)+coalesce(md7,0)+coalesce(md8,0)+coalesce(md9,0)+coalesce(md10,0)+coalesce(md11,0)into v_md from yeah_2011.eah11_i1 where nenc = p_encues and nhogar = p_hogar and miembro = p_miembro;return v_md;end;$$;


ALTER FUNCTION dbo.suma_md(p_encues integer, p_hogar integer, p_miembro integer) OWNER TO yeahowner;

--
-- Name: suma_t1at54b(integer, integer, integer); Type: FUNCTION; Schema: dbo; Owner: yeahowner
--

CREATE FUNCTION suma_t1at54b(p_encues integer, p_hogar integer, p_miembro integer) RETURNS integer
    LANGUAGE plpgsql STABLE
    AS $$declare 	v_res integer;beginSELECTcoalesce(t54b,0)+coalesce(t54,0)+coalesce(t53c_meses,0)+coalesce(t53c_anios,0)+coalesce(t53c_98,0)+coalesce(t53_ing,0)+coalesce(t53_bis2,0)+coalesce(t53_bis1_sem,0)+coalesce(t53_bis1_mes,0)+coalesce(t53_bis1,0)+coalesce(t52c,0)+coalesce(t52b,0)+coalesce(t52a,0)+coalesce(t51,0)+coalesce(t50f,0)+coalesce(t50e,0)+coalesce(t50d,0)+coalesce(t50c,0)+coalesce(t50b,0)+coalesce(t50a,0)+coalesce(t49,0)+dbo.textoinformado(t48b_esp)+coalesce(t48b,0)+coalesce(t48a,0)+coalesce(t48,0)+coalesce(t47,0)+coalesce(t46,0)+coalesce(t45,0)+coalesce(t44,0)+dbo.textoinformado(t43)+dbo.textoinformado(t42)+dbo.textoinformado(t41)+coalesce(t40,0)+dbo.textoinformado(t39_otro)+coalesce(t39_bis_cuantos,0)+dbo.textoinformado(t39_bis2_esp)+coalesce(t39_bis2,0)+coalesce(t39_bis,0)+dbo.textoinformado(t39_barrio)+coalesce(t39,0)+coalesce(t38,0)+coalesce(t37sd,0)+dbo.textoinformado(t37)+coalesce(t36_a,0)+dbo.textoinformado(t36_8_otro)+coalesce(t36_8,0)+dbo.textoinformado(t36_7_otro)+coalesce(t36_7,0)+coalesce(t36_6,0)+coalesce(t36_5,0)+coalesce(t36_4,0)+coalesce(t36_3,0)+coalesce(t36_2,0)+coalesce(t36_1,0)+coalesce(t35,0)+coalesce(t34,0)+coalesce(t33,0)+coalesce(t32_v,0)+coalesce(t32_s,0)+coalesce(t32_mi,0)+coalesce(t32_ma,0)+coalesce(t32_l,0)+coalesce(t32_j,0)+coalesce(t32_d,0)+coalesce(t31_v,0)+coalesce(t31_s,0)+coalesce(t31_mi,0)+coalesce(t31_ma,0)+coalesce(t31_l,0)+coalesce(t31_j,0)+coalesce(t31_d,0)+coalesce(t30,0)+coalesce(t29a,0)+coalesce(t29,0)+coalesce(t28,0)+coalesce(t27,0)+dbo.textoinformado(t26)+dbo.textoinformado(t25)+dbo.textoinformado(t24)+dbo.textoinformado(t23)+coalesce(t22,0)+coalesce(t21,0)+coalesce(t20,0)+coalesce(t19_anio,0)+coalesce(t18,0)+coalesce(t17,0)+coalesce(t16,0)+coalesce(t15,0)+coalesce(t14,0)+coalesce(t13,0)+coalesce(t12,0)+dbo.textoinformado(t11_otro)+coalesce(t11,0)+coalesce(t10,0)+coalesce(t9,0)+dbo.textoinformado(t8_otro)+coalesce(t8,0)+coalesce(t7,0)+coalesce(t6,0)+coalesce(t5,0)+coalesce(t4,0)+coalesce(t3,0)+coalesce(t2,0)+coalesce(t1,0)into v_res from yeah_2011.eah11_i1 where nenc = p_encues and nhogar = p_hogar and miembro = p_miembro;return v_res;end;$$;


ALTER FUNCTION dbo.suma_t1at54b(p_encues integer, p_hogar integer, p_miembro integer) OWNER TO yeahowner;

--
-- Name: suma_t28a54b(integer, integer, integer); Type: FUNCTION; Schema: dbo; Owner: yeahowner
--

CREATE FUNCTION suma_t28a54b(p_encues integer, p_hogar integer, p_miembro integer) RETURNS integer
    LANGUAGE plpgsql STABLE
    AS $$declare 	v_res integer;beginSELECTcoalesce(t54b,0)+coalesce(t54,0)+coalesce(t53c_meses,0)+coalesce(t53c_anios,0)+coalesce(t53c_98,0)+coalesce(t53_ing,0)+coalesce(t53_bis2,0)+coalesce(t53_bis1_sem,0)+coalesce(t53_bis1_mes,0)+coalesce(t53_bis1,0)+coalesce(t52c,0)+coalesce(t52b,0)+coalesce(t52a,0)+coalesce(t51,0)+coalesce(t50f,0)+coalesce(t50e,0)+coalesce(t50d,0)+coalesce(t50c,0)+coalesce(t50b,0)+coalesce(t50a,0)+coalesce(t49,0)+dbo.textoinformado(t48b_esp)+coalesce(t48b,0)+coalesce(t48a,0)+coalesce(t48,0)+coalesce(t47,0)+coalesce(t46,0)+coalesce(t45,0)+coalesce(t44,0)+dbo.textoinformado(t43)+dbo.textoinformado(t42)+dbo.textoinformado(t41)+coalesce(t40,0)+dbo.textoinformado(t39_otro)+coalesce(t39_bis_cuantos,0)+dbo.textoinformado(t39_bis2_esp)+coalesce(t39_bis2,0)+coalesce(t39_bis,0)+dbo.textoinformado(t39_barrio)+coalesce(t39,0)+coalesce(t38,0)+coalesce(t37sd,0)+dbo.textoinformado(t37)+coalesce(t36_a,0)+dbo.textoinformado(t36_8_otro)+coalesce(t36_8,0)+dbo.textoinformado(t36_7_otro)+coalesce(t36_7,0)+coalesce(t36_6,0)+coalesce(t36_5,0)+coalesce(t36_4,0)+coalesce(t36_3,0)+coalesce(t36_2,0)+coalesce(t36_1,0)+coalesce(t35,0)+coalesce(t34,0)+coalesce(t33,0)+coalesce(t32_v,0)+coalesce(t32_s,0)+coalesce(t32_mi,0)+coalesce(t32_ma,0)+coalesce(t32_l,0)+coalesce(t32_j,0)+coalesce(t32_d,0)+coalesce(t31_v,0)+coalesce(t31_s,0)+coalesce(t31_mi,0)+coalesce(t31_ma,0)+coalesce(t31_l,0)+coalesce(t31_j,0)+coalesce(t31_d,0)+coalesce(t30,0)+coalesce(t29a,0)+coalesce(t29,0)+coalesce(t28,0)into v_res from yeah_2011.eah11_i1 where nenc = p_encues and nhogar = p_hogar and miembro = p_miembro;return v_res;end;$$;


ALTER FUNCTION dbo.suma_t28a54b(p_encues integer, p_hogar integer, p_miembro integer) OWNER TO yeahowner;

--
-- Name: texto_a_fecha(text); Type: FUNCTION; Schema: dbo; Owner: yeahowner
--

CREATE FUNCTION texto_a_fecha(p_valor text) RETURNS date
    LANGUAGE plpgsql
    AS $$DECLARE v_fecha date;DECLARE v_anio_extraido integer;DECLARE v_mes_extraido integer;DECLARE v_dia_extraido integer;DECLARE v_anio_actual integer;BEGIN  if p_valor is null then    return null;  end if;  v_anio_actual := dbo.anio();  v_anio_extraido := extract(year from to_date(p_valor, 'DD/MM/YYYY'))::integer;  v_mes_extraido := extract(month from to_date(p_valor, 'DD/MM/YYYY'))::integer;  v_dia_extraido := extract(day from to_date(p_valor, 'DD/MM/YYYY'))::integer;  if v_anio_extraido = -1 then    v_fecha := to_date(p_valor || '/' || v_anio_actual, 'DD/MM/YYYY');  else    if v_anio_extraido < 100 and v_anio_extraido > 11 then       v_anio_extraido := v_anio_extraido + 1900;      v_fecha := to_date(v_dia_extraido || '/' || v_mes_extraido || '/' || v_anio_extraido, 'DD/MM/YYYY');    elsif v_anio_extraido < 12 then       v_anio_extraido := v_anio_extraido + 2000;      v_fecha := to_date(v_dia_extraido || '/' || v_mes_extraido || '/' || v_anio_extraido, 'DD/MM/YYYY');    elseif v_anio_extraido > 99 then      v_fecha := to_date(p_valor, 'DD/MM/YYYY');    end if;  end if;  return v_fecha;EXCEPTION  WHEN invalid_datetime_format THEN    return null;  WHEN datetime_field_overflow THEN    return null; END;$$;


ALTER FUNCTION dbo.texto_a_fecha(p_valor text) OWNER TO yeahowner;

--
-- Name: textoinformado(text); Type: FUNCTION; Schema: dbo; Owner: yeahowner
--

CREATE FUNCTION textoinformado(valor text) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
  if valor is null or length(trim(valor))=0 then
     return 0;
  else 
     return 1;
  end if;
end;
$$;


ALTER FUNCTION dbo.textoinformado(valor text) OWNER TO yeahowner;

--
-- Name: textoinformado(character varying); Type: FUNCTION; Schema: dbo; Owner: yeahowner
--

CREATE FUNCTION textoinformado(valor character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
  if valor is null or length(trim(valor))=0 then
     return 0;
  else 
     return 1;
  end if;
end;
$$;


ALTER FUNCTION dbo.textoinformado(valor character varying) OWNER TO yeahowner;

--
-- Name: textoinformado(integer); Type: FUNCTION; Schema: dbo; Owner: yeahowner
--

CREATE FUNCTION textoinformado(valor integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
  if valor is null then
     return 0;
  else 
	if valor=0 then
		return 0;
	else
		return 1;
	end if;
  end if;
end;
$$;


ALTER FUNCTION dbo.textoinformado(valor integer) OWNER TO yeahowner;

--
-- Name: total_hogares(integer); Type: FUNCTION; Schema: dbo; Owner: yeahowner
--

CREATE FUNCTION total_hogares(enc integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$declare cant integer;begin	cant :=  count(nenc) from yeah_2011.eah11_viv_s1a1 where nenc = enc;			return cant;end;$$;


ALTER FUNCTION dbo.total_hogares(enc integer) OWNER TO yeahowner;

SET search_path = yeah, pg_catalog;

--
-- Name: calcular_poseedor(text, text, integer, integer); Type: FUNCTION; Schema: yeah; Owner: yeahowner
--

CREATE FUNCTION calcular_poseedor(p_dominio text, p_comuna text, p_estado integer, p_encues integer) RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$BEGIN  RETURN NULL;END;$$;


ALTER FUNCTION yeah.calcular_poseedor(p_dominio text, p_comuna text, p_estado integer, p_encues integer) OWNER TO yeahowner;

--
-- Name: con_borrar_campos_calculados_trg(); Type: FUNCTION; Schema: yeah; Owner: yeahowner
--

CREATE FUNCTION con_borrar_campos_calculados_trg() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
begin
  if new.con_precondicion is distinct from old.con_precondicion 
    or new.con_postcondicion is distinct from old.con_postcondicion
  then
    -- estos campos se anulan ante cualquier cambio, solo pueden ser restaurados por el sistema cambiando en forma simultánea la revision
    new.con_junta=null;
    new.con_expresion_sql=null;
    new.con_error_compilacion='Modificada desde la compilacion anterior';
    new.con_valida=false;
  end if;
  return new;
end;
$$;


ALTER FUNCTION yeah.con_borrar_campos_calculados_trg() OWNER TO yeahowner;

--
-- Name: controlversiondelbackup(integer); Type: FUNCTION; Schema: yeah; Owner: yeahowner
--

CREATE FUNCTION controlversiondelbackup(p_version_instalada_en_desarrollo_esperada integer) RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$DECLARE  v_obtenida yeah.parametros.VersionCommitInstaladoEnProduccion%type;BEGIN  SELECT VersionCommitInstaladoEnProduccion    INTO STRICT v_obtenida    FROM yeah.parametros	WHERE UnicoRegistro;  IF p_version_instalada_en_desarrollo_esperada is distinct from v_obtenida THEN    RAISE EXCEPTION 'ERROR. No tiene el ultimo backup subido de produccion. Debe obtener % y tiene %'		,p_version_instalada_en_desarrollo_esperada,v_obtenida;  END IF;  RETURN 'OK';END;$$;


ALTER FUNCTION yeah.controlversiondelbackup(p_version_instalada_en_desarrollo_esperada integer) OWNER TO yeahowner;

--
-- Name: fin_etapa_encuesta(integer, text, integer); Type: FUNCTION; Schema: yeah; Owner: yeahowner
--

CREATE FUNCTION fin_etapa_encuesta(p_encuesta integer, p_usu_usu text, p_poner_fin integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
declare
  v_rol_max yeah.roles.rol_rol%type;
  v_estado_autorizado_para_rol integer;
  v_estado integer;
  v_fin_anal_ing   integer;
  v_fin_anal_campo integer;
  v_fin_anal_proc  integer;
begin
  SELECT estado, fin_anal_ing  
               , fin_anal_campo
               , fin_anal_proc 
    INTO v_estado, v_fin_anal_ing  
	             , v_fin_anal_campo
	             , v_fin_anal_proc 
    FROM tem11
	WHERE encues=p_encuesta;
  SELECT rol, estado 
    INTO v_rol_max, v_estado_autorizado_para_rol
	FROM rol_como_analista(p_usu_usu);
  if v_estado<23 then
    raise exception 'ERROR no se puede finalizar la encuesta % porque su estado es %',p_encuesta,v_estado;
  --elsif v_estado>v_estado_autorizado_para_rol then
    --raise exception 'ERROR el usuario % no tiene permiso para finalizar la encuesta % porque su estado es %',p_usu_usu,p_encuesta,v_estado;
  elsif v_rol_max='ana_campo' and v_estado<>25 then
    raise exception 'ERROR el analista de campo % no puede finalizar la encuesta % porque su estado no es 25, es %',p_usu_usu,p_encuesta,v_estado;
  end if;
  if v_rol_max='ingresador' then
    if p_poner_fin not in (1,2,3) then
	  raise exception 'ERROR el ingresador no puede poner el fin % en la encuesta %, solo puede poner 1, 2 o 3',p_poner_fin,p_encuesta;
	elsif coalesce(v_fin_anal_ing, v_fin_anal_campo, v_fin_anal_proc) is not null then
	  raise exception 'ERROR el ingresador no puede finalizar la encuesta % si esta finalizada por un analista (%,%,%)',p_encuesta,v_anal_ing,v_anal_campo,v_anal_proc;
	end if;
    update tem11 set fin_ingreso=p_poner_fin where encues=p_encuesta;
  end if;
  if v_rol_max='ana_ing' then
    if p_poner_fin not in (1,2,3,4,5) then
	  raise exception 'ERROR el analista de ingreso no puede poner el fin % en la encuesta %, solo puede poner 1, 2, 4 o 5',p_poner_fin,p_encuesta;
	elsif coalesce(v_fin_anal_campo, v_fin_anal_proc) is not null then
	  raise exception 'ERROR el analista de ingreso no puede finalizar la encuesta % si esta finalizada por un analista de campo o procesamiento (%,%,%)',p_encuesta,v_anal_ing,v_anal_campo,v_anal_proc;
	end if;
    update tem11 
	  set fin_ingreso=coalesce(fin_ingreso,case p_poner_fin when 1 then 1 when 2 then 2 else 3 end)
		, fin_anal_ing=case when coalesce(fin_ingreso,p_poner_fin) in (1, 2) or p_poner_fin=3 then null else p_poner_fin end
	  where encues=p_encuesta;
  end if;
  if v_rol_max='ana_campo' then
    if p_poner_fin not in (1,2,5) then
	  raise exception 'ERROR el analista de campo no puede poner el fin % en la encuesta %, solo puede poner 1, 2 o 5',p_poner_fin,p_encuesta;
	elsif coalesce(v_fin_anal_proc) is not null then
	  raise exception 'ERROR el analista de campo no puede finalizar la encuesta % si esta finalizada por un analista de procesamiento (%,%,%)',p_encuesta,v_anal_ing,v_anal_campo,v_anal_proc;
	end if;
    update tem11 
	  set fin_anal_campo=p_poner_fin
	  where encues=p_encuesta;
  end if;
  if v_rol_max='procesamiento' then
    if p_poner_fin=3 then
		p_poner_fin=null;
    elsif p_poner_fin not in (1,2,4,6) then
	  raise exception 'ERROR el usuario no puede poner el fin % en la encuesta %, solo puede poner 1, 2, 4 o 6',p_poner_fin,p_encuesta;
	end if;
    update tem11 
	  set fin_ingreso=coalesce(fin_ingreso,case p_poner_fin when 1 then 1 when 2 then 2 else 3 end)
		, fin_anal_proc=coalesce(p_poner_fin,fin_anal_proc)
	  where encues=p_encuesta;
  end if;
  return '';
end;
$$;


ALTER FUNCTION yeah.fin_etapa_encuesta(p_encuesta integer, p_usu_usu text, p_poner_fin integer) OWNER TO yeahowner;

--
-- Name: participacion_segun_replica(integer, integer); Type: FUNCTION; Schema: yeah; Owner: yeahowner
--

CREATE FUNCTION participacion_segun_replica(p_rep integer, p_annio integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
declare
  v_rta integer;
begin
  v_rta:=case p_annio
	when 2011 then case p_rep
		when 3 then 1
		when 4 then 1
		when 1 then 2
		when 2 then 2
		when 5 then 3
		when 6 then 3
		when 7 then 1
		when 8 then 1
		end
	end;
  if v_rta is null then
	raise exception 'No se puede calcular la participación de la replica % en el annio %',p_rep,p_annio;
  end if;
  return v_rta;
end;
$$;


ALTER FUNCTION yeah.participacion_segun_replica(p_rep integer, p_annio integer) OWNER TO yeahowner;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ano_con; Type: TABLE; Schema: yeah; Owner: yeahowner; Tablespace: 
--

CREATE TABLE ano_con (
    anocon_con character varying(30) NOT NULL,
    anocon_num integer NOT NULL,
    anocon_anotacion character varying(1000) NOT NULL,
    anocon_autor character varying(30) NOT NULL,
    anocon_momento timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "texto invalido en anocon_anotacion de tabla ano_con" CHECK (comun.cadena_valida((anocon_anotacion)::text, 'cualquiera'::text)),
    CONSTRAINT "texto invalido en anocon_autor de tabla ano_con" CHECK (comun.cadena_valida((anocon_autor)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en anocon_con de tabla ano_con" CHECK (comun.cadena_valida((anocon_con)::text, 'formula'::text))
);


ALTER TABLE yeah.ano_con OWNER TO yeahowner;

--
-- Name: aux_tem_cambios; Type: TABLE; Schema: yeah; Owner: yeahowner; Tablespace: 
--

CREATE TABLE aux_tem_cambios (
    comuna character varying(30),
    replica character varying(30),
    lote character varying(30),
    encues integer NOT NULL
);


ALTER TABLE yeah.aux_tem_cambios OWNER TO yeahowner;

--
-- Name: celdas; Type: TABLE; Schema: yeah; Owner: yeahowner; Tablespace: 
--

CREATE TABLE celdas (
    cel_enc character varying(50) NOT NULL,
    cel_for character varying(50) NOT NULL,
    cel_cel character varying(250) NOT NULL,
    cel_orden integer,
    cel_texto character varying(150),
    cel_tipo character varying(50),
    cel_aclaracion character varying(500),
    cel_mat character varying(50),
    cel_incluir_mat character varying(50),
    cel_activa boolean DEFAULT true NOT NULL,
    cel_nombre_corto character varying(50),
    cel_cel_visible boolean,
    cel_numero_pagina integer,
    CONSTRAINT "texto invalido en cel_aclaracion de tabla celdas" CHECK (comun.cadena_valida((cel_aclaracion)::text, 'cualquiera'::text)),
    CONSTRAINT "texto invalido en cel_cel de tabla celdas" CHECK (comun.cadena_valida((cel_cel)::text, 'extendido'::text)),
    CONSTRAINT "texto invalido en cel_enc de tabla celdas" CHECK (comun.cadena_valida((cel_enc)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en cel_for de tabla celdas" CHECK (comun.cadena_valida((cel_for)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en cel_incluir_mat de tabla celdas" CHECK (comun.cadena_valida((cel_incluir_mat)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en cel_mat de tabla celdas" CHECK (comun.cadena_valida((cel_mat)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en cel_nombre_corto de tabla celdas" CHECK (comun.cadena_valida((cel_nombre_corto)::text, 'cualquiera'::text)),
    CONSTRAINT "texto invalido en cel_texto de tabla celdas" CHECK (comun.cadena_valida((cel_texto)::text, 'cualquiera'::text)),
    CONSTRAINT "texto invalido en cel_tipo de tabla celdas" CHECK (comun.cadena_valida((cel_tipo)::text, 'extendido'::text))
);


ALTER TABLE yeah.celdas OWNER TO yeahowner;

--
-- Name: consistencias; Type: TABLE; Schema: yeah; Owner: yeahowner; Tablespace: 
--

CREATE TABLE consistencias (
    con_con character varying(30) NOT NULL,
    con_precondicion character varying(800),
    con_rel character varying(3) DEFAULT '=>'::character varying,
    con_postcondicion character varying(800),
    con_activa boolean DEFAULT true NOT NULL,
    con_descripcion character varying(240),
    con_grupo character varying(60),
    con_modulo character varying(60),
    con_tipo character varying(60),
    con_gravedad character varying(60),
    con_momento character varying(60),
    con_version character varying(200),
    con_explicacion character varying(300),
    con_orden numeric,
    con_expl_ok boolean DEFAULT false NOT NULL,
    con_rev integer DEFAULT 1 NOT NULL,
    con_junta character varying(30),
    con_clausula_from character varying(500),
    con_expresion_sql character varying(4000),
    con_valida boolean DEFAULT false,
    con_error_compilacion character varying(4000),
    con_ultima_modificacion date,
    con_ultima_variable character varying(50),
    con_ignorar_nulls boolean,
    CONSTRAINT "La gravedad solo puede ser Error o Advertencia" CHECK (((con_gravedad)::text = ANY (ARRAY[('Error'::character varying)::text, ('Advertencia'::character varying)::text]))),
    CONSTRAINT "texto invalido en con_clausula_from de tabla consistencias" CHECK (comun.cadena_valida((con_clausula_from)::text, 'formula'::text)),
    CONSTRAINT "texto invalido en con_con de tabla consistencias" CHECK (comun.cadena_valida((con_con)::text, 'formula'::text)),
    CONSTRAINT "texto invalido en con_descripcion de tabla consistencias" CHECK (comun.cadena_valida((con_descripcion)::text, 'cualquiera'::text)),
    CONSTRAINT "texto invalido en con_error_compilacion de tabla consistencias" CHECK (comun.cadena_valida((con_error_compilacion)::text, 'cualquiera'::text)),
    CONSTRAINT "texto invalido en con_explicacion de tabla consistencias" CHECK (comun.cadena_valida((con_explicacion)::text, 'cualquiera'::text)),
    CONSTRAINT "texto invalido en con_expresion_sql de tabla consistencias" CHECK (comun.cadena_valida((con_expresion_sql)::text, 'cualquiera'::text)),
    CONSTRAINT "texto invalido en con_gravedad de tabla consistencias" CHECK (comun.cadena_valida((con_gravedad)::text, 'cualquiera'::text)),
    CONSTRAINT "texto invalido en con_grupo de tabla consistencias" CHECK (comun.cadena_valida((con_grupo)::text, 'cualquiera'::text)),
    CONSTRAINT "texto invalido en con_junta de tabla consistencias" CHECK (comun.cadena_valida((con_junta)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en con_modulo de tabla consistencias" CHECK (comun.cadena_valida((con_modulo)::text, 'cualquiera'::text)),
    CONSTRAINT "texto invalido en con_momento de tabla consistencias" CHECK (comun.cadena_valida((con_momento)::text, 'castellano'::text)),
    CONSTRAINT "texto invalido en con_postcondicion de tabla consistencias" CHECK (comun.cadena_valida((con_postcondicion)::text, 'formula'::text)),
    CONSTRAINT "texto invalido en con_precondicion de tabla consistencias" CHECK (comun.cadena_valida((con_precondicion)::text, 'formula'::text)),
    CONSTRAINT "texto invalido en con_rel de tabla consistencias" CHECK (comun.cadena_valida((con_rel)::text, 'formula'::text)),
    CONSTRAINT "texto invalido en con_tipo de tabla consistencias" CHECK (comun.cadena_valida((con_tipo)::text, 'cualquiera'::text)),
    CONSTRAINT "texto invalido en con_version de tabla consistencias" CHECK (comun.cadena_valida((con_version)::text, 'castellano y formula'::text)),
    CONSTRAINT "tipo no puede ser cualquiera" CHECK (((con_tipo)::text <> 'cualquiera'::text))
);


ALTER TABLE yeah.consistencias OWNER TO yeahowner;

--
-- Name: eah10_ex; Type: TABLE; Schema: yeah; Owner: yeahowner; Tablespace: 
--

CREATE TABLE eah10_ex (
    nenc integer,
    nhogar integer NOT NULL,
    ex_miembro integer NOT NULL,
    sexo_ex integer,
    pais_nac integer,
    edad_ex integer,
    niv_educ integer,
    anio integer,
    lugar integer,
    lugar_desc character varying(50),
    usuario character varying(50),
    log timestamp with time zone,
    CONSTRAINT "texto invalido en lugar_desc de tabla eah10_ex" CHECK (comun.cadena_valida((lugar_desc)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en usuario de tabla eah10_ex" CHECK (comun.cadena_valida((usuario)::text, 'codigo'::text))
);


ALTER TABLE yeah.eah10_ex OWNER TO yeahowner;

--
-- Name: eah10_fam; Type: TABLE; Schema: yeah; Owner: yeahowner; Tablespace: 
--

CREATE TABLE eah10_fam (
    nenc integer,
    nhogar integer NOT NULL,
    p0 integer NOT NULL,
    nombre character varying(30),
    sexo integer,
    f_nac_o character varying(10),
    edad integer,
    p4 integer,
    p5 integer,
    p5b integer,
    p6_a integer,
    p6_b integer,
    p7 integer,
    p8 integer NOT NULL,
    p8_esp character varying(50),
    usuario character varying(50),
    log timestamp with time zone,
    pc character varying(50),
    f_nac character varying(10),
    CONSTRAINT "texto invalido en f_nac de tabla eah10_fam" CHECK (comun.cadena_valida((f_nac)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en f_nac_o de tabla eah10_fam" CHECK (comun.cadena_valida((f_nac_o)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en nombre de tabla eah10_fam" CHECK (comun.cadena_valida((nombre)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en p8_esp de tabla eah10_fam" CHECK (comun.cadena_valida((p8_esp)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en pc de tabla eah10_fam" CHECK (comun.cadena_valida((pc)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en usuario de tabla eah10_fam" CHECK (comun.cadena_valida((usuario)::text, 'codigo'::text))
);


ALTER TABLE yeah.eah10_fam OWNER TO yeahowner;

--
-- Name: eah10_i1; Type: TABLE; Schema: yeah; Owner: yeahowner; Tablespace: 
--

CREATE TABLE eah10_i1 (
    nenc integer,
    nhogar integer NOT NULL,
    miembro integer NOT NULL,
    respondi integer,
    entrev integer,
    u1 integer,
    t1 integer,
    t2 integer,
    t3 integer,
    t4 integer,
    t5 integer,
    t6 integer,
    t7 integer,
    t8 integer,
    t8_otro character(50),
    t9 integer,
    t10 integer,
    t11 integer,
    t11_otro character(50),
    t12 integer,
    t13 integer,
    t14 integer,
    t15 integer,
    t16 integer,
    t17 integer,
    t18 integer,
    t19_anio integer,
    t20 integer,
    t21 integer,
    t22 integer,
    t23 character(200),
    t23_cod integer,
    t24 character(200),
    t24_cod integer,
    t25 character(200),
    t26 character(100),
    t27 integer,
    t28 integer,
    t29 integer,
    t29a integer,
    t30 integer,
    t31_d integer,
    t31_l integer,
    t31_ma integer,
    t31_mi integer,
    t31_j integer,
    t31_v integer,
    t31_s integer,
    t32_d integer,
    t32_l integer,
    t32_ma integer,
    t32_mi integer,
    t32_j integer,
    t32_v integer,
    t32_s integer,
    t33 integer,
    t34 integer,
    t35 integer,
    t36_1 integer,
    t36_2 integer,
    t36_3 integer,
    t36_4 integer,
    t36_5 integer,
    t36_6 integer,
    t36_7 integer,
    t36_7_otro character(50),
    t36_8 integer,
    t36_8_otro character(50),
    t36_99 integer,
    t36_a integer,
    t37 character(100),
    t37_cod integer,
    t38 integer,
    t39 integer,
    t39_barrio character(50),
    t39_otro character(50),
    t39_bis integer,
    t39_bis_cuantos integer,
    t40 integer,
    t41 character(200),
    t41_cod integer,
    t42 character(200),
    t43 character(100),
    t44 integer,
    t45 integer,
    t46 integer,
    t47 integer,
    t48 integer,
    t49 integer,
    t50a integer,
    t50b integer,
    t50c integer,
    t50d integer,
    t50e integer,
    t50f integer,
    t51 integer,
    t52a integer,
    t52b integer,
    t52c integer,
    t53_ing integer,
    t53_mensual integer,
    t53_nopago integer,
    t53c_anios integer,
    t53c_meses integer,
    t53c_98 integer,
    t54 integer,
    t54b integer,
    i1 integer,
    i2_tot integer,
    i2_totx integer,
    i2_tic integer,
    i2_ticx integer,
    i3_1 integer,
    i3_1x integer,
    i3_2 integer,
    i3_2x integer,
    i3_3 integer,
    i3_3x integer,
    i3_4 integer,
    i3_4x integer,
    i3_5 integer,
    i3_5x integer,
    i3_6 integer,
    i3_6x integer,
    i3_7 integer,
    i3_7x integer,
    i3_8 integer,
    i3_8x integer,
    i3_11 integer,
    i3_11x integer,
    i3_12 integer,
    i3_12x integer,
    i3_13 integer,
    i3_13x integer,
    i3_10 integer,
    i3_10x integer,
    i3_10_otro character(50),
    i3_tot integer,
    i3_99 integer,
    e1 integer,
    e2 integer,
    e3 integer,
    e3a integer,
    e4 integer,
    e6 integer,
    e7 integer,
    e8 integer,
    e9_edad integer,
    e9_anio integer,
    e10 integer,
    e12 integer,
    e13 integer,
    e14 integer,
    e11_1 integer,
    e11_2 integer,
    e11_3 integer,
    e11_4 integer,
    e11_5 integer,
    e11_6 integer,
    e11_7 integer,
    e11_8 integer,
    e11_9 integer,
    e11_10 integer,
    e11_11 integer,
    e11_12 integer,
    e11_13 integer,
    e11_14 integer,
    e11_15 integer,
    e11_15_otro character(50),
    e11_99 integer,
    e11a integer,
    te integer,
    e15_1 integer,
    e15_2 integer,
    e15_3 integer,
    e15_4 integer,
    e15_5 integer,
    e15_5_otro character(70),
    e15_6 integer,
    e15_9 integer,
    e15a integer,
    m1 integer,
    m1_esp character(100),
    m1_anio integer,
    m1a integer,
    m1a_esp character(50),
    m3 integer,
    m3_anio integer,
    m4 integer,
    m4_esp character(100),
    m5 integer,
    sn1_1 integer,
    sn1_2 integer,
    sn1_3 integer,
    sn1_4 integer,
    sn1_5 integer,
    sn1_6 integer,
    sn1_99 integer,
    sn1_1_esp character(40),
    sn1_2_esp character(40),
    sn1_3_esp character(40),
    sn1_4_esp character(40),
    sn1_5_esp character(40),
    sn2 integer,
    sn2_cant integer,
    sn3 integer,
    sn4 integer,
    sn4_esp character(50),
    sn5 integer,
    sn5_esp character(50),
    sn6 integer,
    sn6_cant integer,
    sn7 integer,
    sn7_esp character(50),
    sn8 integer,
    sn8_esp character(70),
    sn9 integer,
    sn10a integer,
    sn10b integer,
    sn10c integer,
    sn10d integer,
    sn10e integer,
    sn10f integer,
    sn10g integer,
    sn10h integer,
    sn10i integer,
    sn10j_esp character(50),
    sn10j integer,
    sn11 integer,
    sn12 integer,
    sn12_esp integer,
    sn12_98 integer,
    sn13 integer,
    sn13_otro character(40),
    sn14 integer,
    sn14_esp character(40),
    sn15a integer,
    sn15b integer,
    sn15c integer,
    sn15d integer,
    sn15e integer,
    sn15f integer,
    sn15g integer,
    sn15h integer,
    sn15i integer,
    sn15j integer,
    sn15k_esp character(40),
    sn15k integer,
    sn16 integer,
    s28 integer,
    s29 integer,
    s30 integer,
    s31_anio integer,
    s31_mes integer,
    estado integer,
    obs character(200),
    usuario character(50),
    log date,
    edad_30_6 integer,
    e9r integer,
    m1a_esp2 character varying(200),
    m1a_esp3 character varying(200),
    m1a_esp4 character varying(200),
    m4_esp1 character varying(200),
    m4_esp2 character varying(200),
    m4_esp3 character varying(200),
    sn10_j_esp character varying(200),
    m1_esp2 character varying(200),
    m1_esp3 character varying(200),
    m1_esp4 character varying(200),
    t39_bis2 integer,
    t39_bis2_esp character varying(50),
    t48a integer,
    t48b integer,
    t53_bis1_sem integer,
    t53_bis1_mes integer,
    t53_bis2 integer,
    t48b_esp character varying(50),
    t53_bis1 integer,
    te_1 integer,
    te_2 integer,
    sn1_7 integer,
    sn1_7_esp character varying(50),
    md1 integer,
    md2 integer,
    md3 integer,
    md4 integer,
    md5 integer,
    md6 integer,
    md7 integer,
    md8 integer,
    md9 integer,
    md10 integer,
    md11 integer,
    md12 character varying(100),
    observaciones character varying(400),
    t37sd integer,
    CONSTRAINT "texto invalido en m1_esp2 de tabla eah10_i1" CHECK (comun.cadena_valida((m1_esp2)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en m1_esp3 de tabla eah10_i1" CHECK (comun.cadena_valida((m1_esp3)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en m1_esp4 de tabla eah10_i1" CHECK (comun.cadena_valida((m1_esp4)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en m1a_esp2 de tabla eah10_i1" CHECK (comun.cadena_valida((m1a_esp2)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en m1a_esp3 de tabla eah10_i1" CHECK (comun.cadena_valida((m1a_esp3)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en m1a_esp4 de tabla eah10_i1" CHECK (comun.cadena_valida((m1a_esp4)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en m4_esp1 de tabla eah10_i1" CHECK (comun.cadena_valida((m4_esp1)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en m4_esp2 de tabla eah10_i1" CHECK (comun.cadena_valida((m4_esp2)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en m4_esp3 de tabla eah10_i1" CHECK (comun.cadena_valida((m4_esp3)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en md12 de tabla eah10_i1" CHECK (comun.cadena_valida((md12)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en observaciones de tabla eah10_i1" CHECK (comun.cadena_valida((observaciones)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en sn10_j_esp de tabla eah10_i1" CHECK (comun.cadena_valida((sn10_j_esp)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en sn1_7_esp de tabla eah10_i1" CHECK (comun.cadena_valida((sn1_7_esp)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en t39_bis2_esp de tabla eah10_i1" CHECK (comun.cadena_valida((t39_bis2_esp)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en t48b_esp de tabla eah10_i1" CHECK (comun.cadena_valida((t48b_esp)::text, 'codigo'::text))
);


ALTER TABLE yeah.eah10_i1 OWNER TO yeahowner;

--
-- Name: eah10_md; Type: TABLE; Schema: yeah; Owner: yeahowner; Tablespace: 
--

CREATE TABLE eah10_md (
    nenc integer NOT NULL,
    nhogar integer NOT NULL,
    miembro integer NOT NULL,
    d1_meses integer,
    d1_anios integer,
    d2 integer,
    d3 integer,
    d4 integer,
    d5 integer,
    d6 integer,
    d7 integer,
    d8 integer,
    d9 integer,
    d10 integer,
    d11 integer,
    d12 integer,
    d13 integer,
    d14 integer,
    d15 integer,
    d16 integer,
    d17 integer,
    d18 integer,
    d19 integer,
    d20 integer,
    d21 integer,
    d22 integer,
    d23 integer,
    d24 integer,
    d25 integer,
    d26 integer,
    d27 integer
);


ALTER TABLE yeah.eah10_md OWNER TO yeahowner;

--
-- Name: eah10_tv; Type: TABLE; Schema: yeah; Owner: yeahowner; Tablespace: 
--

CREATE TABLE eah10_tv (
    nenc integer,
    nhogar integer NOT NULL,
    miembro integer NOT NULL,
    tv1 integer,
    tv2 integer,
    tv3 integer,
    tv4 character varying(100),
    tv5 character varying(100),
    tv6 integer,
    tv7 integer,
    CONSTRAINT "texto invalido en tv4 de tabla eah10_tv" CHECK (comun.cadena_valida((tv4)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en tv5 de tabla eah10_tv" CHECK (comun.cadena_valida((tv5)::text, 'codigo'::text))
);


ALTER TABLE yeah.eah10_tv OWNER TO yeahowner;

--
-- Name: eah10_un; Type: TABLE; Schema: yeah; Owner: yeahowner; Tablespace: 
--

CREATE TABLE eah10_un (
    nenc integer NOT NULL,
    nhogar integer NOT NULL,
    miembro integer NOT NULL,
    relacion integer NOT NULL,
    u3_mes integer,
    u3_anio integer,
    u4_mes integer,
    u4_anio integer,
    u5 integer,
    u6 integer
);


ALTER TABLE yeah.eah10_un OWNER TO yeahowner;

--
-- Name: eah10_viv_s1a1; Type: TABLE; Schema: yeah; Owner: yeahowner; Tablespace: 
--

CREATE TABLE eah10_viv_s1a1 (
    id integer NOT NULL,
    comuna integer,
    rep integer,
    lote integer,
    up integer,
    nenc integer,
    participacion integer NOT NULL,
    id2009 integer,
    nh2009 integer,
    entrea integer,
    razon1 integer,
    razon2_1 integer,
    razon2_2 integer,
    razon2_3 integer,
    razon2_4 integer,
    razon2_5 integer,
    razon2_6 integer,
    razon2_7 integer,
    razon2_8 integer,
    razon2_9 integer,
    razon3 character varying(50),
    nhogar integer NOT NULL,
    miembro integer,
    v1 integer,
    total_h integer,
    total_m integer,
    c_enc integer,
    n_enc character varying(50),
    c_recu integer,
    n_recu character varying(50),
    c_recep integer,
    n_recep character varying(50),
    c_sup integer,
    n_sup character varying(50),
    respond integer,
    nombrer character varying(50),
    f_realiz_o character varying(20),
    form character varying(4),
    v2 integer,
    v2_esp character varying(50),
    v4 integer,
    v5 integer,
    v5_esp character varying(255),
    v6 integer,
    v7 integer,
    v12 integer,
    h1 integer,
    h2 integer,
    h2_esp character varying(50),
    h3 integer,
    h4 integer,
    h4_tipot integer,
    h4_tel character varying(20),
    h20_1 integer,
    h20_2 integer,
    h20_4 integer,
    h20_5 integer,
    h20_6 integer,
    h20_7 integer,
    h20_8 integer,
    h20_10 integer,
    h20_15 integer,
    h20_11 integer,
    h20_12 integer,
    h20_13 integer,
    h20_16 integer,
    h20_17 integer,
    h20_18 integer,
    h20_19 integer,
    h20_20 integer,
    h20_14 integer,
    h20_esp character varying(50),
    h20_99 integer,
    x5 integer,
    x5_tot integer,
    h30_tv integer,
    h30_hf integer,
    h30_la integer,
    h30_vi integer,
    h30_ac integer,
    h30_dvd integer,
    h30_mo integer,
    h30_pc integer,
    h30_in integer,
    obs character varying(255),
    usuario character varying(15),
    log timestamp with time zone,
    tipo_h character varying(1),
    encreali integer,
    f_realiz character varying(50),
    telefono character varying(50),
    CONSTRAINT "texto invalido en f_realiz de tabla eah10_viv_s1a1" CHECK (comun.cadena_valida((f_realiz)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en f_realiz_o de tabla eah10_viv_s1a1" CHECK (comun.cadena_valida((f_realiz_o)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en form de tabla eah10_viv_s1a1" CHECK (comun.cadena_valida((form)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en h20_esp de tabla eah10_viv_s1a1" CHECK (comun.cadena_valida((h20_esp)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en h2_esp de tabla eah10_viv_s1a1" CHECK (comun.cadena_valida((h2_esp)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en h4_tel de tabla eah10_viv_s1a1" CHECK (comun.cadena_valida((h4_tel)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en n_enc de tabla eah10_viv_s1a1" CHECK (comun.cadena_valida((n_enc)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en n_recep de tabla eah10_viv_s1a1" CHECK (comun.cadena_valida((n_recep)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en n_recu de tabla eah10_viv_s1a1" CHECK (comun.cadena_valida((n_recu)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en n_sup de tabla eah10_viv_s1a1" CHECK (comun.cadena_valida((n_sup)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en nombrer de tabla eah10_viv_s1a1" CHECK (comun.cadena_valida((nombrer)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en obs de tabla eah10_viv_s1a1" CHECK (comun.cadena_valida((obs)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en razon3 de tabla eah10_viv_s1a1" CHECK (comun.cadena_valida((razon3)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en telefono de tabla eah10_viv_s1a1" CHECK (comun.cadena_valida((telefono)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en tipo_h de tabla eah10_viv_s1a1" CHECK (comun.cadena_valida((tipo_h)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en usuario de tabla eah10_viv_s1a1" CHECK (comun.cadena_valida((usuario)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en v2_esp de tabla eah10_viv_s1a1" CHECK (comun.cadena_valida((v2_esp)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en v5_esp de tabla eah10_viv_s1a1" CHECK (comun.cadena_valida((v5_esp)::text, 'codigo'::text))
);


ALTER TABLE yeah.eah10_viv_s1a1 OWNER TO yeahowner;

--
-- Name: encuestas; Type: TABLE; Schema: yeah; Owner: yeahowner; Tablespace: 
--

CREATE TABLE encuestas (
    enc_enc character varying(50) NOT NULL,
    enc_prefija_for_nombre_variable boolean,
    CONSTRAINT "texto invalido en enc_enc de tabla encuestas" CHECK (comun.cadena_valida((enc_enc)::text, 'codigo'::text))
);


ALTER TABLE yeah.encuestas OWNER TO yeahowner;

--
-- Name: formularios; Type: TABLE; Schema: yeah; Owner: yeahowner; Tablespace: 
--

CREATE TABLE formularios (
    for_enc character varying(50) NOT NULL,
    for_for character varying(50) NOT NULL,
    for_nombre character varying(50),
    for_tabla_destino character varying(50) DEFAULT NULL::character varying,
    for_orden integer,
    CONSTRAINT "texto invalido en for_enc de tabla formularios" CHECK (comun.cadena_valida((for_enc)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en for_for de tabla formularios" CHECK (comun.cadena_valida((for_for)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en for_nombre de tabla formularios" CHECK (comun.cadena_valida((for_nombre)::text, 'castellano'::text)),
    CONSTRAINT "texto invalido en for_tabla_destino de tabla formularios" CHECK (comun.cadena_valida((for_tabla_destino)::text, 'codigo'::text))
);


ALTER TABLE yeah.formularios OWNER TO yeahowner;

--
-- Name: tipovar_opciones; Type: TABLE; Schema: yeah; Owner: yeahowner; Tablespace: 
--

CREATE TABLE tipovar_opciones (
    tipovaropc_tipovar character varying(50) NOT NULL,
    tipovaropc_opc character varying(50) NOT NULL,
    tipovaropc_texto character varying(150),
    tipovaropc_orden integer,
    CONSTRAINT "texto invalido en tipovaropc_opc de tabla tipovar_opciones" CHECK (comun.cadena_valida((tipovaropc_opc)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en tipovaropc_texto de tabla tipovar_opciones" CHECK (comun.cadena_valida((tipovaropc_texto)::text, 'castellano'::text)),
    CONSTRAINT "texto invalido en tipovaropc_tipovar de tabla tipovar_opciones" CHECK (comun.cadena_valida((tipovaropc_tipovar)::text, 'codigo'::text))
);


ALTER TABLE yeah.tipovar_opciones OWNER TO yeahowner;

--
-- Name: valores; Type: TABLE; Schema: yeah; Owner: yeahowner; Tablespace: 
--

CREATE TABLE valores (
    val_enc character varying(50) NOT NULL,
    val_for character varying(50) NOT NULL,
    val_cel character varying(250) NOT NULL,
    val_val character varying(50) NOT NULL,
    val_texto character varying(150),
    val_salta character varying(50),
    val_aclaracion character varying(150),
    val_orden integer,
    val_tipovar character varying(50),
    val_opcion character varying(50),
    val_maximo numeric,
    val_minimo numeric,
    val_advertencia_sup numeric,
    val_advertencia_inf numeric,
    val_padre character varying(50) DEFAULT NULL::character varying,
    val_variable character varying(50),
    val_expresion character varying(250),
    val_expresion_habilitar character varying(500),
    val_mejor_de_celda character varying(50),
    val_optativa boolean DEFAULT false NOT NULL,
    val_nsnc_atipico integer,
    CONSTRAINT "Las opciones deben tener padre" CHECK (((val_tipovar IS NOT NULL) OR (val_padre IS NOT NULL))),
    CONSTRAINT "Las variables unico no deben tener padre" CHECK ((((val_val)::text <> 'unico'::text) OR (val_padre IS NULL))),
    CONSTRAINT "texto invalido en val_aclaracion de tabla valores" CHECK (comun.cadena_valida((val_aclaracion)::text, 'cualquiera'::text)),
    CONSTRAINT "texto invalido en val_cel de tabla valores" CHECK (comun.cadena_valida((val_cel)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en val_enc de tabla valores" CHECK (comun.cadena_valida((val_enc)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en val_expresion de tabla valores" CHECK (comun.cadena_valida((val_expresion)::text, 'formula'::text)),
    CONSTRAINT "texto invalido en val_expresion_habilitar de tabla valores" CHECK (comun.cadena_valida((val_expresion_habilitar)::text, 'cualquiera'::text)),
    CONSTRAINT "texto invalido en val_for de tabla valores" CHECK (comun.cadena_valida((val_for)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en val_mejor_de_celda de tabla valores" CHECK (comun.cadena_valida((val_mejor_de_celda)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en val_opcion de tabla valores" CHECK (comun.cadena_valida((val_opcion)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en val_padre de tabla valores" CHECK (comun.cadena_valida((val_padre)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en val_salta de tabla valores" CHECK (comun.cadena_valida((val_salta)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en val_texto de tabla valores" CHECK (comun.cadena_valida((val_texto)::text, 'cualquiera'::text)),
    CONSTRAINT "texto invalido en val_tipovar de tabla valores" CHECK (comun.cadena_valida((val_tipovar)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en val_val de tabla valores" CHECK (comun.cadena_valida((val_val)::text, 'cualquiera'::text)),
    CONSTRAINT "texto invalido en val_variable de tabla valores" CHECK (comun.cadena_valida((val_variable)::text, 'extendido'::text))
);


ALTER TABLE yeah.valores OWNER TO yeahowner;

--
-- Name: inconsistencias_estructurales; Type: VIEW; Schema: yeah; Owner: yeahowner
--

CREATE VIEW inconsistencias_estructurales AS
    ((((SELECT ('Falta la opción '::text || (tipovar_opciones.tipovaropc_opc)::text) AS inc_problema, padre.val_enc AS inc_enc, padre.val_for AS inc_for, padre.val_cel AS inc_cel, padre.val_val AS inc_val, tipovar_opciones.tipovaropc_opc AS inc_opc FROM ((valores padre JOIN tipovar_opciones ON (((padre.val_tipovar)::text = (tipovar_opciones.tipovaropc_tipovar)::text))) LEFT JOIN valores hija ON (((((((padre.val_enc)::text = (hija.val_enc)::text) AND ((padre.val_for)::text = (hija.val_for)::text)) AND ((padre.val_cel)::text = (hija.val_cel)::text)) AND ((padre.val_val)::text = (hija.val_padre)::text)) AND ((tipovar_opciones.tipovaropc_opc)::text = (hija.val_opcion)::text)))) WHERE (hija.val_enc IS NULL) UNION SELECT ((('El texto de la opción debía ser '::text || (COALESCE(tipovar_opciones.tipovaropc_texto, '*no tiene*'::character varying))::text) || ' y es '::text) || (COALESCE(hija.val_texto, '*no tiene*'::character varying))::text) AS inc_problema, padre.val_enc AS inc_enc, padre.val_for AS inc_for, padre.val_cel AS inc_cel, padre.val_val AS inc_val, tipovar_opciones.tipovaropc_opc AS inc_opc FROM ((valores padre JOIN tipovar_opciones ON (((padre.val_tipovar)::text = (tipovar_opciones.tipovaropc_tipovar)::text))) LEFT JOIN valores hija ON (((((((padre.val_enc)::text = (hija.val_enc)::text) AND ((padre.val_for)::text = (hija.val_for)::text)) AND ((padre.val_cel)::text = (hija.val_cel)::text)) AND ((padre.val_val)::text = (hija.val_padre)::text)) AND ((tipovar_opciones.tipovaropc_opc)::text = (hija.val_opcion)::text)))) WHERE ((hija.val_texto)::text IS DISTINCT FROM (tipovar_opciones.tipovaropc_texto)::text)) UNION SELECT ('Hay una celda con un valor de nombre "unico" y otro valor (o sea no es unico): '::text || (otra.val_val)::text) AS inc_problema, unico.val_enc AS inc_enc, unico.val_for AS inc_for, unico.val_cel AS inc_cel, otra.val_val AS inc_val, NULL::character varying AS inc_opc FROM (valores unico JOIN valores otra ON ((((((((unico.val_enc)::text = (otra.val_enc)::text) AND ((unico.val_for)::text = (otra.val_for)::text)) AND ((unico.val_cel)::text = (otra.val_cel)::text)) AND ((unico.val_val)::text = 'unico'::text)) AND ('unico'::text <> (otra.val_val)::text)) AND (otra.val_padre IS NULL))))) UNION SELECT (((('Los hijos de las múltiples no son todas del mismo tipo hay "'::text || min((hija.val_tipovar)::text)) || '" y "'::text) || max((hija.val_tipovar)::text)) || '"'::text) AS inc_problema, padre.val_enc AS inc_enc, padre.val_for AS inc_for, padre.val_cel AS inc_cel, padre.val_val AS inc_val, NULL::character varying AS inc_opc FROM (valores padre JOIN valores hija ON ((((((padre.val_enc)::text = (hija.val_enc)::text) AND ((padre.val_for)::text = (hija.val_for)::text)) AND ((padre.val_cel)::text = (hija.val_cel)::text)) AND ((padre.val_val)::text = (hija.val_padre)::text)))) GROUP BY padre.val_enc, padre.val_for, padre.val_cel, padre.val_val HAVING (min((hija.val_tipovar)::text) <> max((hija.val_tipovar)::text))) UNION SELECT ((((('Hay dos valores iguales con nombre de variable distinto. val_val='::text || (valores.val_val)::text) || ' son: '::text) || max((COALESCE(valores.val_variable, '"la por defecto"'::character varying))::text)) || ' y '::text) || min((COALESCE(valores.val_variable, '"la por defecto"'::character varying))::text)) AS inc_problema, valores.val_enc AS inc_enc, NULL::character varying AS inc_for, valores.val_cel AS inc_cel, valores.val_val AS inc_val, NULL::character varying AS inc_opc FROM valores GROUP BY valores.val_enc, valores.val_cel, valores.val_val HAVING (max((COALESCE(valores.val_variable, '*'::character varying))::text) <> min((COALESCE(valores.val_variable, '*'::character varying))::text))) UNION SELECT ((((((('Hay columnas repetidas en las tablas de datos. Columna:'::text || (columns.column_name)::text) || ' repeticiones: '::text) || count(*)) || ' tablas: '::text) || max((columns.table_name)::text)) || ' y '::text) || min((columns.table_name)::text)) AS inc_problema, NULL::character varying AS inc_enc, NULL::character varying AS inc_for, NULL::character varying AS inc_cel, NULL::character varying AS inc_val, NULL::character varying AS inc_opc FROM information_schema.columns WHERE ((((columns.table_schema)::text = 'yeah'::text) AND ((columns.table_name)::text ~~ 'eah10%'::text)) AND ((columns.column_name)::text <> ALL (ARRAY[('nenc'::character varying)::text, ('nhogar'::character varying)::text, ('miembro'::character varying)::text, ('log'::character varying)::text, ('obs'::character varying)::text, ('usuario'::character varying)::text]))) GROUP BY columns.column_name HAVING (count(*) > 1);


ALTER TABLE yeah.inconsistencias_estructurales OWNER TO yeahowner;

--
-- Name: matrices; Type: TABLE; Schema: yeah; Owner: yeahowner; Tablespace: 
--

CREATE TABLE matrices (
    mat_enc character varying(50) NOT NULL,
    mat_for character varying(50) NOT NULL,
    mat_mat character varying(50) NOT NULL,
    mat_nombre character varying(250) NOT NULL,
    mat_tabla_destino character varying(50) NOT NULL,
    CONSTRAINT "texto invalido en mat_enc de tabla matrices" CHECK (comun.cadena_valida((mat_enc)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en mat_for de tabla matrices" CHECK (comun.cadena_valida((mat_for)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en mat_mat de tabla matrices" CHECK (comun.cadena_valida((mat_mat)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en mat_nombre de tabla matrices" CHECK (comun.cadena_valida((mat_nombre)::text, 'castellano'::text)),
    CONSTRAINT "texto invalido en mat_tabla_destino de tabla matrices" CHECK (comun.cadena_valida((mat_tabla_destino)::text, 'codigo'::text))
);


ALTER TABLE yeah.matrices OWNER TO yeahowner;

--
-- Name: norea; Type: TABLE; Schema: yeah; Owner: yeahowner; Tablespace: 
--

CREATE TABLE norea (
    norea_norea integer NOT NULL
);


ALTER TABLE yeah.norea OWNER TO yeahowner;

--
-- Name: noreamd; Type: TABLE; Schema: yeah; Owner: yeahowner; Tablespace: 
--

CREATE TABLE noreamd (
    noreamd_noreamd integer NOT NULL
);


ALTER TABLE yeah.noreamd OWNER TO yeahowner;

--
-- Name: numeros; Type: TABLE; Schema: yeah; Owner: yeahowner; Tablespace: 
--

CREATE TABLE numeros (
    num_num integer NOT NULL
);


ALTER TABLE yeah.numeros OWNER TO yeahowner;

--
-- Name: numeros_provisorios_seq; Type: SEQUENCE; Schema: yeah; Owner: yeahowner
--

CREATE SEQUENCE numeros_provisorios_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE yeah.numeros_provisorios_seq OWNER TO yeahowner;

--
-- Name: opciones_tmp; Type: TABLE; Schema: yeah; Owner: yeahowner; Tablespace: 
--

CREATE TABLE opciones_tmp (
    opc_enc character varying(50),
    opc_for character varying(50),
    opc_pre character varying(250),
    opc_opc character varying(50),
    opc_texto character varying(150),
    opc_salta_pre character varying(50),
    opc_aclaracion character varying(150),
    opc_orden integer,
    opc_tiene_otros_especificar boolean,
    opc_tipovar_heterogenea character varying(50),
    opc_valor_heterogenea character varying(50),
    CONSTRAINT "texto invalido en opc_aclaracion de tabla opciones_tmp" CHECK (comun.cadena_valida((opc_aclaracion)::text, 'cualquiera'::text)),
    CONSTRAINT "texto invalido en opc_enc de tabla opciones_tmp" CHECK (comun.cadena_valida((opc_enc)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en opc_for de tabla opciones_tmp" CHECK (comun.cadena_valida((opc_for)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en opc_opc de tabla opciones_tmp" CHECK (comun.cadena_valida((opc_opc)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en opc_pre de tabla opciones_tmp" CHECK (comun.cadena_valida((opc_pre)::text, 'extendido'::text)),
    CONSTRAINT "texto invalido en opc_salta_pre de tabla opciones_tmp" CHECK (comun.cadena_valida((opc_salta_pre)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en opc_texto de tabla opciones_tmp" CHECK (comun.cadena_valida((opc_texto)::text, 'cualquiera'::text)),
    CONSTRAINT "texto invalido en opc_tipovar_heterogenea de tabla opciones_tmp" CHECK (comun.cadena_valida((opc_tipovar_heterogenea)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en opc_valor_heterogenea de tabla opciones_tmp" CHECK (comun.cadena_valida((opc_valor_heterogenea)::text, 'codigo'::text))
);


ALTER TABLE yeah.opciones_tmp OWNER TO yeahowner;

--
-- Name: parametros; Type: TABLE; Schema: yeah; Owner: yeahowner; Tablespace: 
--

CREATE TABLE parametros (
    unicoregistro boolean DEFAULT true NOT NULL,
    estructuraversioncommit numeric NOT NULL,
    versioncommitinstaladoenproduccion integer,
    CONSTRAINT parametros_unicoregistro_check CHECK ((unicoregistro IS TRUE))
);


ALTER TABLE yeah.parametros OWNER TO yeahowner;

--
-- Name: rea; Type: TABLE; Schema: yeah; Owner: yeahowner; Tablespace: 
--

CREATE TABLE rea (
    rea_rea integer NOT NULL
);


ALTER TABLE yeah.rea OWNER TO yeahowner;

--
-- Name: rea_modulo; Type: TABLE; Schema: yeah; Owner: yeahowner; Tablespace: 
--

CREATE TABLE rea_modulo (
    reamodu_reamodu integer NOT NULL
);


ALTER TABLE yeah.rea_modulo OWNER TO yeahowner;

--
-- Name: relaciones; Type: TABLE; Schema: yeah; Owner: yeahowner; Tablespace: 
--

CREATE TABLE relaciones (
    rel_rel character varying(3) NOT NULL,
    rel_nombre character varying(20) NOT NULL,
    CONSTRAINT "texto invalido en rel_nombre de tabla relaciones" CHECK (comun.cadena_valida((rel_nombre)::text, 'castellano'::text)),
    CONSTRAINT "texto invalido en rel_rel de tabla relaciones" CHECK (comun.cadena_valida((rel_rel)::text, 'formula'::text))
);


ALTER TABLE yeah.relaciones OWNER TO yeahowner;

--
-- Name: rol_rol; Type: TABLE; Schema: yeah; Owner: yeahowner; Tablespace: 
--

CREATE TABLE rol_rol (
    rolrol_principal character varying(30) NOT NULL,
    rolrol_delegado character varying(30) NOT NULL,
    CONSTRAINT "texto invalido en rolrol_delegado de tabla rol_rol" CHECK (comun.cadena_valida((rolrol_delegado)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en rolrol_principal de tabla rol_rol" CHECK (comun.cadena_valida((rolrol_principal)::text, 'codigo'::text))
);


ALTER TABLE yeah.rol_rol OWNER TO yeahowner;

--
-- Name: roles; Type: TABLE; Schema: yeah; Owner: yeahowner; Tablespace: 
--

CREATE TABLE roles (
    rol_rol character varying(30) NOT NULL,
    rol_descripcion character varying(200),
    CONSTRAINT "los nombres de roles deben ir en minusculas" CHECK (((rol_rol)::text = lower((rol_rol)::text))),
    CONSTRAINT "texto invalido en rol_descripcion de tabla roles" CHECK (comun.cadena_valida((rol_descripcion)::text, 'castellano'::text)),
    CONSTRAINT "texto invalido en rol_rol de tabla roles" CHECK (comun.cadena_valida((rol_rol)::text, 'codigo'::text))
);


ALTER TABLE yeah.roles OWNER TO yeahowner;

--
-- Name: sesiones; Type: TABLE; Schema: yeah; Owner: yeahowner; Tablespace: 
--

CREATE TABLE sesiones (
    ses_ses integer NOT NULL,
    ses_usu character varying(30) NOT NULL,
    ses_momento timestamp without time zone DEFAULT now(),
    ses_activa boolean DEFAULT true NOT NULL,
    ses_phpsessid character varying(100),
    ses_http_user_agent character varying(500),
    ses_remote_addr character varying(100),
    ses_finalizada timestamp without time zone
);


ALTER TABLE yeah.sesiones OWNER TO yeahowner;

--
-- Name: sesiones_ses_ses_seq; Type: SEQUENCE; Schema: yeah; Owner: yeahowner
--

CREATE SEQUENCE sesiones_ses_ses_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE yeah.sesiones_ses_ses_seq OWNER TO yeahowner;

--
-- Name: sesiones_ses_ses_seq; Type: SEQUENCE OWNED BY; Schema: yeah; Owner: yeahowner
--

ALTER SEQUENCE sesiones_ses_ses_seq OWNED BY sesiones.ses_ses;


--
-- Name: sup_campo; Type: TABLE; Schema: yeah; Owner: yeahowner; Tablespace: 
--

CREATE TABLE sup_campo (
    supcampo_supcampo integer NOT NULL
);


ALTER TABLE yeah.sup_campo OWNER TO yeahowner;

--
-- Name: sup_recu_campo; Type: TABLE; Schema: yeah; Owner: yeahowner; Tablespace: 
--

CREATE TABLE sup_recu_campo (
    suprecucampo_suprecucampo integer NOT NULL
);


ALTER TABLE yeah.sup_recu_campo OWNER TO yeahowner;

--
-- Name: sup_tel; Type: TABLE; Schema: yeah; Owner: yeahowner; Tablespace: 
--

CREATE TABLE sup_tel (
    suptel_suptel integer NOT NULL
);


ALTER TABLE yeah.sup_tel OWNER TO yeahowner;

--
-- Name: tablas; Type: TABLE; Schema: yeah; Owner: yeahowner; Tablespace: 
--

CREATE TABLE tablas (
    tab_tab character varying(50) NOT NULL,
    tab_raiz_json boolean DEFAULT true NOT NULL,
    tab_orden numeric,
    tab_prefijo_campos character varying(20),
    CONSTRAINT "texto invalido en tab_prefijo_campos de tabla tablas" CHECK (comun.cadena_valida((tab_prefijo_campos)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en tab_tab de tabla tablas" CHECK (comun.cadena_valida((tab_tab)::text, 'codigo'::text))
);


ALTER TABLE yeah.tablas OWNER TO yeahowner;

--
-- Name: tabulados; Type: TABLE; Schema: yeah; Owner: yeahowner; Tablespace: 
--

CREATE TABLE tabulados (
    tab_tab character varying(30) NOT NULL,
    tab_var1 character varying(300),
    tab_var2 character varying(300),
    tab_titulo character varying(200),
    tab_detalle character varying(200),
    tab_junta character varying(30),
    tab_ignorar_nulls boolean DEFAULT true NOT NULL,
    CONSTRAINT "texto invalido en tab_detalle de tabla consistencias" CHECK (comun.cadena_valida((tab_detalle)::text, 'castellano'::text)),
    CONSTRAINT "texto invalido en tab_junta de tabla tabulados" CHECK (comun.cadena_valida((tab_junta)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en tab_tab de tabla consistencias" CHECK (comun.cadena_valida((tab_tab)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en tab_titulo de tabla consistencias" CHECK (comun.cadena_valida((tab_titulo)::text, 'castellano'::text)),
    CONSTRAINT "texto invalido en tab_var1 de tabla consistencias" CHECK (comun.cadena_valida((tab_var1)::text, 'formula'::text)),
    CONSTRAINT "texto invalido en tab_var2 de tabla consistencias" CHECK (comun.cadena_valida((tab_var2)::text, 'formula'::text))
);


ALTER TABLE yeah.tabulados OWNER TO yeahowner;

--
-- Name: tipo_cel; Type: TABLE; Schema: yeah; Owner: yeahowner; Tablespace: 
--

CREATE TABLE tipo_cel (
    tipocel_tipocel character varying(50) NOT NULL,
    tipocel_sufijo_variable_agregada character varying(50),
    tipocel_tipovar_variable_agregada character varying(50),
    tipocel_genera_var_por_cada_opcion boolean,
    tipocel_desplegar_opciones boolean,
    tipocel_texto_variable_agregada character varying(50),
    tipocel_texto_mejor character varying(50),
    CONSTRAINT "texto invalido en tipocel_sufijo_variable_agregada de tabla tip" CHECK (comun.cadena_valida((tipocel_sufijo_variable_agregada)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en tipocel_texto_mejor de tabla tipo_cel" CHECK (comun.cadena_valida((tipocel_texto_mejor)::text, 'cualquiera'::text)),
    CONSTRAINT "texto invalido en tipocel_texto_variable_agregada de tabla tipo" CHECK (comun.cadena_valida((tipocel_texto_variable_agregada)::text, 'castellano'::text)),
    CONSTRAINT "texto invalido en tipocel_tipocel de tabla tipo_cel" CHECK (comun.cadena_valida((tipocel_tipocel)::text, 'extendido'::text)),
    CONSTRAINT "texto invalido en tipocel_tipovar_variable_agregada de tabla ti" CHECK (comun.cadena_valida((tipocel_tipovar_variable_agregada)::text, 'codigo'::text))
);


ALTER TABLE yeah.tipo_cel OWNER TO yeahowner;

--
-- Name: tipo_var; Type: TABLE; Schema: yeah; Owner: yeahowner; Tablespace: 
--

CREATE TABLE tipo_var (
    tipovar_tipovar character varying(50) NOT NULL,
    tipovar_tipo_dato_cs character varying(50),
    tipovar_longitud character varying(50),
    tipovar_necesita_longitud boolean NOT NULL,
    tipovar_texto_derecha boolean DEFAULT false NOT NULL,
    tipovar_es_numerico boolean,
    tipovar_maximo numeric,
    tipovar_minimo numeric,
    tipovar_advertencia_sup numeric,
    tipovar_advertencia_inf numeric,
    tipovar_para_marcar boolean DEFAULT false NOT NULL,
    tipovar_es_multiple_con_opciones boolean DEFAULT false NOT NULL,
    tipovar_es_visible boolean DEFAULT true,
    tipovar_nsnc integer,
    CONSTRAINT "texto invalido en tipovar_longitud de tabla tipo_var" CHECK (comun.cadena_valida((tipovar_longitud)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en tipovar_tipo_dato_cs de tabla tipo_var" CHECK (comun.cadena_valida((tipovar_tipo_dato_cs)::text, 'extendido'::text)),
    CONSTRAINT "texto invalido en tipovar_tipovar de tabla tipo_var" CHECK (comun.cadena_valida((tipovar_tipovar)::text, 'codigo'::text))
);


ALTER TABLE yeah.tipo_var OWNER TO yeahowner;

--
-- Name: usuarios; Type: TABLE; Schema: yeah; Owner: yeahowner; Tablespace: 
--

CREATE TABLE usuarios (
    usu_usu character varying(30) NOT NULL,
    usu_rol character varying(30),
    usu_activo boolean DEFAULT false NOT NULL,
    usu_nombre character varying(100),
    usu_apellido character varying(100),
    usu_clave character varying(50),
    usu_interno character varying(30),
    usu_mail character varying(200),
    CONSTRAINT "debe ingresar una clave provisoria para el usuario" CHECK (((usu_activo IS NOT TRUE) OR (usu_clave IS NOT NULL))),
    CONSTRAINT "los nombres de usuario deben ir en minusculas" CHECK (((usu_usu)::text = lower((usu_usu)::text))),
    CONSTRAINT "para activarlo debe ingresar el apellido del usuario" CHECK (((usu_activo IS NOT TRUE) OR (usu_apellido IS NOT NULL))),
    CONSTRAINT "para activarlo debe ingresar el nombre del usuario" CHECK (((usu_activo IS NOT TRUE) OR (usu_nombre IS NOT NULL))),
    CONSTRAINT "para activarlo debe ingresar la funcion del usuario" CHECK (((usu_activo IS NOT TRUE) OR (usu_rol IS NOT NULL))),
    CONSTRAINT "texto invalido en usu_apellido de tabla usuarios" CHECK (comun.cadena_valida((usu_apellido)::text, 'castellano'::text)),
    CONSTRAINT "texto invalido en usu_clave de tabla usuarios" CHECK (comun.cadena_valida((usu_clave)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en usu_funcion de tabla usuarios" CHECK (comun.cadena_valida((usu_rol)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en usu_interno de tabla usuarios" CHECK (comun.cadena_valida((usu_interno)::text, 'extendido'::text)),
    CONSTRAINT "texto invalido en usu_mail de tabla usuarios" CHECK (comun.cadena_valida((usu_mail)::text, 'extendido'::text)),
    CONSTRAINT "texto invalido en usu_nombre de tabla usuarios" CHECK (comun.cadena_valida((usu_nombre)::text, 'castellano'::text)),
    CONSTRAINT "texto invalido en usu_rol de tabla usuarios" CHECK (comun.cadena_valida((usu_rol)::text, 'codigo'::text)),
    CONSTRAINT "texto invalido en usu_usu de tabla usuarios" CHECK (comun.cadena_valida((usu_usu)::text, 'codigo'::text))
);


ALTER TABLE yeah.usuarios OWNER TO yeahowner;

--
-- Name: variables; Type: TABLE; Schema: yeah; Owner: yeahowner; Tablespace: 
--

CREATE TABLE variables (
    var_enc character varying(50) NOT NULL,
    var_for character varying(50),
    var_cel character varying(250),
    var_val character varying(50),
    var_var character varying(50) NOT NULL,
    var_texto character varying(300),
    var_salta character varying(50),
    var_aclaracion character varying(150),
    var_orden integer,
    var_tipovar character varying(50),
    var_maximo numeric,
    var_minimo numeric,
    var_advertencia_sup numeric,
    var_advertencia_inf numeric,
    var_padre character varying(50),
    var_variable character varying(50),
    var_expresion character varying(250),
    var_expresion_habilitar character varying(500),
    var_mejor_de_celda character varying(50),
    var_optativa boolean,
    var_es_numerico boolean,
    var_para_marcar boolean,
    var_multipleconopciones boolean,
    var_mat character varying(50),
    var_nsnc integer
);


ALTER TABLE yeah.variables OWNER TO yeahowner;

--
-- Name: ses_ses; Type: DEFAULT; Schema: yeah; Owner: yeahowner
--

ALTER TABLE sesiones ALTER COLUMN ses_ses SET DEFAULT nextval('sesiones_ses_ses_seq'::regclass);


--
-- Name: ano_con_pkey; Type: CONSTRAINT; Schema: yeah; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY ano_con
    ADD CONSTRAINT ano_con_pkey PRIMARY KEY (anocon_con, anocon_num);


--
-- Name: aux_tem_cambios_pkey; Type: CONSTRAINT; Schema: yeah; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY aux_tem_cambios
    ADD CONSTRAINT aux_tem_cambios_pkey PRIMARY KEY (encues);


--
-- Name: celdas_pkey; Type: CONSTRAINT; Schema: yeah; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY celdas
    ADD CONSTRAINT celdas_pkey PRIMARY KEY (cel_enc, cel_for, cel_cel);


--
-- Name: consistencias_pkey; Type: CONSTRAINT; Schema: yeah; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY consistencias
    ADD CONSTRAINT consistencias_pkey PRIMARY KEY (con_con);


--
-- Name: eah10_md_pkey; Type: CONSTRAINT; Schema: yeah; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY eah10_md
    ADD CONSTRAINT eah10_md_pkey PRIMARY KEY (nenc, nhogar, miembro);


--
-- Name: eah10_un_pkey; Type: CONSTRAINT; Schema: yeah; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY eah10_un
    ADD CONSTRAINT eah10_un_pkey PRIMARY KEY (nenc, nhogar, miembro, relacion);


--
-- Name: eah10_viv_s1a1_pkey; Type: CONSTRAINT; Schema: yeah; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY eah10_viv_s1a1
    ADD CONSTRAINT eah10_viv_s1a1_pkey PRIMARY KEY (id, nhogar);


--
-- Name: encuestas_pk; Type: CONSTRAINT; Schema: yeah; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY encuestas
    ADD CONSTRAINT encuestas_pk PRIMARY KEY (enc_enc);


--
-- Name: formularios_pk; Type: CONSTRAINT; Schema: yeah; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY formularios
    ADD CONSTRAINT formularios_pk PRIMARY KEY (for_enc, for_for);


--
-- Name: matrices_pkey; Type: CONSTRAINT; Schema: yeah; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY matrices
    ADD CONSTRAINT matrices_pkey PRIMARY KEY (mat_enc, mat_for, mat_mat);


--
-- Name: norea_pkey; Type: CONSTRAINT; Schema: yeah; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY norea
    ADD CONSTRAINT norea_pkey PRIMARY KEY (norea_norea);


--
-- Name: noreamd_pkey; Type: CONSTRAINT; Schema: yeah; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY noreamd
    ADD CONSTRAINT noreamd_pkey PRIMARY KEY (noreamd_noreamd);


--
-- Name: numeros_pk; Type: CONSTRAINT; Schema: yeah; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY numeros
    ADD CONSTRAINT numeros_pk PRIMARY KEY (num_num);


--
-- Name: parametros_pkey; Type: CONSTRAINT; Schema: yeah; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY parametros
    ADD CONSTRAINT parametros_pkey PRIMARY KEY (unicoregistro);


--
-- Name: rea_modulo_pkey; Type: CONSTRAINT; Schema: yeah; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY rea_modulo
    ADD CONSTRAINT rea_modulo_pkey PRIMARY KEY (reamodu_reamodu);


--
-- Name: rea_pkey; Type: CONSTRAINT; Schema: yeah; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY rea
    ADD CONSTRAINT rea_pkey PRIMARY KEY (rea_rea);


--
-- Name: relaciones_pkey; Type: CONSTRAINT; Schema: yeah; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY relaciones
    ADD CONSTRAINT relaciones_pkey PRIMARY KEY (rel_rel);


--
-- Name: rol_rol_pkey; Type: CONSTRAINT; Schema: yeah; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY rol_rol
    ADD CONSTRAINT rol_rol_pkey PRIMARY KEY (rolrol_principal, rolrol_delegado);


--
-- Name: roles_pkey; Type: CONSTRAINT; Schema: yeah; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (rol_rol);


--
-- Name: sesiones_pkey; Type: CONSTRAINT; Schema: yeah; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY sesiones
    ADD CONSTRAINT sesiones_pkey PRIMARY KEY (ses_ses);


--
-- Name: sup_campo_pkey; Type: CONSTRAINT; Schema: yeah; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY sup_campo
    ADD CONSTRAINT sup_campo_pkey PRIMARY KEY (supcampo_supcampo);


--
-- Name: sup_recu_campo_pkey; Type: CONSTRAINT; Schema: yeah; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY sup_recu_campo
    ADD CONSTRAINT sup_recu_campo_pkey PRIMARY KEY (suprecucampo_suprecucampo);


--
-- Name: sup_tel_pkey; Type: CONSTRAINT; Schema: yeah; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY sup_tel
    ADD CONSTRAINT sup_tel_pkey PRIMARY KEY (suptel_suptel);


--
-- Name: tablas_pkey; Type: CONSTRAINT; Schema: yeah; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY tablas
    ADD CONSTRAINT tablas_pkey PRIMARY KEY (tab_tab);


--
-- Name: tabulados_pkey; Type: CONSTRAINT; Schema: yeah; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY tabulados
    ADD CONSTRAINT tabulados_pkey PRIMARY KEY (tab_tab);


--
-- Name: tipos_pk; Type: CONSTRAINT; Schema: yeah; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY tipo_cel
    ADD CONSTRAINT tipos_pk PRIMARY KEY (tipocel_tipocel);


--
-- Name: tipovar_opciones_pkey; Type: CONSTRAINT; Schema: yeah; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY tipovar_opciones
    ADD CONSTRAINT tipovar_opciones_pkey PRIMARY KEY (tipovaropc_tipovar, tipovaropc_opc);


--
-- Name: tipovar_pk; Type: CONSTRAINT; Schema: yeah; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY tipo_var
    ADD CONSTRAINT tipovar_pk PRIMARY KEY (tipovar_tipovar);


--
-- Name: usuarios_pkey; Type: CONSTRAINT; Schema: yeah; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (usu_usu);


--
-- Name: valores_pkey; Type: CONSTRAINT; Schema: yeah; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY valores
    ADD CONSTRAINT valores_pkey PRIMARY KEY (val_enc, val_for, val_cel, val_val);


--
-- Name: variables_pkey; Type: CONSTRAINT; Schema: yeah; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY variables
    ADD CONSTRAINT variables_pkey PRIMARY KEY (var_enc, var_var);


--
-- Name: fki_; Type: INDEX; Schema: yeah; Owner: yeahowner; Tablespace: 
--

CREATE INDEX fki_ ON celdas USING btree (cel_tipo);


--
-- Name: fki_opc_pre_salta; Type: INDEX; Schema: yeah; Owner: yeahowner; Tablespace: 
--

CREATE INDEX fki_opc_pre_salta ON valores USING btree (val_salta);


--
-- Name: fki_opciones_tipovar; Type: INDEX; Schema: yeah; Owner: yeahowner; Tablespace: 
--

CREATE INDEX fki_opciones_tipovar ON valores USING btree (val_tipovar);


--
-- Name: con_borrar_campos_calculados_trg; Type: TRIGGER; Schema: yeah; Owner: yeahowner
--

CREATE TRIGGER con_borrar_campos_calculados_trg BEFORE UPDATE ON consistencias FOR EACH ROW EXECUTE PROCEDURE con_borrar_campos_calculados_trg();


--
-- Name: ano_con_anocon_con_fkey; Type: FK CONSTRAINT; Schema: yeah; Owner: yeahowner
--

ALTER TABLE ONLY ano_con
    ADD CONSTRAINT ano_con_anocon_con_fkey FOREIGN KEY (anocon_con) REFERENCES consistencias(con_con);


--
-- Name: celdas_cel_enc_fkey; Type: FK CONSTRAINT; Schema: yeah; Owner: yeahowner
--

ALTER TABLE ONLY celdas
    ADD CONSTRAINT celdas_cel_enc_fkey FOREIGN KEY (cel_enc, cel_for, cel_mat) REFERENCES matrices(mat_enc, mat_for, mat_mat) ON UPDATE CASCADE;


--
-- Name: celdas_cel_enc_fkey1; Type: FK CONSTRAINT; Schema: yeah; Owner: yeahowner
--

ALTER TABLE ONLY celdas
    ADD CONSTRAINT celdas_cel_enc_fkey1 FOREIGN KEY (cel_enc, cel_for) REFERENCES formularios(for_enc, for_for) ON UPDATE CASCADE;


--
-- Name: celdas_cel_enc_fkey2; Type: FK CONSTRAINT; Schema: yeah; Owner: yeahowner
--

ALTER TABLE ONLY celdas
    ADD CONSTRAINT celdas_cel_enc_fkey2 FOREIGN KEY (cel_enc, cel_for, cel_incluir_mat) REFERENCES matrices(mat_enc, mat_for, mat_mat);


--
-- Name: consistencias_con_rel_fkey; Type: FK CONSTRAINT; Schema: yeah; Owner: yeahowner
--

ALTER TABLE ONLY consistencias
    ADD CONSTRAINT consistencias_con_rel_fkey FOREIGN KEY (con_rel) REFERENCES relaciones(rel_rel);


--
-- Name: formularios_for_enc_fkey; Type: FK CONSTRAINT; Schema: yeah; Owner: yeahowner
--

ALTER TABLE ONLY formularios
    ADD CONSTRAINT formularios_for_enc_fkey FOREIGN KEY (for_enc) REFERENCES encuestas(enc_enc) ON UPDATE CASCADE;


--
-- Name: matrices_mat_enc_fkey; Type: FK CONSTRAINT; Schema: yeah; Owner: yeahowner
--

ALTER TABLE ONLY matrices
    ADD CONSTRAINT matrices_mat_enc_fkey FOREIGN KEY (mat_enc, mat_for) REFERENCES formularios(for_enc, for_for) ON UPDATE CASCADE;


--
-- Name: opciones_tipovar; Type: FK CONSTRAINT; Schema: yeah; Owner: yeahowner
--

ALTER TABLE ONLY valores
    ADD CONSTRAINT opciones_tipovar FOREIGN KEY (val_tipovar) REFERENCES tipo_var(tipovar_tipovar);


--
-- Name: preguntas_pre_tipo_fkey; Type: FK CONSTRAINT; Schema: yeah; Owner: yeahowner
--

ALTER TABLE ONLY celdas
    ADD CONSTRAINT preguntas_pre_tipo_fkey FOREIGN KEY (cel_tipo) REFERENCES tipo_cel(tipocel_tipocel);


--
-- Name: rol_rol_rolrol_delegado_fkey; Type: FK CONSTRAINT; Schema: yeah; Owner: yeahowner
--

ALTER TABLE ONLY rol_rol
    ADD CONSTRAINT rol_rol_rolrol_delegado_fkey FOREIGN KEY (rolrol_delegado) REFERENCES roles(rol_rol) ON UPDATE CASCADE;


--
-- Name: rol_rol_rolrol_principal_fkey; Type: FK CONSTRAINT; Schema: yeah; Owner: yeahowner
--

ALTER TABLE ONLY rol_rol
    ADD CONSTRAINT rol_rol_rolrol_principal_fkey FOREIGN KEY (rolrol_principal) REFERENCES roles(rol_rol) ON UPDATE CASCADE;


--
-- Name: tipovar_opciones_tipovaropc_tipovar_fkey; Type: FK CONSTRAINT; Schema: yeah; Owner: yeahowner
--

ALTER TABLE ONLY tipovar_opciones
    ADD CONSTRAINT tipovar_opciones_tipovaropc_tipovar_fkey FOREIGN KEY (tipovaropc_tipovar) REFERENCES tipo_var(tipovar_tipovar);


--
-- Name: usuarios_usu_rol_fkey; Type: FK CONSTRAINT; Schema: yeah; Owner: yeahowner
--

ALTER TABLE ONLY usuarios
    ADD CONSTRAINT usuarios_usu_rol_fkey FOREIGN KEY (usu_rol) REFERENCES roles(rol_rol) ON UPDATE CASCADE;


--
-- Name: valores_padres; Type: FK CONSTRAINT; Schema: yeah; Owner: yeahowner
--

ALTER TABLE ONLY valores
    ADD CONSTRAINT valores_padres FOREIGN KEY (val_enc, val_for, val_cel, val_padre) REFERENCES valores(val_enc, val_for, val_cel, val_val) ON UPDATE CASCADE;


--
-- Name: valores_val_enc_fkey; Type: FK CONSTRAINT; Schema: yeah; Owner: yeahowner
--

ALTER TABLE ONLY valores
    ADD CONSTRAINT valores_val_enc_fkey FOREIGN KEY (val_enc, val_for, val_salta) REFERENCES celdas(cel_enc, cel_for, cel_cel) ON UPDATE CASCADE;


--
-- Name: valores_val_enc_fkey1; Type: FK CONSTRAINT; Schema: yeah; Owner: yeahowner
--

ALTER TABLE ONLY valores
    ADD CONSTRAINT valores_val_enc_fkey1 FOREIGN KEY (val_enc, val_for, val_cel) REFERENCES celdas(cel_enc, cel_for, cel_cel) ON UPDATE CASCADE;


--
-- Name: valores_val_tipovar_fkey; Type: FK CONSTRAINT; Schema: yeah; Owner: yeahowner
--

ALTER TABLE ONLY valores
    ADD CONSTRAINT valores_val_tipovar_fkey FOREIGN KEY (val_tipovar) REFERENCES tipo_var(tipovar_tipovar);


--
-- Name: dbo; Type: ACL; Schema: -; Owner: yeahowner
--

REVOKE ALL ON SCHEMA dbo FROM PUBLIC;
REVOKE ALL ON SCHEMA dbo FROM yeahowner;
GRANT ALL ON SCHEMA dbo TO yeahowner;
GRANT USAGE ON SCHEMA dbo TO yeah_test;


--
-- Name: yeah; Type: ACL; Schema: -; Owner: yeahowner
--

REVOKE ALL ON SCHEMA yeah FROM PUBLIC;
REVOKE ALL ON SCHEMA yeah FROM yeahowner;
GRANT ALL ON SCHEMA yeah TO yeahowner;
GRANT USAGE ON SCHEMA yeah TO yeah_test;


--
-- Name: ano_con; Type: ACL; Schema: yeah; Owner: yeahowner
--

REVOKE ALL ON TABLE ano_con FROM PUBLIC;
REVOKE ALL ON TABLE ano_con FROM yeahowner;
GRANT ALL ON TABLE ano_con TO yeahowner;
GRANT SELECT ON TABLE ano_con TO yeah_test;


--
-- Name: aux_tem_cambios; Type: ACL; Schema: yeah; Owner: yeahowner
--

REVOKE ALL ON TABLE aux_tem_cambios FROM PUBLIC;
REVOKE ALL ON TABLE aux_tem_cambios FROM yeahowner;
GRANT ALL ON TABLE aux_tem_cambios TO yeahowner;
GRANT SELECT ON TABLE aux_tem_cambios TO yeah_test;


--
-- Name: celdas; Type: ACL; Schema: yeah; Owner: yeahowner
--

REVOKE ALL ON TABLE celdas FROM PUBLIC;
REVOKE ALL ON TABLE celdas FROM yeahowner;
GRANT ALL ON TABLE celdas TO yeahowner;
GRANT SELECT ON TABLE celdas TO yeah_test;


--
-- Name: consistencias; Type: ACL; Schema: yeah; Owner: yeahowner
--

REVOKE ALL ON TABLE consistencias FROM PUBLIC;
REVOKE ALL ON TABLE consistencias FROM yeahowner;
GRANT ALL ON TABLE consistencias TO yeahowner;
GRANT SELECT ON TABLE consistencias TO yeah_test;


--
-- Name: eah10_ex; Type: ACL; Schema: yeah; Owner: yeahowner
--

REVOKE ALL ON TABLE eah10_ex FROM PUBLIC;
REVOKE ALL ON TABLE eah10_ex FROM yeahowner;
GRANT ALL ON TABLE eah10_ex TO yeahowner;
GRANT SELECT ON TABLE eah10_ex TO yeah_test;


--
-- Name: eah10_fam; Type: ACL; Schema: yeah; Owner: yeahowner
--

REVOKE ALL ON TABLE eah10_fam FROM PUBLIC;
REVOKE ALL ON TABLE eah10_fam FROM yeahowner;
GRANT ALL ON TABLE eah10_fam TO yeahowner;
GRANT SELECT ON TABLE eah10_fam TO yeah_test;


--
-- Name: eah10_i1; Type: ACL; Schema: yeah; Owner: yeahowner
--

REVOKE ALL ON TABLE eah10_i1 FROM PUBLIC;
REVOKE ALL ON TABLE eah10_i1 FROM yeahowner;
GRANT ALL ON TABLE eah10_i1 TO yeahowner;
GRANT SELECT ON TABLE eah10_i1 TO yeah_test;


--
-- Name: eah10_md; Type: ACL; Schema: yeah; Owner: yeahowner
--

REVOKE ALL ON TABLE eah10_md FROM PUBLIC;
REVOKE ALL ON TABLE eah10_md FROM yeahowner;
GRANT ALL ON TABLE eah10_md TO yeahowner;
GRANT SELECT ON TABLE eah10_md TO yeah_test;


--
-- Name: eah10_tv; Type: ACL; Schema: yeah; Owner: yeahowner
--

REVOKE ALL ON TABLE eah10_tv FROM PUBLIC;
REVOKE ALL ON TABLE eah10_tv FROM yeahowner;
GRANT ALL ON TABLE eah10_tv TO yeahowner;
GRANT SELECT ON TABLE eah10_tv TO yeah_test;


--
-- Name: eah10_un; Type: ACL; Schema: yeah; Owner: yeahowner
--

REVOKE ALL ON TABLE eah10_un FROM PUBLIC;
REVOKE ALL ON TABLE eah10_un FROM yeahowner;
GRANT ALL ON TABLE eah10_un TO yeahowner;
GRANT SELECT ON TABLE eah10_un TO yeah_test;


--
-- Name: eah10_viv_s1a1; Type: ACL; Schema: yeah; Owner: yeahowner
--

REVOKE ALL ON TABLE eah10_viv_s1a1 FROM PUBLIC;
REVOKE ALL ON TABLE eah10_viv_s1a1 FROM yeahowner;
GRANT ALL ON TABLE eah10_viv_s1a1 TO yeahowner;
GRANT SELECT ON TABLE eah10_viv_s1a1 TO yeah_test;


--
-- Name: encuestas; Type: ACL; Schema: yeah; Owner: yeahowner
--

REVOKE ALL ON TABLE encuestas FROM PUBLIC;
REVOKE ALL ON TABLE encuestas FROM yeahowner;
GRANT ALL ON TABLE encuestas TO yeahowner;
GRANT SELECT ON TABLE encuestas TO yeah_test;


--
-- Name: formularios; Type: ACL; Schema: yeah; Owner: yeahowner
--

REVOKE ALL ON TABLE formularios FROM PUBLIC;
REVOKE ALL ON TABLE formularios FROM yeahowner;
GRANT ALL ON TABLE formularios TO yeahowner;
GRANT SELECT ON TABLE formularios TO yeah_test;


--
-- Name: tipovar_opciones; Type: ACL; Schema: yeah; Owner: yeahowner
--

REVOKE ALL ON TABLE tipovar_opciones FROM PUBLIC;
REVOKE ALL ON TABLE tipovar_opciones FROM yeahowner;
GRANT ALL ON TABLE tipovar_opciones TO yeahowner;
GRANT SELECT ON TABLE tipovar_opciones TO yeah_test;


--
-- Name: valores; Type: ACL; Schema: yeah; Owner: yeahowner
--

REVOKE ALL ON TABLE valores FROM PUBLIC;
REVOKE ALL ON TABLE valores FROM yeahowner;
GRANT ALL ON TABLE valores TO yeahowner;
GRANT SELECT ON TABLE valores TO yeah_test;


--
-- Name: inconsistencias_estructurales; Type: ACL; Schema: yeah; Owner: yeahowner
--

REVOKE ALL ON TABLE inconsistencias_estructurales FROM PUBLIC;
REVOKE ALL ON TABLE inconsistencias_estructurales FROM yeahowner;
GRANT ALL ON TABLE inconsistencias_estructurales TO yeahowner;
GRANT SELECT ON TABLE inconsistencias_estructurales TO yeah_test;


--
-- Name: matrices; Type: ACL; Schema: yeah; Owner: yeahowner
--

REVOKE ALL ON TABLE matrices FROM PUBLIC;
REVOKE ALL ON TABLE matrices FROM yeahowner;
GRANT ALL ON TABLE matrices TO yeahowner;
GRANT SELECT ON TABLE matrices TO yeah_test;


--
-- Name: numeros; Type: ACL; Schema: yeah; Owner: yeahowner
--

REVOKE ALL ON TABLE numeros FROM PUBLIC;
REVOKE ALL ON TABLE numeros FROM yeahowner;
GRANT ALL ON TABLE numeros TO yeahowner;
GRANT SELECT ON TABLE numeros TO yeah_test;


--
-- Name: opciones_tmp; Type: ACL; Schema: yeah; Owner: yeahowner
--

REVOKE ALL ON TABLE opciones_tmp FROM PUBLIC;
REVOKE ALL ON TABLE opciones_tmp FROM yeahowner;
GRANT ALL ON TABLE opciones_tmp TO yeahowner;
GRANT SELECT ON TABLE opciones_tmp TO yeah_test;


--
-- Name: parametros; Type: ACL; Schema: yeah; Owner: yeahowner
--

REVOKE ALL ON TABLE parametros FROM PUBLIC;
REVOKE ALL ON TABLE parametros FROM yeahowner;
GRANT ALL ON TABLE parametros TO yeahowner;
GRANT SELECT ON TABLE parametros TO yeah_test;


--
-- Name: relaciones; Type: ACL; Schema: yeah; Owner: yeahowner
--

REVOKE ALL ON TABLE relaciones FROM PUBLIC;
REVOKE ALL ON TABLE relaciones FROM yeahowner;
GRANT ALL ON TABLE relaciones TO yeahowner;
GRANT SELECT ON TABLE relaciones TO yeah_test;


--
-- Name: rol_rol; Type: ACL; Schema: yeah; Owner: yeahowner
--

REVOKE ALL ON TABLE rol_rol FROM PUBLIC;
REVOKE ALL ON TABLE rol_rol FROM yeahowner;
GRANT ALL ON TABLE rol_rol TO yeahowner;
GRANT SELECT ON TABLE rol_rol TO yeah_test;


--
-- Name: roles; Type: ACL; Schema: yeah; Owner: yeahowner
--

REVOKE ALL ON TABLE roles FROM PUBLIC;
REVOKE ALL ON TABLE roles FROM yeahowner;
GRANT ALL ON TABLE roles TO yeahowner;
GRANT SELECT ON TABLE roles TO yeah_test;


--
-- Name: sesiones; Type: ACL; Schema: yeah; Owner: yeahowner
--

REVOKE ALL ON TABLE sesiones FROM PUBLIC;
REVOKE ALL ON TABLE sesiones FROM yeahowner;
GRANT ALL ON TABLE sesiones TO yeahowner;
GRANT SELECT ON TABLE sesiones TO yeah_test;


--
-- Name: tablas; Type: ACL; Schema: yeah; Owner: yeahowner
--

REVOKE ALL ON TABLE tablas FROM PUBLIC;
REVOKE ALL ON TABLE tablas FROM yeahowner;
GRANT ALL ON TABLE tablas TO yeahowner;
GRANT SELECT ON TABLE tablas TO yeah_test;


--
-- Name: tipo_cel; Type: ACL; Schema: yeah; Owner: yeahowner
--

REVOKE ALL ON TABLE tipo_cel FROM PUBLIC;
REVOKE ALL ON TABLE tipo_cel FROM yeahowner;
GRANT ALL ON TABLE tipo_cel TO yeahowner;
GRANT SELECT ON TABLE tipo_cel TO yeah_test;


--
-- Name: tipo_var; Type: ACL; Schema: yeah; Owner: yeahowner
--

REVOKE ALL ON TABLE tipo_var FROM PUBLIC;
REVOKE ALL ON TABLE tipo_var FROM yeahowner;
GRANT ALL ON TABLE tipo_var TO yeahowner;
GRANT SELECT ON TABLE tipo_var TO yeah_test;


--
-- Name: usuarios; Type: ACL; Schema: yeah; Owner: yeahowner
--

REVOKE ALL ON TABLE usuarios FROM PUBLIC;
REVOKE ALL ON TABLE usuarios FROM yeahowner;
GRANT ALL ON TABLE usuarios TO yeahowner;
GRANT SELECT ON TABLE usuarios TO yeah_test;


--
-- Name: variables; Type: ACL; Schema: yeah; Owner: yeahowner
--

REVOKE ALL ON TABLE variables FROM PUBLIC;
REVOKE ALL ON TABLE variables FROM yeahowner;
GRANT ALL ON TABLE variables TO yeahowner;
GRANT SELECT ON TABLE variables TO yeah_test;


--
-- PostgreSQL database dump complete
--

