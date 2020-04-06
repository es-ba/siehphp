create or replace view encu.v_frecuencia_de_ingreso as
select hisres_ope fre_ope, hisres_for fre_for, hisres_mat fre_mat, hisres_enc fre_enc, hisres_hog fre_hog, hisres_mie fre_mie, min(tlg_tlg) fre_tlg, min(tlg_momento) fre_mom
from his.his_respuestas 
 inner join encu.tiempo_logico on hisres_tlg=tlg_tlg
 inner join encu.sesiones on tlg_ses=ses_ses
 where ses_usu='msara' and hisres_enc < 900000 and hisres_for <>'TEM' 
 group by fre_ope, fre_for, fre_mat, fre_enc, fre_hog, fre_mie
 order by fre_mom;

--promedio por formulario I1
select date(fre_mom) fecha, count(fre_for) cant_formularios, min(fre_mom) min_fre_mom, max(fre_mom) max_fre_mom,  max(fre_mom)-min(fre_mom) cuanto_tardo,  (max(fre_mom)-min(fre_mom))/count(fre_for) promedio from encu.v_frecuencia_de_ingreso 
where fre_mat ='' and fre_for='I1' 
group by date(fre_mom)
order by date(fre_mom);

--promedio por formularios distintos a I1 
select avg(a.promedio) from
(select date(fre_mom) fecha, count(fre_for) cant_formularios, min(fre_mom) min_fre_mom, max(fre_mom) max_fre_mom,  max(fre_mom)-min(fre_mom) cuanto_tardo,  (max(fre_mom)-min(fre_mom))/count(fre_for) promedio from encu.v_frecuencia_de_ingreso 
where fre_mat ='' and fre_for<>'I1'  
group by date(fre_mom)
order by date(fre_mom)

--promedio por formularios distintos a I1 depurado
select avg(a.promedio) from
(select date(fre_mom) fecha, count(fre_for) cant_formularios, min(fre_mom) min_fre_mom, max(fre_mom) max_fre_mom,  max(fre_mom)-min(fre_mom) cuanto_tardo,  (max(fre_mom)-min(fre_mom))/count(fre_for) promedio from encu.v_frecuencia_de_ingreso 
where fre_mat ='' and fre_for<>'I1'  
group by date(fre_mom)
having count(fre_for)>9) a;
--"00:07:05.2846"
select 60/7 select (12+14+19+9+15)/5


--promedio por formulario I1 depurado

select avg(a.promedio) from
(select date(fre_mom) fecha, count(fre_for) cant_formularios, min(fre_mom) min_fre_mom, max(fre_mom) max_fre_mom,  max(fre_mom)-min(fre_mom) cuanto_tardo,  (max(fre_mom)-min(fre_mom))/count(fre_for) promedio from encu.v_frecuencia_de_ingreso 
where fre_mat ='' and fre_for='I1'  AND fre_mom<'2012-07-27 11:00:00.000' or fre_mom>'2012-07-28 00:00:00.000'
group by date(fre_mom)
having count(fre_for)>9) a;
--"00:04:03.315427"

--select 60/4
   
--11:10 por encuesta
-- 5 encuestas por hora

-- 890 encuestas
-- 10000 minutos
--select 10000/60
1   11:10
890 166 hs



/*
select * from encu.plana_tem_ where pla_para_asignar='papel' and pla_comenzo_ingreso=1

--promedio por formulario I1 - significativo
select 6*1915/60 --191 horas para 1915 casos de REp7


/*
Información de EAH2011
Réplica 7:
457 hogares.
1915 población

Réplica 8:
432 hogares.
1014 población

Total
889 hogares
select 7*889/60 as horas_hombre
-103 horas hombre

2929 población
select 4*2929/60 as horas_hombre
-195 horas hombre

-300 horas hombre aprox



*/






select fre_for, fre_mom
from encu.v_frecuencia_de_ingreso 
where fre_mat ='' and fre_for='I1'
AND fre_mom<'2012-07-27 11:00:00.000' or fre_mom>'2012-07-28 00:00:00.000'
--ORDER BY fre_MOM

select pla_estado_carga,pla_rol,* from encu.plana_tem_ where pla_per='321' and pla_rol=2;

update encu.plana_tem_  set pla_estado_carga=2 where pla_per='321' and pla_estado_carga=1
