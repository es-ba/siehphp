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
-- Name: his; Type: SCHEMA; Schema: -; Owner: yeahowner
--

CREATE SCHEMA his;


ALTER SCHEMA his OWNER TO yeahowner;

--
-- Name: test; Type: SCHEMA; Schema: -; Owner: yeahowner
--

CREATE SCHEMA test;


ALTER SCHEMA test OWNER TO yeahowner;

--
-- Name: yeah_2009; Type: SCHEMA; Schema: -; Owner: yeahowner
--

CREATE SCHEMA yeah_2009;


ALTER SCHEMA yeah_2009 OWNER TO yeahowner;

--
-- Name: yeah_2010; Type: SCHEMA; Schema: -; Owner: yeahowner
--

CREATE SCHEMA yeah_2010;


ALTER SCHEMA yeah_2010 OWNER TO yeahowner;

--
-- Name: yeah_2011; Type: SCHEMA; Schema: -; Owner: yeahowner
--

CREATE SCHEMA yeah_2011;


ALTER SCHEMA yeah_2011 OWNER TO yeahowner;

--
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: postgres
--

CREATE OR REPLACE PROCEDURAL LANGUAGE plpgsql;


ALTER PROCEDURAL LANGUAGE plpgsql OWNER TO postgres;

SET search_path = yeah_2011, pg_catalog;

--
-- Name: tupla_rol_estado; Type: TYPE; Schema: yeah_2011; Owner: yeahowner
--

CREATE TYPE tupla_rol_estado AS (
	rol character varying(30),
	estado integer
);


ALTER TYPE yeah_2011.tupla_rol_estado OWNER TO yeahowner;

--
-- Name: abrir_encuesta(integer, text); Type: FUNCTION; Schema: yeah_2011; Owner: yeahowner
--

CREATE FUNCTION abrir_encuesta(p_encuesta integer, p_usu_usu text) RETURNS text
    LANGUAGE plpgsql
    AS $$declare  v_estado yeah_2011.tem11.estado%type;  v_nombre_estado yeah_2011.estados.est_nombre%type;  v_rol yeah.roles.rol_rol%type;  v_rol_max yeah.roles.rol_rol%type;  v_estado_autorizado_para_rol integer;  v_rta text;  v_cod_ing yeah_2011.tem11.cod_ing%type;  v_ingresando yeah_2011.tem11.ingresando%type;begin  SELECT estado, cod_ing, ingresando INTO STRICT v_estado,v_cod_ing,v_ingresando    FROM tem11    WHERE encues=p_encuesta;  SELECT rol, estado     INTO v_rol_max, v_estado_autorizado_para_rol	FROM rol_como_analista(p_usu_usu);  if v_estado is null then    v_rta:='La encuesta no existe o no está inicializada';  elsif v_rol_max='ana_campo' and v_estado is distinct from 25 then    v_rta:='El estado de la encuesta es '||v_estado||'. Los analistas de campo solo pueden editar encuestas en estado 25';  elsif v_rol_max is distinct from 'ana_campo' and v_estado=25 then    v_rta:='Las encuestas en estado 25 solo pueden editarse por los analistas de campo';  elsif v_estado>v_estado_autorizado_para_rol then    if v_cod_ing=p_usu_usu and current_timestamp<v_ingresando+interval '1 day' then      v_rta:=null; -- puede ingresar, es el mismo día    else      v_rta:='El estado de la encuesta es '||v_estado||' no tiene permiso para modificar';    end if;  elsif v_estado<21 then    v_rta:='La bolsa no fue revisada';  else    update tem11       set cod_ing=coalesce(cod_ing,p_usu_usu)        , ingresando=coalesce(ingresando,current_timestamp)      where encues=p_encuesta;  end if;  return v_rta; end;$$;


ALTER FUNCTION yeah_2011.abrir_encuesta(p_encuesta integer, p_usu_usu text) OWNER TO yeahowner;

--
-- Name: bolsa_nueva_trg(); Type: FUNCTION; Schema: yeah_2011; Owner: yeahowner
--

CREATE FUNCTION bolsa_nueva_trg() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE-- ver  v_cantidad bigint;  v_signo integer:=CASE new.bolsa_rea WHEN 1 THEN 1 ELSE -1 END;  v_proximo integer;  v_ultimo_id_proc integer;BEGIN  IF new.bolsa_cerrada is null and old.bolsa_cerrada is not null then    RAISE EXCEPTION 'No se pueden reabrir bolsas. La bolsa % esta cerrada',new.bolsa_bolsa;  end if;  IF new.bolsa_cerrada in (1,2) and old.bolsa_cerrada is null then    SELECT count(*)	  INTO v_cantidad	  FROM tem11	  WHERE bolsa=new.bolsa_bolsa;	if v_cantidad is null or v_cantidad=0 then      RAISE EXCEPTION 'No se pueden cerrar bolsas con sin encuestas. La bolsa % tiene % encuestas',new.bolsa_bolsa,v_cantidad;	elsif new.bolsa_cerrada=1 and v_cantidad<10 then      RAISE EXCEPTION 'No se pueden cerrar bolsas con menos de 10 encuestas con codigo 1. Cerrar con codigo 2=bolsa chica. La bolsa % tiene % encuestas',new.bolsa_bolsa,v_cantidad;	elsif new.bolsa_cerrada=2 and v_cantidad>=10 then      RAISE EXCEPTION 'No se pueden cerrar bolsas con 10 o mas encuestas con codigo 2. Cerrar con codigo 1=bolsa chica. La bolsa % tiene % encuestas',new.bolsa_bolsa,v_cantidad;	end if;	select max(abs(new.bolsa_bolsa))+1	  into v_proximo	  from bolsas	  where bolsa_rea is not distinct from new.bolsa_rea;	new.bolsa_activa=null;	update bolsas set bolsa_activa=null where bolsa_bolsa=new.bolsa_bolsa;	insert into bolsas VALUES (v_proximo*v_signo,null,new.bolsa_rea,1);	-- Numerar los id_proc	select coalesce(max(id_proc),0)	  into v_ultimo_id_proc	  from tem11;	update tem11 x      set id_proc=nuevo_id      from (select encues, v_ultimo_id_proc+row_number() over (order by encues) as nuevo_id 	          from tem11 			  where bolsa=new.bolsa_bolsa) y      where x.encues=y.encues;  end if;  if new.bolsa_revisada is distinct from old.bolsa_revisada then    update tem11 x      set bolsa_ok=new.bolsa_revisada      where bolsa=new.bolsa_bolsa;  end if;  RETURN NEW;END;$$;


ALTER FUNCTION yeah_2011.bolsa_nueva_trg() OWNER TO yeahowner;

--
-- Name: fin_etapa_encuesta(integer, text, integer); Type: FUNCTION; Schema: yeah_2011; Owner: yeahowner
--

CREATE FUNCTION fin_etapa_encuesta(p_encuesta integer, p_usu_usu text, p_poner_fin integer) RETURNS text
    LANGUAGE plpgsql
    AS $$declare  v_rol_max yeah.roles.rol_rol%type;  v_estado_autorizado_para_rol integer;  v_estado integer;  v_fin_anal_ing   integer;  v_fin_anal_campo integer;  v_fin_anal_proc  integer;begin  SELECT estado, fin_anal_ing                 , fin_anal_campo               , fin_anal_proc     INTO v_estado, v_fin_anal_ing  	             , v_fin_anal_campo	             , v_fin_anal_proc     FROM tem11	WHERE encues=p_encuesta;  SELECT rol, estado     INTO v_rol_max, v_estado_autorizado_para_rol	FROM rol_como_analista(p_usu_usu);  if v_estado<23 then    raise exception 'ERROR no se puede finalizar la encuesta % porque su estado es %',p_encuesta,v_estado;  --elsif v_estado>v_estado_autorizado_para_rol then    --raise exception 'ERROR el usuario % no tiene permiso para finalizar la encuesta % porque su estado es %',p_usu_usu,p_encuesta,v_estado;  elsif v_rol_max='ana_campo' and v_estado<>25 then    raise exception 'ERROR el analista de campo % no puede finalizar la encuesta % porque su estado no es 25, es %',p_usu_usu,p_encuesta,v_estado;  end if;  if v_rol_max='ingresador' then    if p_poner_fin not in (1,2,3) then	  raise exception 'ERROR el ingresador no puede poner el fin % en la encuesta %, solo puede poner 1, 2 o 3',p_poner_fin,p_encuesta;	elsif coalesce(v_fin_anal_ing, v_fin_anal_campo, v_fin_anal_proc) is not null then	  raise exception 'ERROR el ingresador no puede finalizar la encuesta % si esta finalizada por un analista (%,%,%)',p_encuesta,v_anal_ing,v_anal_campo,v_anal_proc;	end if;    update tem11 set fin_ingreso=p_poner_fin where encues=p_encuesta;  end if;  if v_rol_max='ana_ing' then    if p_poner_fin not in (1,2,3,4,5) then	  raise exception 'ERROR el analista de ingreso no puede poner el fin % en la encuesta %, solo puede poner 1, 2, 4 o 5',p_poner_fin,p_encuesta;	elsif coalesce(v_fin_anal_campo, v_fin_anal_proc) is not null then	  raise exception 'ERROR el analista de ingreso no puede finalizar la encuesta % si esta finalizada por un analista de campo o procesamiento (%,%,%)',p_encuesta,v_anal_ing,v_anal_campo,v_anal_proc;	end if;    update tem11 	  set fin_ingreso=coalesce(fin_ingreso,case p_poner_fin when 1 then 1 when 2 then 2 else 3 end)		, fin_anal_ing=case when coalesce(fin_ingreso,p_poner_fin) in (1, 2) or p_poner_fin=3 then null else p_poner_fin end	  where encues=p_encuesta;  end if;  if v_rol_max='ana_campo' then    if p_poner_fin not in (1,2,5) then	  raise exception 'ERROR el analista de campo no puede poner el fin % en la encuesta %, solo puede poner 1, 2 o 5',p_poner_fin,p_encuesta;	elsif coalesce(v_fin_anal_proc) is not null then	  raise exception 'ERROR el analista de campo no puede finalizar la encuesta % si esta finalizada por un analista de procesamiento (%,%,%)',p_encuesta,v_anal_ing,v_anal_campo,v_anal_proc;	end if;    update tem11 	  set fin_anal_campo=p_poner_fin	  where encues=p_encuesta;  end if;  if v_rol_max='procesamiento' then    if p_poner_fin not in (1,2,4,6) then	  raise exception 'ERROR el usuario no puede poner el fin % en la encuesta %, solo puede poner 1, 2, 4 o 6',p_poner_fin,p_encuesta;	end if;    update tem11 	  set fin_ingreso=coalesce(fin_ingreso,case p_poner_fin when 1 then 1 when 2 then 2 else 3 end)		, fin_anal_proc=p_poner_fin	  where encues=p_encuesta;  end if;  return '';end;$$;


ALTER FUNCTION yeah_2011.fin_etapa_encuesta(p_encuesta integer, p_usu_usu text, p_poner_fin integer) OWNER TO yeahowner;

--
-- Name: his_inconsistencias_trg(); Type: FUNCTION; Schema: yeah_2011; Owner: yeahowner
--

CREATE FUNCTION his_inconsistencias_trg() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE	v_ultima_justificacion yeah_2011.inconsistencias.inc_justificacion%type; 	v_ultima_variables_y_valores yeah_2011.inconsistencias.inc_variables_y_valores%type; BEGIN	if TG_OP='DELETE' then		INSERT INTO his.his_inconsistencias(            inc_con, inc_nenc, inc_nhogar, inc_miembro_ex_0, inc_relacion_0,             inc_variables_y_valores, inc_justificacion, inc_autor_justificacion,             inc_corrida, inc_estado_tem) VALUES (            old.inc_con, old.inc_nenc, old.inc_nhogar, old.inc_miembro_ex_0, old.inc_relacion_0,             old.inc_variables_y_valores, old.inc_justificacion, old.inc_autor_justificacion,             old.inc_corrida, old.inc_estado_tem);		return old;	elsif TG_OP='INSERT' then		if new.inc_justificacion is null then			SELECT inc_justificacion,inc_variables_y_valores				INTO v_ultima_justificacion, v_ultima_variables_y_valores				FROM his.his_inconsistencias				WHERE inc_con=new.inc_con					AND inc_nenc=new.inc_nenc					AND inc_nhogar=new.inc_nhogar					AND inc_miembro_ex_0=new.inc_miembro_ex_0					AND inc_relacion_0=new.inc_relacion_0				ORDER BY inc_corrida DESC LIMIT 1;			if v_ultima_variables_y_valores=new.inc_variables_y_valores then				new.inc_justificacion:=v_ultima_justificacion;			end if;		end if;		return new;	end if;END;$$;


ALTER FUNCTION yeah_2011.his_inconsistencias_trg() OWNER TO yeahowner;

--
-- Name: marcar_tem11_a_supervisar(integer); Type: FUNCTION; Schema: yeah_2011; Owner: yeahowner
--

CREATE FUNCTION marcar_tem11_a_supervisar(p_lote integer) RETURNS text
    LANGUAGE plpgsql
    AS $$declare  v_contador integer;  v_encuesta record;  v_hago_sup_tel boolean; -- para ver si la primera vez es telefonica  v_hago_sup boolean; -- para ver si hago supervisionbegin  v_contador:=0;  for v_encuesta in    select *       from tem11       where lote::integer=p_lote::integer -- para mi lote        and rea::integer in (1,3,4)        and sup_campo is null and sup_tel is null -- o sea no las marqué aún        and rea is not null -- o sea están rendidas (volvieron de campo)      order by md5(encues::text)  loop    v_contador:=v_contador+1;    v_hago_sup:=true;    if v_contador=1 then      v_hago_sup_tel:=(v_encuesta.lote::integer % 2)=1;    elsif v_contador=6 then      v_hago_sup_tel:=(v_encuesta.up::integer % 2)=1;    elsif v_contador in (2,8) then      v_hago_sup_tel:=not v_hago_sup_tel;    else      v_hago_sup:=false;    end if;    if v_hago_sup then      if v_hago_sup_tel then        update tem11 set sup_tel=1, sup_campo=0 where encues=v_encuesta.encues;      else        update tem11 set sup_tel=0, sup_campo=1 where encues=v_encuesta.encues;      end if;    else      update tem11 set sup_tel=0, sup_campo=0 where encues=v_encuesta.encues;    end if;  end loop;  return '';end;$$;


ALTER FUNCTION yeah_2011.marcar_tem11_a_supervisar(p_lote integer) OWNER TO yeahowner;

--
-- Name: reabrir_encuesta(integer, integer, boolean, boolean, boolean); Type: FUNCTION; Schema: yeah_2011; Owner: yeahowner
--

CREATE FUNCTION reabrir_encuesta(p_encuesta integer, p_id integer, p_deshacer_anal_ing boolean, p_deshacer_anal_campo boolean, p_deshacer_anal_proc boolean) RETURNS text
    LANGUAGE plpgsql
    AS $$declare  v_encuesta yeah_2011.tem11.encues%type;  v_encuesta2 yeah_2011.tem11.encues%type;  v_rta text;  v_ing integer;  v_campo integer;  v_proc integer;  begin    SELECT encues INTO STRICT v_encuesta FROM tem11 WHERE encues=p_encuesta;    if (v_encuesta is null) then        v_rta:='La encuesta no existe';    else 	SELECT encues INTO STRICT v_encuesta2 FROM tem11 WHERE encues=p_encuesta AND p_id=id_proc;	if (v_encuesta2 is null) then 		v_rta:='No coincide el número de encuesta '||p_encuesta||' con el ID de procesamiento '||p_id;        else           SELECT fin_anal_ing, fin_anal_campo, fin_anal_proc INTO v_ing, v_campo, v_proc FROM tem11 WHERE encues=p_encuesta;           if p_deshacer_anal_ing then              v_ing=null;           end if;           if p_deshacer_anal_campo then              v_campo=null;           end if;             if p_deshacer_anal_proc then              v_proc=null;           end if;   	   UPDATE tem11                 SET fin_anal_ing=v_ing, fin_anal_campo=v_campo, fin_anal_proc=v_proc                WHERE encues=p_encuesta;                v_rta:='Listo. Encuesta reabierta';	end if;    end if;  return v_rta;   end;$$;


ALTER FUNCTION yeah_2011.reabrir_encuesta(p_encuesta integer, p_id integer, p_deshacer_anal_ing boolean, p_deshacer_anal_campo boolean, p_deshacer_anal_proc boolean) OWNER TO yeahowner;

--
-- Name: res_eah11_ex_del(); Type: FUNCTION; Schema: yeah_2011; Owner: yeahowner
--

CREATE FUNCTION res_eah11_ex_del() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  		delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=old.ex_miembro and res_relacion=0 and res_tab='ex';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=old.ex_miembro and res_relacion=0 and res_tab='ex';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=old.ex_miembro and res_relacion=0 and res_tab='ex';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=old.ex_miembro and res_relacion=0 and res_tab='ex';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=old.ex_miembro and res_relacion=0 and res_tab='ex';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=old.ex_miembro and res_relacion=0 and res_tab='ex';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=old.ex_miembro and res_relacion=0 and res_tab='ex';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=old.ex_miembro and res_relacion=0 and res_tab='ex';
		
  RETURN old;
END
$$;


ALTER FUNCTION yeah_2011.res_eah11_ex_del() OWNER TO yeahowner;

--
-- Name: res_eah11_ex_ins(); Type: FUNCTION; Schema: yeah_2011; Owner: yeahowner
--

CREATE FUNCTION res_eah11_ex_ins() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  		INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,new.ex_miembro,0,'ex_miembro', 'A1', 'X', 'ex',new.ex_miembro,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,new.ex_miembro,0,'sexo_ex', 'A1', 'X', 'ex',new.sexo_ex,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,new.ex_miembro,0,'pais_nac', 'A1', 'X', 'ex',new.pais_nac,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,new.ex_miembro,0,'edad_ex', 'A1', 'X', 'ex',new.edad_ex,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,new.ex_miembro,0,'niv_educ', 'A1', 'X', 'ex',new.niv_educ,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,new.ex_miembro,0,'anio', 'A1', 'X', 'ex',new.anio,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,new.ex_miembro,0,'lugar', 'A1', 'X', 'ex',new.lugar,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,new.ex_miembro,0,'lugar_desc', 'A1', 'X', 'ex',new.lugar_desc,new.usuario);
		
  RETURN new;
END
$$;


ALTER FUNCTION yeah_2011.res_eah11_ex_ins() OWNER TO yeahowner;

--
-- Name: res_eah11_ex_upd(); Type: FUNCTION; Schema: yeah_2011; Owner: yeahowner
--

CREATE FUNCTION res_eah11_ex_upd() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  		if new.ex_miembro is distinct from old.ex_miembro then
			update yeah_2011.respuestas set res_respuesta=new.ex_miembro, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=new.ex_miembro and res_relacion=0 and res_var='ex_miembro';
	    end if;
				if new.sexo_ex is distinct from old.sexo_ex then
			update yeah_2011.respuestas set res_respuesta=new.sexo_ex, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=new.ex_miembro and res_relacion=0 and res_var='sexo_ex';
	    end if;
				if new.pais_nac is distinct from old.pais_nac then
			update yeah_2011.respuestas set res_respuesta=new.pais_nac, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=new.ex_miembro and res_relacion=0 and res_var='pais_nac';
	    end if;
				if new.edad_ex is distinct from old.edad_ex then
			update yeah_2011.respuestas set res_respuesta=new.edad_ex, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=new.ex_miembro and res_relacion=0 and res_var='edad_ex';
	    end if;
				if new.niv_educ is distinct from old.niv_educ then
			update yeah_2011.respuestas set res_respuesta=new.niv_educ, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=new.ex_miembro and res_relacion=0 and res_var='niv_educ';
	    end if;
				if new.anio is distinct from old.anio then
			update yeah_2011.respuestas set res_respuesta=new.anio, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=new.ex_miembro and res_relacion=0 and res_var='anio';
	    end if;
				if new.lugar is distinct from old.lugar then
			update yeah_2011.respuestas set res_respuesta=new.lugar, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=new.ex_miembro and res_relacion=0 and res_var='lugar';
	    end if;
				if new.lugar_desc is distinct from old.lugar_desc then
			update yeah_2011.respuestas set res_respuesta=new.lugar_desc, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=new.ex_miembro and res_relacion=0 and res_var='lugar_desc';
	    end if;
		
  RETURN new;
END
$$;


ALTER FUNCTION yeah_2011.res_eah11_ex_upd() OWNER TO yeahowner;

--
-- Name: res_eah11_fam_del(); Type: FUNCTION; Schema: yeah_2011; Owner: yeahowner
--

CREATE FUNCTION res_eah11_fam_del() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  		delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.p0 and res_ex_miembro=0 and res_relacion=0 and res_tab='fam';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.p0 and res_ex_miembro=0 and res_relacion=0 and res_tab='fam';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.p0 and res_ex_miembro=0 and res_relacion=0 and res_tab='fam';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.p0 and res_ex_miembro=0 and res_relacion=0 and res_tab='fam';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.p0 and res_ex_miembro=0 and res_relacion=0 and res_tab='fam';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.p0 and res_ex_miembro=0 and res_relacion=0 and res_tab='fam';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.p0 and res_ex_miembro=0 and res_relacion=0 and res_tab='fam';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.p0 and res_ex_miembro=0 and res_relacion=0 and res_tab='fam';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.p0 and res_ex_miembro=0 and res_relacion=0 and res_tab='fam';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.p0 and res_ex_miembro=0 and res_relacion=0 and res_tab='fam';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.p0 and res_ex_miembro=0 and res_relacion=0 and res_tab='fam';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.p0 and res_ex_miembro=0 and res_relacion=0 and res_tab='fam';
		
  RETURN old;
END
$$;


ALTER FUNCTION yeah_2011.res_eah11_fam_del() OWNER TO yeahowner;

--
-- Name: res_eah11_fam_ins(); Type: FUNCTION; Schema: yeah_2011; Owner: yeahowner
--

CREATE FUNCTION res_eah11_fam_ins() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  		INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.p0,0,0,'p0', 'S1', 'P', 'fam',new.p0,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.p0,0,0,'nombre', 'S1', 'P', 'fam',new.nombre,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.p0,0,0,'sexo', 'S1', 'P', 'fam',new.sexo,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.p0,0,0,'f_nac_o', 'S1', 'P', 'fam',new.f_nac_o,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.p0,0,0,'p7', 'S1', 'P', 'fam',new.p7,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.p0,0,0,'p8', 'S1', 'P', 'fam',new.p8,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.p0,0,0,'edad', 'S1', 'P', 'fam',new.edad,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.p0,0,0,'p4', 'S1', 'P', 'fam',new.p4,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.p0,0,0,'p5', 'S1', 'P', 'fam',new.p5,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.p0,0,0,'p5b', 'S1', 'P', 'fam',new.p5b,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.p0,0,0,'p6_a', 'S1', 'P', 'fam',new.p6_a,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.p0,0,0,'p6_b', 'S1', 'P', 'fam',new.p6_b,new.usuario);
		
  RETURN new;
END
$$;


ALTER FUNCTION yeah_2011.res_eah11_fam_ins() OWNER TO yeahowner;

--
-- Name: res_eah11_fam_upd(); Type: FUNCTION; Schema: yeah_2011; Owner: yeahowner
--

CREATE FUNCTION res_eah11_fam_upd() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  		if new.p0 is distinct from old.p0 then
			update yeah_2011.respuestas set res_respuesta=new.p0, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.p0 and res_ex_miembro=0 and res_relacion=0 and res_var='p0';
	    end if;
				if new.nombre is distinct from old.nombre then
			update yeah_2011.respuestas set res_respuesta=new.nombre, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.p0 and res_ex_miembro=0 and res_relacion=0 and res_var='nombre';
	    end if;
				if new.sexo is distinct from old.sexo then
			update yeah_2011.respuestas set res_respuesta=new.sexo, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.p0 and res_ex_miembro=0 and res_relacion=0 and res_var='sexo';
	    end if;
				if new.f_nac_o is distinct from old.f_nac_o then
			update yeah_2011.respuestas set res_respuesta=new.f_nac_o, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.p0 and res_ex_miembro=0 and res_relacion=0 and res_var='f_nac_o';
	    end if;
				if new.p7 is distinct from old.p7 then
			update yeah_2011.respuestas set res_respuesta=new.p7, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.p0 and res_ex_miembro=0 and res_relacion=0 and res_var='p7';
	    end if;
				if new.p8 is distinct from old.p8 then
			update yeah_2011.respuestas set res_respuesta=new.p8, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.p0 and res_ex_miembro=0 and res_relacion=0 and res_var='p8';
	    end if;
				if new.edad is distinct from old.edad then
			update yeah_2011.respuestas set res_respuesta=new.edad, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.p0 and res_ex_miembro=0 and res_relacion=0 and res_var='edad';
	    end if;
				if new.p4 is distinct from old.p4 then
			update yeah_2011.respuestas set res_respuesta=new.p4, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.p0 and res_ex_miembro=0 and res_relacion=0 and res_var='p4';
	    end if;
				if new.p5 is distinct from old.p5 then
			update yeah_2011.respuestas set res_respuesta=new.p5, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.p0 and res_ex_miembro=0 and res_relacion=0 and res_var='p5';
	    end if;
				if new.p5b is distinct from old.p5b then
			update yeah_2011.respuestas set res_respuesta=new.p5b, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.p0 and res_ex_miembro=0 and res_relacion=0 and res_var='p5b';
	    end if;
				if new.p6_a is distinct from old.p6_a then
			update yeah_2011.respuestas set res_respuesta=new.p6_a, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.p0 and res_ex_miembro=0 and res_relacion=0 and res_var='p6_a';
	    end if;
				if new.p6_b is distinct from old.p6_b then
			update yeah_2011.respuestas set res_respuesta=new.p6_b, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.p0 and res_ex_miembro=0 and res_relacion=0 and res_var='p6_b';
	    end if;
		
  RETURN new;
END
$$;


ALTER FUNCTION yeah_2011.res_eah11_fam_upd() OWNER TO yeahowner;

--
-- Name: res_eah11_i1_del(); Type: FUNCTION; Schema: yeah_2011; Owner: yeahowner
--

CREATE FUNCTION res_eah11_i1_del() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  		delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='i1';
		
  RETURN old;
END
$$;


ALTER FUNCTION yeah_2011.res_eah11_i1_del() OWNER TO yeahowner;

--
-- Name: res_eah11_i1_ins(); Type: FUNCTION; Schema: yeah_2011; Owner: yeahowner
--

CREATE FUNCTION res_eah11_i1_ins() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN  		INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'u1', 'I1', '', 'i1',new.u1,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t1', 'I1', '', 'i1',new.t1,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t2', 'I1', '', 'i1',new.t2,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t3', 'I1', '', 'i1',new.t3,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t4', 'I1', '', 'i1',new.t4,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t5', 'I1', '', 'i1',new.t5,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t6', 'I1', '', 'i1',new.t6,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t7', 'I1', '', 'i1',new.t7,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t8_otro', 'I1', '', 'i1',new.t8_otro,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t8', 'I1', '', 'i1',new.t8,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t9', 'I1', '', 'i1',new.t9,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t10', 'I1', '', 'i1',new.t10,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t11_otro', 'I1', '', 'i1',new.t11_otro,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t11', 'I1', '', 'i1',new.t11,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t12', 'I1', '', 'i1',new.t12,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t13', 'I1', '', 'i1',new.t13,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t14', 'I1', '', 'i1',new.t14,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t15', 'I1', '', 'i1',new.t15,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t16', 'I1', '', 'i1',new.t16,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t17', 'I1', '', 'i1',new.t17,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t18', 'I1', '', 'i1',new.t18,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t19_anio', 'I1', '', 'i1',new.t19_anio,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t20', 'I1', '', 'i1',new.t20,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t21', 'I1', '', 'i1',new.t21,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t22', 'I1', '', 'i1',new.t22,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t23', 'I1', '', 'i1',new.t23,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t24', 'I1', '', 'i1',new.t24,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t25', 'I1', '', 'i1',new.t25,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t26', 'I1', '', 'i1',new.t26,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t27', 'I1', '', 'i1',new.t27,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t28', 'I1', '', 'i1',new.t28,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t29', 'I1', '', 'i1',new.t29,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t29a', 'I1', '', 'i1',new.t29a,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t30', 'I1', '', 'i1',new.t30,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t31_d', 'I1', '', 'i1',new.t31_d,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t31_l', 'I1', '', 'i1',new.t31_l,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t31_ma', 'I1', '', 'i1',new.t31_ma,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t31_mi', 'I1', '', 'i1',new.t31_mi,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t31_j', 'I1', '', 'i1',new.t31_j,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t31_v', 'I1', '', 'i1',new.t31_v,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t31_s', 'I1', '', 'i1',new.t31_s,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t32_d', 'I1', '', 'i1',new.t32_d,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t32_l', 'I1', '', 'i1',new.t32_l,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t32_ma', 'I1', '', 'i1',new.t32_ma,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t32_mi', 'I1', '', 'i1',new.t32_mi,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t32_j', 'I1', '', 'i1',new.t32_j,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t32_v', 'I1', '', 'i1',new.t32_v,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t32_s', 'I1', '', 'i1',new.t32_s,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t33', 'I1', '', 'i1',new.t33,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t34', 'I1', '', 'i1',new.t34,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t35', 'I1', '', 'i1',new.t35,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t36_1', 'I1', '', 'i1',new.t36_1,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t36_2', 'I1', '', 'i1',new.t36_2,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t36_3', 'I1', '', 'i1',new.t36_3,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t36_4', 'I1', '', 'i1',new.t36_4,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t36_5', 'I1', '', 'i1',new.t36_5,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t36_6', 'I1', '', 'i1',new.t36_6,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t36_7', 'I1', '', 'i1',new.t36_7,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t36_7_otro', 'I1', '', 'i1',new.t36_7_otro,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t36_8', 'I1', '', 'i1',new.t36_8,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t36_8_otro', 'I1', '', 'i1',new.t36_8_otro,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t36_a', 'I1', '', 'i1',new.t36_a,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t37', 'I1', '', 'i1',new.t37,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t37sd', 'I1', '', 'i1',new.t37sd,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t38', 'I1', '', 'i1',new.t38,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t39_barrio', 'I1', '', 'i1',new.t39_barrio,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t39_otro', 'I1', '', 'i1',new.t39_otro,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t39', 'I1', '', 'i1',new.t39,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t39_bis_cuantos', 'I1', '', 'i1',new.t39_bis_cuantos,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t39_bis', 'I1', '', 'i1',new.t39_bis,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t39_bis2_esp', 'I1', '', 'i1',new.t39_bis2_esp,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t39_bis2', 'I1', '', 'i1',new.t39_bis2,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t40', 'I1', '', 'i1',new.t40,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t41', 'I1', '', 'i1',new.t41,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t42', 'I1', '', 'i1',new.t42,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t43', 'I1', '', 'i1',new.t43,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t44', 'I1', '', 'i1',new.t44,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t45', 'I1', '', 'i1',new.t45,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t46', 'I1', '', 'i1',new.t46,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t47', 'I1', '', 'i1',new.t47,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t48', 'I1', '', 'i1',new.t48,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t48a', 'I1', '', 'i1',new.t48a,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t48b_esp', 'I1', '', 'i1',new.t48b_esp,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t48b', 'I1', '', 'i1',new.t48b,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t49', 'I1', '', 'i1',new.t49,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t50a', 'I1', '', 'i1',new.t50a,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t50b', 'I1', '', 'i1',new.t50b,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t50c', 'I1', '', 'i1',new.t50c,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t50d', 'I1', '', 'i1',new.t50d,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t50e', 'I1', '', 'i1',new.t50e,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t50f', 'I1', '', 'i1',new.t50f,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t51', 'I1', '', 'i1',new.t51,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t52a', 'I1', '', 'i1',new.t52a,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t52b', 'I1', '', 'i1',new.t52b,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t52c', 'I1', '', 'i1',new.t52c,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t53_ing', 'I1', '', 'i1',new.t53_ing,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t53_bis1', 'I1', '', 'i1',new.t53_bis1,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t53_bis1_sem', 'I1', '', 'i1',new.t53_bis1_sem,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t53_bis1_mes', 'I1', '', 'i1',new.t53_bis1_mes,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t53_bis2', 'I1', '', 'i1',new.t53_bis2,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t53c_anios', 'I1', '', 'i1',new.t53c_anios,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t53c_meses', 'I1', '', 'i1',new.t53c_meses,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t53c_98', 'I1', '', 'i1',new.t53c_98,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t54', 'I1', '', 'i1',new.t54,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'t54b', 'I1', '', 'i1',new.t54b,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'i1', 'I1', '', 'i1',new.i1,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'i2_totx', 'I1', '', 'i1',new.i2_totx,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'i2_ticx', 'I1', '', 'i1',new.i2_ticx,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'i3_1', 'I1', '', 'i1',new.i3_1,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'i3_1x', 'I1', '', 'i1',new.i3_1x,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'i3_2', 'I1', '', 'i1',new.i3_2,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'i3_2x', 'I1', '', 'i1',new.i3_2x,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'i3_3', 'I1', '', 'i1',new.i3_3,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'i3_3x', 'I1', '', 'i1',new.i3_3x,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'i3_4', 'I1', '', 'i1',new.i3_4,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'i3_4x', 'I1', '', 'i1',new.i3_4x,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'i3_5', 'I1', '', 'i1',new.i3_5,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'i3_5x', 'I1', '', 'i1',new.i3_5x,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'i3_6', 'I1', '', 'i1',new.i3_6,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'i3_6x', 'I1', '', 'i1',new.i3_6x,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'i3_7', 'I1', '', 'i1',new.i3_7,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'i3_7x', 'I1', '', 'i1',new.i3_7x,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'i3_8', 'I1', '', 'i1',new.i3_8,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'i3_8x', 'I1', '', 'i1',new.i3_8x,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'i3_11', 'I1', '', 'i1',new.i3_11,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'i3_11x', 'I1', '', 'i1',new.i3_11x,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'i3_12', 'I1', '', 'i1',new.i3_12,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'i3_12x', 'I1', '', 'i1',new.i3_12x,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'i3_10', 'I1', '', 'i1',new.i3_10,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'i3_10x', 'I1', '', 'i1',new.i3_10x,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'i3_10_otro', 'I1', '', 'i1',new.i3_10_otro,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'i3_13', 'I1', '', 'i1',new.i3_13,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'i3_13x', 'I1', '', 'i1',new.i3_13x,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'i3_tot', 'I1', '', 'i1',new.i3_tot,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'i3_99', 'I1', '', 'i1',new.i3_99,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'e1', 'I1', '', 'i1',new.e1,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'e2', 'I1', '', 'i1',new.e2,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'e3', 'I1', '', 'i1',new.e3,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'e3a', 'I1', '', 'i1',new.e3a,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'e4', 'I1', '', 'i1',new.e4,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'e6', 'I1', '', 'i1',new.e6,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'e8', 'I1', '', 'i1',new.e8,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'e9_edad', 'I1', '', 'i1',new.e9_edad,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'e9_anio', 'I1', '', 'i1',new.e9_anio,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'e10', 'I1', '', 'i1',new.e10,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'e12', 'I1', '', 'i1',new.e12,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'e13', 'I1', '', 'i1',new.e13,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'e14', 'I1', '', 'i1',new.e14,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'e11_1', 'I1', '', 'i1',new.e11_1,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'e11_2', 'I1', '', 'i1',new.e11_2,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'e11_3', 'I1', '', 'i1',new.e11_3,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'e11_4', 'I1', '', 'i1',new.e11_4,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'e11_5', 'I1', '', 'i1',new.e11_5,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'e11_6', 'I1', '', 'i1',new.e11_6,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'e11_7', 'I1', '', 'i1',new.e11_7,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'e11_8', 'I1', '', 'i1',new.e11_8,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'e11_9', 'I1', '', 'i1',new.e11_9,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'e11_10', 'I1', '', 'i1',new.e11_10,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'e11_11', 'I1', '', 'i1',new.e11_11,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'e11_12', 'I1', '', 'i1',new.e11_12,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'e11_13', 'I1', '', 'i1',new.e11_13,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'e11_14', 'I1', '', 'i1',new.e11_14,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'e11_15', 'I1', '', 'i1',new.e11_15,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'e11_15_otro', 'I1', '', 'i1',new.e11_15_otro,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'e11a', 'I1', '', 'i1',new.e11a,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'te_1', 'I1', '', 'i1',new.te_1,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'te_2', 'I1', '', 'i1',new.te_2,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'e15_1', 'I1', '', 'i1',new.e15_1,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'e15_2', 'I1', '', 'i1',new.e15_2,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'e15_3', 'I1', '', 'i1',new.e15_3,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'e15_4', 'I1', '', 'i1',new.e15_4,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'e15_5', 'I1', '', 'i1',new.e15_5,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'e15_5_otro', 'I1', '', 'i1',new.e15_5_otro,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'e15_6', 'I1', '', 'i1',new.e15_6,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'e15_7', 'I1', '', 'i1',new.e15_7,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'e15a', 'I1', '', 'i1',new.e15a,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'m1_esp2', 'I1', '', 'i1',new.m1_esp2,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'m1_esp3', 'I1', '', 'i1',new.m1_esp3,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'m1_esp4', 'I1', '', 'i1',new.m1_esp4,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'m1_anio', 'I1', '', 'i1',new.m1_anio,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'m1', 'I1', '', 'i1',new.m1,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'m1a_esp2', 'I1', '', 'i1',new.m1a_esp2,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'m1a_esp3', 'I1', '', 'i1',new.m1a_esp3,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'m1a_esp4', 'I1', '', 'i1',new.m1a_esp4,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'m1a', 'I1', '', 'i1',new.m1a,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'m3_anio', 'I1', '', 'i1',new.m3_anio,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'m3', 'I1', '', 'i1',new.m3,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'m4_esp1', 'I1', '', 'i1',new.m4_esp1,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'m4_esp2', 'I1', '', 'i1',new.m4_esp2,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'m4_esp3', 'I1', '', 'i1',new.m4_esp3,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'m4', 'I1', '', 'i1',new.m4,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'m5', 'I1', '', 'i1',new.m5,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn1_1', 'I1', '', 'i1',new.sn1_1,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn1_1_esp', 'I1', '', 'i1',new.sn1_1_esp,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn1_7', 'I1', '', 'i1',new.sn1_7,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn1_7_esp', 'I1', '', 'i1',new.sn1_7_esp,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn1_2', 'I1', '', 'i1',new.sn1_2,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn1_2_esp', 'I1', '', 'i1',new.sn1_2_esp,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn1_3', 'I1', '', 'i1',new.sn1_3,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn1_3_esp', 'I1', '', 'i1',new.sn1_3_esp,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn1_4', 'I1', '', 'i1',new.sn1_4,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn1_4_esp', 'I1', '', 'i1',new.sn1_4_esp,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn1_5', 'I1', '', 'i1',new.sn1_5,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn1_6', 'I1', '', 'i1',new.sn1_6,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn2_cant', 'I1', '', 'i1',new.sn2_cant,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn2', 'I1', '', 'i1',new.sn2,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn3', 'I1', '', 'i1',new.sn3,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn4_esp', 'I1', '', 'i1',new.sn4_esp,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn4', 'I1', '', 'i1',new.sn4,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn5_esp', 'I1', '', 'i1',new.sn5_esp,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn5', 'I1', '', 'i1',new.sn5,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn6_cant', 'I1', '', 'i1',new.sn6_cant,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn6', 'I1', '', 'i1',new.sn6,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn7_esp', 'I1', '', 'i1',new.sn7_esp,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn7', 'I1', '', 'i1',new.sn7,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn8_esp', 'I1', '', 'i1',new.sn8_esp,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn8', 'I1', '', 'i1',new.sn8,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn9', 'I1', '', 'i1',new.sn9,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn10a', 'I1', '', 'i1',new.sn10a,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn10b', 'I1', '', 'i1',new.sn10b,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn10c', 'I1', '', 'i1',new.sn10c,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn10d', 'I1', '', 'i1',new.sn10d,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn10e', 'I1', '', 'i1',new.sn10e,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn10f', 'I1', '', 'i1',new.sn10f,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn10g', 'I1', '', 'i1',new.sn10g,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn10h', 'I1', '', 'i1',new.sn10h,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn10i', 'I1', '', 'i1',new.sn10i,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn10j', 'I1', '', 'i1',new.sn10j,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn10_j_esp', 'I1', '', 'i1',new.sn10_j_esp,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn11', 'I1', '', 'i1',new.sn11,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn12_esp', 'I1', '', 'i1',new.sn12_esp,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn12', 'I1', '', 'i1',new.sn12,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn13_otro', 'I1', '', 'i1',new.sn13_otro,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn13', 'I1', '', 'i1',new.sn13,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn14_esp', 'I1', '', 'i1',new.sn14_esp,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn14', 'I1', '', 'i1',new.sn14,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn15a', 'I1', '', 'i1',new.sn15a,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn15b', 'I1', '', 'i1',new.sn15b,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn15c', 'I1', '', 'i1',new.sn15c,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn15d', 'I1', '', 'i1',new.sn15d,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn15e', 'I1', '', 'i1',new.sn15e,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn15f', 'I1', '', 'i1',new.sn15f,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn15g', 'I1', '', 'i1',new.sn15g,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn15h', 'I1', '', 'i1',new.sn15h,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn15i', 'I1', '', 'i1',new.sn15i,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn15j', 'I1', '', 'i1',new.sn15j,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn15k', 'I1', '', 'i1',new.sn15k,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn15k_esp', 'I1', '', 'i1',new.sn15k_esp,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'sn16', 'I1', '', 'i1',new.sn16,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'s28', 'I1', '', 'i1',new.s28,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'s29', 'I1', '', 'i1',new.s29,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'s30', 'I1', '', 'i1',new.s30,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'s31_anio', 'I1', '', 'i1',new.s31_anio,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'s31_mes', 'I1', '', 'i1',new.s31_mes,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'md1', 'I1', '', 'i1',new.md1,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'md2', 'I1', '', 'i1',new.md2,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'md3', 'I1', '', 'i1',new.md3,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'md4', 'I1', '', 'i1',new.md4,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'md5', 'I1', '', 'i1',new.md5,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'md6', 'I1', '', 'i1',new.md6,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'md7', 'I1', '', 'i1',new.md7,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'md8', 'I1', '', 'i1',new.md8,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'md9', 'I1', '', 'i1',new.md9,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'md10', 'I1', '', 'i1',new.md10,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'md11', 'I1', '', 'i1',new.md11,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'md12', 'I1', '', 'i1',new.md12,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'obs', 'I1', '', 'i1',new.obs,new.usuario);		  RETURN new;END$$;


ALTER FUNCTION yeah_2011.res_eah11_i1_ins() OWNER TO yeahowner;

--
-- Name: res_eah11_i1_upd(); Type: FUNCTION; Schema: yeah_2011; Owner: yeahowner
--

CREATE FUNCTION res_eah11_i1_upd() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN  		if new.u1 is distinct from old.u1 then			update yeah_2011.respuestas set res_respuesta=new.u1, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='u1';	    end if;				if new.t1 is distinct from old.t1 then			update yeah_2011.respuestas set res_respuesta=new.t1, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t1';	    end if;				if new.t2 is distinct from old.t2 then			update yeah_2011.respuestas set res_respuesta=new.t2, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t2';	    end if;				if new.t3 is distinct from old.t3 then			update yeah_2011.respuestas set res_respuesta=new.t3, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t3';	    end if;				if new.t4 is distinct from old.t4 then			update yeah_2011.respuestas set res_respuesta=new.t4, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t4';	    end if;				if new.t5 is distinct from old.t5 then			update yeah_2011.respuestas set res_respuesta=new.t5, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t5';	    end if;				if new.t6 is distinct from old.t6 then			update yeah_2011.respuestas set res_respuesta=new.t6, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t6';	    end if;				if new.t7 is distinct from old.t7 then			update yeah_2011.respuestas set res_respuesta=new.t7, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t7';	    end if;				if new.t8_otro is distinct from old.t8_otro then			update yeah_2011.respuestas set res_respuesta=new.t8_otro, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t8_otro';	    end if;				if new.t8 is distinct from old.t8 then			update yeah_2011.respuestas set res_respuesta=new.t8, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t8';	    end if;				if new.t9 is distinct from old.t9 then			update yeah_2011.respuestas set res_respuesta=new.t9, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t9';	    end if;				if new.t10 is distinct from old.t10 then			update yeah_2011.respuestas set res_respuesta=new.t10, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t10';	    end if;				if new.t11_otro is distinct from old.t11_otro then			update yeah_2011.respuestas set res_respuesta=new.t11_otro, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t11_otro';	    end if;				if new.t11 is distinct from old.t11 then			update yeah_2011.respuestas set res_respuesta=new.t11, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t11';	    end if;				if new.t12 is distinct from old.t12 then			update yeah_2011.respuestas set res_respuesta=new.t12, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t12';	    end if;				if new.t13 is distinct from old.t13 then			update yeah_2011.respuestas set res_respuesta=new.t13, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t13';	    end if;				if new.t14 is distinct from old.t14 then			update yeah_2011.respuestas set res_respuesta=new.t14, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t14';	    end if;				if new.t15 is distinct from old.t15 then			update yeah_2011.respuestas set res_respuesta=new.t15, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t15';	    end if;				if new.t16 is distinct from old.t16 then			update yeah_2011.respuestas set res_respuesta=new.t16, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t16';	    end if;				if new.t17 is distinct from old.t17 then			update yeah_2011.respuestas set res_respuesta=new.t17, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t17';	    end if;				if new.t18 is distinct from old.t18 then			update yeah_2011.respuestas set res_respuesta=new.t18, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t18';	    end if;				if new.t19_anio is distinct from old.t19_anio then			update yeah_2011.respuestas set res_respuesta=new.t19_anio, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t19_anio';	    end if;				if new.t20 is distinct from old.t20 then			update yeah_2011.respuestas set res_respuesta=new.t20, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t20';	    end if;				if new.t21 is distinct from old.t21 then			update yeah_2011.respuestas set res_respuesta=new.t21, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t21';	    end if;				if new.t22 is distinct from old.t22 then			update yeah_2011.respuestas set res_respuesta=new.t22, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t22';	    end if;				if new.t23 is distinct from old.t23 then			update yeah_2011.respuestas set res_respuesta=new.t23, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t23';	    end if;				if new.t24 is distinct from old.t24 then			update yeah_2011.respuestas set res_respuesta=new.t24, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t24';	    end if;				if new.t25 is distinct from old.t25 then			update yeah_2011.respuestas set res_respuesta=new.t25, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t25';	    end if;				if new.t26 is distinct from old.t26 then			update yeah_2011.respuestas set res_respuesta=new.t26, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t26';	    end if;				if new.t27 is distinct from old.t27 then			update yeah_2011.respuestas set res_respuesta=new.t27, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t27';	    end if;				if new.t28 is distinct from old.t28 then			update yeah_2011.respuestas set res_respuesta=new.t28, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t28';	    end if;				if new.t29 is distinct from old.t29 then			update yeah_2011.respuestas set res_respuesta=new.t29, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t29';	    end if;				if new.t29a is distinct from old.t29a then			update yeah_2011.respuestas set res_respuesta=new.t29a, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t29a';	    end if;				if new.t30 is distinct from old.t30 then			update yeah_2011.respuestas set res_respuesta=new.t30, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t30';	    end if;				if new.t31_d is distinct from old.t31_d then			update yeah_2011.respuestas set res_respuesta=new.t31_d, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t31_d';	    end if;				if new.t31_l is distinct from old.t31_l then			update yeah_2011.respuestas set res_respuesta=new.t31_l, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t31_l';	    end if;				if new.t31_ma is distinct from old.t31_ma then			update yeah_2011.respuestas set res_respuesta=new.t31_ma, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t31_ma';	    end if;				if new.t31_mi is distinct from old.t31_mi then			update yeah_2011.respuestas set res_respuesta=new.t31_mi, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t31_mi';	    end if;				if new.t31_j is distinct from old.t31_j then			update yeah_2011.respuestas set res_respuesta=new.t31_j, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t31_j';	    end if;				if new.t31_v is distinct from old.t31_v then			update yeah_2011.respuestas set res_respuesta=new.t31_v, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t31_v';	    end if;				if new.t31_s is distinct from old.t31_s then			update yeah_2011.respuestas set res_respuesta=new.t31_s, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t31_s';	    end if;				if new.t32_d is distinct from old.t32_d then			update yeah_2011.respuestas set res_respuesta=new.t32_d, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t32_d';	    end if;				if new.t32_l is distinct from old.t32_l then			update yeah_2011.respuestas set res_respuesta=new.t32_l, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t32_l';	    end if;				if new.t32_ma is distinct from old.t32_ma then			update yeah_2011.respuestas set res_respuesta=new.t32_ma, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t32_ma';	    end if;				if new.t32_mi is distinct from old.t32_mi then			update yeah_2011.respuestas set res_respuesta=new.t32_mi, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t32_mi';	    end if;				if new.t32_j is distinct from old.t32_j then			update yeah_2011.respuestas set res_respuesta=new.t32_j, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t32_j';	    end if;				if new.t32_v is distinct from old.t32_v then			update yeah_2011.respuestas set res_respuesta=new.t32_v, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t32_v';	    end if;				if new.t32_s is distinct from old.t32_s then			update yeah_2011.respuestas set res_respuesta=new.t32_s, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t32_s';	    end if;				if new.t33 is distinct from old.t33 then			update yeah_2011.respuestas set res_respuesta=new.t33, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t33';	    end if;				if new.t34 is distinct from old.t34 then			update yeah_2011.respuestas set res_respuesta=new.t34, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t34';	    end if;				if new.t35 is distinct from old.t35 then			update yeah_2011.respuestas set res_respuesta=new.t35, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t35';	    end if;				if new.t36_1 is distinct from old.t36_1 then			update yeah_2011.respuestas set res_respuesta=new.t36_1, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t36_1';	    end if;				if new.t36_2 is distinct from old.t36_2 then			update yeah_2011.respuestas set res_respuesta=new.t36_2, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t36_2';	    end if;				if new.t36_3 is distinct from old.t36_3 then			update yeah_2011.respuestas set res_respuesta=new.t36_3, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t36_3';	    end if;				if new.t36_4 is distinct from old.t36_4 then			update yeah_2011.respuestas set res_respuesta=new.t36_4, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t36_4';	    end if;				if new.t36_5 is distinct from old.t36_5 then			update yeah_2011.respuestas set res_respuesta=new.t36_5, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t36_5';	    end if;				if new.t36_6 is distinct from old.t36_6 then			update yeah_2011.respuestas set res_respuesta=new.t36_6, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t36_6';	    end if;				if new.t36_7 is distinct from old.t36_7 then			update yeah_2011.respuestas set res_respuesta=new.t36_7, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t36_7';	    end if;				if new.t36_7_otro is distinct from old.t36_7_otro then			update yeah_2011.respuestas set res_respuesta=new.t36_7_otro, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t36_7_otro';	    end if;				if new.t36_8 is distinct from old.t36_8 then			update yeah_2011.respuestas set res_respuesta=new.t36_8, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t36_8';	    end if;				if new.t36_8_otro is distinct from old.t36_8_otro then			update yeah_2011.respuestas set res_respuesta=new.t36_8_otro, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t36_8_otro';	    end if;				if new.t36_a is distinct from old.t36_a then			update yeah_2011.respuestas set res_respuesta=new.t36_a, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t36_a';	    end if;				if new.t37 is distinct from old.t37 then			update yeah_2011.respuestas set res_respuesta=new.t37, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t37';	    end if;				if new.t37sd is distinct from old.t37sd then			update yeah_2011.respuestas set res_respuesta=new.t37sd, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t37sd';	    end if;				if new.t38 is distinct from old.t38 then			update yeah_2011.respuestas set res_respuesta=new.t38, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t38';	    end if;				if new.t39_barrio is distinct from old.t39_barrio then			update yeah_2011.respuestas set res_respuesta=new.t39_barrio, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t39_barrio';	    end if;				if new.t39_otro is distinct from old.t39_otro then			update yeah_2011.respuestas set res_respuesta=new.t39_otro, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t39_otro';	    end if;				if new.t39 is distinct from old.t39 then			update yeah_2011.respuestas set res_respuesta=new.t39, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t39';	    end if;				if new.t39_bis_cuantos is distinct from old.t39_bis_cuantos then			update yeah_2011.respuestas set res_respuesta=new.t39_bis_cuantos, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t39_bis_cuantos';	    end if;				if new.t39_bis is distinct from old.t39_bis then			update yeah_2011.respuestas set res_respuesta=new.t39_bis, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t39_bis';	    end if;				if new.t39_bis2_esp is distinct from old.t39_bis2_esp then			update yeah_2011.respuestas set res_respuesta=new.t39_bis2_esp, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t39_bis2_esp';	    end if;				if new.t39_bis2 is distinct from old.t39_bis2 then			update yeah_2011.respuestas set res_respuesta=new.t39_bis2, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t39_bis2';	    end if;				if new.t40 is distinct from old.t40 then			update yeah_2011.respuestas set res_respuesta=new.t40, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t40';	    end if;				if new.t41 is distinct from old.t41 then			update yeah_2011.respuestas set res_respuesta=new.t41, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t41';	    end if;				if new.t42 is distinct from old.t42 then			update yeah_2011.respuestas set res_respuesta=new.t42, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t42';	    end if;				if new.t43 is distinct from old.t43 then			update yeah_2011.respuestas set res_respuesta=new.t43, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t43';	    end if;				if new.t44 is distinct from old.t44 then			update yeah_2011.respuestas set res_respuesta=new.t44, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t44';	    end if;				if new.t45 is distinct from old.t45 then			update yeah_2011.respuestas set res_respuesta=new.t45, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t45';	    end if;				if new.t46 is distinct from old.t46 then			update yeah_2011.respuestas set res_respuesta=new.t46, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t46';	    end if;				if new.t47 is distinct from old.t47 then			update yeah_2011.respuestas set res_respuesta=new.t47, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t47';	    end if;				if new.t48 is distinct from old.t48 then			update yeah_2011.respuestas set res_respuesta=new.t48, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t48';	    end if;				if new.t48a is distinct from old.t48a then			update yeah_2011.respuestas set res_respuesta=new.t48a, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t48a';	    end if;				if new.t48b_esp is distinct from old.t48b_esp then			update yeah_2011.respuestas set res_respuesta=new.t48b_esp, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t48b_esp';	    end if;				if new.t48b is distinct from old.t48b then			update yeah_2011.respuestas set res_respuesta=new.t48b, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t48b';	    end if;				if new.t49 is distinct from old.t49 then			update yeah_2011.respuestas set res_respuesta=new.t49, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t49';	    end if;				if new.t50a is distinct from old.t50a then			update yeah_2011.respuestas set res_respuesta=new.t50a, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t50a';	    end if;				if new.t50b is distinct from old.t50b then			update yeah_2011.respuestas set res_respuesta=new.t50b, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t50b';	    end if;				if new.t50c is distinct from old.t50c then			update yeah_2011.respuestas set res_respuesta=new.t50c, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t50c';	    end if;				if new.t50d is distinct from old.t50d then			update yeah_2011.respuestas set res_respuesta=new.t50d, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t50d';	    end if;				if new.t50e is distinct from old.t50e then			update yeah_2011.respuestas set res_respuesta=new.t50e, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t50e';	    end if;				if new.t50f is distinct from old.t50f then			update yeah_2011.respuestas set res_respuesta=new.t50f, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t50f';	    end if;				if new.t51 is distinct from old.t51 then			update yeah_2011.respuestas set res_respuesta=new.t51, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t51';	    end if;				if new.t52a is distinct from old.t52a then			update yeah_2011.respuestas set res_respuesta=new.t52a, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t52a';	    end if;				if new.t52b is distinct from old.t52b then			update yeah_2011.respuestas set res_respuesta=new.t52b, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t52b';	    end if;				if new.t52c is distinct from old.t52c then			update yeah_2011.respuestas set res_respuesta=new.t52c, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t52c';	    end if;				if new.t53_ing is distinct from old.t53_ing then			update yeah_2011.respuestas set res_respuesta=new.t53_ing, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t53_ing';	    end if;				if new.t53_bis1 is distinct from old.t53_bis1 then			update yeah_2011.respuestas set res_respuesta=new.t53_bis1, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t53_bis1';	    end if;				if new.t53_bis1_sem is distinct from old.t53_bis1_sem then			update yeah_2011.respuestas set res_respuesta=new.t53_bis1_sem, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t53_bis1_sem';	    end if;				if new.t53_bis1_mes is distinct from old.t53_bis1_mes then			update yeah_2011.respuestas set res_respuesta=new.t53_bis1_mes, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t53_bis1_mes';	    end if;				if new.t53_bis2 is distinct from old.t53_bis2 then			update yeah_2011.respuestas set res_respuesta=new.t53_bis2, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t53_bis2';	    end if;				if new.t53c_anios is distinct from old.t53c_anios then			update yeah_2011.respuestas set res_respuesta=new.t53c_anios, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t53c_anios';	    end if;				if new.t53c_meses is distinct from old.t53c_meses then			update yeah_2011.respuestas set res_respuesta=new.t53c_meses, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t53c_meses';	    end if;				if new.t53c_98 is distinct from old.t53c_98 then			update yeah_2011.respuestas set res_respuesta=new.t53c_98, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t53c_98';	    end if;				if new.t54 is distinct from old.t54 then			update yeah_2011.respuestas set res_respuesta=new.t54, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t54';	    end if;				if new.t54b is distinct from old.t54b then			update yeah_2011.respuestas set res_respuesta=new.t54b, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='t54b';	    end if;				if new.i1 is distinct from old.i1 then			update yeah_2011.respuestas set res_respuesta=new.i1, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='i1';	    end if;				if new.i2_totx is distinct from old.i2_totx then			update yeah_2011.respuestas set res_respuesta=new.i2_totx, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='i2_totx';	    end if;				if new.i2_ticx is distinct from old.i2_ticx then			update yeah_2011.respuestas set res_respuesta=new.i2_ticx, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='i2_ticx';	    end if;				if new.i3_1 is distinct from old.i3_1 then			update yeah_2011.respuestas set res_respuesta=new.i3_1, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='i3_1';	    end if;				if new.i3_1x is distinct from old.i3_1x then			update yeah_2011.respuestas set res_respuesta=new.i3_1x, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='i3_1x';	    end if;				if new.i3_2 is distinct from old.i3_2 then			update yeah_2011.respuestas set res_respuesta=new.i3_2, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='i3_2';	    end if;				if new.i3_2x is distinct from old.i3_2x then			update yeah_2011.respuestas set res_respuesta=new.i3_2x, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='i3_2x';	    end if;				if new.i3_3 is distinct from old.i3_3 then			update yeah_2011.respuestas set res_respuesta=new.i3_3, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='i3_3';	    end if;				if new.i3_3x is distinct from old.i3_3x then			update yeah_2011.respuestas set res_respuesta=new.i3_3x, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='i3_3x';	    end if;				if new.i3_4 is distinct from old.i3_4 then			update yeah_2011.respuestas set res_respuesta=new.i3_4, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='i3_4';	    end if;				if new.i3_4x is distinct from old.i3_4x then			update yeah_2011.respuestas set res_respuesta=new.i3_4x, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='i3_4x';	    end if;				if new.i3_5 is distinct from old.i3_5 then			update yeah_2011.respuestas set res_respuesta=new.i3_5, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='i3_5';	    end if;				if new.i3_5x is distinct from old.i3_5x then			update yeah_2011.respuestas set res_respuesta=new.i3_5x, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='i3_5x';	    end if;				if new.i3_6 is distinct from old.i3_6 then			update yeah_2011.respuestas set res_respuesta=new.i3_6, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='i3_6';	    end if;				if new.i3_6x is distinct from old.i3_6x then			update yeah_2011.respuestas set res_respuesta=new.i3_6x, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='i3_6x';	    end if;				if new.i3_7 is distinct from old.i3_7 then			update yeah_2011.respuestas set res_respuesta=new.i3_7, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='i3_7';	    end if;				if new.i3_7x is distinct from old.i3_7x then			update yeah_2011.respuestas set res_respuesta=new.i3_7x, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='i3_7x';	    end if;				if new.i3_8 is distinct from old.i3_8 then			update yeah_2011.respuestas set res_respuesta=new.i3_8, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='i3_8';	    end if;				if new.i3_8x is distinct from old.i3_8x then			update yeah_2011.respuestas set res_respuesta=new.i3_8x, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='i3_8x';	    end if;				if new.i3_11 is distinct from old.i3_11 then			update yeah_2011.respuestas set res_respuesta=new.i3_11, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='i3_11';	    end if;				if new.i3_11x is distinct from old.i3_11x then			update yeah_2011.respuestas set res_respuesta=new.i3_11x, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='i3_11x';	    end if;				if new.i3_12 is distinct from old.i3_12 then			update yeah_2011.respuestas set res_respuesta=new.i3_12, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='i3_12';	    end if;				if new.i3_12x is distinct from old.i3_12x then			update yeah_2011.respuestas set res_respuesta=new.i3_12x, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='i3_12x';	    end if;				if new.i3_10 is distinct from old.i3_10 then			update yeah_2011.respuestas set res_respuesta=new.i3_10, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='i3_10';	    end if;				if new.i3_10x is distinct from old.i3_10x then			update yeah_2011.respuestas set res_respuesta=new.i3_10x, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='i3_10x';	    end if;				if new.i3_10_otro is distinct from old.i3_10_otro then			update yeah_2011.respuestas set res_respuesta=new.i3_10_otro, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='i3_10_otro';	    end if;				if new.i3_13 is distinct from old.i3_13 then			update yeah_2011.respuestas set res_respuesta=new.i3_13, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='i3_13';	    end if;				if new.i3_13x is distinct from old.i3_13x then			update yeah_2011.respuestas set res_respuesta=new.i3_13x, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='i3_13x';	    end if;				if new.i3_tot is distinct from old.i3_tot then			update yeah_2011.respuestas set res_respuesta=new.i3_tot, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='i3_tot';	    end if;				if new.i3_99 is distinct from old.i3_99 then			update yeah_2011.respuestas set res_respuesta=new.i3_99, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='i3_99';	    end if;				if new.e1 is distinct from old.e1 then			update yeah_2011.respuestas set res_respuesta=new.e1, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='e1';	    end if;				if new.e2 is distinct from old.e2 then			update yeah_2011.respuestas set res_respuesta=new.e2, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='e2';	    end if;				if new.e3 is distinct from old.e3 then			update yeah_2011.respuestas set res_respuesta=new.e3, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='e3';	    end if;				if new.e3a is distinct from old.e3a then			update yeah_2011.respuestas set res_respuesta=new.e3a, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='e3a';	    end if;				if new.e4 is distinct from old.e4 then			update yeah_2011.respuestas set res_respuesta=new.e4, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='e4';	    end if;				if new.e6 is distinct from old.e6 then			update yeah_2011.respuestas set res_respuesta=new.e6, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='e6';	    end if;				if new.e8 is distinct from old.e8 then			update yeah_2011.respuestas set res_respuesta=new.e8, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='e8';	    end if;				if new.e9_edad is distinct from old.e9_edad then			update yeah_2011.respuestas set res_respuesta=new.e9_edad, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='e9_edad';	    end if;				if new.e9_anio is distinct from old.e9_anio then			update yeah_2011.respuestas set res_respuesta=new.e9_anio, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='e9_anio';	    end if;				if new.e10 is distinct from old.e10 then			update yeah_2011.respuestas set res_respuesta=new.e10, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='e10';	    end if;				if new.e12 is distinct from old.e12 then			update yeah_2011.respuestas set res_respuesta=new.e12, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='e12';	    end if;				if new.e13 is distinct from old.e13 then			update yeah_2011.respuestas set res_respuesta=new.e13, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='e13';	    end if;				if new.e14 is distinct from old.e14 then			update yeah_2011.respuestas set res_respuesta=new.e14, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='e14';	    end if;				if new.e11_1 is distinct from old.e11_1 then			update yeah_2011.respuestas set res_respuesta=new.e11_1, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='e11_1';	    end if;				if new.e11_2 is distinct from old.e11_2 then			update yeah_2011.respuestas set res_respuesta=new.e11_2, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='e11_2';	    end if;				if new.e11_3 is distinct from old.e11_3 then			update yeah_2011.respuestas set res_respuesta=new.e11_3, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='e11_3';	    end if;				if new.e11_4 is distinct from old.e11_4 then			update yeah_2011.respuestas set res_respuesta=new.e11_4, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='e11_4';	    end if;				if new.e11_5 is distinct from old.e11_5 then			update yeah_2011.respuestas set res_respuesta=new.e11_5, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='e11_5';	    end if;				if new.e11_6 is distinct from old.e11_6 then			update yeah_2011.respuestas set res_respuesta=new.e11_6, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='e11_6';	    end if;				if new.e11_7 is distinct from old.e11_7 then			update yeah_2011.respuestas set res_respuesta=new.e11_7, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='e11_7';	    end if;				if new.e11_8 is distinct from old.e11_8 then			update yeah_2011.respuestas set res_respuesta=new.e11_8, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='e11_8';	    end if;				if new.e11_9 is distinct from old.e11_9 then			update yeah_2011.respuestas set res_respuesta=new.e11_9, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='e11_9';	    end if;				if new.e11_10 is distinct from old.e11_10 then			update yeah_2011.respuestas set res_respuesta=new.e11_10, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='e11_10';	    end if;				if new.e11_11 is distinct from old.e11_11 then			update yeah_2011.respuestas set res_respuesta=new.e11_11, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='e11_11';	    end if;				if new.e11_12 is distinct from old.e11_12 then			update yeah_2011.respuestas set res_respuesta=new.e11_12, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='e11_12';	    end if;				if new.e11_13 is distinct from old.e11_13 then			update yeah_2011.respuestas set res_respuesta=new.e11_13, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='e11_13';	    end if;				if new.e11_14 is distinct from old.e11_14 then			update yeah_2011.respuestas set res_respuesta=new.e11_14, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='e11_14';	    end if;				if new.e11_15 is distinct from old.e11_15 then			update yeah_2011.respuestas set res_respuesta=new.e11_15, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='e11_15';	    end if;				if new.e11_15_otro is distinct from old.e11_15_otro then			update yeah_2011.respuestas set res_respuesta=new.e11_15_otro, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='e11_15_otro';	    end if;				if new.e11a is distinct from old.e11a then			update yeah_2011.respuestas set res_respuesta=new.e11a, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='e11a';	    end if;				if new.te_1 is distinct from old.te_1 then			update yeah_2011.respuestas set res_respuesta=new.te_1, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='te_1';	    end if;				if new.te_2 is distinct from old.te_2 then			update yeah_2011.respuestas set res_respuesta=new.te_2, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='te_2';	    end if;				if new.e15_1 is distinct from old.e15_1 then			update yeah_2011.respuestas set res_respuesta=new.e15_1, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='e15_1';	    end if;				if new.e15_2 is distinct from old.e15_2 then			update yeah_2011.respuestas set res_respuesta=new.e15_2, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='e15_2';	    end if;				if new.e15_3 is distinct from old.e15_3 then			update yeah_2011.respuestas set res_respuesta=new.e15_3, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='e15_3';	    end if;				if new.e15_4 is distinct from old.e15_4 then			update yeah_2011.respuestas set res_respuesta=new.e15_4, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='e15_4';	    end if;				if new.e15_5 is distinct from old.e15_5 then			update yeah_2011.respuestas set res_respuesta=new.e15_5, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='e15_5';	    end if;				if new.e15_5_otro is distinct from old.e15_5_otro then			update yeah_2011.respuestas set res_respuesta=new.e15_5_otro, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='e15_5_otro';	    end if;				if new.e15_6 is distinct from old.e15_6 then			update yeah_2011.respuestas set res_respuesta=new.e15_6, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='e15_6';	    end if;				if new.e15_7 is distinct from old.e15_7 then			update yeah_2011.respuestas set res_respuesta=new.e15_7, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='e15_7';	    end if;				if new.e15a is distinct from old.e15a then			update yeah_2011.respuestas set res_respuesta=new.e15a, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='e15a';	    end if;				if new.m1_esp2 is distinct from old.m1_esp2 then			update yeah_2011.respuestas set res_respuesta=new.m1_esp2, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='m1_esp2';	    end if;				if new.m1_esp3 is distinct from old.m1_esp3 then			update yeah_2011.respuestas set res_respuesta=new.m1_esp3, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='m1_esp3';	    end if;				if new.m1_esp4 is distinct from old.m1_esp4 then			update yeah_2011.respuestas set res_respuesta=new.m1_esp4, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='m1_esp4';	    end if;				if new.m1_anio is distinct from old.m1_anio then			update yeah_2011.respuestas set res_respuesta=new.m1_anio, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='m1_anio';	    end if;				if new.m1 is distinct from old.m1 then			update yeah_2011.respuestas set res_respuesta=new.m1, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='m1';	    end if;				if new.m1a_esp2 is distinct from old.m1a_esp2 then			update yeah_2011.respuestas set res_respuesta=new.m1a_esp2, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='m1a_esp2';	    end if;				if new.m1a_esp3 is distinct from old.m1a_esp3 then			update yeah_2011.respuestas set res_respuesta=new.m1a_esp3, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='m1a_esp3';	    end if;				if new.m1a_esp4 is distinct from old.m1a_esp4 then			update yeah_2011.respuestas set res_respuesta=new.m1a_esp4, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='m1a_esp4';	    end if;				if new.m1a is distinct from old.m1a then			update yeah_2011.respuestas set res_respuesta=new.m1a, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='m1a';	    end if;				if new.m3_anio is distinct from old.m3_anio then			update yeah_2011.respuestas set res_respuesta=new.m3_anio, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='m3_anio';	    end if;				if new.m3 is distinct from old.m3 then			update yeah_2011.respuestas set res_respuesta=new.m3, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='m3';	    end if;				if new.m4_esp1 is distinct from old.m4_esp1 then			update yeah_2011.respuestas set res_respuesta=new.m4_esp1, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='m4_esp1';	    end if;				if new.m4_esp2 is distinct from old.m4_esp2 then			update yeah_2011.respuestas set res_respuesta=new.m4_esp2, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='m4_esp2';	    end if;				if new.m4_esp3 is distinct from old.m4_esp3 then			update yeah_2011.respuestas set res_respuesta=new.m4_esp3, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='m4_esp3';	    end if;				if new.m4 is distinct from old.m4 then			update yeah_2011.respuestas set res_respuesta=new.m4, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='m4';	    end if;				if new.m5 is distinct from old.m5 then			update yeah_2011.respuestas set res_respuesta=new.m5, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='m5';	    end if;				if new.sn1_1 is distinct from old.sn1_1 then			update yeah_2011.respuestas set res_respuesta=new.sn1_1, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn1_1';	    end if;				if new.sn1_1_esp is distinct from old.sn1_1_esp then			update yeah_2011.respuestas set res_respuesta=new.sn1_1_esp, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn1_1_esp';	    end if;				if new.sn1_7 is distinct from old.sn1_7 then			update yeah_2011.respuestas set res_respuesta=new.sn1_7, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn1_7';	    end if;				if new.sn1_7_esp is distinct from old.sn1_7_esp then			update yeah_2011.respuestas set res_respuesta=new.sn1_7_esp, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn1_7_esp';	    end if;				if new.sn1_2 is distinct from old.sn1_2 then			update yeah_2011.respuestas set res_respuesta=new.sn1_2, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn1_2';	    end if;				if new.sn1_2_esp is distinct from old.sn1_2_esp then			update yeah_2011.respuestas set res_respuesta=new.sn1_2_esp, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn1_2_esp';	    end if;				if new.sn1_3 is distinct from old.sn1_3 then			update yeah_2011.respuestas set res_respuesta=new.sn1_3, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn1_3';	    end if;				if new.sn1_3_esp is distinct from old.sn1_3_esp then			update yeah_2011.respuestas set res_respuesta=new.sn1_3_esp, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn1_3_esp';	    end if;				if new.sn1_4 is distinct from old.sn1_4 then			update yeah_2011.respuestas set res_respuesta=new.sn1_4, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn1_4';	    end if;				if new.sn1_4_esp is distinct from old.sn1_4_esp then			update yeah_2011.respuestas set res_respuesta=new.sn1_4_esp, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn1_4_esp';	    end if;				if new.sn1_5 is distinct from old.sn1_5 then			update yeah_2011.respuestas set res_respuesta=new.sn1_5, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn1_5';	    end if;				if new.sn1_6 is distinct from old.sn1_6 then			update yeah_2011.respuestas set res_respuesta=new.sn1_6, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn1_6';	    end if;				if new.sn2_cant is distinct from old.sn2_cant then			update yeah_2011.respuestas set res_respuesta=new.sn2_cant, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn2_cant';	    end if;				if new.sn2 is distinct from old.sn2 then			update yeah_2011.respuestas set res_respuesta=new.sn2, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn2';	    end if;				if new.sn3 is distinct from old.sn3 then			update yeah_2011.respuestas set res_respuesta=new.sn3, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn3';	    end if;				if new.sn4_esp is distinct from old.sn4_esp then			update yeah_2011.respuestas set res_respuesta=new.sn4_esp, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn4_esp';	    end if;				if new.sn4 is distinct from old.sn4 then			update yeah_2011.respuestas set res_respuesta=new.sn4, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn4';	    end if;				if new.sn5_esp is distinct from old.sn5_esp then			update yeah_2011.respuestas set res_respuesta=new.sn5_esp, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn5_esp';	    end if;				if new.sn5 is distinct from old.sn5 then			update yeah_2011.respuestas set res_respuesta=new.sn5, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn5';	    end if;				if new.sn6_cant is distinct from old.sn6_cant then			update yeah_2011.respuestas set res_respuesta=new.sn6_cant, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn6_cant';	    end if;				if new.sn6 is distinct from old.sn6 then			update yeah_2011.respuestas set res_respuesta=new.sn6, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn6';	    end if;				if new.sn7_esp is distinct from old.sn7_esp then			update yeah_2011.respuestas set res_respuesta=new.sn7_esp, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn7_esp';	    end if;				if new.sn7 is distinct from old.sn7 then			update yeah_2011.respuestas set res_respuesta=new.sn7, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn7';	    end if;				if new.sn8_esp is distinct from old.sn8_esp then			update yeah_2011.respuestas set res_respuesta=new.sn8_esp, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn8_esp';	    end if;				if new.sn8 is distinct from old.sn8 then			update yeah_2011.respuestas set res_respuesta=new.sn8, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn8';	    end if;				if new.sn9 is distinct from old.sn9 then			update yeah_2011.respuestas set res_respuesta=new.sn9, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn9';	    end if;				if new.sn10a is distinct from old.sn10a then			update yeah_2011.respuestas set res_respuesta=new.sn10a, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn10a';	    end if;				if new.sn10b is distinct from old.sn10b then			update yeah_2011.respuestas set res_respuesta=new.sn10b, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn10b';	    end if;				if new.sn10c is distinct from old.sn10c then			update yeah_2011.respuestas set res_respuesta=new.sn10c, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn10c';	    end if;				if new.sn10d is distinct from old.sn10d then			update yeah_2011.respuestas set res_respuesta=new.sn10d, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn10d';	    end if;				if new.sn10e is distinct from old.sn10e then			update yeah_2011.respuestas set res_respuesta=new.sn10e, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn10e';	    end if;				if new.sn10f is distinct from old.sn10f then			update yeah_2011.respuestas set res_respuesta=new.sn10f, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn10f';	    end if;				if new.sn10g is distinct from old.sn10g then			update yeah_2011.respuestas set res_respuesta=new.sn10g, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn10g';	    end if;				if new.sn10h is distinct from old.sn10h then			update yeah_2011.respuestas set res_respuesta=new.sn10h, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn10h';	    end if;				if new.sn10i is distinct from old.sn10i then			update yeah_2011.respuestas set res_respuesta=new.sn10i, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn10i';	    end if;				if new.sn10j is distinct from old.sn10j then			update yeah_2011.respuestas set res_respuesta=new.sn10j, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn10j';	    end if;				if new.sn10_j_esp is distinct from old.sn10_j_esp then			update yeah_2011.respuestas set res_respuesta=new.sn10_j_esp, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn10_j_esp';	    end if;				if new.sn11 is distinct from old.sn11 then			update yeah_2011.respuestas set res_respuesta=new.sn11, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn11';	    end if;				if new.sn12_esp is distinct from old.sn12_esp then			update yeah_2011.respuestas set res_respuesta=new.sn12_esp, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn12_esp';	    end if;				if new.sn12 is distinct from old.sn12 then			update yeah_2011.respuestas set res_respuesta=new.sn12, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn12';	    end if;				if new.sn13_otro is distinct from old.sn13_otro then			update yeah_2011.respuestas set res_respuesta=new.sn13_otro, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn13_otro';	    end if;				if new.sn13 is distinct from old.sn13 then			update yeah_2011.respuestas set res_respuesta=new.sn13, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn13';	    end if;				if new.sn14_esp is distinct from old.sn14_esp then			update yeah_2011.respuestas set res_respuesta=new.sn14_esp, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn14_esp';	    end if;				if new.sn14 is distinct from old.sn14 then			update yeah_2011.respuestas set res_respuesta=new.sn14, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn14';	    end if;				if new.sn15a is distinct from old.sn15a then			update yeah_2011.respuestas set res_respuesta=new.sn15a, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn15a';	    end if;				if new.sn15b is distinct from old.sn15b then			update yeah_2011.respuestas set res_respuesta=new.sn15b, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn15b';	    end if;				if new.sn15c is distinct from old.sn15c then			update yeah_2011.respuestas set res_respuesta=new.sn15c, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn15c';	    end if;				if new.sn15d is distinct from old.sn15d then			update yeah_2011.respuestas set res_respuesta=new.sn15d, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn15d';	    end if;				if new.sn15e is distinct from old.sn15e then			update yeah_2011.respuestas set res_respuesta=new.sn15e, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn15e';	    end if;				if new.sn15f is distinct from old.sn15f then			update yeah_2011.respuestas set res_respuesta=new.sn15f, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn15f';	    end if;				if new.sn15g is distinct from old.sn15g then			update yeah_2011.respuestas set res_respuesta=new.sn15g, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn15g';	    end if;				if new.sn15h is distinct from old.sn15h then			update yeah_2011.respuestas set res_respuesta=new.sn15h, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn15h';	    end if;				if new.sn15i is distinct from old.sn15i then			update yeah_2011.respuestas set res_respuesta=new.sn15i, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn15i';	    end if;				if new.sn15j is distinct from old.sn15j then			update yeah_2011.respuestas set res_respuesta=new.sn15j, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn15j';	    end if;				if new.sn15k is distinct from old.sn15k then			update yeah_2011.respuestas set res_respuesta=new.sn15k, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn15k';	    end if;				if new.sn15k_esp is distinct from old.sn15k_esp then			update yeah_2011.respuestas set res_respuesta=new.sn15k_esp, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn15k_esp';	    end if;				if new.sn16 is distinct from old.sn16 then			update yeah_2011.respuestas set res_respuesta=new.sn16, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='sn16';	    end if;				if new.s28 is distinct from old.s28 then			update yeah_2011.respuestas set res_respuesta=new.s28, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='s28';	    end if;				if new.s29 is distinct from old.s29 then			update yeah_2011.respuestas set res_respuesta=new.s29, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='s29';	    end if;				if new.s30 is distinct from old.s30 then			update yeah_2011.respuestas set res_respuesta=new.s30, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='s30';	    end if;				if new.s31_anio is distinct from old.s31_anio then			update yeah_2011.respuestas set res_respuesta=new.s31_anio, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='s31_anio';	    end if;				if new.s31_mes is distinct from old.s31_mes then			update yeah_2011.respuestas set res_respuesta=new.s31_mes, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='s31_mes';	    end if;				if new.md1 is distinct from old.md1 then			update yeah_2011.respuestas set res_respuesta=new.md1, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='md1';	    end if;				if new.md2 is distinct from old.md2 then			update yeah_2011.respuestas set res_respuesta=new.md2, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='md2';	    end if;				if new.md3 is distinct from old.md3 then			update yeah_2011.respuestas set res_respuesta=new.md3, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='md3';	    end if;				if new.md4 is distinct from old.md4 then			update yeah_2011.respuestas set res_respuesta=new.md4, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='md4';	    end if;				if new.md5 is distinct from old.md5 then			update yeah_2011.respuestas set res_respuesta=new.md5, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='md5';	    end if;				if new.md6 is distinct from old.md6 then			update yeah_2011.respuestas set res_respuesta=new.md6, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='md6';	    end if;				if new.md7 is distinct from old.md7 then			update yeah_2011.respuestas set res_respuesta=new.md7, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='md7';	    end if;				if new.md8 is distinct from old.md8 then			update yeah_2011.respuestas set res_respuesta=new.md8, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='md8';	    end if;				if new.md9 is distinct from old.md9 then			update yeah_2011.respuestas set res_respuesta=new.md9, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='md9';	    end if;				if new.md10 is distinct from old.md10 then			update yeah_2011.respuestas set res_respuesta=new.md10, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='md10';	    end if;				if new.md11 is distinct from old.md11 then			update yeah_2011.respuestas set res_respuesta=new.md11, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='md11';	    end if;				if new.md12 is distinct from old.md12 then			update yeah_2011.respuestas set res_respuesta=new.md12, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='md12';	    end if;				if new.obs is distinct from old.obs then			update yeah_2011.respuestas set res_respuesta=new.obs, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='obs';	    end if;		  RETURN new;END$$;


ALTER FUNCTION yeah_2011.res_eah11_i1_upd() OWNER TO yeahowner;

--
-- Name: res_eah11_md_del(); Type: FUNCTION; Schema: yeah_2011; Owner: yeahowner
--

CREATE FUNCTION res_eah11_md_del() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  		delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=0 and res_tab='md';
		
  RETURN old;
END
$$;


ALTER FUNCTION yeah_2011.res_eah11_md_del() OWNER TO yeahowner;

--
-- Name: res_eah11_md_ins(); Type: FUNCTION; Schema: yeah_2011; Owner: yeahowner
--

CREATE FUNCTION res_eah11_md_ins() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN  		INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'entre_realizada', 'MD', '', 'md',new.entre_realizada,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d1_meses', 'MD', '', 'md',new.d1_meses,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d1_anios', 'MD', '', 'md',new.d1_anios,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d2', 'MD', '', 'md',new.d2,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d3_1', 'MD', '', 'md',new.d3_1,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d3_2', 'MD', '', 'md',new.d3_2,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d3_3', 'MD', '', 'md',new.d3_3,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d3_4', 'MD', '', 'md',new.d3_4,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d3_5', 'MD', '', 'md',new.d3_5,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d3_6', 'MD', '', 'md',new.d3_6,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d3_7', 'MD', '', 'md',new.d3_7,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d3_8', 'MD', '', 'md',new.d3_8,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d3_9', 'MD', '', 'md',new.d3_9,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d3_10', 'MD', '', 'md',new.d3_10,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d3_11', 'MD', '', 'md',new.d3_11,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d3_12', 'MD', '', 'md',new.d3_12,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d3_13', 'MD', '', 'md',new.d3_13,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d3_14', 'MD', '', 'md',new.d3_14,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d4', 'MD', '', 'md',new.d4,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d5_1', 'MD', '', 'md',new.d5_1,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d5_2', 'MD', '', 'md',new.d5_2,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d5_3', 'MD', '', 'md',new.d5_3,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d5_4', 'MD', '', 'md',new.d5_4,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d5_5', 'MD', '', 'md',new.d5_5,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d5_6', 'MD', '', 'md',new.d5_6,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d5_7', 'MD', '', 'md',new.d5_7,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d5_8', 'MD', '', 'md',new.d5_8,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d5_9', 'MD', '', 'md',new.d5_9,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d5_10', 'MD', '', 'md',new.d5_10,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d5_11', 'MD', '', 'md',new.d5_11,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d6', 'MD', '', 'md',new.d6,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d7', 'MD', '', 'md',new.d7,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d8', 'MD', '', 'md',new.d8,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d8_esp', 'MD', '', 'md',new.d8_esp,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d9', 'MD', '', 'md',new.d9,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d9_esp', 'MD', '', 'md',new.d9_esp,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d10', 'MD', '', 'md',new.d10,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d11_1', 'MD', '', 'md',new.d11_1,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d11_2', 'MD', '', 'md',new.d11_2,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d11_3', 'MD', '', 'md',new.d11_3,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d11_4', 'MD', '', 'md',new.d11_4,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d11_5', 'MD', '', 'md',new.d11_5,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d11_6', 'MD', '', 'md',new.d11_6,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d11_7', 'MD', '', 'md',new.d11_7,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d11_8', 'MD', '', 'md',new.d11_8,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d11_9', 'MD', '', 'md',new.d11_9,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d11_10', 'MD', '', 'md',new.d11_10,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d12', 'MD', '', 'md',new.d12,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d13', 'MD', '', 'md',new.d13,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d14_1', 'MD', '', 'md',new.d14_1,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d14_2', 'MD', '', 'md',new.d14_2,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d14_3', 'MD', '', 'md',new.d14_3,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d14_4', 'MD', '', 'md',new.d14_4,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d14_5', 'MD', '', 'md',new.d14_5,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d14_6', 'MD', '', 'md',new.d14_6,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d15', 'MD', '', 'md',new.d15,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d16', 'MD', '', 'md',new.d16,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d17', 'MD', '', 'md',new.d17,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d18', 'MD', '', 'md',new.d18,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d19', 'MD', '', 'md',new.d19,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d20', 'MD', '', 'md',new.d20,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d21', 'MD', '', 'md',new.d21,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d22', 'MD', '', 'md',new.d22,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d23', 'MD', '', 'md',new.d23,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d24', 'MD', '', 'md',new.d24,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d25', 'MD', '', 'md',new.d25,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d26', 'MD', '', 'md',new.d26,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'d27', 'MD', '', 'md',new.d27,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'razon_no_realizada', 'MD', '', 'md',new.razon_no_realizada,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'razon_no_realizada_1', 'MD', '', 'md',new.razon_no_realizada_1,new.usuario);				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,0,'razon_no_realizada_2', 'MD', '', 'md',new.razon_no_realizada_2,new.usuario);		  RETURN new;END$$;


ALTER FUNCTION yeah_2011.res_eah11_md_ins() OWNER TO yeahowner;

--
-- Name: res_eah11_md_upd(); Type: FUNCTION; Schema: yeah_2011; Owner: yeahowner
--

CREATE FUNCTION res_eah11_md_upd() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN  		if new.entre_realizada is distinct from old.entre_realizada then			update yeah_2011.respuestas set res_respuesta=new.entre_realizada, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='entre_realizada';	    end if;				if new.d1_meses is distinct from old.d1_meses then			update yeah_2011.respuestas set res_respuesta=new.d1_meses, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d1_meses';	    end if;				if new.d1_anios is distinct from old.d1_anios then			update yeah_2011.respuestas set res_respuesta=new.d1_anios, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d1_anios';	    end if;				if new.d2 is distinct from old.d2 then			update yeah_2011.respuestas set res_respuesta=new.d2, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d2';	    end if;				if new.d3_1 is distinct from old.d3_1 then			update yeah_2011.respuestas set res_respuesta=new.d3_1, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d3_1';	    end if;				if new.d3_2 is distinct from old.d3_2 then			update yeah_2011.respuestas set res_respuesta=new.d3_2, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d3_2';	    end if;				if new.d3_3 is distinct from old.d3_3 then			update yeah_2011.respuestas set res_respuesta=new.d3_3, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d3_3';	    end if;				if new.d3_4 is distinct from old.d3_4 then			update yeah_2011.respuestas set res_respuesta=new.d3_4, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d3_4';	    end if;				if new.d3_5 is distinct from old.d3_5 then			update yeah_2011.respuestas set res_respuesta=new.d3_5, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d3_5';	    end if;				if new.d3_6 is distinct from old.d3_6 then			update yeah_2011.respuestas set res_respuesta=new.d3_6, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d3_6';	    end if;				if new.d3_7 is distinct from old.d3_7 then			update yeah_2011.respuestas set res_respuesta=new.d3_7, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d3_7';	    end if;				if new.d3_8 is distinct from old.d3_8 then			update yeah_2011.respuestas set res_respuesta=new.d3_8, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d3_8';	    end if;				if new.d3_9 is distinct from old.d3_9 then			update yeah_2011.respuestas set res_respuesta=new.d3_9, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d3_9';	    end if;				if new.d3_10 is distinct from old.d3_10 then			update yeah_2011.respuestas set res_respuesta=new.d3_10, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d3_10';	    end if;				if new.d3_11 is distinct from old.d3_11 then			update yeah_2011.respuestas set res_respuesta=new.d3_11, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d3_11';	    end if;				if new.d3_12 is distinct from old.d3_12 then			update yeah_2011.respuestas set res_respuesta=new.d3_12, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d3_12';	    end if;				if new.d3_13 is distinct from old.d3_13 then			update yeah_2011.respuestas set res_respuesta=new.d3_13, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d3_13';	    end if;				if new.d3_14 is distinct from old.d3_14 then			update yeah_2011.respuestas set res_respuesta=new.d3_14, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d3_14';	    end if;				if new.d4 is distinct from old.d4 then			update yeah_2011.respuestas set res_respuesta=new.d4, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d4';	    end if;				if new.d5_1 is distinct from old.d5_1 then			update yeah_2011.respuestas set res_respuesta=new.d5_1, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d5_1';	    end if;				if new.d5_2 is distinct from old.d5_2 then			update yeah_2011.respuestas set res_respuesta=new.d5_2, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d5_2';	    end if;				if new.d5_3 is distinct from old.d5_3 then			update yeah_2011.respuestas set res_respuesta=new.d5_3, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d5_3';	    end if;				if new.d5_4 is distinct from old.d5_4 then			update yeah_2011.respuestas set res_respuesta=new.d5_4, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d5_4';	    end if;				if new.d5_5 is distinct from old.d5_5 then			update yeah_2011.respuestas set res_respuesta=new.d5_5, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d5_5';	    end if;				if new.d5_6 is distinct from old.d5_6 then			update yeah_2011.respuestas set res_respuesta=new.d5_6, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d5_6';	    end if;				if new.d5_7 is distinct from old.d5_7 then			update yeah_2011.respuestas set res_respuesta=new.d5_7, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d5_7';	    end if;				if new.d5_8 is distinct from old.d5_8 then			update yeah_2011.respuestas set res_respuesta=new.d5_8, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d5_8';	    end if;				if new.d5_9 is distinct from old.d5_9 then			update yeah_2011.respuestas set res_respuesta=new.d5_9, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d5_9';	    end if;				if new.d5_10 is distinct from old.d5_10 then			update yeah_2011.respuestas set res_respuesta=new.d5_10, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d5_10';	    end if;				if new.d5_11 is distinct from old.d5_11 then			update yeah_2011.respuestas set res_respuesta=new.d5_11, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d5_11';	    end if;				if new.d6 is distinct from old.d6 then			update yeah_2011.respuestas set res_respuesta=new.d6, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d6';	    end if;				if new.d7 is distinct from old.d7 then			update yeah_2011.respuestas set res_respuesta=new.d7, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d7';	    end if;				if new.d8 is distinct from old.d8 then			update yeah_2011.respuestas set res_respuesta=new.d8, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d8';	    end if;				if new.d8_esp is distinct from old.d8_esp then			update yeah_2011.respuestas set res_respuesta=new.d8_esp, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d8_esp';	    end if;				if new.d9 is distinct from old.d9 then			update yeah_2011.respuestas set res_respuesta=new.d9, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d9';	    end if;				if new.d9_esp is distinct from old.d9_esp then			update yeah_2011.respuestas set res_respuesta=new.d9_esp, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d9_esp';	    end if;				if new.d10 is distinct from old.d10 then			update yeah_2011.respuestas set res_respuesta=new.d10, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d10';	    end if;				if new.d11_1 is distinct from old.d11_1 then			update yeah_2011.respuestas set res_respuesta=new.d11_1, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d11_1';	    end if;				if new.d11_2 is distinct from old.d11_2 then			update yeah_2011.respuestas set res_respuesta=new.d11_2, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d11_2';	    end if;				if new.d11_3 is distinct from old.d11_3 then			update yeah_2011.respuestas set res_respuesta=new.d11_3, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d11_3';	    end if;				if new.d11_4 is distinct from old.d11_4 then			update yeah_2011.respuestas set res_respuesta=new.d11_4, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d11_4';	    end if;				if new.d11_5 is distinct from old.d11_5 then			update yeah_2011.respuestas set res_respuesta=new.d11_5, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d11_5';	    end if;				if new.d11_6 is distinct from old.d11_6 then			update yeah_2011.respuestas set res_respuesta=new.d11_6, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d11_6';	    end if;				if new.d11_7 is distinct from old.d11_7 then			update yeah_2011.respuestas set res_respuesta=new.d11_7, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d11_7';	    end if;				if new.d11_8 is distinct from old.d11_8 then			update yeah_2011.respuestas set res_respuesta=new.d11_8, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d11_8';	    end if;				if new.d11_9 is distinct from old.d11_9 then			update yeah_2011.respuestas set res_respuesta=new.d11_9, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d11_9';	    end if;				if new.d11_10 is distinct from old.d11_10 then			update yeah_2011.respuestas set res_respuesta=new.d11_10, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d11_10';	    end if;				if new.d12 is distinct from old.d12 then			update yeah_2011.respuestas set res_respuesta=new.d12, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d12';	    end if;				if new.d13 is distinct from old.d13 then			update yeah_2011.respuestas set res_respuesta=new.d13, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d13';	    end if;				if new.d14_1 is distinct from old.d14_1 then			update yeah_2011.respuestas set res_respuesta=new.d14_1, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d14_1';	    end if;				if new.d14_2 is distinct from old.d14_2 then			update yeah_2011.respuestas set res_respuesta=new.d14_2, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d14_2';	    end if;				if new.d14_3 is distinct from old.d14_3 then			update yeah_2011.respuestas set res_respuesta=new.d14_3, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d14_3';	    end if;				if new.d14_4 is distinct from old.d14_4 then			update yeah_2011.respuestas set res_respuesta=new.d14_4, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d14_4';	    end if;				if new.d14_5 is distinct from old.d14_5 then			update yeah_2011.respuestas set res_respuesta=new.d14_5, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d14_5';	    end if;				if new.d14_6 is distinct from old.d14_6 then			update yeah_2011.respuestas set res_respuesta=new.d14_6, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d14_6';	    end if;				if new.d15 is distinct from old.d15 then			update yeah_2011.respuestas set res_respuesta=new.d15, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d15';	    end if;				if new.d16 is distinct from old.d16 then			update yeah_2011.respuestas set res_respuesta=new.d16, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d16';	    end if;				if new.d17 is distinct from old.d17 then			update yeah_2011.respuestas set res_respuesta=new.d17, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d17';	    end if;				if new.d18 is distinct from old.d18 then			update yeah_2011.respuestas set res_respuesta=new.d18, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d18';	    end if;				if new.d19 is distinct from old.d19 then			update yeah_2011.respuestas set res_respuesta=new.d19, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d19';	    end if;				if new.d20 is distinct from old.d20 then			update yeah_2011.respuestas set res_respuesta=new.d20, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d20';	    end if;				if new.d21 is distinct from old.d21 then			update yeah_2011.respuestas set res_respuesta=new.d21, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d21';	    end if;				if new.d22 is distinct from old.d22 then			update yeah_2011.respuestas set res_respuesta=new.d22, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d22';	    end if;				if new.d23 is distinct from old.d23 then			update yeah_2011.respuestas set res_respuesta=new.d23, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d23';	    end if;				if new.d24 is distinct from old.d24 then			update yeah_2011.respuestas set res_respuesta=new.d24, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d24';	    end if;				if new.d25 is distinct from old.d25 then			update yeah_2011.respuestas set res_respuesta=new.d25, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d25';	    end if;				if new.d26 is distinct from old.d26 then			update yeah_2011.respuestas set res_respuesta=new.d26, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d26';	    end if;				if new.d27 is distinct from old.d27 then			update yeah_2011.respuestas set res_respuesta=new.d27, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='d27';	    end if;				if new.razon_no_realizada is distinct from old.razon_no_realizada then			update yeah_2011.respuestas set res_respuesta=new.razon_no_realizada, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='razon_no_realizada';	    end if;				if new.razon_no_realizada_1 is distinct from old.razon_no_realizada_1 then			update yeah_2011.respuestas set res_respuesta=new.razon_no_realizada_1, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='razon_no_realizada_1';	    end if;				if new.razon_no_realizada_2 is distinct from old.razon_no_realizada_2 then			update yeah_2011.respuestas set res_respuesta=new.razon_no_realizada_2, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=0 and res_var='razon_no_realizada_2';	    end if;		  RETURN new;END$$;


ALTER FUNCTION yeah_2011.res_eah11_md_upd() OWNER TO yeahowner;

--
-- Name: res_eah11_un_del(); Type: FUNCTION; Schema: yeah_2011; Owner: yeahowner
--

CREATE FUNCTION res_eah11_un_del() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  		delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=old.relacion and res_tab='un';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=old.relacion and res_tab='un';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=old.relacion and res_tab='un';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=old.relacion and res_tab='un';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=old.relacion and res_tab='un';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=old.relacion and res_tab='un';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=old.miembro and res_ex_miembro=0 and res_relacion=old.relacion and res_tab='un';
		
  RETURN old;
END
$$;


ALTER FUNCTION yeah_2011.res_eah11_un_del() OWNER TO yeahowner;

--
-- Name: res_eah11_un_ins(); Type: FUNCTION; Schema: yeah_2011; Owner: yeahowner
--

CREATE FUNCTION res_eah11_un_ins() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  		INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,new.relacion,'relacion', 'I1', 'U', 'un',new.relacion,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,new.relacion,'u3_mes', 'I1', 'U', 'un',new.u3_mes,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,new.relacion,'u3_anio', 'I1', 'U', 'un',new.u3_anio,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,new.relacion,'u4_mes', 'I1', 'U', 'un',new.u4_mes,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,new.relacion,'u4_anio', 'I1', 'U', 'un',new.u4_anio,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,new.relacion,'u5', 'I1', 'U', 'un',new.u5,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,new.miembro,0,new.relacion,'u6', 'I1', 'U', 'un',new.u6,new.usuario);
		
  RETURN new;
END
$$;


ALTER FUNCTION yeah_2011.res_eah11_un_ins() OWNER TO yeahowner;

--
-- Name: res_eah11_un_upd(); Type: FUNCTION; Schema: yeah_2011; Owner: yeahowner
--

CREATE FUNCTION res_eah11_un_upd() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  		if new.relacion is distinct from old.relacion then
			update yeah_2011.respuestas set res_respuesta=new.relacion, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=new.relacion and res_var='relacion';
	    end if;
				if new.u3_mes is distinct from old.u3_mes then
			update yeah_2011.respuestas set res_respuesta=new.u3_mes, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=new.relacion and res_var='u3_mes';
	    end if;
				if new.u3_anio is distinct from old.u3_anio then
			update yeah_2011.respuestas set res_respuesta=new.u3_anio, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=new.relacion and res_var='u3_anio';
	    end if;
				if new.u4_mes is distinct from old.u4_mes then
			update yeah_2011.respuestas set res_respuesta=new.u4_mes, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=new.relacion and res_var='u4_mes';
	    end if;
				if new.u4_anio is distinct from old.u4_anio then
			update yeah_2011.respuestas set res_respuesta=new.u4_anio, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=new.relacion and res_var='u4_anio';
	    end if;
				if new.u5 is distinct from old.u5 then
			update yeah_2011.respuestas set res_respuesta=new.u5, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=new.relacion and res_var='u5';
	    end if;
				if new.u6 is distinct from old.u6 then
			update yeah_2011.respuestas set res_respuesta=new.u6, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=new.miembro and res_ex_miembro=0 and res_relacion=new.relacion and res_var='u6';
	    end if;
		
  RETURN new;
END
$$;


ALTER FUNCTION yeah_2011.res_eah11_un_upd() OWNER TO yeahowner;

--
-- Name: res_eah11_viv_s1a1_del(); Type: FUNCTION; Schema: yeah_2011; Owner: yeahowner
--

CREATE FUNCTION res_eah11_viv_s1a1_del() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  		delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
				delete from yeah_2011.respuestas WHERE res_encuesta=old.nenc AND res_hogar=old.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_tab='viv_s1a1';
		
  RETURN old;
END
$$;


ALTER FUNCTION yeah_2011.res_eah11_viv_s1a1_del() OWNER TO yeahowner;

--
-- Name: res_eah11_viv_s1a1_ins(); Type: FUNCTION; Schema: yeah_2011; Owner: yeahowner
--

CREATE FUNCTION res_eah11_viv_s1a1_ins() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  		INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'participacion', 'S1', '', 'viv_s1a1',new.participacion,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'entrea', 'S1', '', 'viv_s1a1',new.entrea,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'respond', 'S1', '', 'viv_s1a1',new.respond,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'telefono', 'S1', '', 'viv_s1a1',new.telefono,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'nombrer', 'S1', '', 'viv_s1a1',new.nombrer,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'f_realiz_o', 'S1', '', 'viv_s1a1',new.f_realiz_o,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'v1', 'S1', '', 'viv_s1a1',new.v1,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'total_h', 'S1', '', 'viv_s1a1',new.total_h,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'total_m', 'S1', '', 'viv_s1a1',new.total_m,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'razon1', 'S1', '', 'viv_s1a1',new.razon1,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'razon2_1', 'S1', '', 'viv_s1a1',new.razon2_1,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'razon2_2', 'S1', '', 'viv_s1a1',new.razon2_2,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'razon2_3', 'S1', '', 'viv_s1a1',new.razon2_3,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'razon2_4', 'S1', '', 'viv_s1a1',new.razon2_4,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'razon2_5', 'S1', '', 'viv_s1a1',new.razon2_5,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'razon3', 'S1', '', 'viv_s1a1',new.razon3,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'razon2_6', 'S1', '', 'viv_s1a1',new.razon2_6,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'razon2_7', 'S1', '', 'viv_s1a1',new.razon2_7,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'razon2_8', 'S1', '', 'viv_s1a1',new.razon2_8,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'razon2_9', 'S1', '', 'viv_s1a1',new.razon2_9,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'v2_esp', 'A1', '', 'viv_s1a1',new.v2_esp,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'v2', 'A1', '', 'viv_s1a1',new.v2,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'v4', 'A1', '', 'viv_s1a1',new.v4,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'v5_esp', 'A1', '', 'viv_s1a1',new.v5_esp,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'v5', 'A1', '', 'viv_s1a1',new.v5,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'v6', 'A1', '', 'viv_s1a1',new.v6,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'v7', 'A1', '', 'viv_s1a1',new.v7,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'v12', 'A1', '', 'viv_s1a1',new.v12,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'h1', 'A1', '', 'viv_s1a1',new.h1,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'h2_esp', 'A1', '', 'viv_s1a1',new.h2_esp,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'h2', 'A1', '', 'viv_s1a1',new.h2,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'h3', 'A1', '', 'viv_s1a1',new.h3,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'h4', 'A1', '', 'viv_s1a1',new.h4,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'h4_tipot', 'A1', '', 'viv_s1a1',new.h4_tipot,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'h4_tel', 'A1', '', 'viv_s1a1',new.h4_tel,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'h20_1', 'A1', '', 'viv_s1a1',new.h20_1,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'h20_4', 'A1', '', 'viv_s1a1',new.h20_4,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'h20_2', 'A1', '', 'viv_s1a1',new.h20_2,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'h20_17', 'A1', '', 'viv_s1a1',new.h20_17,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'h20_18', 'A1', '', 'viv_s1a1',new.h20_18,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'h20_5', 'A1', '', 'viv_s1a1',new.h20_5,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'h20_6', 'A1', '', 'viv_s1a1',new.h20_6,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'h20_7', 'A1', '', 'viv_s1a1',new.h20_7,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'h20_15', 'A1', '', 'viv_s1a1',new.h20_15,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'h20_8', 'A1', '', 'viv_s1a1',new.h20_8,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'h20_19', 'A1', '', 'viv_s1a1',new.h20_19,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'h20_20', 'A1', '', 'viv_s1a1',new.h20_20,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'h20_16', 'A1', '', 'viv_s1a1',new.h20_16,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'h20_10', 'A1', '', 'viv_s1a1',new.h20_10,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'h20_12', 'A1', '', 'viv_s1a1',new.h20_12,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'h20_11', 'A1', '', 'viv_s1a1',new.h20_11,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'h20_13', 'A1', '', 'viv_s1a1',new.h20_13,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'h20_14', 'A1', '', 'viv_s1a1',new.h20_14,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'h20_esp', 'A1', '', 'viv_s1a1',new.h20_esp,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'x5', 'A1', '', 'viv_s1a1',new.x5,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'x5_tot', 'A1', '', 'viv_s1a1',new.x5_tot,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'h30_tv', 'A1', '', 'viv_s1a1',new.h30_tv,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'h30_hf', 'A1', '', 'viv_s1a1',new.h30_hf,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'h30_la', 'A1', '', 'viv_s1a1',new.h30_la,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'h30_vi', 'A1', '', 'viv_s1a1',new.h30_vi,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'h30_ac', 'A1', '', 'viv_s1a1',new.h30_ac,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'h30_dvd', 'A1', '', 'viv_s1a1',new.h30_dvd,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'h30_mo', 'A1', '', 'viv_s1a1',new.h30_mo,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'h30_pc', 'A1', '', 'viv_s1a1',new.h30_pc,new.usuario);
				INSERT INTO yeah_2011.respuestas(res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod) VALUES (new.nenc,new.nhogar,0,0,0,'h30_in', 'A1', '', 'viv_s1a1',new.h30_in,new.usuario);
		
  RETURN new;
END
$$;


ALTER FUNCTION yeah_2011.res_eah11_viv_s1a1_ins() OWNER TO yeahowner;

--
-- Name: res_eah11_viv_s1a1_upd(); Type: FUNCTION; Schema: yeah_2011; Owner: yeahowner
--

CREATE FUNCTION res_eah11_viv_s1a1_upd() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  		if new.participacion is distinct from old.participacion then
			update yeah_2011.respuestas set res_respuesta=new.participacion, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='participacion';
	    end if;
				if new.entrea is distinct from old.entrea then
			update yeah_2011.respuestas set res_respuesta=new.entrea, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='entrea';
	    end if;
				if new.respond is distinct from old.respond then
			update yeah_2011.respuestas set res_respuesta=new.respond, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='respond';
	    end if;
				if new.telefono is distinct from old.telefono then
			update yeah_2011.respuestas set res_respuesta=new.telefono, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='telefono';
	    end if;
				if new.nombrer is distinct from old.nombrer then
			update yeah_2011.respuestas set res_respuesta=new.nombrer, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='nombrer';
	    end if;
				if new.f_realiz_o is distinct from old.f_realiz_o then
			update yeah_2011.respuestas set res_respuesta=new.f_realiz_o, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='f_realiz_o';
	    end if;
				if new.v1 is distinct from old.v1 then
			update yeah_2011.respuestas set res_respuesta=new.v1, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='v1';
	    end if;
				if new.total_h is distinct from old.total_h then
			update yeah_2011.respuestas set res_respuesta=new.total_h, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='total_h';
	    end if;
				if new.total_m is distinct from old.total_m then
			update yeah_2011.respuestas set res_respuesta=new.total_m, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='total_m';
	    end if;
				if new.razon1 is distinct from old.razon1 then
			update yeah_2011.respuestas set res_respuesta=new.razon1, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='razon1';
	    end if;
				if new.razon2_1 is distinct from old.razon2_1 then
			update yeah_2011.respuestas set res_respuesta=new.razon2_1, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='razon2_1';
	    end if;
				if new.razon2_2 is distinct from old.razon2_2 then
			update yeah_2011.respuestas set res_respuesta=new.razon2_2, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='razon2_2';
	    end if;
				if new.razon2_3 is distinct from old.razon2_3 then
			update yeah_2011.respuestas set res_respuesta=new.razon2_3, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='razon2_3';
	    end if;
				if new.razon2_4 is distinct from old.razon2_4 then
			update yeah_2011.respuestas set res_respuesta=new.razon2_4, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='razon2_4';
	    end if;
				if new.razon2_5 is distinct from old.razon2_5 then
			update yeah_2011.respuestas set res_respuesta=new.razon2_5, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='razon2_5';
	    end if;
				if new.razon3 is distinct from old.razon3 then
			update yeah_2011.respuestas set res_respuesta=new.razon3, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='razon3';
	    end if;
				if new.razon2_6 is distinct from old.razon2_6 then
			update yeah_2011.respuestas set res_respuesta=new.razon2_6, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='razon2_6';
	    end if;
				if new.razon2_7 is distinct from old.razon2_7 then
			update yeah_2011.respuestas set res_respuesta=new.razon2_7, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='razon2_7';
	    end if;
				if new.razon2_8 is distinct from old.razon2_8 then
			update yeah_2011.respuestas set res_respuesta=new.razon2_8, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='razon2_8';
	    end if;
				if new.razon2_9 is distinct from old.razon2_9 then
			update yeah_2011.respuestas set res_respuesta=new.razon2_9, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='razon2_9';
	    end if;
				if new.v2_esp is distinct from old.v2_esp then
			update yeah_2011.respuestas set res_respuesta=new.v2_esp, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='v2_esp';
	    end if;
				if new.v2 is distinct from old.v2 then
			update yeah_2011.respuestas set res_respuesta=new.v2, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='v2';
	    end if;
				if new.v4 is distinct from old.v4 then
			update yeah_2011.respuestas set res_respuesta=new.v4, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='v4';
	    end if;
				if new.v5_esp is distinct from old.v5_esp then
			update yeah_2011.respuestas set res_respuesta=new.v5_esp, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='v5_esp';
	    end if;
				if new.v5 is distinct from old.v5 then
			update yeah_2011.respuestas set res_respuesta=new.v5, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='v5';
	    end if;
				if new.v6 is distinct from old.v6 then
			update yeah_2011.respuestas set res_respuesta=new.v6, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='v6';
	    end if;
				if new.v7 is distinct from old.v7 then
			update yeah_2011.respuestas set res_respuesta=new.v7, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='v7';
	    end if;
				if new.v12 is distinct from old.v12 then
			update yeah_2011.respuestas set res_respuesta=new.v12, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='v12';
	    end if;
				if new.h1 is distinct from old.h1 then
			update yeah_2011.respuestas set res_respuesta=new.h1, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='h1';
	    end if;
				if new.h2_esp is distinct from old.h2_esp then
			update yeah_2011.respuestas set res_respuesta=new.h2_esp, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='h2_esp';
	    end if;
				if new.h2 is distinct from old.h2 then
			update yeah_2011.respuestas set res_respuesta=new.h2, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='h2';
	    end if;
				if new.h3 is distinct from old.h3 then
			update yeah_2011.respuestas set res_respuesta=new.h3, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='h3';
	    end if;
				if new.h4 is distinct from old.h4 then
			update yeah_2011.respuestas set res_respuesta=new.h4, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='h4';
	    end if;
				if new.h4_tipot is distinct from old.h4_tipot then
			update yeah_2011.respuestas set res_respuesta=new.h4_tipot, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='h4_tipot';
	    end if;
				if new.h4_tel is distinct from old.h4_tel then
			update yeah_2011.respuestas set res_respuesta=new.h4_tel, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='h4_tel';
	    end if;
				if new.h20_1 is distinct from old.h20_1 then
			update yeah_2011.respuestas set res_respuesta=new.h20_1, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='h20_1';
	    end if;
				if new.h20_4 is distinct from old.h20_4 then
			update yeah_2011.respuestas set res_respuesta=new.h20_4, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='h20_4';
	    end if;
				if new.h20_2 is distinct from old.h20_2 then
			update yeah_2011.respuestas set res_respuesta=new.h20_2, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='h20_2';
	    end if;
				if new.h20_17 is distinct from old.h20_17 then
			update yeah_2011.respuestas set res_respuesta=new.h20_17, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='h20_17';
	    end if;
				if new.h20_18 is distinct from old.h20_18 then
			update yeah_2011.respuestas set res_respuesta=new.h20_18, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='h20_18';
	    end if;
				if new.h20_5 is distinct from old.h20_5 then
			update yeah_2011.respuestas set res_respuesta=new.h20_5, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='h20_5';
	    end if;
				if new.h20_6 is distinct from old.h20_6 then
			update yeah_2011.respuestas set res_respuesta=new.h20_6, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='h20_6';
	    end if;
				if new.h20_7 is distinct from old.h20_7 then
			update yeah_2011.respuestas set res_respuesta=new.h20_7, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='h20_7';
	    end if;
				if new.h20_15 is distinct from old.h20_15 then
			update yeah_2011.respuestas set res_respuesta=new.h20_15, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='h20_15';
	    end if;
				if new.h20_8 is distinct from old.h20_8 then
			update yeah_2011.respuestas set res_respuesta=new.h20_8, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='h20_8';
	    end if;
				if new.h20_19 is distinct from old.h20_19 then
			update yeah_2011.respuestas set res_respuesta=new.h20_19, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='h20_19';
	    end if;
				if new.h20_20 is distinct from old.h20_20 then
			update yeah_2011.respuestas set res_respuesta=new.h20_20, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='h20_20';
	    end if;
				if new.h20_16 is distinct from old.h20_16 then
			update yeah_2011.respuestas set res_respuesta=new.h20_16, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='h20_16';
	    end if;
				if new.h20_10 is distinct from old.h20_10 then
			update yeah_2011.respuestas set res_respuesta=new.h20_10, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='h20_10';
	    end if;
				if new.h20_12 is distinct from old.h20_12 then
			update yeah_2011.respuestas set res_respuesta=new.h20_12, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='h20_12';
	    end if;
				if new.h20_11 is distinct from old.h20_11 then
			update yeah_2011.respuestas set res_respuesta=new.h20_11, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='h20_11';
	    end if;
				if new.h20_13 is distinct from old.h20_13 then
			update yeah_2011.respuestas set res_respuesta=new.h20_13, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='h20_13';
	    end if;
				if new.h20_14 is distinct from old.h20_14 then
			update yeah_2011.respuestas set res_respuesta=new.h20_14, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='h20_14';
	    end if;
				if new.h20_esp is distinct from old.h20_esp then
			update yeah_2011.respuestas set res_respuesta=new.h20_esp, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='h20_esp';
	    end if;
				if new.x5 is distinct from old.x5 then
			update yeah_2011.respuestas set res_respuesta=new.x5, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='x5';
	    end if;
				if new.x5_tot is distinct from old.x5_tot then
			update yeah_2011.respuestas set res_respuesta=new.x5_tot, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='x5_tot';
	    end if;
				if new.h30_tv is distinct from old.h30_tv then
			update yeah_2011.respuestas set res_respuesta=new.h30_tv, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='h30_tv';
	    end if;
				if new.h30_hf is distinct from old.h30_hf then
			update yeah_2011.respuestas set res_respuesta=new.h30_hf, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='h30_hf';
	    end if;
				if new.h30_la is distinct from old.h30_la then
			update yeah_2011.respuestas set res_respuesta=new.h30_la, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='h30_la';
	    end if;
				if new.h30_vi is distinct from old.h30_vi then
			update yeah_2011.respuestas set res_respuesta=new.h30_vi, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='h30_vi';
	    end if;
				if new.h30_ac is distinct from old.h30_ac then
			update yeah_2011.respuestas set res_respuesta=new.h30_ac, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='h30_ac';
	    end if;
				if new.h30_dvd is distinct from old.h30_dvd then
			update yeah_2011.respuestas set res_respuesta=new.h30_dvd, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='h30_dvd';
	    end if;
				if new.h30_mo is distinct from old.h30_mo then
			update yeah_2011.respuestas set res_respuesta=new.h30_mo, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='h30_mo';
	    end if;
				if new.h30_pc is distinct from old.h30_pc then
			update yeah_2011.respuestas set res_respuesta=new.h30_pc, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='h30_pc';
	    end if;
				if new.h30_in is distinct from old.h30_in then
			update yeah_2011.respuestas set res_respuesta=new.h30_in, res_usu_ult_mod=new.usuario, res_fec_ult_mod=current_timestamp WHERE res_encuesta=new.nenc AND res_hogar=new.nhogar and res_miembro=0 and res_ex_miembro=0 and res_relacion=0 and res_var='h30_in';
	    end if;
		
  RETURN new;
END
$$;


ALTER FUNCTION yeah_2011.res_eah11_viv_s1a1_upd() OWNER TO yeahowner;

--
-- Name: res_his_del(); Type: FUNCTION; Schema: yeah_2011; Owner: yeahowner
--

CREATE FUNCTION res_his_del() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN  	INSERT INTO his.his_respuestas(            res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion,             res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod,             res_fec_ult_mod, res_estado)		VALUES (            old.res_encuesta, old.res_hogar, old.res_miembro, old.res_ex_miembro, old.res_relacion,             old.res_var, old.res_for, old.res_mat, old.res_tab, '!BORRADO!', old.res_usu_ult_mod,             old.res_fec_ult_mod, '!BORRADO!');    return old;END;$$;


ALTER FUNCTION yeah_2011.res_his_del() OWNER TO yeahowner;

--
-- Name: res_his_ins(); Type: FUNCTION; Schema: yeah_2011; Owner: yeahowner
--

CREATE FUNCTION res_his_ins() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN  IF new.res_respuesta is not null then	INSERT INTO his.his_respuestas(            res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion,             res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod,             res_fec_ult_mod, res_estado)		VALUES (            new.res_encuesta, new.res_hogar, new.res_miembro, new.res_ex_miembro, new.res_relacion,             new.res_var, new.res_for, new.res_mat, new.res_tab, new.res_respuesta, new.res_usu_ult_mod,             new.res_fec_ult_mod, new.res_estado);  end if;  return new;END;$$;


ALTER FUNCTION yeah_2011.res_his_ins() OWNER TO yeahowner;

--
-- Name: res_his_upd(); Type: FUNCTION; Schema: yeah_2011; Owner: yeahowner
--

CREATE FUNCTION res_his_upd() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN  IF new.res_respuesta is distinct from old.res_respuesta then	INSERT INTO his.his_respuestas(            res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion,             res_var, res_for, res_mat, res_tab, res_respuesta, res_usu_ult_mod,             res_fec_ult_mod, res_estado)		VALUES (            new.res_encuesta, new.res_hogar, new.res_miembro, new.res_ex_miembro, new.res_relacion,             new.res_var, new.res_for, new.res_mat, new.res_tab, new.res_respuesta, new.res_usu_ult_mod,             new.res_fec_ult_mod, new.res_estado);  elsif new.res_estado is distinct from old.res_estado then    UPDATE his.his_respuestas set res_estado=new.res_estado	  WHERE res_encuesta = new.res_encuesta	    AND res_hogar = new.res_hogar		AND res_miembro = new.res_miembro		AND res_ex_miembro = new.res_ex_miembro		AND res_relacion = new.res_relacion		AND res_var = new.res_var		AND res_for = new.res_for		AND res_mat = new.res_mat		AND res_tab = new.res_tab		AND res_respuesta = new.res_respuesta		AND res_usu_ult_mod = new.res_usu_ult_mod		AND res_fec_ult_mod = new.res_fec_ult_mod;  end if;  return new;END;$$;


ALTER FUNCTION yeah_2011.res_his_upd() OWNER TO yeahowner;

--
-- Name: rol_como_analista(text); Type: FUNCTION; Schema: yeah_2011; Owner: yeahowner
--

CREATE FUNCTION rol_como_analista(p_usu_usu text) RETURNS tupla_rol_estado
    LANGUAGE plpgsql
    AS $$declare  v_rol varchar(30);  v_rta tupla_rol_estado;begin  SELECT usu_rol INTO v_rol    FROM usuarios     WHERE usu_usu=p_usu_usu;  SELECT rol,         CASE rol WHEN 'procesamiento' THEN 26                  WHEN 'ana_campo'     THEN 25                  WHEN 'ana_ing'       THEN 24                  WHEN 'ingresador'    THEN 23                  ELSE 0 END    INTO v_rta.rol, v_rta.estado    FROM (SELECT rolrol_delegado as rol FROM rol_rol WHERE rolrol_principal=v_rol UNION SELECT v_rol) x    ORDER BY 2 DESC    LIMIT 1;  return v_rta;end;$$;


ALTER FUNCTION yeah_2011.rol_como_analista(p_usu_usu text) OWNER TO yeahowner;

--
-- Name: tem_dominio_trg(); Type: FUNCTION; Schema: yeah_2011; Owner: yeahowner
--

CREATE FUNCTION tem_dominio_trg() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  new.dominio=case when new.lote::integer>=5000 or new.replica='7' then 'v' 
                   when new.lote::integer>=900 or new.replica='8' then 'i' 
                   else 'c' end;
  RETURN new;
END
$$;


ALTER FUNCTION yeah_2011.tem_dominio_trg() OWNER TO yeahowner;

--
-- Name: tem_estado_trg(); Type: FUNCTION; Schema: yeah_2011; Owner: yeahowner
--

CREATE FUNCTION tem_estado_trg() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE  v_estado_nuevo decimal:=0;  v_error_estado text:='';  v_poseedor yeah_2011.tem11.poseedor%type;  v_rol_poseedor yeah_2011.tem11.rol_poseedor%type;  v_comuna_cod_recu    yeah_2011.comunas.comuna_cod_recu%type;  v_comuna_cod_recep   yeah_2011.comunas.comuna_cod_recep%type;  v_comuna_cod_sup     yeah_2011.comunas.comuna_cod_sup%type;  v_comuna_cod_subcoor yeah_2011.comunas.comuna_cod_subcoor%type;  v_bolsa_cerrada integer;  v_ultima_bolsa integer;--  v_supervisable boolean:=false;BEGIN  if new.fin_anal_proc=4 then    new.fin_anal_proc=NULL;    new.fin_anal_campo=NULL;    new.fin_anal_ing=7;  end if;  IF new.dominio='c' THEN    SELECT comuna_cod_recu  , comuna_cod_recep  , comuna_cod_sup  , comuna_cod_subcoor      INTO v_comuna_cod_recu, v_comuna_cod_recep, v_comuna_cod_sup, v_comuna_cod_subcoor      FROM comunas      WHERE comuna_comuna=new.comuna;  END IF;  if new.cod_enc is not null then    v_estado_nuevo:=1;    v_poseedor:=new.cod_enc;    v_rol_poseedor:='encuestador';  end if;  if new.rea::integer in (1,4) or new.rea::integer in (0,2,3) and new.norea_enc is not null then    if v_estado_nuevo is distinct from 1 then      RAISE EXCEPTION 'Falta el codigo de encuestador en encuesta %',new.encues;    else      if (new.norea_enc>='70' or new.norea_enc='10') and new.replica::integer<>8 then        v_estado_nuevo:=2;        if new.cod_recu is null and old.cod_recu is null then           new.cod_recu:=v_comuna_cod_recu;        end if;        v_poseedor:=new.cod_recu;        v_rol_poseedor:='recuperador';      elsif coalesce(new.hog::integer,0)>1 and new.fin_sup is distinct from 4	     or new.norea_enc<>'61' and new.norea_enc<'70' 		 or new.sup_campo::integer>0 and new.rea::integer<>4       then        v_estado_nuevo:=5;        if new.cod_sup is null and old.cod_sup is null then           new.cod_sup:=v_comuna_cod_sup;        end if;        if new.sup_tel::integer>0 and coalesce(new.hog::integer,0)>1 then            RAISE EXCEPTION 'La encuesta % tiene mas de 1 hogar por lo tanto va a sup de campo, no telefonica.',new.encues;        end if;        v_poseedor:=new.cod_sup;        v_rol_poseedor:='supervisor';      elsif new.sup_tel::integer>0 and new.rea::integer<>4 then        v_estado_nuevo:=4;        v_poseedor:=v_comuna_cod_recep;        v_rol_poseedor:='recepcionista';       else        v_estado_nuevo:=9;        v_poseedor:=v_comuna_cod_subcoor;        v_rol_poseedor:='subcoor_campo';       end if;    end if;  end if;    if v_estado_nuevo in (4,5,9) then    if new.sup_tel is null and new.sup_campo is null then      if new.bolsa is null then        v_estado_nuevo := 1.5;      end if;    end if;  end if;    if new.cod_recu is not null then    if v_estado_nuevo is distinct from 2 then      RAISE EXCEPTION 'La encuesta % no estaba destinada para recuperacion',new.encues;    else      v_estado_nuevo:=3;      v_poseedor:=new.cod_recu;      v_rol_poseedor:='recuperador';    end if;  end if;  if new.rea::integer=3 or new.rea::integer=2 and new.norea_recu is not null then    if v_estado_nuevo is distinct from 3 then      RAISE EXCEPTION 'La encuesta % no tiene codigo de recuperador',new.encues;    else      --if new.rea::integer=3 and new.sup_recu_campo::integer>0 then      if new.sup_recu_campo::integer>0 then -- pasa a 7 solo x la marca, para cualquier rea        v_estado_nuevo:=7;        if new.cod_sup is null and old.cod_sup is null then           new.cod_sup:=v_comuna_cod_sup;        end if;        v_poseedor:=new.cod_sup;        v_rol_poseedor:='subcoor_campo';      else        if new.sup_recu_campo=0 then            v_estado_nuevo:=9;        else          if new.bolsa is null then            v_estado_nuevo:=3.5;          end if;        end if;        v_poseedor:=v_comuna_cod_subcoor;        v_rol_poseedor:='subcoor_campo';       end if;    end if;  end if;  if new.cod_sup is not null then    if v_estado_nuevo not in (5,7) then      RAISE EXCEPTION 'La encuesta % no esperaba un supervisor',new.encues;    else      if v_estado_nuevo=5 then        v_estado_nuevo:=6;      else        v_estado_nuevo:=8;      end if;      v_poseedor:=new.cod_sup;      v_rol_poseedor:='supervisor';     end if;  end if;  if v_poseedor is null then    v_rol_poseedor:='subcoor_campo';    v_poseedor:=v_comuna_cod_subcoor;  end if;  if new.fin_sup is not null then    if v_estado_nuevo not in (4,6,8) and new.fin_sup<>4 then      RAISE EXCEPTION 'La encuesta % no esperaba fin de supervision porque no tiene codigo de supervisor',new.encues;    end if;    v_estado_nuevo:=9;    v_poseedor:=v_comuna_cod_subcoor;    v_rol_poseedor:='subcoor_campo';   end if;  if v_estado_nuevo=9 and new.rea in (0,2) then    v_estado_nuevo:=10;  end if;  if new.bolsa is not null then    if v_estado_nuevo is distinct from 9 then      RAISE EXCEPTION 'La encuesta % no puede embolsarse porque todavia esta en estado %, debe estar en estado 9',new.encues,v_estado_nuevo;    end if;	if new.bolsa>0 and new.rea::integer not in (1,3) then      RAISE EXCEPTION 'La encuesta % no puede embolsarse en la bolsa % porque su rea es %',new.encues,new.bolsa,new.rea;	end if;	if new.bolsa<0 and new.rea::integer in (1,3) then      RAISE EXCEPTION 'La encuesta % no puede embolsarse en la bolsa % porque su rea es %',new.encues,new.bolsa,new.rea;	end if;	if old.bolsa is null then          if new.bolsa=0 then            SELECT min(abs(bolsa_bolsa)) INTO v_ultima_bolsa -- vale -1 si está abierta y null si no existe              FROM bolsas               WHERE bolsa_cerrada is null                AND (bolsa_rea=0 AND new.rea::integer in (0,2) OR bolsa_rea=1 AND new.rea::integer in (1,3));            if new.rea::integer in (0,2) then              v_ultima_bolsa=-v_ultima_bolsa;            end if;            new.bolsa=v_ultima_bolsa;          end if;	  SELECT coalesce(bolsa_cerrada,-1) INTO v_bolsa_cerrada -- vale -1 si está abierta y null si no existe	    FROM bolsas WHERE bolsa_bolsa=new.bolsa;	  if v_bolsa_cerrada>0 then            RAISE EXCEPTION 'La encuesta % no puede embolsarse en la bolsa % porque está cerrada (%)',new.encues,new.bolsa,v_bolsa_cerrada;	  end if;	  if v_bolsa_cerrada is null then            RAISE EXCEPTION 'La encuesta % no puede embolsarse en la bolsa % porque esa bolsa no existe',new.encues,new.bolsa;	  end if;	end if;    v_estado_nuevo:=20;  elsif new.bolsa is null and old.bolsa is not null then -- verifico que se pueda sacar de la bolsa	SELECT coalesce(bolsa_cerrada,-1) INTO v_bolsa_cerrada -- vale -1 si está abierta y null si no existe	  FROM bolsas WHERE bolsa_bolsa=old.bolsa;	if v_bolsa_cerrada>0 then  			RAISE EXCEPTION 'La encuesta % no puede sacarse la bolsa % porque está cerrada',new.encues,old.bolsa;	end if;  end if;  if new.bolsa_ok is not null then    if v_estado_nuevo is distinct from 20 then      RAISE EXCEPTION 'La encuesta % no puede verificarse en bolsa_ok porque todavia esta en estado %, debe estar en estado 20',new.encues,v_estado_nuevo;	else	  v_estado_nuevo:=21;    end if;  end if;  if new.cod_ing is not null then    if v_estado_nuevo is distinct from 21 then      RAISE EXCEPTION 'La encuesta % no puede asignarse al ingresador % porque todavia esta en estado %, debe estar en estado 21',new.encues,new.cod_ing,v_estado_nuevo;	else	  v_estado_nuevo:=22;    end if;  end if;  if new.ingresando is not null then    if v_estado_nuevo is distinct from 22 then      RAISE EXCEPTION 'La encuesta % no puede comenzar a ingresarse porque todavia esta en estado %, debe estar en estado 22',new.encues,v_estado_nuevo;	else	  v_estado_nuevo:=23;    end if;  end if;  if new.fin_ingreso is not null then    if v_estado_nuevo is distinct from 23 then        RAISE EXCEPTION 'La encuesta % no puede finalizar de ingresarse porque todavia esta en estado %, debe estar en estado 23',new.encues,v_estado_nuevo;    else        if new.fin_ingreso=1 or new.fin_ingreso=2 then             v_estado_nuevo:=29;        end if;        if new.fin_ingreso=3 then             v_estado_nuevo:=24;        end if;    end if;  end if;  if new.fin_anal_ing is not null then    if v_estado_nuevo is distinct from 24 then        RAISE EXCEPTION 'La encuesta % no puede finalizar el analisis de ingreso porque todavia esta en estado %, debe estar en estado 24.',new.encues,v_estado_nuevo;    else        if new.fin_anal_ing=1 or new.fin_anal_ing=2 then            v_estado_nuevo:=29;        end if;        if new.fin_anal_ing=4 then            v_estado_nuevo:=25;        end if;        if new.fin_anal_ing=5 then            v_estado_nuevo:=26;        end if;        if new.fin_anal_ing=7 then            v_estado_nuevo:=25;        end if;    end if;  end if;  if new.fin_anal_campo is not null then    if v_estado_nuevo is distinct from 25 then        RAISE EXCEPTION 'La encuesta % no puede finalizar el analisis de campo porque todavia esta en estado %, debe astar en estado 25.',new.encues,v_estado_nuevo;    else        if new.fin_anal_campo=1 or new.fin_anal_campo=2 then            v_estado_nuevo:=29;        end if;        if new.fin_anal_campo=5 then            v_estado_nuevo:=26;        end if;    end if;  end if;  if new.fin_anal_proc is not null then    if v_estado_nuevo not in (23,24,26) then         RAISE EXCEPTION 'La encuesta % no puede finalizar el analisis de procesamiento porque esta en estado %, debe etar en estado 26.',new.encues,v_estado_nuevo;    else        if new.fin_anal_proc=1 or new.fin_anal_proc=2 or new.fin_anal_proc=6 then            v_estado_nuevo:=29;        end if;        if new.fin_anal_proc=4 then            v_estado_nuevo:=25;        end if;    end if;  end if;  -----------------------------------------------------------------  if v_estado_nuevo is distinct from new.estado then    new.estado:=v_estado_nuevo;    INSERT INTO modificaciones(mod_tabla, mod_operacion, mod_pk, mod_campo, mod_actual, mod_anterior, mod_cuando, mod_autor, mod_esquema)      VALUES (TG_TABLE_NAME, SUBSTR(TG_OP,1,1), new.encues, 'estado'      , new.estado      , old.estado      , current_timestamp, new.usu_ult_mod, TG_TABLE_SCHEMA);  end if;  if v_poseedor is distinct from new.poseedor then    new.poseedor:=v_poseedor;    INSERT INTO modificaciones(mod_tabla, mod_operacion, mod_pk, mod_campo, mod_actual, mod_anterior, mod_cuando, mod_autor, mod_esquema)      VALUES (TG_TABLE_NAME, SUBSTR(TG_OP,1,1), new.encues, 'poseedor'    , new.poseedor    , old.poseedor    , current_timestamp, new.usu_ult_mod, TG_TABLE_SCHEMA);  end if;  if v_rol_poseedor is distinct from new.rol_poseedor then    new.rol_poseedor:=v_rol_poseedor;    INSERT INTO modificaciones(mod_tabla, mod_operacion, mod_pk, mod_campo, mod_actual, mod_anterior, mod_cuando, mod_autor, mod_esquema)      VALUES (TG_TABLE_NAME, SUBSTR(TG_OP,1,1), new.encues, 'rol_poseedor', new.rol_poseedor, old.rol_poseedor, current_timestamp, new.usu_ult_mod, TG_TABLE_SCHEMA);  end if;  return new;END;$$;


ALTER FUNCTION yeah_2011.tem_estado_trg() OWNER TO yeahowner;

SET search_path = his, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: his_inconsistencias; Type: TABLE; Schema: his; Owner: yeahowner; Tablespace: 
--

CREATE TABLE his_inconsistencias (
    inc_con character varying(30),
    inc_nenc integer,
    inc_nhogar integer,
    inc_miembro_ex_0 integer,
    inc_relacion_0 integer,
    inc_variables_y_valores text,
    inc_justificacion character varying(140),
    inc_autor_justificacion character varying(30),
    inc_corrida timestamp without time zone,
    inc_estado_tem integer
);


ALTER TABLE his.his_inconsistencias OWNER TO yeahowner;

--
-- Name: his_respuestas; Type: TABLE; Schema: his; Owner: yeahowner; Tablespace: 
--

CREATE TABLE his_respuestas (
    res_encuesta integer NOT NULL,
    res_hogar integer NOT NULL,
    res_miembro integer NOT NULL,
    res_ex_miembro integer NOT NULL,
    res_relacion integer NOT NULL,
    res_var character varying(30) NOT NULL,
    res_for character varying(30),
    res_mat character varying(30),
    res_tab character varying(100),
    res_respuesta character varying(1000),
    res_usu_ult_mod character varying(30),
    res_fec_ult_mod timestamp without time zone DEFAULT now(),
    res_estado character varying(30)
);


ALTER TABLE his.his_respuestas OWNER TO yeahowner;

--
-- Name: modificaciones; Type: TABLE; Schema: his; Owner: yeahowner; Tablespace: 
--

CREATE TABLE modificaciones (
    mod_mod integer NOT NULL,
    mod_tabla character varying(50) NOT NULL,
    mod_operacion character varying(1) NOT NULL,
    mod_pk character varying(500) NOT NULL,
    mod_campo character varying(500) NOT NULL,
    mod_actual text,
    mod_anterior text,
    mod_cuando timestamp without time zone DEFAULT now(),
    mod_autor character varying(30) NOT NULL,
    mod_esquema character varying(50)
);


ALTER TABLE his.modificaciones OWNER TO yeahowner;

--
-- Name: modificaciones_mod_mod_seq; Type: SEQUENCE; Schema: his; Owner: yeahowner
--

CREATE SEQUENCE modificaciones_mod_mod_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE his.modificaciones_mod_mod_seq OWNER TO yeahowner;

--
-- Name: modificaciones_mod_mod_seq; Type: SEQUENCE OWNED BY; Schema: his; Owner: yeahowner
--

ALTER SEQUENCE modificaciones_mod_mod_seq OWNED BY modificaciones.mod_mod;


SET search_path = test, pg_catalog;

--
-- Name: t_conbool; Type: TABLE; Schema: test; Owner: yeahowner; Tablespace: 
--

CREATE TABLE t_conbool (
    con_bool_elbool boolean
);


ALTER TABLE test.t_conbool OWNER TO yeahowner;

--
-- Name: t_condpd; Type: TABLE; Schema: test; Owner: yeahowner; Tablespace: 
--

CREATE TABLE t_condpd (
    conn_entero integer DEFAULT 1,
    conn_bool boolean DEFAULT false,
    conn_texto character varying(20) DEFAULT 'Don''t yeah'::character varying,
    conn_texto2 character varying(20)
);


ALTER TABLE test.t_condpd OWNER TO yeahowner;

--
-- Name: t_connum; Type: TABLE; Schema: test; Owner: yeahowner; Tablespace: 
--

CREATE TABLE t_connum (
    conn_entero integer,
    conn_doble double precision DEFAULT 999,
    conn_fijo numeric DEFAULT (777)::numeric,
    conn_texto character varying(20) DEFAULT '666'::character varying
);


ALTER TABLE test.t_connum OWNER TO yeahowner;

--
-- Name: t_conpk2; Type: TABLE; Schema: test; Owner: yeahowner; Tablespace: 
--

CREATE TABLE t_conpk2 (
    conn_entero integer NOT NULL,
    conn_texto character varying(20) NOT NULL,
    conn_texto2 character varying(20)
);


ALTER TABLE test.t_conpk2 OWNER TO yeahowner;

--
-- Name: t_encues; Type: TABLE; Schema: test; Owner: yeahowner; Tablespace: 
--

CREATE TABLE t_encues (
    enc_enc character varying(10) NOT NULL,
    enc_nombre character varying(30)
);


ALTER TABLE test.t_encues OWNER TO yeahowner;

--
-- Name: t_formus; Type: TABLE; Schema: test; Owner: yeahowner; Tablespace: 
--

CREATE TABLE t_formus (
    for_enc character varying(10) NOT NULL,
    for_for character varying(10) NOT NULL,
    for_nombre character varying(30),
    for_un_bool boolean DEFAULT false
);


ALTER TABLE test.t_formus OWNER TO yeahowner;

--
-- Name: t_opcios; Type: TABLE; Schema: test; Owner: yeahowner; Tablespace: 
--

CREATE TABLE t_opcios (
    opc_enc character varying(10) NOT NULL,
    opc_for character varying(10) NOT NULL,
    opc_pre character varying(10) NOT NULL,
    opc_opc character varying(10) NOT NULL,
    opc_texto character varying(30),
    opc_pre_salta character varying(10)
);


ALTER TABLE test.t_opcios OWNER TO yeahowner;

--
-- Name: t_pregus; Type: TABLE; Schema: test; Owner: yeahowner; Tablespace: 
--

CREATE TABLE t_pregus (
    pre_enc character varying(10) NOT NULL,
    pre_for character varying(10) NOT NULL,
    pre_pre character varying(10) NOT NULL,
    pre_texto character varying(30)
);


ALTER TABLE test.t_pregus OWNER TO yeahowner;

--
-- Name: t_sinpk; Type: TABLE; Schema: test; Owner: yeahowner; Tablespace: 
--

CREATE TABLE t_sinpk (
    conn_entero integer,
    conn_texto character varying(20),
    conn_texto2 character varying(20)
);


ALTER TABLE test.t_sinpk OWNER TO yeahowner;

--
-- Name: t_vacia; Type: TABLE; Schema: test; Owner: yeahowner; Tablespace: 
--

CREATE TABLE t_vacia (
    enc_enc character varying(10) NOT NULL,
    enc_nombre character varying(30)
);


ALTER TABLE test.t_vacia OWNER TO yeahowner;

--
-- Name: tablas; Type: TABLE; Schema: test; Owner: yeahowner; Tablespace: 
--

CREATE TABLE tablas (
    tabla character varying(50) NOT NULL,
    prefijo_campos character varying(50)
);


ALTER TABLE test.tablas OWNER TO yeahowner;

SET search_path = yeah_2009, pg_catalog;

--
-- Name: --Pautas; Type: TABLE; Schema: yeah_2009; Owner: yeahowner; Tablespace: 
--

CREATE TABLE "--Pautas" (
    id_con integer NOT NULL,
    orden integer,
    condicion_con character varying(250),
    si_con text,
    pauta_con text,
    error_con character varying(15),
    activa_con character varying(10),
    basica character varying(10),
    general character varying(10),
    descripcion character varying(100),
    obs text,
    vista character varying(15),
    modulo character varying(50),
    info character varying(100),
    forzar character varying(10)
);


ALTER TABLE yeah_2009."--Pautas" OWNER TO yeahowner;

--
-- Name: _pautas; Type: TABLE; Schema: yeah_2009; Owner: yeahowner; Tablespace: 
--

CREATE TABLE _pautas (
    id_con integer NOT NULL,
    condicion_con text,
    si_con text,
    pauta_con text,
    error_con text,
    activa_con text,
    descripcion text,
    obs text,
    vista text,
    modulo text
);


ALTER TABLE yeah_2009._pautas OWNER TO yeahowner;

--
-- Name: borradosi1; Type: TABLE; Schema: yeah_2009; Owner: yeahowner; Tablespace: 
--

CREATE TABLE borradosi1 (
    id integer NOT NULL,
    comuna smallint,
    rep smallint,
    up integer,
    nenc integer,
    nhogar smallint NOT NULL,
    miembro smallint NOT NULL,
    nombre character varying(50),
    edad integer,
    sexo numeric(3,0),
    respond numeric(3,0),
    entrev numeric(3,0),
    t1 numeric(3,0),
    t2 numeric(3,0),
    t3 numeric(3,0),
    t4 numeric(3,0),
    t5 numeric(3,0),
    t6 numeric(3,0),
    t7 numeric(3,0),
    t8 numeric(3,0),
    t8_otro character varying(50),
    t9 numeric(3,0),
    t10 numeric(3,0),
    t11 numeric(3,0),
    t11_otro character varying(50),
    t12 numeric(3,0),
    t13 numeric(3,0),
    t14 numeric(3,0),
    t15 numeric(3,0),
    t16 numeric(3,0),
    t17 numeric(3,0),
    t18 numeric(3,0),
    t19_anio integer,
    t20 numeric(3,0),
    t21 numeric(3,0),
    t22 numeric(3,0),
    t23 character varying(200),
    t23_cod integer,
    t24 character varying(200),
    t24_cod integer,
    t25 character varying(200),
    t26 character varying(100),
    t27 numeric(3,0),
    t28 numeric(3,0),
    t29 numeric(3,0),
    t29a numeric(3,0),
    t30 numeric(3,0),
    t31_d numeric(3,0),
    t31_l numeric(3,0),
    t31_ma numeric(3,0),
    t31_mi numeric(3,0),
    t31_j numeric(3,0),
    t31_v numeric(3,0),
    t31_s numeric(3,0),
    t32_d numeric(3,0),
    t32_l numeric(3,0),
    t32_ma numeric(3,0),
    t32_mi numeric(3,0),
    t32_j numeric(3,0),
    t32_v numeric(3,0),
    t32_s numeric(3,0),
    t33 numeric(3,0),
    t34 numeric(3,0),
    t35 numeric(3,0),
    t36_1 numeric(3,0),
    t36_2 numeric(3,0),
    t36_3 numeric(3,0),
    t36_4 numeric(3,0),
    t36_5 numeric(3,0),
    t36_6 numeric(3,0),
    t36_7 numeric(3,0),
    t36_7_otro character varying(50),
    t36_8 numeric(3,0),
    t36_8_otro character varying(50),
    t36_99 numeric(3,0),
    t36_a numeric(3,0),
    t37 character varying(100),
    t37_cod smallint,
    t38 numeric(3,0),
    t39 numeric(3,0),
    t39_barrio character varying(50),
    t39_otro character varying(50),
    t39_bis numeric(3,0),
    t39_bis_cuantos integer,
    t39_bis1 integer,
    t40 numeric(3,0),
    t41 character varying(200),
    t41_cod smallint,
    t42 character varying(200),
    t43 character varying(100),
    t44 numeric(3,0),
    t45 numeric(3,0),
    t46 numeric(3,0),
    t47 numeric(3,0),
    t48 numeric(3,0),
    t49 numeric(3,0),
    t50a numeric(3,0),
    t50b numeric(3,0),
    t50c numeric(3,0),
    t50d numeric(3,0),
    t50e numeric(3,0),
    t50f numeric(3,0),
    t51 numeric(3,0),
    t52a numeric(3,0),
    t52b numeric(3,0),
    t52c numeric(3,0),
    t53_ing integer,
    t53_mensual numeric(3,0),
    t53_nopago numeric(3,0),
    t53c_anios numeric(3,0),
    t53c_meses numeric(3,0),
    t54 numeric(3,0),
    t54b integer,
    i1 numeric(3,0),
    i2_tot numeric(3,0),
    i2_totx integer,
    i2_tic numeric(3,0),
    i2_ticx integer,
    i3_1 numeric(3,0),
    i3_1x integer,
    i3_2 numeric(3,0),
    i3_2x integer,
    i3_3 numeric(3,0),
    i3_3x integer,
    i3_4 numeric(3,0),
    i3_4x integer,
    i3_5 numeric(3,0),
    i3_5x integer,
    i3_6 numeric(3,0),
    i3_6x integer,
    i3_7 numeric(3,0),
    i3_7x integer,
    i3_8 numeric(3,0),
    i3_8x integer,
    i3_9 numeric(3,0),
    i3_9x integer,
    i3_11 integer,
    i3_11x integer,
    i3_10 numeric(3,0),
    i3_10x integer,
    i3_10_otro character varying(50),
    i3_tot integer,
    i3_99 numeric(3,0),
    e1 numeric(3,0),
    e2 numeric(3,0),
    e3 numeric(3,0),
    e3a numeric(3,0),
    e4 numeric(3,0),
    e6 numeric(3,0),
    e7 numeric(3,0),
    e8 numeric(3,0),
    e9_edad integer,
    e9_anio integer,
    e10 numeric(3,0),
    e12 numeric(3,0),
    e13 numeric(3,0),
    e14 numeric(3,0),
    e11_1 numeric(3,0),
    e11_2 numeric(3,0),
    e11_3 numeric(3,0),
    e11_4 numeric(3,0),
    e11_5 numeric(3,0),
    e11_6 numeric(3,0),
    e11_7 numeric(3,0),
    e11_8 numeric(3,0),
    e11_9 numeric(3,0),
    e11_10 numeric(3,0),
    e11_11 numeric(3,0),
    e11_12 numeric(3,0),
    e11_13 numeric(3,0),
    e11_14 numeric(3,0),
    e11_15 numeric(3,0),
    e11_15_otro character varying(50),
    e11_99 numeric(3,0),
    e11a numeric(3,0),
    e15_1 numeric(3,0),
    e15_2 numeric(3,0),
    e15_3 numeric(3,0),
    e15_4 numeric(3,0),
    e15_5 numeric(3,0),
    e15_5_otro character varying(50),
    e15_6 numeric(3,0),
    e15_9 numeric(3,0),
    e15a numeric(3,0),
    e16 numeric(3,0),
    e16_esp character varying(50),
    e16_bis integer,
    m1 numeric(3,0),
    m1_esp character varying(100),
    m1_anio smallint,
    m1a numeric(3,0),
    m1a_esp character varying(50),
    m3 integer,
    m3_anio smallint,
    m4 numeric(3,0),
    m4_esp character varying(100),
    m5 numeric(3,0),
    sn1_1 numeric(3,0),
    sn1_2 numeric(3,0),
    sn1_3 numeric(3,0),
    sn1_4 integer,
    sn1_5 integer,
    sn1_6 numeric(3,0),
    sn1_99 numeric(3,0),
    sn1_1_esp character varying(40),
    sn1_2_esp character varying(40),
    sn1_3_esp character varying(40),
    sn1_4_esp character varying(40),
    sn1_5_esp character varying(40),
    sn2 numeric(3,0),
    sn2_cant numeric(3,0),
    sn3 numeric(3,0),
    sn4 numeric(3,0),
    sn4_esp character varying(50),
    sn5 numeric(3,0),
    sn5_esp character varying(50),
    sn6 numeric(3,0),
    sn6_cant numeric(3,0),
    sn7 numeric(3,0),
    sn7_esp character varying(50),
    sn8 numeric(3,0),
    sn8_esp character varying(70),
    sn9 numeric(3,0),
    sn10a numeric(3,0),
    sn10b numeric(3,0),
    sn10c numeric(3,0),
    sn10d numeric(3,0),
    sn10e numeric(3,0),
    sn10f numeric(3,0),
    sn10g numeric(3,0),
    sn10h numeric(3,0),
    sn10i numeric(3,0),
    sn10j_esp character varying(50),
    sn10j numeric(3,0),
    sn11 numeric(3,0),
    sn12 numeric(3,0),
    sn12_esp numeric(3,0),
    sn13 integer,
    sn13_otro character varying(40),
    sn14 numeric(3,0),
    sn14_esp character varying(40),
    sn15a numeric(3,0),
    sn15b numeric(3,0),
    sn15c numeric(3,0),
    sn15d numeric(3,0),
    sn15e numeric(3,0),
    sn15f numeric(3,0),
    sn15g numeric(3,0),
    sn15h numeric(3,0),
    sn15i numeric(3,0),
    sn15j numeric(3,0),
    sn15k_esp character varying(40),
    sn15k numeric(3,0),
    sn16 numeric(3,0),
    s28 numeric(3,0),
    s29 numeric(3,0),
    s30 numeric(3,0),
    s31_anio integer,
    s31_mes numeric(3,0),
    e9_r integer,
    sem_hs integer,
    sn integer,
    estado integer,
    obs character varying(200),
    usuario character varying(50),
    log timestamp with time zone
);


ALTER TABLE yeah_2009.borradosi1 OWNER TO yeahowner;

--
-- Name: campo; Type: TABLE; Schema: yeah_2009; Owner: yeahowner; Tablespace: 
--

CREATE TABLE campo (
    id integer NOT NULL,
    tipo character(1) NOT NULL,
    nombre character(150)
);


ALTER TABLE yeah_2009.campo OWNER TO yeahowner;

--
-- Name: cons_10; Type: TABLE; Schema: yeah_2009; Owner: yeahowner; Tablespace: 
--

CREATE TABLE cons_10 (
    id character varying(255),
    orden character varying(255),
    hogar character varying(255),
    miembro character varying(255),
    pauta character varying(255),
    descripcion character varying(255),
    info character varying(255),
    col008 character varying(255)
);


ALTER TABLE yeah_2009.cons_10 OWNER TO yeahowner;

--
-- Name: eah09_ex; Type: TABLE; Schema: yeah_2009; Owner: yeahowner; Tablespace: 
--

CREATE TABLE eah09_ex (
    id integer NOT NULL,
    comuna smallint,
    rep smallint,
    up integer,
    nenc integer,
    nhogar smallint NOT NULL,
    ex_miembro numeric(3,0) NOT NULL,
    sexo numeric(3,0),
    pais_nac numeric(3,0),
    edad smallint,
    niv_educ numeric(3,0),
    anio integer,
    lugar numeric(3,0),
    lugar_desc character varying(50),
    usuario character varying(50),
    log timestamp with time zone
);


ALTER TABLE yeah_2009.eah09_ex OWNER TO yeahowner;

--
-- Name: eah09_fam; Type: TABLE; Schema: yeah_2009; Owner: yeahowner; Tablespace: 
--

CREATE TABLE eah09_fam (
    id integer NOT NULL,
    comuna smallint,
    rep smallint,
    up integer,
    nenc integer,
    nhogar smallint NOT NULL,
    total_m numeric(3,0),
    p0 smallint NOT NULL,
    nombre character varying(30),
    sexo numeric(3,0),
    f_nac character varying(10),
    edad smallint,
    p4 numeric(3,0),
    p5 numeric(3,0),
    p5b numeric(3,0),
    p6_a numeric(3,0),
    p6_b numeric(3,0),
    p7 integer,
    p8 integer NOT NULL,
    p8_esp character varying(50),
    usuario character varying(50),
    log timestamp with time zone,
    edad_30_6 smallint,
    pc character varying(50)
);


ALTER TABLE yeah_2009.eah09_fam OWNER TO yeahowner;

--
-- Name: eah09_i1; Type: TABLE; Schema: yeah_2009; Owner: yeahowner; Tablespace: 
--

CREATE TABLE eah09_i1 (
    id integer NOT NULL,
    comuna smallint,
    rep smallint,
    up integer,
    nenc integer,
    nhogar smallint NOT NULL,
    miembro smallint NOT NULL,
    nombre character varying(50),
    edad integer,
    sexo numeric(3,0),
    respond numeric(3,0),
    entrev numeric(3,0),
    t1 numeric(3,0),
    t2 numeric(3,0),
    t3 numeric(3,0),
    t4 numeric(3,0),
    t5 numeric(3,0),
    t6 numeric(3,0),
    t7 numeric(3,0),
    t8 numeric(3,0),
    t8_otro character varying(50),
    t9 numeric(3,0),
    t10 numeric(3,0),
    t11 numeric(3,0),
    t11_otro character varying(50),
    t12 numeric(3,0),
    t13 numeric(3,0),
    t14 numeric(3,0),
    t15 numeric(3,0),
    t16 numeric(3,0),
    t17 numeric(3,0),
    t18 numeric(3,0),
    t19_anio integer,
    t20 numeric(3,0),
    t21 numeric(3,0),
    t22 numeric(3,0),
    t23 character varying(200),
    t23_cod integer,
    t24 character varying(200),
    t24_cod integer,
    t25 character varying(200),
    t26 character varying(100),
    t27 numeric(3,0),
    t28 numeric(3,0),
    t29 numeric(3,0),
    t29a numeric(3,0),
    t30 numeric(3,0),
    t31_d numeric(3,0),
    t31_l numeric(3,0),
    t31_ma numeric(3,0),
    t31_mi numeric(3,0),
    t31_j numeric(3,0),
    t31_v numeric(3,0),
    t31_s numeric(3,0),
    t32_d numeric(3,0),
    t32_l numeric(3,0),
    t32_ma numeric(3,0),
    t32_mi numeric(3,0),
    t32_j numeric(3,0),
    t32_v numeric(3,0),
    t32_s numeric(3,0),
    t33 numeric(3,0),
    t34 numeric(3,0),
    t35 numeric(3,0),
    t36_1 numeric(3,0),
    t36_2 numeric(3,0),
    t36_3 numeric(3,0),
    t36_4 numeric(3,0),
    t36_5 numeric(3,0),
    t36_6 numeric(3,0),
    t36_7 numeric(3,0),
    t36_7_otro character varying(50),
    t36_8 numeric(3,0),
    t36_8_otro character varying(50),
    t36_99 numeric(3,0),
    t36_a numeric(3,0),
    t37 character varying(100),
    t37_cod smallint,
    t38 numeric(3,0),
    t39 numeric(3,0),
    t39_barrio character varying(50),
    t39_otro character varying(50),
    t39_bis numeric(3,0),
    t39_bis_cuantos integer,
    t39_bis1 integer,
    t40 numeric(3,0),
    t41 character varying(200),
    t41_cod smallint,
    t42 character varying(200),
    t43 character varying(100),
    t44 numeric(3,0),
    t45 numeric(3,0),
    t46 numeric(3,0),
    t47 numeric(3,0),
    t48 numeric(3,0),
    t49 numeric(3,0),
    t50a numeric(3,0),
    t50b numeric(3,0),
    t50c numeric(3,0),
    t50d numeric(3,0),
    t50e numeric(3,0),
    t50f numeric(3,0),
    t51 numeric(3,0),
    t52a numeric(3,0),
    t52b numeric(3,0),
    t52c numeric(3,0),
    t53_ing integer,
    t53_mensual numeric(3,0),
    t53_nopago numeric(3,0),
    t53c_anios numeric(3,0),
    t53c_meses numeric(3,0),
    t54 numeric(3,0),
    t54b integer,
    i1 numeric(3,0),
    i2_tot numeric(3,0),
    i2_totx integer,
    i2_tic numeric(3,0),
    i2_ticx integer,
    i3_1 numeric(3,0),
    i3_1x integer,
    i3_2 numeric(3,0),
    i3_2x integer,
    i3_3 numeric(3,0),
    i3_3x integer,
    i3_4 numeric(3,0),
    i3_4x integer,
    i3_5 numeric(3,0),
    i3_5x integer,
    i3_6 numeric(3,0),
    i3_6x integer,
    i3_7 numeric(3,0),
    i3_7x integer,
    i3_8 numeric(3,0),
    i3_8x integer,
    i3_9 numeric(3,0),
    i3_9x integer,
    i3_11 integer,
    i3_11x integer,
    i3_10 numeric(3,0),
    i3_10x integer,
    i3_10_otro character varying(50),
    i3_tot integer,
    i3_99 numeric(3,0),
    e1 numeric(3,0),
    e2 numeric(3,0),
    e3 numeric(3,0),
    e3a numeric(3,0),
    e4 numeric(3,0),
    e6 numeric(3,0),
    e7 numeric(3,0),
    e8 numeric(3,0),
    e9_edad integer,
    e9_anio integer,
    e10 numeric(3,0),
    e12 numeric(3,0),
    e13 numeric(3,0),
    e14 numeric(3,0),
    e11_1 numeric(3,0),
    e11_2 numeric(3,0),
    e11_3 numeric(3,0),
    e11_4 numeric(3,0),
    e11_5 numeric(3,0),
    e11_6 numeric(3,0),
    e11_7 numeric(3,0),
    e11_8 numeric(3,0),
    e11_9 numeric(3,0),
    e11_10 numeric(3,0),
    e11_11 numeric(3,0),
    e11_12 numeric(3,0),
    e11_13 numeric(3,0),
    e11_14 numeric(3,0),
    e11_15 numeric(3,0),
    e11_15_otro character varying(50),
    e11_99 numeric(3,0),
    e11a numeric(3,0),
    e15_1 numeric(3,0),
    e15_2 numeric(3,0),
    e15_3 numeric(3,0),
    e15_4 numeric(3,0),
    e15_5 numeric(3,0),
    e15_5_otro character varying(50),
    e15_6 numeric(3,0),
    e15_9 numeric(3,0),
    e15a numeric(3,0),
    e16 numeric(3,0),
    e16_esp character varying(50),
    e16_bis integer,
    m1 numeric(3,0),
    m1_esp character varying(100),
    m1_anio smallint,
    m1a numeric(3,0),
    m1a_esp character varying(50),
    m3 integer,
    m3_anio smallint,
    m4 numeric(3,0),
    m4_esp character varying(100),
    m5 numeric(3,0),
    sn1_1 numeric(3,0),
    sn1_2 numeric(3,0),
    sn1_3 numeric(3,0),
    sn1_4 integer,
    sn1_5 integer,
    sn1_6 numeric(3,0),
    sn1_99 numeric(3,0),
    sn1_1_esp character varying(40),
    sn1_2_esp character varying(40),
    sn1_3_esp character varying(40),
    sn1_4_esp character varying(40),
    sn1_5_esp character varying(40),
    sn2 numeric(3,0),
    sn2_cant numeric(3,0),
    sn3 numeric(3,0),
    sn4 numeric(3,0),
    sn4_esp character varying(50),
    sn5 numeric(3,0),
    sn5_esp character varying(50),
    sn6 numeric(3,0),
    sn6_cant numeric(3,0),
    sn7 numeric(3,0),
    sn7_esp character varying(50),
    sn8 numeric(3,0),
    sn8_esp character varying(70),
    sn9 numeric(3,0),
    sn10a numeric(3,0),
    sn10b numeric(3,0),
    sn10c numeric(3,0),
    sn10d numeric(3,0),
    sn10e numeric(3,0),
    sn10f numeric(3,0),
    sn10g numeric(3,0),
    sn10h numeric(3,0),
    sn10i numeric(3,0),
    sn10j_esp character varying(50),
    sn10j numeric(3,0),
    sn11 numeric(3,0),
    sn12 numeric(3,0),
    sn12_esp integer,
    sn13 integer,
    sn13_otro character varying(40),
    sn14 numeric(3,0),
    sn14_esp character varying(40),
    sn15a numeric(3,0),
    sn15b numeric(3,0),
    sn15c numeric(3,0),
    sn15d numeric(3,0),
    sn15e numeric(3,0),
    sn15f numeric(3,0),
    sn15g numeric(3,0),
    sn15h numeric(3,0),
    sn15i numeric(3,0),
    sn15j numeric(3,0),
    sn15k_esp character varying(40),
    sn15k numeric(3,0),
    sn16 numeric(3,0),
    s28 numeric(3,0),
    s29 numeric(3,0),
    s30 numeric(3,0),
    s31_anio integer,
    s31_mes numeric(3,0),
    e9_r integer,
    sem_hs integer,
    sn integer,
    estado integer,
    obs character varying(200),
    usuario character varying(50),
    log timestamp with time zone,
    edad_30_6 smallint,
    e9r smallint
);


ALTER TABLE yeah_2009.eah09_i1 OWNER TO yeahowner;

--
-- Name: eah09_mt; Type: TABLE; Schema: yeah_2009; Owner: yeahowner; Tablespace: 
--

CREATE TABLE eah09_mt (
    id integer NOT NULL,
    comuna smallint,
    rep smallint,
    up integer,
    nenc integer,
    nhogar smallint NOT NULL,
    miembro smallint NOT NULL,
    nombre character varying(50),
    edad numeric(3,0),
    sexo numeric(3,0),
    respond numeric(3,0),
    entrev numeric(3,0),
    nrm numeric(3,0),
    tm_1 numeric(3,0),
    tm_2 integer,
    tm_3 numeric(3,0),
    tm_3_esp character varying(50),
    tm_3_esp_2 character varying(50),
    tm_4 numeric(3,0),
    tm_5 integer,
    tm_6 numeric(3,0),
    tm_6_esp character varying(50),
    tm_6_esp_2 character varying(50),
    tm_7 numeric(3,0),
    tm_8 numeric(3,0),
    tm_9 numeric(3,0),
    tm_11 numeric(3,0),
    tm_10 numeric(3,0),
    tm_12 numeric(3,0),
    tm_13 integer,
    tm_14 numeric(3,0),
    tm_14_esp character varying(50),
    tm_14_esp_2 character varying(50),
    tm_15 numeric(3,0),
    tm_16 integer,
    tm_17 numeric(3,0),
    tm_17_esp character varying(50),
    tm_17_esp_2 character varying(50),
    tm_18 numeric(3,0),
    tm_18_esp character varying(50),
    tm_19 numeric(3,0),
    tm_19_esp character varying(50),
    obs character varying(250),
    usuario character varying(50),
    log timestamp with time zone
);


ALTER TABLE yeah_2009.eah09_mt OWNER TO yeahowner;

--
-- Name: eah09_no_rea; Type: TABLE; Schema: yeah_2009; Owner: yeahowner; Tablespace: 
--

CREATE TABLE eah09_no_rea (
    id integer NOT NULL,
    nhogar smallint NOT NULL,
    comuna smallint,
    rep smallint,
    up integer,
    nenc integer,
    entrea numeric(3,0),
    razon1 numeric(3,0),
    razon2 numeric(3,0),
    razon3 character varying(50),
    id2008 integer,
    nh2008 integer,
    obs character varying(255),
    usuario character varying(15),
    log timestamp with time zone,
    c_enc smallint,
    n_enc character varying(50),
    c_recu smallint,
    n_recu character varying(50),
    c_recep smallint,
    n_recep character varying(50),
    c_sup integer,
    n_sup character varying(50)
);


ALTER TABLE yeah_2009.eah09_no_rea OWNER TO yeahowner;

--
-- Name: eah09_viv_s1a1; Type: TABLE; Schema: yeah_2009; Owner: yeahowner; Tablespace: 
--

CREATE TABLE eah09_viv_s1a1 (
    id integer NOT NULL,
    comuna smallint,
    rep smallint,
    lote integer,
    up integer,
    nenc integer,
    id2008 integer,
    nh2008 integer,
    entrea numeric(3,0),
    razon1 numeric(3,0),
    razon2 numeric(3,0),
    razon3 character varying(50),
    nhogar smallint NOT NULL,
    miembro integer,
    v1 numeric(3,0),
    total_h numeric(3,0),
    total_m numeric(3,0),
    c_enc smallint,
    n_enc character varying(50),
    c_recu smallint,
    n_recu character varying(50),
    c_recep smallint,
    n_recep character varying(50),
    c_sup integer,
    n_sup character varying(50),
    respond smallint,
    nombre character varying(50),
    f_realiz character varying(5),
    form character varying(4),
    v2 numeric(3,0),
    v2_esp character varying(50),
    v4 numeric(3,0),
    v5 numeric(3,0),
    v5_esp character varying(255),
    v6 numeric(3,0),
    v7 numeric(3,0),
    v12 numeric(3,0),
    h1 numeric(3,0),
    h2 numeric(3,0),
    h2_esp character varying(50),
    h3 numeric(3,0),
    h4 numeric(3,0),
    h4_tipot numeric(3,0),
    h4_tel character varying(20),
    h20_1 numeric(3,0),
    h20_2 numeric(3,0),
    h20_4 numeric(3,0),
    h20_5 numeric(3,0),
    h20_6 numeric(3,0),
    h20_7 numeric(3,0),
    h20_8 numeric(3,0),
    h20_9 numeric(3,0),
    h20_10 numeric(3,0),
    h20_15 numeric(3,0),
    h20_11 numeric(3,0),
    h20_12 numeric(3,0),
    h20_13 numeric(3,0),
    h20_16 numeric(3,0),
    h20_14 numeric(3,0),
    h20_esp character varying(50),
    h20_99 numeric(3,0),
    x5 numeric(3,0),
    x5_tot numeric(3,0),
    h30_tv numeric(3,0),
    h30_hf numeric(3,0),
    h30_la numeric(3,0),
    h30_vi numeric(3,0),
    h30_ac numeric(3,0),
    h30_dvd numeric(3,0),
    h30_mo numeric(3,0),
    h30_pc numeric(3,0),
    h30_in numeric(3,0),
    g1 numeric(3,0),
    g2_1 numeric(3,0),
    g2_2 numeric(3,0),
    g2_3 numeric(3,0),
    g2_4 numeric(3,0),
    g2_5 numeric(3,0),
    g2_6 numeric(3,0),
    g2_7 numeric(3,0),
    g2_8 numeric(3,0),
    g2_9 numeric(3,0),
    g3 numeric(3,0),
    g4 numeric(3,0),
    g5 numeric(3,0),
    obs character varying(255),
    usuario character varying(15),
    log timestamp with time zone,
    tipo_h character varying(1),
    encreali integer
);


ALTER TABLE yeah_2009.eah09_viv_s1a1 OWNER TO yeahowner;

--
-- Name: errores_relaciones; Type: TABLE; Schema: yeah_2009; Owner: yeahowner; Tablespace: 
--

CREATE TABLE errores_relaciones (
    id integer,
    nhogar smallint,
    comuna smallint,
    rep smallint,
    up integer,
    nenc integer,
    hogares integer,
    individuales integer,
    viv_pob integer,
    t_comunas character varying(3),
    t_rep character varying(1),
    t_up double precision,
    t_encues character varying(7),
    t_hog character varying(3),
    t_pob character varying(4),
    t_rea character varying(2),
    tem_pob character varying(1),
    tem_com character varying(1),
    tem_rep character varying(1),
    tem_up character varying(1),
    tem_rea character varying(1),
    tem_hog character varying(1)
);


ALTER TABLE yeah_2009.errores_relaciones OWNER TO yeahowner;

--
-- Name: pautas; Type: TABLE; Schema: yeah_2009; Owner: yeahowner; Tablespace: 
--

CREATE TABLE pautas (
    id_con integer NOT NULL,
    orden integer,
    condicion_con character varying(250),
    si_con text,
    pauta_con text,
    error_con character varying(15),
    activa_con character varying(10),
    basica character varying(10),
    general character varying(10),
    descripcion character varying(100),
    obs text,
    vista character varying(15),
    modulo character varying(50),
    info text,
    forzar character varying(10)
);


ALTER TABLE yeah_2009.pautas OWNER TO yeahowner;

--
-- Name: usuarios; Type: TABLE; Schema: yeah_2009; Owner: yeahowner; Tablespace: 
--

CREATE TABLE usuarios (
    idusr numeric(18,0) NOT NULL,
    usuario character(12) NOT NULL,
    pass character(12),
    nombre character(50) NOT NULL,
    cargar character(1),
    editar character(1),
    navegar character(1),
    admin character(1),
    bloqueado character(1)
);


ALTER TABLE yeah_2009.usuarios OWNER TO yeahowner;

--
-- Name: xorden; Type: TABLE; Schema: yeah_2009; Owner: yeahowner; Tablespace: 
--

CREATE TABLE xorden (
    fecha_ultima_modif character varying(255),
    si character varying(255),
    entonces character varying(255),
    pauta_2009 character varying(255),
    basica_y_grales character varying(255),
    orden double precision,
    modulo character varying(255),
    etiqueta_error character varying(255),
    basica character varying(255),
    general character varying(255)
);


ALTER TABLE yeah_2009.xorden OWNER TO yeahowner;

SET search_path = yeah_2010, pg_catalog;

--
-- Name: _Pautas(eah2009); Type: TABLE; Schema: yeah_2010; Owner: yeahowner; Tablespace: 
--

CREATE TABLE "_Pautas(eah2009)" (
    id_con integer NOT NULL,
    orden integer,
    condicion_con character varying(250),
    si_con text,
    pauta_con text,
    error_con character varying(15),
    activa_con character varying(10),
    basica character varying(10),
    general character varying(10),
    descripcion character varying(100),
    obs text,
    vista character varying(15),
    modulo character varying(50),
    info character varying(100),
    forzar character varying(10)
);


ALTER TABLE yeah_2010."_Pautas(eah2009)" OWNER TO yeahowner;

--
-- Name: _Pautas(preLuci); Type: TABLE; Schema: yeah_2010; Owner: yeahowner; Tablespace: 
--

CREATE TABLE "_Pautas(preLuci)" (
    id_con integer,
    orden integer,
    condicion_con character varying(250),
    si_con text,
    pauta_con text,
    error_con character varying(15),
    activa_con character varying(10),
    basica character varying(10),
    general character varying(10),
    descripcion character varying(100),
    obs text,
    vista character varying(15),
    modulo character varying(50),
    info character varying(100),
    forzar character varying(10)
);


ALTER TABLE yeah_2010."_Pautas(preLuci)" OWNER TO yeahowner;

--
-- Name: _eah10_mhl; Type: TABLE; Schema: yeah_2010; Owner: yeahowner; Tablespace: 
--

CREATE TABLE _eah10_mhl (
    id integer NOT NULL,
    comuna smallint,
    rep smallint,
    up integer,
    nenc integer,
    nhogar smallint NOT NULL,
    miembro smallint NOT NULL,
    hh1 numeric(3,0),
    hh2 numeric(3,0),
    hh3 numeric(3,0),
    hh4 numeric(3,0),
    hh5 numeric(3,0),
    hh6 character varying(1),
    sm1 numeric(3,0),
    hi0_05_ene numeric(3,0),
    hi0_05_feb numeric(3,0),
    hi0_05_mar numeric(3,0),
    hi0_05_abr numeric(3,0),
    hi0_05_may numeric(3,0),
    hi0_05_jun numeric(3,0),
    hi0_05_jul numeric(3,0),
    hi0_05_ago numeric(3,0),
    hi0_05_sep numeric(3,0),
    hi0_05_oct numeric(3,0),
    hi0_05_nov numeric(3,0),
    hi0_05_dic numeric(3,0),
    hi0_06_ene numeric(3,0),
    hi0_06_feb numeric(3,0),
    hi0_06_mar numeric(3,0),
    hi0_06_abr numeric(3,0),
    hi0_06_may numeric(3,0),
    hi0_06_jun numeric(3,0),
    hi0_06_jul numeric(3,0),
    hi0_06_ago numeric(3,0),
    hi0_06_sep numeric(3,0),
    hi0_06_oct numeric(3,0),
    hi0_06_nov numeric(3,0),
    hi0_06_dic numeric(3,0),
    hi0_07_ene numeric(3,0),
    hi0_07_feb numeric(3,0),
    hi0_07_mar numeric(3,0),
    hi0_07_abr numeric(3,0),
    hi0_07_may numeric(3,0),
    hi0_07_jun numeric(3,0),
    hi0_07_jul numeric(3,0),
    hi0_07_ago numeric(3,0),
    hi0_07_sep numeric(3,0),
    hi0_07_oct numeric(3,0),
    hi0_07_nov numeric(3,0),
    hi0_07_dic numeric(3,0),
    hi0_08_ene numeric(3,0),
    hi0_08_feb numeric(3,0),
    hi0_08_mar numeric(3,0),
    hi0_08_abr numeric(3,0),
    hi0_08_may numeric(3,0),
    hi0_08_jun numeric(3,0),
    hi0_08_jul numeric(3,0),
    hi0_08_ago numeric(3,0),
    hi0_08_sep numeric(3,0),
    hi0_08_oct numeric(3,0),
    hi0_08_nov numeric(3,0),
    hi0_08_dic numeric(3,0),
    hi0_09_ene numeric(3,0),
    hi0_09_feb numeric(3,0),
    hi0_09_mar numeric(3,0),
    hi0_09_abr numeric(3,0),
    hi0_09_may numeric(3,0),
    hi0_09_jun numeric(3,0),
    hi0_09_jul numeric(3,0),
    hi0_09_ago numeric(3,0),
    hi0_09_sep numeric(3,0),
    hi0_09_oct numeric(3,0),
    hi0_09_nov numeric(3,0),
    hi0_09_dic numeric(3,0),
    hi0_10_ene numeric(3,0),
    hi0_10_feb numeric(3,0),
    hi0_10_mar numeric(3,0),
    hi0_10_abr numeric(3,0),
    hi0_10_may numeric(3,0),
    hi0_10_jun numeric(3,0),
    hi0_10_jul numeric(3,0),
    hi0_10_ago numeric(3,0),
    hi0_10_sep numeric(3,0),
    hi0_10_oct numeric(3,0),
    hi0_10_nov numeric(3,0),
    hi0_10_dic numeric(3,0),
    hi20 integer,
    hi21 integer,
    hi22_nomb character varying(50),
    hi23 character varying(50),
    hi24 character varying(50),
    hi25 numeric(3,0),
    hi26 numeric(3,0),
    hi27 numeric(3,0),
    hi28 numeric(3,0),
    hi29 numeric(3,0),
    hi30 numeric(3,0),
    hi31_1 numeric(3,0),
    hi31_2 numeric(3,0),
    hi31_3 numeric(3,0),
    hi31_4 numeric(3,0),
    hi31_5 numeric(3,0),
    hi31_6 numeric(3,0),
    hi31_6_esp character varying(50),
    hi32 numeric(3,0),
    hi33 numeric(3,0),
    hi34 numeric(3,0),
    hi35_1 numeric(3,0),
    hi35_2 numeric(3,0),
    hi35_3 numeric(3,0),
    hi35_4 numeric(3,0),
    hi35_5 numeric(3,0),
    hi35_6 numeric(3,0),
    hi35_7 numeric(3,0),
    hi35_7_esp character varying(50),
    hi36 numeric(3,0),
    hi37 numeric(3,0),
    hi38 numeric(3,0),
    hi39 numeric(3,0),
    hi40 numeric(3,0),
    hi41 numeric(3,0),
    hi42_esp character varying(50),
    hi42_cod numeric(3,0),
    hi43 numeric(3,0),
    hi44 numeric(3,0),
    hi45 numeric(3,0),
    hi46 numeric(3,0),
    hi47_1 numeric(3,0),
    hi47_2 numeric(3,0),
    hi48 numeric(3,0),
    hi49_1 numeric(3,0),
    hi49_2 numeric(3,0),
    hi49_3 numeric(3,0),
    hi49_3_esp character varying(50),
    usuario character varying(50),
    log timestamp with time zone
);


ALTER TABLE yeah_2010._eah10_mhl OWNER TO yeahowner;

--
-- Name: _eah10_mhlco; Type: TABLE; Schema: yeah_2010; Owner: yeahowner; Tablespace: 
--

CREATE TABLE _eah10_mhlco (
    id integer NOT NULL,
    comuna smallint,
    rep smallint,
    up integer,
    nenc integer,
    nhogar smallint NOT NULL,
    miembro smallint NOT NULL,
    cocup integer NOT NULL,
    hi1_mes integer,
    hi1_anio integer,
    hi2 numeric(3,0),
    hi2_esp character varying(50),
    hi3 numeric(3,0),
    hi4 numeric(3,0),
    hi5 numeric(3,0),
    hi6 numeric(3,0),
    hi7 numeric(3,0),
    hi8 numeric(3,0),
    hi9 numeric(3,0),
    hi10 numeric(3,0),
    hi11_mes integer,
    hi11_anio integer,
    hi12 numeric(3,0),
    hi13 numeric(3,0),
    hi14 numeric(3,0),
    hi4_esp character varying(50),
    hi15 numeric(3,0),
    hi16 numeric(3,0),
    hi17 numeric(3,0),
    hi18 numeric(3,0),
    hi19 numeric(3,0),
    usuario character varying(50),
    log timestamp with time zone
);


ALTER TABLE yeah_2010._eah10_mhlco OWNER TO yeahowner;

--
-- Name: _pautas; Type: TABLE; Schema: yeah_2010; Owner: yeahowner; Tablespace: 
--

CREATE TABLE _pautas (
    id_con integer,
    orden integer,
    condicion_con character varying(250),
    si_con text,
    pauta_con text,
    error_con character varying(15),
    activa_con character varying(10),
    basica character varying(10),
    general character varying(10),
    descripcion character varying(140),
    obs text,
    vista character varying(15),
    modulo character varying(50),
    info character varying(100),
    forzar character varying(10)
);


ALTER TABLE yeah_2010._pautas OWNER TO yeahowner;

--
-- Name: ajmuestra; Type: TABLE; Schema: yeah_2010; Owner: yeahowner; Tablespace: 
--

CREATE TABLE ajmuestra (
    comunas double precision,
    up double precision,
    dpto double precision,
    frac double precision,
    radio double precision,
    mza double precision,
    seg character varying(5),
    nced character varying(6),
    clado double precision,
    ccodigo double precision,
    cnombre character varying(29),
    hn double precision,
    ident_edif character varying(11),
    hp character varying(3),
    hd character varying(6),
    hab character varying(5),
    fuente character varying(8),
    h4 double precision,
    frac_comun double precision,
    radio_comu double precision,
    mza_comuna double precision,
    operacion character varying(9),
    obs character varying(10),
    marco double precision,
    selecciona character varying(13),
    lote integer,
    rea integer,
    hogar integer,
    pob integer,
    fec_recep timestamp with time zone,
    codenc integer,
    norea_hogar integer,
    norea_indiv integer,
    encues integer
);


ALTER TABLE yeah_2010.ajmuestra OWNER TO yeahowner;

--
-- Name: calles_cp; Type: TABLE; Schema: yeah_2010; Owner: yeahowner; Tablespace: 
--

CREATE TABLE calles_cp (
    id double precision,
    detalle character varying(255),
    calle character varying(255),
    desde character varying(255),
    hasta double precision,
    cod_post double precision,
    "CODIGO INDEC" double precision,
    "CODIGO CATASTRO" double precision
);


ALTER TABLE yeah_2010.calles_cp OWNER TO yeahowner;

--
-- Name: campo; Type: TABLE; Schema: yeah_2010; Owner: yeahowner; Tablespace: 
--

CREATE TABLE campo (
    id integer,
    tipo character(1),
    nombre character(150)
);


ALTER TABLE yeah_2010.campo OWNER TO yeahowner;

--
-- Name: eah10_ex; Type: TABLE; Schema: yeah_2010; Owner: yeahowner; Tablespace: 
--

CREATE TABLE eah10_ex (
    id integer NOT NULL,
    comuna smallint,
    rep smallint,
    up integer,
    nenc integer,
    nhogar smallint NOT NULL,
    ex_miembro numeric(3,0) NOT NULL,
    sexo numeric(3,0),
    pais_nac numeric(3,0),
    edad smallint,
    niv_educ numeric(3,0),
    anio integer,
    lugar numeric(3,0),
    lugar_desc character varying(50),
    usuario character varying(50),
    log timestamp with time zone
);


ALTER TABLE yeah_2010.eah10_ex OWNER TO yeahowner;

--
-- Name: eah10_ex_borrado; Type: TABLE; Schema: yeah_2010; Owner: yeahowner; Tablespace: 
--

CREATE TABLE eah10_ex_borrado (
    id integer NOT NULL,
    comuna smallint,
    rep smallint,
    up integer,
    nenc integer,
    nhogar smallint NOT NULL,
    ex_miembro numeric(3,0) NOT NULL,
    sexo numeric(3,0),
    pais_nac numeric(3,0),
    edad smallint,
    niv_educ numeric(3,0),
    anio integer,
    lugar numeric(3,0),
    lugar_desc character varying(50),
    usuario character varying(50),
    log timestamp with time zone
);


ALTER TABLE yeah_2010.eah10_ex_borrado OWNER TO yeahowner;

--
-- Name: eah10_fam; Type: TABLE; Schema: yeah_2010; Owner: yeahowner; Tablespace: 
--

CREATE TABLE eah10_fam (
    id integer NOT NULL,
    comuna smallint,
    rep smallint,
    up integer,
    nenc integer,
    nhogar smallint NOT NULL,
    total_m numeric(3,0),
    p0 smallint NOT NULL,
    nombre character varying(30),
    sexo numeric(3,0),
    f_nac_o character varying(10),
    edad smallint,
    p4 numeric(3,0),
    p5 numeric(3,0),
    p5b numeric(3,0),
    p6_a numeric(3,0),
    p6_b numeric(3,0),
    p7 integer,
    p8 integer NOT NULL,
    p8_esp character varying(50),
    usuario character varying(50),
    log timestamp with time zone,
    edad_30_6 smallint,
    pc character varying(50),
    f_nac character varying(10)
);


ALTER TABLE yeah_2010.eah10_fam OWNER TO yeahowner;

--
-- Name: eah10_fam_borrado; Type: TABLE; Schema: yeah_2010; Owner: yeahowner; Tablespace: 
--

CREATE TABLE eah10_fam_borrado (
    id integer NOT NULL,
    comuna smallint,
    rep smallint,
    up integer,
    nenc integer,
    nhogar smallint NOT NULL,
    total_m numeric(3,0),
    p0 smallint NOT NULL,
    nombre character varying(30),
    sexo numeric(3,0),
    f_nac character varying(10),
    edad smallint,
    p4 numeric(3,0),
    p5 numeric(3,0),
    p5b numeric(3,0),
    p6_a numeric(3,0),
    p6_b numeric(3,0),
    p7 integer,
    p8 integer NOT NULL,
    p8_esp character varying(50),
    usuario character varying(50),
    log timestamp with time zone,
    edad_30_6 smallint,
    pc character varying(50)
);


ALTER TABLE yeah_2010.eah10_fam_borrado OWNER TO yeahowner;

--
-- Name: eah10_i1; Type: TABLE; Schema: yeah_2010; Owner: yeahowner; Tablespace: 
--

CREATE TABLE eah10_i1 (
    id integer NOT NULL,
    comuna smallint,
    rep smallint,
    up integer,
    nenc integer,
    nhogar smallint NOT NULL,
    miembro smallint NOT NULL,
    nombre character varying(50),
    edad integer,
    sexo numeric(3,0),
    respond numeric(3,0),
    entrev numeric(3,0),
    t1 numeric(3,0),
    t2 numeric(3,0),
    t3 numeric(3,0),
    t4 numeric(3,0),
    t5 numeric(3,0),
    t6 numeric(3,0),
    t7 numeric(3,0),
    t8 numeric(3,0),
    t8_otro character varying(50),
    t9 numeric(3,0),
    t10 numeric(3,0),
    t11 numeric(3,0),
    t11_otro character varying(50),
    t12 numeric(3,0),
    t13 numeric(3,0),
    t14 numeric(3,0),
    t15 numeric(3,0),
    t16 numeric(3,0),
    t17 numeric(3,0),
    t18 numeric(3,0),
    t19_anio integer,
    t20 numeric(3,0),
    t21 numeric(3,0),
    t22 numeric(3,0),
    t23 character varying(200),
    t23_cod integer,
    t24 character varying(200),
    t24_cod integer,
    t25 character varying(200),
    t26 character varying(100),
    t27 numeric(3,0),
    t28 numeric(3,0),
    t29 numeric(3,0),
    t29a numeric(3,0),
    t30 numeric(3,0),
    t31_d numeric(3,0),
    t31_l numeric(3,0),
    t31_ma numeric(3,0),
    t31_mi numeric(3,0),
    t31_j numeric(3,0),
    t31_v numeric(3,0),
    t31_s numeric(3,0),
    t32_d numeric(3,0),
    t32_l numeric(3,0),
    t32_ma numeric(3,0),
    t32_mi numeric(3,0),
    t32_j numeric(3,0),
    t32_v numeric(3,0),
    t32_s numeric(3,0),
    t33 numeric(3,0),
    t34 numeric(3,0),
    t35 numeric(3,0),
    t36_1 numeric(3,0),
    t36_2 numeric(3,0),
    t36_3 numeric(3,0),
    t36_4 numeric(3,0),
    t36_5 numeric(3,0),
    t36_6 numeric(3,0),
    t36_7 numeric(3,0),
    t36_7_otro character varying(50),
    t36_8 numeric(3,0),
    t36_8_otro character varying(50),
    t36_99 numeric(3,0),
    t36_a numeric(3,0),
    t37 character varying(100),
    t37_cod smallint,
    t38 numeric(3,0),
    t39 numeric(3,0),
    t39_barrio character varying(50),
    t39_otro character varying(50),
    t39_bis numeric(3,0),
    t39_bis_cuantos integer,
    t39_bis1 integer,
    t40 numeric(3,0),
    t41 character varying(200),
    t41_cod smallint,
    t42 character varying(200),
    t43 character varying(100),
    t44 numeric(3,0),
    t45 numeric(3,0),
    t46 numeric(3,0),
    t47 numeric(3,0),
    t48 numeric(3,0),
    t49 numeric(3,0),
    t50a numeric(3,0),
    t50b numeric(3,0),
    t50c numeric(3,0),
    t50d numeric(3,0),
    t50e numeric(3,0),
    t50f numeric(3,0),
    t51 numeric(3,0),
    t52a numeric(3,0),
    t52b numeric(3,0),
    t52c numeric(3,0),
    t53_ing integer,
    t53_mensual numeric(3,0),
    t53_nopago numeric(3,0),
    t53c_anios numeric(3,0),
    t53c_meses numeric(3,0),
    t53c_98 numeric(3,0),
    t54 numeric(3,0),
    t54b integer,
    i1 numeric(3,0),
    i2_tot numeric(3,0),
    i2_totx integer,
    i2_tic numeric(3,0),
    i2_ticx integer,
    i3_1 numeric(3,0),
    i3_1x integer,
    i3_2 numeric(3,0),
    i3_2x integer,
    i3_3 numeric(3,0),
    i3_3x integer,
    i3_4 numeric(3,0),
    i3_4x integer,
    i3_5 numeric(3,0),
    i3_5x integer,
    i3_6 numeric(3,0),
    i3_6x integer,
    i3_7 numeric(3,0),
    i3_7x integer,
    i3_8 numeric(3,0),
    i3_8x integer,
    i3_11 integer,
    i3_11x integer,
    i3_12 integer,
    i3_12x integer,
    i3_13 integer,
    i3_13x integer,
    i3_10 numeric(3,0),
    i3_10x integer,
    i3_10_otro character varying(50),
    i3_tot integer,
    i3_99 numeric(3,0),
    e1 numeric(3,0),
    e2 numeric(3,0),
    e3 numeric(3,0),
    e3a numeric(3,0),
    e4 numeric(3,0),
    e6 numeric(3,0),
    e7 numeric(3,0),
    e8 numeric(3,0),
    e9_edad integer,
    e9_anio integer,
    e10 numeric(3,0),
    e12 numeric(3,0),
    e13 numeric(3,0),
    e14 numeric(3,0),
    e11_1 numeric(3,0),
    e11_2 numeric(3,0),
    e11_3 numeric(3,0),
    e11_4 numeric(3,0),
    e11_5 numeric(3,0),
    e11_6 numeric(3,0),
    e11_7 numeric(3,0),
    e11_8 numeric(3,0),
    e11_9 numeric(3,0),
    e11_10 numeric(3,0),
    e11_11 numeric(3,0),
    e11_12 numeric(3,0),
    e11_13 numeric(3,0),
    e11_14 numeric(3,0),
    e11_15 numeric(3,0),
    e11_15_otro character varying(50),
    e11_99 numeric(3,0),
    e11a numeric(3,0),
    e15_1 numeric(3,0),
    e15_2 numeric(3,0),
    e15_3 numeric(3,0),
    e15_4 numeric(3,0),
    e15_5 numeric(3,0),
    e15_5_otro character varying(70),
    e15_6 numeric(3,0),
    e15_9 numeric(3,0),
    e15a numeric(3,0),
    e16 numeric(3,0),
    e16_esp character varying(50),
    e16_bis integer,
    m1 numeric(3,0),
    m1_esp character varying(100),
    m1_anio smallint,
    m1a numeric(3,0),
    m1a_esp character varying(50),
    m3 integer,
    m3_anio smallint,
    m4 numeric(3,0),
    m4_esp character varying(100),
    m5 numeric(3,0),
    sn1_1 numeric(3,0),
    sn1_2 numeric(3,0),
    sn1_3 numeric(3,0),
    sn1_4 integer,
    sn1_5 integer,
    sn1_6 numeric(3,0),
    sn1_99 numeric(3,0),
    sn1_1_esp character varying(40),
    sn1_2_esp character varying(40),
    sn1_3_esp character varying(40),
    sn1_4_esp character varying(40),
    sn1_5_esp character varying(40),
    sn2 numeric(3,0),
    sn2_cant numeric(3,0),
    sn3 numeric(3,0),
    sn4 numeric(3,0),
    sn4_esp character varying(50),
    sn5 numeric(3,0),
    sn5_esp character varying(50),
    sn6 numeric(3,0),
    sn6_cant numeric(3,0),
    sn7 numeric(3,0),
    sn7_esp character varying(50),
    sn8 numeric(3,0),
    sn8_esp character varying(70),
    sn9 numeric(3,0),
    sn10a numeric(3,0),
    sn10b numeric(3,0),
    sn10c numeric(3,0),
    sn10d numeric(3,0),
    sn10e numeric(3,0),
    sn10f numeric(3,0),
    sn10g numeric(3,0),
    sn10h numeric(3,0),
    sn10i numeric(3,0),
    sn10j_esp character varying(50),
    sn10j numeric(3,0),
    sn11 numeric(3,0),
    sn12 numeric(3,0),
    sn12_esp integer,
    sn12_98 integer,
    sn13 integer,
    sn13_otro character varying(40),
    sn14 numeric(3,0),
    sn14_esp character varying(40),
    sn15a numeric(3,0),
    sn15b numeric(3,0),
    sn15c numeric(3,0),
    sn15d numeric(3,0),
    sn15e numeric(3,0),
    sn15f numeric(3,0),
    sn15g numeric(3,0),
    sn15h numeric(3,0),
    sn15i numeric(3,0),
    sn15j numeric(3,0),
    sn15k_esp character varying(40),
    sn15k numeric(3,0),
    sn16 numeric(3,0),
    s28 numeric(3,0),
    s29 numeric(3,0),
    s30 numeric(3,0),
    s31_anio integer,
    s31_mes numeric(3,0),
    estado integer,
    obs character varying(200),
    usuario character varying(50),
    log timestamp with time zone,
    edad_30_6 smallint,
    e9r smallint
);


ALTER TABLE yeah_2010.eah10_i1 OWNER TO yeahowner;

--
-- Name: eah10_i1_borrado; Type: TABLE; Schema: yeah_2010; Owner: yeahowner; Tablespace: 
--

CREATE TABLE eah10_i1_borrado (
    id integer NOT NULL,
    comuna smallint,
    rep smallint,
    up integer,
    nenc integer,
    nhogar smallint NOT NULL,
    miembro smallint NOT NULL,
    nombre character varying(50),
    edad integer,
    sexo numeric(3,0),
    respond numeric(3,0),
    entrev numeric(3,0),
    t1 numeric(3,0),
    t2 numeric(3,0),
    t3 numeric(3,0),
    t4 numeric(3,0),
    t5 numeric(3,0),
    t6 numeric(3,0),
    t7 numeric(3,0),
    t8 numeric(3,0),
    t8_otro character varying(50),
    t9 numeric(3,0),
    t10 numeric(3,0),
    t11 numeric(3,0),
    t11_otro character varying(50),
    t12 numeric(3,0),
    t13 numeric(3,0),
    t14 numeric(3,0),
    t15 numeric(3,0),
    t16 numeric(3,0),
    t17 numeric(3,0),
    t18 numeric(3,0),
    t19_anio integer,
    t20 numeric(3,0),
    t21 numeric(3,0),
    t22 numeric(3,0),
    t23 character varying(200),
    t23_cod integer,
    t24 character varying(200),
    t24_cod integer,
    t25 character varying(200),
    t26 character varying(100),
    t27 numeric(3,0),
    t28 numeric(3,0),
    t29 numeric(3,0),
    t29a numeric(3,0),
    t30 numeric(3,0),
    t31_d numeric(3,0),
    t31_l numeric(3,0),
    t31_ma numeric(3,0),
    t31_mi numeric(3,0),
    t31_j numeric(3,0),
    t31_v numeric(3,0),
    t31_s numeric(3,0),
    t32_d numeric(3,0),
    t32_l numeric(3,0),
    t32_ma numeric(3,0),
    t32_mi numeric(3,0),
    t32_j numeric(3,0),
    t32_v numeric(3,0),
    t32_s numeric(3,0),
    t33 numeric(3,0),
    t34 numeric(3,0),
    t35 numeric(3,0),
    t36_1 numeric(3,0),
    t36_2 numeric(3,0),
    t36_3 numeric(3,0),
    t36_4 numeric(3,0),
    t36_5 numeric(3,0),
    t36_6 numeric(3,0),
    t36_7 numeric(3,0),
    t36_7_otro character varying(50),
    t36_8 numeric(3,0),
    t36_8_otro character varying(50),
    t36_99 numeric(3,0),
    t36_a numeric(3,0),
    t37 character varying(100),
    t37_cod smallint,
    t38 numeric(3,0),
    t39 numeric(3,0),
    t39_barrio character varying(50),
    t39_otro character varying(50),
    t39_bis numeric(3,0),
    t39_bis_cuantos integer,
    t39_bis1 integer,
    t40 numeric(3,0),
    t41 character varying(200),
    t41_cod smallint,
    t42 character varying(200),
    t43 character varying(100),
    t44 numeric(3,0),
    t45 numeric(3,0),
    t46 numeric(3,0),
    t47 numeric(3,0),
    t48 numeric(3,0),
    t49 numeric(3,0),
    t50a numeric(3,0),
    t50b numeric(3,0),
    t50c numeric(3,0),
    t50d numeric(3,0),
    t50e numeric(3,0),
    t50f numeric(3,0),
    t51 numeric(3,0),
    t52a numeric(3,0),
    t52b numeric(3,0),
    t52c numeric(3,0),
    t53_ing integer,
    t53_mensual numeric(3,0),
    t53_nopago numeric(3,0),
    t53c_anios numeric(3,0),
    t53c_meses numeric(3,0),
    t53c_98 numeric(3,0),
    t54 numeric(3,0),
    t54b integer,
    i1 numeric(3,0),
    i2_tot numeric(3,0),
    i2_totx integer,
    i2_tic numeric(3,0),
    i2_ticx integer,
    i3_1 numeric(3,0),
    i3_1x integer,
    i3_2 numeric(3,0),
    i3_2x integer,
    i3_3 numeric(3,0),
    i3_3x integer,
    i3_4 numeric(3,0),
    i3_4x integer,
    i3_5 numeric(3,0),
    i3_5x integer,
    i3_6 numeric(3,0),
    i3_6x integer,
    i3_7 numeric(3,0),
    i3_7x integer,
    i3_8 numeric(3,0),
    i3_8x integer,
    i3_11 integer,
    i3_11x integer,
    i3_12 integer,
    i3_12x integer,
    i3_13 integer,
    i3_13x integer,
    i3_10 numeric(3,0),
    i3_10x integer,
    i3_10_otro character varying(50),
    i3_tot integer,
    i3_99 numeric(3,0),
    e1 numeric(3,0),
    e2 numeric(3,0),
    e3 numeric(3,0),
    e3a numeric(3,0),
    e4 numeric(3,0),
    e6 numeric(3,0),
    e7 numeric(3,0),
    e8 numeric(3,0),
    e9_edad integer,
    e9_anio integer,
    e10 numeric(3,0),
    e12 numeric(3,0),
    e13 numeric(3,0),
    e14 numeric(3,0),
    e11_1 numeric(3,0),
    e11_2 numeric(3,0),
    e11_3 numeric(3,0),
    e11_4 numeric(3,0),
    e11_5 numeric(3,0),
    e11_6 numeric(3,0),
    e11_7 numeric(3,0),
    e11_8 numeric(3,0),
    e11_9 numeric(3,0),
    e11_10 numeric(3,0),
    e11_11 numeric(3,0),
    e11_12 numeric(3,0),
    e11_13 numeric(3,0),
    e11_14 numeric(3,0),
    e11_15 numeric(3,0),
    e11_15_otro character varying(50),
    e11_99 numeric(3,0),
    e11a numeric(3,0),
    e15_1 numeric(3,0),
    e15_2 numeric(3,0),
    e15_3 numeric(3,0),
    e15_4 numeric(3,0),
    e15_5 numeric(3,0),
    e15_5_otro character varying(50),
    e15_6 numeric(3,0),
    e15_9 numeric(3,0),
    e15a numeric(3,0),
    e16 numeric(3,0),
    e16_esp character varying(50),
    e16_bis integer,
    m1 numeric(3,0),
    m1_esp character varying(100),
    m1_anio smallint,
    m1a numeric(3,0),
    m1a_esp character varying(50),
    m3 integer,
    m3_anio smallint,
    m4 numeric(3,0),
    m4_esp character varying(100),
    m5 numeric(3,0),
    sn1_1 numeric(3,0),
    sn1_2 numeric(3,0),
    sn1_3 numeric(3,0),
    sn1_4 integer,
    sn1_5 integer,
    sn1_6 numeric(3,0),
    sn1_99 numeric(3,0),
    sn1_1_esp character varying(40),
    sn1_2_esp character varying(40),
    sn1_3_esp character varying(40),
    sn1_4_esp character varying(40),
    sn1_5_esp character varying(40),
    sn2 numeric(3,0),
    sn2_cant numeric(3,0),
    sn3 numeric(3,0),
    sn4 numeric(3,0),
    sn4_esp character varying(50),
    sn5 numeric(3,0),
    sn5_esp character varying(50),
    sn6 numeric(3,0),
    sn6_cant numeric(3,0),
    sn7 numeric(3,0),
    sn7_esp character varying(50),
    sn8 numeric(3,0),
    sn8_esp character varying(70),
    sn9 numeric(3,0),
    sn10a numeric(3,0),
    sn10b numeric(3,0),
    sn10c numeric(3,0),
    sn10d numeric(3,0),
    sn10e numeric(3,0),
    sn10f numeric(3,0),
    sn10g numeric(3,0),
    sn10h numeric(3,0),
    sn10i numeric(3,0),
    sn10j_esp character varying(50),
    sn10j numeric(3,0),
    sn11 numeric(3,0),
    sn12 numeric(3,0),
    sn12_esp integer,
    sn12_98 integer,
    sn13 integer,
    sn13_otro character varying(40),
    sn14 numeric(3,0),
    sn14_esp character varying(40),
    sn15a numeric(3,0),
    sn15b numeric(3,0),
    sn15c numeric(3,0),
    sn15d numeric(3,0),
    sn15e numeric(3,0),
    sn15f numeric(3,0),
    sn15g numeric(3,0),
    sn15h numeric(3,0),
    sn15i numeric(3,0),
    sn15j numeric(3,0),
    sn15k_esp character varying(40),
    sn15k numeric(3,0),
    sn16 numeric(3,0),
    s28 numeric(3,0),
    s29 numeric(3,0),
    s30 numeric(3,0),
    s31_anio integer,
    s31_mes numeric(3,0),
    estado integer,
    obs character varying(200),
    usuario character varying(50),
    log timestamp with time zone,
    edad_30_6 smallint,
    e9r smallint
);


ALTER TABLE yeah_2010.eah10_i1_borrado OWNER TO yeahowner;

--
-- Name: eah10_mhl_epides; Type: TABLE; Schema: yeah_2010; Owner: yeahowner; Tablespace: 
--

CREATE TABLE eah10_mhl_epides (
    id integer NOT NULL,
    comuna smallint,
    rep smallint,
    up integer,
    nenc integer,
    nhogar integer NOT NULL,
    miembro integer NOT NULL,
    epides integer NOT NULL,
    hi11_mes smallint,
    hi11_anio integer,
    hi12 smallint,
    hi13 smallint,
    hi14 smallint,
    hi14_esp character(150),
    hi15 smallint,
    hi16 smallint,
    hi17 smallint,
    hi18 smallint,
    hi19 smallint,
    usuario character(10),
    log timestamp with time zone
);


ALTER TABLE yeah_2010.eah10_mhl_epides OWNER TO yeahowner;

--
-- Name: eah10_mhl_epiocu; Type: TABLE; Schema: yeah_2010; Owner: yeahowner; Tablespace: 
--

CREATE TABLE eah10_mhl_epiocu (
    id integer NOT NULL,
    comuna smallint,
    rep smallint,
    up integer,
    nenec integer,
    nhogar integer NOT NULL,
    miembro integer NOT NULL,
    cocup integer NOT NULL,
    hi1_mes smallint,
    hi1_anio integer,
    hi2 smallint,
    hi2_esp character(150),
    hi3 smallint,
    hi4 smallint,
    hi5 smallint,
    hi6 smallint,
    hi7 smallint,
    hi8 smallint,
    hi9 smallint,
    hi10 smallint,
    usuario character(10),
    log timestamp with time zone
);


ALTER TABLE yeah_2010.eah10_mhl_epiocu OWNER TO yeahowner;

--
-- Name: eah10_mhl_fam; Type: TABLE; Schema: yeah_2010; Owner: yeahowner; Tablespace: 
--

CREATE TABLE eah10_mhl_fam (
    id integer NOT NULL,
    comuna smallint,
    nenc integer,
    nhogar integer NOT NULL,
    miembro integer NOT NULL,
    nombre character(30),
    edad integer,
    hh1 smallint,
    hh2 smallint,
    hh3 smallint,
    hh4 smallint,
    hh5 smallint,
    hh6 character(1),
    hh7 smallint
);


ALTER TABLE yeah_2010.eah10_mhl_fam OWNER TO yeahowner;

--
-- Name: eah10_mhl_hog; Type: TABLE; Schema: yeah_2010; Owner: yeahowner; Tablespace: 
--

CREATE TABLE eah10_mhl_hog (
    id integer NOT NULL,
    comuna smallint,
    nenc integer,
    nhogar integer NOT NULL,
    obser character(150),
    rnr_h smallint,
    f_realiz character(10),
    c_enc smallint,
    n_enc character(50),
    c_recep smallint,
    n_recep character(50),
    c_sup smallint,
    n_sup character(50),
    c_recu smallint,
    n_recu character(50),
    tot_15_60 smallint,
    sm1 smallint,
    sm2 smallint
);


ALTER TABLE yeah_2010.eah10_mhl_hog OWNER TO yeahowner;

--
-- Name: eah10_mhl_ind; Type: TABLE; Schema: yeah_2010; Owner: yeahowner; Tablespace: 
--

CREATE TABLE eah10_mhl_ind (
    id integer NOT NULL,
    comuna smallint,
    nenc integer,
    nhogar integer NOT NULL,
    miembro integer NOT NULL,
    nombre character(50),
    edad integer,
    sexo smallint,
    rea smallint,
    razon1 smallint,
    razon2 smallint,
    razon3 character(50),
    f_realiz character(5),
    c_enc smallint,
    n_enc character(50),
    c_recep smallint,
    n_recep character(50),
    c_sup smallint,
    n_sup character(50),
    c_recu smallint,
    n_recu character(50),
    hi0_05_ene smallint,
    hi0_05_feb smallint,
    hi0_05_mar smallint,
    hi0_05_abr smallint,
    hi0_05_may smallint,
    hi0_05_jun smallint,
    hi0_05_jul smallint,
    hi0_05_ago smallint,
    hi0_05_sep smallint,
    hi0_05_oct smallint,
    hi0_05_nov smallint,
    hi0_05_dic smallint,
    hi0_06_ene smallint,
    hi0_06_feb smallint,
    hi0_06_mar smallint,
    hi0_06_abr smallint,
    hi0_06_may smallint,
    hi0_06_jun smallint,
    hi0_06_jul smallint,
    hi0_06_ago smallint,
    hi0_06_sep smallint,
    hi0_06_oct smallint,
    hi0_06_nov smallint,
    hi0_06_dic smallint,
    hi0_07_ene smallint,
    hi0_07_feb smallint,
    hi0_07_mar smallint,
    hi0_07_abr smallint,
    hi0_07_may smallint,
    hi0_07_jun smallint,
    hi0_07_jul smallint,
    hi0_07_ago smallint,
    hi0_07_sep smallint,
    hi0_07_oct smallint,
    hi0_07_nov smallint,
    hi0_07_dic smallint,
    hi0_08_ene smallint,
    hi0_08_feb smallint,
    hi0_08_mar smallint,
    hi0_08_abr smallint,
    hi0_08_may smallint,
    hi0_08_jun smallint,
    hi0_08_jul smallint,
    hi0_08_ago smallint,
    hi0_08_sep smallint,
    hi0_08_oct smallint,
    hi0_08_nov smallint,
    hi0_08_dic smallint,
    hi0_09_ene smallint,
    hi0_09_feb smallint,
    hi0_09_mar smallint,
    hi0_09_abr smallint,
    hi0_09_may smallint,
    hi0_09_jun smallint,
    hi0_09_jul smallint,
    hi0_09_ago smallint,
    hi0_09_sep smallint,
    hi0_09_oct smallint,
    hi0_09_nov smallint,
    hi0_09_dic smallint,
    hi0_10_ene smallint,
    hi0_10_feb smallint,
    hi0_10_mar smallint,
    hi0_10_abr smallint,
    hi0_10_may smallint,
    hi0_10_jun smallint,
    hi0_10_jul smallint,
    hi0_10_ago smallint,
    hi0_10_sep smallint,
    hi0_10_oct smallint,
    hi0_10_nov smallint,
    hi0_10_dic smallint,
    hi20 character(150),
    hi20_cod integer,
    hi21 smallint,
    hi22_nomb character(150),
    hi22_cod integer,
    hi23 character(150),
    hi24 character(150),
    hi25 smallint,
    hi26 smallint,
    hi27 smallint,
    hi28 smallint,
    hi29 smallint,
    hi30 smallint,
    hi31_1 smallint,
    hi31_2 smallint,
    hi31_3 smallint,
    hi31_4 smallint,
    hi31_5 smallint,
    hi31_6 smallint,
    hi31_6_esp character(150),
    hi32 smallint,
    hi33 smallint,
    hi34 smallint,
    hi35_1 smallint,
    hi35_2 smallint,
    hi35_3 smallint,
    hi35_4 smallint,
    hi35_5 smallint,
    hi35_6 smallint,
    hi35_7 smallint,
    hi35_8 smallint,
    hi35_8_esp character(150),
    hi35_9 smallint,
    hi36 smallint,
    hi37 smallint,
    hi38 smallint,
    hi39 smallint,
    hi40 smallint,
    hi41 smallint,
    hi42_esp character(150),
    hi42_cod integer,
    hi43 smallint,
    hi44 character(150),
    hi45 character(150),
    hi46 character(150),
    hi47_1 smallint,
    hi47_2 smallint,
    hi48 smallint,
    hi49_1 smallint,
    hi49_2 smallint,
    hi49_3 smallint,
    hi49_3_esp character(150),
    obser text,
    usuario character(10),
    log timestamp with time zone
);


ALTER TABLE yeah_2010.eah10_mhl_ind OWNER TO yeahowner;

--
-- Name: eah10_tv; Type: TABLE; Schema: yeah_2010; Owner: yeahowner; Tablespace: 
--

CREATE TABLE eah10_tv (
    id integer NOT NULL,
    comuna smallint,
    rep smallint,
    up integer,
    nenc integer,
    nhogar smallint NOT NULL,
    miembro smallint NOT NULL,
    p1 character varying(50),
    p3b smallint,
    tv1 smallint,
    tv2 smallint,
    tv3 smallint,
    tv4 character varying(100),
    tv5 character varying(100),
    tv6 smallint,
    tv7 smallint
);


ALTER TABLE yeah_2010.eah10_tv OWNER TO yeahowner;

--
-- Name: eah10_tv_borrado; Type: TABLE; Schema: yeah_2010; Owner: yeahowner; Tablespace: 
--

CREATE TABLE eah10_tv_borrado (
    id integer NOT NULL,
    comuna smallint,
    rep smallint,
    up integer,
    nenc integer,
    nhogar smallint NOT NULL,
    miembro smallint NOT NULL,
    p1 character varying(50),
    p3b smallint,
    tv1 smallint,
    tv2 smallint,
    tv3 smallint,
    tv4 character varying(100),
    tv5 character varying(100),
    tv6 smallint,
    tv7 smallint
);


ALTER TABLE yeah_2010.eah10_tv_borrado OWNER TO yeahowner;

--
-- Name: eah10_viv_s1a1; Type: TABLE; Schema: yeah_2010; Owner: yeahowner; Tablespace: 
--

CREATE TABLE eah10_viv_s1a1 (
    id integer NOT NULL,
    comuna smallint,
    rep smallint,
    lote integer,
    up integer,
    nenc integer,
    id2009 integer,
    nh2009 integer,
    entrea numeric(3,0),
    razon1 numeric(3,0),
    razon2 numeric(3,0),
    razon3 character varying(50),
    nhogar smallint NOT NULL,
    miembro integer,
    v1 numeric(3,0),
    total_h numeric(3,0),
    total_m numeric(3,0),
    c_enc smallint,
    n_enc character varying(50),
    c_recu smallint,
    n_recu character varying(50),
    c_recep smallint,
    n_recep character varying(50),
    c_sup integer,
    n_sup character varying(50),
    respond smallint,
    nombre character varying(50),
    f_realiz_o character varying(5),
    form character varying(4),
    v2 numeric(3,0),
    v2_esp character varying(50),
    v4 numeric(3,0),
    v5 numeric(3,0),
    v5_esp character varying(255),
    v6 numeric(3,0),
    v7 numeric(3,0),
    v12 numeric(3,0),
    h1 numeric(3,0),
    h2 numeric(3,0),
    h2_esp character varying(50),
    h3 numeric(3,0),
    h4 numeric(3,0),
    h4_tipot numeric(3,0),
    h4_tel character varying(20),
    h20_1 numeric(3,0),
    h20_2 numeric(3,0),
    h20_4 numeric(3,0),
    h20_5 numeric(3,0),
    h20_6 numeric(3,0),
    h20_7 numeric(3,0),
    h20_8 numeric(3,0),
    h20_10 numeric(3,0),
    h20_15 numeric(3,0),
    h20_11 numeric(3,0),
    h20_12 numeric(3,0),
    h20_13 numeric(3,0),
    h20_16 numeric(3,0),
    h20_17 numeric(3,0),
    h20_18 numeric(3,0),
    h20_19 numeric(3,0),
    h20_20 numeric(3,0),
    h20_14 numeric(3,0),
    h20_esp character varying(50),
    h20_99 numeric(3,0),
    x5 numeric(3,0),
    x5_tot numeric(3,0),
    h30_tv numeric(3,0),
    h30_hf numeric(3,0),
    h30_la numeric(3,0),
    h30_vi numeric(3,0),
    h30_ac numeric(3,0),
    h30_dvd numeric(3,0),
    h30_mo numeric(3,0),
    h30_pc numeric(3,0),
    h30_in numeric(3,0),
    obs character varying(255),
    usuario character varying(15),
    log timestamp with time zone,
    tipo_h character varying(1),
    encreali integer,
    f_realiz character varying(50)
);


ALTER TABLE yeah_2010.eah10_viv_s1a1 OWNER TO yeahowner;

--
-- Name: eah10_viv_s1a1_borrado; Type: TABLE; Schema: yeah_2010; Owner: yeahowner; Tablespace: 
--

CREATE TABLE eah10_viv_s1a1_borrado (
    id integer NOT NULL,
    comuna smallint,
    rep smallint,
    lote integer,
    up integer,
    nenc integer,
    id2009 integer,
    nh2009 integer,
    entrea numeric(3,0),
    razon1 numeric(3,0),
    razon2 numeric(3,0),
    razon3 character varying(50),
    nhogar smallint NOT NULL,
    miembro integer,
    v1 numeric(3,0),
    total_h numeric(3,0),
    total_m numeric(3,0),
    c_enc smallint,
    n_enc character varying(50),
    c_recu smallint,
    n_recu character varying(50),
    c_recep smallint,
    n_recep character varying(50),
    c_sup integer,
    n_sup character varying(50),
    respond smallint,
    nombre character varying(50),
    f_realiz character varying(5),
    form character varying(4),
    v2 numeric(3,0),
    v2_esp character varying(50),
    v4 numeric(3,0),
    v5 numeric(3,0),
    v5_esp character varying(255),
    v6 numeric(3,0),
    v7 numeric(3,0),
    v12 numeric(3,0),
    h1 numeric(3,0),
    h2 numeric(3,0),
    h2_esp character varying(50),
    h3 numeric(3,0),
    h4 numeric(3,0),
    h4_tipot numeric(3,0),
    h4_tel character varying(20),
    h20_1 numeric(3,0),
    h20_2 numeric(3,0),
    h20_4 numeric(3,0),
    h20_5 numeric(3,0),
    h20_6 numeric(3,0),
    h20_7 numeric(3,0),
    h20_8 numeric(3,0),
    h20_10 numeric(3,0),
    h20_15 numeric(3,0),
    h20_11 numeric(3,0),
    h20_12 numeric(3,0),
    h20_13 numeric(3,0),
    h20_16 numeric(3,0),
    h20_17 numeric(3,0),
    h20_18 numeric(3,0),
    h20_19 numeric(3,0),
    h20_20 numeric(3,0),
    h20_14 numeric(3,0),
    h20_esp character varying(50),
    h20_99 numeric(3,0),
    x5 numeric(3,0),
    x5_tot numeric(3,0),
    h30_tv numeric(3,0),
    h30_hf numeric(3,0),
    h30_la numeric(3,0),
    h30_vi numeric(3,0),
    h30_ac numeric(3,0),
    h30_dvd numeric(3,0),
    h30_mo numeric(3,0),
    h30_pc numeric(3,0),
    h30_in numeric(3,0),
    obs character varying(255),
    usuario character varying(15),
    log timestamp with time zone,
    tipo_h character varying(1),
    encreali integer
);


ALTER TABLE yeah_2010.eah10_viv_s1a1_borrado OWNER TO yeahowner;

--
-- Name: id2009; Type: TABLE; Schema: yeah_2010; Owner: yeahowner; Tablespace: 
--

CREATE TABLE id2009 (
    nenc integer,
    id integer,
    maxid integer
);


ALTER TABLE yeah_2010.id2009 OWNER TO yeahowner;

--
-- Name: log_edicion; Type: TABLE; Schema: yeah_2010; Owner: yeahowner; Tablespace: 
--

CREATE TABLE log_edicion (
    usuario character(100) NOT NULL,
    texto text,
    pc character(100) NOT NULL,
    fecha timestamp with time zone NOT NULL,
    error text
);


ALTER TABLE yeah_2010.log_edicion OWNER TO yeahowner;

--
-- Name: ocurrencia_pautas; Type: TABLE; Schema: yeah_2010; Owner: yeahowner; Tablespace: 
--

CREATE TABLE ocurrencia_pautas (
    cod_enc_rec character varying(255)
);


ALTER TABLE yeah_2010.ocurrencia_pautas OWNER TO yeahowner;

--
-- Name: ordenmodulo; Type: TABLE; Schema: yeah_2010; Owner: yeahowner; Tablespace: 
--

CREATE TABLE ordenmodulo (
    orden integer,
    modulo character varying(50)
);


ALTER TABLE yeah_2010.ordenmodulo OWNER TO yeahowner;

--
-- Name: pautas; Type: TABLE; Schema: yeah_2010; Owner: yeahowner; Tablespace: 
--

CREATE TABLE pautas (
    id_con integer NOT NULL,
    orden integer,
    condicion_con text,
    si_con text,
    pauta_con text,
    error_con character varying(15),
    activa_con character varying(10),
    basica character varying(10),
    general character varying(10),
    descripcion character varying(140),
    obs text,
    vista character varying(15),
    modulo character varying(50),
    info character varying(250),
    forzar character varying(10)
);


ALTER TABLE yeah_2010.pautas OWNER TO yeahowner;

--
-- Name: pegadas_rep5; Type: TABLE; Schema: yeah_2010; Owner: yeahowner; Tablespace: 
--

CREATE TABLE pegadas_rep5 (
    comunas double precision,
    rep double precision,
    dpto character varying(255),
    frac character varying(255),
    radio character varying(255),
    mza character varying(255),
    seg character varying(255),
    nced character varying(255),
    clado character varying(255),
    ccodigo double precision,
    cnombre character varying(255),
    hn character varying(255),
    hp double precision,
    hd character varying(255),
    "CODIGO POSTAL" double precision,
    f16 character varying(255)
);


ALTER TABLE yeah_2010.pegadas_rep5 OWNER TO yeahowner;

--
-- Name: tem10; Type: TABLE; Schema: yeah_2010; Owner: yeahowner; Tablespace: 
--

CREATE TABLE tem10 (
    id integer NOT NULL,
    id_marco numeric(19,0),
    comunas integer,
    rep integer,
    dpto character varying(3),
    frac character varying(2),
    radio character varying(2),
    mza character varying(3),
    seg character varying(11),
    nced character varying(11),
    clado character varying(2),
    ccodigo character varying(6),
    cnombre character varying(50),
    hn double precision,
    hp character varying(3),
    hd character varying(6),
    hab character varying(3),
    h0 character varying(1),
    h4 character varying(2),
    h1 character varying(2),
    obs character varying(255),
    ident_edif character varying(50),
    hn_bis double precision,
    hp_bis character varying(50),
    hd_bis character varying(50),
    hab_bis character varying(50),
    ident_edif_bis character varying(30),
    barrio character varying(50),
    res character varying(11),
    tot_hab character varying(11),
    pzas character varying(11),
    encues integer,
    lote double precision,
    dominio character varying(11),
    up double precision,
    cod_ord double precision,
    noreaenc2009 character varying(2),
    codenc2009 character varying(3),
    fec_enc2009 character varying(10),
    rea2009 character varying(2),
    hog2009 character varying(3),
    pob2009 character varying(4),
    norearec2009 character varying(2),
    f_recep2009 character varying(10),
    recup_fecentrega2009 character varying(10),
    recup_fecrecep2009 character varying(10),
    recup_codigo2009 character varying(3),
    recuento_fliar2009 character varying(11),
    recuento_pas2009 character varying(11),
    recuento_desocupada2009 character varying(11),
    recuento_otro2009 character varying(11),
    recuento_total2009 character varying(11),
    marco_anio character varying(50),
    marco character varying(1),
    cd2009 character varying(1),
    modulo2009 character varying(1),
    modulorea2009 character varying(2),
    modulonorea2009 character varying(2),
    modulonocorr2009 character varying(2),
    modulo18_2009 character varying(2),
    estrato character varying(1),
    recep_codigo2009 character varying(3),
    recep_nombre2009 character varying(50),
    preshog2009 character varying(2),
    prespob2009 character varying(2),
    ausehog2009 character varying(2),
    ausepob2009 character varying(2),
    totalhog2009 character varying(2),
    totalpob2009 character varying(2),
    fec_mod character varying(10),
    usuario character varying(20),
    cp smallint
);


ALTER TABLE yeah_2010.tem10 OWNER TO yeahowner;

--
-- Name: tem10_bis; Type: TABLE; Schema: yeah_2010; Owner: yeahowner; Tablespace: 
--

CREATE TABLE tem10_bis (
    id_marco numeric(19,0),
    comunas integer,
    rep integer,
    dpto character varying(3),
    frac character varying(2),
    radio character varying(2),
    mza character varying(3),
    seg character varying(11),
    nced character varying(11),
    clado character varying(2),
    ccodigo character varying(6),
    cnombre character varying(50),
    hn double precision,
    hp character varying(3),
    hd character varying(6),
    hab character varying(3),
    h0 character varying(1),
    h4 character varying(2),
    h1 character varying(2),
    obs character varying(255),
    ident_edif character varying(50),
    hn_bis double precision,
    hp_bis character varying(50),
    hd_bis character varying(50),
    hab_bis character varying(50),
    ident_edif_bis character varying(30),
    barrio character varying(50),
    res character varying(11),
    tot_hab character varying(11),
    pzas character varying(11),
    encues integer,
    lote double precision,
    dominio character varying(11),
    up double precision,
    cod_ord double precision,
    noreaenc2009 character varying(2),
    codenc2009 character varying(3),
    fec_enc2009 character varying(10),
    rea2009 character varying(2),
    hog2009 character varying(3),
    pob2009 character varying(4),
    norearec2009 character varying(2),
    f_recep2009 character varying(10),
    recup_fecentrega2009 character varying(10),
    recup_fecrecep2009 character varying(10),
    recup_codigo2009 character varying(3),
    recuento_fliar2009 character varying(11),
    recuento_pas2009 character varying(11),
    recuento_desocupada2009 character varying(11),
    recuento_otro2009 character varying(11),
    recuento_total2009 character varying(11),
    marco_anio character varying(50),
    marco character varying(1),
    cd2009 character varying(1),
    modulo2009 character varying(1),
    modulorea2009 character varying(2),
    modulonorea2009 character varying(2),
    modulonocorr2009 character varying(2),
    modulo18_2009 character varying(2),
    estrato character varying(1),
    recep_codigo2009 character varying(3),
    recep_nombre2009 character varying(50),
    preshog2009 character varying(2),
    prespob2009 character varying(2),
    ausehog2009 character varying(2),
    ausepob2009 character varying(2),
    totalhog2009 character varying(2),
    totalpob2009 character varying(2),
    fec_mod character varying(10),
    usuario character varying(20),
    cp smallint
);


ALTER TABLE yeah_2010.tem10_bis OWNER TO yeahowner;

--
-- Name: tpegadas_rep5; Type: TABLE; Schema: yeah_2010; Owner: yeahowner; Tablespace: 
--

CREATE TABLE tpegadas_rep5 (
    comunas double precision,
    rep double precision,
    ccodigo double precision,
    hn character varying(255),
    "codigo postal" double precision,
    casos integer
);


ALTER TABLE yeah_2010.tpegadas_rep5 OWNER TO yeahowner;

SET search_path = yeah_2011, pg_catalog;

--
-- Name: bolsas; Type: TABLE; Schema: yeah_2011; Owner: yeahowner; Tablespace: 
--

CREATE TABLE bolsas (
    bolsa_bolsa integer NOT NULL,
    bolsa_cerrada integer,
    bolsa_rea integer NOT NULL,
    bolsa_activa integer,
    bolsa_revisada integer,
    CONSTRAINT bolsas_bolsa_activa_check CHECK (((bolsa_activa = 1) OR (bolsa_activa IS NULL))),
    CONSTRAINT bolsas_bolsa_cerrada_check CHECK (((bolsa_cerrada = ANY (ARRAY[1, 2])) OR (bolsa_cerrada IS NULL))),
    CONSTRAINT bolsas_bolsa_rea_check CHECK ((bolsa_rea = ANY (ARRAY[0, 1]))),
    CONSTRAINT bolsas_bolsa_revisada_check CHECK ((bolsa_revisada = 1)),
    CONSTRAINT "no puede estar revisada la bolsa sin cerrar" CHECK (((bolsa_revisada IS NULL) OR ((bolsa_cerrada IS NOT NULL) AND (bolsa_cerrada = ANY (ARRAY[1, 2])))))
);


ALTER TABLE yeah_2011.bolsas OWNER TO yeahowner;

--
-- Name: comunas; Type: TABLE; Schema: yeah_2011; Owner: yeahowner; Tablespace: 
--

CREATE TABLE comunas (
    comuna_comuna character varying(30) NOT NULL,
    comuna_cod_recep character varying(30),
    comuna_cod_sup character varying(30),
    comuna_cod_subcoor character varying(30),
    comuna_cod_recu character varying(30),
    comuna_cte_recep character varying(30),
    comuna_cte_sup character varying(30),
    comuna_cte_subcoor character varying(30),
    comuna_cte_recu character varying(30),
    CONSTRAINT comunas_cte_recep_check CHECK (((comuna_cte_recep)::text = 'recepcionista'::text)),
    CONSTRAINT comunas_cte_recu_check CHECK (((comuna_cte_recu)::text = 'recuperador'::text)),
    CONSTRAINT comunas_cte_subcoor_check CHECK (((comuna_cte_subcoor)::text = 'subcoor_campo'::text)),
    CONSTRAINT comunas_cte_sup_check CHECK (((comuna_cte_sup)::text = 'supervisor'::text))
);


ALTER TABLE yeah_2011.comunas OWNER TO yeahowner;

--
-- Name: con_var; Type: VIEW; Schema: yeah_2011; Owner: yeahowner
--

CREATE VIEW con_var AS
    SELECT v.var_enc AS convar_enc, x.convar_con, x.vars[1] AS convar_var, CASE WHEN (v.var_var IS NULL) THEN '**** NO ENCONTRADA ****'::character varying ELSE v.var_texto END AS convar_texto, v.var_for AS convar_for, v.var_mat AS convar_mat, v.var_orden AS convar_orden FROM ((SELECT DISTINCT consistencias.con_con AS convar_con, regexp_matches(lower((((COALESCE(consistencias.con_precondicion, ''::character varying))::text || ' '::text) || (COALESCE(consistencias.con_postcondicion, ''::character varying))::text)), '([A-Za-z][A-Za-z0-9_]*)(?![A-Za-z0-9_]|[.(])'::text, 'g'::text) AS vars FROM yeah.consistencias) x LEFT JOIN yeah.variables v ON ((x.vars[1] = (v.var_var)::text))) WHERE (x.vars[1] <> ALL (ARRAY['or'::text, 'and'::text]));


ALTER TABLE yeah_2011.con_var OWNER TO yeahowner;

--
-- Name: eah11_ex; Type: TABLE; Schema: yeah_2011; Owner: yeahowner; Tablespace: 
--

CREATE TABLE eah11_ex (
    nenc integer NOT NULL,
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
    log timestamp with time zone
);


ALTER TABLE yeah_2011.eah11_ex OWNER TO yeahowner;

--
-- Name: eah11_fam; Type: TABLE; Schema: yeah_2011; Owner: yeahowner; Tablespace: 
--

CREATE TABLE eah11_fam (
    nenc integer NOT NULL,
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
    p8 integer,
    p8_esp character varying(50),
    usuario character varying(50),
    log timestamp with time zone,
    pc character varying(50),
    f_nac character varying(10)
);


ALTER TABLE yeah_2011.eah11_fam OWNER TO yeahowner;

--
-- Name: eah11_i1; Type: TABLE; Schema: yeah_2011; Owner: yeahowner; Tablespace: 
--

CREATE TABLE eah11_i1 (
    nenc integer NOT NULL,
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
    t11_otro character(116),
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
    t37 character(209),
    t37_cod integer,
    t38 integer,
    t39 integer,
    t39_barrio character(50),
    t39_otro character(50),
    t39_bis integer,
    t39_bis_cuantos integer,
    t39_bis1 integer,
    t40 integer,
    t41 character(200),
    t41_cod integer,
    t42 character(400),
    t43 character(200),
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
    e11_15_otro character(100),
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
    sn2 integer,
    sn2_cant integer,
    sn3 integer,
    sn4 integer,
    sn4_esp character(104),
    sn5 integer,
    sn5_esp character(50),
    sn6 integer,
    sn6_cant integer,
    sn7 integer,
    sn7_esp character(50),
    sn8 integer,
    sn8_esp character(135),
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
    sn15k_esp character(93),
    sn15k integer,
    sn16 integer,
    s28 integer,
    s29 integer,
    s30 integer,
    s31_anio integer,
    s31_mes integer,
    estado integer,
    obs character(400),
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
    t48b_esp character varying(219),
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
    observaciones character varying(800),
    t37sd integer,
    e15_7 integer
);


ALTER TABLE yeah_2011.eah11_i1 OWNER TO yeahowner;

--
-- Name: eah11_md; Type: TABLE; Schema: yeah_2011; Owner: yeahowner; Tablespace: 
--

CREATE TABLE eah11_md (
    nenc integer NOT NULL,
    nhogar integer NOT NULL,
    miembro integer NOT NULL,
    d1_meses integer,
    d1_anios integer,
    d2 integer,
    d4 integer,
    d6 integer,
    d7 integer,
    d8 integer,
    d9 integer,
    d10 integer,
    d12 integer,
    d13 integer,
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
    d27 integer,
    d5_1 integer,
    d5_2 integer,
    d5_3 integer,
    d5_4 integer,
    d5_5 integer,
    d5_6 integer,
    d5_7 integer,
    d5_8 integer,
    d5_9 integer,
    d5_10 integer,
    d5_11 integer,
    d11_1 integer,
    d11_2 integer,
    d11_3 integer,
    d11_4 integer,
    d11_5 integer,
    d11_6 integer,
    d11_7 integer,
    d11_8 integer,
    d11_9 integer,
    d11_10 integer,
    d14_1 integer,
    d14_2 integer,
    d14_3 integer,
    d14_4 integer,
    d14_5 integer,
    d14_6 integer,
    entre_realizada integer,
    razon_no_realizada integer,
    razon_no_realizada_1 text,
    razon_no_realizada_2 text,
    usuario character varying(30),
    d3_1 integer,
    d3_2 integer,
    d3_3 integer,
    d3_4 integer,
    d3_5 integer,
    d3_6 integer,
    d3_7 integer,
    d3_8 integer,
    d3_9 integer,
    d3_10 integer,
    d3_11 integer,
    d3_12 integer,
    d3_13 integer,
    d3_14 integer,
    d8_esp character(198),
    d9_esp character(196)
);


ALTER TABLE yeah_2011.eah11_md OWNER TO yeahowner;

--
-- Name: eah11_tv; Type: TABLE; Schema: yeah_2011; Owner: yeahowner; Tablespace: 
--

CREATE TABLE eah11_tv (
    nenc integer NOT NULL,
    nhogar integer NOT NULL,
    miembro integer NOT NULL,
    tv1 integer,
    tv2 integer,
    tv3 integer,
    tv4 character varying(100),
    tv5 character varying(100),
    tv6 integer,
    tv7 integer
);


ALTER TABLE yeah_2011.eah11_tv OWNER TO yeahowner;

--
-- Name: eah11_un; Type: TABLE; Schema: yeah_2011; Owner: yeahowner; Tablespace: 
--

CREATE TABLE eah11_un (
    nenc integer NOT NULL,
    nhogar integer NOT NULL,
    miembro integer NOT NULL,
    relacion integer NOT NULL,
    u3_mes integer,
    u3_anio integer,
    u4_mes integer,
    u4_anio integer,
    u5 integer,
    u6 integer,
    usuario character varying(30)
);


ALTER TABLE yeah_2011.eah11_un OWNER TO yeahowner;

--
-- Name: eah11_viv_s1a1; Type: TABLE; Schema: yeah_2011; Owner: yeahowner; Tablespace: 
--

CREATE TABLE eah11_viv_s1a1 (
    nenc integer NOT NULL,
    participacion integer NOT NULL,
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
    h4_tel character varying(97),
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
    usuario character varying(30),
    log timestamp with time zone,
    tipo_h character varying(1),
    encreali integer,
    f_realiz character varying(50),
    telefono character varying(50),
    s1a1_obs character varying(250)
);


ALTER TABLE yeah_2011.eah11_viv_s1a1 OWNER TO yeahowner;

--
-- Name: estados; Type: TABLE; Schema: yeah_2011; Owner: yeahowner; Tablespace: 
--

CREATE TABLE estados (
    est_est numeric NOT NULL,
    est_nombre character varying(50),
    est_detalle character varying(200)
);


ALTER TABLE yeah_2011.estados OWNER TO yeahowner;

--
-- Name: excepciones; Type: TABLE; Schema: yeah_2011; Owner: yeahowner; Tablespace: 
--

CREATE TABLE excepciones (
    exc_encues integer NOT NULL,
    exc_observacion character varying(500),
    exc_fecha timestamp without time zone DEFAULT now()
);


ALTER TABLE yeah_2011.excepciones OWNER TO yeahowner;

--
-- Name: inconsistencias; Type: TABLE; Schema: yeah_2011; Owner: yeahowner; Tablespace: 
--

CREATE TABLE inconsistencias (
    inc_con character varying(30) NOT NULL,
    inc_nenc integer NOT NULL,
    inc_nhogar integer NOT NULL,
    inc_miembro_ex_0 integer NOT NULL,
    inc_relacion_0 integer NOT NULL,
    inc_variables_y_valores text,
    inc_justificacion character varying(140),
    inc_autor_justificacion character varying(30),
    inc_corrida timestamp without time zone NOT NULL,
    inc_estado_tem integer NOT NULL
);


ALTER TABLE yeah_2011.inconsistencias OWNER TO yeahowner;

--
-- Name: personal; Type: TABLE; Schema: yeah_2011; Owner: yeahowner; Tablespace: 
--

CREATE TABLE personal (
    per_per character varying(30) NOT NULL,
    per_nombre character varying(200),
    per_apellido character varying(200),
    per_rol character varying(30),
    per_comuna character varying(30)
);


ALTER TABLE yeah_2011.personal OWNER TO yeahowner;

--
-- Name: respuestas; Type: TABLE; Schema: yeah_2011; Owner: yeahowner; Tablespace: 
--

CREATE TABLE respuestas (
    res_encuesta integer NOT NULL,
    res_hogar integer NOT NULL,
    res_miembro integer NOT NULL,
    res_ex_miembro integer NOT NULL,
    res_relacion integer NOT NULL,
    res_var character varying(30) NOT NULL,
    res_for character varying(30),
    res_mat character varying(30),
    res_tab character varying(100),
    res_respuesta character varying(1000),
    res_usu_ult_mod character varying(30),
    res_fec_ult_mod timestamp without time zone DEFAULT now(),
    res_estado character varying(30)
);


ALTER TABLE yeah_2011.respuestas OWNER TO yeahowner;

--
-- Name: tem11; Type: TABLE; Schema: yeah_2011; Owner: yeahowner; Tablespace: 
--

CREATE TABLE tem11 (
    comuna character varying(30),
    replica character varying(30),
    up character varying(30),
    lote character varying(30),
    ipad character varying(30),
    encues integer NOT NULL,
    id_marco character varying(30),
    idd character varying(30),
    dpto character varying(30),
    frac character varying(30),
    radio character varying(30),
    mza character varying(30),
    clado character varying(30),
    seg character varying(30),
    nced character varying(30),
    hn character varying(30),
    orden_altu character varying(30),
    hp character varying(30),
    pisoaux character varying(30),
    hd character varying(30),
    h0 character varying(30),
    h4 character varying(30),
    usp character varying(30),
    h1 character varying(30),
    ccodigo character varying(30),
    cnombre character varying(100),
    ident_edif character varying(100),
    rep character varying(30),
    barrio character varying(50),
    cuit character varying(30),
    tot_hab character varying(30),
    pzas character varying(30),
    hab character varying(30),
    te character varying(30),
    fuente character varying(30),
    fec_mod character varying(30),
    frac_comun character varying(30),
    radio_comu character varying(30),
    mza_comuna character varying(30),
    up_comuna character varying(30),
    anio_list character varying(30),
    replica_cm character varying(30),
    marco character varying(30),
    marco_anio character varying(30),
    nro_orden character varying(30),
    incluido character varying(30),
    operacion character varying(30),
    usuario character varying(30),
    ok character varying(30),
    titular character varying(30),
    suplente character varying(30),
    marca character varying(30),
    pelusa character varying(30),
    anio_list_ant character varying(30),
    obs character varying(300),
    idcuerpo character varying(100),
    rama_act character varying(50),
    nomb_inst character varying(300),
    eli character varying(30),
    fuente_ant character varying(30),
    replica_cm_2007 character varying(30),
    yearfuente character varying(30),
    idprocedencia character varying(30),
    codord character varying(30),
    replica2 character varying(30),
    marca1 character varying(30),
    reserva character varying(30),
    orden_de_reemplazo character varying(30),
    up_i character varying(30),
    estrato character varying(30),
    habitaciones character varying(30),
    fec_entr_enc character varying(30),
    fec_enc character varying(30),
    cod_recu character varying(30),
    fec_entr_recu character varying(30),
    fec_recu character varying(30),
    bolsa integer,
    estado numeric DEFAULT 0 NOT NULL,
    cod_sup character varying(30),
    fin_sup integer,
    usu_ult_mod character varying(30),
    norea_enc integer,
    dominio character varying(1),
    poseedor character varying(30),
    rol_poseedor character varying(30),
    id_proc integer,
    bolsa_ok integer,
    cod_ing character varying(30),
    ingresando timestamp without time zone,
    vil_hog_pres character varying(30),
    vil_hog_aus character varying(30),
    vil_pob_pres character varying(30),
    vil_pob_aus character varying(30),
    fin_ingreso integer,
    inq_recuento character varying(30),
    inq_tipo_viv character varying(30),
    inq_ocu_flia character varying(30),
    inq_ocu_pas character varying(30),
    inq_desocupados character varying(30),
    inq_otro character varying(30),
    inq_tot_hab character varying(30),
    inq_dominio character varying(30),
    posterior integer DEFAULT 1,
    rea integer,
    hog integer,
    pobl integer,
    rea_modulo integer,
    norea_modulo integer,
    cod_enc integer,
    norea_recu integer,
    rea_recu_modu integer,
    norea_recu_modu integer,
    comunas integer,
    sup_campo integer,
    sup_recu_campo integer,
    sup_tel integer,
    fin_anal_ing integer,
    fin_anal_campo integer,
    fin_anal_proc integer,
    cod_ana_ing character varying(30),
    cod_ana_campo character varying(30),
    cod_procesamiento character varying(30),
    s1_extra integer,
    vil_hogpre_rea integer,
    vil_hogpre_hog integer,
    vil_hogpre_pob integer,
    vil_hogaus_rea integer,
    vil_hogaus_hog integer,
    vil_hogaus_pob integer
);


ALTER TABLE yeah_2011.tem11 OWNER TO yeahowner;

SET search_path = his, pg_catalog;

--
-- Name: mod_mod; Type: DEFAULT; Schema: his; Owner: yeahowner
--

ALTER TABLE modificaciones ALTER COLUMN mod_mod SET DEFAULT nextval('modificaciones_mod_mod_seq'::regclass);


--
-- Name: modificaciones_pkey; Type: CONSTRAINT; Schema: his; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY modificaciones
    ADD CONSTRAINT modificaciones_pkey PRIMARY KEY (mod_mod);


SET search_path = test, pg_catalog;

--
-- Name: t_conpk2_pkey; Type: CONSTRAINT; Schema: test; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY t_conpk2
    ADD CONSTRAINT t_conpk2_pkey PRIMARY KEY (conn_entero, conn_texto);


--
-- Name: t_encues_pkey; Type: CONSTRAINT; Schema: test; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY t_encues
    ADD CONSTRAINT t_encues_pkey PRIMARY KEY (enc_enc);


--
-- Name: t_formus_pkey; Type: CONSTRAINT; Schema: test; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY t_formus
    ADD CONSTRAINT t_formus_pkey PRIMARY KEY (for_enc, for_for);


--
-- Name: t_opcios_pkey; Type: CONSTRAINT; Schema: test; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY t_opcios
    ADD CONSTRAINT t_opcios_pkey PRIMARY KEY (opc_enc, opc_for, opc_pre, opc_opc);


--
-- Name: t_pregus_pkey; Type: CONSTRAINT; Schema: test; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY t_pregus
    ADD CONSTRAINT t_pregus_pkey PRIMARY KEY (pre_enc, pre_for, pre_pre);


--
-- Name: t_vacia_pkey; Type: CONSTRAINT; Schema: test; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY t_vacia
    ADD CONSTRAINT t_vacia_pkey PRIMARY KEY (enc_enc);


--
-- Name: tablas_pkey; Type: CONSTRAINT; Schema: test; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY tablas
    ADD CONSTRAINT tablas_pkey PRIMARY KEY (tabla);


SET search_path = yeah_2011, pg_catalog;

--
-- Name: bolsas_bolsa_activa_bolsa_rea_key; Type: CONSTRAINT; Schema: yeah_2011; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY bolsas
    ADD CONSTRAINT bolsas_bolsa_activa_bolsa_rea_key UNIQUE (bolsa_activa, bolsa_rea);


--
-- Name: bolsas_bolsa_activa_bolsa_rea_key1; Type: CONSTRAINT; Schema: yeah_2011; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY bolsas
    ADD CONSTRAINT bolsas_bolsa_activa_bolsa_rea_key1 UNIQUE (bolsa_activa, bolsa_rea);


--
-- Name: bolsas_bolsa_activa_bolsa_rea_key2; Type: CONSTRAINT; Schema: yeah_2011; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY bolsas
    ADD CONSTRAINT bolsas_bolsa_activa_bolsa_rea_key2 UNIQUE (bolsa_activa, bolsa_rea);


--
-- Name: bolsas_pkey; Type: CONSTRAINT; Schema: yeah_2011; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY bolsas
    ADD CONSTRAINT bolsas_pkey PRIMARY KEY (bolsa_bolsa);


--
-- Name: comuna_comuna_pkey; Type: CONSTRAINT; Schema: yeah_2011; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY comunas
    ADD CONSTRAINT comuna_comuna_pkey PRIMARY KEY (comuna_comuna);


--
-- Name: eah11_ex_pkey; Type: CONSTRAINT; Schema: yeah_2011; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY eah11_ex
    ADD CONSTRAINT eah11_ex_pkey PRIMARY KEY (nenc, nhogar, ex_miembro);


--
-- Name: eah11_fam_pkey; Type: CONSTRAINT; Schema: yeah_2011; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY eah11_fam
    ADD CONSTRAINT eah11_fam_pkey PRIMARY KEY (nenc, nhogar, p0);


--
-- Name: eah11_i1_pkey; Type: CONSTRAINT; Schema: yeah_2011; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY eah11_i1
    ADD CONSTRAINT eah11_i1_pkey PRIMARY KEY (nenc, nhogar, miembro);


--
-- Name: eah11_md_pkey; Type: CONSTRAINT; Schema: yeah_2011; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY eah11_md
    ADD CONSTRAINT eah11_md_pkey PRIMARY KEY (nenc, nhogar, miembro);


--
-- Name: eah11_tv_pkey; Type: CONSTRAINT; Schema: yeah_2011; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY eah11_tv
    ADD CONSTRAINT eah11_tv_pkey PRIMARY KEY (nenc, nhogar, miembro);


--
-- Name: eah11_un_pkey; Type: CONSTRAINT; Schema: yeah_2011; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY eah11_un
    ADD CONSTRAINT eah11_un_pkey PRIMARY KEY (nenc, nhogar, miembro, relacion);


--
-- Name: eah11_viv_s1a1_pkey; Type: CONSTRAINT; Schema: yeah_2011; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY eah11_viv_s1a1
    ADD CONSTRAINT eah11_viv_s1a1_pkey PRIMARY KEY (nenc, nhogar);


--
-- Name: estados_est_nombre_key; Type: CONSTRAINT; Schema: yeah_2011; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY estados
    ADD CONSTRAINT estados_est_nombre_key UNIQUE (est_nombre);


--
-- Name: estados_pkey; Type: CONSTRAINT; Schema: yeah_2011; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY estados
    ADD CONSTRAINT estados_pkey PRIMARY KEY (est_est);


--
-- Name: excepciones_pkey; Type: CONSTRAINT; Schema: yeah_2011; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY excepciones
    ADD CONSTRAINT excepciones_pkey PRIMARY KEY (exc_encues);


--
-- Name: inconsistencias_pkey; Type: CONSTRAINT; Schema: yeah_2011; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY inconsistencias
    ADD CONSTRAINT inconsistencias_pkey PRIMARY KEY (inc_con, inc_nenc, inc_nhogar, inc_miembro_ex_0, inc_relacion_0);


--
-- Name: per_per_pkey; Type: CONSTRAINT; Schema: yeah_2011; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY personal
    ADD CONSTRAINT per_per_pkey PRIMARY KEY (per_per);


--
-- Name: personal_per_rol_per_per_key; Type: CONSTRAINT; Schema: yeah_2011; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY personal
    ADD CONSTRAINT personal_per_rol_per_per_key UNIQUE (per_rol, per_per);


--
-- Name: respuestas_pkey; Type: CONSTRAINT; Schema: yeah_2011; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY respuestas
    ADD CONSTRAINT respuestas_pkey PRIMARY KEY (res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var);


--
-- Name: tem11_id_proc_key; Type: CONSTRAINT; Schema: yeah_2011; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY tem11
    ADD CONSTRAINT tem11_id_proc_key UNIQUE (id_proc);


--
-- Name: tem11_pkey; Type: CONSTRAINT; Schema: yeah_2011; Owner: yeahowner; Tablespace: 
--

ALTER TABLE ONLY tem11
    ADD CONSTRAINT tem11_pkey PRIMARY KEY (encues);


SET search_path = his, pg_catalog;

--
-- Name: his_inconsistencias_idx; Type: INDEX; Schema: his; Owner: yeahowner; Tablespace: 
--

CREATE INDEX his_inconsistencias_idx ON his_inconsistencias USING btree (inc_con, inc_nenc, inc_nhogar, inc_miembro_ex_0, inc_relacion_0);


--
-- Name: his_respuestas_i; Type: INDEX; Schema: his; Owner: yeahowner; Tablespace: 
--

CREATE INDEX his_respuestas_i ON his_respuestas USING btree (res_encuesta, res_hogar, res_miembro, res_ex_miembro, res_relacion, res_var, res_fec_ult_mod);


SET search_path = yeah_2011, pg_catalog;

--
-- Name: bolsa_cerrar_trg; Type: TRIGGER; Schema: yeah_2011; Owner: yeahowner
--

CREATE TRIGGER bolsa_cerrar_trg AFTER UPDATE ON bolsas FOR EACH ROW EXECUTE PROCEDURE bolsa_nueva_trg();


--
-- Name: his_inconsistencias_trg; Type: TRIGGER; Schema: yeah_2011; Owner: yeahowner
--

CREATE TRIGGER his_inconsistencias_trg BEFORE INSERT OR DELETE ON inconsistencias FOR EACH ROW EXECUTE PROCEDURE his_inconsistencias_trg();


--
-- Name: res_eah11_ex_del; Type: TRIGGER; Schema: yeah_2011; Owner: yeahowner
--

CREATE TRIGGER res_eah11_ex_del BEFORE DELETE ON eah11_ex FOR EACH ROW EXECUTE PROCEDURE res_eah11_ex_del();


--
-- Name: res_eah11_ex_ins; Type: TRIGGER; Schema: yeah_2011; Owner: yeahowner
--

CREATE TRIGGER res_eah11_ex_ins BEFORE INSERT ON eah11_ex FOR EACH ROW EXECUTE PROCEDURE res_eah11_ex_ins();


--
-- Name: res_eah11_ex_upd; Type: TRIGGER; Schema: yeah_2011; Owner: yeahowner
--

CREATE TRIGGER res_eah11_ex_upd BEFORE UPDATE ON eah11_ex FOR EACH ROW EXECUTE PROCEDURE res_eah11_ex_upd();


--
-- Name: res_eah11_fam_del; Type: TRIGGER; Schema: yeah_2011; Owner: yeahowner
--

CREATE TRIGGER res_eah11_fam_del BEFORE DELETE ON eah11_fam FOR EACH ROW EXECUTE PROCEDURE res_eah11_fam_del();


--
-- Name: res_eah11_fam_ins; Type: TRIGGER; Schema: yeah_2011; Owner: yeahowner
--

CREATE TRIGGER res_eah11_fam_ins BEFORE INSERT ON eah11_fam FOR EACH ROW EXECUTE PROCEDURE res_eah11_fam_ins();


--
-- Name: res_eah11_fam_upd; Type: TRIGGER; Schema: yeah_2011; Owner: yeahowner
--

CREATE TRIGGER res_eah11_fam_upd BEFORE UPDATE ON eah11_fam FOR EACH ROW EXECUTE PROCEDURE res_eah11_fam_upd();


--
-- Name: res_eah11_i1_del; Type: TRIGGER; Schema: yeah_2011; Owner: yeahowner
--

CREATE TRIGGER res_eah11_i1_del BEFORE DELETE ON eah11_i1 FOR EACH ROW EXECUTE PROCEDURE res_eah11_i1_del();


--
-- Name: res_eah11_i1_ins; Type: TRIGGER; Schema: yeah_2011; Owner: yeahowner
--

CREATE TRIGGER res_eah11_i1_ins BEFORE INSERT ON eah11_i1 FOR EACH ROW EXECUTE PROCEDURE res_eah11_i1_ins();


--
-- Name: res_eah11_i1_upd; Type: TRIGGER; Schema: yeah_2011; Owner: yeahowner
--

CREATE TRIGGER res_eah11_i1_upd BEFORE UPDATE ON eah11_i1 FOR EACH ROW EXECUTE PROCEDURE res_eah11_i1_upd();


--
-- Name: res_eah11_md_del; Type: TRIGGER; Schema: yeah_2011; Owner: yeahowner
--

CREATE TRIGGER res_eah11_md_del BEFORE DELETE ON eah11_md FOR EACH ROW EXECUTE PROCEDURE res_eah11_md_del();


--
-- Name: res_eah11_md_ins; Type: TRIGGER; Schema: yeah_2011; Owner: yeahowner
--

CREATE TRIGGER res_eah11_md_ins BEFORE INSERT ON eah11_md FOR EACH ROW EXECUTE PROCEDURE res_eah11_md_ins();


--
-- Name: res_eah11_md_upd; Type: TRIGGER; Schema: yeah_2011; Owner: yeahowner
--

CREATE TRIGGER res_eah11_md_upd BEFORE UPDATE ON eah11_md FOR EACH ROW EXECUTE PROCEDURE res_eah11_md_upd();


--
-- Name: res_eah11_un_del; Type: TRIGGER; Schema: yeah_2011; Owner: yeahowner
--

CREATE TRIGGER res_eah11_un_del BEFORE DELETE ON eah11_un FOR EACH ROW EXECUTE PROCEDURE res_eah11_un_del();


--
-- Name: res_eah11_un_ins; Type: TRIGGER; Schema: yeah_2011; Owner: yeahowner
--

CREATE TRIGGER res_eah11_un_ins BEFORE INSERT ON eah11_un FOR EACH ROW EXECUTE PROCEDURE res_eah11_un_ins();


--
-- Name: res_eah11_un_upd; Type: TRIGGER; Schema: yeah_2011; Owner: yeahowner
--

CREATE TRIGGER res_eah11_un_upd BEFORE UPDATE ON eah11_un FOR EACH ROW EXECUTE PROCEDURE res_eah11_un_upd();


--
-- Name: res_eah11_viv_s1a1_del; Type: TRIGGER; Schema: yeah_2011; Owner: yeahowner
--

CREATE TRIGGER res_eah11_viv_s1a1_del BEFORE DELETE ON eah11_viv_s1a1 FOR EACH ROW EXECUTE PROCEDURE res_eah11_viv_s1a1_del();


--
-- Name: res_eah11_viv_s1a1_ins; Type: TRIGGER; Schema: yeah_2011; Owner: yeahowner
--

CREATE TRIGGER res_eah11_viv_s1a1_ins BEFORE INSERT ON eah11_viv_s1a1 FOR EACH ROW EXECUTE PROCEDURE res_eah11_viv_s1a1_ins();


--
-- Name: res_eah11_viv_s1a1_upd; Type: TRIGGER; Schema: yeah_2011; Owner: yeahowner
--

CREATE TRIGGER res_eah11_viv_s1a1_upd BEFORE UPDATE ON eah11_viv_s1a1 FOR EACH ROW EXECUTE PROCEDURE res_eah11_viv_s1a1_upd();


--
-- Name: res_his_del; Type: TRIGGER; Schema: yeah_2011; Owner: yeahowner
--

CREATE TRIGGER res_his_del BEFORE DELETE ON respuestas FOR EACH ROW EXECUTE PROCEDURE res_his_del();


--
-- Name: res_his_ins; Type: TRIGGER; Schema: yeah_2011; Owner: yeahowner
--

CREATE TRIGGER res_his_ins BEFORE INSERT ON respuestas FOR EACH ROW EXECUTE PROCEDURE res_his_ins();


--
-- Name: res_his_upd; Type: TRIGGER; Schema: yeah_2011; Owner: yeahowner
--

CREATE TRIGGER res_his_upd BEFORE UPDATE ON respuestas FOR EACH ROW EXECUTE PROCEDURE res_his_upd();


--
-- Name: tem_dominio_trg; Type: TRIGGER; Schema: yeah_2011; Owner: yeahowner
--

CREATE TRIGGER tem_dominio_trg BEFORE UPDATE ON tem11 FOR EACH ROW EXECUTE PROCEDURE tem_dominio_trg();


--
-- Name: tem_estado_2011_trg; Type: TRIGGER; Schema: yeah_2011; Owner: yeahowner
--

CREATE TRIGGER tem_estado_2011_trg BEFORE UPDATE ON tem11 FOR EACH ROW EXECUTE PROCEDURE tem_estado_trg();


SET search_path = test, pg_catalog;

--
-- Name: t_formus_for_enc_fkey; Type: FK CONSTRAINT; Schema: test; Owner: yeahowner
--

ALTER TABLE ONLY t_formus
    ADD CONSTRAINT t_formus_for_enc_fkey FOREIGN KEY (for_enc) REFERENCES t_encues(enc_enc);


--
-- Name: t_opcios_opc_enc_fkey; Type: FK CONSTRAINT; Schema: test; Owner: yeahowner
--

ALTER TABLE ONLY t_opcios
    ADD CONSTRAINT t_opcios_opc_enc_fkey FOREIGN KEY (opc_enc, opc_for, opc_pre) REFERENCES t_pregus(pre_enc, pre_for, pre_pre);


--
-- Name: t_opcios_opc_enc_fkey1; Type: FK CONSTRAINT; Schema: test; Owner: yeahowner
--

ALTER TABLE ONLY t_opcios
    ADD CONSTRAINT t_opcios_opc_enc_fkey1 FOREIGN KEY (opc_enc, opc_for, opc_pre_salta) REFERENCES t_pregus(pre_enc, pre_for, pre_pre);


--
-- Name: t_pregus_pre_enc_fkey; Type: FK CONSTRAINT; Schema: test; Owner: yeahowner
--

ALTER TABLE ONLY t_pregus
    ADD CONSTRAINT t_pregus_pre_enc_fkey FOREIGN KEY (pre_enc, pre_for) REFERENCES t_formus(for_enc, for_for);


SET search_path = yeah_2011, pg_catalog;

--
-- Name: eah11_fam_nenc_fkey; Type: FK CONSTRAINT; Schema: yeah_2011; Owner: yeahowner
--

ALTER TABLE ONLY eah11_fam
    ADD CONSTRAINT eah11_fam_nenc_fkey FOREIGN KEY (nenc, nhogar) REFERENCES eah11_viv_s1a1(nenc, nhogar);


--
-- Name: eah11_i1_nenc_fkey; Type: FK CONSTRAINT; Schema: yeah_2011; Owner: yeahowner
--

ALTER TABLE ONLY eah11_i1
    ADD CONSTRAINT eah11_i1_nenc_fkey FOREIGN KEY (nenc, nhogar, miembro) REFERENCES eah11_fam(nenc, nhogar, p0);


--
-- Name: eah11_md_nenc_fkey; Type: FK CONSTRAINT; Schema: yeah_2011; Owner: yeahowner
--

ALTER TABLE ONLY eah11_md
    ADD CONSTRAINT eah11_md_nenc_fkey FOREIGN KEY (nenc, nhogar, miembro) REFERENCES eah11_fam(nenc, nhogar, p0);


--
-- Name: eah11_tv_nenc_fkey; Type: FK CONSTRAINT; Schema: yeah_2011; Owner: yeahowner
--

ALTER TABLE ONLY eah11_tv
    ADD CONSTRAINT eah11_tv_nenc_fkey FOREIGN KEY (nenc, nhogar, miembro) REFERENCES eah11_fam(nenc, nhogar, p0);


--
-- Name: eah11_un_nenc_fkey; Type: FK CONSTRAINT; Schema: yeah_2011; Owner: yeahowner
--

ALTER TABLE ONLY eah11_un
    ADD CONSTRAINT eah11_un_nenc_fkey FOREIGN KEY (nenc, nhogar, miembro) REFERENCES eah11_fam(nenc, nhogar, p0);


--
-- Name: encues_fkey; Type: FK CONSTRAINT; Schema: yeah_2011; Owner: yeahowner
--

ALTER TABLE ONLY excepciones
    ADD CONSTRAINT encues_fkey FOREIGN KEY (exc_encues) REFERENCES tem11(encues) ON UPDATE CASCADE;


--
-- Name: fk_comuna; Type: FK CONSTRAINT; Schema: yeah_2011; Owner: yeahowner
--

ALTER TABLE ONLY tem11
    ADD CONSTRAINT fk_comuna FOREIGN KEY (comuna) REFERENCES comunas(comuna_comuna);


--
-- Name: fk_personal; Type: FK CONSTRAINT; Schema: yeah_2011; Owner: yeahowner
--

ALTER TABLE ONLY personal
    ADD CONSTRAINT fk_personal FOREIGN KEY (per_comuna) REFERENCES comunas(comuna_comuna);


--
-- Name: fk_poseedor_poseedor_rol; Type: FK CONSTRAINT; Schema: yeah_2011; Owner: yeahowner
--

ALTER TABLE ONLY tem11
    ADD CONSTRAINT fk_poseedor_poseedor_rol FOREIGN KEY (rol_poseedor, poseedor) REFERENCES personal(per_rol, per_per);


--
-- Name: fk_rep_recep; Type: FK CONSTRAINT; Schema: yeah_2011; Owner: yeahowner
--

ALTER TABLE ONLY comunas
    ADD CONSTRAINT fk_rep_recep FOREIGN KEY (comuna_cte_recep, comuna_cod_recep) REFERENCES personal(per_rol, per_per);


--
-- Name: fk_rep_recu; Type: FK CONSTRAINT; Schema: yeah_2011; Owner: yeahowner
--

ALTER TABLE ONLY comunas
    ADD CONSTRAINT fk_rep_recu FOREIGN KEY (comuna_cte_recu, comuna_cod_recu) REFERENCES personal(per_rol, per_per);


--
-- Name: fk_rep_subcoor; Type: FK CONSTRAINT; Schema: yeah_2011; Owner: yeahowner
--

ALTER TABLE ONLY comunas
    ADD CONSTRAINT fk_rep_subcoor FOREIGN KEY (comuna_cte_subcoor, comuna_cod_subcoor) REFERENCES personal(per_rol, per_per);


--
-- Name: fk_rep_super; Type: FK CONSTRAINT; Schema: yeah_2011; Owner: yeahowner
--

ALTER TABLE ONLY comunas
    ADD CONSTRAINT fk_rep_super FOREIGN KEY (comuna_cte_sup, comuna_cod_sup) REFERENCES personal(per_rol, per_per);


--
-- Name: inconsistencias_inc_con_fkey; Type: FK CONSTRAINT; Schema: yeah_2011; Owner: yeahowner
--

ALTER TABLE ONLY inconsistencias
    ADD CONSTRAINT inconsistencias_inc_con_fkey FOREIGN KEY (inc_con) REFERENCES yeah.consistencias(con_con);


--
-- Name: inconsistencias_inc_nenc_fkey; Type: FK CONSTRAINT; Schema: yeah_2011; Owner: yeahowner
--

ALTER TABLE ONLY inconsistencias
    ADD CONSTRAINT inconsistencias_inc_nenc_fkey FOREIGN KEY (inc_nenc) REFERENCES tem11(encues);


--
-- Name: pk_codigo_norea; Type: FK CONSTRAINT; Schema: yeah_2011; Owner: yeahowner
--

ALTER TABLE ONLY tem11
    ADD CONSTRAINT pk_codigo_norea FOREIGN KEY (norea_enc) REFERENCES yeah.norea(norea_norea);


--
-- Name: pk_codigo_norea_modulo_discapacidad; Type: FK CONSTRAINT; Schema: yeah_2011; Owner: yeahowner
--

ALTER TABLE ONLY tem11
    ADD CONSTRAINT pk_codigo_norea_modulo_discapacidad FOREIGN KEY (norea_modulo) REFERENCES yeah.noreamd(noreamd_noreamd);


--
-- Name: pk_codigo_norea_recu; Type: FK CONSTRAINT; Schema: yeah_2011; Owner: yeahowner
--

ALTER TABLE ONLY tem11
    ADD CONSTRAINT pk_codigo_norea_recu FOREIGN KEY (norea_recu) REFERENCES yeah.norea(norea_norea);


--
-- Name: pk_codigo_norea_recu_modulo_discapacidad; Type: FK CONSTRAINT; Schema: yeah_2011; Owner: yeahowner
--

ALTER TABLE ONLY tem11
    ADD CONSTRAINT pk_codigo_norea_recu_modulo_discapacidad FOREIGN KEY (norea_recu_modu) REFERENCES yeah.noreamd(noreamd_noreamd);


--
-- Name: pk_codigo_rea; Type: FK CONSTRAINT; Schema: yeah_2011; Owner: yeahowner
--

ALTER TABLE ONLY tem11
    ADD CONSTRAINT pk_codigo_rea FOREIGN KEY (rea) REFERENCES yeah.rea(rea_rea);


--
-- Name: pk_codigo_sup_campo; Type: FK CONSTRAINT; Schema: yeah_2011; Owner: yeahowner
--

ALTER TABLE ONLY tem11
    ADD CONSTRAINT pk_codigo_sup_campo FOREIGN KEY (sup_campo) REFERENCES yeah.sup_campo(supcampo_supcampo);


--
-- Name: pk_codigo_sup_recu_campo; Type: FK CONSTRAINT; Schema: yeah_2011; Owner: yeahowner
--

ALTER TABLE ONLY tem11
    ADD CONSTRAINT pk_codigo_sup_recu_campo FOREIGN KEY (sup_recu_campo) REFERENCES yeah.sup_recu_campo(suprecucampo_suprecucampo);


--
-- Name: pk_codigo_sup_tel; Type: FK CONSTRAINT; Schema: yeah_2011; Owner: yeahowner
--

ALTER TABLE ONLY tem11
    ADD CONSTRAINT pk_codigo_sup_tel FOREIGN KEY (sup_tel) REFERENCES yeah.sup_tel(suptel_suptel);


--
-- Name: pk_rea_modulo; Type: FK CONSTRAINT; Schema: yeah_2011; Owner: yeahowner
--

ALTER TABLE ONLY tem11
    ADD CONSTRAINT pk_rea_modulo FOREIGN KEY (rea_modulo) REFERENCES yeah.rea_modulo(reamodu_reamodu);


--
-- Name: pk_rea_recu_modulo; Type: FK CONSTRAINT; Schema: yeah_2011; Owner: yeahowner
--

ALTER TABLE ONLY tem11
    ADD CONSTRAINT pk_rea_recu_modulo FOREIGN KEY (rea_recu_modu) REFERENCES yeah.rea_modulo(reamodu_reamodu);


--
-- Name: pk_roles_personal; Type: FK CONSTRAINT; Schema: yeah_2011; Owner: yeahowner
--

ALTER TABLE ONLY personal
    ADD CONSTRAINT pk_roles_personal FOREIGN KEY (per_rol) REFERENCES yeah.roles(rol_rol);


--
-- Name: tem11_bolsa_fkey; Type: FK CONSTRAINT; Schema: yeah_2011; Owner: yeahowner
--

ALTER TABLE ONLY tem11
    ADD CONSTRAINT tem11_bolsa_fkey FOREIGN KEY (bolsa) REFERENCES bolsas(bolsa_bolsa);


--
-- Name: tem11_cod_ana_campo_fkey; Type: FK CONSTRAINT; Schema: yeah_2011; Owner: yeahowner
--

ALTER TABLE ONLY tem11
    ADD CONSTRAINT tem11_cod_ana_campo_fkey FOREIGN KEY (cod_ana_campo) REFERENCES yeah.usuarios(usu_usu);


--
-- Name: tem11_cod_ana_ing_fkey; Type: FK CONSTRAINT; Schema: yeah_2011; Owner: yeahowner
--

ALTER TABLE ONLY tem11
    ADD CONSTRAINT tem11_cod_ana_ing_fkey FOREIGN KEY (cod_ana_ing) REFERENCES yeah.usuarios(usu_usu);


--
-- Name: tem11_cod_procesamiento_fkey; Type: FK CONSTRAINT; Schema: yeah_2011; Owner: yeahowner
--

ALTER TABLE ONLY tem11
    ADD CONSTRAINT tem11_cod_procesamiento_fkey FOREIGN KEY (cod_procesamiento) REFERENCES yeah.usuarios(usu_usu);


--
-- Name: tem11_estado_fkey; Type: FK CONSTRAINT; Schema: yeah_2011; Owner: yeahowner
--

ALTER TABLE ONLY tem11
    ADD CONSTRAINT tem11_estado_fkey FOREIGN KEY (estado) REFERENCES estados(est_est);


--
-- Name: his; Type: ACL; Schema: -; Owner: yeahowner
--

REVOKE ALL ON SCHEMA his FROM PUBLIC;
REVOKE ALL ON SCHEMA his FROM yeahowner;
GRANT ALL ON SCHEMA his TO yeahowner;
GRANT USAGE ON SCHEMA his TO yeah_test;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: test; Type: ACL; Schema: -; Owner: yeahowner
--

REVOKE ALL ON SCHEMA test FROM PUBLIC;
REVOKE ALL ON SCHEMA test FROM yeahowner;
GRANT ALL ON SCHEMA test TO yeahowner;
GRANT ALL ON SCHEMA test TO yeah_test;


--
-- Name: yeah_2011; Type: ACL; Schema: -; Owner: yeahowner
--

REVOKE ALL ON SCHEMA yeah_2011 FROM PUBLIC;
REVOKE ALL ON SCHEMA yeah_2011 FROM yeahowner;
GRANT ALL ON SCHEMA yeah_2011 TO yeahowner;
GRANT USAGE ON SCHEMA yeah_2011 TO yeah_mues_campo;
GRANT USAGE ON SCHEMA yeah_2011 TO yeah_test;


SET search_path = his, pg_catalog;

--
-- Name: his_inconsistencias; Type: ACL; Schema: his; Owner: yeahowner
--

REVOKE ALL ON TABLE his_inconsistencias FROM PUBLIC;
REVOKE ALL ON TABLE his_inconsistencias FROM yeahowner;
GRANT ALL ON TABLE his_inconsistencias TO yeahowner;
GRANT SELECT ON TABLE his_inconsistencias TO yeah_test;


--
-- Name: modificaciones; Type: ACL; Schema: his; Owner: yeahowner
--

REVOKE ALL ON TABLE modificaciones FROM PUBLIC;
REVOKE ALL ON TABLE modificaciones FROM yeahowner;
GRANT ALL ON TABLE modificaciones TO yeahowner;
GRANT SELECT ON TABLE modificaciones TO yeah_test;


SET search_path = yeah_2011, pg_catalog;

--
-- Name: bolsas; Type: ACL; Schema: yeah_2011; Owner: yeahowner
--

REVOKE ALL ON TABLE bolsas FROM PUBLIC;
REVOKE ALL ON TABLE bolsas FROM yeahowner;
GRANT ALL ON TABLE bolsas TO yeahowner;
GRANT SELECT ON TABLE bolsas TO yeah_test;


--
-- Name: comunas; Type: ACL; Schema: yeah_2011; Owner: yeahowner
--

REVOKE ALL ON TABLE comunas FROM PUBLIC;
REVOKE ALL ON TABLE comunas FROM yeahowner;
GRANT ALL ON TABLE comunas TO yeahowner;
GRANT SELECT ON TABLE comunas TO yeah_test;


--
-- Name: con_var; Type: ACL; Schema: yeah_2011; Owner: yeahowner
--

REVOKE ALL ON TABLE con_var FROM PUBLIC;
REVOKE ALL ON TABLE con_var FROM yeahowner;
GRANT ALL ON TABLE con_var TO yeahowner;
GRANT SELECT ON TABLE con_var TO yeah_test;


--
-- Name: eah11_ex; Type: ACL; Schema: yeah_2011; Owner: yeahowner
--

REVOKE ALL ON TABLE eah11_ex FROM PUBLIC;
REVOKE ALL ON TABLE eah11_ex FROM yeahowner;
GRANT ALL ON TABLE eah11_ex TO yeahowner;
GRANT SELECT ON TABLE eah11_ex TO yeah_test;


--
-- Name: eah11_fam; Type: ACL; Schema: yeah_2011; Owner: yeahowner
--

REVOKE ALL ON TABLE eah11_fam FROM PUBLIC;
REVOKE ALL ON TABLE eah11_fam FROM yeahowner;
GRANT ALL ON TABLE eah11_fam TO yeahowner;
GRANT SELECT ON TABLE eah11_fam TO yeah_test;


--
-- Name: eah11_i1; Type: ACL; Schema: yeah_2011; Owner: yeahowner
--

REVOKE ALL ON TABLE eah11_i1 FROM PUBLIC;
REVOKE ALL ON TABLE eah11_i1 FROM yeahowner;
GRANT ALL ON TABLE eah11_i1 TO yeahowner;
GRANT SELECT ON TABLE eah11_i1 TO yeah_test;


--
-- Name: eah11_md; Type: ACL; Schema: yeah_2011; Owner: yeahowner
--

REVOKE ALL ON TABLE eah11_md FROM PUBLIC;
REVOKE ALL ON TABLE eah11_md FROM yeahowner;
GRANT ALL ON TABLE eah11_md TO yeahowner;
GRANT SELECT ON TABLE eah11_md TO yeah_test;


--
-- Name: eah11_tv; Type: ACL; Schema: yeah_2011; Owner: yeahowner
--

REVOKE ALL ON TABLE eah11_tv FROM PUBLIC;
REVOKE ALL ON TABLE eah11_tv FROM yeahowner;
GRANT ALL ON TABLE eah11_tv TO yeahowner;
GRANT SELECT ON TABLE eah11_tv TO yeah_test;


--
-- Name: eah11_un; Type: ACL; Schema: yeah_2011; Owner: yeahowner
--

REVOKE ALL ON TABLE eah11_un FROM PUBLIC;
REVOKE ALL ON TABLE eah11_un FROM yeahowner;
GRANT ALL ON TABLE eah11_un TO yeahowner;
GRANT SELECT ON TABLE eah11_un TO yeah_test;


--
-- Name: eah11_viv_s1a1; Type: ACL; Schema: yeah_2011; Owner: yeahowner
--

REVOKE ALL ON TABLE eah11_viv_s1a1 FROM PUBLIC;
REVOKE ALL ON TABLE eah11_viv_s1a1 FROM yeahowner;
GRANT ALL ON TABLE eah11_viv_s1a1 TO yeahowner;
GRANT SELECT ON TABLE eah11_viv_s1a1 TO yeah_test;


--
-- Name: estados; Type: ACL; Schema: yeah_2011; Owner: yeahowner
--

REVOKE ALL ON TABLE estados FROM PUBLIC;
REVOKE ALL ON TABLE estados FROM yeahowner;
GRANT ALL ON TABLE estados TO yeahowner;
GRANT SELECT ON TABLE estados TO yeah_test;


--
-- Name: excepciones; Type: ACL; Schema: yeah_2011; Owner: yeahowner
--

REVOKE ALL ON TABLE excepciones FROM PUBLIC;
REVOKE ALL ON TABLE excepciones FROM yeahowner;
GRANT ALL ON TABLE excepciones TO yeahowner;


--
-- Name: inconsistencias; Type: ACL; Schema: yeah_2011; Owner: yeahowner
--

REVOKE ALL ON TABLE inconsistencias FROM PUBLIC;
REVOKE ALL ON TABLE inconsistencias FROM yeahowner;
GRANT ALL ON TABLE inconsistencias TO yeahowner;
GRANT SELECT ON TABLE inconsistencias TO yeah_test;


--
-- Name: personal; Type: ACL; Schema: yeah_2011; Owner: yeahowner
--

REVOKE ALL ON TABLE personal FROM PUBLIC;
REVOKE ALL ON TABLE personal FROM yeahowner;
GRANT ALL ON TABLE personal TO yeahowner;
GRANT SELECT ON TABLE personal TO yeah_test;


--
-- Name: tem11; Type: ACL; Schema: yeah_2011; Owner: yeahowner
--

REVOKE ALL ON TABLE tem11 FROM PUBLIC;
REVOKE ALL ON TABLE tem11 FROM yeahowner;
GRANT ALL ON TABLE tem11 TO yeahowner;
GRANT SELECT ON TABLE tem11 TO yeah_mues_campo;
GRANT SELECT ON TABLE tem11 TO yeah_test;


--
-- PostgreSQL database dump complete
--

