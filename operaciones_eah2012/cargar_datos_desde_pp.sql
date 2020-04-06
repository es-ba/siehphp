-- seleccionamos 480 encuestas de la muestra actual para pegarles las de la pp
select cla_enc 
--into encu.cla_enc_2012 
from encu.claves group by cla_enc order by cla_enc limit 480;

-- creamos una tabla de traduccion donde ponemos los pares enc_actua-enc_pp
select cla_enc, 0 as enc_2012 
--into encu.cla_pares 
from encu.claves_pp2012 where cla_enc < 900000 group by cla_enc order by cla_enc;

-- a cada una de las tablas anteriores les agregamos un campo tipo serial
-- completamos el par:
update encu.cla_pares set enc_2012 = cla_enc_2012.cla_enc
 from encu.cla_enc_2012
 where cla_pares.id = cla_enc_2012.id;

select * from encu.cla_pares

-- en claves_pp2012 modificar cla_enc segun los pares de cla_pares
update encu.claves_pp2012 set cla_enc = enc_2012
 from encu.cla_pares
 where claves_pp2012.cla_enc = cla_pares.cla_enc

select * from encu.claves_pp2012 order by cla_enc;

-- borrar de planas, respuestas y claves las 480 encuestas 
-- salvo de la tem
select * from encu.plana_i1_ where pla_enc in(select cla_enc from encu.claves_pp2012)
select * from encu.plana_s1_p where pla_enc in(select cla_enc from encu.claves_pp2012)
select * from encu.plana_a1_x where pla_enc in(select cla_enc from encu.claves_pp2012)
select * from encu.plana_a1_ where pla_enc in(select cla_enc from encu.claves_pp2012) and pla_enc < 900000
select * from encu.plana_s1_ where pla_enc in(select cla_enc from encu.claves_pp2012) and pla_enc < 900000
select * from encu.plana_tem_ where pla_enc in(select cla_enc from encu.claves_pp2012)

select * from encu.claves where cla_enc in (select cla_enc from encu.claves_pp2012) and cla_for<>'TEM' and cla_ope='eah2012'
select * from encu.respuestas where res_enc in (select cla_enc from encu.claves_pp2012) and res_for<>'TEM' and res_ope='eah2012'

select * from encu.respuestas where res_enc in(select cla_enc from encu.claves_pp2012) and res_for<>'TEM' and res_ope='eah2012'
--delete from encu.respuestas where res_enc in(select cla_enc from encu.claves_pp2012) and res_for<>'TEM' and res_ope='eah2012'
select * from encu.claves where cla_enc in(select cla_enc from encu.claves_pp2012) and cla_for<>'TEM' and cla_ope='eah2012'
--delete from encu.claves where cla_enc in(select cla_enc from encu.claves_pp2012) and cla_for<>'TEM' and cla_ope='eah2012'
select * from encu.plana_a1_ where pla_enc in(select cla_enc from encu.claves_pp2012)
--delete from encu.plana_a1_ where pla_enc in(select cla_enc from encu.claves_pp2012)
select * from encu.plana_a1_x where pla_enc in(select cla_enc from encu.claves_pp2012)
--delete from encu.plana_a1_x where pla_enc in(select cla_enc from encu.claves_pp2012)
select * from encu.plana_i1_ where pla_enc in(select cla_enc from encu.claves_pp2012)
--delete from encu.plana_i1_ where pla_enc in(select cla_enc from encu.claves_pp2012)
select * from encu.plana_s1_ where pla_enc in(select cla_enc from encu.claves_pp2012)
--delete from encu.plana_s1_ where pla_enc in(select cla_enc from encu.claves_pp2012)
select * from encu.plana_s1_p where pla_enc in(select cla_enc from encu.claves_pp2012)
--delete from encu.plana_s1_p where pla_enc in(select cla_enc from encu.claves_pp2012)

-- insertamos claves_pp2012 en claves
INSERT INTO encu.claves(
            cla_ope, cla_for, cla_mat, cla_enc, cla_hog, cla_mie, cla_exm, 
            cla_aux_es_enc, cla_aux_es_hog, cla_aux_es_mie, cla_aux_es_exm, 
            cla_ultimo_coloreo_tlg, cla_tlg)
select 'eah2012' as cla_ope, cla_for, cla_mat, cla_enc, cla_hog, cla_mie, cla_exm, 
            cla_aux_es_enc, cla_aux_es_hog, cla_aux_es_mie, cla_aux_es_exm, 
            cla_ultimo_coloreo_tlg, 1 from encu.claves_pp2012 where cla_for<>'TEM' and cla_ope='pp2012';

-- en respuestas_pp2012 modificar res_enc segun los pares de cla_pares
update encu.respuestas_pp2012 set res_enc = enc_2012
 from encu.cla_pares
 where respuestas_pp2012.res_enc = cla_pares.cla_enc

-- updatear respuestas con los datos de respuestas_pp2012
select * from encu.respuestas limit 1000;
select * from encu.respuestas where res_valor is not null and res_ope='eah2012' limit 1000;
select * from encu.respuestas_pp2012 limit 1000;
update encu.respuestas set res_valor=respuestas_pp2012.res_valor , res_valesp=respuestas_pp2012.res_valesp , res_valor_con_error=respuestas_pp2012.res_valor_con_error , 
       res_estado=respuestas_pp2012.res_estado , res_anotaciones_marginales=respuestas_pp2012.res_anotaciones_marginales
from encu.respuestas_pp2012
where respuestas.res_ope='eah2012' and respuestas_pp2012.res_ope='pp2012' and respuestas.res_for=respuestas_pp2012.res_for and respuestas.res_mat=respuestas_pp2012.res_mat and 
      respuestas.res_enc=respuestas_pp2012.res_enc and respuestas.res_hog=respuestas_pp2012.res_hog and
      respuestas.res_mie=respuestas_pp2012.res_mie and respuestas.res_exm=respuestas_pp2012.res_exm and respuestas.res_var=respuestas_pp2012.res_var;

