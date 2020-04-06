-- Function: dbo.cant_hog_rea(integer)

-- DROP FUNCTION dbo.cant_hog_rea(integer);

CREATE OR REPLACE FUNCTION dbo.cant_hog_rea(p_enc integer)
  RETURNS bigint AS
$BODY$
  select count(pla_hog)
    from encu.plana_s1_ 
    where pla_enc = $1
      and pla_entrea=1;
$BODY$
  LANGUAGE sql IMMUTABLE
  COST 100;
ALTER FUNCTION dbo.cant_hog_rea(integer)
  OWNER TO tedede_php;

-- Function: dbo.cant_hog_tot_sin95(integer)

-- DROP FUNCTION dbo.cant_hog_tot_sin95(integer);

CREATE OR REPLACE FUNCTION dbo.cant_hog_tot_sin95(p_enc integer)
  RETURNS bigint AS
$BODY$
  select count(res_hog)
	from encu.respuestas where res_ope = dbo.ope_actual() 
		and res_for = 'S1' 
		and res_enc = $1
		and res_var = 'entrea' 
		and res_valor <> '95';
$BODY$
  LANGUAGE sql IMMUTABLE
  COST 100;
ALTER FUNCTION dbo.cant_hog_tot_sin95(integer)
  OWNER TO tedede_php;

-- Function: dbo.cant_i1_x_enc(integer)

-- DROP FUNCTION dbo.cant_i1_x_enc(integer);

CREATE OR REPLACE FUNCTION dbo.cant_i1_x_enc(p_enc integer)
  RETURNS bigint AS
$BODY$
  select count(cla_mie)
  from encu.claves where cla_ope=dbo.ope_actual() 
	and cla_for='I1' 
	and cla_enc=$1;
$BODY$
  LANGUAGE sql IMMUTABLE
  COST 100;
ALTER FUNCTION dbo.cant_i1_x_enc(integer)
  OWNER TO tedede_php;

-- Function: dbo.edad_participacion_anterior(integer, integer, integer)

-- DROP FUNCTION dbo.edad_participacion_anterior(integer, integer, integer);

CREATE OR REPLACE FUNCTION dbo.edad_participacion_anterior(enc integer, hogar integer, miembro integer)
  RETURNS integer AS
$BODY$
	select res_valor::integer from encu.respuestas 
	where res_ope = 'eah'||(dbo.anio()-1)::text
	and res_for = 'S1' 
	and res_mat = 'P'
	and res_enc = $1 
	and res_hog = $2 
	and res_mie = $3 
	and res_var = 'edad';
$BODY$
  LANGUAGE sql STABLE
  COST 100;
ALTER FUNCTION dbo.edad_participacion_anterior(integer, integer, integer)
  OWNER TO tedede_php;

-- Function: dbo.existe_a1(integer, integer)

-- DROP FUNCTION dbo.existe_a1(integer, integer);

CREATE OR REPLACE FUNCTION dbo.existe_a1(enc integer, hog integer)
  RETURNS bigint AS
$BODY$
  select count(cla_enc)
  from encu.claves where cla_ope=dbo.ope_actual() 
	and cla_for='A1'
	and cla_mat=''
	and cla_enc=$1
	and cla_hog=$2
	limit 1;
$BODY$
  LANGUAGE sql IMMUTABLE
  COST 100;
ALTER FUNCTION dbo.existe_a1(integer, integer)
  OWNER TO tedede_php;

-- Function: dbo.existe_s1(integer)

-- DROP FUNCTION dbo.existe_s1(integer);

CREATE OR REPLACE FUNCTION dbo.existe_s1(enc integer)
  RETURNS integer AS
$BODY$
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
$BODY$
  LANGUAGE plpgsql IMMUTABLE
  COST 100;
ALTER FUNCTION dbo.existe_s1(integer)
  OWNER TO tedede_php;

-- Function: dbo.existeindividual(integer, integer, integer)

-- DROP FUNCTION dbo.existeindividual(integer, integer, integer);

CREATE OR REPLACE FUNCTION dbo.existeindividual(enc integer, hog integer, mie integer)
  RETURNS bigint AS
$BODY$
  	select count(distinct(pla_mie)) from encu.plana_i1_ 
		where pla_enc = $1 
		and pla_hog = $2 
		and pla_mie = $3;
$BODY$
  LANGUAGE sql STABLE
  COST 100;
ALTER FUNCTION dbo.existeindividual(integer, integer, integer)
  OWNER TO tedede_php;

-- Function: dbo.p7_min(integer, integer)

-- DROP FUNCTION dbo.p7_min(integer, integer);

CREATE OR REPLACE FUNCTION dbo.p7_min(p_enc integer, p_hog integer)
  RETURNS integer AS
$BODY$
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
$BODY$
  LANGUAGE plpgsql IMMUTABLE
  COST 100;
ALTER FUNCTION dbo.p7_min(integer, integer)
  OWNER TO tedede_php;

-- Function: dbo.sexo_participacion_anterior(integer, integer, integer)

-- DROP FUNCTION dbo.sexo_participacion_anterior(integer, integer, integer);

CREATE OR REPLACE FUNCTION dbo.sexo_participacion_anterior(enc integer, hogar integer, miembro integer)
  RETURNS integer AS
$BODY$
	select res_valor::integer from encu.respuestas 
	where res_ope = 'eah'||(dbo.anio()-1)::text
	and res_for = 'S1'
	and res_mat = 'P'
	and res_enc = $1 
	and res_hog = $2 
	and res_mie = $3 
	and res_var = 'sexo';
$BODY$
  LANGUAGE sql STABLE
  COST 100;
ALTER FUNCTION dbo.sexo_participacion_anterior(integer, integer, integer)
  OWNER TO tedede_php;
  
CREATE OR REPLACE FUNCTION dbo.cant_hog_norea_con_motivo(p_enc integer)
  RETURNS integer AS
$BODY$
DECLARE
 v_cantidad integer;
BEGIN 
  select count(*) into v_cantidad 
    from encu.plana_s1_
    where pla_enc=p_enc and pla_entrea=2 and pla_razon1 is not null;
  return v_cantidad;
END;
$BODY$
  LANGUAGE plpgsql ;  
ALTER FUNCTION dbo.cant_hog_norea_con_motivo(integer)
  OWNER TO tedede_php;  

CREATE OR REPLACE FUNCTION dbo.cant_registros_exm(p_enc integer, p_hog integer)
  RETURNS integer AS
$BODY$
DECLARE
 v_cantidad integer;
BEGIN 

    SELECT count(distinct res_exm) INTO v_cantidad 
    FROM encu.respuestas 
    WHERE res_ope=dbo.ope_actual() and res_for='A1'  and res_mat='X' and res_enc=p_enc and res_hog=p_hog and res_valor is not null;  
    
    return v_cantidad;
END;
$BODY$
  LANGUAGE plpgsql IMMUTABLE;
ALTER FUNCTION dbo.cant_registros_exm(integer, integer)
  OWNER TO tedede_php;


