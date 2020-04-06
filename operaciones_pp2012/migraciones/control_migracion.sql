-- Vamos a migrar desde yeah2011 a encu

create or replace function controlar_migracion_variable(p_tabla_origen text, p_for text, p_mat text, p_var text,p_venc text,p_vhog text,p_vmie text) returns text
  language plpgsql as 
$body$
declare
  v_sql text;
  v_hay_en_respuestas integer;
  v_hay_en_variables integer;
begin
  v_sql:=replace($sql$
        select 1 
            from encu.respuestas
            where res_ope='pp2012'
              and res_for #filtro_for#
              and res_mat=$1
              and res_var=$2
            limit 1;
    $sql$,'#filtro_for#', case when p_for='S1A1' then $$ in ('S1','A1')$$ else $$='$$||p_for||$$'$$ end);
    execute v_sql into v_hay_en_respuestas using p_mat, p_var;
        select 1 
            from encu.variables
            into v_hay_en_variables
            where var_ope='EAH2011'
              and var_for=p_for
              and var_var=p_var
            limit 1;
    if v_hay_en_respuestas is null then
        return 'Falta la variable '||p_var||' en '||p_for||':'||p_mat||case when v_hay_en_variables is null then ' falta también en variables' end;
    else
        return null;
    end if;
end;
$body$;

select * from (
select controlar_migracion_variable(tabla,formulario,matriz,column_name,enc,hog,mie) control
  from information_schema.columns, 
	(select 'eah11_viv_s1a1' as tabla, 'S1A1' as formulario, '' as matriz, 'nenc' as enc,'nhogar' as hog,'miembro' as mie
	union select 'eah11_fam' as tabla, 'S1' as formulario, 'P' as matriz, 'nenc' as enc,'nhogar' as hog,'p0' as mie 
	union select 'eah11_ex' as tabla, 'A1' as formulario, 'X' as matriz, 'nenc' as enc,'nhogar' as hog,'ex_miembro' as mie
	union select 'eah11_i1' as tabla, 'I1' as formulario, '' as matriz, 'nenc' as enc,'nhogar' as hog,'miembro' as mie	
	) x
  where table_schema='yeah_2011' and table_name=tabla
    and column_name not in ('nenc','nhogar','miembro','ex_miembro','p0','participacion')) x
  where control is not null;
