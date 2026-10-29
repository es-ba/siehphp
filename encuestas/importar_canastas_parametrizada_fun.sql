CREATE OR REPLACE FUNCTION encu.importar_canastas_fun( p_valor text
    )
    RETURNS text
    LANGUAGE 'plpgsql'
    VOLATILE PARALLEL UNSAFE
AS $BODY$
declare
  vCursor record;
  vVar text;
  vVarProm text;
  vConexion text;
begin
 -- select dblink_connect('ipcba_conn' , 'host=10.35.100.20 port=5432 dbname=ipc_db user=sieh password=xxxxxxxxx') INTO vConexion;
    select dblink_connect('ipcba_conn' , format( 'host=10.35.100.20 port=5432 dbname=ipc_db user=sieh password=%L', p_valor)  )INTO vConexion;
   --select par_periodo_ipcba into strict vPeriodo from encu.parametros;
   --RAISE notice 'SENTENCIA %', 'select * from cvp.transf_data where periodo=$$'||vPeriodo||'$$';   
  insert into  encu.valcan (pla_ope, pla_tlg) (select dbo.ope_actual(),1); 
  select dblink_open('ipcba_conn', 'cur_can',
    'select periodo, agrupacion, grupo, valorgruredondeado, valorgrupromedioredondeado from cvp.transf_data') INTO vConexion;
  for vCursor in 
     select  periodo, agrupacion, grupo, valorgruredondeado, valorgrupromedioredondeado
       from  dblink_fetch('ipcba_conn', 'cur_can', 9999  )as (periodo text, agrupacion text, grupo text, valorgruredondeado numeric, valorgrupromedioredondeado numeric)
       where periodo in (select par_periodo_ipcba from encu.parametros)
  loop 
     --RAISE notice 'SENTENCIA %', vCursor.periodo;
     select var_var, var_promedio into strict vVar, vVarProm
       from encu.import_info 
       where operativo='val_can'
         and agrupacion=vCursor.agrupacion
         and grupo=vCursor.grupo;
     --RAISE notice 'SENTENCIA Vvar %', vVar;
     execute ('update encu.valcan set (pla_'||vVar||',pla_'||vVarProm||') = ($2,$3) where pla_ope = $1') using dbo.ope_actual(), vCursor.valorgruredondeado, vCursor.valorgrupromedioredondeado ;
     end loop;
  select dblink_close('ipcba_conn', 'cur_can') INTO vConexion;
  select dblink_disconnect('ipcba_conn') INTO vConexion;
  return 'ok';
end;
$BODY$;

ALTER FUNCTION encu.importar_canastas_fun(text)
    OWNER TO tedede_php;
    