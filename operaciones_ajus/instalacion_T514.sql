CREATE OR REPLACE FUNCTION dbo.detectar_salto_en_hogares(v_enc integer, v_hog integer)
  RETURNS integer AS
$BODY$
DECLARE
  vHogant integer;
BEGIN
  if v_hog!=1 then
	SELECT distinct(cla_hog) into vHogant
	from encu.claves  
	where cla_enc = v_enc and cla_hog=v_hog-1;
        if vHogant is null then 
	   return 1; 
	end if;
  end if;	
  RETURN 0;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION dbo.detectar_salto_en_hogares(integer,integer)
  OWNER TO tedede_php;

delete from encu.inconsistencias where inc_con='AI_hogar_salteado';
delete from encu.consistencias where con_con='AI_hogar_salteado';
insert into encu.consistencias (
            con_ope, con_con, con_precondicion, con_rel, con_postcondicion, 
            con_activa, con_descripcion, con_grupo, con_modulo, con_tipo, 
            con_gravedad, con_momento, con_version, con_explicacion, con_orden, 
            con_expl_ok, con_rev, con_junta, con_clausula_from, con_expresion_sql, 
            con_valida, con_error_compilacion, con_ultima_modificacion, con_ultima_variable, 
            con_ignorar_nulls, con_tlg) values
('AJUS','AI_hogar_salteado','','=>','dbo.detectar_salto_en_hogares(enc,hog)=0',TRUE,'Un hogar ha sido salteado',NULL,'VyH','Completitud','Error',NULL,NULL,NULL,NULL,FALSE,1,'h',NULL,NULL,FALSE,NULL,NULL,NULL,NULL,1);