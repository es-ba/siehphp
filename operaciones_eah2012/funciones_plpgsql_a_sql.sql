
CREATE OR REPLACE FUNCTION dbo.edadfamiliar(p_enc integer, p_hog integer, p_mie integer)
  RETURNS integer AS
$BODY$
	select res_valor::integer from encu.respuestas 
	where res_ope=dbo.ope_actual() and res_for='S1' and res_mat='P' and res_enc = $1 and res_hog = $2 and res_mie = $3 and res_var='edad';
$BODY$
  LANGUAGE sql STABLE
  COST 100;

CREATE OR REPLACE FUNCTION dbo.estadofamiliar(p_enc integer, p_hog integer, p_mie integer)
  RETURNS integer AS
$BODY$
	select res_valor::integer from encu.respuestas
	where res_ope=dbo.ope_actual() and res_for='S1' and res_mat='P' and res_enc = $1 and res_hog = $2 and res_mie = $3 and res_var = 'p5b';
$BODY$
  LANGUAGE sql STABLE
  COST 100;

--drop function dbo.nroconyuges(integer, integer);

CREATE OR REPLACE FUNCTION dbo.nroconyuges(p_enc integer, p_hog integer)
  RETURNS bigint AS
$BODY$
    select count(*) from encu.respuestas where res_ope=dbo.ope_actual() and res_for='S1' and res_mat='P' and res_enc=$1 and res_hog=$2 and res_var='p4' and (res_valor='2');
$BODY$
  LANGUAGE sql STABLE
  COST 100;
ALTER FUNCTION dbo.nroconyuges(integer, integer)
  OWNER TO tedede_php;

--drop function dbo.nrojefes(integer, integer);

CREATE OR REPLACE FUNCTION dbo.nrojefes(p_enc integer, p_hog integer)
  RETURNS bigint AS
$BODY$
    select count(*) from encu.respuestas where res_ope=dbo.ope_actual() and res_for='S1' and res_mat='P' and res_enc = $1 and res_hog = $2 and res_var = 'p4' and res_valor ='1';
$BODY$
  LANGUAGE sql STABLE
  COST 100;
ALTER FUNCTION dbo.nrojefes(integer, integer)
  OWNER TO tedede_php;

select * from encu.plana_s1_ where dbo.nrojefes(pla_enc, pla_hog)>1

--drop function dbo.p5bfamiliar(integer, integer, integer);

CREATE OR REPLACE FUNCTION dbo.p5bfamiliar(p_enc integer, p_hog integer, p_mie integer)
  RETURNS integer AS
$BODY$
  select res_valor::integer
    from encu.respuestas where res_ope=dbo.ope_actual() and res_for='S1' and res_mat='P' and res_enc = $1 and res_hog = $2 and res_mie=$3 and res_var = 'p5b';
$BODY$
  LANGUAGE sql STABLE
  COST 100;
ALTER FUNCTION dbo.p5bfamiliar(integer, integer, integer)
  OWNER TO tedede_php;

-- DROP FUNCTION dbo.sumah3(integer);

CREATE OR REPLACE FUNCTION dbo.sumah3(p_enc integer)
  RETURNS bigint AS
$BODY$
	select sum(res_valor::integer) from encu.respuestas 
	where res_ope=dbo.ope_actual() and res_for='A1' and res_mat='' and res_enc = $1 and res_var = 'h3' and not comun.nsnc(res_valor);
$BODY$
  LANGUAGE sql STABLE
  COST 100;
ALTER FUNCTION dbo.sumah3(integer)
  OWNER TO tedede_php;

-- DROP FUNCTION dbo.total_hogares(integer);

CREATE OR REPLACE FUNCTION dbo.total_hogares(p_enc integer)
  RETURNS bigint AS
$BODY$
    select count(distinct(cla_hog)) 
      from encu.claves 
      where cla_enc=$1 
        and cla_ope=dbo.ope_actual()
        and cla_for=dbo.form_familiar()
        and cla_mat=''
        and cla_mie=0;
$BODY$
  LANGUAGE sql STABLE
  COST 100;
ALTER FUNCTION dbo.total_hogares(integer)
  OWNER TO tedede_php;

-- DROP FUNCTION dbo.sexojefe(integer, integer);

CREATE OR REPLACE FUNCTION dbo.sexojefe(p_enc integer, p_hog integer)
  RETURNS integer AS
$BODY$
    select res_valor::integer  
        from encu.respuestas r
        where res_ope=dbo.ope_actual() 
          and res_for='S1' 
          and res_mat='P' 
          and res_enc = $1
          and res_hog = $2
          and res_var = 'sexo' 
          and res_mie = (select res_mie 
                            from encu.respuestas 
                            where res_ope=dbo.ope_actual() 
                              and res_for='S1' 
                              and res_mat='P' 
                              and res_enc = $1
                              and res_hog = $2
                              -- and res_enc = r.res_enc 
                              -- and res_hog = r.res_hog 
                              and res_var = 'p4' 
                              and res_valor ='1' 
                              and res_exm=0
                              limit 1
                           )
          and res_exm=0;
$BODY$
  LANGUAGE sql STABLE
  COST 100;
ALTER FUNCTION dbo.sexojefe(integer, integer)
  OWNER TO tedede_php;

CREATE OR REPLACE FUNCTION dbo.edadjefe(p_enc integer, p_nhogar integer)
  RETURNS integer AS
$BODY$
    select res_valor::integer  
        from encu.respuestas r
        where res_ope=dbo.ope_actual() 
          and res_for='S1' 
          and res_mat='P' 
          and res_enc = $1
          and res_hog = $2
          and res_var = 'edad' 
          and res_mie = (select res_mie 
                            from encu.respuestas 
                            where res_ope=dbo.ope_actual() 
                              and res_for='S1' 
                              and res_mat='P' 
                              and res_enc = $1
                              and res_hog = $2
                              -- and res_enc = r.res_enc 
                              -- and res_hog = r.res_hog 
                              and res_var = 'p4' 
                              and res_valor ='1' 
                              and res_exm=0
                              limit 1
                           )
          and res_exm=0;
$BODY$
  LANGUAGE sql STABLE
  COST 100;
ALTER FUNCTION dbo.edadjefe(integer, integer)
  OWNER TO tedede_php;


-- DROP FUNCTION dbo.estadojefe(integer, integer);

CREATE OR REPLACE FUNCTION dbo.estadojefe(p_enc integer, p_hog integer)
  RETURNS integer AS
$BODY$
  select res_valor::integer 
      from encu.respuestas 
      where res_ope=dbo.ope_actual() 
        and res_for='S1' 
        and res_mat='P' 
        and res_enc = $1 
        and res_hog = $2 
        and res_var = 'p5' 
        and res_mie = (
	  select res_mie 
	    from encu.respuestas 
	    where res_ope=dbo.ope_actual() 
              and res_for='S1' 
              and res_mat='P' 
              and res_enc=$1 
	      and res_hog=$2 
	      and res_var ='p4' 
	      and (res_valor ='1') limit 1);
$BODY$
  LANGUAGE sql STABLE
  COST 100;
ALTER FUNCTION dbo.estadojefe(integer, integer)
  OWNER TO postgres;

CREATE OR REPLACE FUNCTION dbo.existe_hogar(p_enc integer, p_hog integer)
  RETURNS integer AS
$BODY$
DECLARE v_existe integer;
BEGIN
    v_existe := 0;
    v_existe := count(distinct (res_hog)) from encu.respuestas where res_ope=dbo.ope_actual() and res_enc = p_enc and res_hog = p_hog;
    return v_existe;
END;
$BODY$
  LANGUAGE plpgsql STABLE
  COST 100;
ALTER FUNCTION dbo.existe_hogar(integer, integer)
  OWNER TO tedede_php;

  CREATE OR REPLACE FUNCTION dbo.existemiembro(p_enc integer, p_hog integer, p_mie integer)
  RETURNS integer AS
$BODY$
DECLARE v_existe integer;
BEGIN
    v_existe := 0;
    v_existe := count(distinct (res_mie)) from encu.respuestas where res_ope=dbo.ope_actual() and res_for='S1' and res_mat='P' and res_enc = p_enc and res_hog = p_hog and res_mie = p_mie;
    return v_existe;
END;
$BODY$
  LANGUAGE plpgsql STABLE
  COST 100;
ALTER FUNCTION dbo.existemiembro(integer, integer, integer)
  OWNER TO tedede_php;

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
  
  
CREATE OR REPLACE FUNCTION dbo.sexo_participacion_anterior(enc integer, hogar integer, miembro integer)
  RETURNS integer AS
$BODY$
	select sexo from yeah_2011.eah11_fam where nenc = $1 and nhogar = $2 and p0 = $3;
$BODY$
  LANGUAGE sql STABLE
  COST 100;
ALTER FUNCTION dbo.sexo_participacion_anterior(integer, integer, integer)
  OWNER TO tedede_php;

CREATE OR REPLACE FUNCTION dbo.edad_participacion_anterior(enc integer, hogar integer, miembro integer)
  RETURNS integer AS
$BODY$
	select edad from yeah_2011.eah11_fam where nenc = $1 and nhogar = $2 and p0 = $3;
$BODY$
  LANGUAGE sql STABLE
  COST 100;
ALTER FUNCTION dbo.edad_participacion_anterior(integer, integer, integer)
  OWNER TO tedede_php;

