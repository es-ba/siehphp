--Para las etois
--recuperar la infomación de los operativos correspondientes y generar backups de esta información 
set role tedede_php;

CREATE SCHEMA IF NOT EXISTS operaciones_supervision
    AUTHORIZATION tedede_php;
select * into operaciones_supervision.platem_etoi262
  from encu.plana_tem_
order by pla_enc;

set role tedede_php;
CREATE SCHEMA IF NOT EXISTS operaciones_supervision
    AUTHORIZATION tedede_php;
select * into operaciones_supervision.platem_eah2026
  from encu.plana_tem_
order by pla_enc;
--restaurar backups en el operativo actual

--ejecutar las siguientes funciones 

set search_path=encu;
select encu.seleccionar_supervision_operativos_anteriores(
    'operaciones_supervision' ,
    'platem_etoi262',
    'platem_eah2026',
    3) ;
 --596 casos   
set search_path=encu;
select encu.actualizar_supervision_operativos_anteriores(
    'operaciones_supervision' ,
    'platem_etoi262',
    'platem_eah2026',
    3) ;  
--596 casos

 --como control la actualización debe dar la misma cantidad que la selección.
    
    
   