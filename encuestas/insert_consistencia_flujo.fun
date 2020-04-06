##FUN
insert_consistencia_flujo
##ESQ
encu
##PARA
revisar 
##DETALLE
NUEVA
##PROVISORIO
set search_path= encu, comun, dbo, public;
CREATE OR REPLACE FUNCTION encu.insert_consistencia_flujo(
                                       pcon_ope encu.consistencias.con_ope%type,
                                       pcon_con encu.consistencias.con_con%type, 
                                       pcon_precondicion encu.consistencias.con_precondicion%type,
                                       pcon_rel encu.consistencias.con_rel%type,
                                       pcon_postcondicion encu.consistencias.con_postcondicion%type,
                                       pcon_explicacion encu.consistencias.con_explicacion%type)
  RETURNS VOID AS
$BODY$
DECLARE
    xcon_activa             encu.consistencias.con_activa%type;
    xcon_tipo               encu.consistencias.con_tipo%type;
    xcon_falsos_positivos   encu.consistencias.con_falsos_positivos%type;  
    xcon_importancia        encu.consistencias.con_importancia%type;
    xcon_momento            encu.consistencias.con_momento%type;
    xcon_grupo              encu.consistencias.con_grupo%type;
    xcon_gravedad           encu.consistencias.con_gravedad%type;
BEGIN
   --xcon_expl_ok= false;
    --xcon_estado
   xcon_activa=true;   
   xcon_tipo='Auditoría';   
   xcon_falsos_positivos=false;
   xcon_importancia='ALTA';
   xcon_momento='Recepción';
   xcon_grupo='flujo'; 
   xcon_gravedad='Error';
    --con_descripcion
    --con_modulo
    --con_valida
    --con_junta
    --con_clausula_from
    --con_expresion_sql
    --con_error_compilacion
    --con_ultima_variable
    --con_orden
  INSERT INTO encu.consistencias( con_ope,con_con,con_precondicion,con_rel, con_postcondicion,
            con_activa, con_explicacion, con_tipo, con_falsos_positivos,
            con_importancia, con_momento, con_grupo, con_gravedad, con_tlg)
   values( pcon_ope, pcon_con, pcon_precondicion, pcon_rel, pcon_postcondicion,
           xcon_activa, pcon_explicacion, xcon_tipo, xcon_falsos_positivos,
           xcon_importancia, xcon_momento, xcon_grupo, xcon_gravedad, 1) ;                        

END;
$BODY$
LANGUAGE plpgsql;
/*otra*/
ALTER FUNCTION encu.insert_consistencia_flujo(pcon_ope encu.consistencias.con_ope%type,
                                       pcon_con encu.consistencias.con_con%type, 
                                       pcon_precondicion encu.consistencias.con_precondicion%type,
                                       pcon_rel encu.consistencias.con_rel%type,
                                       pcon_postcondicion encu.consistencias.con_postcondicion%type,
                                       pcon_explicacion encu.consistencias.con_explicacion%type)
  OWNER TO tedede_php;