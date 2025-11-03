set role tedede_php;
CREATE OR REPLACE FUNCTION encu.aux_importar_canastas_fun(
    )
    RETURNS text
    LANGUAGE 'plpgsql'
    VOLATILE 
    
AS $BODY$
declare
  vCursor record;
  vVar text;
  vVarProm text;
  vConexion text;
begin
  insert into  encu.valcan (pla_ope, pla_tlg) (select dbo.ope_actual(),1); 
  
  for vCursor in 
     select  periodo, agrupacion, grupo, valorgruredondeado, valorgrupromedioredondeado
       from  operaciones.tranf_data_xxxx_25 /* nos pasan una tabla auxiliar desde ipcba */
       where periodo in (select par_periodo_ipcba from encu.parametros)
  loop 
     RAISE notice 'SENTENCIA %', vCursor.periodo;
     select var_var, var_promedio into strict vVar, vVarProm
       from encu.import_info 
       where operativo='val_can'
         and agrupacion=vCursor.agrupacion
         and grupo=vCursor.grupo;
     RAISE notice 'SENTENCIA Vvar %', vVar;
     execute ('update encu.valcan set (pla_'||vVar||',pla_'||vVarProm||') = ($2,$3) where pla_ope = $1') using dbo.ope_actual(), vCursor.valorgruredondeado, vCursor.valorgrupromedioredondeado ;
     end loop;
  return 'ok';
end;
$BODY$;

ALTER FUNCTION encu.aux_importar_canastas_fun()
    OWNER TO tedede_php;
select encu.aux_importar_canastas_fun();      