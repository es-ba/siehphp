insert into encu.tem (tem_enc,tem_tlg) select *,1 from generate_series(200001, 200999)
insert into encu.plana_tem_ (pla_enc,pla_tlg) select *,1 from generate_series(200001, 200999)
update encu.plana_tem_ set pla_replica=1, pla_participacion=1
  where pla_enc between 200001 and 200999
/*
update encu.respuestas 
  set res_valor=1
  where res_enc between 200001 and 200999
    and res_for='TEM'
    and res_ope='eah2013'
    and res_mat=''
    and res_var in ('participacion','replica');
*/
-- insert into encu.claves (cla_enc,cla_ope,cla_for,cla_mat,cla_tlg) select *,'eah2013','TEM','',1 from generate_series(200001, 200999)