/* CONTROLES
select *
 from encu.variables
 where var_pre in (select pre_pre from encu.preguntas where pre_ope='ut2016' and pre_blo='DIARIO_DE_ACTIVIDADES' and pre_pre <>'MODULO_1');--191
select *
 from encu.preguntas
 where pre_ope='ut2016' and pre_blo='DIARIO_DE_ACTIVIDADES' and pre_pre <> 'MODULO_1'; --143 filas
select *
 from encu.bloques
 where blo_ope='ut2016' and blo_blo='DIARIO_DE_ACTIVIDADES';
select *
 from encu.saltos
 where sal_ope='ut2016' and sal_var in 
  (
  select var_var
   from encu.variables
   where var_pre in (select pre_pre from encu.preguntas where pre_ope='ut2016' and pre_blo='DIARIO_DE_ACTIVIDADES')
 );

select *
 from encu.filtros
 where fil_for='I1' and fil_blo='DIARIO_DE_ACTIVIDADES'; --NO HAY CASOS
*/
--BORRADO
delete from encu.variables
 where var_var in (
  select var_var
   from encu.variables
   where var_pre in (select pre_pre from encu.preguntas where pre_ope='ut2016' and pre_blo='DIARIO_DE_ACTIVIDADES' and pre_pre <>'MODULO_1'));--191 FILAS
delete from encu.preguntas
 where pre_pre in (   
  select pre_pre
   from encu.preguntas
   where pre_ope='ut2016' and pre_blo='DIARIO_DE_ACTIVIDADES' and pre_pre <> 'MODULO_1'); --143 filas