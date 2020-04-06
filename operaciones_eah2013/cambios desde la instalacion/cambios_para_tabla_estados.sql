alter table encu.estados alter column est_editar_encuesta TYPE text;
update encu.estados set est_editar_encuesta = 'nunca' where est_ope= 'eah2013'; 

update encu.estados set est_editar_encuesta= 'descargando' where est_ope= 'eah2013' and est_est =23;
update encu.estados set est_editar_encuesta= 'siempre' where est_ope= 'eah2013' and est_est =27;
update encu.estados set est_editar_encuesta= 'siempre' where est_ope= 'eah2013' and est_est =26; 
update encu.estados set est_editar_encuesta= 'descargando' where est_ope= 'eah2013' and est_est =33;
update encu.estados set est_editar_encuesta= 'siempre' where est_ope= 'eah2013' and est_est =37; 
update encu.estados set est_editar_encuesta= 'siempre' where est_ope= 'eah2013' and est_est =36;
