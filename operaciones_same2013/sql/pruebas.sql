select * from encu.variables where  var_tipovar is null


select * from encu.preguntas where pre_pre='SN15A'

select * from encu.saltos where sal_destino='Bloind'
select * from encu.preguntas where pre_destino='Bloind'





select * from encu.saltos where sal_destino='SN26d';
update encu.saltos set sal_destino='SN26D' where sal_destino='SN26d';
update encu.saltos set sal_destino='SN27D' where sal_destino='SN27d';

select * from encu.preguntas where pre_pre='SN26D';
select * from encu.filtros where fil_destino='Bloind';


select * from encu.variables where var_pre='SN26d'


select * from encu.variables where var_var='sn15a28_esp'
update encu.variables set var_expresion_habilitar= 'SN15a28=1' where var_var='sn15a28_esp';

select * from encu.variables where var_var like 'SN15%'

select * from encu.con_opc


update encu.filtros set fil_destino='fin' where fil_destino='Bloind';



update encu.variables set var_destino='SN15a1' where var_destino = 'sn15a_1';
update encu.variables set var_for='SMI1' where var_var = 't11_esp';
select * from encu.variables where var_var = 't11_esp';

select * from encu.variables where var_destino = 'Tabaco';
select * from encu.variables where var_destino = 'Antid';
select * from encu.variables where var_destino = 'Marih';


select var_pre, var_var, var_for, var_orden from encu.variables order by var_for, var_orden;


where var_destino = 'SN15a1';


update encu.variables set var_destino='SN15A' where var_destino = 'Salud';


select * from encu.saltos where sal_destino is not null



INSERT INTO encu.saltos(sal_ope, sal_var, sal_conopc, sal_opc, sal_destino, sal_tlg) values 
('same2013','t11','t11','1','SN15A',1),
('same2013','t11','t11','2','SN15A',1),
('same2013','t11','t11','3','SN15A',1);

