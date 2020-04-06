select operaciones.generar_calculo_estado_trg();
/*OTRA*/
select encu.generar_trigger_variables_calculadas('#todo');
/*OTRA*/
CREATE OR REPLACE FUNCTION encu.disparar_variables_calculadas_s1_p_trg()
  RETURNS trigger AS
$BODY$
    BEGIN
    if new.pla_edad is distinct from old.pla_edad or new.pla_sexo is distinct from old.pla_sexo or new.pla_f_nac_d is distinct from old.pla_f_nac_d or new.pla_f_nac_m is distinct from old.pla_f_nac_m or new.pla_f_nac_a is distinct from old.pla_f_nac_a or new.pla_p4 is distinct from old.pla_p4 or new.pla_p5 is distinct from old.pla_p5 or new.pla_p5b is distinct from old.pla_p5b or new.pla_p6_a is distinct from old.pla_p6_a or new.pla_p6_b is distinct from old.pla_p6_b then
        update encu.plana_i1_
                set pla_obs = pla_obs
                where pla_enc = new.pla_enc
                and pla_hog = new.pla_hog
                and pla_mie = new.pla_mie
                and pla_exm = 0;
    end if;
    return new;
    END
  $BODY$
  LANGUAGE plpgsql VOLATILE;
/*OTRA*/
ALTER FUNCTION encu.disparar_variables_calculadas_s1_p_trg()
  OWNER TO tedede_php;
/*OTRA*/
CREATE TRIGGER disparar_variables_calculadas_s1_p_trg
  AFTER UPDATE
  ON encu.plana_s1_p
  FOR EACH ROW
  EXECUTE PROCEDURE encu.disparar_variables_calculadas_s1_p_trg();
/*OTRA*/
CREATE OR REPLACE FUNCTION encu.disparar_variables_calculadas_a1__trg()
  RETURNS trigger AS
$BODY$
    BEGIN
    if new.pla_h2 is distinct from old.pla_h2 or new.pla_h3 is distinct from old.pla_h3 then
        update encu.plana_s1_
                set pla_movil = pla_movil
                where pla_enc = new.pla_enc
                and pla_hog = new.pla_hog
                and pla_mie = 0
                and pla_exm = 0;
    end if;
    if new.pla_v2 is distinct from old.pla_v2 then
        update encu.plana_s1_
                set pla_movil = pla_movil
                where pla_enc = new.pla_enc
--                and pla_hog = new.pla_hog  PORQUE v2 está informada solo en hogar 1
                and pla_mie = 0
                and pla_exm = 0;
        update encu.plana_i1_
                set pla_obs = pla_obs
                where pla_enc = new.pla_enc;
--                and pla_hog = new.pla_hog  PORQUE v2 está informada solo en hogar 1
    end if;
    return new;
    END
  $BODY$
  LANGUAGE plpgsql VOLATILE;
/*OTRA*/
ALTER FUNCTION encu.disparar_variables_calculadas_a1__trg()
  OWNER TO tedede_php;
/*OTRA*/
CREATE TRIGGER disparar_variables_calculadas_a1__trg
  AFTER UPDATE
  ON encu.plana_a1_
  FOR EACH ROW
  EXECUTE PROCEDURE encu.disparar_variables_calculadas_a1__trg();
/*OTRA*/
CREATE OR REPLACE FUNCTION encu.pase_a_procesamiento_trg()
  RETURNS trigger AS
$BODY$
DECLARE
BEGIN
  IF new.pla_estado>=70 AND old.pla_estado<70 THEN
    INSERT INTO his.plana_a1_  SELECT current_timestamp, * FROM encu.plana_a1_  WHERE pla_enc=new.pla_enc;
    INSERT INTO his.plana_a1_x SELECT current_timestamp, * FROM encu.plana_a1_x WHERE pla_enc=new.pla_enc;
    INSERT INTO his.plana_i1_  SELECT current_timestamp, * FROM encu.plana_i1_  WHERE pla_enc=new.pla_enc;
    INSERT INTO his.plana_s1_  SELECT current_timestamp, * FROM encu.plana_s1_  WHERE pla_enc=new.pla_enc;
    INSERT INTO his.plana_s1_p SELECT current_timestamp, * FROM encu.plana_s1_p  WHERE pla_enc=new.pla_enc;
  END IF;
  RETURN new;
END
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*OTRA*/  
ALTER FUNCTION encu.pase_a_procesamiento_trg()
  OWNER TO tedede_php;
/*OTRA*/
CREATE TRIGGER pase_a_procesamiento_trg
  AFTER UPDATE
  ON encu.plana_tem_
  FOR EACH ROW
  EXECUTE PROCEDURE encu.pase_a_procesamiento_trg();
/*OTRA*/
CREATE OR REPLACE FUNCTION encu.plana_tem_control_editar_variables_trg()
  RETURNS trigger AS
$BODY$
DECLARE

BEGIN
  if new.pla_cnombre <> old.pla_cnombre OR new.pla_hn <> old.pla_hn then
    if new.pla_dominio <> 5 then
       raise 'NO PUEDE MODIFICAR LA DIRECCION Y/O NRO. DOMINIO % ', new.pla_dominio;
    end if;
  end if;
  RETURN new;
END
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*OTRA*/  
ALTER FUNCTION encu.plana_tem_control_editar_variables_trg()
  OWNER TO tedede_php;
/*OTRA*/
CREATE TRIGGER plana_tem_control_editar_variables_trg
  BEFORE UPDATE
  ON encu.plana_tem_
  FOR EACH ROW
  EXECUTE PROCEDURE encu.plana_tem_control_editar_variables_trg();
/*OTRA*/
CREATE OR REPLACE FUNCTION encu.recalcular_mie_bu_i1_trg()
  RETURNS trigger AS
$BODY$
    BEGIN
    if TG_OP='UPDATE' then
       if new.pla_enc is distinct from old.pla_enc then
          perform dbo.recalcular_mie_bu(old.pla_enc);
          perform dbo.recalcular_mie_bu(new.pla_enc);
       elsif new.pla_hog is distinct from old.pla_hog or new.pla_mie is distinct from old.pla_mie then
          perform dbo.recalcular_mie_bu(new.pla_enc);
       end if;
       RETURN new;
    elsif TG_OP='INSERT' then
          perform dbo.recalcular_mie_bu(new.pla_enc);
          RETURN new;
    elsif TG_OP='DELETE' then
          perform dbo.recalcular_mie_bu(old.pla_enc);
          RETURN old;
    end if;
    END
  $BODY$
  LANGUAGE plpgsql VOLATILE;
/*OTRA*/  
ALTER FUNCTION encu.recalcular_mie_bu_i1_trg()
  OWNER TO tedede_php;
/*OTRA*/  
CREATE TRIGGER recalcular_mie_bu_i1_trg
  AFTER INSERT OR UPDATE OR DELETE
  ON encu.plana_i1_
  FOR EACH ROW
  EXECUTE PROCEDURE encu.recalcular_mie_bu_i1_trg();
/*OTRA*/
CREATE OR REPLACE FUNCTION encu.recalcular_mie_bu_s1_p_trg()
  RETURNS trigger AS
$BODY$
    BEGIN
    if TG_OP='UPDATE' then
       if new.pla_enc is distinct from old.pla_enc then
          perform dbo.recalcular_mie_bu(old.pla_enc);
          perform dbo.recalcular_mie_bu(new.pla_enc);
       elsif new.pla_hog is distinct from old.pla_hog or new.pla_mie is distinct from old.pla_mie or new.pla_p4 is distinct from old.pla_p4 then
          perform dbo.recalcular_mie_bu(new.pla_enc);
       end if;
       RETURN new;
    elsif TG_OP='INSERT' then
          perform dbo.recalcular_mie_bu(new.pla_enc);
          RETURN new;
    elsif TG_OP='DELETE' then
          perform dbo.recalcular_mie_bu(old.pla_enc);
          RETURN old;
    end if;
    END
  $BODY$
  LANGUAGE plpgsql VOLATILE;
/*OTRA*/  
ALTER FUNCTION encu.recalcular_mie_bu_s1_p_trg()
  OWNER TO tedede_php;
/*OTRA*/
CREATE TRIGGER recalcular_mie_bu_s1_p_trg
  AFTER INSERT OR UPDATE OR DELETE
  ON encu.plana_s1_p
  FOR EACH ROW
  EXECUTE PROCEDURE encu.recalcular_mie_bu_s1_p_trg();
/*OTRA*/
CREATE OR REPLACE FUNCTION encu.respuestas_control_editable_trg()
  RETURNS trigger AS
$BODY$
DECLARE
  v_estado integer;
  v_editable text:='nunca';
  v_edtem text:='nunca';
  v_fecha_comenzo_descarga timestamp without time zone;
  --v_rol character varying(30);
  v_permitido boolean;
  v_permitidotem boolean;
  v_rea integer;
  v_norea integer;
BEGIN
  select pla_estado, pla_fecha_comenzo_descarga, pla_rea, pla_norea
    into   v_estado,   v_fecha_comenzo_descarga,   v_rea,   v_norea
    from encu.plana_tem_ 
    where pla_enc = new.res_enc;
  select est_editar_encuesta, est_editar_TEM into v_editable, v_edtem from encu.estados where est_est = v_estado and est_ope = dbo.ope_actual();

  if (new.res_for<>'TEM' and v_editable = 'nunca') or (new.res_for = 'TEM' and v_edtem = 'nunca') then
    raise 'ENCUESTA % NO HABILITADA PARA PROC 1,%,%. ESTADO %', new.res_enc, v_rea, v_norea, v_estado;
  end if;

  if new.res_for<>'TEM' and v_editable = 'descargando' then
   if v_fecha_comenzo_descarga is  null then 
     raise 'ENCUESTA % NO HABILITADA PARA PROC 2. ESTADO %', new.res_enc, v_estado;
   else 
     if now()-v_fecha_comenzo_descarga > '10 MINUTES'::INTERVAL then
         raise 'ENCUESTA % NO HABILITADA PARA PROC 3. ESTADO %', new.res_enc, v_estado;
     end if;
   end if;
  end if;

  if new.res_for<>'TEM' and v_editable <> 'siempre' and v_editable <> 'descargando' then
      select case when r.rolrol_delegado is not null or u.usu_rol = v_editable then true else false end into v_permitido 
      from encu.tiempo_logico l 
        inner join encu.sesiones s on l.tlg_ses = s.ses_ses
        inner join encu.usuarios u on s.ses_usu = u.usu_usu
        left join encu.rol_rol r on u.usu_rol = r.rolrol_principal and r.rolrol_delegado = v_editable   
      where l.tlg_tlg = new.res_tlg;
      if not v_permitido then
        raise 'ENCUESTA % NO HABILITADA PARA PROC 4. ESTADO %', new.res_enc, v_estado;
      end if;    
  end if;    
  
  if new.res_for = 'TEM' and v_edtem <> 'siempre' then
      select case when r.rolrol_delegado is not null or u.usu_rol = v_edtem then true else false end into v_permitidotem 
      from encu.tiempo_logico l 
        inner join encu.sesiones s on l.tlg_ses = s.ses_ses
        inner join encu.usuarios u on s.ses_usu = u.usu_usu
        left join encu.rol_rol r on u.usu_rol = r.rolrol_principal and r.rolrol_delegado = v_edtem   
      where l.tlg_tlg = new.res_tlg;
      if not v_permitidotem then
         raise 'ENCUESTA % NO HABILITADA PARA PROC 5. ESTADO %', new.res_enc, v_estado;
      end if;    
  end if;
  RETURN new;
END
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*OTRA*/
ALTER FUNCTION encu.respuestas_control_editable_trg()
  OWNER TO tedede_php;
/*OTRA*/
CREATE TRIGGER respuestas_control_editable_trg
  BEFORE UPDATE
  ON encu.respuestas
  FOR EACH ROW
  EXECUTE PROCEDURE encu.respuestas_control_editable_trg();
/*OTRA*/
CREATE OR REPLACE FUNCTION encu.respuestas_control_justificaciones_trg()
  RETURNS trigger AS
$BODY$
DECLARE
  v_nojustificadas integer;
  v_select text;
  v_from text;
  v_where text;
  v_rol text;
  v_valor text;
  v_norea text;
  v_estado integer;
BEGIN
  if (new.res_var like 'verificado%' or new.res_var='fin_anacon') and new.res_valor = '1' then
     v_nojustificadas := 0;
     SELECT COUNT(*) into v_nojustificadas 
       FROM encu.inconsistencias
       WHERE inc_ope= new.res_ope and inc_enc= new.res_enc and (inc_justificacion is null or trim(inc_justificacion)='')
             and inc_con <> 'opc_inconsistente' 
             and inc_con not in (select con_con from encu.consistencias where con_ope=dbo.ope_actual() and con_momento = 'Procesamiento');
     if v_nojustificadas> 0 then
         raise 'NO SE PUEDE VERIFICAR LA ENCUESTA % TIENE % INCONSISTENCIAS SIN JUSTIFICAR',new.res_enc, v_nojustificadas;
     end if;
  end if;
  if ((new.res_var like 'verificado%' and new.res_var not like '%_ac') or new.res_var='fin_anacon') and (new.res_valor = '1' or new.res_valor = '4') then
     v_valor = null;
     v_select = $$
        SELECT res_valor
     $$;
     v_from := $$
        FROM encu.respuestas
     $$;
     v_where := $$
        WHERE res_ope = $1 AND res_for = $2 AND res_mat = $3 AND res_enc = $4 and res_hog = $5 AND 
              res_mie = $6 AND res_exm = $7 AND res_var = 'cod_'||split_part($8, '_', 2);        
        --PK DE encu.respuestas :res_ope, res_for, res_mat, res_enc, res_hog, res_mie, res_exm, res_var
     $$;
     EXECUTE v_select||v_from||v_where INTO v_valor USING new.res_ope, new.res_for, new.res_mat, new.res_enc, new.res_hog, new.res_mie, new.res_exm, new.res_var;
     IF v_valor IS NULL THEN
         v_rol := case when new.res_var like '%_enc'    then 'ENCUESTADOR'
                       when new.res_var like '%_sup'    then 'SUPERVISOR'
                       when new.res_var like '%_recu'   then 'RECUPERADOR'
                       when new.res_var like '%_anacon' then 'ANACON'
                  end;          
         raise 'NO SE PUEDE VERIFICAR LA ENCUESTA % PORQUE NO SE HA ESPECIFICADO EL CODIGO DE %',new.res_enc, v_rol;
     END IF;
  end if;
  if new.res_var like 'verificado%' and new.res_valor = '1' then
     SELECT res_valor INTO v_norea
     FROM encu.respuestas
     WHERE res_ope = new.res_ope AND res_for = new.res_for AND res_mat = new.res_mat AND res_enc = new.res_enc and res_hog = new.res_hog AND 
           res_mie = new.res_mie AND res_exm = new.res_exm AND res_var = 'norea';
     if v_norea = '18' then
       raise 'NOREA=18 solo permite verificado=4';
     end if;     
  end if;
  if new.res_var like 'verificado%' and new.res_valor = '1' then
     SELECT pla_estado into v_estado
     FROM encu.plana_tem_ 
     WHERE pla_enc = new.res_enc and pla_hog = new.res_hog and pla_mie = new.res_mie and pla_exm = new.res_exm;
     IF v_estado = 23 or v_estado = 24 or v_estado = 33 or v_estado = 34 then
         raise 'NO SE PUEDE VERIFICAR LA ENCUESTA % PORQUE SE ENCUENTRA EN ESTADO %',new.res_enc, v_estado;
     END IF;
  end if;
  RETURN new;
END
$BODY$
  LANGUAGE plpgsql STABLE;
/*OTRA*/  
ALTER FUNCTION encu.respuestas_control_justificaciones_trg()
  OWNER TO tedede_php;
/*OTRA*/
CREATE TRIGGER respuestas_control_justificaciones_trg
  BEFORE UPDATE
  ON encu.respuestas
  FOR EACH ROW
  EXECUTE PROCEDURE encu.respuestas_control_justificaciones_trg();
/*OTRA*/
CREATE OR REPLACE FUNCTION encu.respuestas_sinc_tem_trg()
  RETURNS trigger AS
$BODY$
DECLARE
  rvar  RECORD;
  p_ope text;
  p_enc integer;
BEGIN
  IF new.res_for<>'TEM' and (
      new.res_valor is distinct from old.res_valor or 
      new.res_valesp is distinct from old.res_valesp or 
      new.res_valor_con_error is distinct from old.res_valor_con_error or 
      new.res_var='obs'
  ) THEN
    p_ope:=new.res_ope;
    p_enc=new.res_enc;
    rvar:= encu.sincronizacion_tem_datos(p_ope, p_enc); 
    update encu.respuestas 
      set res_valor=rvar.p_rea
      where res_ope=p_ope and res_for='TEM' and  res_mat=''  and res_enc=p_enc and res_mie=0 and res_exm=0
        and res_var='rea'
        and res_valor is distinct from rvar.p_rea::text;
    update encu.respuestas 
      set res_valor=rvar.p_norea
      where res_ope=p_ope and res_for='TEM' and  res_mat=''  and res_enc=p_enc and res_mie=0 and res_exm=0
        and res_var='norea'
        and res_valor is distinct from rvar.p_norea::text;
    update encu.respuestas 
      set res_valor=rvar.p_rea_enc
      where res_ope=p_ope and res_for='TEM' and  res_mat=''  and res_enc=p_enc and res_mie=0 and res_exm=0
        and res_var='rea_enc'
        and res_valor is distinct from rvar.p_rea_enc::text;
    update encu.respuestas 
      set res_valor=rvar.p_norea_enc
      where res_ope=p_ope and res_for='TEM' and  res_mat=''  and res_enc=p_enc and res_mie=0 and res_exm=0
        and res_var='norea_enc'
        and res_valor is distinct from rvar.p_norea_enc::text;
    update encu.respuestas 
      set res_valor=rvar.p_con_dato_enc
      where res_ope=p_ope and res_for='TEM' and  res_mat=''  and res_enc=p_enc and res_mie=0 and res_exm=0
        and res_var='con_dato_enc'
        and res_valor is distinct from rvar.p_con_dato_enc::text;
    update encu.respuestas 
      set res_valor=rvar.p_rea_recu
      where res_ope=p_ope and res_for='TEM' and  res_mat=''  and res_enc=p_enc and res_mie=0 and res_exm=0
        and res_var='rea_recu'
        and res_valor is distinct from rvar.p_rea_recu::text;
    update encu.respuestas 
      set res_valor=rvar.p_norea_recu
      where res_ope=p_ope and res_for='TEM' and  res_mat=''  and res_enc=p_enc and res_mie=0 and res_exm=0
        and res_var='norea_recu'
        and res_valor is distinct from rvar.p_norea_recu::text;
    update encu.respuestas 
      set res_valor=rvar.p_con_dato_recu
      where res_ope=p_ope and res_for='TEM' and  res_mat=''  and res_enc=p_enc and res_mie=0 and res_exm=0
        and res_var='con_dato_recu'
        and res_valor is distinct from rvar.p_con_dato_recu::text;
    update encu.respuestas 
      set res_valor=rvar.p_pob_tot
      where res_ope=p_ope and res_for='TEM' and  res_mat=''  and res_enc=p_enc and res_mie=0 and res_exm=0
        and res_var='pob_tot'
        and res_valor is distinct from rvar.p_pob_tot::text;
    update encu.respuestas 
      set res_valor=rvar.p_pob_pre
      where res_ope=p_ope and res_for='TEM' and  res_mat=''  and res_enc=p_enc and res_mie=0 and res_exm=0
        and res_var='pob_pre'
        and res_valor is distinct from rvar.p_pob_pre::text;
    update encu.respuestas 
      set res_valor=rvar.p_hog_tot
      where res_ope=p_ope and res_for='TEM' and  res_mat=''  and res_enc=p_enc and res_mie=0 and res_exm=0
        and res_var='hog_tot'
        and res_valor is distinct from rvar.p_hog_tot::text;
    update encu.respuestas 
      set res_valor=rvar.p_hog_pre
      where res_ope=p_ope and res_for='TEM' and  res_mat=''  and res_enc=p_enc and res_mie=0 and res_exm=0
        and res_var='hog_pre'
        and res_valor is distinct from rvar.p_hog_pre::text;
  END IF;
RETURN new;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*OTRA*/  
ALTER FUNCTION encu.respuestas_sinc_tem_trg()
  OWNER TO tedede_php;
/*OTRA*/
CREATE TRIGGER respuestas_sinc_tem_trg
  AFTER UPDATE
  ON encu.respuestas
  FOR EACH ROW
  EXECUTE PROCEDURE encu.respuestas_sinc_tem_trg();  