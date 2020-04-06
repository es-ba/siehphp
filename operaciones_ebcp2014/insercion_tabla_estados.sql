delete from encu.est_rol;
delete from encu.est_var;
delete from encu.pla_est;
delete from encu.estados;

insert into encu.estados (est_ope,est_est, est_nombre, est_editar_encuesta, est_criterio, est_tlg) values ('ebcp2014',18,'en la muestra','nunca','true',1);
insert into encu.estados (est_ope,est_est, est_nombre, est_editar_encuesta, est_criterio, est_tlg) values ('ebcp2014',19,'en la TEM','nunca','reserva=1 or reserva=3 or nro_enc_de_baja > 0',1);
insert into encu.estados (est_ope,est_est, est_nombre, est_editar_encuesta, est_criterio, est_tlg) values ('ebcp2014',20,'Disponible para ser asignada por el recepcionista.','nunca','asignable=1',1);
insert into encu.estados (est_ope,est_est, est_nombre, est_editar_encuesta, est_criterio, est_tlg) values ('ebcp2014',22,'Asignada a encuestador.','nunca','cod_enc<>0 AND dispositivo_enc<>0',1);
insert into encu.estados (est_ope,est_est, est_nombre, est_editar_encuesta, est_criterio, est_tlg) values ('ebcp2014',24,'Cargada en el (papel); en campo para encuestador.','nunca','fecha_carga_enc is not null  AND dispositivo_enc=2',1);
insert into encu.estados (est_ope,est_est, est_nombre, est_editar_encuesta, est_criterio, est_tlg) values ('ebcp2014',25,'Descargada vacía para ingreso o para volver a cargar','nunca','fecha_descarga_enc is not null  AND con_dato_enc=0',1);
insert into encu.estados (est_ope,est_est, est_nombre, est_editar_encuesta, est_criterio, est_tlg) values ('ebcp2014',27,'Descargada/ingresada y en recepción (DM, papel) del encuestador.','siempre','fin_ingreso_enc=1 OR con_dato_enc=1 and a_ingreso_enc is null',1);
insert into encu.estados (est_ope,est_est, est_nombre, est_editar_encuesta, est_criterio, est_tlg) values ('ebcp2014',26,'En ingreso (de encuestador)','siempre','a_ingreso_enc=1',1);
insert into encu.estados (est_ope,est_est, est_nombre, est_editar_encuesta, est_criterio, est_tlg) values ('ebcp2014',40,'Verificada y para asignar a supervisión presencial de encuestador.','nunca','verificado_enc=1 and sup_dirigida =3',1);
insert into encu.estados (est_ope,est_est, est_nombre, est_editar_encuesta, est_criterio, est_tlg) values ('ebcp2014',41,'Verificada y para asignar a supervisión telefónica de encuestador.','nunca','verificado_enc=1 and sup_dirigida =4',1);
insert into encu.estados (est_ope,est_est, est_nombre, est_editar_encuesta, est_criterio, est_tlg) values ('ebcp2014',42,'Asignada a supervisión presencial','nunca','cod_sup <> 0',1);
insert into encu.estados (est_ope,est_est, est_nombre, est_editar_encuesta, est_criterio, est_tlg) values ('ebcp2014',43,'Asignada a supervisión telefónica','nunca','cod_sup <> 0 and sup_dirigida=4',1);
insert into encu.estados (est_ope,est_est, est_nombre, est_editar_encuesta, est_criterio, est_tlg) values ('ebcp2014',44,'En campo, supervisión presencial','nunca','fecha_carga_sup is not null ',1);
insert into encu.estados (est_ope,est_est, est_nombre, est_editar_encuesta, est_criterio, est_tlg) values ('ebcp2014',45,'Cargado para supervisión telefónica de encuestador','nunca','fecha_carga_sup is not null  AND sup_dirigida=4',1);
insert into encu.estados (est_ope,est_est, est_nombre, est_editar_encuesta, est_criterio, est_tlg) values ('ebcp2014',46,'En recepción, supervisión presencial','nunca','result_sup<>0',1);
insert into encu.estados (est_ope,est_est, est_nombre, est_editar_encuesta, est_criterio, est_tlg) values ('ebcp2014',47,'En recepción, supervisión telefónica','nunca','result_sup<>0 and sup_dirigida=4',1);
insert into encu.estados (est_ope,est_est, est_nombre, est_editar_encuesta, est_criterio, est_tlg) values ('ebcp2014',60,'Análisis de encuestas incompletas o con dudas','siempre','verificado_enc = 4 or verificado_sup = 4',1);
insert into encu.estados (est_ope,est_est, est_nombre, est_editar_encuesta, est_criterio, est_tlg) values ('ebcp2014',65,'Encuestas rechazadas en gabinete a limpiar','siempre','verificado_enc = 6 or verificado_sup = 6',1);
insert into encu.estados (est_ope,est_est, est_nombre, est_editar_encuesta, est_criterio, est_tlg) values ('ebcp2014',69,'En espera de terminación de fin de campo','nunca','verificado_enc = 1 and sup_dirigida is null',1);
insert into encu.estados (est_ope,est_est, est_nombre, est_editar_encuesta, est_criterio, est_tlg) values ('ebcp2014',70,'Inicio del procesamiento','siempre','verificado_enc = 3 or verificado_sup = 3 or verificado_sup = 1',1);
insert into encu.estados (est_ope,est_est, est_nombre, est_editar_encuesta, est_criterio, est_tlg) values ('ebcp2014',72,'En análisis de consistencias','siempre','cod_anacon is not null',1);
insert into encu.estados (est_ope,est_est, est_nombre, est_editar_encuesta, est_criterio, est_tlg) values ('ebcp2014',75,'Devuelta a campo por procesamiento','siempre','fin_anacon=4',1);
insert into encu.estados (est_ope,est_est, est_nombre, est_editar_encuesta, est_criterio, est_tlg) values ('ebcp2014',78,'Resuelta por campo','siempre','resol_campo is not null',1);
insert into encu.estados (est_ope,est_est, est_nombre, est_editar_encuesta, est_criterio, est_tlg) values ('ebcp2014',79,'Fin de análisis de consistencias','procesamiento','fin_anacon=1',1);
insert into encu.estados (est_ope,est_est, est_nombre, est_editar_encuesta, est_criterio, est_tlg) values ('ebcp2014',90,'Fin de NOREA','siempre','norea is not null and verificado_enc = 1',1);

insert into encu.est_rol (estrol_ope, estrol_est, estrol_rol, estrol_tlg) values ('ebcp2014',18,'mues_campo',1);
insert into encu.est_rol (estrol_ope, estrol_est, estrol_rol, estrol_tlg) values ('ebcp2014',19,'subcoor_campo',1);
insert into encu.est_rol (estrol_ope, estrol_est, estrol_rol, estrol_tlg) values ('ebcp2014',20,'recepcionista',1);
insert into encu.est_rol (estrol_ope, estrol_est, estrol_rol, estrol_tlg) values ('ebcp2014',22,'recepcionista',1);
insert into encu.est_rol (estrol_ope, estrol_est, estrol_rol, estrol_tlg) values ('ebcp2014',24,'recepcionista',1);
insert into encu.est_rol (estrol_ope, estrol_est, estrol_rol, estrol_tlg) values ('ebcp2014',25,'recepcionista',1);
insert into encu.est_rol (estrol_ope, estrol_est, estrol_rol, estrol_tlg) values ('ebcp2014',27,'recepcionista',1);
insert into encu.est_rol (estrol_ope, estrol_est, estrol_rol, estrol_tlg) values ('ebcp2014',26,'ingresador',1);
insert into encu.est_rol (estrol_ope, estrol_est, estrol_rol, estrol_tlg) values ('ebcp2014',40,'subcoor_campo',1);
insert into encu.est_rol (estrol_ope, estrol_est, estrol_rol, estrol_tlg) values ('ebcp2014',41,'subcoor_campo',1);
insert into encu.est_rol (estrol_ope, estrol_est, estrol_rol, estrol_tlg) values ('ebcp2014',42,'subcoor_campo',1);
insert into encu.est_rol (estrol_ope, estrol_est, estrol_rol, estrol_tlg) values ('ebcp2014',43,'recepcionista',1);
insert into encu.est_rol (estrol_ope, estrol_est, estrol_rol, estrol_tlg) values ('ebcp2014',44,'subcoor_campo',1);
insert into encu.est_rol (estrol_ope, estrol_est, estrol_rol, estrol_tlg) values ('ebcp2014',45,'subcoor_campo',1);
insert into encu.est_rol (estrol_ope, estrol_est, estrol_rol, estrol_tlg) values ('ebcp2014',46,'subcoor_campo',1);
insert into encu.est_rol (estrol_ope, estrol_est, estrol_rol, estrol_tlg) values ('ebcp2014',47,'subcoor_campo',1);
--insert into encu.est_rol (estrol_ope, estrol_est, estrol_rol, estrol_tlg) values ('ebcp2014',23,'recepcionista',1);
--insert into encu.est_rol (estrol_ope, estrol_est, estrol_rol, estrol_tlg) values ('ebcp2014',33,'recepcionista',1);
insert into encu.est_rol (estrol_ope, estrol_est, estrol_rol, estrol_tlg) values ('ebcp2014',70,'procesamiento',1);
insert into encu.est_rol (estrol_ope, estrol_est, estrol_rol, estrol_tlg) values ('ebcp2014',72,'procesamiento',1);
insert into encu.est_rol (estrol_ope, estrol_est, estrol_rol, estrol_tlg) values ('ebcp2014',75,'procesamiento',1);
insert into encu.est_rol (estrol_ope, estrol_est, estrol_rol, estrol_tlg) values ('ebcp2014',78,'subcoor_campo',1);
insert into encu.est_rol (estrol_ope, estrol_est, estrol_rol, estrol_tlg) values ('ebcp2014',90,'procesamiento',1);

insert into encu.est_var (estvar_ope, estvar_est, estvar_var, estvar_editable, estvar_tlg) values ('ebcp2014',19,'asignable',true,1);
insert into encu.est_var (estvar_ope, estvar_est, estvar_var, estvar_editable, estvar_tlg) values ('ebcp2014',20,'cod_enc',true,1);
insert into encu.est_var (estvar_ope, estvar_est, estvar_var, estvar_editable, estvar_tlg) values ('ebcp2014',20,'dispositivo_enc',true,1);
insert into encu.est_var (estvar_ope, estvar_est, estvar_var, estvar_editable, estvar_tlg) values ('ebcp2014',20,'recepcionista',true,1);
insert into encu.est_var (estvar_ope, estvar_est, estvar_var, estvar_editable, estvar_tlg) values ('ebcp2014',22,'fecha_carga_enc',true,1);
insert into encu.est_var (estvar_ope, estvar_est, estvar_var, estvar_editable, estvar_tlg) values ('ebcp2014',22,'fecha_primcarga_enc',true,1);
insert into encu.est_var (estvar_ope, estvar_est, estvar_var, estvar_editable, estvar_tlg) values ('ebcp2014',24,'a_ingreso_enc',true,1);
insert into encu.est_var (estvar_ope, estvar_est, estvar_var, estvar_editable, estvar_tlg) values ('ebcp2014',25,'a_ingreso_enc',true,1);
insert into encu.est_var (estvar_ope, estvar_est, estvar_var, estvar_editable, estvar_tlg) values ('ebcp2014',25,'volver_a_cargar_enc',true,1);
insert into encu.est_var (estvar_ope, estvar_est, estvar_var, estvar_editable, estvar_tlg) values ('ebcp2014',27,'volver_a_cargar_enc',true,1);
insert into encu.est_var (estvar_ope, estvar_est, estvar_var, estvar_editable, estvar_tlg) values ('ebcp2014',26,'fin_ingreso_enc',true,1);
insert into encu.est_var (estvar_ope, estvar_est, estvar_var, estvar_editable, estvar_tlg) values ('ebcp2014',27,'verificado_enc',true,1);
insert into encu.est_var (estvar_ope, estvar_est, estvar_var, estvar_editable, estvar_tlg) values ('ebcp2014',40,'cod_sup',true,1);
insert into encu.est_var (estvar_ope, estvar_est, estvar_var, estvar_editable, estvar_tlg) values ('ebcp2014',41,'cod_sup',true,1);
insert into encu.est_var (estvar_ope, estvar_est, estvar_var, estvar_editable, estvar_tlg) values ('ebcp2014',42,'fecha_carga_sup',true,1);
insert into encu.est_var (estvar_ope, estvar_est, estvar_var, estvar_editable, estvar_tlg) values ('ebcp2014',43,'result_sup',true,1);
insert into encu.est_var (estvar_ope, estvar_est, estvar_var, estvar_editable, estvar_tlg) values ('ebcp2014',44,'result_sup',true,1);
insert into encu.est_var (estvar_ope, estvar_est, estvar_var, estvar_editable, estvar_tlg) values ('ebcp2014',46,'verificado_sup',true,1);
insert into encu.est_var (estvar_ope, estvar_est, estvar_var, estvar_editable, estvar_tlg) values ('ebcp2014',47,'verificado_sup',true,1);
insert into encu.est_var (estvar_ope, estvar_est, estvar_var, estvar_editable, estvar_tlg) values ('ebcp2014',23,'fecha_comenzo_descarga',true,1);
--insert into encu.est_var (estvar_ope, estvar_est, estvar_var, estvar_editable, estvar_tlg) values ('ebcp2014',33,'fecha_comenzo_descarga',true,1);
insert into encu.est_var (estvar_ope, estvar_est, estvar_var, estvar_editable, estvar_tlg) values ('ebcp2014',60,'verificado_ac',true,1);
insert into encu.est_var (estvar_ope, estvar_est, estvar_var, estvar_editable, estvar_tlg) values ('ebcp2014',69,'fin_de_campo',true,1);
insert into encu.est_var (estvar_ope, estvar_est, estvar_var, estvar_editable, estvar_tlg) values ('ebcp2014',70,'cod_anacon',true,1);
insert into encu.est_var (estvar_ope, estvar_est, estvar_var, estvar_editable, estvar_tlg) values ('ebcp2014',72,'fin_anacon',true,1);
insert into encu.est_var (estvar_ope, estvar_est, estvar_var, estvar_editable, estvar_tlg) values ('ebcp2014',78,'resol_campo',true,1);
insert into encu.est_var (estvar_ope, estvar_est, estvar_var, estvar_editable, estvar_tlg) values ('ebcp2014',70,'bolsa',true,1);
insert into encu.est_var (estvar_ope, estvar_est, estvar_var, estvar_editable, estvar_tlg) values ('ebcp2014',70,'etapa_pro',true,1);

insert into encu.pla_est (plaest_planilla, plaest_ope, plaest_est, plaest_tlg) select  p.planilla_planilla ,'ebcp2014',19,1 from encu.planillas p where p.planilla_planilla in ('CAR_ENC');
insert into encu.pla_est (plaest_planilla, plaest_ope, plaest_est, plaest_tlg) select  p.planilla_planilla ,'ebcp2014',20,1 from encu.planillas p where p.planilla_planilla in ('CAR_ENC', 'REC_ENC');
insert into encu.pla_est (plaest_planilla, plaest_ope, plaest_est, plaest_tlg) select  p.planilla_planilla ,'ebcp2014',22,1 from encu.planillas p where p.planilla_planilla in ('CAR_ENC', 'REC_ENC');
insert into encu.pla_est (plaest_planilla, plaest_ope, plaest_est, plaest_tlg) select  p.planilla_planilla ,'ebcp2014',24,1 from encu.planillas p where p.planilla_planilla in ('REC_ENC');
insert into encu.pla_est (plaest_planilla, plaest_ope, plaest_est, plaest_tlg) select  p.planilla_planilla ,'ebcp2014',25,1 from encu.planillas p where p.planilla_planilla in ('REC_ENC');
insert into encu.pla_est (plaest_planilla, plaest_ope, plaest_est, plaest_tlg) select  p.planilla_planilla ,'ebcp2014',27,1 from encu.planillas p where p.planilla_planilla in ('REC_ENC');
insert into encu.pla_est (plaest_planilla, plaest_ope, plaest_est, plaest_tlg) select  p.planilla_planilla ,'ebcp2014',26,1 from encu.planillas p where p.planilla_planilla in ('REC_ENC');
insert into encu.pla_est (plaest_planilla, plaest_ope, plaest_est, plaest_tlg) select  p.planilla_planilla ,'ebcp2014',40,1 from encu.planillas p where p.planilla_planilla in ('CAR_SUP_ENC',' REC_SUP_ENC');
insert into encu.pla_est (plaest_planilla, plaest_ope, plaest_est, plaest_tlg) select  p.planilla_planilla ,'ebcp2014',41,1 from encu.planillas p where p.planilla_planilla in ('CAR_SUP_ENC',' REC_SUP_ENC');
insert into encu.pla_est (plaest_planilla, plaest_ope, plaest_est, plaest_tlg) select  p.planilla_planilla ,'ebcp2014',42,1 from encu.planillas p where p.planilla_planilla in ('CAR_SUP_ENC',' REC_SUP_ENC');
insert into encu.pla_est (plaest_planilla, plaest_ope, plaest_est, plaest_tlg) select  p.planilla_planilla ,'ebcp2014',43,1 from encu.planillas p where p.planilla_planilla in ('REC_SUP_ENC');
insert into encu.pla_est (plaest_planilla, plaest_ope, plaest_est, plaest_tlg) select  p.planilla_planilla ,'ebcp2014',44,1 from encu.planillas p where p.planilla_planilla in ('REC_SUP_ENC');
insert into encu.pla_est (plaest_planilla, plaest_ope, plaest_est, plaest_tlg) select  p.planilla_planilla ,'ebcp2014',45,1 from encu.planillas p where p.planilla_planilla in ('MON_TEM','REC_SUP_TEL');
insert into encu.pla_est (plaest_planilla, plaest_ope, plaest_est, plaest_tlg) select  p.planilla_planilla ,'ebcp2014',46,1 from encu.planillas p where p.planilla_planilla in ('REC_SUP_ENC');
insert into encu.pla_est (plaest_planilla, plaest_ope, plaest_est, plaest_tlg) select  p.planilla_planilla ,'ebcp2014',47,1 from encu.planillas p where p.planilla_planilla in ('REC_SUP_ENC');
insert into encu.pla_est (plaest_planilla, plaest_ope, plaest_est, plaest_tlg) select  p.planilla_planilla ,'ebcp2014',70,1 from encu.planillas p where p.planilla_planilla in ('PLA_PRO');
insert into encu.pla_est (plaest_planilla, plaest_ope, plaest_est, plaest_tlg) select  p.planilla_planilla ,'ebcp2014',72,1 from encu.planillas p where p.planilla_planilla in ('PLA_PRO');
insert into encu.pla_est (plaest_planilla, plaest_ope, plaest_est, plaest_tlg) select  p.planilla_planilla ,'ebcp2014',75,1 from encu.planillas p where p.planilla_planilla in ('MON_TEM','PLA_PRO');
insert into encu.pla_est (plaest_planilla, plaest_ope, plaest_est, plaest_tlg) select  p.planilla_planilla ,'ebcp2014',78,1 from encu.planillas p where p.planilla_planilla in ('MON_TEM','PLA_PRO');

/*INSERT INTO estados (est_ope, est_est, est_nombre, est_criterio, est_editar_encuesta, est_tlg, est_editar_tem) VALUES ('ebcp2014', 70, 'Inicio del procesamiento', 'fin_de_campo=1 AND norea is distinct from 18', 'siempre', 1, 'siempre'),
('ebcp2014', 75, 'Devuelta a campo por procesamiento', 'fin_anacon=4 AND norea is distinct from 18', 'siempre', 1, 'siempre'),
('ebcp2014', 78, 'Resuelta por campo', 'resol_campo is not null AND norea is distinct from 18', 'siempre', 1, 'siempre'),
('ebcp2014', 45, 'Cargado para supervisión telefónica de encuestador', 'fecha_carga_sup is not null  AND (coalesce(sup_dirigida,sup_aleat)=4)', 'nunca', 1, 'siempre'),
('ebcp2014', 55, 'Cargado para supervisión telefónica de recuperador', 'fecha_carga_sup is not null  AND (coalesce(sup_dirigida,sup_aleat)=4) AND rea>=2', 'nunca', 1, 'siempre'),
('ebcp2014', 23, 'Cargada en el (DM), en campo para encuestador.', 'fecha_carga_enc is not null AND dispositivo_enc=1', 'descargando', 1, 'siempre'),
('ebcp2014', 24, 'Cargada en el (papel), en campo para encuestador.', 'fecha_carga_enc is not null  AND dispositivo_enc=2', 'nunca', 1, 'siempre'),
('ebcp2014', 19, 'en la TEM', 'true', 'nunca', 1, 'siempre'),
('ebcp2014', 20, 'Disponible para ser asignada por el recepcionista.', 'asignable=1', 'nunca', 1, 'siempre'),
('ebcp2014', 22, 'Asignada a encuestador.', 'cod_enc<>0 AND dispositivo_enc<>0', 'nunca', 1, 'siempre'),
('ebcp2014', 25, 'Descargada vacía para ingreso o para volver a cargar', 'fecha_descarga_enc is not null  AND con_dato_enc=0', 'nunca', 1, 'siempre'),
('ebcp2014', 27, 'Descargada/ingresada y en recepción (DM, papel) del encuestador.', 'fin_ingreso_enc=1 OR con_dato_enc=1 and a_ingreso_enc is null', 'siempre', 1, 'siempre'),
('ebcp2014', 26, 'En ingreso (de encuestador)', 'a_ingreso_enc=1', 'siempre', 1, 'siempre'),
('ebcp2014', 30, 'Disponible para ser asignada por el recepcionista.', '(norea=10 or norea>=71 and norea not in (91,95,96)) AND verificado_enc<>0 AND dominio = 3', 'nunca', 1, 'siempre'),
('ebcp2014', 32, 'Asignada a recuperador.', 'cod_recu<>0 AND dispositivo_recu<>0', 'nunca', 1, 'siempre'),
('ebcp2014', 33, 'Cargada en el (DM), en campo para recuperador.', 'fecha_carga_recu is not null  AND dispositivo_recu=1', 'descargando', 1, 'siempre'),
('ebcp2014', 34, 'Cargada en el (papel), en campo para recuperador.', 'fecha_carga_recu is not null  AND dispositivo_recu=2', 'nunca', 1, 'siempre'),
('ebcp2014', 53, 'Asignada a supervisión telefónica de recuperador', 'cod_sup <> 0 and (coalesce(sup_dirigida,sup_aleat)=4) and rea>=2', 'nunca', 1, 'siempre'),
('ebcp2014', 57, 'En recepción, supervisión telefónica de recuperador', 'result_sup<>0 and (coalesce(sup_dirigida,sup_aleat)=4) and rea>=2', 'nunca', 1, 'siempre'),
('ebcp2014', 46, 'En recepción, supervisión presencial', 'result_sup<>0', 'nunca', 1, 'siempre'),
('ebcp2014', 44, 'En campo, supervisión presencial', 'fecha_carga_sup is not null ', 'nunca', 1, 'siempre'),
('ebcp2014', 54, 'En campo, supervisión presencial de recuperador', 'fecha_carga_sup is not null and rea>=2', 'nunca', 1, 'siempre'),
('ebcp2014', 56, 'En recepción, supervisión presencial de recuperador', 'result_sup<>0 and rea>=2', 'nunca', 1, 'siempre'),
('ebcp2014', 40, 'Verificada y para asignar a supervisión presencial de encuestador.', '(((hog_tot>1 OR norea<70) AND norea is distinct from 10 AND norea is distinct from 18 AND norea is distinct from 61 AND rea_recu is null and norea_recu is null) OR (rea=1 AND (sup_aleat=3 OR sup_dirigida=3))) AND verificado_enc<>0', 'nunca', 1, 'siempre'),
('ebcp2014', 50, 'Verificada y para asignar a supervisión presencial de recuperador.', '(((hog_tot>1 OR norea<70) AND norea is distinct from 10 AND norea is distinct from 18 AND norea is distinct from 61) OR (rea=3 AND (sup_aleat=3 OR sup_dirigida=3))) AND verificado_recu<>0', 'nunca', 1, 'siempre'),
('ebcp2014', 79, 'Fin de análisis de consistencias', 'fin_anacon=1 AND norea is distinct from 18', 'procesamiento', 1, 'siempre'),
('ebcp2014', 69, 'En espera de terminación de fin de campo', 'norea is distinct from 18 and (verificado_ac=1 or verificado_enc=1 and ((rea=1 and hog_tot=1 and sup_aleat is null and sup_dirigida is null) or (norea is distinct from 18 and norea is distinct from 10 and dominio is distinct from 3 and sup_dirigida is null) or norea=61) or verificado_recu=1 and (rea=3 and hog_tot=1 and sup_aleat is null and sup_dirigida is null or (norea>=71 and norea not in (91,95,96)) or norea=61) or verificado_sup=1)  or verificado_enc=3 or verificado_recu=3', 'nunca', 1, 'siempre'),
('ebcp2014', 90, 'Fin de NOREA', 'fin_de_campo=1 and (rea=0 or rea=2) AND norea is distinct from 18', 'siempre', 1, 'siempre'),
('ebcp2014', 35, 'Descargada vacía para ingreso o para volver a cargar', 'fecha_descarga_recu is not null  AND con_dato_recu=0', 'nunca', 1, 'siempre'),
('ebcp2014', 37, 'Descargada y en recepción (DM, papel) del recuperador.', 'fin_ingreso_recu=1 OR con_dato_recu=1 and a_ingreso_recu is null', 'siempre', 1, 'siempre'),
('ebcp2014', 36, 'En ingreso (de recuperador)', 'a_ingreso_recu=1', 'siempre', 1, 'siempre'),
('ebcp2014', 41, 'Verificada y para asignar a supervisión telefónica de encuestador.', '(rea=1 AND sup_aleat=4) OR sup_dirigida=4', 'nunca', 1, 'siempre'),
('ebcp2014', 42, 'Asignada a supervisión presencial', 'cod_sup <> 0', 'nunca', 1, 'siempre'),
('ebcp2014', 51, 'Verificada y para asignar a supervisión telefónica de recuperador.', '((rea=3 AND sup_aleat=4) OR sup_dirigida=4) and rea>=2', 'nunca', 1, 'siempre'),
('ebcp2014', 52, 'Asignada a supervisión presencial de recuperador', 'cod_sup <> 0 and rea>=2', 'nunca', 1, 'siempre'),
('ebcp2014', 98, 'Fuera de muestra (IHPCT)', 'coalesce(verificado_ac, verificado_sup, verificado_recu, verificado_enc)=2 and dominio=4', 'nunca', 1, 'siempre'),
('ebcp2014', 60, 'Análisis de encuestas incompletas o con dudas', 'verificado_enc=4 and (rea=1 and hog_tot=1 or dominio=4 or dominio=5) and sup_aleat is null and sup_dirigida is null or verificado_recu=4 and rea=3 and hog_tot=1 and sup_aleat is null and sup_dirigida is null or verificado_sup=4 or norea=18 and (verificado_recu is not null or verificado_sup is not null)', 'siempre', 1, 'siempre'),
('ebcp2014', 65, 'Encuestas rechazadas en gabinete a limpiar', 'verificado_ac=6 or verificado_enc=6 or verificado_recu=6 or verificado_sup=6 or  result_sup=6', 'siempre', 1, 'siempre'),
('ebcp2014', 72, 'En análisis de consistencias', 'cod_anacon is not null AND norea is distinct from 18', 'siempre', 1, 'siempre'),
('ebcp2014', 43, 'Asignada a supervisión telefónica', 'cod_sup <> 0 and (coalesce(sup_dirigida,sup_aleat)=4)', 'nunca', 1, 'siempre'),
('ebcp2014', 47, 'En recepción, supervisión telefónica', 'result_sup<>0 and (coalesce(sup_dirigida,sup_aleat)=4)', 'nunca', 1, 'siempre');*/
