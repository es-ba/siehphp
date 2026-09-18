set search_path=encu;
delete 
--select count(*)
from plana_i1_; --162
delete 
--select count(*)
from plana_s1_p;--171
delete 
--select count(*) 
from plana_sup_; --1
delete
--select count(*) 
from plana_a1_;--1
delete
--select count(*) 
from plana_s1_; --82

delete 
from plana_pg1_; --10
delete 
from plana_pg1_m; --9
delete 
from pla_ext_hog;--0
 
delete 
--select count(*) 
from plana_tem_; --9570
delete
--select count(*)
from tem; --9570
--hasta aqui llegue 
delete 
--select count(*) 
from respuestas; --765876
delete
--select count(*) 
from claves; --DELETE 10086
delete 
--select count(*) 
from encu.anoenc; --0
delete
--select count(*) --31
from inconsistencias; --396
delete
--select count(*) 
from semanas; --1

delete from excepciones;--0

delete from registro_claves; --1

delete
--select count(*) 
from his.his_respuestas;--DELETE 200610
/*
delete
--select count(*) 
from his.his_modificaciones;
*/
delete 
--select * --count(*) 
from his.his_inconsistencias;--DELETE 1193

--actualizar personal y usuarios en un script aparte 
