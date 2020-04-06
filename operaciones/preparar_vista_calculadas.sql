-- alter table varcal_destinos add column varcaldes_orden integer;

update varcal_destinos set varcaldes_orden = case varcaldes_destino when 'tem' then 1 when 'hog' then 2 else 3 end;

create table ua_planas (
  uapla_ua text,
  uapla_pla text,
  uapla_orden integer,
  uapla_campos_union text,
  uapla_for text,
  uapla_mat text,
  primary key (uapla_ua, uapla_pla)
);

alter table ua_planas add column uapla_for text;
alter table ua_planas add column uapla_mat text;

delete from ua_planas;

insert into ua_planas(uapla_ua, uapla_pla, uapla_orden, uapla_campos_union, uapla_for, uapla_mat) values
  ('mie', 'plana_i1_' , 1, 'enc,hog,mie','I1' ,'' ),
  ('mie', 'plana_s1_p', 2, 'enc,hog,mie','S1' ,'P'),
  ('mie', 'plana_s1_' , 3, 'enc,hog'    ,'S1' ,'' ),
  ('mie', 'plana_a1_' , 4, 'enc,hog'    ,'A1' ,'' ),
  ('mie', 'plana_gh_' , 5, 'enc,hog'    ,'GH' ,'' ),
  ('mie', 'plana_tem_', 6, 'enc'        ,'TEM','' ),
  ('hog', 'plana_s1_' , 3, 'enc,hog'    ,'S1' ,'' ),
  ('hog', 'plana_a1_' , 4, 'enc,hog'    ,'A1' ,'' ),
  ('hog', 'plana_gh_' , 5, 'enc,hog'    ,'GH' ,'' ),
  ('hog', 'plana_tem_', 6, 'enc'        ,'TEM','' ),
  ('enc', 'plana_tem_', 6, 'enc'        ,'TEM','' );

-- Function: encu.permitir_modificacion_variables_calculadas_trg()

-- DROP FUNCTION encu.permitir_modificacion_variables_calculadas_trg();

DROP TRIGGER varcal_controlar_modificacion_varcalopc_trg ON encu.varcal;

ALTER TABLE varcal DISABLE TRIGGER  varcal_controlar_modificacion_varcalopc_trg;

CREATE OR REPLACE FUNCTION encu.permitir_modificacion_variables_calculadas_trg()
  RETURNS trigger AS
$BODY$
DECLARE
    v_usuario   text;
    v_rol       text;
    v_esta_cerrado boolean;
    v_varcal    text;
    v_texto_op  text;
    v_cant_abiertas integer;
    v_var_abiertas  TEXT;
    v_opciones  text;
    v_registro  RECORD;
BEGIN
CASE TG_TABLE_NAME
    WHEN 'varcal' THEN
        SELECT ses_usu, usu_rol  
            INTO v_usuario, v_rol
            FROM encu.tiempo_logico JOIN encu.sesiones ON tlg_ses=ses_ses JOIN encu.usuarios ON usu_usu=ses_usu
            WHERE tlg_tlg=new.varcal_tlg;
        IF OLD.varcal_cerrado IS DISTINCT FROM NEW.varcal_cerrado THEN
            IF NEW.varcal_cerrado=true THEN
                --esta cerrando
                -- tiene que ser de procesamiento o programador
                -- condicion de cerrado: esten cerradas las varibles calculadas que usa
                IF coalesce(v_rol,'') not in ('programador', 'procesamiento') THEN
                    RAISE EXCEPTION 'ERROR Perfil del usuario % no autorizado para realizar el cierre de la variable "%" ',v_usuario, new.varcal_varcal;
                END IF;
                select string_agg( coalesce(varcalopc_expresion_condicion,'') ||' '|| coalesce(varcalopc_expresion_valor,''), ', ' order by varcalopc_ope, varcalopc_varcal, varcalopc_opcion) 
                    into v_opciones
                    from encu.varcalopc
                    where varcalopc_ope = dbo.ope_actual() and varcalopc_varcal = new.varcal_varcal;  
                SELECT string_agg(varcal_varcal, ','), count(*)
                    INTO v_var_abiertas, v_cant_abiertas
                    FROM encu.varcal,  comun.extraer_identificadores(v_opciones) 
                    where varcal_ope=dbo.ope_actual() and varcal_varcal= extraer_identificadores and varcal_cerrado='N';
                if v_cant_abiertas>0 then
                    RAISE EXCEPTION 'ERROR hay % variable/s calculadas dependiente/s no cerrada/s:%', v_cant_abiertas, v_var_abiertas;
                end if;
            ELSE 
                --reabre un programador
                IF v_rol is distinct from 'programador' THEN
                   RAISE EXCEPTION 'ERROR Perfil del usuario % no autorizado para realizar la apertura de la variable  "%" ',v_usuario, new.varcal_varcal;
                END IF;
            END IF;
        ELSE
            IF new.varcal_cerrado THEN
                if not (new.varcal_activa is distinct from old.varcal_activa or new.varcal_grupo is distinct from old.varcal_grupo) then
                    RAISE EXCEPTION 'ERROR no se puede modificar, variable calculada "%" esta cerrada',  new.varcal_varcal;
                end if;  
            END IF;         
        END IF;
        RETURN NEW;
    WHEN 'varcalopc' THEN
        CASE TG_OP
            WHEN 'INSERT' THEN
                v_varcal=NEW.varcalopc_varcal;
                v_texto_op= 'agregar opcion';
                v_registro=NEW;
            WHEN 'UPDATE' THEN
                v_varcal=NEW.varcalopc_varcal;
                v_texto_op= 'modificar opcion';
                v_registro=NEW;
            ELSE
                v_varcal=OLD.varcalopc_varcal;
                v_texto_op= 'borrar opcion';
                v_registro=OLD;
        END CASE;        
        SELECT varcal_cerrado 
            INTO v_esta_cerrado 
            FROM encu.varcal
            WHERE varcal_ope=v_registro.varcalopc_ope AND varcal_varcal=v_varcal;
        IF v_esta_cerrado THEN    
            RAISE EXCEPTION 'ERROR no se puede %, variable calculada "%" esta cerrada', v_texto_op, v_registro.varcalopc_varcal;
        END IF; 
        RETURN v_registro;
    ELSE
        RAISE EXCEPTION 'ERROR Tabla "%" no considerada en "permitir_modificacion_variables_calculadas_trg"',TG_TABLE_NAME;
END CASE;    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

update varcal set varcal_orden = 2960 where varcal_varcal = 't_suboc3';
update varcal set varcal_orden = 2961 where varcal_varcal = 't_subocup';
update varcal set varcal_orden = 2962 where varcal_varcal = 't_sobreoc';
update varcal set varcal_orden = 1540 where varcal_varcal = 'edad_30';
update varcal set varcal_orden = 9610 where varcal_varcal = 'grupoc';
update varcal set varcal_orden = 4306 where varcal_varcal = 'ingtot_2';
update varcal set varcal_orden = 4310 where varcal_varcal = 'pctinolabiti';
update varcal set varcal_orden = 4310 where varcal_varcal = 'pctinolabitineto';
update varcal set varcal_orden = 4310 where varcal_varcal = 'pctilabnetoiti';
update varcal set varcal_orden = 4310 where varcal_varcal = 'pctilabiti';
update varcal set varcal_orden = 4312 where varcal_varcal = 'iop_ind_2';
update varcal set varcal_orden = 4310 where varcal_varcal = 'perjsolo';
update varcal set varcal_orden = 4320 where varcal_varcal = 'pctijtmciti';

update varcal set varcal_orden = 916 where varcal_varcal = 'coef_exp_p';
update varcal set varcal_orden = 916 where varcal_varcal = 'coef_exp_c';
update varcal set varcal_orden = 4321 where varcal_varcal = 'i_canastas';
update varcal set varcal_orden = 4321 where varcal_varcal = 'i_pobreza';
update varcal set varcal_orden = 4321 where varcal_varcal = 'i_estratos';
update varcal set varcal_orden = 4233 where varcal_varcal = 'jasnoch';
update varcal set varcal_orden = 4322 where varcal_varcal = 'perjsoloh';
update varcal set varcal_orden = 4322 where varcal_varcal = 'pctijitfh';
update varcal set varcal_orden = 4322 where varcal_varcal = 'pctijtmcitf';
update varcal set varcal_orden = 4322 where varcal_varcal = 'ipcf_neto_2';

update varcal set varcal_orden = 917 where varcal_varcal = 'cash_canasta';
update varcal set varcal_orden = 917 where varcal_varcal = 'ct_pobreza';
update varcal set varcal_orden = 4322 where varcal_varcal = 'i_pobreza_2';
update varcal set varcal_orden = 4239 where varcal_varcal = 'jasnoch';
update varcal set varcal_orden = 4322 where varcal_varcal = 'i_estratos';

update varcal set varcal_orden = 917 where varcal_varcal = 'cash_canastas';
update varcal set varcal_orden = 918 where varcal_varcal = 'cbsm_canastas';
update varcal set varcal_orden = 919 where varcal_varcal = 'ct_canastas';


ALTER TABLE varcal ENABLE TRIGGER  varcal_controlar_modificacion_varcalopc_trg;

-- para controlar orden
select x.*,  c.varcal_orden orden_vc, c.varcal_destino
from (
  select a.varcal_varcal, a.varcal_orden, comun.extraer_identificadores(string_agg(coalesce(varcalopc_expresion_condicion,'')||','||coalesce(varcalopc_expresion_valor,''),' ')) var_util
  from encu.varcal a join encu.varcalopc b on a.varcal_varcal=b.varcalopc_varcal and a.varcal_ope=b.varcalopc_ope     
  where a.varcal_activa=true and a.varcal_tipo='normal'
    and a.varcal_destino='mie'
    group by a.varcal_varcal,a.varcal_orden
  ) x left join encu.varcal c on x.var_util=c.varcal_varcal
where c.varcal_orden >=x.varcal_orden  
order by x.varcal_orden 

-- variables cruzadas
select  x.*,  1 orden_vc, case when var_for ='I1' OR var_for='S1' and var_mat='P' THEN 'mie' else 'hog' end varcal_destino,'for' varcal_tipo
from (
  select a.varcal_destino, a.varcal_varcal, a.varcal_orden, comun.extraer_identificadores(string_agg(coalesce(varcalopc_expresion_condicion,'')||','||coalesce(varcalopc_expresion_valor,''),' ')) var_util
  from encu.varcal a join encu.varcalopc b on a.varcal_varcal=b.varcalopc_varcal and a.varcal_ope=b.varcalopc_ope     
  where a.varcal_activa=true and a.varcal_tipo='normal'
   and a.varcal_destino='mie'
    group by a.varcal_destino,a.varcal_varcal,a.varcal_orden
  ) x  join encu.variables c on x.var_util=c.var_var
--where c.varcal_destino !=x.varcal_destino  
order by x.varcal_destino, x.varcal_orden 

-- ejemplo de consulta que setea variables de programa en clausula with
with v_destinos as (select 'mie'::text  varcaldes_ua)
 select * from  v_destinos, lateral
 (SELECT *
        FROM ua_planas
        WHERE uapla_ua = v_destinos.varcaldes_ua
        ORDER BY uapla_orden) x;      
