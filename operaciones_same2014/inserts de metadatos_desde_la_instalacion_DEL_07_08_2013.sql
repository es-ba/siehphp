delete from encu.saltos where sal_destino = 'Bloind' and sal_ope = 'same2013' and sal_var like 't%';

update encu.variables set var_tipovar='texto' where var_tipovar='Texto';
update encu.variables set var_tipovar ='texto_libre' where  var_tipovar is null;
update encu.saltos set sal_destino='E12A' where sal_destino='E12a';
update encu.saltos set sal_destino='SN1B' where sal_destino='SN1b';
update encu.variables set var_destino='fin' where var_destino='Bloind';
update encu.saltos set sal_destino='fin' where sal_destino='Bloind';
update encu.filtros set fil_destino='fin' where fil_destino='Bloind';
update encu.variables set var_for='SMI1' where var_var = 't11_esp';
update encu.variables set var_destino='SN15A' where var_destino = 'Salud';

INSERT INTO encu.saltos(sal_ope, sal_var, sal_conopc, sal_opc, sal_destino, sal_tlg) values 
('same2013','t11','t11','1','SN15A',1),
('same2013','t11','t11','2','SN15A',1),
('same2013','t11','t11','3','SN15A',1);

update encu.saltos set sal_destino='SN26D' where sal_destino='SN26d';
update encu.saltos set sal_destino='SN27D' where sal_destino='SN27d';
update encu.variables set var_expresion_habilitar= 'SN15a28=1' where var_var='sn15a28_esp';

INSERT INTO encu.opciones(
            opc_ope, opc_conopc, opc_opc, opc_texto, opc_aclaracion, opc_orden, 
            opc_tlg)
VALUES
('same2013','p4','1','Jefe/a',null ,'1',1),
('same2013','p4','2','Cónyuge/Pareja',null ,'2',1),
('same2013','p4','3','Hijo/a',null ,'3',1),
('same2013','p4','4','Hijastro/a',null ,'4',1),
('same2013','p4','5','Yerno o Nuera',null ,'5',1),
('same2013','p4','6','Nieto',null ,'6',1),
('same2013','p4','7','Padre/Madre/Suegro/a',null ,'7',1),
('same2013','p4','8','Hermano/a',null ,'8',1),
('same2013','p4','9','Cuñado/a',null ,'9',1),
('same2013','p4','10','Sobrino/a',null,'10',1),
('same2013','p4','11','Abuelo/a',null,'11',1),
('same2013','p4','12','Otro familiar',null,'12',1),
('same2013','p4','13','Servicio doméstico y sus familiares',null,'13',1),
('same2013','p4','14','Otro no familiar',null,'14',1),
('same2013','p5','1','Unido/a',null ,'1',1),
('same2013','p5','2','Casado/a',null ,'2',1),
('same2013','p5','3','Separado/a de unión',null ,'3',1),
('same2013','p5','4','Viudo/a de unión',null ,'4',1),
('same2013','p5','5','Divorciado/a',null ,'5',1),
('same2013','p5','6','Separado/a de matrimonio',null ,'6',1),
('same2013','p5','7','Viudo/a de matrimonio',null ,'7',1),
('same2013','p5','8','Soltero/a, nunca casado/a ni unido/a',null ,'8',1),
('same2013','ghq_12','0','Mejor que lo habitual',null ,'0',1),
('same2013','ghq_12','1','Igual que lo habitual',null ,'1',1),
('same2013','ghq_12','2','Menos que lo habitual',null ,'2',1),
('same2013','ghq_12','3','Mucho menos que lo habitual',null ,'3',1),
('same2013','ghq_12','8','No sabe',null ,'8',1),
('same2013','ghq_12','9','No contesta',null ,'9',1);

update encu.saltos set sal_destino ='NOREAIND' where sal_destino ='noreaind';
update encu.variables set var_conopc = null where var_var = 'sn23_11_esp';
----------------------------------------------------------------------------------
UPDATE encu.matrices
   SET mat_ua='hog', mat_ultimo_campo_pk='hog'
 WHERE mat_for='SM1';

UPDATE encu.matrices
   SET mat_ua='mie', mat_ultimo_campo_pk='mie'
 WHERE mat_for='SM1' and mat_mat='P';
 
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


INSERT INTO encu.saltos(
            sal_ope, sal_var, sal_conopc, sal_opc, sal_destino, sal_tlg) values
            ('same2013','t3','t3','1','SN15A',1),
            ('same2013','t9','si_no','1','SN15A',1),
            ('same2013','t10','si_no','1','SN15A',1),
            ('same2013','t45','t45','3','SN15A',1);

update encu.variables set var_destino='SN27A' where var_VAR ='sn26c';
update encu.variables set var_destino='SN28A' where var_VAR ='sn27c';
update encu.variables set var_var=lower(var_var);
update encu.variables set var_destino=lower(var_destino) where var_destino like 'SN%';            
update encu.variables set var_destino='sn15a1' where var_destino='sn15a';

update encu.variables 
set var_expresion_habilitar=lower(var_expresion_habilitar), var_subordinada_var=lower(var_subordinada_var) where var_var='sn15a28_esp';
update encu.preguntas set pre_blo= 'Razonnoind' where pre_pre='NOREAIND';
update encu.variables set var_texto='Nº de miembro seleccionado de 16 a 64 años' where var_var = 'cr_num_miembro';
update encu.variables set var_texto='Ningún miembro de 16 a 64 años' where var_var = 'cr_ningun_miembro';



/* insercion TEM para prueba 
insert into encu.tem (tem_enc,tem_tlg) select *,1 from generate_series(200001, 200999);
INSERT INTO encu.claves(
            cla_ope, cla_for, cla_mat, cla_enc, cla_hog, cla_mie, cla_exm, cla_tlg)
select 'same2013', 'TEM', '',  tem_enc, 0, 0, 0, 1 from encu.tem
*/

update encu.preguntas  set pre_abreviado= 'Nombre' where pre_mat='P' and pre_pre='P1';
update encu.preguntas  set pre_abreviado= 'Fecha nac' where pre_mat='P' and pre_pre='P3A';
update encu.preguntas  set pre_abreviado= 'Edad' where pre_mat='P' and pre_pre='P3B';
update encu.preguntas  set pre_abreviado= 'Parent' where pre_mat='P' and pre_pre='P4';
update encu.preguntas  set pre_abreviado= 'Estado cony' where pre_mat='P' and pre_pre='P5';
update encu.preguntas  set pre_abreviado= 'Letra' where pre_mat='P' and pre_pre='L0';
update encu.preguntas  set pre_abreviado= 'Nación' where pre_mat='P' and pre_pre='M1';
update encu.preguntas  set pre_abreviado= 'Escol' where pre_mat='P' and pre_pre='E2';
update encu.preguntas  set pre_abreviado= 'Niv actual' where pre_mat='P' and pre_pre='E6A';
update encu.preguntas  set pre_abreviado= 'Niv max' where pre_mat='P' and pre_pre='E12A';
update encu.preguntas  set pre_abreviado= 'Niv Completo' where pre_mat='P' and pre_pre='E13';
update encu.preguntas  set pre_abreviado= 'Afiliado' where pre_mat='P' and pre_pre='SN1B';


INSERT INTO encu.bloques(
            blo_ope, blo_for, blo_blo, blo_mat
            ,blo_orden, blo_tlg, blo_texto)
    VALUES ('same2013', 'SM1', 'CR','',25,1, '')

update encu.preguntas set pre_blo='CR' where pre_pre in ('TP', 'CR');--163

update encu.bloques set blo_texto='TOTAL DE PERSONAS EN EL RANGO' where blo_blo='CR';

update encu.preguntas set pre_texto=' ', pre_aclaracion ='total de personas en el rango' where pre_pre in ('TP');--163



alter table encu.inconsistencias rename column con_falsos_positivos to inc_falsos_positivos;
alter table encu.inconsistencias rename column pla_bolsa to inc_bolsa;
alter table encu.inconsistencias rename column pla_estado to inc_estado;
 
alter table encu.plana_sm1_p rename column pla_p2 to pla_sexo;
alter table encu.plana_sm1_p rename column pla_p3a to pla_f_nac_o;
alter table encu.plana_sm1_p rename column pla_p3b to pla_edad;

update encu.variables set var_var= 'sexo' where var_var ='p2';
update encu.variables set var_var= 'f_nac_o' where var_var ='p3a';
update encu.variables set var_var= 'edad' where var_var ='p3b';

delete from encu.con_var;

INSERT INTO encu.opciones(
            opc_ope, opc_conopc, opc_opc, opc_texto, opc_aclaracion, opc_orden, 
            opc_proxima_vacia, opc_proxima_opc, opc_proxima_texto, opc_tlg)
    VALUES
('same2013','e12a','8','Educación especial',null,8,null,null,null,1);
UPDATE encu.opciones SET opc_texto = 'Primario/EGB (1 a 7 años)'             where opc_ope='same2013' and opc_conopc='e12a' and  opc_opc = '2';
UPDATE encu.opciones SET opc_texto = 'EGB (8 a 9 años)'                      where opc_ope='same2013' and opc_conopc='e12a' and  opc_opc = '3';
UPDATE encu.opciones SET opc_texto = 'Secundario/medio/común/polimodal'      where opc_ope='same2013' and opc_conopc='e12a' and  opc_opc = '4';
UPDATE encu.opciones SET opc_texto = 'Terciario o superior no universitario' where opc_ope='same2013' and opc_conopc='e12a' and  opc_opc = '5';
UPDATE encu.opciones SET opc_texto = 'Universitario'                         where opc_ope='same2013' and opc_conopc='e12a' and  opc_opc = '6';
UPDATE encu.opciones SET opc_texto = 'Postgrado'                             where opc_ope='same2013' and opc_conopc='e12a' and  opc_opc = '7';