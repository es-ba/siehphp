alter table encu.estados 
      alter column est_criterio type character varying(500);
insert into encu.preguntas (pre_ope, pre_for, pre_mat, pre_blo, pre_pre, pre_texto, pre_orden, pre_tlg) values ('eah2013','TEM','','','verificado_ac','verificado del analista de campo',730,1);
insert into encu.variables (var_ope, var_for, var_mat, var_pre, var_var, var_tipovar, var_calculada, var_tlg) values ('eah2013','TEM','','verificado_ac','verificado_ac', 'numeros', '',1);
insert into encu.preguntas (pre_ope, pre_for, pre_mat, pre_blo, pre_pre, pre_texto, pre_orden, pre_tlg) values ('eah2013','TEM','','','fin_de_campo','fin de campo',750,1);
insert into encu.variables (var_ope, var_for, var_mat, var_pre, var_var, var_tipovar, var_calculada, var_tlg) values ('eah2013','TEM','','fin_de_campo','fin_de_campo', 'numeros', '',1);
insert into encu.estados (est_ope,est_est, est_nombre, est_editar_encuesta, est_criterio, est_tlg) values ('eah2013','60','Análisis de encuestas incompletas o con dudas',false,'verificado_ac=1 or verificado_enc=4 and rea_enc=1 and hog_tot=1 and sup_aleat_enc is null and sup_dirigida_enc is null or verificado_recu=4 and rea_recu=3 and hog_tot=1 and sup_aleat_recu is null and sup_dirigida_recu is null or verificado_supe=4 or verificado_supr=4',1);
insert into encu.estados (est_ope,est_est, est_nombre, est_editar_encuesta, est_criterio, est_tlg) values ('eah2013','65','Encuestas rechazadas en gabinete a limpiar',false,'verificado_ac=6 or verificado_enc=6 or verificado_recu=6 or verificado_supe=6 or verificado_supr=6 or result_supe=6 or result_supr=6',1);
insert into encu.estados (est_ope,est_est, est_nombre, est_editar_encuesta, est_criterio, est_tlg) values ('eah2013','69','En espera de terminación de fin de campo',false,'verificado_ac=1 or verificado_enc=1 and rea_enc=1 and hog_tot=1 and sup_aleat_enc is null and sup_dirigida_enc is null or verificado_recu=1 and rea_recu=3 and hog_tot=1 and sup_aleat_recu is null and sup_dirigida_recu is null or verificado_supe=1 or verificado_supr=1',1);
insert into encu.estados (est_ope,est_est, est_nombre, est_editar_encuesta, est_criterio, est_tlg) values ('eah2013','70','Inicio del procesamiento',false,'fin_de_campo=1',1);
alter table encu.plana_tem_ add column pla_verificado_ac integer;
alter table encu.plana_tem_ add column pla_fin_de_campo integer;


