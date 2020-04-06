##FUN
permitir_modificacion_variables_calculadas_trg
##ESQ
encu
##PARA
produccion
##PUBLICA
no
##PAR

##TIPO_DEVUELTO
trigger
##TIPO_FUNCION
plpgsql
##DESCRIPCION
Funcion trigger que determina si permite la modificacion del campo varcal_cerrado,varcalopc_cerrado en varcal y varcalopc respectivamente, de acuerdo al rol del usuario actual
. Si cerrado=true solo se permite modificar activa y grupo en varcal. 



##CUERPO

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
                if not (new.varcal_activa is distinct from old_varcal_activa or new.varcal_grupo is distinct from old.varcal_grupo) then
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
  LANGUAGE plpgsql ;
ALTER FUNCTION encu.permitir_modificacion_variables_calculadas_trg()
    OWNER TO tedede_php;

CREATE TRIGGER varcalopc_controlar_modificacion_varcalopc_trg
    BEFORE UPDATE OR INSERT OR DELETE 
    ON encu.varcalopc
    FOR EACH ROW
    EXECUTE PROCEDURE encu.permitir_modificacion_variables_calculadas_trg();  
CREATE TRIGGER varcal_controlar_modificacion_varcalopc_trg
    BEFORE UPDATE 
    ON encu.varcal
    FOR EACH ROW
    EXECUTE PROCEDURE encu.permitir_modificacion_variables_calculadas_trg();  
    
    

