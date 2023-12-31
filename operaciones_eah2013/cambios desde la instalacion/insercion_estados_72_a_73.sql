insert into encu.planillas(planilla_planilla, planilla_nombre, planilla_tlg) values  ('PLA_PRO','Planilla de Procesamiento', 1);
insert into encu.preguntas (pre_ope, pre_for, pre_mat, pre_blo, pre_pre, pre_texto, pre_orden, pre_tlg) values ('eah2013','TEM','','','cod_anacon','Analista de consistencias asignado',760,1);
insert into encu.variables (var_ope, var_for, var_mat, var_pre, var_var, var_tipovar, var_calculada, var_tlg) values ('eah2013','TEM','','cod_anacon','cod_anacon', 'numeros', '',1);
update encu.estados set est_editar_encuesta='nunca' where est_ope='eah2013' and est_est=70;
update encu.estados set est_editar_encuesta='nunca' where est_ope='eah2013' and est_est=60;
update encu.estados set est_editar_encuesta='nunca' where est_ope='eah2013' and est_est=65;
update encu.estados set est_editar_encuesta='nunca' where est_ope='eah2013' and est_est=69;
update encu.estados set est_editar_encuesta='nunca' where est_ope='eah2013' and est_est=98;
insert into encu.est_var (estvar_ope, estvar_est, estvar_var, estvar_editable, estvar_tlg) values ('eah2013',70,'cod_anacon',true,1);
insert into encu.est_rol (estrol_ope, estrol_est, estrol_rol, estrol_tlg) values ('eah2013',70,'procesamiento',1);
insert into encu.pla_est (plaest_planilla, plaest_ope, plaest_est, plaest_tlg) select  p.planilla_planilla ,'eah2013',70,1 from encu.planillas p where p.planilla_planilla in ('PLA_PRO');
insert into encu.pla_var (plavar_ope, plavar_var, plavar_planilla, plavar_orden, plavar_tlg) select  'eah2013', 'cod_anacon', p.planilla_planilla , 760, 1  from encu.planillas p where p.planilla_planilla in ('PLA_PRO');
insert into encu.preguntas (pre_ope, pre_for, pre_mat, pre_blo, pre_pre, pre_texto, pre_orden, pre_tlg) values ('eah2013','TEM','','','fin_anacon','Fin de análisis de consistencias',763,1);
insert into encu.variables (var_ope, var_for, var_mat, var_pre, var_var, var_tipovar, var_calculada, var_tlg) values ('eah2013','TEM','','fin_anacon','fin_anacon', 'numeros', '',1);
insert into encu.estados (est_ope,est_est, est_nombre, est_editar_encuesta, est_criterio, est_tlg) values ('eah2013',72,'En análisis de consistencias','nunca','cod_anacon<>0',1);
insert into encu.est_var (estvar_ope, estvar_est, estvar_var, estvar_editable, estvar_tlg) values ('eah2013',72,'fin_anacon',true,1);
insert into encu.est_rol (estrol_ope, estrol_est, estrol_rol, estrol_tlg) values ('eah2013',72,'procesamiento',1);
insert into encu.pla_est (plaest_planilla, plaest_ope, plaest_est, plaest_tlg) select  p.planilla_planilla ,'eah2013',72,1 from encu.planillas p where p.planilla_planilla in ('PLA_PRO');
insert into encu.pla_var (plavar_ope, plavar_var, plavar_planilla, plavar_orden, plavar_tlg) select  'eah2013', 'fin_anacon', p.planilla_planilla , 763, 1  from encu.planillas p where p.planilla_planilla in ('PLA_PRO');
insert into encu.estados (est_ope,est_est, est_nombre, est_editar_encuesta, est_criterio, est_tlg) values ('eah2013',73,'Fin de análisis de consistencias','nunca','fin_anacon<>0',1);				

alter table encu.plana_tem_ add column pla_cod_anacon integer;
alter table encu.plana_tem_ add column pla_fin_anacon integer;
