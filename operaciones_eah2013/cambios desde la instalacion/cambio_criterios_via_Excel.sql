
update encu.estados set est_criterio='true' where est_est='19';
update encu.estados set est_criterio='asignable=1' where est_est='20';


update encu.estados set est_criterio='cod_enc<>0 AND dispositivo_enc<>0' where est_est='22';

update encu.estados set est_criterio='fecha_carga_enc is not null AND dispositivo_enc=1' where est_est='23';
update encu.estados set est_criterio='fecha_carga_enc is not null  AND dispositivo_enc=2' where est_est='24';
update encu.estados set est_criterio='fecha_descarga_enc is not null  AND con_dato_enc=0' where est_est='25';

update encu.estados set est_criterio='fin_ingreso_enc=1 OR con_dato_enc=1 and a_ingreso_enc is null' where est_est='27';
update encu.estados set est_criterio='a_ingreso_enc=1' where est_est='26';
















update encu.estados set est_criterio='(norea=10 or norea>=71 and norea not in (91,95,96)) AND verificado_enc<>0 AND dominio = 3' where est_est='30';

update encu.estados set est_criterio='cod_recu<>0 AND dispositivo_recu<>0' where est_est='32';

update encu.estados set est_criterio='fecha_carga_recu is not null  AND dispositivo_recu=1' where est_est='33';
update encu.estados set est_criterio='fecha_carga_recu is not null  AND dispositivo_recu=2' where est_est='34';
update encu.estados set est_criterio='fecha_descarga_recu is not null  AND con_dato_recu=0' where est_est='35';

update encu.estados set est_criterio='fin_ingreso_recu=1 OR con_dato_recu=1 and a_ingreso_recu is null' where est_est='37';
update encu.estados set est_criterio='a_ingreso_recu=1' where est_est='36';




update encu.estados set est_criterio='(((hog_tot>1 OR norea<70) AND norea is distinct from 10 AND norea is distinct from 18 AND rea_recu is null and norea_recu is null) OR (rea=1 AND (sup_aleat=3 OR sup_dirigida=3))) AND verificado_enc<>0' where est_est='40';
update encu.estados set est_criterio='(rea=1 AND sup_aleat=4) OR sup_dirigida=4' where est_est='41';
update encu.estados set est_criterio='cod_sup <> 0' where est_est='42';
update encu.estados set est_criterio='cod_sup <> 0 and (sup_aleat=4 or sup_dirigida=4)' where est_est='43';
update encu.estados set est_criterio='fecha_carga_sup is not null ' where est_est='44';
update encu.estados set est_criterio='result_sup<>0' where est_est='46';
update encu.estados set est_criterio='result_sup<>0 and (sup_aleat=4 or sup_dirigida=4)' where est_est='47';
update encu.estados set est_criterio='(((hog_tot>1 OR norea<70) AND norea is distinct from 10 AND norea is distinct from 18) OR (rea=3 AND (sup_aleat=3 OR sup_dirigida=3))) AND verificado_recu<>0' where est_est='50';
update encu.estados set est_criterio='((rea=3 AND sup_aleat=4) OR sup_dirigida=4) and rea>=2' where est_est='51';
update encu.estados set est_criterio='cod_sup <> 0 and rea>=2' where est_est='52';
update encu.estados set est_criterio='cod_sup <> 0 and (sup_aleat=4 or sup_dirigida=4) and rea>=2' where est_est='53';
update encu.estados set est_criterio='fecha_carga_sup is not null and rea>=2' where est_est='54';
update encu.estados set est_criterio='result_sup<>0 and rea>=2' where est_est='56';
update encu.estados set est_criterio='result_sup<>0 and (sup_aleat=4 or sup_dirigida=4) and rea>=2' where est_est='57';





update encu.estados set est_criterio='verificado_enc=4 and (rea=1 and hog_tot=1 or dominio=4 or dominio=5) and sup_aleat is null and sup_dirigida is null or verificado_recu=4 and rea=3 and hog_tot=1 and sup_aleat is null and sup_dirigida is null or verificado_sup=4 or norea=18 and (verificado_recu is not null or verificado_sup is not null)' where est_est='60';
update encu.estados set est_criterio='verificado_ac=6 or verificado_enc=6 or verificado_recu=6 or verificado_sup=6 or  result_sup=6' where est_est='65';
update encu.estados set est_criterio='verificado_ac=1 or verificado_enc=1 and ((rea=1 and hog_tot=1 and sup_aleat is null and sup_dirigida is null) or (norea is distinct from 18 and norea is distinct from 10 and dominio is distinct from 3 and sup_dirigida is null)) or verificado_recu=1 and (rea=3 and hog_tot=1 and sup_aleat is null and sup_dirigida is null or (norea>=71 and norea not in (91,95,96))) or verificado_sup=1 ' where est_est='69';
update encu.estados set est_criterio='fin_de_campo=1' where est_est='70';
update encu.estados set est_criterio='cod_anacon<>0' where est_est='72';
update encu.estados set est_criterio='fin_anacon<>0' where est_est='73';
update encu.estados set est_criterio='coalesce(verificado_ac, verificado_sup, verificado_recu, verificado_enc)=2 and dominio=4' where est_est='98';






















































