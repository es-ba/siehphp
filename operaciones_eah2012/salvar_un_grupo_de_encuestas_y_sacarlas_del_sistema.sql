-- Comuna 14; Replica 03; UP 436
-- en respuestas 1504
select * from encu.respuestas where res_ope='eah2012' and res_enc in (select pla_enc from encu.plana_tem_ where pla_up=436 and pla_replica=3 and pla_comuna=14)
select * into his.respuestas_c14_r03_up436 from encu.respuestas where res_ope='eah2012' and res_enc in (select pla_enc from encu.plana_tem_ where pla_up=436 and pla_replica=3 and pla_comuna=14)
delete from encu.respuestas where res_ope='eah2012' and res_enc in (select pla_enc from encu.plana_tem_ where pla_up=436 and pla_replica=3 and pla_comuna=14)

-- en claves 30
select * from encu.claves where cla_ope='eah2012' and cla_enc in (select pla_enc from encu.plana_tem_ where pla_up=436 and pla_replica=3 and pla_comuna=14)
select * into his.claves_c14_r03_up436 from encu.claves where cla_ope='eah2012' and  cla_enc in (select pla_enc from encu.plana_tem_ where pla_up=436 and pla_replica=3 and pla_comuna=14)
delete from encu.claves where cla_ope='eah2012' and cla_enc in (select pla_enc from encu.plana_tem_ where pla_up=436 and pla_replica=3 and pla_comuna=14)

-- en las planas
-- 10
select * from encu.plana_s1_ where pla_enc in (select pla_enc from encu.plana_tem_ where pla_up=436 and pla_replica=3 and pla_comuna=14)
select * into his.plana_s1_c14_r03_up436 from encu.plana_s1_ where pla_enc in (select pla_enc from encu.plana_tem_ where pla_up=436 and pla_replica=3 and pla_comuna=14)
delete from encu.plana_s1_ where pla_enc in (select pla_enc from encu.plana_tem_ where pla_up=436 and pla_replica=3 and pla_comuna=14)

-- 6
select * from encu.plana_s1_p where pla_enc in (select pla_enc from encu.plana_tem_ where pla_up=436 and pla_replica=3 and pla_comuna=14)
select * into his.plana_s1_p_c14_r03_up436 from encu.plana_s1_p where pla_enc in (select pla_enc from encu.plana_tem_ where pla_up=436 and pla_replica=3 and pla_comuna=14)
delete from encu.plana_s1_p where pla_enc in (select pla_enc from encu.plana_tem_ where pla_up=436 and pla_replica=3 and pla_comuna=14)

-- 2
select * from encu.plana_a1_ where pla_enc in (select pla_enc from encu.plana_tem_ where pla_up=436 and pla_replica=3 and pla_comuna=14)
select * into his.plana_a1_c14_r03_up436 from encu.plana_a1_ where pla_enc in (select pla_enc from encu.plana_tem_ where pla_up=436 and pla_replica=3 and pla_comuna=14)
delete from encu.plana_a1_ where pla_enc in (select pla_enc from encu.plana_tem_ where pla_up=436 and pla_replica=3 and pla_comuna=14)

-- 0
select * from encu.plana_a1_x where pla_enc in (select pla_enc from encu.plana_tem_ where pla_up=436 and pla_replica=3 and pla_comuna=14)
select * into his.plana_a1_x_c14_r03_up436 from encu.plana_a1_x where pla_enc in (select pla_enc from encu.plana_tem_ where pla_up=436 and pla_replica=3 and pla_comuna=14)
delete from encu.plana_a1_x where pla_enc in (select pla_enc from encu.plana_tem_ where pla_up=436 and pla_replica=3 and pla_comuna=14)

-- 2
select * from encu.plana_i1_ where pla_enc in (select pla_enc from encu.plana_tem_ where pla_up=436 and pla_replica=3 and pla_comuna=14)
select * into his.plana_i1_c14_r03_up436 from encu.plana_i1_ where pla_enc in (select pla_enc from encu.plana_tem_ where pla_up=436 and pla_replica=3 and pla_comuna=14)
delete from encu.plana_i1_ where pla_enc in (select pla_enc from encu.plana_tem_ where pla_up=436 and pla_replica=3 and pla_comuna=14)

-- en la tem 10
select * from encu.plana_tem_ where pla_up=436 and pla_replica=3 and pla_comuna=14
select * into his.plana_tem_c14_r03_up436 from encu.plana_tem_ where pla_up=436 and pla_replica=3 and pla_comuna=14
delete from encu.plana_tem_ where pla_up=436 and pla_replica=3 and pla_comuna=14


-- Comuna 01; Replica 04; UP 196
-- en respuestas
select * from encu.respuestas where res_ope='eah2012' and res_enc in (select pla_enc from encu.plana_tem_ where pla_up=196 and pla_replica=4 and pla_comuna=1)
select * into his.respuestas_c01_r04_up196 from encu.respuestas where res_ope='eah2012' and res_enc in (select pla_enc from encu.plana_tem_ where pla_up=196 and pla_replica=4 and pla_comuna=1)
delete from encu.respuestas where res_ope='eah2012' and res_enc in (select pla_enc from encu.plana_tem_ where pla_up=196 and pla_replica=4 and pla_comuna=1)

-- en claves 30
select * from encu.claves where cla_ope='eah2012' and cla_enc in (select pla_enc from encu.plana_tem_ where pla_up=196 and pla_replica=4 and pla_comuna=1)
select * into his.claves_c01_r04_up196 from encu.claves where cla_ope='eah2012' and cla_enc in (select pla_enc from encu.plana_tem_ where pla_up=196 and pla_replica=4 and pla_comuna=1)
delete from encu.claves where cla_ope='eah2012' and cla_enc in (select pla_enc from encu.plana_tem_ where pla_up=196 and pla_replica=4 and pla_comuna=1)

-- en las planas 10
select * from encu.plana_s1_ where pla_enc in (select pla_enc from encu.plana_tem_ where pla_up=196 and pla_replica=4 and pla_comuna=1)
select * into his.plana_s1_c01_r04_up196 from encu.plana_s1_ where pla_enc in (select pla_enc from encu.plana_tem_ where pla_up=196 and pla_replica=4 and pla_comuna=1)
delete from encu.plana_s1_ where pla_enc in (select pla_enc from encu.plana_tem_ where pla_up=196 and pla_replica=4 and pla_comuna=1)

-- 4
select * from encu.plana_s1_p where pla_enc in (select pla_enc from encu.plana_tem_ where pla_up=196 and pla_replica=4 and pla_comuna=1)
select * into his.plana_s1_p_c01_r04_up196 from encu.plana_s1_p where pla_enc in (select pla_enc from encu.plana_tem_ where pla_up=196 and pla_replica=4 and pla_comuna=1)
delete from encu.plana_s1_p where pla_enc in (select pla_enc from encu.plana_tem_ where pla_up=196 and pla_replica=4 and pla_comuna=1)

-- 2
select * from encu.plana_a1_ where pla_enc in (select pla_enc from encu.plana_tem_ where pla_up=196 and pla_replica=4 and pla_comuna=1)
select * into his.plana_a1_c01_r04_up196 from encu.plana_a1_ where pla_enc in (select pla_enc from encu.plana_tem_ where pla_up=196 and pla_replica=4 and pla_comuna=1)
delete from encu.plana_a1_ where pla_enc in (select pla_enc from encu.plana_tem_ where pla_up=196 and pla_replica=4 and pla_comuna=1)

-- 1
select * from encu.plana_a1_x where pla_enc in (select pla_enc from encu.plana_tem_ where pla_up=196 and pla_replica=4 and pla_comuna=1)
select * into his.plana_a1_x_c01_r04_up196 from encu.plana_a1_x where pla_enc in (select pla_enc from encu.plana_tem_ where pla_up=196 and pla_replica=4 and pla_comuna=1)
delete from encu.plana_a1_x where pla_enc in (select pla_enc from encu.plana_tem_ where pla_up=196 and pla_replica=4 and pla_comuna=1)

-- 3
select * from encu.plana_i1_ where pla_enc in (select pla_enc from encu.plana_tem_ where pla_up=196 and pla_replica=4 and pla_comuna=1)
select * into his.plana_i1_c01_r04_up196 from encu.plana_i1_ where pla_enc in (select pla_enc from encu.plana_tem_ where pla_up=196 and pla_replica=4 and pla_comuna=1)
delete from encu.plana_i1_ where pla_enc in (select pla_enc from encu.plana_tem_ where pla_up=196 and pla_replica=4 and pla_comuna=1)

-- en la tem 10
select * from encu.plana_tem_ where pla_up=196 and pla_replica=4 and pla_comuna=1
select * into his.plana_tem_c01_r04_up196 from encu.plana_tem_ where pla_up=196 and pla_replica=4 and pla_comuna=1
delete from encu.plana_tem_ where pla_up=196 and pla_replica=4 and pla_comuna=1



--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- reponer una de las encuestas guardadas y borradas
select * from his.claves_c01_r04_up196 where cla_enc = 410039 and cla_ope='eah2012'
insert into encu.claves (select * from his.claves_c01_r04_up196 where cla_enc = 410039 and cla_ope='eah2012')

select * from his.plana_tem_c01_r04_up196 where pla_enc=410039
delete from his.plana_tem_c01_r04_up196 where pla_enc=410039
insert into encu.plana_tem_ (select * from his.plana_tem_c01_r04_up196 where pla_enc=410039)
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

