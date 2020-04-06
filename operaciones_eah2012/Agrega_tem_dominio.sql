alter table encu.tem  add column tem_dominio integer;
alter table encu.plana_tem_ add column pla_dominio integer;

update encu.tem set tem_dominio=3 where tem_replica in (1,6);
update encu.tem set tem_dominio=5 where tem_replica=7;
update encu.tem set tem_dominio=4 where tem_replica=8;
update encu.plana_tem_ set pla_dominio=3 where pla_replica in (1,6);
update encu.plana_tem_ set pla_dominio=5 where pla_replica=7;
update encu.plana_tem_ set pla_dominio=4 where pla_replica=8;

