insert into encu.preguntas (pre_ope, pre_for, pre_mat, pre_blo, pre_pre, pre_texto, pre_orden, pre_tlg) values ('eah2013','TEM','','','dispositivo_supe','Fin de análisis de consistencias',763,1);
insert into encu.variables (var_ope, var_for, var_mat, var_pre, var_var, var_tipovar, var_calculada, var_tlg) values ('eah2013','TEM','','dispositivo_supe','dispositivo_supe', 'numeros', '',1);
alter table encu.plana_tem_ add column pla_dispositivo_supe integer;
