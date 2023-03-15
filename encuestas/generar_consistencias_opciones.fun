##FUN
generar_consistencias_opc  de auditoria
##ESQ
encu
##PARA
revisar 
##DETALLE
consistencia de auditoria sobre variables que tienen definido conjunto de opciones
NUEVA
##PROVISORIO
set search_path= encu, comun, dbo, public;

CREATE OR REPLACE FUNCTION encu.generar_consistencias_audi_opc(poperativo TEXT)
  RETURNS void AS
$BODY$
DECLARE
    xcon_activa             encu.consistencias.con_activa%type;
    xcon_tipo               encu.consistencias.con_tipo%type;
    xcon_falsos_positivos   encu.consistencias.con_falsos_positivos%type;  
    xcon_importancia        encu.consistencias.con_importancia%type;
    xcon_momento            encu.consistencias.con_momento%type;
    xcon_grupo              encu.consistencias.con_grupo%type;
    xcon_gravedad           encu.consistencias.con_gravedad%type;
    xcon_rel                encu.consistencias.con_rel%type;
BEGIN  
    -- Borrar las automaticas
    DELETE FROM encu.inconsistencias
        WHERE inc_con like 'audi_opc%';
    DELETE FROM encu.ano_con
        WHERE anocon_con like 'audi_opc%';
    DELETE FROM encu.con_var
        WHERE convar_con like 'audi_opc%';
    DELETE FROM encu.consistencias
           WHERE con_con like 'audi_opc%';
    xcon_activa=true;   
    xcon_tipo='Auditoría';   
    xcon_falsos_positivos=false;
    xcon_importancia='ALTA';
    xcon_momento='Recepción';
    xcon_grupo='opc'; 
    xcon_gravedad='Error';    
    xcon_rel='=>';
    
    INSERT INTO encu.consistencias( con_ope,con_con,con_precondicion,con_rel,
                con_postcondicion,
                con_activa, con_explicacion, con_tipo, con_falsos_positivos,
                con_importancia, con_momento, con_grupo, con_gravedad, con_tlg)
        SELECT  var_ope, 'audi_opc_'||var_var, 'informado('||var_var||') and ' ||
                'not nsnc('||var_var ||') and '||
                'not ignorado('||var_var ||') and '||
                var_var ||'<> -1 and '||var_var ||'<> -9 and '||var_var ||'<> -5' 
                as precondicion, xcon_rel,
                'dbo.var_opcion_valida($$'||var_conopc||'$$,'||var_var||')' as postcondicion,
                xcon_activa, 'Variable ' ||var_var ||' de opciones, con valor invalido' as con_explicacion, xcon_tipo, xcon_falsos_positivos, xcon_importancia, xcon_momento, xcon_grupo, xcon_gravedad, 1
            FROM encu.variables_ordenadas
            WHERE var_ope=poperativo and var_for is distinct from 'SUP' and var_conopc is not null and var_var not like 'entrea%' and var_tipovar <>'multiple_marcar'
            ORDER BY orden; 
            
        INSERT INTO encu.consistencias( con_ope,con_con,con_precondicion,con_rel,
                con_postcondicion,
                con_activa, con_explicacion, con_tipo, con_falsos_positivos,
                con_importancia, con_momento, con_grupo, con_gravedad, con_tlg)
        SELECT  var_ope, 'audi_opc_'||var_var, 'informado('||var_var||') and ' ||
                'not nsnc('||var_var ||') and '||
                'not ignorado('||var_var ||') and '||
                var_var ||'<> -1 and '||var_var ||'<> -9 and '||var_var ||'<> -5' 
                as precondicion, xcon_rel,
                var_var||'=1' as postcondicion,
                xcon_activa, 'Variable ' ||var_var ||' de tipo multiple_marcar, con valor invalido' as con_explicacion, xcon_tipo, xcon_falsos_positivos, xcon_importancia, xcon_momento, xcon_grupo, xcon_gravedad, 1
            FROM encu.variables_ordenadas
            WHERE var_ope=poperativo and var_for is distinct from 'SUP' and var_tipovar ='multiple_marcar'
            ORDER BY orden; 
        
END;
$BODY$
LANGUAGE plpgsql ;
/*otra*/
ALTER FUNCTION encu.generar_consistencias_audi_opc(TEXT)
  OWNER TO tedede_php; 

-- select  encu.generar_consistencias_audi_opc(dbo.ope_actual());   