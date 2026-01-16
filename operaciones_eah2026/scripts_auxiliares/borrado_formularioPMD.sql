set role tedede_php;
select * from encu.respuestas where res_ope='eah2026' and res_for='PMD';
select * from encu.claves where  cla_ope='eah2026' and cla_for='PMD';
select var_var, var_conopc into operaciones.varconop_PMD from encu.variables where var_ope='eah2026' and var_for='PMD';--114 
select  conopc_ope,conopc_conopc into operaciones.conopc_PMD from encu.con_opc where conopc_ope='eah2026' 
    and conopc_conopc in (select  var_conopc  from encu.variables where var_ope='eah2026' and var_for='PMD' ) ;
    --12
select opc_ope,opc_opc,opc_conopc into operaciones.opcopc_PMD from encu.opciones where opc_ope='eah2026' 
and opc_conopc in ( 
    select  conopc_conopc from encu.con_opc where conopc_ope='eah2026' 
    and conopc_conopc in (select  var_conopc  from encu.variables where var_ope='eah2026' and var_for='PMD' ) 

) ;
--33 filas
select * from encu.saltos    where sal_ope='eah2026'
  and sal_var in (select  var_var  from encu.variables where var_ope='eah2026' and var_for='PMD' ) ; -- 32 
select * from encu.variables where var_ope='eah2026' and var_for='PMD'; --114
select * from encu.preguntas where pre_ope='eah2026' and pre_for='PMD'; --87
select * from encu.filtros   where fil_ope='eah2026' and fil_for='PMD';--8
select * from encu.bloques   where blo_ope='eah2026' and blo_for='PMD';--1
--select * from encu.opciones  where opc_ope='eah2026' /*and opc_for='PMD'*/;
select * from encu.matrices where mat_ope='eah2026' and mat_for='PMD'; --1
select * from encu.formularios where for_ope='eah2026' and for_for='PMD'; --1



delete  from encu.respuestas where res_ope='eah2026' and res_for='PMD';--0 casos
delete  from encu.claves where  cla_ope='eah2026' and cla_for='PMD'; --0 casos
delete  from encu.saltos    where sal_ope='eah2026'
  and sal_var in (select  var_var  from encu.variables where var_ope='eah2026' and var_for='PMD' ) ;   --32 
delete from encu.variables where var_ope='eah2026' and var_for='PMD';  
--114
delete from encu.preguntas where pre_ope='eah2026' and pre_for='PMD';
--87
delete from encu.filtros   where fil_ope='eah2026' and fil_for='PMD';
--8
delete from encu.bloques   where blo_ope='eah2026' and blo_for='PMD';
--1
delete from encu.matrices where mat_ope='eah2026' and mat_for='PMD';
--1
delete from encu.formularios where for_ope='eah2026' and for_for='PMD';
--1
select  conopc_ope,conopc_conopc from operaciones.conopc_PMD
 where conopc_ope='eah2026' 
 and conopc_conopc in (select  var_conopc  from encu.variables where var_ope='eah2026' )
--"eah2026"    "si_no"
--"eah2026"    "algunos"
--"eah2026"    "entrea"
--"eah2026"    "notiene"
select distinct var_conopc from encu.variables
 where var_ope='eah2026' 
 and var_conopc  in (select  conopc_conopc  from operaciones.conopc_PMD where conopc_ope='eah2026' );
--"entrea"
--"si_no"
--"algunos"
--"notiene"
select  conopc_ope,conopc_conopc from operaciones.conopc_PMD
 where conopc_ope='eah2026' 
 and conopc_conopc not in ('entrea', 'si_no','algunos','notiene') ;
 --8 casos
 select var_for, var_var, var_pre,var_conopc
 from encu.variables where var_conopc in ('entrea', 'si_no','algunos','notiene');
--24 casos
delete
from encu.opciones
where opc_ope='eah2026' and opc_conopc in (
 select  conopc_conopc from operaciones.conopc_PMD
       where conopc_ope='eah2026' 
      and conopc_conopc not in ('entrea', 'si_no','algunos','notiene'));
      --24 filas

delete from encu.con_opc
 where  conopc_ope='eah2026' 
 and conopc_conopc in (
     select  conopc_conopc from operaciones.conopc_PMD
       where conopc_ope='eah2026' 
      and conopc_conopc not in ('entrea', 'si_no','algunos','notiene')) ;
--8 casos

---bloque de SUPERVISION SPPMD---
delete /*select * */from encu.saltos   where sal_ope='eah2026'
  and sal_var in 
  (select  var_var  from encu.variables 
       where var_ope='eah2026' and var_pre in 
     (select pre_pre from encu.preguntas where pre_ope='eah2026' and pre_blo='SPPMD' )); 
--2 filas 
delete /*select var_for,var_pre,var_var,var_conopc */from encu.variables where var_ope='eah2026' and var_pre in 
  (select pre_pre from encu.preguntas where pre_ope='eah2026' and pre_blo='SPPMD');  
"SUP"    "SPPMD86"    "sppmd86"    "algunos"
"SUP"    "SPPMD87"    "sppmd87_esp"    
"SUP"    "SPPMD87"    "sppmd87"    "notiene"
"SUP"    "SPPMD1"    "sppmd1"    "si_no"
"SUP"    "SPPMD2"    "sppmd2"    
--5 filas
delete /*select* */ from encu.preguntas where pre_ope='eah2026' and pre_blo='SPPMD'; 
--4 filas
select * from encu.filtros   where fil_ope='eah2026' and fil_blo='SPPMD';
--0 no hay casos
delete /*select **/ from encu.bloques   where blo_ope='eah2026' and blo_blo='SPPMD';
--1
delete 
--select *
  from encu.opciones
where opc_ope='eah2026' and opc_conopc in ('algunos','notiene');
--5
delete 
--select *
from encu.con_opc
 where  conopc_ope='eah2026' 
 and conopc_conopc in ('algunos','notiene');
 --2 filas
 alter table encu.plana_sup_ drop column pla_sppmd1;
 alter table encu.plana_sup_ drop column pla_sppmd2;
 alter table encu.plana_sup_ drop column pla_sppmd86;
 alter table encu.plana_sup_ drop column pla_sppmd87;
 alter table encu.plana_sup_ drop column pla_sppmd87_esp;