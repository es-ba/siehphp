-- cargar plana_tem_  de prueba a partir de la tem en  base de test de la eah2026 --

set role tedede_php;
set search_path=encu;
--restauro  backup desde operaciones sieh

select * from encu.tem; --9570 CASOS
select * from encu.plana_tem_; --0 CASOS

/* control*/
select count(*), tem_participacion, tem_dominio, tem_rotaci_n_etoi, tem_rotaci_n_eah
from encu.tem
group by tem_participacion, tem_dominio, tem_rotaci_n_etoi, tem_rotaci_n_eah
order by 2,4,5;
--1000    1    3    2    1
--2040    1    3    4    3
--250    1    5    4    6
--200    1    5    6    1
--1000    2    3    1    1
--2040    2    3    4    2
--1000    3    3    3    1
--2040    3    3    4    4

--RECORDAR deshabilitar sentencia 
--insert into his.his_respuestas (hisres_ope, hisres_for, hisres_mat, hisres_enc, hisres_hog, hisres_mie, hisres_exm, hisres_var, hisres_valor, hisres_valesp, hisres_valor_con_error, hisres_estado, hisres_anotaciones_marginales, hisres_tlg)
  --  values (new.res_ope, new.res_for, new.res_mat, new.res_enc, new.res_hog, new.res_mie, new.res_exm, new.res_var, new.res_valor, new.res_valesp, new.res_valor_con_error, new.res_estado, new.res_anotaciones_marginales, new.res_tlg);
--en trigger respuestas_a_planas de Respuestas referenciado en el bloque  his-.

/* deshabilito constraint h4_mues  PORQUE YA NO VIENE MAS EN LA MUESTRA*/
-- Check: encu."H4_MUES DEBE TENER VALOR PARA DOMINIOS 3,4"

ALTER TABLE encu.plana_tem_ DROP CONSTRAINT "H4_MUES DEBE TENER VALOR PARA DOMINIOS 3,4";

--Insert en claves para que también se inserte en la plana_tem_ -- casos
insert into encu.claves (cla_ope, cla_for, cla_mat, cla_enc, 
                         cla_hog, cla_mie, cla_exm, cla_tlg)
    (select dbo.ope_actual(), 'TEM','', tem_enc, 0, 0, 0, 1 
        from encu.tem
        --where tem_dominio=3
        order by tem_enc 
    );   
--INSERT 0 9570

--controles
select count(*) -- 9570 casos 
from encu.claves;
select count(*) -- 9570 casos 
from encu.plana_tem_;  
--si faltan los triggers AGREGAR TRIGGERS DE CAMBIO DE ESTADOS
--actualizo estados 
update encu.respuestas
  set res_valor=null
  where res_ope=dbo.ope_actual() and res_for='TEM' and res_mat='' and res_var='estado'  and res_enc in (select pla_enc from encu.plana_tem_ /*where pla_dominio=3*/);
--UPDATE 9570

select res_valor, res_var,count(*)
from encu.respuestas
where res_var='estado'
group by 1,2;  
--"19"    "estado"    9120
--"18"    "estado"    450

----RECORDAR HABILITAR sentencia 
--insert into his.his_respuestas (hisres_ope, hisres_for, hisres_mat, hisres_enc, hisres_hog, hisres_mie, hisres_exm, hisres_var, hisres_valor, hisres_valesp, hisres_valor_con_error, hisres_estado, hisres_anotaciones_marginales, hisres_tlg)
  --  values (new.res_ope, new.res_for, new.res_mat, new.res_enc, new.res_hog, new.res_mie, new.res_exm, new.res_var, new.res_valor, new.res_valesp, new.res_valor_con_error, new.res_estado, new.res_anotaciones_marginales, new.res_tlg);
--en trigger respuestas_a_planas de his-.

-------------------
--controles auxiliares

select tem_enc, tem_ccodigo, tem_participacion
from encu.tem
where tem_ccodigo is null and tem_dominio=3
--0 casos
--------------------------

--controles auxiliares 
select tem_enc,tem_semana, tem_participacion, tem_ccodigo, tem_cnombre, tem_codpos,tem_hn
from encu.tem
where tem_codpos is null and tem_dominio=3
-- 0 casos
