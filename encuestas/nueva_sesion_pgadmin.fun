create or replace function comun.nueva_sesion_pgadmin(usuario text, ticket_o_requerimiento text) returns text
  language plpgsql as
$BODY$
<<local>>
DECLARE
  tra_ses encu.sesiones.ses_ses%type;
  tra_tlg encu.tiempo_logico.tlg_tlg%type;
  tipo_tabla_pgadmin boolean;
BEGIN
  SELECT table_type into tipo_tabla_pgadmin 
    FROM information_schema.tables
    WHERE table_name='pgadmin';
  IF tipo_tabla_pgadmin IS NULL THEN
    create temporary table pgadmin(
      pga_user text,
      pga_ses bigint,
      pga_tlg bigint,
      pga_req_o_ticket text
    );
  ELSIF tipo_tabla_pgadmin<>'LOCAL TEMPORARY' THEN
    RAISE EXCEPTION 'existe la tabla pgadmin pero no es LOCAL TEMPORARY es %',tipo_tabla_pgadmin;
  END IF;
  INSERT INTO encu.sesiones(ses_usu, ses_borro_localstorage, ses_activa, ses_phpsessid, ses_httpua, ses_remote_addr)
    VALUES (nueva_sesion_pgadmin.usuario, false , true, 'pgAdminIII: '||nueva_sesion_pgadmin.ticket_o_requerimiento, 0, inet_client_addr())
    RETURNING ses_ses 
    INTO local.tra_ses;
  INSERT INTO encu.tiempo_logico(tlg_ses /* tlg_momento_finalizada*/ ) 
    VALUES (local.tra_ses) 
    RETURNING tlg_tlg
    INTO local.tra_tlg;
  TRUNCATE TABLE pgadmin;
  INSERT INTO pgadmin (pga_user, pga_ses, pga_tlg, pga_req_o_ticket)
    VALUES (nueva_sesion_pgadmin.usuario, local.tra_ses, local.tra_tlg, nueva_sesion_pgadmin.ticket_o_requerimiento);
  RAISE NOTICE 'nuevo tlg: % para % ',local.tra_tlg, nueva_sesion_pgadmin.usuario;
  RETURN local.tra_tlg;
END;
$BODY$;