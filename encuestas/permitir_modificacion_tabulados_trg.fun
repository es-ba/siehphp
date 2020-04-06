##FUN
permitir_modificacion_tabulados_trg
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
Funcion trigger que determina si permite la modificacion del campo tab_cerrado en tabulados, de acuerdo al rol del usuario actual.
Si cerrado=true no se permite modificar otro campos del registro tampoco

##CUERPO
CREATE OR REPLACE FUNCTION encu.permitir_modificacion_tabulados_trg()
    RETURNS trigger AS
$BODY$
DECLARE
    v_usuario   text;
    v_rol       text;
    v_cant_abiertas integer;
    v_var_abiertas  TEXT;
BEGIN
    SELECT ses_usu, usu_rol  
        INTO v_usuario, v_rol
        FROM encu.tiempo_logico JOIN encu.sesiones ON tlg_ses=ses_ses JOIN encu.usuarios ON usu_usu=ses_usu
        WHERE tlg_tlg=new.tab_tlg;
    IF OLD.tab_cerrado IS DISTINCT FROM NEW.tab_cerrado THEN
        IF NEW.tab_cerrado=TRUE THEN
            --esta cerrando
            -- tiene que ser de procesamiento o programador
            -- condicion de cierre: variables calculadas cerradas
            IF coalesce(v_rol,'') not in ('programador', 'procesamiento') THEN
                RAISE EXCEPTION 'ERROR Perfil del usuario % no autorizado para realizar el cierre del tabulado "%" ',v_usuario, new.tab_tab ;
            END IF;
            SELECT string_agg(varcal_varcal, ','), count(*)
                INTO v_var_abiertas, v_cant_abiertas
                FROM encu.varcal, comun.extraer_identificadores( coalesce(new.tab_fila1,'') ||' '||coalesce(new.tab_fila2,'')||' '||coalesce(new.tab_columna,'')||' '||coalesce(new.tab_filtro,'')) 
                where varcal_ope=dbo.ope_actual() and varcal_varcal= extraer_identificadores and varcal_cerrado='N';
            if v_cant_abiertas>0 then
                RAISE EXCEPTION 'ERROR hay % variable/s dependiente/s no cerrada/s:%', v_cant_abiertas, v_var_abiertas;
            end if;
        ELSE
            --reabre un programador
            IF v_rol is distinct from 'programador' THEN
                RAISE EXCEPTION 'ERROR Perfil del usuario % no autorizado para realizar la apertura del tabulado  "%" ',v_usuario, new.tab_tab;
            END IF;
        END IF;
    ELSE
        IF new.tab_cerrado THEN    
            RAISE EXCEPTION 'ERROR no se puede modificar, tabulado "%" esta cerrada', new.tab_tab;
        END IF;         
    END IF;
    RETURN NEW; 
END;
$BODY$
  LANGUAGE plpgsql ;
ALTER FUNCTION encu.permitir_modificacion_tabulados_trg()
    OWNER TO tedede_php;

CREATE TRIGGER tabulados_controlar_modificacion_tabulados_trg
    BEFORE UPDATE
    ON encu.tabulados
    FOR EACH ROW
    EXECUTE PROCEDURE encu.permitir_modificacion_tabulados_trg();  