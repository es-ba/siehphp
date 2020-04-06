##FUN
actualizar_monitoreo_viv_ant_ope
##ESQ
encu
##PARA
produccion
##PUBLICA
no
##PAR

##TIPO_DEVUELTO
void
##TIPO_FUNCION
plpgsql
##DESCRIPCION
Actualizar tabla reflejo de la vista encu.monitoreo_viv_condact del operativo etoi anterior

##CUERPO
-- DROP FUNCTION encu.actualizar_monitoreo_viv_ant_ope();
CREATE OR REPLACE FUNCTION encu.actualizar_monitoreo_viv_ant_ope()
  returns void AS
$BODY$
DECLARE
v_ope_actual text;
v_ope_ant    text;
v_res   text;

BEGIN
    v_ope_actual=dbo.ope_actual();
    select ope_ope_anterior into v_ope_ant from encu.operativos
        where ope_ope=v_ope_actual;
    if substr(v_ope_ant,1,4)<>'etoi' then
       v_ope_ant='etoi'||substr(v_ope_ant,6,2)||'4';
    end if;
    raise notice 'nombre operativo anterior:%',v_ope_ant;
    select dblink_connect('etoi_ant_conn' , 'dbname='||v_ope_ant||'_produc_db user=tedede_php password=laclave') into v_res;

    drop table if exists encu.monitoreo_viv_ant_ope;
    CREATE TABLE encu.monitoreo_viv_ant_ope AS
        SELECT *
        FROM dblink('etoi_ant_conn', 'select * from encu.monitoreo_viv_condact')
        AS (pla_enc integer, pla_comuna integer, pla_zona text, pla_participacion integer, pla_estado integer, pla_rea integer, pla_norea integer,
              h integer, canthog integer, p integer, v integer, m integer,
              o integer, ov integer, om integer, d integer, dv integer, dm integer, i integer, iv integer, im integer); 
    ALTER TABLE encu.monitoreo_viv_ant_ope
        OWNER TO tedede_php;
    ALTER TABLE encu.monitoreo_viv_ant_ope
        ADD CONSTRAINT plana_monit_viv_ant_ope_pkey PRIMARY KEY(pla_enc);
    SELECT dblink_disconnect('etoi_ant_conn')into v_res;  
END;
$BODY$
  LANGUAGE plpgsql ;
ALTER FUNCTION encu.actualizar_monitoreo_viv_ant_ope()
  OWNER TO tedede_php;