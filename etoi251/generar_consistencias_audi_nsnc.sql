--UTF8: Sí
CREATE OR REPLACE FUNCTION encu.generar_consistencias_audi_nsnc(poperativo TEXT)
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
        WHERE inc_con like 'audi_nsnc%';
    DELETE FROM encu.ano_con
        WHERE anocon_con like 'audi_nsnc%';
    DELETE FROM encu.con_var
        WHERE convar_con like 'audi_nsnc%';
    DELETE FROM encu.consistencias
           WHERE con_con like 'audi_nsnc%';
    xcon_activa=true;   
    xcon_tipo='Auditoría';   
    xcon_falsos_positivos=false;
    xcon_importancia='ALTA';
    xcon_momento='Recepción';
    xcon_grupo='nsnc'; 
    xcon_gravedad='Error';    
    xcon_rel='=>';
    
    INSERT INTO encu.consistencias( con_ope,con_con,con_precondicion,con_rel,
                con_postcondicion,
                con_activa, con_explicacion, con_tipo, con_falsos_positivos,
                con_importancia, con_momento, con_grupo, con_gravedad, con_tlg)
        SELECT  var_ope, 'audi_nsnc_'||var_var, 'informado('||var_var||')' as precondicion, xcon_rel,
                case when var_tipovar in ('anios','numeros','marcar_nulidad','edad','anio'
                                        ,'horas','meses','si_no','opciones','monetaria', 'si_no_nosabe3' ) then
                         var_var ||'<> -1 and '||var_var ||'<> -9 and '||var_var ||'<> -5' 
                     else  --'observaciones','telefono','texto_especificar','fecha_corta','texto','fecha','texto_libre'
                         'not es_cadena_vacia('||var_var ||') and '||
                         'not nsnc('||var_var ||') and '||
                         'not ignorado('||var_var ||') and '||
                         var_var ||'<> a_texto(-1) and '||var_var ||'<> a_texto(-9) and '||var_var ||'<> a_texto(-5)' 
                end as postcondicion,
                xcon_activa, 'Variable ' ||var_var ||' tiene NS/NC' as con_explicacion, xcon_tipo, xcon_falsos_positivos,
                xcon_importancia, xcon_momento, xcon_grupo, xcon_gravedad, 1
            FROM encu.variables_ordenadas
            WHERE var_ope=poperativo
            ORDER BY orden; 
END;
$BODY$
LANGUAGE plpgsql ;
ALTER FUNCTION encu.generar_consistencias_audi_nsnc(TEXT)
  OWNER TO tedede_php;    