alter table encu.estados add column est_editar_TEM text;
update encu.estados set est_editar_TEM = 'siempre' where est_ope='eah2013' ;