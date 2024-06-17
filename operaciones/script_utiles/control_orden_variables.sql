--consulta preguntas con mas de una variable, donde hay 1 o mas que no tiene orden distinto
--parametros: POPE operativo
set search_path= encu, dbo, comun;
select  p.pre_for,p.pre_pre, count(*), count(var_orden),count(distinct var_orden)
from preguntas p join bloques b on pre_ope=blo_ope and pre_for=blo_for and pre_mat=blo_mat and pre_blo=blo_blo
  join variables on var_ope=pre_ope and var_for=pre_for and var_mat=pre_mat and var_pre=pre_pre
where pre_ope='VOPE' 
group by 1,2
having count(*)>1 and count(*)!=count(distinct var_orden)
order by  1,2;
