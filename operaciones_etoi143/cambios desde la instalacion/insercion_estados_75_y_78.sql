insert into encu.estados (est_ope,est_est, est_nombre, est_editar_encuesta, est_criterio, est_tlg) values ('eah2013',75,'Devuelta a campo por procesamiento','siempre','fin_anacon=4 AND norea is distinct from 18',1);		
insert into encu.est_rol (estrol_ope, estrol_est, estrol_rol, estrol_tlg) values ('eah2013',75,'procesamiento',1);	
insert into encu.pla_est (plaest_planilla, plaest_ope, plaest_est, plaest_tlg) select  p.planilla_planilla ,'eah2013',75,1 from encu.planillas p where p.planilla_planilla in ('MON_TEM','PLA_PRO');
insert into encu.preguntas (pre_ope, pre_for, pre_mat, pre_blo, pre_pre, pre_texto, pre_orden, pre_tlg) values ('eah2013','TEM','','','resol_campo','Resolución de campo',850,1);	
insert into encu.variables (var_ope, var_for, var_mat, var_pre, var_var, var_tipovar, var_calculada, var_tlg) values ('eah2013','TEM','','resol_campo','resol_campo', 'texto', '',1);	
insert into encu.estados (est_ope,est_est, est_nombre, est_editar_encuesta, est_criterio, est_tlg) values ('eah2013',78,'Resuelta por campo','siempre','resol_campo is not null',1);	insert into encu.est_var (estvar_ope, estvar_est, estvar_var, estvar_editable, estvar_tlg) values ('eah2013',78,'resol_campo',true,1);	
insert into encu.est_rol (estrol_ope, estrol_est, estrol_rol, estrol_tlg) values ('eah2013',78,'subcoor_campo',1);	
insert into encu.pla_est (plaest_planilla, plaest_ope, plaest_est, plaest_tlg) select  p.planilla_planilla ,'eah2013',78,1 from encu.planillas p where p.planilla_planilla in ('MON_TEM','PLA_PRO');	
insert into encu.pla_var (plavar_ope, plavar_var, plavar_planilla, plavar_orden, plavar_tlg) select  'eah2013', 'resol_campo', p.planilla_planilla , 850, 1  from encu.planillas p where p.planilla_planilla in ('MON_TEM','PLA_PRO');
alter table encu.plana_tem_
 add column pla_resol_campo text;
update encu.estados set est_criterio='norea is distinct from 18 and (verificado_ac=1 or verificado_enc=1 and ((rea=1 and hog_tot=1 and sup_aleat is null and sup_dirigida is null) or (norea is distinct from 18 and norea is distinct from 10 and dominio is distinct from 3 and sup_dirigida is null) or norea=61) or verificado_recu=1 and (rea=3 and hog_tot=1 and sup_aleat is null and sup_dirigida is null or (norea>=71 and norea not in (91,95,96)) or norea=61) or verificado_sup=1)' where est_est='69';
update encu.estados set est_criterio='fin_de_campo=1 AND norea is distinct from 18' where est_est='70';
update encu.estados set est_criterio='cod_anacon is not null AND norea is distinct from 18' where est_est='72';
update encu.estados set est_criterio='fin_anacon<>0 AND norea is distinct from 18' where est_est='73';
update encu.estados set est_criterio='fin_de_campo=1 and (rea=0 or rea=2) AND norea is distinct from 18' where est_est='90';
