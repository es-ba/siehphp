--- 4 encuestas de participacion 1

select pla_enc from encu.plana_tem_ where pla_participacion = 1 order by pla_enc limit 4;

--- 3 encuestas de participacion 3, una con un hogar y un miembro Gerardo:encuesta 310006

select res_enc from encu.respuestas where res_ope = 'eah2012' and res_hog > 0 and res_hog < 2 and res_enc in 
(select pla_enc from encu.plana_tem_ where pla_participacion = 3) 
and res_enc in 
(select res_enc from encu.respuestas where res_ope = 'eah2012' and res_for= 'S1' and res_var = 'entrea' and res_valor = '1')
group by res_enc, res_hog order by res_enc, res_hog
limit 3; 

select * from encu.respuestas where res_ope='eah2012' and res_enc = 310006 and res_for = 'S1' and res_mat = 'P';

--- desactive trigger respuestas_sinc_tem para modificar respuestas OJO!!!!!!!!!!!
--- desactive trigger respuestas_control_editable  OJO!!!!!!!!

update encu.respuestas set res_valor ='Gerardo' where res_var = 'nombre' and res_ope='eah2012' and res_for = 'S1' and res_mat = 'P' and res_hog = 1 and res_enc = 310006 and res_mie = 1 and res_exm = 0;
update encu.respuestas set res_valor ='2' where res_var = 'sexo' and res_ope='eah2012' and res_for = 'S1' and res_mat = 'P' and res_hog = 1 and res_enc = 310006 and res_mie = 1 and res_exm = 0;

--- active triggers

--- 3 encuestas de participacion 2, (una con dos hogares (Ricardo,Elvira,Alejandro) y (Marta,María) 513423
--- la 512243 tiene tres hogares uno norea y dos rea

select res_enc from encu.respuestas where res_ope = 'eah2012' and res_hog > 1 and res_hog < 3 and  res_mie > 1 and res_mie < 4
and res_enc in 
(select pla_enc from encu.plana_tem_ where pla_participacion = 2) 
and res_enc in 
(select res_enc from encu.respuestas where res_ope = 'eah2012' and res_for= 'S1' and res_var = 'entrea' and res_valor = '1')
group by res_enc, res_hog order by res_enc, res_hog;

select * from encu.respuestas where res_ope='eah2012' and res_enc = 513423 and res_for = 'S1' and res_mat = 'P' order by res_hog, res_mie;

--- desactive triggers

update encu.respuestas set res_valor ='Ricardo' where res_var = 'nombre' and res_ope='eah2012' and res_for = 'S1' and res_mat = 'P' and res_hog = 1 and res_enc = 513423 and res_mie = 1 and res_exm = 0;
update encu.respuestas set res_valor ='Elvira' where res_var = 'nombre' and res_ope='eah2012' and res_for = 'S1' and res_mat = 'P' and res_hog = 1 and res_enc = 513423 and res_mie = 2 and res_exm = 0;
update encu.respuestas set res_valor ='Alejandro' where res_var = 'nombre' and res_ope='eah2012' and res_for = 'S1' and res_mat = 'P' and res_hog = 1 and res_enc = 513423 and res_mie = 3 and res_exm = 0;
update encu.respuestas set res_valor ='1' where res_var = 'sexo' and res_ope='eah2012' and res_for = 'S1' and res_mat = 'P' and res_hog = 1 and res_enc = 513423 and res_mie = 3 and res_exm = 0;
update encu.respuestas set res_valor ='Marta' where res_var = 'nombre' and res_ope='eah2012' and res_for = 'S1' and res_mat = 'P' and res_hog = 2 and res_enc = 513423 and res_mie = 1 and res_exm = 0;
update encu.respuestas set res_valor ='2' where res_var = 'sexo' and res_ope='eah2012' and res_for = 'S1' and res_mat = 'P' and res_hog = 2 and res_enc = 513423 and res_mie = 1 and res_exm = 0;
update encu.respuestas set res_valor ='María' where res_var = 'nombre' and res_ope='eah2012' and res_for = 'S1' and res_mat = 'P' and res_hog = 2 and res_enc = 513423 and res_mie = 2 and res_exm = 0;
update encu.respuestas set res_valor ='2' where res_var = 'sexo' and res_ope='eah2012' and res_for = 'S1' and res_mat = 'P' and res_hog = 2 and res_enc = 513423 and res_mie = 2 and res_exm = 0;

--- active triggers