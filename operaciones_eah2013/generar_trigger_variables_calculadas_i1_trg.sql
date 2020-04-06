--- aca van las columnas de las variables calculadas a agregar en plana_i1_ tomadas del excel BORRADOR_CAMBIADO_EAH2013-Metadatos Tabulados Basicos_071113.xls
--- para probar filtro columna destino = 'mie'
alter table encu.plana_i1_ drop column if exists pla_edad10a;  alter table encu.plana_i1_ add column pla_edad10a integer;
alter table encu.plana_i1_ drop column if exists pla_zona_3;  alter table encu.plana_i1_ add column pla_zona_3 integer;
alter table encu.plana_i1_ drop column if exists pla_edad10b;  alter table encu.plana_i1_ add column pla_edad10b integer;
alter table encu.plana_i1_ drop column if exists pla_t_ocup;  alter table encu.plana_i1_ add column pla_t_ocup integer;
alter table encu.plana_i1_ drop column if exists pla_t_desoc;  alter table encu.plana_i1_ add column pla_t_desoc integer;
alter table encu.plana_i1_ drop column if exists pla_t_ina;  alter table encu.plana_i1_ add column pla_t_ina integer;
alter table encu.plana_i1_ drop column if exists pla_cond_activ;  alter table encu.plana_i1_ add column pla_cond_activ integer;

--- aca van los inserts para las tablas varcal y varcalopc tomadas del excel BORRADOR_CAMBIADO_EAH2013-Metadatos Tabulados Basicos_071113.xls
--- para probar filtro columna destino = 'mie'

insert into encu.varcal (varcal_ope, varcal_varcal,varcal_destino, varcal_nombre, varcal_comentarios, varcal_tlg) values ('eah2013','edad10a','mie','Grupo de edad (años)','',1);	insert into encu.varcalopc (varcalopc_ope, varcalopc_varcal,varcalopc_opcion, varcalopc_expresion, varcalopc_etiqueta, varcalopc_confirmado,varcalopc_tlg) values ('eah2013','edad10a','1','edad >= 0 and edad <= 9','Hasta 9',true,1);
	insert into encu.varcalopc (varcalopc_ope, varcalopc_varcal,varcalopc_opcion, varcalopc_expresion, varcalopc_etiqueta, varcalopc_confirmado,varcalopc_tlg) values ('eah2013','edad10a','2','edad >= 10 and edad <= 19','10 - 19',true,1);
	insert into encu.varcalopc (varcalopc_ope, varcalopc_varcal,varcalopc_opcion, varcalopc_expresion, varcalopc_etiqueta, varcalopc_confirmado,varcalopc_tlg) values ('eah2013','edad10a','3','edad >= 20 and edad <= 29','20 - 29',true,1);
	insert into encu.varcalopc (varcalopc_ope, varcalopc_varcal,varcalopc_opcion, varcalopc_expresion, varcalopc_etiqueta, varcalopc_confirmado,varcalopc_tlg) values ('eah2013','edad10a','4','edad >= 30 and edad <= 39','30 - 39',true,1);
	insert into encu.varcalopc (varcalopc_ope, varcalopc_varcal,varcalopc_opcion, varcalopc_expresion, varcalopc_etiqueta, varcalopc_confirmado,varcalopc_tlg) values ('eah2013','edad10a','5','edad >= 40 and edad <= 49','40 - 49',true,1);
	insert into encu.varcalopc (varcalopc_ope, varcalopc_varcal,varcalopc_opcion, varcalopc_expresion, varcalopc_etiqueta, varcalopc_confirmado,varcalopc_tlg) values ('eah2013','edad10a','6','edad >= 50 and edad <= 59','50 -59',true,1);
	insert into encu.varcalopc (varcalopc_ope, varcalopc_varcal,varcalopc_opcion, varcalopc_expresion, varcalopc_etiqueta, varcalopc_confirmado,varcalopc_tlg) values ('eah2013','edad10a','7','edad >= 60 and edad <= 69','60 - 69',true,1);
	insert into encu.varcalopc (varcalopc_ope, varcalopc_varcal,varcalopc_opcion, varcalopc_expresion, varcalopc_etiqueta, varcalopc_confirmado,varcalopc_tlg) values ('eah2013','edad10a','8','edad >= 70 ','70 y más',true,1);
insert into encu.varcal (varcal_ope, varcal_varcal,varcal_destino, varcal_nombre, varcal_comentarios, varcal_tlg) values ('eah2013','zona_3','mie','Zona','',1);	insert into encu.varcalopc (varcalopc_ope, varcalopc_varcal,varcalopc_opcion, varcalopc_expresion, varcalopc_etiqueta, varcalopc_confirmado,varcalopc_tlg) values ('eah2013','zona_3','1','comuna = 2 or comuna = 13 or comuna = 14','Norte (comunas 2, 13, 14)',true,1);
	insert into encu.varcalopc (varcalopc_ope, varcalopc_varcal,varcalopc_opcion, varcalopc_expresion, varcalopc_etiqueta, varcalopc_confirmado,varcalopc_tlg) values ('eah2013','zona_3','2','comuna = 1 or comuna = 3 or comuna = 5 or comuna = 6 or comuna = 7 or comuna = 11 or comuna = 12 or comuna = 15','Centro (comunas 1, 3, 5, 6, 7, 11, 12, 15)',true,1);
	insert into encu.varcalopc (varcalopc_ope, varcalopc_varcal,varcalopc_opcion, varcalopc_expresion, varcalopc_etiqueta, varcalopc_confirmado,varcalopc_tlg) values ('eah2013','zona_3','3','comuna = 4 or comuna = 8 or comuna = 9 or comuna = 10 ','Sur (comunas 4, 8, 9, 10)',true,1);
insert into encu.varcal (varcal_ope, varcal_varcal,varcal_destino, varcal_nombre, varcal_comentarios, varcal_tlg) values ('eah2013','edad10b','mie','Grupo de edad (años)','',1);	insert into encu.varcalopc (varcalopc_ope, varcalopc_varcal,varcalopc_opcion, varcalopc_expresion, varcalopc_etiqueta, varcalopc_confirmado,varcalopc_tlg) values ('eah2013','edad10b','1','edad >= 0 and edad <= 29','Hasta 29',true,1);
	insert into encu.varcalopc (varcalopc_ope, varcalopc_varcal,varcalopc_opcion, varcalopc_expresion, varcalopc_etiqueta, varcalopc_confirmado,varcalopc_tlg) values ('eah2013','edad10b','2','edad >= 30 and edad <= 39','30 - 39',true,1);
	insert into encu.varcalopc (varcalopc_ope, varcalopc_varcal,varcalopc_opcion, varcalopc_expresion, varcalopc_etiqueta, varcalopc_confirmado,varcalopc_tlg) values ('eah2013','edad10b','3','edad >= 40 and edad <= 49','40 - 49',true,1);
	insert into encu.varcalopc (varcalopc_ope, varcalopc_varcal,varcalopc_opcion, varcalopc_expresion, varcalopc_etiqueta, varcalopc_confirmado,varcalopc_tlg) values ('eah2013','edad10b','4','edad >= 50 and edad <= 59','50 - 59',true,1);
	insert into encu.varcalopc (varcalopc_ope, varcalopc_varcal,varcalopc_opcion, varcalopc_expresion, varcalopc_etiqueta, varcalopc_confirmado,varcalopc_tlg) values ('eah2013','edad10b','5','edad >= 60 ','60 y más',true,1);
insert into encu.varcal (varcal_ope, varcal_varcal,varcal_destino, varcal_nombre, varcal_comentarios, varcal_tlg) values ('eah2013','t_ocup','mie','T ocup','Variable auxiliar para construir ESTADO (condición de actividad) ',1);	insert into encu.varcalopc (varcalopc_ope, varcalopc_varcal,varcalopc_opcion, varcalopc_expresion, varcalopc_etiqueta, varcalopc_confirmado,varcalopc_tlg) values ('eah2013','t_ocup','1','T1=1 AND T7=1','',true,1);
	insert into encu.varcalopc (varcalopc_ope, varcalopc_varcal,varcalopc_opcion, varcalopc_expresion, varcalopc_etiqueta, varcalopc_confirmado,varcalopc_tlg) values ('eah2013','t_ocup','2','T1=1 AND T7=2 AND (T8= 1 oR T8 = 2)','',true,1);
	insert into encu.varcalopc (varcalopc_ope, varcalopc_varcal,varcalopc_opcion, varcalopc_expresion, varcalopc_etiqueta, varcalopc_confirmado,varcalopc_tlg) values ('eah2013','t_ocup','3','T1=2 AND  T2=1 AND T7=1','',true,1);
	insert into encu.varcalopc (varcalopc_ope, varcalopc_varcal,varcalopc_opcion, varcalopc_expresion, varcalopc_etiqueta, varcalopc_confirmado,varcalopc_tlg) values ('eah2013','t_ocup','4','T1=2 AND  T2=1 AND T7=2 AND (T8= 1 OR T8= 2)','',true,1);
	insert into encu.varcalopc (varcalopc_ope, varcalopc_varcal,varcalopc_opcion, varcalopc_expresion, varcalopc_etiqueta, varcalopc_confirmado,varcalopc_tlg) values ('eah2013','t_ocup','5','T1=2 AND  T2=2 AND T3=5 AND (T4 >= 1 AND T4 <=3)','',true,1);
	insert into encu.varcalopc (varcalopc_ope, varcalopc_varcal,varcalopc_opcion, varcalopc_expresion, varcalopc_etiqueta, varcalopc_confirmado,varcalopc_tlg) values ('eah2013','t_ocup','6','T1=2 AND  T2=2 AND T3=5 AND T4= 4 AND T5=1','',true,1);
	insert into encu.varcalopc (varcalopc_ope, varcalopc_varcal,varcalopc_opcion, varcalopc_expresion, varcalopc_etiqueta, varcalopc_confirmado,varcalopc_tlg) values ('eah2013','t_ocup','7','T1=2 AND  T2=2 AND T3=5 AND T4= 5 AND T6=1','',true,1);
insert into encu.varcal (varcal_ope, varcal_varcal,varcal_destino, varcal_nombre, varcal_comentarios, varcal_tlg) values ('eah2013','t_desoc','mie','t desoc','Variable auxiliar para construir ESTADO (condición de actividad)',1);	insert into encu.varcalopc (varcalopc_ope, varcalopc_varcal,varcalopc_opcion, varcalopc_expresion, varcalopc_etiqueta, varcalopc_confirmado,varcalopc_tlg) values ('eah2013','t_desoc','1','T1= 2 AND T2=2 AND (T3 >= 2 AND T3 <= 4) AND T9=1 AND T12=1','',true,1);
	insert into encu.varcalopc (varcalopc_ope, varcalopc_varcal,varcalopc_opcion, varcalopc_expresion, varcalopc_etiqueta, varcalopc_confirmado,varcalopc_tlg) values ('eah2013','t_desoc','2','T1= 2 AND T2=2 AND (T3 >= 2 AND T3 <= 4) AND T9=2 AND T10=1 AND T12=1','',true,1);
	insert into encu.varcalopc (varcalopc_ope, varcalopc_varcal,varcalopc_opcion, varcalopc_expresion, varcalopc_etiqueta, varcalopc_confirmado,varcalopc_tlg) values ('eah2013','t_desoc','3','T1= 2 AND T2=2 AND (T3 >= 2 AND T3 <= 4) AND T9=2 AND T10=2 AND (T11 >= 1 oR T11 <= 2) AND T12=1','',true,1);
	insert into encu.varcalopc (varcalopc_ope, varcalopc_varcal,varcalopc_opcion, varcalopc_expresion, varcalopc_etiqueta, varcalopc_confirmado,varcalopc_tlg) values ('eah2013','t_desoc','4','T1= 2 AND T2=2 AND T3= 5 AND T4=4 AND (T5=2 oR T5 = 3) AND T9=1 AND T12=1','',true,1);
	insert into encu.varcalopc (varcalopc_ope, varcalopc_varcal,varcalopc_opcion, varcalopc_expresion, varcalopc_etiqueta, varcalopc_confirmado,varcalopc_tlg) values ('eah2013','t_desoc','5','T1= 2 AND T2=2 AND T3= 5 AND T4=4 AND ( T5=2 OR T5 =  3) AND T9=2 AND T10=1 AND T12=1','',true,1);
	insert into encu.varcalopc (varcalopc_ope, varcalopc_varcal,varcalopc_opcion, varcalopc_expresion, varcalopc_etiqueta, varcalopc_confirmado,varcalopc_tlg) values ('eah2013','t_desoc','6','T1= 2 AND T2=2 AND T3= 5 AND T4=4 AND (T5=2 oR T5 = 3) AND T10=2 AND (T11= 1 oR T11 = 2) AND T12=1','',true,1);
	insert into encu.varcalopc (varcalopc_ope, varcalopc_varcal,varcalopc_opcion, varcalopc_expresion, varcalopc_etiqueta, varcalopc_confirmado,varcalopc_tlg) values ('eah2013','t_desoc','7','(T1= 2 AND T2=2 AND T3= 5 AND T4=5 AND (T6=2 oR T6 = 3) AND T9=1  AND T12=1)','',true,1);
	insert into encu.varcalopc (varcalopc_ope, varcalopc_varcal,varcalopc_opcion, varcalopc_expresion, varcalopc_etiqueta, varcalopc_confirmado,varcalopc_tlg) values ('eah2013','t_desoc','8','(T1= 2 AND T2=2 AND T3= 5 AND T4=5 AND (T6=2 oR T6 = 3) AND T9=2 AND T10=1 AND T12=1)','',true,1);
	insert into encu.varcalopc (varcalopc_ope, varcalopc_varcal,varcalopc_opcion, varcalopc_expresion, varcalopc_etiqueta, varcalopc_confirmado,varcalopc_tlg) values ('eah2013','t_desoc','9','(T1= 2 AND T2=2 AND T3= 5 AND T4=5 AND (T6=2 oR T6 = 3) AND T10=2 AND (T11= 1 OR T11 = 2) AND T12=1)','',true,1);
	insert into encu.varcalopc (varcalopc_ope, varcalopc_varcal,varcalopc_opcion, varcalopc_expresion, varcalopc_etiqueta, varcalopc_confirmado,varcalopc_tlg) values ('eah2013','t_desoc','10','(T1= 1 AND T7=2 AND T8= 3 AND T9=1  AND T12=1)','',true,1);
	insert into encu.varcalopc (varcalopc_ope, varcalopc_varcal,varcalopc_opcion, varcalopc_expresion, varcalopc_etiqueta, varcalopc_confirmado,varcalopc_tlg) values ('eah2013','t_desoc','11','(T1= 1 AND T7=2 AND T8= 3 AND T9=2 AND T10=1  AND T12=1)','',true,1);
	insert into encu.varcalopc (varcalopc_ope, varcalopc_varcal,varcalopc_opcion, varcalopc_expresion, varcalopc_etiqueta, varcalopc_confirmado,varcalopc_tlg) values ('eah2013','t_desoc','12','(T1= 1 AND T7=2 AND  T8= 3 AND T9=2 AND T10=2 AND (T11= 1 oR T11 = 2) AND T12=1)','',true,1);
	insert into encu.varcalopc (varcalopc_ope, varcalopc_varcal,varcalopc_opcion, varcalopc_expresion, varcalopc_etiqueta, varcalopc_confirmado,varcalopc_tlg) values ('eah2013','t_desoc','13','(T1= 2 AND T2=1 AND T7=2 AND T8= 3 AND T9=1  AND T12=1)','',true,1);
	insert into encu.varcalopc (varcalopc_ope, varcalopc_varcal,varcalopc_opcion, varcalopc_expresion, varcalopc_etiqueta, varcalopc_confirmado,varcalopc_tlg) values ('eah2013','t_desoc','14','(T1= 2 AND T2=1 AND T7=2 AND T8= 3 AND T9=2 AND T10=1 AND T12=1)','',true,1);
	insert into encu.varcalopc (varcalopc_ope, varcalopc_varcal,varcalopc_opcion, varcalopc_expresion, varcalopc_etiqueta, varcalopc_confirmado,varcalopc_tlg) values ('eah2013','t_desoc','15','(T1= 2 AND T2=1 AND T7=2 AND T8= 3 AND T9=2 AND T10=2 AND (T11= 1 oR T11 = 2) AND T12=1)','',true,1);
insert into encu.varcal (varcal_ope, varcal_varcal,varcal_destino, varcal_nombre, varcal_comentarios, varcal_tlg) values ('eah2013','t_ina','mie','t ina','Variable auxiliar para construir ESTADO (condición de actividad)',1);	insert into encu.varcalopc (varcalopc_ope, varcalopc_varcal,varcalopc_opcion, varcalopc_expresion, varcalopc_etiqueta, varcalopc_confirmado,varcalopc_tlg) values ('eah2013','t_ina','1','(T1=2 AND T2=2 AND T3=1)','',true,1);
	insert into encu.varcalopc (varcalopc_ope, varcalopc_varcal,varcalopc_opcion, varcalopc_expresion, varcalopc_etiqueta, varcalopc_confirmado,varcalopc_tlg) values ('eah2013','t_ina','2','((T11 = 3 oR T11 = 4))','',true,1);
	insert into encu.varcalopc (varcalopc_ope, varcalopc_varcal,varcalopc_opcion, varcalopc_expresion, varcalopc_etiqueta, varcalopc_confirmado,varcalopc_tlg) values ('eah2013','t_ina','3','EDAD <= 9','',true,1);
	insert into encu.varcalopc (varcalopc_ope, varcalopc_varcal,varcalopc_opcion, varcalopc_expresion, varcalopc_etiqueta, varcalopc_confirmado,varcalopc_tlg) values ('eah2013','t_ina','4','T12 = 2','',true,1);
insert into encu.varcal (varcal_ope, varcal_varcal,varcal_destino, varcal_nombre, varcal_comentarios, varcal_tlg) values ('eah2013','cond_activ','mie','Condición de actividad','',1);	insert into encu.varcalopc (varcalopc_ope, varcalopc_varcal,varcalopc_opcion, varcalopc_expresion, varcalopc_etiqueta, varcalopc_confirmado,varcalopc_tlg) values ('eah2013','cond_activ','1',' t_ocup >=1 ','Ocupado',true,1);
	insert into encu.varcalopc (varcalopc_ope, varcalopc_varcal,varcalopc_opcion, varcalopc_expresion, varcalopc_etiqueta, varcalopc_confirmado,varcalopc_tlg) values ('eah2013','cond_activ','2','t_desoc >=1 ','Desocupado',true,1);
	insert into encu.varcalopc (varcalopc_ope, varcalopc_varcal,varcalopc_opcion, varcalopc_expresion, varcalopc_etiqueta, varcalopc_confirmado,varcalopc_tlg) values ('eah2013','cond_activ','3','t_ina >=1 ','Inactivo',true,1);

--- funcion generadora del trigger
 
set search_path = encu, comun, public;

CREATE OR REPLACE FUNCTION operaciones.generar_trigger_variables_calculadas_i1_trg() RETURNS TEXT 
LANGUAGE plpgsql VOLATILE AS
$CUERPO$
DECLARE
  v_enter text:=chr(13)||chr(10);
  v_script_principio text;
  v_script_final text; 
  v_script_creador text; 
  v_reemplazos record;
  v_variables record;
  v_opciones record;
  v_sentencia text;
  v_expresion text;
  v_variable text;
  v_variable_para_comparar text;
  v_nueva_variable text;
  v_opcion text;
  v_identifica_var_regexp text;
BEGIN
  v_sentencia:='';
---  recorro las variables calculadas para el formulario I1   
  v_identifica_var_regexp := '\m(?!AND)(?!OR)(?!NOT)(?!IS)(?!NULL)(?!IN)(?!TRUE)(?!FALSE)(?!EXISTS)(?!DISTINCT)(?!FROM)(?!BETWEEN)([a-z]\w*)(?!\s*\()\M';
  FOR v_variables in
    select varcal_varcal as i_variable from encu.varcal where varcal_ope = dbo.ope_actual() and varcal_destino = 'mie' 
        LOOP
--- por cada variable recorro sus opciones
        v_sentencia:=v_sentencia||v_enter||' new.pla_'||v_variables.i_variable||':=case ';
        FOR v_opciones IN 
          select varcalopc_opcion as i_opcion, varcalopc_expresion as i_expresion from encu.varcalopc where varcalopc_ope = dbo.ope_actual() and varcalopc_varcal = v_variables.i_variable 
          LOOP
          v_expresion:=v_opciones.i_expresion; 
          FOR v_reemplazos IN
              select distinct(regexp_matches(v_opciones.i_expresion, v_identifica_var_regexp, 'ig')) as una_variable 
              LOOP
                v_variable_para_comparar:=lower(v_reemplazos.una_variable[1]); 
                v_variable:=v_reemplazos.una_variable[1]; 
                v_opcion:=v_opciones.i_opcion;                               
                ---raise notice 'variable %',v_variable ;
                if v_variable_para_comparar in ('sexo','edad','comuna') then
                    v_nueva_variable:='v_'||v_variable_para_comparar;
                else
                    v_nueva_variable:='new.pla_'||v_variable_para_comparar;
                end if;
                v_expresion:=replace(v_expresion,v_variable,v_nueva_variable);
              END LOOP;
              v_sentencia:=v_sentencia||v_enter||'when ('||v_expresion||') then '||v_opcion;
          END LOOP;
          v_sentencia:=v_sentencia||v_enter||' else null end; '||v_enter;
        END LOOP;
--- creo el script para generar
v_script_principio:=$SCRIPT1$

CREATE OR REPLACE FUNCTION encu.calculo_variables_calculadas_i1_trg()
  RETURNS trigger AS
$BODY$
DECLARE
  v_edad integer;
  v_sexo integer;  
  v_comuna integer;
BEGIN
--- lee variables de otros formularios
  select pla_edad, pla_sexo 
    from encu.plana_s1_p  p
    where p.pla_enc = new.pla_enc 
      and p.pla_hog = new.pla_hog  
      and p.pla_mie = new.pla_mie
      and p.pla_exm = new.pla_exm
    into v_edad, v_sexo;
  select pla_comuna from encu.plana_tem_ t
    where t.pla_enc = new.pla_enc 
      and t.pla_hog = new.pla_hog  
      and t.pla_mie = new.pla_mie
      and t.pla_exm = new.pla_exm
    into v_comuna;
$SCRIPT1$;
v_script_final:=$SCRIPT2$
  return new;
END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION encu.calculo_variables_calculadas_i1_trg()
  OWNER TO postgres;

DROP TRIGGER IF EXISTS calculo_variables_calculadas_i1_trg ON encu.plana_i1_;


CREATE TRIGGER calculo_variables_calculadas_i1_trg
  BEFORE UPDATE
  ON encu.plana_i1_
  FOR EACH ROW
  EXECUTE PROCEDURE encu.calculo_variables_calculadas_i1_trg();
$SCRIPT2$;
v_script_creador:= v_script_principio||v_sentencia||v_script_final;
EXECUTE v_script_creador;
  RETURN NULL;
--  RETURN v_script_creador;
END;
$CUERPO$;

--- generar trigger

select operaciones.generar_trigger_variables_calculadas_i1_trg();