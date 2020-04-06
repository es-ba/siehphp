delete from encu.respuestas where res_var='e3a';
alter table encu.plana_i1_ drop column pla_e3a;
delete from encu.variables where var_ope='eah2013' and var_for='I1' and var_pre='E3a' and var_var='e3a';
delete from encu.opciones where opc_ope='eah2013' and opc_conopc='e3a';
delete from encu.con_opc where conopc_ope='eah2013' and conopc_conopc='e3a';
delete from encu.preguntas where pre_ope='eah2013' and pre_pre='E3a';