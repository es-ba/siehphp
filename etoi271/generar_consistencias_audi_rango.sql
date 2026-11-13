CREATE OR REPLACE FUNCTION encu.generar_consistencias_audi_rango(poperativo TEXT)
  RETURNS void AS
$BODY$
DECLARE
    xcon_activa             encu.consistencias.con_activa%type;
    xcon_tipo               encu.consistencias.con_tipo%type;
    xcon_falsos_positivos   encu.consistencias.con_falsos_positivos%type;  
    xcon_importancia        encu.consistencias.con_importancia%type;
    xcon_momento            encu.consistencias.con_momento%type;
    xcon_grupo              encu.consistencias.con_grupo%type;
    xcon_rel                encu.consistencias.con_rel%type;
BEGIN  
    -- Borrar las automaticas
    DELETE FROM encu.inconsistencias
        WHERE inc_con like 'audi_rango%';
    DELETE FROM encu.ano_con
        WHERE anocon_con like 'audi_rango%';
    DELETE FROM encu.con_var
        WHERE convar_con like 'audi_rango%';
    DELETE FROM encu.consistencias
           WHERE con_con like 'audi_rango%';
    xcon_activa=true;   
    xcon_tipo='Auditoría';   
    xcon_falsos_positivos=false;
    xcon_importancia='ALTA';
    xcon_momento='Recepción';
    xcon_grupo='rango';  
    xcon_rel='=>';
    --advertencias
    INSERT INTO encu.consistencias( con_ope,con_con,
                con_precondicion,con_rel,
                con_postcondicion,con_activa,
                con_explicacion,
                con_tipo, con_falsos_positivos,
                con_importancia, con_momento, con_grupo, con_gravedad, con_tlg)
        SELECT  var_ope, 'audi_rango_adv_'||var_var,
                'informado('||var_var||') and not nsnc('||var_var||') and not ignorado('||var_var||')' as precondicion , xcon_rel,
                   coalesce (var_var||'>='||var_advertencia_inf,'') ||
                   case when var_advertencia_inf is not null and var_advertencia_sup is not null then ' and ' else '' end
                   ||coalesce (var_var||'<='||var_advertencia_sup,'')
                   as postcondicion, xcon_activa,
                'Fuera de rango ' ||var_var ||coalesce(' min:'||var_advertencia_inf,'')||coalesce(' max:'||var_advertencia_sup,'') as con_explicacion,
                xcon_tipo, xcon_falsos_positivos,
                xcon_importancia, xcon_momento, xcon_grupo, 'Advertencia', 1
            FROM encu.variables
            WHERE var_ope=poperativo
                    and var_for <>'TEM'
                    and var_conopc is null
                    and var_tipovar in ('anios','numeros','edad','anio','horas','meses','monetaria' )
                    and (var_advertencia_inf is not null or var_advertencia_sup is not null)            
            ORDER BY var_var; 
    --error        
    INSERT INTO encu.consistencias( con_ope,con_con,con_precondicion,con_rel,
                con_postcondicion, con_activa,
                con_explicacion,
                con_tipo, con_falsos_positivos,
                con_importancia, con_momento, con_grupo, con_gravedad, con_tlg)
        SELECT  var_ope, 'audi_rango_err_'||var_var, 'informado('||var_var||') and not nsnc('||var_var||') and not ignorado('||var_var||')' as precondicion , xcon_rel,
                   coalesce (var_var||'>='||var_minimo,'') ||
                   case when var_minimo is not null and var_maximo is not null then ' and ' else '' end
                   ||coalesce (var_var||'<='||var_maximo,'')
                   as postcondicion, xcon_activa,
                'Fuera de rango ' ||var_var||coalesce(' min:'||var_minimo,'')||coalesce(' max:'||var_maximo,'') as con_explicacion,
                xcon_tipo, xcon_falsos_positivos,
                xcon_importancia, xcon_momento, xcon_grupo, 'Error', 1
            FROM encu.variables
            WHERE var_ope=poperativo
                    and var_for <>'TEM'
                    and var_conopc is null
                    and var_tipovar in ('anios','numeros','edad','anio','horas','meses','monetaria' )
                    and (var_minimo is not null or var_maximo is not null)            
            ORDER BY var_var;             
END;
$BODY$
LANGUAGE plpgsql ;
ALTER FUNCTION encu.generar_consistencias_audi_rango(TEXT)
  OWNER TO tedede_php;    