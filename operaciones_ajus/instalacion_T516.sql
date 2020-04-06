CREATE OR REPLACE FUNCTION dbo.buscar_rea(p_enc integer)
  RETURNS integer AS
$BODY$
declare v_rea integer;
begin
    select res_valor::integer into v_rea 
        from encu.respuestas 
        where res_ope = 'AJUS'
          and res_for = 'AJH1'
          and res_mat = ''
          and res_enc = p_enc 
          and res_hog = 1 
          and res_var = 'rea';
    return v_rea;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION dbo.buscar_rea(integer)
  OWNER TO tedede_php;

delete from encu.inconsistencias where inc_con='TEM_encu_no_rea';
delete from encu.consistencias where con_con='TEM_encu_no_rea';
insert into encu.consistencias (
            con_ope, con_con, con_precondicion, con_rel, con_postcondicion, 
            con_activa, con_descripcion, con_grupo, con_modulo, con_tipo, 
            con_gravedad, con_momento, con_version, con_explicacion, con_orden, 
            con_expl_ok, con_rev, con_junta, con_clausula_from, con_expresion_sql, 
            con_valida, con_error_compilacion, con_ultima_modificacion, con_ultima_variable, 
            con_ignorar_nulls, con_tlg) values

('AJUS','TEM_encu_no_rea','dbo.buscar_rea(enc)=1','=>','coalesce(rea_recu,rea_enc) in (1,3)',TRUE,'La encuesta ingresada no figura como realizada en la TEM',NULL,'VyH','Completitud','Error',NULL,NULL,NULL,NULL,FALSE,1,'t',NULL,NULL,FALSE,NULL,NULL,NULL,NULL,1);
