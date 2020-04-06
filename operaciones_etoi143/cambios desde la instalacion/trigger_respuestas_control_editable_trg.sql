-- Function: encu.respuestas_control_editable_trg()

-- DROP FUNCTION encu.respuestas_control_editable_trg();

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
BEGIN
  select pla_estado, pla_fecha_comenzo_descarga into v_estado, v_fecha_comenzo_descarga from encu.plana_tem_ where pla_enc = new.res_enc;
  select est_editar_encuesta, est_editar_TEM into v_editable, v_edtem from encu.estados where est_est = v_estado and est_ope = dbo.ope_actual();

  if (new.res_for<>'TEM' and v_editable = 'nunca') or (new.res_for = 'TEM' and v_edtem = 'nunca') then
    raise 'ENCUESTA % NO HABILITADA PARA INGRESAR. ESTADO %', new.res_enc, v_estado;
  end if;

  if new.res_for<>'TEM' and v_editable = 'descargando' then
   if v_fecha_comenzo_descarga is  null then 
     raise 'ENCUESTA % NO HABILITADA PARA INGRESAR. ESTADO %', new.res_enc, v_estado;
   else 
     if now()-v_fecha_comenzo_descarga > '10 MINUTES'::INTERVAL then
         raise 'ENCUESTA % NO HABILITADA PARA INGRESAR. ESTADO %', new.res_enc, v_estado;
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
        raise 'ENCUESTA % NO HABILITADA PARA INGRESAR. ESTADO %', new.res_enc, v_estado;
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
         raise 'ENCUESTA % NO HABILITADA PARA INGRESAR. ESTADO %', new.res_enc, v_estado;
      end if;    
  end if;
  RETURN new;
END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION encu.respuestas_control_editable_trg()
  OWNER TO tedede_php;

-- Trigger: respuestas_control_editable_trg on encu.respuestas

-- DROP TRIGGER respuestas_control_editable_trg ON encu.respuestas;

CREATE TRIGGER respuestas_control_editable_trg
  BEFORE UPDATE
  ON encu.respuestas
  FOR EACH ROW
  EXECUTE PROCEDURE encu.respuestas_control_editable_trg();