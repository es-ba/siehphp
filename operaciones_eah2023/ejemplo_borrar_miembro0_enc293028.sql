--Ejemplo
--Borrar I1 de mie 0 de la enc 293028
select * 
from encu.plana_i1_
where pla_enc=293028; --hogar 1 ,miembro 0 
--293028    1    0    0        1    2    2    4                            2    2    4    
select * 
from encu.plana_S1_p
where pla_enc=293028;
--sin casos de miembro 0
select res_for, count(*)
from encu.respuestas
where res_enc=293028 and res_hog=1 and res_mie=0 and res_for='I1'
group by 1;
--"I1"    208

select  distinct res_hog, res_mie, res_for,res_mat,res_var,res_valor
from encu.respuestas
where res_ope=dbo.ope_actual() and res_enc=293028 and res_for='S1' and res_hog=1 and res_mat='P'  ; --s1P ok

select pla_pob_tot,pla_pob_pre,pla_enc,pla_estado
from encu.plana_tem_
where pla_enc=293028;
--3    4    293028    65
--borrado
delete
--select *
from encu.plana_i1_
where  pla_enc=293028 and pla_hog=1 and pla_mie=0;
--1 fila
--select *           
 delete
  from encu.respuestas   
   WHERE res_ope=dbo.ope_actual() and res_enc=293028 and res_for='I1' and res_mat='' 
        and res_hog=1 and res_mie=0;
--208 filas    
--select *           
 delete
  from encu.claves   
   WHERE cla_ope=dbo.ope_actual() and cla_enc=293028 and cla_for='I1' and cla_mat='' 
        and cla_hog=1 and cla_mie=0;
--1 fila    
select * from encu.respuestas
--update encu.respuestas
--  set res_valor=3
  where res_ope=dbo.ope_actual() and res_enc=293028 and res_for='TEM' and res_var='pob_pre' and res_valor='4' ; 
--UPDATE CASO
