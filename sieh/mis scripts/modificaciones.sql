-- DROP FUNCTION encu.his_inconsistencias_upd_trg();

set search_path = rrhh, comun, public;

insert into http_user_agent (httpua_texto) select 'odbc' where not exists (select 1 from http_user_agent where httpua_texto='odbc');
CREATE OR REPLACE FUNCTION http_ua() RETURNS integer
  language sql SECURITY DEFINER
as $sql$
  select httpua_httpua
    from http_user_agent 
    where httpua_texto='odbc';
$sql$;

select http_ua();

/*
alter table sesiones add column ses_tipo text not null default 'php';
alter table sesiones add constraint "ses_tipo es interna, odbc o php" check (ses_tipo in ('interna','odbc','php'));
*/

set application_name = 'i99 vojeda';

CREATE OR REPLACE FUNCTION obtener_sesion() RETURNS bigint
  language plpgsql SECURITY DEFINER
as 
$body$
<<local>>
declare
  usuario text;
  sesion sesiones.ses_ses%type;
  tipo text;
  remote_addr text;
  application_name text:=current_setting('application_name');
begin
  local.usuario:=session_user;
  if (local.usuario like '%_owner' or local.usuario like '%_php' or true) and local.application_name like 'i% %' then
    local.usuario:=split_part(local.application_name,' ',2);
    local.tipo:='php';
    local.remote_addr:=split_part(local.application_name,' ',1);
  else
    local.tipo:='odbc';
    local.remote_addr:=inet_client_addr();
  end if;
  select ses_ses into local.sesion
    from sesiones
    where ses_usu=local.usuario
      and ses_tipo=local.tipo
      and ses_activa
      and current_timestamp<ses_momento + interval '1 day' -- no se venció
    order by ses_ses desc
    limit 1;
  if local.sesion is null then
    insert into sesiones (ses_usu, ses_momento, ses_activa, ses_httpua, ses_remote_addr  ,ses_borro_localstorage,ses_phpsessid) 
      values (local.usuario, current_timestamp, true      , http_ua() , local.remote_addr,false                 ,'N/A'        )
      returning ses_ses into local.sesion;
  end if;
  return local.sesion;
end;
$body$;

select obtener_sesion();

CREATE OR REPLACE FUNCTION obtener_tlg() RETURNS bigint
  language plpgsql SECURITY DEFINER
as 
$body$
<<local>>
declare
  sesion sesiones.ses_ses%type;
  tiempo_commit timestamp;
  tiempo_reloj timestamp;
  tlg tiempo_logico.tlg_tlg%type;
begin
  local.sesion:=obtener_sesion();
  local.tiempo_commit:=current_timestamp;
  local.tiempo_reloj:=clock_timestamp();
  select tlg_tlg into local.tlg
    from tiempo_logico
    where tlg_momento=local.tiempo_commit
      and tlg_momento_finalizada=local.tiempo_reloj
    limit 1;
  if local.tlg is null then
    insert into tiempo_logico (tlg_ses, tlg_momento, tlg_momento_finalizada) 
      values (local.sesion, local.tiempo_commit, local.tiempo_reloj)
      returning tlg_tlg into local.tlg;
  end if;
  return local.tlg;
end;
$body$;

select obtener_tlg();

CREATE OR REPLACE FUNCTION rrhh.his_trg()
  RETURNS trigger SECURITY DEFINER AS
$BODY$
<<local>>
DECLARE	
  todo_lo_nuevo json;
  todo_lo_viejo json;
  elemento record;
  valor_viejo text;
  tlg bigint:=obtener_tlg();
  operacion text;
  valores_pk text;
  json_para_pk json;
  nombres_pk text[];
  nombre_pk text;
  json_separador_pk text='';
  json_valores_pk text='{';
  cantidad_campos_pk integer:=0;
  ses bigint;
BEGIN
  local.ses:=obtener_sesion();
  if TG_OP='INSERT' then
    local.json_para_pk:=row_to_json(new.*);
  else
    local.json_para_pk:=row_to_json(old.*);
  end if;
  local.nombres_pk:=string_to_array(TG_ARGV[0],',');
  foreach local.nombre_pk in array local.nombres_pk loop
    local.json_valores_pk:=local.json_valores_pk || local.json_separador_pk || to_json(local.nombre_pk)::text||':'|| to_json(json_para_pk->local.nombre_pk)::text;
    local.json_separador_pk:=',';
    local.valores_pk:=json_para_pk->>local.nombre_pk;
    local.cantidad_campos_pk:=local.cantidad_campos_pk+1;
  end loop;
  if local.cantidad_campos_pk>1 then
    local.json_valores_pk:=json_valores_pk||'}';
    local.valores_pk:=local.json_valores_pk;
  end if;
  if TG_OP='UPDATE' or TG_OP='INSERT' then
    local.todo_lo_nuevo:=row_to_json(new.*);
    if TG_OP='INSERT' then
      local.operacion:='I';
      local.todo_lo_viejo:='{}'::json;
    else
      local.operacion:='U';
      local.todo_lo_viejo:=row_to_json(old.*);
    end if;
    for local.elemento in select * from json_each_text(local.todo_lo_nuevo) loop
      local.valor_viejo:=local.todo_lo_viejo->>local.elemento.key;
      if local.elemento.value is distinct from local.valor_viejo then
        insert into his.modificaciones
          (mdf_tabla, mdf_campo, mdf_operacion, mdf_pk, mdf_actual, mdf_anterior, mdf_tlg)
          values (TG_TABLE_NAME, local.elemento.key, local.operacion, local.valores_pk, local.elemento.value, local.valor_viejo, local.tlg);
      end if;
    end loop;
    return new;
  elsif TG_OP='DELETE' then
     insert into his.modificaciones
                 (mdf_tabla    , mdf_campo, mdf_operacion, mdf_pk , mdf_anterior      , mdf_tlg  )
          values (TG_TABLE_NAME, '*'      , 'D'          , local.valores_pk, row_to_json(old.*), local.tlg);
    return old;
  else
    raise exception 'Falta el caso para TG_OP=% para la tabla %',TG_OP,TG_TABLE_NAME;
  end if;
END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION rrhh.his_trg()
  OWNER TO tedede_php;

DROP TRIGGER IF EXISTS personas_his_trg ON rrhh.personas;
-- /*
CREATE TRIGGER personas_his_trg
  BEFORE INSERT OR UPDATE OR DELETE
  ON rrhh.personas
  FOR EACH ROW
  EXECUTE PROCEDURE rrhh.his_trg('dni');

DROP TRIGGER IF EXISTS operativos_his_trg ON rrhh.operativos;
CREATE TRIGGER operativos_his_trg
  BEFORE INSERT OR UPDATE OR DELETE
  ON rrhh.operativos
  FOR EACH ROW
  EXECUTE PROCEDURE rrhh.his_trg('operativo,anio_op,persona_dni,puesto_final');
--*/

-- delete from his.modificaciones;

update rrhh.personas
  set barrio='Monserrat'
  where dni=3727334;

update rrhh.personas
  set barrio='San Nicolás'
  where dni=3727334;

select * from rrhh.operativos limit 1;

update rrhh.operativos set continuo=continuo::integer+1
  where operativo='1ºET ENE' and anio_op=2008 and persona_dni=7704371;
    
select * from rrhh.personas limit 2;
select * from rrhh.tiempo_logico;
select * from his.modificaciones;


update rrhh.personas
  set mail='este2@hotmail.com'
  where dni=3727334;

insert into rrhh.personas (dni,nombre,barrio) values (7,'José','Barrios Esqueloto');
update rrhh.personas set dni=8 where dni=7; 
delete from rrhh.personas where dni=8;

select * from rrhh.tiempo_logico;
select * from his.modificaciones;

-- 