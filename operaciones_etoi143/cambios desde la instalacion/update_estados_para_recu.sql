update encu.estados set est_criterio = '(norea=10 or norea>=71 and norea not in (91,95,96)) AND verificado_enc<>0 AND dominio = 3'
where est_ope = 'eah2013' and est_est = 30;