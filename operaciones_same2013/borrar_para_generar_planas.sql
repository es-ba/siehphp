/*
DELETE from encu.respuestas;
DELETE from encu.claves;

INSERT INTO encu.claves (cla_ope, cla_for, cla_mat, cla_enc, cla_tlg) SELECT 'same2013','TEM','',tem_enc,tem_tlg FROM encu.tem;

update encu.tem set tem_dominio=3, tem_replica=9;
update encu.plana_tem_ set pla_dominio=3, pla_replica=9;

-- */

UPDATE encu.respuestas set res_valor='0'
  where res_var='asignable' 
    and res_for='TEM'
    and res_mat=''
    and res_enc=100001
    and res_ope='same2013';

select * from encu.respuestas 
  where res_var in ('asignable','estado')
    and res_for='TEM'
    and res_mat=''
    and res_enc=100001
    and res_ope='same2013';

select pla_Estado,* from encu.plana_tem_
  where pla_enc=100001;