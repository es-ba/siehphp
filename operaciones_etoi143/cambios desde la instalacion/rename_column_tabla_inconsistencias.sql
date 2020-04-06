alter table encu.inconsistencias rename column con_falsos_positivos to inc_falsos_positivos;
alter table encu.inconsistencias rename column pla_bolsa to inc_bolsa;
alter table encu.inconsistencias rename column pla_estado to inc_estado;


--select * from encu.respuestas where res_valor like '%olsa%'

--select * from encu.plana_sm1_p 
alter table encu.plana_sm1_p rename column pla_p2 to pla_sexo;
alter table encu.plana_sm1_p rename column pla_p3a to pla_f_nac_o;
alter table encu.plana_sm1_p rename column pla_p3b to pla_edad;

update encu.variables set var_var= 'sexo' where var_var ='p2';
update encu.variables set var_var= 'f_nac_o' where var_var ='p3a';
update encu.variables set var_var= 'edad' where var_var ='p3b';

