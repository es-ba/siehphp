-- Table: encu.valcan

-- DROP TABLE encu.valcan;
/*
CREATE TABLE encu.valcan
(
  pla_ope character varying(50) NOT NULL,
  pla_ca_p numeric,
  pla_alquiler_p numeric,
  pla_gastoexpensas_p numeric,
  pla_gas_p numeric,
  pla_electricidad_p numeric,
  pla_agua_p numeric,
  pla_jardin_p numeric,
  pla_preescyprim_p numeric,
  pla_secundaria_p numeric,
  pla_artytextos_p numeric,
  pla_transpu_p numeric,
  pla_comunicaciones_p numeric,
  pla_limpieza_p numeric,
  pla_esparcimiento_p numeric,
  pla_bieneserv_p numeric,
  pla_indadultos_p numeric,
  pla_indninios_p numeric,
  pla_salud_p numeric,
  pla_equipamiento_p numeric,
  pla_ca_c numeric,
  pla_alquiler_c numeric,
  pla_gastoexpensas_c numeric,
  pla_gas_c numeric,
  pla_electricidad_c numeric,
  pla_agua_c numeric,
  pla_jardin_c numeric,
  pla_preescyprim_c numeric,
  pla_secundaria_c numeric,
  pla_artytextos_c numeric,
  pla_transpu_c numeric,
  pla_comunicaciones_c numeric,
  pla_limpieza_c numeric,
  pla_esparcimiento_c numeric,
  pla_bieneserv_c numeric,
  pla_indadultos_c numeric,
  pla_indninios_c numeric,
  pla_salud_c numeric,
  pla_equipamiento_c numeric,
  pla_tlg bigint NOT NULL,
  pla_axesorios_c numeric,
  pla_servind_c numeric,
  CONSTRAINT valcan_pkey PRIMARY KEY (pla_ope),
  CONSTRAINT valcan_operativos_fk FOREIGN KEY (pla_ope)
      REFERENCES encu.operativos (ope_ope) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT valcan_tiempo_logico_fk FOREIGN KEY (pla_tlg)
      REFERENCES encu.tiempo_logico (tlg_tlg) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE encu.valcan
  OWNER TO tedede_php;
GRANT ALL ON TABLE encu.valcan TO tedede_php;
GRANT SELECT ON TABLE encu.valcan TO etoi162_ro;

*/

-- CREATE EXTENSION dblink; --Si el módulo dblink no esta cargado en la base ejecutar esta sentencia
-- select dblink_connect('ipcba_conn' , 'host=10.32.6.20 port=5435 dbname=cvp_db user=sieh password=laclave'); --controlar que el puerto sea el correcto
--nueva
create or replace function encu.importar_canastas_fun() returns text
  language plpgsql
as
$BODY$
declare
  vCursor record;
  vVar text;
  vVarProm text;
  vConexion text;
begin
  select dblink_connect('ipcba_conn' , 'host=10.32.3.38 port=5432 dbname=cvp_db user=sieh password=laclave') INTO vConexion;
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

ALTER FUNCTION encu.importar_canastas_fun()
  OWNER TO tedede_php; 
  
--------------------------------------  
--select encu.importar_canastas_fun();

/*
create or replace function importar_canastas_fun_ant() returns text
  language plpgsql
as
$BODY$
declare
  vPeriodo text;
  vCursor record;
  vVar text;
begin
  select par_periodo_ipcba into strict vPeriodo from encu.parametros;
  -- select dblink_close('ipcba_conn');
  RAISE notice 'SENTENCIA %', 'select * from cvp.transf_data where periodo=$$'||vPeriodo||'$$'; 
  SELECT dblink_open('ipcba_conn', 'cur_can',
    'select * from cvp.transf_data where periodo=$$'||vPeriodo||'$$'); 
  for vCursor in select * from dblink_fetch('ipcba_conn', 'cur_can', 9999) as (operativo text, agrupacion text, grupo text) loop
    select var_var into strict vVar
      from encu.import_info 
      where operativo='val_can'
        and agrupacion=vCursor.agrupacion
        and grupo=vCursor.grupo;
    execute ('update encu.valcan set "'||vVar||'" = $1 where operativo = $2') using dbo.ope_actual(), vCursor.valorgruredondeado;
  end loop;
  return 'ok';
end;
$BODY$;

select importar_canastas_fun_ant();
*/
