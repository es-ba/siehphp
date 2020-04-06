create or replace function borrar_formulario_matriz(p_ope text, p_for text, p_mat text, p_enc integer, p_hog integer, p_mie integer , p_exm integer ) 
  returns integer 
  language plpgsql
  as
$BODY$
DECLARE
    v_ok integer;
    v_sql text;
BEGIN
    v_sql:=replace(replace($SQL$
	DELETE FROM plana_#FOR#_#MAT#
	  WHERE pla_enc=$1
            and pla_hog=$2
            and pla_mie=$3
            and pla_exm=$4
    $SQL$,'#FOR#',p_for),'#MAT#',p_mat);
    raise notice 'PAP % % % %',v_sql,p_enc,p_hog,p_mie;
    EXECUTE v_sql USING p_enc,p_hog,p_mie,p_exm;
    delete from respuestas
        where res_ope=p_ope
            and res_for=p_for
            and res_mat=p_mat
            and res_enc=p_enc
            and res_hog=p_hog
            and res_mie=p_mie
            and res_exm=p_exm
            ;
    delete from claves
        where cla_ope=p_ope
            and cla_for=p_for
            and cla_mat=p_mat
            and cla_enc=p_enc
            and cla_hog=p_hog
            and cla_mie=p_mie
            and cla_exm=p_exm
            ;
    GET DIAGNOSTICS v_ok = ROW_COUNT; 
    return v_ok;
END;
$BODY$;

create or replace function borrar_formulario_entero(p_ope text, p_for text, p_enc integer, p_hog integer, p_mie integer, p_exm integer) 
  returns integer 
  language plpgsql
  as
$BODY$
DECLARE
    v_cursor record;
    v_ok integer;
BEGIN
    for v_cursor in select cla_mat
        from claves
        where cla_ope=p_ope
            and cla_for=p_for
            and cla_enc=p_enc
            and cla_hog=p_hog
            and cla_mie=p_mie
            and cla_exm=p_exm
    loop
        v_ok:=borrar_formulario_matriz(p_ope,p_for,v_cursor.cla_mat,p_enc,p_hog,p_mie,p_exm);
    end loop;
    GET DIAGNOSTICS v_ok = ROW_COUNT; 
    return v_ok;
END;
$BODY$;

create or replace function borrar_miembro(p_ope text, p_enc integer, p_hog integer, p_mie integer) 
  returns integer 
  language plpgsql
  as
$BODY$
DECLARE
    v_cursor record;
    v_ok integer;
BEGIN
    for v_cursor in select cla_mat, cla_for
        from claves
        where cla_ope=p_ope
            and cla_enc=p_enc
            and cla_hog=p_hog
            and cla_mie=p_mie
    loop
        v_ok:=borrar_formulario_matriz(p_ope,v_cursor.cla_for,v_cursor.cla_mat,p_enc,p_hog,p_mie,0 /*p_exm */);
    end loop;
    GET DIAGNOSTICS v_ok = ROW_COUNT; 
    return v_ok;
END;
$BODY$;

create or replace function borrar_hogar(p_ope text, p_enc integer, p_hog integer) 
  returns integer 
  language plpgsql
  as
$BODY$
DECLARE
    v_cursor record;
    v_ok integer;
BEGIN
    for v_cursor in select cla_mat, cla_for, cla_mie, cla_exm
        from claves
        where cla_ope=p_ope
            and cla_enc=p_enc
            and cla_hog=p_hog
    loop
        v_ok:=borrar_formulario_matriz(p_ope,v_cursor.cla_for,v_cursor.cla_mat,p_enc,p_hog,v_cursor.cla_mie,v_cursor.cla_exm);
    end loop;
    GET DIAGNOSTICS v_ok = ROW_COUNT; 
    return v_ok;
END;
$BODY$;