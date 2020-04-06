delete from encu.opciones where opc_conopc = 'bc1a' and opc_ope = 'eah2012' and opc_opc='8';
insert into encu.con_opc values ('eah2012', 'bc1_99', null, 1);
alter table encu.plana_i1_ add column pla_bc1_99 integer;
update encu.variables set var_var='bc1_99', var_conopc='bc1_99', var_orden=10 where var_var = 'bc1_9' and var_ope = 'eah2012';
update encu.variables set var_var='bc1_9', var_conopc='bc1_9', var_expresion_habilitar=null, var_orden=9 where var_var = 'bc1_8' and var_ope = 'eah2012';
INSERT INTO encu.variables(var_ope, var_for, var_pre, var_var, var_texto, 
            var_conopc, var_tipovar, var_optativa, var_orden,  var_tlg)
    VALUES ('eah2012', 'I1', 'BC1', 'bc1_8', 'Ninguna',
	    'bc1_8', 'multiple_marcar',false, 8,1);
update encu.preguntas set pre_texto='La semana pasada, ¿cuántos días leyó el diario en papel?', pre_aclaracion=null where pre_ope='eah2012' and pre_pre='BC2';
update  encu.opciones set opc_texto=opc_texto || ' días' where opc_ope = 'eah2012' and opc_conopc='bc2' and opc_opc in ('1','2');
update  encu.opciones set opc_texto=opc_texto || ' días' where opc_ope = 'eah2012' and opc_conopc='bc3' and opc_opc ='1';
update  encu.opciones set opc_texto='Más de 3 días' where opc_ope = 'eah2012' and opc_conopc='bc3' and opc_opc ='2';
update encu.preguntas set pre_texto='La semana pasada, ¿cuántos días usó internet, incluyendo el chequeo de correo electrónico?', pre_aclaracion=null where pre_ope='eah2012' and pre_pre='BC3';
update encu.preguntas set pre_texto='Durante este año, ¿cuántas películas de video/DVD y/o bajadas de internet vio?', pre_aclaracion='Encuestador: no incluye las películas vistas en el cine.' where pre_ope='eah2012' and pre_pre='BC4';
update  encu.opciones set opc_texto='Entre 1 y 4' where opc_ope = 'eah2012' and opc_conopc='bc4' and opc_opc ='1';
update  encu.opciones set opc_texto='Entre 5 y 15' where opc_ope = 'eah2012' and opc_conopc='bc4' and opc_opc ='2';
update  encu.opciones set opc_texto='Más de 15' where opc_ope = 'eah2012' and opc_conopc='bc4' and opc_opc ='3';
insert into encu.opciones (opc_ope, opc_conopc, opc_opc, opc_texto, opc_orden, opc_tlg) values ('eah2012','bc4','4','No vio',4,1);
update  encu.opciones set opc_texto='NS/NC', opc_aclaracion='(No leer)' where opc_ope = 'eah2012' and opc_conopc='bc4' and opc_opc ='9';
update encu.preguntas set pre_texto='Durante este año, ¿cuántos libros leyó, no relacionados con trabajo o estudios?', pre_aclaracion=null where pre_ope='eah2012' and pre_pre='BC5';
update  encu.opciones set opc_texto='Entre 1 y 4' where opc_ope = 'eah2012' and opc_conopc='bc5' and opc_opc ='1';
update  encu.opciones set opc_texto='Entre 5 y 15' where opc_ope = 'eah2012' and opc_conopc='bc5' and opc_opc ='2';
update  encu.opciones set opc_texto='Más de 15' where opc_ope = 'eah2012' and opc_conopc='bc5' and opc_opc ='3';
insert into encu.opciones (opc_ope, opc_conopc, opc_opc, opc_texto, opc_orden, opc_tlg) values ('eah2012','bc5','4','No leyó',4,1);
update  encu.opciones set opc_texto='NS/NC', opc_aclaracion='(No leer)' where opc_ope = 'eah2012' and opc_conopc='bc5' and opc_opc ='9';
update encu.preguntas set pre_texto='Durante este año, ¿cuantas veces asistió al cine?', pre_aclaracion=null where pre_ope='eah2012' and pre_pre='BC6';
update  encu.opciones set opc_texto='Entre 1 y 5 veces' where opc_ope = 'eah2012' and opc_conopc='bc6' and opc_opc ='1';
update  encu.opciones set opc_texto='Más de 5 veces' where opc_ope = 'eah2012' and opc_conopc='bc6' and opc_opc ='2';
update  encu.opciones set opc_texto='No asistió' where opc_ope = 'eah2012' and opc_conopc='bc6' and opc_opc ='3';
delete from encu.opciones where opc_ope = 'eah2012' and opc_conopc='bc6' and opc_opc ='4';
update  encu.opciones set opc_texto='NS/NC', opc_aclaracion='(No leer)' where opc_ope = 'eah2012' and opc_conopc='bc6' and opc_opc ='9';
update encu.preguntas set pre_texto='Durante este año, ¿asistió a alguna biblioteca?', pre_aclaracion='pública, privada, escolar' where pre_ope='eah2012' and pre_pre='BC7';
update  encu.opciones set opc_texto='Si' where opc_ope = 'eah2012' and opc_conopc='bc7' and opc_opc ='1';
update  encu.opciones set opc_texto='No' where opc_ope = 'eah2012' and opc_conopc='bc7' and opc_opc ='2';
update  encu.opciones set opc_texto='NS/NC', opc_aclaracion='(No leer)' where opc_ope = 'eah2012' and opc_conopc='bc7' and opc_opc ='9';

update encu.preguntas set pre_texto='Durante este año, ¿asistió a recitales o conciertos de música?', pre_aclaracion=null where pre_ope='eah2012' and pre_pre='BC8';
update  encu.opciones set opc_texto='Si' where opc_ope = 'eah2012' and opc_conopc='bc8' and opc_opc ='1';
update  encu.opciones set opc_texto='No' where opc_ope = 'eah2012' and opc_conopc='bc8' and opc_opc ='2';
update  encu.opciones set opc_texto='NS/NC', opc_aclaracion='(No leer)' where opc_ope = 'eah2012' and opc_conopc='bc8' and opc_opc ='9';
delete from encu.saltos where sal_ope='eah2012' and sal_conopc = 'bc8';

update encu.preguntas set pre_texto='Durante este año, ¿asistió a espectáculos de teatro?', pre_aclaracion=null where pre_ope='eah2012' and pre_pre='BC9';
update  encu.opciones set opc_texto='Si' where opc_ope = 'eah2012' and opc_conopc='bc9' and opc_opc ='1';
update  encu.opciones set opc_texto='No' where opc_ope = 'eah2012' and opc_conopc='bc9' and opc_opc ='2';
update  encu.opciones set opc_texto='NS/NC', opc_aclaracion='(No leer)' where opc_ope = 'eah2012' and opc_conopc='bc9' and opc_opc ='9';

update encu.preguntas set pre_texto='Durante este año, ¿asistió a espectáculos de danza o ballet?', pre_aclaracion=null where pre_ope='eah2012' and pre_pre='BC10';
update  encu.opciones set opc_texto='Si' where opc_ope = 'eah2012' and opc_conopc='bc10' and opc_opc ='1';
update  encu.opciones set opc_texto='No' where opc_ope = 'eah2012' and opc_conopc='bc10' and opc_opc ='2';
update  encu.opciones set opc_texto='NS/NC', opc_aclaracion='(No leer)' where opc_ope = 'eah2012' and opc_conopc='bc10' and opc_opc ='9';
delete from encu.saltos where sal_ope='eah2012' and sal_conopc = 'bc10';

update encu.preguntas set pre_texto='Durante este año, ¿asistió a museos o galerías de arte?', pre_aclaracion=null where pre_ope='eah2012' and pre_pre='BC11';
update  encu.opciones set opc_texto='Si' where opc_ope = 'eah2012' and opc_conopc='bc11' and opc_opc ='1';
update  encu.opciones set opc_texto='No' where opc_ope = 'eah2012' and opc_conopc='bc11' and opc_opc ='2';
update  encu.opciones set opc_texto='NS/NC', opc_aclaracion='(No leer)' where opc_ope = 'eah2012' and opc_conopc='bc11' and opc_opc ='9';
delete from encu.opciones where opc_ope = 'eah2012' and opc_conopc='bc11' and opc_opc ='3';

update encu.preguntas set pre_texto='Durante este año, ¿asistió a lugares bailables?', pre_aclaracion=null where pre_ope='eah2012' and pre_pre='BC12';
update  encu.opciones set opc_texto='Si' where opc_ope = 'eah2012' and opc_conopc='bc12' and opc_opc ='1';
update  encu.opciones set opc_texto='No' where opc_ope = 'eah2012' and opc_conopc='bc12' and opc_opc ='2';
update  encu.opciones set opc_texto='NS/NC', opc_aclaracion='(No leer)' where opc_ope = 'eah2012' and opc_conopc='bc12' and opc_opc ='9';
delete from encu.saltos where sal_ope='eah2012' and sal_conopc = 'bc12';

update encu.preguntas set pre_texto='Durante este año, ¿ha practicado como hobby alguna actividad artística como por ejemplo: escribir, pintar, hacer cerámica, fotografía, teatro, danza, coro, tocar instrumentos, etc.?  ', pre_aclaracion='Encuestador: no incluye a los que realizan estas actividades profesionalmente' where pre_ope='eah2012' and pre_pre='BC13';
update  encu.opciones set opc_texto='Si' where opc_ope = 'eah2012' and opc_conopc='bc13' and opc_opc ='1';
update  encu.opciones set opc_texto='No' where opc_ope = 'eah2012' and opc_conopc='bc13' and opc_opc ='2';
update  encu.opciones set opc_texto='NS/NC', opc_aclaracion='(No leer)' where opc_ope = 'eah2012' and opc_conopc='bc13' and opc_opc ='9';
delete from encu.opciones where opc_ope = 'eah2012' and opc_conopc='bc13' and opc_opc ='3';

delete from encu.saltos where sal_ope='eah2012' and sal_conopc in ('bc14', 'bc15', 'bc16', 'bc17', 'bc18', 'bc19', 'bc20');
delete from encu.opciones where opc_ope ='eah2012' and opc_conopc in ('bc14', 'bc15', 'bc16', 'bc17', 'bc18', 'bc19', 'bc20');
delete from encu.respuestas where res_ope='eah2012' and res_var in ('bc14', 'bc15', 'bc16', 'bc17', 'bc18', 'bc19', 'bc20');
delete from encu.variables where var_ope='eah2012' and var_var in ('bc14', 'bc15', 'bc16', 'bc17', 'bc18', 'bc19', 'bc20');
delete from encu.preguntas where pre_ope ='eah2012' and pre_pre in ('BC14', 'BC15', 'BC16', 'BC17', 'BC18', 'BC19', 'BC20');
insert into encu.bloques (blo_ope, blo_for, blo_blo, blo_texto, blo_orden, blo_tlg) values
('eah2012', 'I1', 'M13', 'Hábitos y prácticas culturales',2020,1);
update encu.bloques set blo_aclaracion = 'Empezando por el jefe' where blo_texto like 'COMPONENTES%' and blo_ope='eah2012';
update encu.preguntas set pre_texto='Si presta servicio doméstico en hogares particulares marque', pre_aclaracion=null where pre_ope='eah2012' and pre_pre='T37sd';
insert into encu.con_opc values ('eah2012','t39_bis',null,1);
update encu.variables set var_conopc='t39_bis' where var_ope='eah2012' and var_var='t39_bis';
insert into encu.opciones values 
('eah2012', 't39_bis', 1, 'Sí', '¿Con cuántos?',1,null,null,null,1),
('eah2012', 't39_bis', 2, 'No', null,2,null,null,null,1);

update  encu.opciones set opc_texto='Entre 1 y 3 días' where opc_ope = 'eah2012' and opc_conopc='bc2' and opc_opc ='1';
update  encu.opciones set opc_texto='Más de 3 días' where opc_ope = 'eah2012' and opc_conopc='bc2' and opc_opc ='2';
update  encu.opciones set opc_texto='Entre 1 y 3 días' where opc_ope = 'eah2012' and opc_conopc='bc3' and opc_opc ='1';
delete from encu.opciones where opc_ope = 'eah2012' and opc_conopc='bc9' and opc_opc ='3';

update  encu.opciones set opc_texto='NS/NC', opc_aclaracion='(no leer)' where opc_ope = 'eah2012' and opc_conopc='bc1' and opc_opc ='9';
update  encu.opciones set opc_texto='NS/NC', opc_aclaracion='(no leer)' where opc_ope = 'eah2012' and opc_conopc='bc1a' and opc_opc ='9';
update  encu.opciones set opc_texto='NS/NC', opc_aclaracion='(no leer)' where opc_ope = 'eah2012' and opc_conopc='bc2' and opc_opc ='9';
update  encu.opciones set opc_texto='NS/NC', opc_aclaracion='(no leer)' where opc_ope = 'eah2012' and opc_conopc='bc3' and opc_opc ='9';

