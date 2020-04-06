/*
select * from encu.preguntas where pre_ope='eah2012' and pre_for='I1' and pre_pre like 'O%';
select pre_orden,* from encu.preguntas where pre_ope='eah2012' and pre_for='I1' order by pre_orden;

select * from encu.filtros where fil_ope='eah2012' and fil_for='I1' and fil_blo='T'
select * from encu.filtros where fil_ope='eah2012' and fil_for='I1' order by fil_orden;
*/
update encu.filtros set fil_orden=15 where fil_ope='eah2012' and fil_for='I1' and fil_blo='T';
