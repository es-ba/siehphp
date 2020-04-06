set search_path to operaciones, encu, yeah_2011, yeah_2010, comun, public;

create or replace function migrar_una_clave(p_ope text, p_tabla_origen text, p_for text, p_mat text,p_venc text,p_vhog text,p_vmie text,p_vexm text) returns void
  language plpgsql as 
$body$
declare
  v_sql text;  
begin
    v_sql:=replace(replace(replace(replace(replace(replace($sql$
        INSERT INTO encu.claves(
                    cla_ope, cla_for, cla_mat, cla_enc, cla_hog, cla_mie, cla_exm, cla_tlg)
            SELECT '#p_ope#' as cla_ope, $1, $2, #p_venc# as cla_enc, #p_vhog# as cla_hog, coalesce(#p_vmie#,0) as cla_mie, coalesce(#p_vexm#,0) as cla_exm, 
                    1 as cla_tlg
              FROM #p_tabla_origen# INNER JOIN encu.tem ON #p_venc#=tem_enc
              --where #p_venc# BETWEEN  100001 AND 999999
    $sql$,'#p_tabla_origen#',p_tabla_origen),'#p_venc#',p_venc),'#p_vhog#',p_vhog),'#p_vmie#',p_vmie),'#p_vexm#',p_vexm),'#p_ope#',p_ope);
    execute v_sql using p_for, p_mat;
end;
$body$;

create or replace function migrar_una_variable(p_ope text, p_tabla_origen text, p_for text, p_mat text, p_var text,p_venc text,p_vhog text,p_vmie text,p_vexm text) returns void
  language plpgsql as 
$body$
declare
  v_sql text;
begin
    v_sql:=replace(replace(replace(replace(replace(replace(replace(replace($sql$    
        UPDATE encu.respuestas
            SET res_valor=case when #p_var#::text not in (#nsnc_var#::text,'-1') then #p_var# else null end 
              , res_valesp=case #p_var#::text when #nsnc_var#::text then '//' when '-1' then '--' else null end 
            FROM #p_tabla_origen# INNER JOIN encu.tem ON #p_venc#=tem_enc
            WHERE res_ope='#p_ope#' and res_for=$1 and res_mat=$2 and res_enc=#p_venc# 
                AND res_hog=#p_vhog# 
                and res_mie=coalesce(#p_vmie#,0) 
                and res_exm=coalesce(#p_vexm#,0) 
                and res_var='#p_var#' and #p_venc# BETWEEN  100001 AND 999999
    $sql$,'#p_tabla_origen#',p_tabla_origen),'#p_var#',p_var),'#nsnc_var#','9'),'#p_venc#',p_venc),'#p_vhog#',p_vhog),'#p_vmie#',p_vmie),'#p_ope#',p_ope),'#p_vexm#',p_vexm);
    execute v_sql using p_for, p_mat;    
end;
$body$;

select migrar_una_clave('eah2011','eah11_fam','S1','P','nenc','nhogar','p0','null'); 
select migrar_una_clave('eah2011','eah11_viv_s1a1','S1','','nenc','nhogar','miembro','null'); 

select migrar_una_clave('eah2010','eah10_fam','S1','P','nenc','nhogar','p0','null'); 
select migrar_una_clave('eah2010','eah10_viv_s1a1','S1','','nenc','nhogar','miembro','null'); 

select migrar_una_variable('eah20'||sufijo_annio,'eah'||sufijo_annio||tabla,formulario,matriz,column_name,enc,hog,mie,exm) 
  from information_schema.columns, 
	(select '_fam' as tabla, 'S1' as formulario, 'P' as matriz, 'nenc' as enc,'nhogar' as hog,'p0' as mie, 'null' as exm
	union select '_viv_s1a1' as tabla, 'S1' as formulario, '' as matriz, 'nenc' as enc,'nhogar' as hog,'miembro' as mie, 'null' as exm
    /*
	union select '_viv_s1a1' as tabla, 'A1' as formulario, '' as matriz, 'nenc' as enc,'nhogar' as hog,'miembro' as mie, 'null' as exm
	union select '_ex' as tabla, 'A1' as formulario, 'X' as matriz, 'nenc' as enc,'nhogar' as hog,'null' as mie, 'ex_miembro' as exm
	union select '_i1' as tabla, 'I1' as formulario, '' as matriz, 'nenc' as enc,'nhogar' as hog,'miembro' as mie, 'null' as exm
    */
	) x cross join (select '11' as sufijo_annio union select '10') y
  where table_schema in ('yeah_2011','yeah_2010') and table_name='eah'||sufijo_annio||tabla
    and column_name not in ('nenc','nhogar','miembro','ex_miembro','p0','participacion');
