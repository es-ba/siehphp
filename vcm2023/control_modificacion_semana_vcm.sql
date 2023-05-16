-- DROP FUNCTION IF EXISTS encu.controlar_modificacion_semana_vcm_trg();

CREATE OR REPLACE FUNCTION encu.controlar_modificacion_semana_vcm_trg()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    VOLATILE NOT LEAKPROOF
AS $BODY$
    DECLARE 
        v_rol  text;
    BEGIN
    if new.pla_semana is distinct from old.pla_semana then 
        select  usu_rol  into v_rol
            from encu.tiempo_logico join encu.sesiones on tlg_ses=ses_ses join encu.usuarios on usu_usu=ses_usu
            where tlg_tlg=new.pla_tlg;       
     if v_rol in ('programador','coor_campo', 'subcoor_campo') then    
            if  new.pla_estado in (null, 18,19,20)  then
                    new.pla_replica=new.pla_semana;
                    update encu.tem set tem_semana=new.pla_semana, tem_replica=new.pla_semana
                      where tem_enc=new.pla_enc ;
            else
                raise exception 'No se puede modificar la semana en encuestas que no cumplen: estado <=19';    
            end if;
        else
               raise exception 'Este rol no cuenta con permisos para modificar la semana: "%"',v_rol;
     end if;
    end if;   
    return new;
    END
  
$BODY$;

ALTER FUNCTION encu.controlar_modificacion_semana_vcm_trg()
    OWNER TO tedede_php;
    
CREATE TRIGGER controlar_modificacion_semana_vcm_trg
    BEFORE UPDATE 
    ON encu.plana_tem_
    FOR EACH ROW
    EXECUTE FUNCTION encu.controlar_modificacion_semana_vcm_trg();

