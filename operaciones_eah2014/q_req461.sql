select count(distinct enc)
  from operaciones.factores_req461


select enc, count(distinct w)
from operaciones.factores_req461
group by enc
having count(distinct w)>1

select pla_rea,*
from encu.plana_tem_ t join (select distinct enc from operaciones.factores_req461) as f on f.enc=t.pla_enc 
where pla_rea not in (1,3)

select count(*)
from encu.plana_tem_

select pla_rea,*
from encu.plana_tem_
where pla_enc=103506

select * from encu.plana_I1_
where pla_enc in (222704,103506,456510)
order by pla_enc, pla_hog, pla_mie


select count(*) cant, 'respuestas' tabla
    from encu.respuestas a
    where not exists (select * from operaciones.factores_req461 b  where b.enc=a.res_enc ) 
union    
select count(*) cant, 'tem' tabla
    from encu.tem a
    where not exists (select * from operaciones.factores_req461 b  where b.enc=a.tem_enc ) 
union    
select count(*)  cant, 'plana_tem' tabla
    from encu.plana_tem_ a
    where not exists (select * from operaciones.factores_req461 b  where b.enc=a.pla_enc ) 
union    
select count(*) cant, 'plana_s1_' tabla
    from encu.plana_s1_ a
    where not exists (select * from operaciones.factores_req461 b  where b.enc=a.pla_enc )
union    
select count(*)cant, 'plana_s1_p' tabla
    from encu.plana_s1_p a
    where not exists (select * from operaciones.factores_req461 b  where b.enc=a.pla_enc )
union    
select count(*) cant, 'plana_a1_' tabla 
    from encu.plana_a1_ a
    where not exists (select * from operaciones.factores_req461 b  where b.enc=a.pla_enc )
union    
select count(*) cant, 'plana_a1_x' tabla 
    from encu.plana_a1_x a
    where not exists (select * from operaciones.factores_req461 b  where b.enc=a.pla_enc )
union    
select count(*) cant, 'plana_pg1_' tabla 
    from encu.plana_pg1_ a
    where not exists (select * from operaciones.factores_req461 b  where b.enc=a.pla_enc )
union    
select count(*) cant, 'plana_pg1_m' tabla 
    from encu.plana_pg1_m a
    where not exists (select * from operaciones.factores_req461 b  where b.enc=a.pla_enc )
union    
select count(*) cant, 'plana_i1_' tabla
    from encu.plana_i1_ a
    where not exists (select * from operaciones.factores_req461 b  where b.enc=a.pla_enc )
union    
select count(*) cant, 'plana_sup_' tabla 
    from encu.plana_sup_ a
    where not exists (select * from operaciones.factores_req461 b  where b.enc=a.pla_enc ) 
union    
select count(*) cant, 'claves' tabla 
    from encu.claves a
    where not exists (select * from operaciones.factores_req461 b  where b.enc=a.cla_enc ) 
union    
select count(*) cant, 'inconsistencias' tabla 
    from encu.inconsistencias a
    where not exists (select * from operaciones.factores_req461 b  where b.enc=a.inc_enc )  
order by tabla;
  
46210;"claves"
4675;"inconsistencias"
3705;"plana_a1_"
247;"plana_a1_x"
9187;"plana_i1_"
1346;"plana_pg1_"
2062;"plana_pg1_m"
7918;"plana_s1_"
9187;"plana_s1_p"
1269;"plana_sup_"
9505;"plana_tem"
3230807;"respuestas"
9505;"tem"

delete from encu.respuestas a
    where not exists (select enc from operaciones.factores_req461 b  where b.enc=a.res_enc ) ;    
delete from encu.tem a
    where not exists (select enc from operaciones.factores_req461 b  where b.enc=a.tem_enc ) ;    
delete  from encu.plana_tem_ a
    where not exists (select enc from operaciones.factores_req461 b  where b.enc=a.pla_enc ) ;    
delete from encu.plana_s1_ a
    where not exists (select enc from operaciones.factores_req461 b  where b.enc=a.pla_enc );    
delete from encu.plana_s1_p a
    where not exists (select enc from operaciones.factores_req461 b  where b.enc=a.pla_enc );    
delete from encu.plana_a1_ a
    where not exists (select enc from operaciones.factores_req461 b  where b.enc=a.pla_enc );    
delete from encu.plana_a1_x a
    where not exists (select enc from operaciones.factores_req461 b  where b.enc=a.pla_enc );    
delete from encu.plana_i1_ a
    where not exists (select enc from operaciones.factores_req461 b  where b.enc=a.pla_enc );    
delete from encu.claves a
    where not exists (select enc from operaciones.factores_req461 b  where b.enc=a.cla_enc ) ;    
delete from encu.inconsistencias a
    where not exists (select enc from operaciones.factores_req461 b  where b.enc=a.inc_enc ) ;
delete from encu.plana_pg1_ a
    where not exists (select enc from operaciones.factores_req461 b  where b.enc=a.pla_enc );    
delete from encu.plana_pg1_m a
    where not exists (select enc from operaciones.factores_req461 b  where b.enc=a.pla_enc );    
delete from encu.plana_sup_ a
    where not exists (select enc from operaciones.factores_req461 b  where b.enc=a.pla_enc );    

select count(*) from encu.plana_tem_

------------
Continúa Emilio

select enc, count(distinct w)
  from operaciones.factores_req461 
  group by enc
  having count(distinct w)>1

select count(distinct enc)
  from operaciones.factores_req461 
-- 1823

select count(*)
  from encu.plana_tem_
-- 1823

update encu.plana_tem_ set pla_fexp=w
  from operaciones.factores_req461 
  where enc=pla_enc;