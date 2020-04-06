insert into encu.tem (tem_enc, tem_tlg) values (200005,1), (200006,1);
update encu.tem set tem_lote = 1 where tem_enc in (200005,200006);
update encu.tem set tem_replica = 1 where tem_enc in (200005,200006);
update encu.tem set tem_comuna = 1 where tem_enc in (200005,200006);
update encu.tem set tem_up = 1 where tem_enc in (200005,200006);
insert into encu.claves (cla_ope, cla_for, cla_mat, cla_enc, cla_tlg) values  ('eah2013','TEM','',200005,1); 
insert into encu.claves (cla_ope, cla_for, cla_mat, cla_enc, cla_tlg) values  ('eah2013','TEM','',200006,1); 
--insert into encu.plana_tem_ (pla_enc, pla_up, pla_comuna, pla_replica, pla_lote,pla_tlg) values (200003,1,1,1,1,1);
select * from encu.respuestas where res_enc in (200003,200004);


select * from encu.plana_tem_ where pla_enc in (200003,200004);

update encu.respuestas set res_valor=0
  where res_var='asignable';

update encu.respuestas set res_valor = '19' where res_var = 'estado' and res_ope = 'eah2013' and res_for = 'TEM' and res_mat = '' and res_enc in (200005,200006);

/* para control 
select pla_estado,* from encu.plana_tem_ where pla_asignable=1;

select pla_replica, pla_comuna, count(*) from encu.plana_tem_ where pla_asignable=0
group by pla_replica, pla_comuna;

select  pla_replica, pla_comuna, pla_up from encu.plana_tem_ 
where pla_asignable=0
and  pla_replica=5 and pla_comuna=1
order by pla_up;

*/
