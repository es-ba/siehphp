--agregado de variables_i1 
select *
from encu.respuestas
where res_ope=dbo.ope_actual() and res_for='I1' and res_var in ('dd2', 'pd');

select  * --pla_e13,pla_e12
from encu.plana_i1_

select var_var
from encu.variables
join encu.var_orden on varord_ope=var_ope and varord_var=var_var
where var_for='I1' and var_pre in (select pre_pre from encu.preguntas where pre_blo='BD' )
order by  varord_orden_total;

ALTER TABLE encu.plana_i1_ ADD COLUMN pla_dd1  integer ;
ALTER TABLE encu.plana_i1_ ADD COLUMN pla_dd2  integer ;
ALTER TABLE encu.plana_i1_ ADD COLUMN pla_dd3  integer ;
ALTER TABLE encu.plana_i1_ ADD COLUMN pla_dd4  integer ;
ALTER TABLE encu.plana_i1_ ADD COLUMN pla_dd5  integer ;
ALTER TABLE encu.plana_i1_ ADD COLUMN pla_dd6  integer ;
ALTER TABLE encu.plana_i1_ ADD COLUMN pla_dd7  integer ;
ALTER TABLE encu.plana_i1_ ADD COLUMN pla_dd8  integer ;
ALTER TABLE encu.plana_i1_ ADD COLUMN pla_dd9  integer ;
ALTER TABLE encu.plana_i1_ ADD COLUMN pla_dd10 integer;
ALTER TABLE encu.plana_i1_ ADD COLUMN pla_dd11 integer;
ALTER TABLE encu.plana_i1_ ADD COLUMN pla_dd12 integer;
ALTER TABLE encu.plana_i1_ ADD COLUMN pla_dd13 integer;
ALTER TABLE encu.plana_i1_ ADD COLUMN pla_dd14 integer;
ALTER TABLE encu.plana_i1_ ADD COLUMN pla_dd15 integer;
ALTER TABLE encu.plana_i1_ ADD COLUMN pla_pd   integer;

