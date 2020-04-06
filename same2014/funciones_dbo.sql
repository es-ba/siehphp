CREATE OR REPLACE FUNCTION dbo.ope_actual()
  RETURNS text AS
$BODY$
begin
	return 'same2014';
end;
$BODY$
  LANGUAGE plpgsql IMMUTABLE;
/*otra*/
CREATE OR REPLACE FUNCTION dbo.anio()
  RETURNS integer AS
$BODY$
begin
	return 2014;
end;
$BODY$
  LANGUAGE plpgsql IMMUTABLE;
/*otra*/
CREATE OR REPLACE FUNCTION dbo.anionac(p_enc integer, p_hog integer, p_mie integer)
  RETURNS integer 
  LANGUAGE sql STABLE
AS  
$BODY$
    select pla_f_nac_a 
      from plana_s1_p
      where pla_enc = p_enc and pla_hog = p_hog and pla_mie = p_mie;
$BODY$;
/*otra*/
CREATE OR REPLACE FUNCTION dbo.cantex(p_enc integer, p_hog integer)
  RETURNS integer AS
$BODY$
DECLARE
 v_cantidad integer;
BEGIN 
  select count(*) into v_cantidad 
  from encu.respuestas where res_ope=dbo.ope_actual() and res_for='A1'  and res_mat='X' and res_enc=p_enc and res_hog=p_hog and res_var='ex_miembro';
  return v_cantidad;
END;
$BODY$
  LANGUAGE plpgsql STABLE;
/*otra*/
CREATE OR REPLACE FUNCTION dbo.dma_a_fecha(p_dia integer, p_mes integer, p_annio integer)
  RETURNS date AS
$BODY$
begin 
 return to_date(p_annio||'/'||p_mes||'/'||p_dia,'YYYY/MM/DD');
end;
$BODY$
  LANGUAGE plpgsql IMMUTABLE;
/*otra*/
CREATE OR REPLACE FUNCTION dbo.texto_a_fecha(p_valor text)
  RETURNS date AS
$BODY$
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
$BODY$
  LANGUAGE plpgsql IMMUTABLE;
/*otra*/
CREATE OR REPLACE FUNCTION dbo.edad_a_la_fecha(p_f_nac text, p_f_realiz text)
  RETURNS integer AS
$BODY$
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
$BODY$
  LANGUAGE plpgsql IMMUTABLE;
/*otra*/
CREATE OR REPLACE FUNCTION dbo.edadfamiliar(p_enc integer, p_hog integer, p_mie integer)
RETURNS integer AS
$BODY$
DECLARE v_edad integer;
BEGIN
	v_edad := 0;
	select res_valor from encu.respuestas 
	where res_ope=dbo.ope_actual() and res_for='S1' and res_mat='P' and res_enc = p_enc and res_hog = p_hog and res_mie = p_mie and res_var='edad' into v_edad;
	return v_edad;	
END;
$BODY$
LANGUAGE plpgsql STABLE;
/*otra*/
CREATE OR REPLACE FUNCTION dbo.edadjefe(p_enc integer, p_nhogar integer)
  RETURNS integer AS
$BODY$
DECLARE v_edad_jefe integer;
BEGIN
	v_edad_jefe := 0;
	select res_valor into v_edad_jefe from encu.respuestas where res_ope=dbo.ope_actual() and res_for='S1' and res_mat='P' and res_enc = p_enc and res_hog = p_nhogar and res_mie = 1 and res_var = 'edad';
	return v_edad_jefe;	
END;
$BODY$
  LANGUAGE plpgsql STABLE;
/*otra*/
CREATE OR REPLACE FUNCTION dbo.es_fecha(valor text)
  RETURNS integer AS
$BODY$
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
$BODY$
  LANGUAGE plpgsql IMMUTABLE;
/*otra*/
CREATE OR REPLACE FUNCTION dbo.estadofamiliar(p_enc integer, p_hog integer, p_mie integer)
  RETURNS integer AS
$BODY$
DECLARE v_estado integer;
BEGIN
	v_estado := 0;
	select res_valor from encu.respuestas
	where res_ope=dbo.ope_actual() and res_for='S1' and res_mat='P' and res_enc = p_enc and res_hog = p_hog and res_mie = p_mie and res_var = 'p5b' into v_estado;
	return v_estado;
END;
$BODY$
  LANGUAGE plpgsql STABLE;
/*otra*/
CREATE OR REPLACE FUNCTION dbo.estadojefe(p_enc integer, p_hog integer)
  RETURNS integer AS
$BODY$
declare v_estadojefe text;
begin
    select res_valor into v_estadojefe from encu.respuestas 
    where res_ope=dbo.ope_actual() and res_for='S1' and res_mat='P' and res_enc = p_enc and res_hog = p_hog and res_var = 'p5' and res_mie in (select res_mie from encu.respuestas where res_enc=p_enc and res_hog=p_hog and res_var ='p4' and (res_valor ='1') limit 1);
    return v_estadojefe;
end;
$BODY$
  LANGUAGE plpgsql STABLE;
/*otra*/
CREATE OR REPLACE FUNCTION dbo.existe_hogar(p_enc integer, p_hog integer)
  RETURNS integer AS
$BODY$
DECLARE v_existe integer;
BEGIN
    v_existe := count(distinct (res_hog)) from encu.respuestas where res_ope=dbo.ope_actual() and res_enc = p_enc and res_hog = p_hog;
    return v_existe;
END;
$BODY$
  LANGUAGE plpgsql STABLE;
/*otra*/
CREATE OR REPLACE FUNCTION dbo.existejefe(p_enc integer, p_hog integer)
  RETURNS integer AS
$BODY$
DECLARE v_cantjefes integer;
BEGIN
    v_cantjefes := count(*) from encu.respuestas where res_ope=dbo.ope_actual() and res_for='S1' and res_mat='P' and res_enc = p_enc and res_hog = p_hog and res_var = 'p4' and res_valor ='1';
    if (v_cantjefes > 1) then
	v_cantjefes := 2;
    end if;
    return v_cantjefes;
END;
$BODY$
  LANGUAGE plpgsql STABLE;
/*otra*/
CREATE OR REPLACE FUNCTION dbo.existemiembro(p_enc integer, p_hog integer, p_mie integer)
  RETURNS integer AS
$BODY$
DECLARE v_existe integer;
BEGIN
    v_existe := count(distinct (res_mie)) from encu.respuestas where res_ope=dbo.ope_actual() and res_for='S1' and res_mat='P' and res_enc = p_enc and res_hog = p_hog and res_mie = p_mie;
    return v_existe;
END;
$BODY$
  LANGUAGE plpgsql STABLE;
/*otra*/
CREATE OR REPLACE FUNCTION dbo.nroconyuges(p_enc integer, p_hog integer)
  RETURNS integer AS
$BODY$
DECLARE v_nroconyuges integer;
BEGIN
    v_nroconyuges := count(*) from encu.respuestas where res_ope=dbo.ope_actual() and res_for='S1' and res_mat='P' and res_enc=p_enc and res_hog=p_hog and res_var='p4' and (res_valor='2');
    return v_nroconyuges;
END;
$BODY$
  LANGUAGE plpgsql STABLE;
/*otra*/
CREATE OR REPLACE FUNCTION dbo.nrojefes(p_enc integer, p_hog integer)
  RETURNS integer AS
$BODY$
DECLARE v_cantjefes integer;
BEGIN
    v_cantjefes := count(*) from encu.respuestas where res_ope=dbo.ope_actual() and res_for='S1' and res_mat='P' and res_enc = p_enc and res_hog = p_hog and res_var = 'p4' and res_valor ='1';
    return v_cantjefes;
END;
$BODY$
  LANGUAGE plpgsql STABLE;
/*otra*/
CREATE OR REPLACE FUNCTION dbo.p5bfamiliar(p_enc integer, p_hog integer, p_mie integer)
  RETURNS integer AS
$BODY$
declare 
  v_p5b integer;
begin
  select res_valor
    into v_p5b 
    from encu.respuestas where res_ope=dbo.ope_actual() and res_for='S1' and res_mat='P' and res_enc = p_enc and res_hog = p_hog and res_mie=p_mie and res_var = 'p5b';
  return v_p5b;
end;
$BODY$
  LANGUAGE plpgsql STABLE;
/*otra*/
CREATE OR REPLACE FUNCTION dbo.sexofamiliar(p_enc integer, p_hog integer, p_mie integer)
  RETURNS integer AS
$BODY$
DECLARE v_sexo integer;
BEGIN
    select res_valor::integer into v_sexo from encu.respuestas where res_ope=dbo.ope_actual() and res_for='S1' and res_mat='P' and res_enc = p_enc and res_hog = p_hog and res_mie=p_mie and res_var = 'sexo';
    if v_sexo in(1,2) then
	return v_sexo;
    else
	return 0;
    end if;	
END;
$BODY$
  LANGUAGE plpgsql STABLE;
/*otra*/
CREATE OR REPLACE FUNCTION dbo.sexojefe(p_enc integer, p_hog integer)
  RETURNS integer AS
$BODY$
DECLARE v_sexojefe integer;
BEGIN
    select res_valor::integer into v_sexojefe from encu.respuestas where res_ope=dbo.ope_actual() and res_for='S1' and res_mat='P' and res_enc = p_enc and res_hog = p_hog and res_var = 'sexo' and res_mie in (select res_mie from encu.respuestas where res_ope=dbo.ope_actual() and res_for='S1' and res_mat='P' and res_enc = p_enc and res_hog = p_hog and res_var = 'p4' and (res_valor ='1' ) limit 1);
    return v_sexojefe;
END;
$BODY$
  LANGUAGE plpgsql STABLE;
/*otra*/
CREATE OR REPLACE FUNCTION dbo.suma_md(p_enc integer, p_hog integer, p_mie integer)
  RETURNS integer AS
$BODY$
DECLARE
	v_md integer;
BEGIN
   select sum(res_valor::integer) into v_md from encu.respuestas 
   where res_ope=dbo.ope_actual() and res_for='I1' and res_mat='' and res_enc = p_enc and res_hog = p_hog and res_mie = p_mie and res_var IN ('md1', 'md2', 'md3', 'md4', 'md5', 'md6', 'md7', 'md8', 'md9', 'md10', 'md11');
return v_md;
END;
$BODY$
  LANGUAGE plpgsql STABLE;
/*otra*/
CREATE OR REPLACE FUNCTION dbo.textoinformado(p_valor text)
  RETURNS integer AS
$BODY$
BEGIN
  if p_valor is null or length(trim(p_valor))=0 then
     return 0;
  else 
     return 1;
  end if;
END;
$BODY$
  LANGUAGE plpgsql IMMUTABLE;
/*otra*/  
CREATE OR REPLACE FUNCTION dbo.textoinformado(p_valor character varying)
  RETURNS integer AS
$BODY$
BEGIN
  if p_valor is null or length(trim(p_valor))=0 then
     return 0;
  else 
     return 1;
  end if;
END;
$BODY$
  LANGUAGE plpgsql IMMUTABLE;
/*otra*/  
CREATE OR REPLACE FUNCTION dbo.textoinformado(p_valor integer)
  RETURNS integer AS
$BODY$
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
$BODY$
  LANGUAGE plpgsql IMMUTABLE;  
/*otra*/
CREATE OR REPLACE FUNCTION dbo.suma_t1at54b(p_enc integer, p_hog integer, p_mie integer)
  RETURNS integer AS
$BODY$
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
$BODY$
  LANGUAGE plpgsql STABLE;
/*otra*/  
CREATE OR REPLACE FUNCTION dbo.suma_t28a54b(p_enc integer, p_hog integer, p_mie integer)
  RETURNS integer AS
$BODY$
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
$BODY$
  LANGUAGE plpgsql STABLE;
/*otra*/
CREATE OR REPLACE FUNCTION dbo.form_familiar()
  RETURNS text AS
$BODY$
begin
	return 'S1';
end;
$BODY$
  LANGUAGE plpgsql IMMUTABLE;
/*otra*/
CREATE OR REPLACE FUNCTION dbo.total_hogares(p_enc integer)
  RETURNS integer AS
$BODY$
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
$BODY$
  LANGUAGE plpgsql STABLE;
/*otra*/
CREATE OR REPLACE FUNCTION comun.nsnc(valor text)
  RETURNS boolean AS
$BODY$
BEGIN
  IF valor = '//' THEN
     RETURN true;
  END IF;
RETURN false;
END;
$BODY$
  LANGUAGE plpgsql IMMUTABLE;
/*otra*/
CREATE OR REPLACE FUNCTION comun.nsnc(valor integer)
  RETURNS boolean AS
$BODY$
BEGIN
  IF valor = -9 THEN
     RETURN true;
  END IF;
RETURN false;
END;
$BODY$
  LANGUAGE plpgsql IMMUTABLE;
/*otra*/
CREATE OR REPLACE FUNCTION comun.blanco("P_valor" integer)
  RETURNS boolean AS
'SELECT $1 IS NULL'
  LANGUAGE sql IMMUTABLE;
/*otra*/
CREATE OR REPLACE FUNCTION comun.blanco("P_valor" text)
  RETURNS boolean AS
'SELECT $1 IS NULL'
  LANGUAGE sql IMMUTABLE;
/*otra*/  
CREATE OR REPLACE FUNCTION comun.informado("P_valor" text)
  RETURNS boolean AS
'SELECT $1 IS NOT NULL'
  LANGUAGE sql IMMUTABLE;
/*otra*/
CREATE OR REPLACE FUNCTION comun.informado("P_valor" integer)
  RETURNS boolean AS
'SELECT $1 IS NOT NULL'
  LANGUAGE sql IMMUTABLE;
/*otra*/
CREATE OR REPLACE FUNCTION dbo.cantex(p_enc integer, p_hog integer)
  RETURNS integer AS
$BODY$
DECLARE
 v_cantidad integer;
BEGIN 
  select count(cla_exm) into v_cantidad 
  from encu.claves where cla_ope=dbo.ope_actual() and cla_for='A1'  and cla_mat='X' and cla_enc=p_enc  and cla_hog=p_hog;
  return v_cantidad;
END;
$BODY$
  LANGUAGE plpgsql IMMUTABLE;



