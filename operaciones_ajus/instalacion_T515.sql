delete from encu.inconsistencias where inc_con='TEM_cant_hogares';
delete from encu.consistencias where con_con='TEM_cant_hogares';
insert into encu.consistencias (
            con_ope, con_con, con_precondicion, con_rel, con_postcondicion, 
            con_activa, con_descripcion, con_grupo, con_modulo, con_tipo, 
            con_gravedad, con_momento, con_version, con_explicacion, con_orden, 
            con_expl_ok, con_rev, con_junta, con_clausula_from, con_expresion_sql, 
            con_valida, con_error_compilacion, con_ultima_modificacion, con_ultima_variable, 
            con_ignorar_nulls, con_tlg) values

('AJUS','TEM_cant_hogares','','=>','dbo.total_hogares(enc)=nhogares',TRUE,'No coinciden la cantidad de hogares ingresados con los de la TEM ',NULL,'VyH','Completitud','Error',NULL,NULL,NULL,NULL,FALSE,1,'t',NULL,NULL,FALSE,NULL,NULL,NULL,NULL,1);