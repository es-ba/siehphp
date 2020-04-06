/*
select * from encu.variables where var_var like 'sn15a28_esp'

update encu.variables set var_subordinada_var='SN15a28' where var_var like 'sn15a28_esp'
*/
select * from encu.preguntas where pre_pre='SN25A'

select * from encu.saltos where sal_var='sn24a' --and sal_opc='1'



----------------------------------------------------------------


update encu.saltos set sal_destino = 'SN25A' where sal_var='sn24a';
update encu.saltos set sal_destino = 'SN26A' where sal_var='sn25a';
update encu.saltos set sal_destino = 'SN27A' where sal_var='sn26a';
update encu.saltos set sal_destino = 'SN28A' where sal_var='sn27a';
update encu.saltos set sal_destino = 'SN29A' where sal_var='sn28a';
update encu.saltos set sal_destino = 'SN30A' where sal_var='sn29a';
update encu.saltos set sal_destino = 'SN31A' where sal_var='sn30a';
update encu.saltos set sal_destino = 'SN32A' where sal_var='sn31a';
update encu.saltos set sal_destino = 'SN33A' where sal_var='sn32a';
update encu.saltos set sal_destino = 'SN34A' where sal_var='sn33a';
update encu.saltos set sal_destino = 'SN27A' where sal_var='sn26b' and sal_opc='9';
update encu.saltos set sal_destino = 'SN28A' where sal_var='sn27b' and sal_opc='9';


update encu.variables set var_destino='SN27A' where var_VAR ='sn26c';
update encu.variables set var_destino='SN28A' where var_VAR ='sn27c';


INSERT INTO encu.saltos(
            sal_ope, sal_var, sal_conopc, sal_opc, sal_destino, sal_tlg) values
            ('same2013','t3','t3','1','SN15A',1),
            ('same2013','t9','si_no','1','SN15A',1),
            ('same2013','t10','si_no','1','SN15A',1),
            ('same2013','t45','t45','3','SN15A',1);


select var_destino from encu.variables where var_destino like 'SN%';

update encu.variables set var_destino=lower(var_destino) where var_destino like 'SN%';

select distinct sal_destino from encu.saltos where sal_destino is not null
where var_destino like 'SN%';


select var_destino from encu.variables where var_destino='sn15a'
update encu.variables set var_destino='sn15a1' where var_destino='sn15a'


update encu.variables 
set var_expresion_habilitar=lower(var_expresion_habilitar), var_subordinada_var=lower(var_subordinada_var) where var_var='sn15a28_esp';

select * from encu.variables where var_subordinada_var is not null

update encu.bloques set blo_orden=25 where blo_mat='P'

select * from encu.matrices
SELECT * from encu.preguntas where pre_for='SM1' order by pre_orden;

where pre_pre='CR';-305

SELECT * from encu.bloques where blo_for='SM1' order by blo_orden;

update encu.preguntas set pre_blo= 'Razonnoind' where pre_pre='NOREAIND';



update encu.variables set var_texto='Nº de miembro seleccionado de 16 a 64 años' where var_var = 'cr_num_miembro';
update encu.variables set var_texto='Ningún miembro de 16 a 64 años' where var_var = 'cr_ningun_miembro';
SELECT * from encu.variables where var_var = 'cr_ningun_miembro';




SELECT * from encu.variables where var_pre = 'CR';

"cr_num_miembro"
"cr_ningun_miembro"
select * from encu.opciones where opc_conopc='noreaind'


