set search_path = encu, comun, public;
/*OTRA*/
CREATE OR REPLACE FUNCTION operaciones.generar_calculo_estado_trg() RETURNS TEXT 
LANGUAGE plpgsql VOLATILE AS
$CUERPO$
DECLARE
  v_enter text:=chr(13)||chr(10);
  v_script_creador text;
  v_reemplazo_1 text;
  v_reemplazos record;
  otro_orden integer;
BEGIN
v_script_creador:=$SCRIPT$
-- alter table encu.plana_tem_ drop column if exists pla_sup_dirigida_enc; alter table encu.plana_tem_ add column pla_sup_dirigida_enc integer; /*G*/

-- DROP FUNCTION encu.calculo_estado_trg();
-- set search_path = encu, comun, public;

CREATE OR REPLACE FUNCTION encu.calculo_estado_trg()
  RETURNS trigger AS
$BODY$
DECLARE
  v_estado_final integer;
  
  v_sup_dirigida_enc encu.plana_tem_.pla_sup_dirigida_enc%type; /*G*/
  
  v_en_campo_nuevo encu.plana_tem_.pla_en_campo%type; v_en_campo_viejo encu.plana_tem_.pla_en_campo%type; /*G*/
  
  v_rol_nuevo encu.plana_tem_.pla_rol%type; v_rol_viejo encu.plana_tem_.pla_rol%type; /*G_amano*/
  
  v_per_nuevo encu.plana_tem_.pla_per%type; v_per_viejo encu.plana_tem_.pla_per%type; /*G_amano*/
  
  v_calculo_enc integer;  
  v_calculo_recu integer;  
  i_sufijo integer;
  v_sufijo text;
  v_aux_aleat_enc text;
  v_aux_aleat_recu text;
BEGIN
  if new.res_for='TEM' and 
        (new.res_valor is distinct from old.res_valor 
        or new.res_valesp is distinct from old.res_valesp 
        or new.res_valor_con_error is distinct from old.res_valor_con_error 
        or new.res_var = 'asignable'
        ) 
     and new.res_var<>'estado' -- porque vamos a actualizar el estado
  then
    if new.res_var='verificado_enc' and new.res_valor::integer<>2 then
        select pla_rea_enc, pla_dominio, (pla_enc*23 + pla_replica + pla_comuna*7 + coalesce(pla_id_marco,0)*21 + coalesce(pla_ccodigo,0)) % 10
            into   v_rea_enc, v_dominio, v_calculo_enc
            from encu.plana_tem_
            where pla_enc=new.res_enc and pla_hog=new.res_hog and pla_mie=new.res_mie and pla_exm=new.res_exm;  
        if v_rea_enc = 1 and v_dominio = 3 then
            if v_calculo_enc = 1 then
                v_aux_aleat_enc := '3';
            elsif v_calculo_enc = 0 then
                v_aux_aleat_enc='4';
            end if;
            UPDATE encu.respuestas
                SET res_valor=v_aux_aleat_enc, res_valesp=null, res_valor_con_error=null, res_tlg=new.res_tlg
                    WHERE res_ope=new.res_ope
                        and res_for=new.res_for
                        and res_mat=new.res_mat
                        and res_enc=new.res_enc
                        and res_hog=new.res_hog
                        and res_mie=new.res_mie 
                        and res_exm=new.res_exm 
                        and res_var='sup_aleat'; 
        end if;
    elsif new.res_var='verificado_recu' and new.res_valor::integer<>2 then
        select pla_rea_recu, pla_dominio, ((pla_enc*23 + pla_replica + pla_comuna*7 + coalesce(pla_id_marco,0)*21 + coalesce(pla_ccodigo,0)) % 10)
            into   v_rea_recu, v_dominio, v_calculo_recu
            from encu.plana_tem_
            where pla_enc=new.res_enc and pla_hog=new.res_hog and pla_mie=new.res_mie and pla_exm=new.res_exm;  
        if v_rea_recu = 3 and v_dominio = 3 then
            if v_calculo_recu = 8 then
                v_aux_aleat_recu := '3';
            elsif v_calculo_recu = 7 then
                v_aux_aleat_recu := '4';
            end if;
            UPDATE encu.respuestas
                SET res_valor=v_aux_aleat_recu::text, res_valesp=null, res_valor_con_error=null, res_tlg=new.res_tlg
                    WHERE res_ope=new.res_ope
                        and res_for=new.res_for
                        and res_mat=new.res_mat
                        and res_enc=new.res_enc
                        and res_hog=new.res_hog
                        and res_mie=new.res_mie 
                        and res_exm=new.res_exm 
                        and res_var='sup_aleat'; 
        end if;
    end if;
    select pla_sup_dirigida_enc /*G*/
      into   v_sup_dirigida_enc /*G*/
      from encu.plana_tem_
      where pla_enc=new.res_enc and pla_hog=new.res_hog and pla_mie=new.res_mie and pla_exm=new.res_exm; /*G:PK*/ -- pk_verificada
    if v_estado_final is null and (v_result_supe>0 /*G:C*/) then v_estado_final:=47 /*G:NumE*/; end if; /*G:E*/
    if v_estado_final is distinct from v_estado then
      UPDATE encu.respuestas
        SET res_valor=v_estado_final, res_valesp=null, res_valor_con_error=null, res_tlg=new.res_tlg
        WHERE res_ope=new.res_ope
          and res_for=new.res_for
          and res_mat=new.res_mat
          and res_enc=new.res_enc
          and res_hog=new.res_hog
          and res_mie=new.res_mie 
          and res_exm=new.res_exm /*G:PK*/ 
          and res_var='estado'; -- pk_verificada
    end if;
  end if;
  for i_sufijo in 1..2 loop
      if i_sufijo=1 then
          v_sufijo='enc';
      else
          v_sufijo='recu';
      end if;
      if new.res_var='volver_a_cargar_'||v_sufijo and new.res_valor>='1' then
         UPDATE encu.respuestas
           SET res_valor=null, res_valesp=null, res_valor_con_error=null, res_tlg=new.res_tlg
           WHERE res_ope=new.res_ope
             and res_for=new.res_for
             and res_mat=new.res_mat
             and res_enc=new.res_enc
             and res_hog=new.res_hog
             and res_mie=new.res_mie 
             and res_exm=new.res_exm 
             and res_var in ('fecha_carga_'||v_sufijo,'fecha_descarga_'||v_sufijo,'a_ingreso_'||v_sufijo,'con_dato_'||v_sufijo,'fin_ingreso_'||v_sufijo) -- pk_verificada
             and (res_valor is not null or res_valesp is not null or res_valor_con_error is not null);
      end if;
      if new.res_var='fecha_carga_'||v_sufijo and new.res_valor>'1' then
         UPDATE encu.respuestas
           SET res_valor=null, res_valesp=null, res_valor_con_error=null, res_tlg=new.res_tlg
           WHERE res_ope=new.res_ope
             and res_for=new.res_for
             and res_mat=new.res_mat
             and res_enc=new.res_enc
             and res_hog=new.res_hog
             and res_mie=new.res_mie 
             and res_exm=new.res_exm 
             and res_var = 'volver_a_cargar_'||v_sufijo -- pk_verificada
             and (res_valor is not null or res_valesp is not null or res_valor_con_error is not null);
      end if;
      if new.res_var='a_ingreso_'||v_sufijo and new.res_valor='1' then
         UPDATE encu.respuestas
           SET res_valor='2', res_valesp=null, res_valor_con_error=null, res_tlg=new.res_tlg
           WHERE res_ope=new.res_ope
             and res_for=new.res_for
             and res_mat=new.res_mat
             and res_enc=new.res_enc
             and res_hog=new.res_hog
             and res_mie=new.res_mie 
             and res_exm=new.res_exm 
             and res_var = 'con_dato_'||v_sufijo -- pk_verificada
             and (res_valor is distinct from '2' or res_valesp is not null or res_valor_con_error is not null);
      end if;
  end loop;
-- seccion variables calculadas
  select 
      case when pla_estado in (23,24,33,34,44,54) then 1 else 0 end, pla_en_campo, /*G*/
      case when pla_estado<=29 then 'encuestador'  when pla_estado<=39 then 'recuperador' 
           when pla_estado<59 then  'supervisor'  else null end, pla_rol, /*G_amano*/
      case when pla_estado<=29 then pla_cod_enc when pla_estado<=39 then pla_cod_recu when pla_estado<49 then pla_cod_sup 
           when pla_estado<59 then pla_cod_sup else null end, pla_per /*G_amano*/
    into 
      v_en_campo_nuevo, v_en_campo_viejo, /*G*/
      v_rol_nuevo, v_rol_viejo, /*G_amano*/
      v_per_nuevo, v_per_viejo /*G_amano*/
    from encu.plana_tem_
    where pla_enc=new.res_enc and pla_hog=new.res_hog and pla_mie=new.res_mie and pla_exm=new.res_exm;
  if v_en_campo_nuevo is distinct from v_en_campo_viejo then
    UPDATE encu.respuestas
       SET res_valor=v_en_campo_nuevo, res_valesp=null, res_valor_con_error=null, res_tlg=new.res_tlg
       WHERE res_ope=new.res_ope
         and res_for=new.res_for
         and res_mat=new.res_mat
         and res_enc=new.res_enc
         and res_hog=new.res_hog
         and res_mie=new.res_mie 
         and res_exm=new.res_exm 
         and res_var = 'en_campo'; -- pk_verificada
  end if; /*G*/
  if v_rol_nuevo is distinct from v_rol_viejo then
    UPDATE encu.respuestas
       SET res_valor=v_rol_nuevo, res_valesp=null, res_valor_con_error=null, res_tlg=new.res_tlg
       WHERE res_ope=new.res_ope
         and res_for=new.res_for
         and res_mat=new.res_mat
         and res_enc=new.res_enc
         and res_hog=new.res_hog
         and res_mie=new.res_mie 
         and res_exm=new.res_exm 
         and res_var = 'rol'; -- pk_verificada
  end if; /*G_amano*/
  if v_per_nuevo is distinct from v_per_viejo then
    UPDATE encu.respuestas
       SET res_valor=v_per_nuevo, res_valesp=null, res_valor_con_error=null, res_tlg=new.res_tlg
       WHERE res_ope=new.res_ope
         and res_for=new.res_for
         and res_mat=new.res_mat
         and res_enc=new.res_enc
         and res_hog=new.res_hog
         and res_mie=new.res_mie 
         and res_exm=new.res_exm 
         and res_var = 'per'; -- pk_verificada
  end if; /*G_amano*/
  RETURN new;
END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION encu.calculo_estado_trg()
  OWNER TO tedede_php;

DROP TRIGGER IF EXISTS calculo_estado_trg ON encu.respuestas;


CREATE TRIGGER calculo_estado_trg
  AFTER UPDATE
  ON encu.respuestas
  FOR EACH ROW
  EXECUTE PROCEDURE encu.calculo_estado_trg();
$SCRIPT$;
  SELECT MAX(pre_orden)+100 INTO otro_orden 
  FROM encu.variables INNER JOIN encu.preguntas ON pre_ope=var_ope AND pre_pre=var_pre WHERE pre_for='TEM';

  FOR v_reemplazos IN
    SELECT v_enter as separador, '-- alter table encu.plana_tem_ drop column if exists pla_sup_dirigida_enc; alter table encu.plana_tem_ add column pla_sup_dirigida_enc integer; /*G*/' as que_reemplazar
    UNION SELECT v_enter,'  v_sup_dirigida_enc encu.plana_tem_.pla_sup_dirigida_enc%type; /*G*/'
    UNION SELECT ', '   ,'pla_sup_dirigida_enc /*G*/'
    UNION SELECT ','    ,'  v_sup_dirigida_enc /*G*/'
  LOOP
    SELECT string_agg(replace(replace(v_reemplazos.que_reemplazar,'sup_dirigida_enc',var_var),'integer',case when var_tipovar='timestamp' then 'timestamp without time zone' when var_tipovar = 'texto' then 'text' else 'integer' end),v_reemplazos.separador ORDER BY pre_orden)
        INTO v_reemplazo_1
        FROM (select var_var, var_tipovar, pre_orden from encu.variables 
              inner join encu.preguntas on pre_ope=var_ope and pre_pre=var_pre where pre_for='TEM'
              union select 'dominio' as var_var, 'numeros' as var_tipovar, otro_orden as pre_orden ) as a;
    v_script_creador:=replace(v_script_creador,v_reemplazos.que_reemplazar,v_reemplazo_1);
  END LOOP;
  FOR v_reemplazos IN
    SELECT v_enter as separador, '    if v_estado_final is null and (v_result_supe>0 /*G:C*/) then v_estado_final:=47 /*G:NumE*/; end if; /*G:E*/'::text as que_reemplazar
  LOOP
    SELECT string_agg(replace(replace(v_reemplazos.que_reemplazar,
             'v_result_supe>0 /*G:C*/',comun.reemplazar_variables(est_criterio,'v_\1')),
             '47 /*G:NumE*/',est_est::text
             ),v_reemplazos.separador ORDER BY est_est DESC)
       INTO v_reemplazo_1
        FROM encu.estados
        WHERE trim(est_criterio)<>'';
    v_script_creador:=replace(v_script_creador,v_reemplazos.que_reemplazar,v_reemplazo_1);
  END LOOP;
  EXECUTE v_script_creador;
  RETURN NULL;
--  RETURN v_script_creador;
END;
$CUERPO$;
/*OTRA*/
CREATE OR REPLACE FUNCTION operaciones.migrar_una_clave(p_ope text, p_tabla_origen text, p_for text, p_mat text, p_venc text, p_vhog text, p_vmie text, p_vexm text)
  RETURNS void AS
$BODY$
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
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*OTRA*/  
ALTER FUNCTION operaciones.migrar_una_clave(text, text, text, text, text, text, text, text)
  OWNER TO postgres;
/*OTRA*/
CREATE OR REPLACE FUNCTION operaciones.migrar_una_variable(p_ope text, p_tabla_origen text, p_for text, p_mat text, p_var text, p_venc text, p_vhog text, p_vmie text, p_vexm text)
  RETURNS void AS
$BODY$
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
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*OTRA*/  
ALTER FUNCTION operaciones.migrar_una_variable(text, text, text, text, text, text, text, text, text)
  OWNER TO postgres;
/*OTRA*/