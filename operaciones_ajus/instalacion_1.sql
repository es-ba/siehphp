DELETE FROM encu.usuarios WHERE usu_usu<>'instalador';

INSERT INTO encu.usuarios(
            usu_usu, usu_rol, usu_clave, usu_activo, usu_nombre, usu_apellido, 
            usu_interno, usu_mail, usu_tlg)
  SELECT usu_usu, usu_rol, usu_clave, usu_activo, usu_nombre, usu_apellido, 
            usu_interno, usu_mail, 1
    FROM old_encu.usuarios
    WHERE usu_usu<>'instalador';

UPDATE encu.http_user_agent SET httpua_texto='INSTALANDO '||httpua_httpua;
    
INSERT INTO encu.http_user_agent
  SELECT * 
    FROM old_encu.http_user_agent
    WHERE httpua_httpua>1;
    
UPDATE encu.http_user_agent d
  SET httpua_texto=o.httpua_texto
  FROM old_encu.http_user_agent o
  WHERE d.httpua_httpua=o.httpua_httpua;
    
INSERT INTO encu.sesiones(
            ses_ses, ses_usu, ses_momento, ses_borro_localstorage, ses_activa, 
            ses_phpsessid, ses_httpua, ses_remote_addr, ses_momento_finalizada, 
            ses_razon_finalizada)
  SELECT ses_ses, ses_usu, ses_momento, ses_borro_localstorage, ses_activa, 
            ses_phpsessid, ses_httpua, ses_remote_addr, ses_momento_finalizada, 
            ses_razon_finalizada
    FROM old_encu.sesiones
    WHERE ses_ses>2; 

INSERT INTO encu.tiempo_logico(
            tlg_tlg, tlg_ses, tlg_momento, tlg_momento_finalizada)    
  SELECT tlg_tlg, tlg_ses, tlg_momento, tlg_momento_finalizada
    FROM old_encu.tiempo_logico
    WHERE tlg_tlg>2;

  
INSERT INTO encu.claves(
            cla_ope, cla_for, cla_mat, cla_enc, cla_hog, cla_mie, cla_aux_es_enc, 
            cla_aux_es_hog, cla_aux_es_mie, cla_ultimo_coloreo_tlg, cla_tlg)
    SELECT cla_ope, cla_for, cla_mat, cla_enc, cla_hog, cla_mie, cla_aux_es_enc, 
           cla_aux_es_hog, cla_aux_es_mie, cla_ultimo_coloreo_tlg, cla_tlg
      FROM old_encu.claves
      WHERE cla_for<>'TEM';


UPDATE encu.respuestas d
   SET  res_valor=o.res_valor, 
        res_valesp=o.res_valesp, 
        res_valor_con_error=o.res_valor_con_error, 
        res_estado=o.res_estado, 
        res_anotaciones_marginales=o.res_anotaciones_marginales, 
        res_tlg=o.res_tlg
  FROM old_encu.respuestas o
 WHERE o.res_ope=d.res_ope
   and o.res_for=d.res_for
   and o.res_mat=d.res_mat
   and o.res_enc=d.res_enc
   and o.res_hog=d.res_hog
   and o.res_mie=d.res_mie
   and o.res_var=d.res_var;

SELECT setval('encu.tiempo_logico_tlg_tlg_seq', nextval('old_encu.tiempo_logico_tlg_tlg_seq'), true);
SELECT setval('encu.sesiones_ses_ses_seq', nextval('old_encu.sesiones_ses_ses_seq'), true);
SELECT setval('encu.http_user_agent_httpua_httpua_seq', nextval('old_encu.http_user_agent_httpua_httpua_seq'), true);

grant select on encu.plana_tem_ to yeah_mues_campo; 
grant usage on schema encu to yeah_mues_campo;