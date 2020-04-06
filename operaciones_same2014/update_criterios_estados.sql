update encu.estados  set est_criterio='(norea=10 or norea>=71 and norea not in (91,95,96)) AND verificado_enc>0' where est_ope='same2013' and est_est=30;
update encu.estados  set est_criterio='(hog_tot>1 OR norea<70 OR (rea_enc=1 AND sup_aleat_enc=3) OR sup_dirigida_enc=3) AND verificado_enc>0' where est_ope='same2013' and est_est=40;
update encu.estados  set est_criterio='(hog_tot>1 OR norea<70 OR (rea_recu=1 AND sup_aleat_recu=3) OR sup_dirigida_recu=3) AND verificado_enc>0' where est_ope='same2013' and est_est=50;
