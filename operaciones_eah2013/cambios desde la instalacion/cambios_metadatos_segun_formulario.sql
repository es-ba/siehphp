--select * from encu.saltos where sal_conopc = 't3' and sal_ope = 'eah2013' and sal_var = 't3' and sal_opc='5';
delete from encu.saltos where sal_conopc = 't3' and sal_ope = 'eah2013' and sal_var = 't3' and sal_opc='5';

--select * from encu.saltos where sal_conopc = 't4' and sal_ope = 'eah2013' and sal_var = 't4' and sal_opc='4';
delete from encu.saltos where sal_conopc = 't4' and sal_ope = 'eah2013' and sal_var = 't4' and sal_opc='4';

--select * from encu.saltos where sal_conopc = 't11' and sal_ope = 'eah2013' and sal_var = 't11' and sal_opc in ('1','2');
delete from encu.saltos where sal_conopc = 't11' and sal_ope = 'eah2013' and sal_var = 't11' and sal_opc in ('1','2');

--select * from encu.saltos where sal_conopc = 't12' and sal_ope = 'eah2013' and sal_var = 't12' and sal_opc='2';
delete from encu.saltos where sal_conopc = 't12' and sal_ope = 'eah2013' and sal_var = 't12' and sal_opc='2';

--select * from encu.saltos where sal_conopc = 't16' and sal_ope = 'eah2013' and sal_var = 't16' and sal_opc='1';
delete from encu.saltos where sal_conopc = 't16' and sal_ope = 'eah2013' and sal_var = 't16' and sal_opc='1';

--select * from encu.saltos where sal_conopc = 't18' and sal_ope = 'eah2013' and sal_var = 't18' and sal_opc='1';
delete from encu.saltos where sal_conopc = 't18' and sal_ope = 'eah2013' and sal_var = 't18' and sal_opc='1';

--select * from encu.saltos where sal_conopc = 't20' and sal_ope = 'eah2013' and sal_var = 't20' and sal_opc='2';
delete from encu.saltos where sal_conopc = 't20' and sal_ope = 'eah2013' and sal_var = 't20' and sal_opc='2';

--select * from encu.saltos where sal_conopc = 't21' and sal_ope = 'eah2013' and sal_var = 't21' and sal_opc='2';
delete from encu.saltos where sal_conopc = 't21' and sal_ope = 'eah2013' and sal_var = 't21' and sal_opc='2';

--select * from encu.saltos where sal_conopc = 't33' and sal_ope = 'eah2013' and sal_var = 't33' and sal_opc='1';
delete from encu.saltos where sal_conopc = 't33' and sal_ope = 'eah2013' and sal_var = 't33' and sal_opc='1';

--select * from encu.saltos where sal_conopc = 't35' and sal_ope = 'eah2013' and sal_var = 't35' and sal_opc='1';
delete from encu.saltos where sal_conopc = 't35' and sal_ope = 'eah2013' and sal_var = 't35' and sal_opc='1';

--select * from encu.variables where var_ope= 'eah2013' and var_for = 'I1' and var_mat = '' and var_pre = 'T39' and var_var in ('t39_barrio','t39_otro');
update encu.variables set var_destino = '' where var_ope= 'eah2013' and var_for = 'I1' and var_mat = '' and var_pre = 'T39' and var_var in ('t39_barrio','t39_otro');

--select * from encu.saltos where sal_conopc = 't44' and sal_ope = 'eah2013' and sal_var = 't44' and sal_opc='2';
delete from encu.saltos where sal_conopc = 't44' and sal_ope = 'eah2013' and sal_var = 't44' and sal_opc='2';

--select * from encu.saltos where sal_conopc = 't45' and sal_ope = 'eah2013' and sal_var = 't45' and sal_opc='2';
delete from encu.saltos where sal_conopc = 't45' and sal_ope = 'eah2013' and sal_var = 't45' and sal_opc='2';

--select * from encu.saltos where sal_conopc = 't47' and sal_ope = 'eah2013' and sal_var = 't47' and sal_opc='1';
delete from encu.saltos where sal_conopc = 't47' and sal_ope = 'eah2013' and sal_var = 't47' and sal_opc='1';

--select * from encu.saltos where sal_conopc = 'e2' and sal_ope = 'eah2013' and sal_var = 'e2' and sal_opc='1';
delete from encu.saltos where sal_conopc = 'e2' and sal_ope = 'eah2013' and sal_var = 'e2' and sal_opc='1';

--select * from encu.saltos where sal_conopc = 'm1' and sal_ope = 'eah2013' and sal_var = 'm1' and sal_opc  ='1';
delete from encu.saltos where sal_conopc = 'm1' and sal_ope = 'eah2013' and sal_var = 'm1' and sal_opc ='1';
--select * from encu.variables where var_ope= 'eah2013' and var_for = 'I1' and var_mat = '' and var_pre = 'M1' and var_var in ('m1_anio','m1_esp2','m1_esp3') ;
update encu.variables set var_destino = '' where var_ope= 'eah2013' and var_for = 'I1' and var_mat = '' and var_pre = 'M1' and var_var in ('m1_anio','m1_esp2','m1_esp3');

--select * from encu.variables where var_var in ('sn2','sn2_cant');
update encu.variables set var_destino = upper(var_destino)  where var_ope= 'eah2013' and var_for = 'I1' and var_mat = '' and var_pre = 'SN2' and var_var in ('sn2','sn2_cant');

-- para que aparezca filtro antes del bloque T (Trabajo)
UPDATE  encu.filtros set fil_blo = 'Respondi' where fil_fil = 'FILTRO_1';

-- para que aparezca filtro antes del bloque Fecundidad
UPDATE  encu.filtros set fil_blo = 'STP' where fil_fil = 'FILTRO_3';

-- Ticket 1008 para que pida meses cuando no ingresa anios
update encu.variables set var_expresion_habilitar = '!t53c_anios'
where var_ope = 'eah2013' and var_for = 'I1' and var_pre = 'T53c' and var_var = 't53c_meses';