insert into encu.estados (est_ope,est_est, est_nombre, est_editar_encuesta, est_criterio, est_tlg) values ('eah2013',45,'Cargado para supervisión telefónica de encuestador','nunca','fecha_carga_sup is not null AND (sup_aleat=4 OR sup_dirigida=4)',1);        
insert into encu.est_rol (estrol_ope, estrol_est, estrol_rol, estrol_tlg) values ('eah2013',45,'subcoor_campo',1);    
insert into encu.pla_est (plaest_planilla, plaest_ope, plaest_est, plaest_tlg) select  p.planilla_planilla ,'eah2013',45,1 from encu.planillas p where p.planilla_planilla in ('REC_SUP_TEL');    
insert into encu.estados (est_ope,est_est, est_nombre, est_editar_encuesta, est_criterio, est_tlg) values ('eah2013',55,'Cargado para supervisión telefónica de recuperador','nunca','fecha_carga_sup is not null AND (sup_aleat=4 OR sup_dirigida=4) AND rea>=2',1);        
insert into encu.est_rol (estrol_ope, estrol_est, estrol_rol, estrol_tlg) values ('eah2013',55,'subcoor_campo',1);    
insert into encu.pla_est (plaest_planilla, plaest_ope, plaest_est, plaest_tlg) select  p.planilla_planilla ,'eah2013',55,1 from encu.planillas p where p.planilla_planilla in ('REC_SUP_TEL');    



